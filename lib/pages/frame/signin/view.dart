import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:kabarin_app/pages/common/style/color.dart';
import 'package:kabarin_app/pages/common/values/colors.dart';

import 'controller.dart';

class SignInView extends GetView<SignInController> {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.primarySecondaryBackground,
        body: Center(
          child: Column(
            mainAxisAlignment: .center,
            children: [
              _buildLogo(),
              SizedBox(height: 20.h),
              _buildThirdPartyLogin(
                "Google",
                "assets/icons/google.png",
                authRoute: () => controller.signInWithGoogle(),
              ),
              SizedBox(height: 20.h),
              _buildThirdPartyLogin(
                "Facebook",
                "assets/icons/facebook.png",
                authRoute: () {},
              ),
              SizedBox(height: 20.h),
              _buildThirdPartyLogin(
                "Apple",
                "assets/icons/apple.png",
                authRoute: () {},
              ),
              SizedBox(height: 30.h),
              _buildOrWidget(),
              SizedBox(height: 20.h),
              _buildThirdPartyLogin(
                "Phone Number",
                "assets/icons/ic_smartphone.png",
                colorIcon: Colors.black,
                authRoute: () {},
              ),
              SizedBox(height: 35.h),
              _buildSignUpText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpText() {
    return Column(
      children: [
        Text(
          textAlign: .center,
          "Already have an account ?",
          style: TextStyle(
            color: AppColor.secondaryText,
            fontWeight: .normal,
            fontSize: 12.sp,
          ),
        ),
        InkWell(
          onTap: () {},
          child: Text(
            "Signup Here",
            textAlign: .center,
            style: TextStyle(
              color: AppColor.accentColor,
              fontWeight: .w500,
              fontSize: 12.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrWidget() {
    return Row(
      mainAxisAlignment: .center,
      children: [
        Expanded(
          child: Divider(
            color: AppColors.primarySecondaryElementText,
            height: 2.h,
            thickness: 0.5,
            endIndent: 20,
            indent: 20,
          ),
        ),
        Text(
          "Or",
          textAlign: .center,
          style: TextStyle(
            fontWeight: .w700,
            color: AppColors.primarySecondaryElementText,
          ),
        ),
        Expanded(
          child: Divider(
            color: AppColors.primarySecondaryElementText,
            height: 2.h,
            thickness: 0.5,
            indent: 20,
            endIndent: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      "assets/images/kabarin-logo.png",
      width: 200.w,
      height: 100.h,
    );
  }

  Widget _buildThirdPartyLogin(
    String loginType,
    String logoPath, {
    required VoidCallback authRoute,
    Color? colorIcon,
  }) {
    return InkWell(
      onTap: authRoute,
      child: Container(
        width: 295.w,
        height: 44.h,
        padding: .all(10),
        decoration: BoxDecoration(
          color: AppColors.primaryBackground,
          borderRadius: .circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: .start,
          crossAxisAlignment: .start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Image.asset(
                logoPath,
                width: 30.w,
                height: 30.h,
                color: colorIcon,
              ),
            ),
            SizedBox(width: 30.w),
            Text(
              textAlign: .center,
              "Sign in with $loginType",
              style: TextStyle(
                fontSize: 15.sp,
                color: AppColor.secondaryText,
                fontWeight: .w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
