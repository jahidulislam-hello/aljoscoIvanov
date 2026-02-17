import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/appbar/custom_appbar.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/core/widgets/custom_text_button.dart';
import 'package:freshbite/features/shopping_list/create_shopping/create_shopping_controller/create_shopping_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../create_shopping_model/create_shopping_model.dart';



class CreateShoppingScreen extends StatelessWidget {
  final bool isFromRecipe;
  final String? recipeName;
  final List<Map<String, dynamic>>? ingredients;

  const CreateShoppingScreen({
    super.key,
    this.isFromRecipe = false,
    this.recipeName,
    this.ingredients,
  });


  @override
  Widget build(BuildContext context) {
    // Create new controller
    final controller = Get.put(CreateShoppingController());

    // If from recipe, add ingredients
    if (isFromRecipe && recipeName != null && ingredients != null) {
      // Use Future.microtask to ensure controller is initialized
      Future.microtask(() {
        controller.addIngredientsFromRecipe(
          recipeName: recipeName!,
          ingredients: ingredients!,
        );
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      // Only AppBar is wrapped with SafeArea inside CustomAppBar if needed
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: CustomAppBar(
            title: 'Create Shopping List',
            titleAlignment: AppBarTitleAlignment.center,
            showBackButton: true,
            actionButtons: [
              AppBarAction(imagePath: 'assets/icons/charm_menu.png', onPressed: () {}),
            ],
          ),
        ),
      ),


      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // /// Cover Image Section - Commented out
            // _buildCoverImageSection(controller),
            // SizedBox(height: 16.h),

            /// Title (Editable)
            Text("Title", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 6.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: AppColors.pureWhite,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  /// Title TextField
                  Expanded(
                    child: TextField(
                      controller: controller.titleController,
                      style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                      decoration: InputDecoration(
                        hintText: "Enter shopping list title",
                        hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  /// Edit Icon (visual indicator)
                  Image.asset(
                    AppImages.edit_icon,
                    height: 20,
                    width: 20,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            /// Sections List
            Obx(() => Column(
              children: controller.shoppingSections
                  .asMap()
                  .entries
                  .map((entry) => _buildRecipeSection(
                    entry.value,
                    controller,
                    entry.key,
                    isFromRecipe,  // Use screen parameter directly
                  ))
                  .toList(),
            )),

            SizedBox(height: 20.h),



            /// Description
            Text("Description", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 6.h),

            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.pureWhite,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: TextField(
                maxLines: 4,
                controller: controller.descriptionController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Add a short description about this shopping list",
                ),
              ),
            ),

            SizedBox(height: 20.h),

            /// Plan your shopping
            Text("Plan your shopping", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 8.h),

            _buildPlanSection(controller),

            SizedBox(height: 30.h),

            /// SAVE BUTTON
            CustomTextButton(
              text: 'SAVE',
              onTap: controller.saveList,
            ),

            SizedBox(height: 10.h),

            /// CANCEL BUTTON
            Center(
              child: TextButton(
                onPressed: () => Get.back(),
                child: Text("CANCEL", style: TextStyle(color: Colors.black54, fontSize: 14.sp)),
              ),
            ),
          ],
        ),
      ),
    );

  }


