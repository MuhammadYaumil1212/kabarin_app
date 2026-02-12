import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kabarin_app/pages/common/style/color.dart';
import 'package:kabarin_app/pages/frame/contact/controller.dart';

import '../../common/values/colors.dart';

class ContactView extends GetView<ContactController> {
  const ContactView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      appBar: AppBar(
        title: Text(
          "Contacts",
          style: TextStyle(
            fontSize: 18.sp,
            color: AppColors.fourElementText,
            fontWeight: .w500,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => controller.goToMessage(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.fourElementText,
            size: 18.h,
          ),
        ),
      ),
      body: SafeArea(child: Center(child: Text("Contact Page"))),
    );
  }
}
