import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kabarin_app/pages/common/values/colors.dart';

import 'controller.dart';

class VoiceCallView extends GetView<VoiceCallController> {
  final String toId;
  final String toName;
  final String toAvatar;
  const VoiceCallView({
    super.key,
    required this.toName,
    required this.toAvatar,
    required this.toId,
  });

  @override
  Widget build(BuildContext context) {
    bool hasAvatarData =
        toAvatar.trim().isNotEmpty &&
        toAvatar != "null" &&
        toAvatar != "Unknown Name";
    String initial = toName.trim().isNotEmpty
        ? toName.trim()[0].toUpperCase()
        : "?";

    return Scaffold(
      backgroundColor: AppColors.thirdElement,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: .center,
              children: [
                SizedBox(height: 10.h),
                _timerCall(),
                SizedBox(height: 170.h),
                _buildImageCalling(hasAvatarData, initial),
                const Spacer(),
                _callButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _timerCall() {
    return Text(
      "0:00",
      style: TextStyle(color: AppColors.chatbg, fontSize: 20.sp),
    );
  }

  Widget _buildImageCalling(bool hasAvatarData, String initial) {
    return Column(
      children: [
        Text(
          "Waiting time : 5:00",
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: .bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 20.h),
        Container(
          width: 120.w,
          height: 120.h,
          decoration: BoxDecoration(
            color: AppColors.primaryElementStatus,
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: hasAvatarData
                ? Image.network(
                    toAvatar,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text(
                          initial,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 50.sp,
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(
                      initial,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.sp,
                      ),
                    ),
                  ),
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          toName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: .bold,
          ),
        ),
      ],
    );
  }

  Widget _callButtons() {
    return Obx(
      () => controller.state.isJoined.value
          ? Padding(
              padding: EdgeInsets.only(bottom: 50.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () => controller.muteMic(),
                        child: Obx(
                          () => Container(
                            width: 60.w,
                            height: 60.w,
                            decoration: BoxDecoration(
                              color: controller.state.isMutedMic.value
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              controller.state.isMutedMic.value
                                  ? Icons.mic_off
                                  : Icons.mic,
                              color: controller.state.isMutedMic.value
                                  ? Colors.black
                                  : Colors.white,
                              size: 28.w,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Mute",
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          controller.leaveChannel();
                          controller.goToChat(controller.state.contact);
                        },
                        child: Container(
                          width: 75.w,
                          height: 75.w,
                          decoration: const BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.call_end,
                            color: Colors.white,
                            size: 35.w,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "End",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () => controller.muteSpeaker(),
                        child: Obx(
                          () => Container(
                            width: 60.w,
                            height: 60.w,
                            decoration: BoxDecoration(
                              color: controller.state.isMutedSpeaker.value
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              controller.state.isMutedSpeaker.value
                                  ? Icons.volume_up
                                  : Icons.volume_down,
                              color: controller.state.isMutedSpeaker.value
                                  ? Colors.black
                                  : Colors.white,
                              size: 28.w,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Speaker",
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : Container(),
    );
  }

  Widget _receiverButton() {
    return Padding(
      padding: EdgeInsets.only(bottom: 50.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //leave channel
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  controller.leaveChannel();
                  controller.goToChat(controller.state.contact);
                },
                child: Container(
                  width: 75.w,
                  height: 75.w,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(Icons.call_end, color: Colors.white, size: 35.w),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "Decline",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          //join channel
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  controller.state.isJoined.value
                      ? controller.leaveChannel()
                      : controller.joinChannel();
                },
                child: Container(
                  width: 75.w,
                  height: 75.w,
                  decoration: BoxDecoration(
                    color: Colors.green.shade600,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(Icons.call, color: Colors.white, size: 35.w),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "Accept",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
