import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/localization/localization/app_translation.dart';
import 'package:freshbite/routes/routes.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:freshbite/localization/localization/localization_controller.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.put(LocalizationController(sharedPreferences: sharedPreferences));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(376, 812),
      builder: (context, child) {
        return GetMaterialApp(
          theme: ThemeData(useMaterial3: false),
          debugShowCheckedModeBanner: false,

          title: 'FreshBite',
          translations: AppTranslations(),
          locale: Get.find<LocalizationController>().locale,
          fallbackLocale: const Locale('en', 'US'),
          getPages: AppRoute.routes,
          initialRoute: AppRoute.splashScreen,
        );
      },
    );
  }
}









