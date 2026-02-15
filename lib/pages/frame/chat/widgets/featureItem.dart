import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kabarin_app/pages/common/values/colors.dart';

class FeatureItem extends StatelessWidget {
  final VoidCallback onTap;
  final Icon icon;
  const FeatureItem({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 50.w,
        height: 50.h,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: .circular(10),
          border: .all(color: AppColors.fourElementText),
        ),
        child: icon,
      ),
    );
  }
}
