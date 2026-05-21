import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/appbar/custom_appbar.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/features/new/popup/popup_screen/timer_popup.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

/// Model class for Skill data
class SkillData {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String coverUrl;

  SkillData({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.coverUrl,
  });

  factory SkillData.fromJson(Map<String, dynamic> json) {
    return SkillData(
      id: json['_id'] ?? '',
      title: json['skillTitle'] ?? json['title'] ?? '',
      description: json['description'] ?? '',
      videoUrl: json['video'] ?? '',
      coverUrl: json['cover'] ?? '',
    );
  }
}

class RecipeInstructionsScreen extends StatefulWidget {
  final List<SkillData> skills;

  const RecipeInstructionsScreen({super.key, required this.skills});

  @override
  State<RecipeInstructionsScreen> createState() =>
      _RecipeInstructionsScreenState();
}

class _RecipeInstructionsScreenState extends State<RecipeInstructionsScreen> {
  int selectedStep = 0;
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _isPlaying = false;
  bool _isMuted = false;
  double _currentPosition = 0;
  double _totalDuration = 1;

  @override
  void initState() {
    super.initState();
    if (widget.skills.isNotEmpty) {
      _initializeVideo(widget.skills[0].videoUrl);
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _initializeVideo(String videoUrl) async {
    if (videoUrl.isEmpty) return;

    _videoController?.dispose();
    setState(() {
      _isVideoInitialized = false;
      _isPlaying = false;
    });

    try {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      await _videoController!.initialize();

      _videoController!.addListener(() {
        if (mounted) {
          setState(() {
            _currentPosition = _videoController!.value.position.inMilliseconds
                .toDouble();
            _totalDuration = _videoController!.value.duration.inMilliseconds
                .toDouble();
            _isPlaying = _videoController!.value.isPlaying;
          });
        }
      });

      setState(() {
        _isVideoInitialized = true;
      });
    } catch (e) {
      print("Error initializing video: $e");
    }
  }

  void _togglePlayPause() {
    if (_videoController == null) return;

    setState(() {
      if (_isPlaying) {
        _videoController!.pause();
      } else {
        _videoController!.play();
      }
      _isPlaying = !_isPlaying;
    });
  }

  void _toggleMute() {
    if (_videoController == null) return;

    setState(() {
      _isMuted = !_isMuted;
      _videoController!.setVolume(_isMuted ? 0 : 1);
    });
  }

  void _seekBackward() {
    if (_videoController == null) return;

    final currentPosition = _videoController!.value.position;
    final newPosition = currentPosition - const Duration(seconds: 10);
    _videoController!.seekTo(
      newPosition > Duration.zero ? newPosition : Duration.zero,
    );
  }

  void _seekForward() {
    if (_videoController == null) return;

    final currentPosition = _videoController!.value.position;
    final duration = _videoController!.value.duration;
    final newPosition = currentPosition + const Duration(seconds: 10);
    _videoController!.seekTo(newPosition < duration ? newPosition : duration);
  }

  void _enterFullScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _FullScreenVideoPlayer(
          videoController: _videoController!,
          onTogglePlayPause: _togglePlayPause,
          onToggleMute: _toggleMute,
          onSeekBackward: _seekBackward,
          onSeekForward: _seekForward,
          isPlaying: _isPlaying,
          isMuted: _isMuted,
        ),
      ),
    );
  }

  void _onStepSelected(int index) {
    if (index >= 0 && index < widget.skills.length) {
      setState(() {
        selectedStep = index;
      });
      _initializeVideo(widget.skills[index].videoUrl);
    }
  }

  SkillData get currentSkill => widget.skills.isNotEmpty
      ? widget.skills[selectedStep]
      : SkillData(
          id: '',
          title: '',
          description: '',
          videoUrl: '',
          coverUrl: '',
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8EAE6),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: CustomAppBar(
            title: 'Instructions',
            titleAlignment: AppBarTitleAlignment.center,
            showBackButton: true,
            actionButtons: [
              AppBarAction(
                imagePath: 'assets/icons/timer.png',
                onPressed: () {
                  Get.to(() => const TimerScreen());
                },
              ),
            ],
          ),
        ),
      ),
      body: widget.skills.isEmpty
          ? Center(
              child: Text(
                'No skills available',
                style: TextStyle(fontSize: 16.sp, color: Colors.grey),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Video Player Section
                    _buildVideoPlayer(),

                    SizedBox(height: 20.h),

                    // Skill Title
                    if (currentSkill.title.isNotEmpty) ...[
                      Text(
                        currentSkill.title,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 12.h),
                    ],

                    // Instruction Text / Description
                    _buildInstructionText(),

                    SizedBox(height: 24.h),

                    // Step Navigation
                    if (widget.skills.length > 1) _buildStepNavigation(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildVideoPlayer() {
    return Container(
      width: double.infinity,
      height: 240.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: Colors.black,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          children: [
            // Video or Cover Image
            if (_isVideoInitialized && _videoController != null)
              Center(
                child: AspectRatio(
                  aspectRatio: _videoController!.value.aspectRatio,
                  child: VideoPlayer(_videoController!),
                ),
              )
            else
              Container(
                color: Colors.grey[800],
                child: Center(
                  child: _isVideoInitialized
                      ? const SizedBox()
                      : CircularProgressIndicator(color: AppColors.buttonColor),
                ),
              ),

            // Play Button Overlay (shown when paused)
            if (!_isPlaying)
              Center(
                child: GestureDetector(
                  onTap: _togglePlayPause,
                  child: Container(
                    width: 64.w,
                    height: 64.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.black,
                      size: 36.sp,
                    ),
                  ),
                ),
              ),

            // Bottom Controls
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16.r),
                    bottomRight: Radius.circular(16.r),
                  ),
                ),
                padding: EdgeInsets.all(12.w),
                child: Column(
                  children: [
                    // Progress Bar
                    SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 4.h,
                        thumbShape: RoundSliderThumbShape(
                          enabledThumbRadius: 6.r,
                        ),
                        overlayShape: RoundSliderOverlayShape(
                          overlayRadius: 12.r,
                        ),
                        activeTrackColor: AppColors.buttonColor,
                        inactiveTrackColor: Colors.white.withOpacity(0.3),
                        thumbColor: AppColors.buttonColor,
                      ),
                      child: Slider(
                        value: _currentPosition.clamp(0, _totalDuration),
                        max: _totalDuration > 0 ? _totalDuration : 1,
                        onChanged: (value) {
                          _videoController?.seekTo(
                            Duration(milliseconds: value.toInt()),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 8.h),

                    // Control Buttons Row
                    Row(
                      children: [
                        // Volume Button (Left)
                        _buildControlButton(
                          _isMuted ? Icons.volume_off : Icons.volume_up,
                          Colors.white,
                          _toggleMute,
                        ),

                        const Spacer(),

                        // Replay 10 sec (Left of center)
                        _buildControlButton(
                          Icons.replay_10,
                          Colors.white,
                          _seekBackward,
                        ),

                        SizedBox(width: 16.w),

                        // Play/Pause Button (Center)
                        GestureDetector(
                          onTap: _togglePlayPause,
                          child: Container(
                            width: 40.w,
                            height: 40.w,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.black,
                              size: 24.sp,
                            ),
                          ),
                        ),

                        SizedBox(width: 16.w),

                        // Forward 10 sec (Right of center)
                        _buildControlButton(
                          Icons.forward_10,
                          Colors.white,
                          _seekForward,
                        ),

                        const Spacer(),

                        // Fullscreen Button (Right)
                        _buildControlButton(
                          Icons.fullscreen,
                          Colors.white,
                          _isVideoInitialized ? _enterFullScreen : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton(
    IconData icon,
    Color color,
    VoidCallback? onPressed,
  ) {
    return IconButton(
      icon: Icon(icon, color: color, size: 24.sp),
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }

  Widget _buildInstructionText() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Step Number Circle
        Container(
          width: 32.w,
          height: 32.w,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${selectedStep + 1}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        SizedBox(width: 12.w),

        // Description Text
        Expanded(
          child: Text(
            currentSkill.description.isNotEmpty
                ? currentSkill.description
                : 'No description available',
            style: TextStyle(
              color: const Color(0xFF6B7280),
              fontSize: 14.sp,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepNavigation() {
    return Row(
      children: [
        // Previous Button
        GestureDetector(
          onTap: selectedStep > 0
              ? () => _onStepSelected(selectedStep - 1)
              : null,
          child: _buildNavButton(Icons.chevron_left, false, selectedStep > 0),
        ),

        SizedBox(width: 8.w),

        // Step Buttons
        ...List.generate(widget.skills.length, (index) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index != widget.skills.length - 1 ? 8.w : 0,
              ),
              child: _buildStepButton(index),
            ),
          );
        }),

        SizedBox(width: 8.w),

        // Next Button
        GestureDetector(
          onTap: selectedStep < widget.skills.length - 1
              ? () => _onStepSelected(selectedStep + 1)
              : null,
          child: _buildNavButton(
            Icons.chevron_right,
            true,
            selectedStep < widget.skills.length - 1,
          ),
        ),
      ],
    );
  }

  Widget _buildNavButton(IconData icon, bool isNext, bool isEnabled) {
    return Container(
      width: 40.w,
      height: 40.h,
      decoration: BoxDecoration(
        color: isNext && isEnabled ? Colors.black : const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(
        icon,
        color: isNext && isEnabled ? Colors.white : const Color(0xFF6B7280),
        size: 20.sp,
      ),
    );
  }

  Widget _buildStepButton(int index) {
    final bool isSelected = selectedStep == index;

    return GestureDetector(
      onTap: () => _onStepSelected(index),
      child: Container(
        height: 40.h,
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          border: isSelected
              ? null
              : Border.all(color: const Color(0xFFE5E7EB), width: 2),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: Text(
            (index + 1).toString().padLeft(2, '0'),
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF374151),
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

/// Full Screen Video Player
class _FullScreenVideoPlayer extends StatefulWidget {
  final VideoPlayerController videoController;
  final VoidCallback onTogglePlayPause;
  final VoidCallback onToggleMute;
  final VoidCallback onSeekBackward;
  final VoidCallback onSeekForward;
  final bool isPlaying;
  final bool isMuted;

  const _FullScreenVideoPlayer({
    required this.videoController,
    required this.onTogglePlayPause,
    required this.onToggleMute,
    required this.onSeekBackward,
    required this.onSeekForward,
    required this.isPlaying,
    required this.isMuted,
  });

  @override
  State<_FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<_FullScreenVideoPlayer> {
  late bool _isPlaying;
  late bool _isMuted;

  @override
  void initState() {
    super.initState();
    _isPlaying = widget.isPlaying;
    _isMuted = widget.isMuted;
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

  void _togglePlayPause() {
    widget.onTogglePlayPause();
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _toggleMute() {
    widget.onToggleMute();
    setState(() {
      _isMuted = !_isMuted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Video Player
          Center(
            child: AspectRatio(
              aspectRatio: widget.videoController.value.aspectRatio,
              child: VideoPlayer(widget.videoController),
            ),
          ),

          // Center play button (shown when paused)
          if (!_isPlaying)
            GestureDetector(
              onTap: _togglePlayPause,
              child: CircleAvatar(
                radius: 40.r,
                backgroundColor: Colors.white.withOpacity(0.8),
                child: Icon(Icons.play_arrow, color: Colors.black, size: 48.sp),
              ),
            ),

          // Bottom Controls
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
                  colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Progress bar
                  VideoProgressIndicator(
                    widget.videoController,
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
                      // Volume button (left)
                      IconButton(
                        icon: Icon(
                          _isMuted ? Icons.volume_off : Icons.volume_up,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                        onPressed: _toggleMute,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),

                      const Spacer(),

                      // 10 sec back button
                      IconButton(
                        icon: Icon(
                          Icons.replay_10,
                          color: Colors.white,
                          size: 32.sp,
                        ),
                        onPressed: widget.onSeekBackward,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      SizedBox(width: 24.w),

                      // Play/Pause button
                      IconButton(
                        icon: Icon(
                          _isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                          color: Colors.white,
                          size: 40.sp,
                        ),
                        onPressed: _togglePlayPause,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      SizedBox(width: 24.w),

                      // 10 sec forward button
                      IconButton(
                        icon: Icon(
                          Icons.forward_10,
                          color: Colors.white,
                          size: 32.sp,
                        ),
                        onPressed: widget.onSeekForward,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),

                      const Spacer(),

                      // Exit fullscreen button (right)
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
