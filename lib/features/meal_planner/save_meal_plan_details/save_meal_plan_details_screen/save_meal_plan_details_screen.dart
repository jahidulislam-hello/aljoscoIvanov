import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/appbar/custom_appbar.dart';
import 'package:freshbite/features/meal_planner/reused_meal_plan/reused_meal_plan_model.dart';
import 'package:freshbite/features/meal_planner/save_meal_plan_details/save_meal_plan_details_controller/save_meal_plan_details_controller.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

// ================= SCREEN =================
class SavedMealPlanDetails extends StatelessWidget {
  final List<MealPlanModel>? selectedMealPlans;

  const SavedMealPlanDetails({
    super.key,
    this.selectedMealPlans,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SavedMealPlanDetailsController());
    ScreenUtil.init(context);

    // Set selected meal plans if passed
    if (selectedMealPlans != null && selectedMealPlans!.isNotEmpty) {
      controller.setSelectedMealPlans(selectedMealPlans!);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3EF),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: Obx(() => CustomAppBar(
            title: controller.getAppBarTitle(),
            titleAlignment: AppBarTitleAlignment.center,
            showBackButton: true,
            actionButtons: [
              AppBarAction(imagePath: 'assets/icons/charm_menu.png', onPressed: () {}),
            ],
          )),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Obx(() {
          return ListView(
            children: [
              SizedBox(height: 10.h),

              // Print Button
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => _printMealPlan(controller),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: const Color(0xFFB5B7B4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Print",
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF2D2D2D),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        const Icon(Icons.print, size: 18),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              // ====== DAILY SECTIONS ======
              for (var day in controller.dailyPlans)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Plan title if available
                    if (day.planTitle != null) ...[
                      Text(
                        day.planTitle!,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1C2D07),
                        ),
                      ),
                      SizedBox(height: 4.h),
                    ],
                    Text(
                      day.date,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2D2D2D),
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // Meals under each day
                    ...day.meals.map(
                          (meal) => Padding(
                        padding: EdgeInsets.only(bottom: 14.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              meal.mealType,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF2D2D2D),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      meal.title,
                                      style: TextStyle(fontSize: 13.sp, color: Colors.black87),
                                    ),
                                    Text(
                                      meal.servings,
                                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),

                    Divider(color: Colors.grey.shade300),
                    SizedBox(height: 10.h),
                  ],
                ),

              SizedBox(height: 40.h),
            ],
          );
        }),
      ),
    );
  }

  // Print functionality
  Future<void> _printMealPlan(SavedMealPlanDetailsController controller) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text(
                controller.getAppBarTitle(),
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            ...controller.dailyPlans.map((day) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (day.planTitle != null)
                    pw.Text(
                      day.planTitle!,
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.green800,
                      ),
                    ),
                  pw.Text(
                    day.date,
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  ...day.meals.map((meal) {
                    return pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 8),
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.SizedBox(
                            width: 80,
                            child: pw.Text(
                              meal.mealType,
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Expanded(
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(meal.title),
                                pw.Text(
                                  meal.servings,
                                  style: pw.TextStyle(
                                    fontSize: 10,
                                    color: PdfColors.grey600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  pw.Divider(),
                  pw.SizedBox(height: 10),
                ],
              );
            }),
          ];
        },
      ),
    );

    // Show print preview
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