  // ------------------------------------------------------------
  // RECIPE SECTION (with custom item input row)
  // ------------------------------------------------------------
  Widget _buildRecipeSection(
      RecipeSection section,
      CreateShoppingController controller,
      int index,
      bool isFromRecipe,
      ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// HEADER - Show "Ingredients" label when from recipe
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isFromRecipe) ...[
                      Text(
                        "Ingredients",
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 4.h),
                    ],
                    Text(
                      section.title,
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          /// ITEMS
          Obx(() => Column(
            children: section.items
                .map((item) => _buildShoppingItem(item))
                .toList(),
          )),

          SizedBox(height: 8.h),

          /// ADD CUSTOM ITEM - Always visible
          _buildAddCustomItemRow(controller, section),
        ],
      ),
    );
  }


  // ------------------------------------------------------------
  // SHOPPING ITEM ROW
  // ------------------------------------------------------------
  Widget _buildShoppingItem(ShoppingItemModel item) {
    return Obx(() {
      return Column(
        children: [

          /// ROW CONTENT
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              children: [
                /// Checkbox
                GestureDetector(
                  onTap: () {
                    item.checked.value = !item.checked.value;
                  },
                  child: Image.asset(
                    item.checked.value
                        ? AppImages.thik_fill_icon
                        : AppImages.thik_icon,
                    height: 24,
                    width: 24,
                  ),
                ),

                SizedBox(width: 10.w),

                /// Name
                Expanded(
                  child: Text(
                    item.name,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),

                /// Amount
                Text(
                  item.amount,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp
                  ),
                ),

                SizedBox(width: 6.w),

                /// Unit
                Text(
                  item.unit,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.black54,
                  ),
                ),

                SizedBox(width: 6.w),

                /// Edit Icon
                Image.asset(
                  AppImages.edit_icon,
                  height: 24,
                  width: 24,
                  color: Colors.grey,
                ),
              ],
            ),
          ),

          /// DIVIDER (full width)
          Divider(
            color: Colors.grey.shade300,
            thickness: 2,
            height: 2,
          ),
        ],
      );
    });
  }



  // ------------------------------------------------------------
  // ADD CUSTOM ITEM ROW
  // ------------------------------------------------------------
  Widget _buildAddCustomItemRow(CreateShoppingController controller, RecipeSection section) {
    return Row(
      children: [


        /// --- NAME INPUT ---
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: section.nameCtrl,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Add custom item",
              ),
            ),
          ),
        ),

        SizedBox(width: 6.w),

        /// --- AMOUNT ---
        SizedBox(
          width: 60.w,
          child: TextField(
            controller: section.amountCtrl,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.r)),
              hintText: "Amt",
            ),
          ),
        ),

        SizedBox(width: 6.w),

        /// --- UNIT ---
        SizedBox(
          width: 50.w,
          child: TextField(
            controller: section.unitCtrl,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.r)),
              hintText: "Unit",
            ),
          ),
        ),

        /// --- ADD BUTTON ---
        GestureDetector(
          onTap: () => controller.addCustomItem(section),
          child: Image.asset(
            AppImages.add_icon,
            height: 24,
            width: 24,
            color: Colors.grey,
          ),
        )
      ],
    );
  }


  // ------------------------------------------------------------
  // PLAN SECTION
  // ------------------------------------------------------------
  Widget _buildPlanSection(CreateShoppingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// WHO?
        Row(
          children: [
            Text("Who?", style: TextStyle(fontSize: 14.sp)),
            SizedBox(width: 16.w),
            Expanded(
              child: Obx(() => DropdownButtonFormField<String>(
                value: controller.selectedPerson.value,
                items: controller.people
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: controller.changePerson,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
              )),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        /// WHEN?
        Row(
          children: [
            Text("When?", style: TextStyle(fontSize: 14.sp)),
            SizedBox(width: 16.w),
            Expanded(
              child: GestureDetector(
                onTap: controller.pickDate,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8.r),
                    color: Colors.white,
                  ),
                  child:Obx(() => Text(
                    controller.selectedDate.value == null
                        ? "Select date"
                        : DateFormat('dd/MM/yyyy').format(controller.selectedDate.value!),
                    style: TextStyle(fontSize: 13.sp),
                  ))

                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // COVER IMAGE SECTION
  // ------------------------------------------------------------
  Widget _buildCoverImageSection(CreateShoppingController controller) {
    return Obx(() {
      final hasImage = controller.coverImage.value != null;

      return GestureDetector(
        onTap: controller.pickCoverImage,
        child: Container(
          width: double.infinity,
          height: 180.h,
          decoration: BoxDecoration(
            color: AppColors.pureWhite,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: hasImage
              ? Stack(
                  children: [
                    /// Selected Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.file(
                        controller.coverImage.value!,
                        width: double.infinity,
                        height: 180.h,
                        fit: BoxFit.cover,
                      ),
                    ),

                    /// Remove Button
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: GestureDetector(
                        onTap: controller.removeCoverImage,
                        child: Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ),

                    /// Change Image Hint
                    Positioned(
                      bottom: 8.h,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            "Tap to change",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 48.sp,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "Add Cover Image",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Tap to select an image",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
        ),
      );
    });
  }
}
