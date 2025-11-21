import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
  final PageController _pageController = PageController(
    viewportFraction: 0.9, // Shows part of adjacent images
  );
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Image PageView
        SizedBox(
          height: 250.h,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w), // Space between images
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r), // Optional: rounded corners
                    image: DecorationImage(
                      image: AssetImage(widget.images[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),


        // Thumbnail Navigation
        Positioned(
          bottom: 16.h,
          left: 16.w,
          child: Row(
            children: List.generate(
              widget.images.length > 3 ? 3 : widget.images.length,
                  (index) => GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    index,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(right: 8.w),
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _currentPage == index
                          ? Colors.white
                          : Colors.transparent,
                      width: 2.w,
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                    image: DecorationImage(
                      image: AssetImage(widget.images[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}