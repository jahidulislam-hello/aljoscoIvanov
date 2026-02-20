import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/core/widgets/custom_text_button.dart';
import 'package:freshbite/features/shopping_list/edit_shopping_list/edit_shopping_list_controller/edit_shopping_list_controller.dart';
import 'package:get/get.dart';
import 'package:freshbite/core/appbar/custom_appbar.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/text_styles.dart';
import '../edit_shopping_list_model.dart';



class EditShoppingListScreen extends StatelessWidget {
  EditShoppingListScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditShoppingController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: Obx(() => CustomAppBar(
            title: controller.isViewMode.value ? 'Shopping List' : 'Edit Shopping List',
            titleAlignment: AppBarTitleAlignment.center,
            showBackButton: true,
            actionButtons: [
              AppBarAction(imagePath: 'assets/icons/charm_menu.png', onPressed: () {}),
            ],
          )),
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.buttonColor,
            ),
          );
        }

        // Show View Mode or Edit Mode
        if (controller.isViewMode.value) {
          return _buildViewMode(controller);
        } else {
          return _buildEditMode(controller);
        }
      }),
    );
  }

  // ============================================================
  // VIEW MODE - After saving
  // ============================================================
  Widget _buildViewMode(EditShoppingController controller) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title with three dot menu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  controller.listTitle.value.isNotEmpty
                      ? controller.listTitle.value
                      : "Shopping List",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              PopupMenuButton<int>(
                icon: Icon(Icons.more_vert, color: Colors.grey),
                color: AppColors.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                onSelected: (value) {
                  switch (value) {
                    case 0:
                      // Edit
                      controller.switchToEditMode();
                      break;
                    case 1:
                      // Save Note
                      controller.saveNote();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.pureWhite,
                      ),
                    ),
                  ),
                  PopupMenuDivider(height: 1),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Text(
                      'Save Note',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.pureWhite,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 8.h),

          /// Date
          Text(
            controller.selectedDate.value,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),

          SizedBox(height: 16.h),

          /// Shopping Note - Show text if exists, otherwise show input
          Obx(() {
            if (controller.personalNote.value.isNotEmpty) {
              // Show read-only note
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Shopping Note",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.pureWhite,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      controller.personalNote.value,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              // Show input field to add note
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Shopping Note",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.pureWhite,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      controller: controller.noteController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Add a note for your shopping...",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              );
            }
          }),

          SizedBox(height: 20.h),

          /// All List Items
          Obx(() {
            final sections = controller.recipeSections;
            return Column(
              children: sections
                  .asMap()
                  .entries
                  .map((entry) => _buildViewModeSection(entry.value, controller))
                  .toList(),
            );
          }),

          SizedBox(height: 30.h),

          /// MARK AS COMPLETE BUTTON
          Obx(() => controller.isSaving.value
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.buttonColor,
                  ),
                )
              : CustomTextButton(
                  text: 'MARK AS COMPLETE',
                  onTap: controller.markAsComplete,
                )),

          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // VIEW MODE SECTION
  // ------------------------------------------------------------
  Widget _buildViewModeSection(RecipeSection section, EditShoppingController controller) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Section Title
          Text(
            section.title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12.h),

          /// Items
          Column(
            children: section.items
                .map((item) => _buildViewModeItem(item, controller))
                .toList(),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // VIEW MODE ITEM
  // ------------------------------------------------------------
  Widget _buildViewModeItem(ShoppingItem item, EditShoppingController controller) {
    return Obx(() {
      final displayValue = item.getDisplayValue(controller.selectedUnit.value);
      final displayUnit = item.getDisplayUnit(controller.selectedUnit.value);

      return Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.h),
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

                SizedBox(width: 12.w),

                /// Name
                Expanded(
                  child: Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      decoration: item.checked.value
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: item.checked.value ? Colors.grey : Colors.black87,
                    ),
                  ),
                ),

                /// Amount
                Text(
                  _formatValue(displayValue),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    color: item.checked.value ? Colors.grey : Colors.black87,
                  ),
                ),

                SizedBox(width: 6.w),

                /// Unit
                Text(
                  displayUnit,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey.shade300,
            thickness: 1,
            height: 1,
          ),
        ],
      );
    });
  }

  // ============================================================
  // EDIT MODE - Original edit screen
  // ============================================================
  Widget _buildEditMode(EditShoppingController controller) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Title Text
              Expanded(
                child: Obx(() => Text(
                  controller.listTitle.value.isNotEmpty
                      ? controller.listTitle.value
                      : "Shopping List from Prep List(s)",
                  style: TextStyle(fontSize: 12.sp, color: Colors.black87),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )),
              ),

              /// Edit Icon
              GestureDetector(
                onTap: () {
                  // your edit action here
                },
                child: Image.asset(
                  AppImages.edit_icon,
                  height: 24,
                  width: 24,
                  color: Colors.grey,
                ),
              ),
            ],
          ),


          SizedBox(height: 16.h),

          /// Tabs
          _buildTabButtons(controller),

          SizedBox(height: 20.h),

          /// Sections List (switches between BY RECIPE and BY CATEGORY)
          Obx(() {
            final sections = controller.selectedTab.value == 0
                ? controller.recipeSections
                : controller.categorySections;

            return Column(
              children: sections
                  .asMap()
                  .entries
                  .map((entry) => _buildRecipeSection(entry.value, controller, entry.key))
                  .toList(),
            );
          }),

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
        Obx(() => controller.isSaving.value
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.buttonColor,
                ),
              )
            : CustomTextButton(
                text: 'SAVE',
                onTap: controller.saveList,
              )),

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
    );
  }

  // ------------------------------------------------------------
  // TAB BUTTONS
  // ------------------------------------------------------------
  Widget _buildTabButtons(EditShoppingController controller) {
    return Obx(() {
      return Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => controller.switchTab(0),
              child: Container(
                height: 42.h,
                decoration: BoxDecoration(
                  color: controller.selectedTab.value == 0
                      ? AppColors.buttonColor
                      : Colors.transparent,
                  border: Border.all(color: AppColors.buttonColor),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.r),
                    bottomLeft: Radius.circular(8.r),
                  ),
                ),
                child: Center(
                  child: Text(
                    "BY RECIPE",
                    style: AppTextStyles.H6_Regular.copyWith(
                      color: controller.selectedTab.value == 0
                          ? Colors.white
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: GestureDetector(
              onTap: () => controller.switchTab(1),
              child: Container(
                height: 42.h,
                decoration: BoxDecoration(
                  color: controller.selectedTab.value == 1
                      ? AppColors.buttonColor
                      : Colors.transparent,
                  border: Border.all(color: AppColors.buttonColor),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8.r),
                    bottomRight: Radius.circular(8.r),
                  ),
                ),
                child: Center(
                  child: Text(
                    "BY CATEGORY",
                    style: AppTextStyles.H6_Regular.copyWith(
                      color: controller.selectedTab.value == 1
                          ? Colors.white
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  // ------------------------------------------------------------
  // RECIPE SECTION (with custom item input row)
  // ------------------------------------------------------------
  Widget _buildRecipeSection(
      RecipeSection section,
      EditShoppingController controller,
      int index,
      ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// HEADER
          Row(
            children: [
              Expanded(
                child: Text(
                  section.title,
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
                ),
              ),

              /// SHOW DROPDOWN ONLY FOR FIRST SECTION (index == 0)
              if (index == 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 100.w,
                      child: Obx(() => DropdownButtonFormField<String>(
                        value: controller.selectedUnit.value,
                        items: ["g/ml", "HouseHold"]
                            .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            textAlign: TextAlign.center,
                          ),
                        ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) controller.selectedUnit.value = val;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 8.h),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        isExpanded: true,
                      )),
                    )
                  ],
                ),
            ],
          ),

          SizedBox(height: 12.h),

          /// ITEMS
          Column(
            children: section.items
                .map((item) => _buildShoppingItem(item, controller))
                .toList(),
          ),

          SizedBox(height: 18.h),

          /// ADD CUSTOM ITEM
          _buildAddCustomItemRow(controller, section),
        ],
      ),
    );
  }


  // ------------------------------------------------------------
  // SHOPPING ITEM ROW
  // ------------------------------------------------------------
  Widget _buildShoppingItem(ShoppingItem item, EditShoppingController controller) {
    return Obx(() {
      // Get display value and unit based on selected unit type
      final displayValue = item.getDisplayValue(controller.selectedUnit.value);
      final displayUnit = item.getDisplayUnit(controller.selectedUnit.value);

      return Column(
        children: [

          /// MAIN ROW
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

                /// Amount (displays based on unit selection)
                Text(
                  _formatValue(displayValue),
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 14.sp),
                ),

                SizedBox(width: 6.w),

                /// Unit (displays based on unit selection)
                Text(
                  displayUnit,
                  style: TextStyle(fontSize: 12.sp, color: Colors.black54),
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

          /// DIVIDER UNDER EACH ITEM
          Divider(
            color: Colors.grey.shade300,
            thickness: 1,
            height: 1,
          )
        ],
      );
    });
  }



  // ------------------------------------------------------------
  // ADD CUSTOM ITEM ROW
  // ------------------------------------------------------------
  Widget _buildAddCustomItemRow(EditShoppingController controller, RecipeSection section) {
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
  Widget _buildPlanSection(EditShoppingController controller) {
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
                  child: Obx(() => Text(
                    controller.selectedDate.value,
                    style: TextStyle(fontSize: 13.sp),
                  )),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // HELPER: Format value (round decimals)
  // ------------------------------------------------------------
  String _formatValue(String value) {
    try {
      final numValue = double.tryParse(value);
      if (numValue == null) return value;

      // If it's a whole number, show without decimals
      if (numValue == numValue.roundToDouble()) {
        return numValue.toInt().toString();
      }

      // Otherwise show with 1 decimal place
      return numValue.toStringAsFixed(1);
    } catch (e) {
      return value;
    }
  }
}
