import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/text_styles.dart';
import 'package:freshbite/features/home/home_new/controller/cooking_controller.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class CookingSkillsScreen extends StatelessWidget {
  CookingSkillsScreen({super.key});
  final controller = Get.put(CookingSkillsController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.buttonColor),
          onPressed: Get.back,
        ),
        title: Text('Cooking Skills', style: AppTextStyles.H6_Regular),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVideoPlayer(context),
            SizedBox(height: 16.h),
            _buildSkillTextBox(),
            SizedBox(height: 12.h),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillTextBox() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.buttonColor.withOpacity(0.5),
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.skill.title,
              style: AppTextStyles.body.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              controller.skill.description,
              style: AppTextStyles.bioText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          Container(
            width: 56.w,
            height: 36.h,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.buttonColor),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.buttonColor,
                size: 18.sp,
              ),
              onPressed: () {
                // Handle back navigation
              },
            ),
          ),
          // Next button
          Container(
            width: 56.w,
            height: 36.h,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.buttonColor),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.arrow_forward_ios,
                color: AppColors.buttonColor,
                size: 18.sp,
              ),
              onPressed: () {
                // Handle next navigation
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer(BuildContext context) {
    return GetBuilder<CookingSkillsController>(
      builder: (c) {
        if (!c.videoController.value.isInitialized) {
          return Container(
            height: 240.h,
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: AppColors.defaultbackground,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          height: 240.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: Colors.black,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Video player
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: AspectRatio(
                  aspectRatio: c.videoController.value.aspectRatio,
                  child: VideoPlayer(c.videoController),
                ),
              ),

              // Center play button (shown when paused)
              Obx(() => !c.isPlaying.value
                  ? GestureDetector(
                      onTap: c.togglePlay,
                      child: CircleAvatar(
                        radius: 30.r,
                        backgroundColor: Colors.white.withOpacity(0.8),
                        child: Icon(
                          Icons.play_arrow,
                          color: AppColors.background,
                          size: 36.sp,
                        ),
                      ),
                    )
                  : const SizedBox.shrink()),

              // Bottom controls with progress bar
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12.r),
                      bottomRight: Radius.circular(12.r),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Progress bar (above controls)
                      VideoProgressIndicator(
                        c.videoController,
                        allowScrubbing: true,
                        colors: VideoProgressColors(
                          playedColor: AppColors.buttonColor,
                          backgroundColor: Colors.grey.shade400,
                        ),
                      ),

                      // Space between progress bar and controls
                      SizedBox(height: 8.h),

                      // Control buttons row
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Row(
                          children: [
                            // Volume button (left side)
                            Obx(() => IconButton(
                                  icon: Icon(
                                    c.isMuted.value
                                        ? Icons.volume_off
                                        : Icons.volume_up,
                                    color: Colors.white,
                                    size: 24.sp,
                                  ),
                                  onPressed: c.toggleMute,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                )),

                            const Spacer(),

                            // 10 sec back button
                            IconButton(
                              icon: Icon(
                                Icons.replay_10,
                                color: Colors.white,
                                size: 24.sp,
                              ),
                              onPressed: c.seekBackward,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            SizedBox(width: 16.w),

                            // Play/Pause button
                            Obx(() => IconButton(
                                  icon: Icon(
                                    c.isPlaying.value
                                        ? Icons.pause_circle_filled
                                        : Icons.play_circle_fill,
                                    color: Colors.white,
                                    size: 24.sp,
                                  ),
                                  onPressed: c.togglePlay,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                )),
                            SizedBox(width: 16.w),

                            // 10 sec forward button
                            IconButton(
                              icon: Icon(
                                Icons.forward_10,
                                color: Colors.white,
                                size: 24.sp,
                              ),
                              onPressed: c.seekForward,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),

                            const Spacer(),

                            // Fullscreen button (right side)
                            IconButton(
                              icon: Icon(
                                Icons.fullscreen,
                                color: Colors.white,
                                size: 24.sp,
                              ),
                              onPressed: () => _enterFullScreen(context, c),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _enterFullScreen(BuildContext context, CookingSkillsController c) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _FullScreenVideoPlayer(controller: c),
      ),
    );
  }
}

class _FullScreenVideoPlayer extends StatefulWidget {
  final CookingSkillsController controller;

  const _FullScreenVideoPlayer({required this.controller});

  @override
  State<_FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<_FullScreenVideoPlayer> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Video player
          Center(
            child: AspectRatio(
              aspectRatio: c.videoController.value.aspectRatio,
              child: VideoPlayer(c.videoController),
            ),
          ),

          // Center play button (shown when paused)
          Obx(() => !c.isPlaying.value
              ? GestureDetector(
                  onTap: c.togglePlay,
                  child: CircleAvatar(
                    radius: 40.r,
                    backgroundColor: Colors.white.withOpacity(0.8),
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.black,
                      size: 48.sp,
                    ),
                  ),
                )
              : const SizedBox.shrink()),

          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Progress bar (above controls)
                  VideoProgressIndicator(
                    c.videoController,
                    allowScrubbing: true,
                    colors: VideoProgressColors(
                      playedColor: AppColors.buttonColor,
                      backgroundColor: Colors.grey.shade400,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  // Control buttons row
                  Row(
                    children: [
                      // Volume button
                      Obx(() => IconButton(
                            icon: Icon(
                              c.isMuted.value
                                  ? Icons.volume_off
                                  : Icons.volume_up,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                            onPressed: c.toggleMute,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          )),

                      const Spacer(),

                      // 10 sec back button
                      IconButton(
                        icon: Icon(
                          Icons.replay_10,
                          color: Colors.white,
                          size: 32.sp,
                        ),
                        onPressed: c.seekBackward,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      SizedBox(width: 24.w),

                      // Play/Pause button
                      Obx(() => IconButton(
                            icon: Icon(
                              c.isPlaying.value
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_fill,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                            onPressed: c.togglePlay,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          )),
                      SizedBox(width: 24.w),

                      // 10 sec forward button
                      IconButton(
                        icon: Icon(
                          Icons.forward_10,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                        onPressed: c.seekForward,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),

                      const Spacer(),

                      // Exit fullscreen button
                      IconButton(
                        icon: Icon(
                          Icons.fullscreen_exit,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
