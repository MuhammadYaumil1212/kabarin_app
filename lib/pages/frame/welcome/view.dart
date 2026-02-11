import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:kabarin_app/pages/common/style/color.dart';
import 'package:kabarin_app/pages/common/values/strings.dart';
import 'package:kabarin_app/pages/frame/welcome/controller.dart';

class WelcomeView extends GetView<WelcomeController> {
  const WelcomeView({super.key});

  Widget _buildPageHeadTitle(String title) {
    return Center(
      child: Image.asset(
        "assets/images/kabarin-logo-transparent.png",
        width: 300.w,
        height: 100.h,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.primaryBackground,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_buildPageHeadTitle(AppStrings.AppName)],
        ),
      ),
    );
  }
}
