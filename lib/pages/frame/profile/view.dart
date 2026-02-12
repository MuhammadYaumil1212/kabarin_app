import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:kabarin_app/pages/common/style/color.dart';
import 'package:kabarin_app/pages/common/values/colors.dart';
import 'package:kabarin_app/pages/frame/profile/controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
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
      backgroundColor: AppColor.scaffoldBackground,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              _buildImageProfile(
                onTap: () => controller.toggleEditProfile(),
                urlImage: "",
                displayName: controller.nameController.text,
              ),
              _buildEditProfile(),
              SizedBox(height: 20.h),
              _buildButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageProfile({
    required VoidCallback onTap,
    required String urlImage,
    required String displayName,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 100.w,
                  height: 100.h,
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
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: AppColors.primaryElement,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(Icons.edit_outlined, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Text(
              displayName,
              softWrap: true,
              maxLines: 2,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: .w500,
                overflow: .ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditProfile() {
    return Obx(() {
      return Container(
        margin: EdgeInsets.only(bottom: 20.h),
        child: controller.isProfileEditing.value
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: _buildProfileInputs(),
              )
            : Container(),
      );
    });
  }

  Widget _buildProfileInputs() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          _buildTextField(
            controller: controller.nameController,
            hintText: "Enter your name",
          ),
          SizedBox(height: 15.h),

          _buildTextField(
            controller: controller.descriptionController,
            hintText: "Enter a description",
          ),
          SizedBox(height: 15.h),

          Obx(
            () => Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.withOpacity(0.3)),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: controller.currentStatus.value,
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.grey),
                  items: controller.statusOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            margin: EdgeInsets.only(right: 10.w),
                            decoration: BoxDecoration(
                              color: _getStatusColor(value),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Text(
                            value,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.primaryText,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: controller.onStatusChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.3))),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          isDense: true,
        ),
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryText,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Online":
        return Colors.green;
      case "Busy":
        return Colors.red;
      case "Offline":
        return Colors.grey;
      default:
        return Colors.green;
    }
  }

  Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.saveProfile(),
              child: Text("Save"),
            ),
          ),
          SizedBox(height: 5.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.defaultDialog(
                  title: "Logout",
                  titleStyle: TextStyle(fontWeight: .w500, fontSize: 18.sp),
                  middleText: "Are you sure you want to logout?",
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => controller.signOut(),
                      child: Text(
                        "Logout",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                );
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.red),
              ),
              child: Text("Logout", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
