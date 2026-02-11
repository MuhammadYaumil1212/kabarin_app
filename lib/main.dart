import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kabarin_app/global.dart';
import 'package:kabarin_app/pages/common/routes/pages.dart';
import 'package:kabarin_app/pages/common/style/style.dart';
import 'package:kabarin_app/pages/common/values/strings.dart';

void main() async {
  await Global.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 780),
      builder: (context, child) {
        return GetMaterialApp(
          title: AppStrings.AppName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
