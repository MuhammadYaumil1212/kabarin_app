import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kabarin_app/pages/common/style/color.dart';
import 'package:kabarin_app/pages/frame/message/controller.dart';

import '../../common/values/colors.dart';

class MessageView extends GetView<MessageController> {
  const MessageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  scrolledUnderElevation: 0.0,
                  title: Obx(
                    () => _buildHeader(
                      onTap: () => controller.goToProfile(),
                      urlImage: controller.state.headDetail.value.avatar == null
                          ? ""
                          : controller.state.avatar.value,
                      displayName: controller.state.name.value,
                      status: true,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader({
    required VoidCallback onTap,
    required String urlImage,
    required String displayName,
    required bool status,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 40.w,
                  height: 40.h,
                  padding: const .all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryElementStatus,
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    image: DecorationImage(
                      image: AssetImage("assets/images/man_ava.jpg"),
                      fit: .cover,
                    ),
                  ),
                ),
                if (status == true)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                if (status == false)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                displayName,
                softWrap: true,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: .w500,
                  overflow: .ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigation() {
    return Container();
  }
}
