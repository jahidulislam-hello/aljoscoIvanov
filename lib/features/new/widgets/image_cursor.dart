import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/themes/app_colors.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> images;

  const ImageCarousel({
    Key? key,
    required this.images,
  }) : super(key: key);

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
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

    // Get cover image (first image) and other images
    final coverImage = widget.images.first;
    final otherImages = widget.images.length > 1
        ? widget.images.sublist(1)
        : <String>[];

    return Column(
      children: [
        // MAIN COVER IMAGE (First image only)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: _buildImage(
              coverImage,
              width: double.infinity,
              height: 244.h,
              fit: BoxFit.cover,
            ),
          ),
        ),

        // THUMBNAIL ROW (Other images if available)
        if (otherImages.isNotEmpty) ...[
          SizedBox(height: 12.h),
          SizedBox(
            height: 60.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: otherImages.length,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Optional: You can add functionality to view full image
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 10.w),
                    width: 75.w,
                    height: 51.h,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[400]!,
                        width: 1.w,
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: _buildImage(
                        otherImages[index],
                        width: 75.w,
                        height: 51.h,
                        fit: BoxFit.cover,
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
