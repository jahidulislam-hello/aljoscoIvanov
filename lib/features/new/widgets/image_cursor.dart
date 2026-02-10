import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/themes/app_colors.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> images;
  final Duration autoSwipeDuration;

  const ImageCarousel({
    Key? key,
    required this.images,
    this.autoSwipeDuration = const Duration(seconds: 4),
  }) : super(key: key);

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int _selectedIndex = 0;
  Timer? _autoSwipeTimer;

  @override
  void initState() {
    super.initState();
    _startAutoSwipe();
  }

  @override
  void dispose() {
    _autoSwipeTimer?.cancel();
    super.dispose();
  }

  void _startAutoSwipe() {
    if (widget.images.length > 1) {
      _autoSwipeTimer = Timer.periodic(widget.autoSwipeDuration, (timer) {
        if (mounted) {
          setState(() {
            _selectedIndex = (_selectedIndex + 1) % widget.images.length;
          });
        }
      });
    }
  }

  void _resetAutoSwipeTimer() {
    _autoSwipeTimer?.cancel();
    _startAutoSwipe();
  }

  /// Helper method to check if image is a network URL
  bool _isNetworkImage(String imagePath) {
    return imagePath.startsWith('http://') || imagePath.startsWith('https://');
  }

  /// Build image widget based on whether it's a network or asset image
  Widget _buildImage(String imagePath, {required double width, required double height, BoxFit? fit}) {
    if (_isNetworkImage(imagePath)) {
      return Image.network(
        imagePath,
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey[300],
            child: Center(
              child: Icon(
                Icons.broken_image,
                size: 50.sp,
                color: Colors.grey[600],
              ),
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            color: Colors.grey[200],
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.buttonColor,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
      );
    } else {
      return Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey[300],
            child: Center(
              child: Icon(
                Icons.broken_image,
                size: 50.sp,
                color: Colors.grey[600],
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container(
        height: 244.h,
        color: Colors.grey[300],
        child: Center(
          child: Icon(Icons.image_not_supported, size: 50.sp),
        ),
      );
    }

    // Ensure selected index is valid
    if (_selectedIndex >= widget.images.length) {
      _selectedIndex = 0;
    }

    // Get currently selected image for main display
    final mainImage = widget.images[_selectedIndex];

    return Column(
      children: [
        // MAIN COVER IMAGE (Selected image)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildImage(
                mainImage,
                width: double.infinity,
                height: 244.h,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        // THUMBNAIL ROW (All images)
        if (widget.images.length > 1) ...[
          SizedBox(height: 12.h),
          SizedBox(
            height: 60.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.images.length,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemBuilder: (context, index) {
                final isSelected = index == _selectedIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                    _resetAutoSwipeTimer();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.only(right: 10.w),
                    width: 75.w,
                    height: 51.h,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? AppColors.buttonColor : Colors.grey[400]!,
                        width: isSelected ? 2.w : 1.w,
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7.r),
                      child: Opacity(
                        opacity: isSelected ? 1.0 : 0.7,
                        child: _buildImage(
                          widget.images[index],
                          width: 75.w,
                          height: 51.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
