import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/features/meal_planner/newly_meal_planner/model.dart';



typedef RecipeCallback = void Function(NewMealModel recipe);

class NewMealSection extends StatelessWidget {
  final String title;
  final bool isExpanded;
  final VoidCallback onEyeTap;
  final VoidCallback onAdd;
  final RecipeCallback onEdit;
  final RecipeCallback onMessage;
  final RecipeCallback onRemove;
  final List<NewMealModel> recipes;

  const NewMealSection({
    Key? key,
    required this.title,
    required this.isExpanded,
    required this.onEyeTap,
    required this.onAdd,
    required this.onEdit,
    required this.onMessage,
    required this.onRemove,
    this.recipes = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // outer container
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 14.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          // header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
              InkWell(
                onTap: onEyeTap,
                child: Icon(isExpanded ? Icons.visibility : Icons.visibility_off, size: 22.sp),
              )
            ],
          ),

          // animated expand/collapse
          AnimatedCrossFade(
            crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: Column(
                children: [
                  // list of recipes in this meal (if empty show Add button area)
                  ...recipes.map((r) => _recipeTile(context, r)).toList(),

                  // Add button (bottom)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: onAdd,
                      child: Container(
                        margin: EdgeInsets.only(top: 10.h),
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8.r)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, size: 18.sp),
                            SizedBox(width: 8.w),
                            Text("Add Recipe", style: TextStyle(fontSize: 13.sp)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _recipeTile(BuildContext context, NewMealModel r) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Image.asset(r.imageAsset, width: 60.h, height: 60.h, fit: BoxFit.cover),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(r.title, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
              SizedBox(height: 4.h),
              Text(r.subtitle, style: TextStyle(fontSize: 11.sp, color: Colors.grey)),
            ]),
          ),
          Row(children: [
            // message
            GestureDetector(onTap: () => onMessage(r), child: _iconBox(Icons.message_outlined)),
            SizedBox(width: 8.w),
            // edit
            GestureDetector(onTap: () => onEdit(r), child: _iconBox(Icons.edit)),
            SizedBox(width: 8.w),
            // remove
            GestureDetector(onTap: () => onRemove(r), child: _iconBox(Icons.delete_outline)),
          ]),
        ],
      ),
    );
  }

  Widget _iconBox(IconData icon) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), border: Border.all(color: Colors.grey.shade300)),
      child: Icon(icon, size: 18.sp),
    );
  }
}
