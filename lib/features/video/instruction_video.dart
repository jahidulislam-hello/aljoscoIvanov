import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class RecipeInstructionsScreen extends StatefulWidget {
  const RecipeInstructionsScreen({super.key});

  @override
  State<RecipeInstructionsScreen> createState() => _RecipeInstructionsScreenState();
}

class _RecipeInstructionsScreenState extends State<RecipeInstructionsScreen> {
  int selectedStep = 1;
  final List<int> steps = [1, 2, 3, 6];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Instructions',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.replay, color: Colors.black, size: 24.sp),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Video Player Section
              _buildVideoPlayer(),

              SizedBox(height: 20.h),

              // Instruction Text
              _buildInstructionText(),

              SizedBox(height: 24.h),

              // Step Navigation
              _buildStepNavigation(),
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
            // Video Thumbnail
            Image.network(
              'https://via.placeholder.com/400x240',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),

            // Play Button Overlay
            Center(
              child: Container(
                width: 64.w,
                height: 64.w,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.black,
                  size: 36.sp,
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
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
                padding: EdgeInsets.all(12.w),
                child: Column(
                  children: [
                    // Progress Bar
                    Container(
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: 0.33,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444),
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 12.h),

                    // Control Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildControlButton(Icons.replay_10, Colors.white),
                        Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.black,
                            size: 24.sp,
                          ),
                        ),
                        _buildControlButton(Icons.forward_10, Colors.white),
                        _buildControlButton(Icons.fullscreen, Colors.white),
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

  Widget _buildControlButton(IconData icon, Color color) {
    return IconButton(
      icon: Icon(icon, color: color, size: 20.sp),
      onPressed: () {},
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
              '1',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        SizedBox(width: 12.w),

        // Instruction Text
        Expanded(
          child: Text(
            'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
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
        _buildNavButton(Icons.chevron_left, false),

        SizedBox(width: 8.w),

        // Step Buttons
        ...steps.map((step) => Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: step != steps.last ? 8.w : 0),
            child: _buildStepButton(step),
          ),
        )).toList(),

        SizedBox(width: 8.w),

        // Next Button
        _buildNavButton(Icons.chevron_right, true),
      ],
    );
  }

  Widget _buildNavButton(IconData icon, bool isNext) {
    return Container(
      width: 40.w,
      height: 40.h,
      decoration: BoxDecoration(
        color: isNext ? Colors.black : const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(
        icon,
        color: isNext ? Colors.white : const Color(0xFF6B7280),
        size: 20.sp,
      ),
    );
  }

  Widget _buildStepButton(int step) {
    final bool isSelected = selectedStep == step;

    return GestureDetector(
      onTap: () => setState(() => selectedStep = step),
      child: Container(
        height: 40.h,
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          border: isSelected ? null : Border.all(
            color: const Color(0xFFE5E7EB),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: Text(
            step.toString().padLeft(2, '0'),
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