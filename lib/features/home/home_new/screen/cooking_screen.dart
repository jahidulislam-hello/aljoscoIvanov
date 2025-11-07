import 'package:flutter/material.dart';
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
            _buildSkillTitle(),
            SizedBox(height: 12.h),
            _buildVideoPlayer(),
            SizedBox(height: 16.h),
            _buildSkillDescription(),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Text(
        controller.skill.title,
        style: AppTextStyles.body.copyWith(fontSize: 16.sp),
      ),
    );
  }

  Widget _buildSkillDescription() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Text(
        controller.skill.description,
        style: AppTextStyles.bioText,
      ),
    );
  }

  Widget _buildVideoPlayer() {
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
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: AspectRatio(
                  aspectRatio: c.videoController.value.aspectRatio,
                  child: VideoPlayer(c.videoController),
                ),
              ),

              // Center play button
              Obx(() => !c.isPlaying.value
                  ? GestureDetector(
                onTap: c.togglePlay,
                child: CircleAvatar(
                  radius: 30.r,
                  backgroundColor: Colors.white.withOpacity(0.8),
                  child: Icon(Icons.play_arrow,
                      color: AppColors.background, size: 36.sp),
                ),
              )
                  : const SizedBox.shrink()),

              // Bottom controls
              Positioned(
                bottom: 8.h,
                left: 8.w,
                right: 8.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(Icons.replay_10,
                          color: Colors.white, size: 28.sp),
                      onPressed: c.seekBackward,
                    ),
                    Obx(() => IconButton(
                      icon: Icon(
                        c.isPlaying.value
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                        color: Colors.white,
                        size: 38.sp,
                      ),
                      onPressed: c.togglePlay,
                    )),
                    IconButton(
                      icon: Icon(Icons.forward_10,
                          color: Colors.white, size: 28.sp),
                      onPressed: c.seekForward,
                    ),
                  ],
                ),
              ),

              // Progress bar
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: VideoProgressIndicator(
                  c.videoController,
                  allowScrubbing: true,
                  colors: VideoProgressColors(
                    playedColor: AppColors.buttonColor,
                    backgroundColor: Colors.grey.shade400,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
