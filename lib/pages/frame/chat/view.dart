import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kabarin_app/pages/common/style/color.dart';
import 'package:kabarin_app/pages/frame/chat/controller.dart';
import 'package:kabarin_app/pages/frame/chat/widgets/featureItem.dart';

import '../../common/values/colors.dart';

class ChatView extends GetView<ChatController> {
  final String toName;
  final String toAvatar;
  final String toOnline;
  const ChatView({
    super.key,
    required this.toName,
    required this.toAvatar,
    required this.toOnline,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => controller.goToContact(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => controller.goToContact(),
            ),
          ),
        ),
        centerTitle: false,
        actionsPadding: .symmetric(horizontal: 20),
        actions: [InkWell(child: Icon(Icons.more_vert_outlined))],
        title: _buildHeader(
          onTap: () {},
          urlImage: toAvatar,
          displayName: toName,
          status: int.tryParse(toOnline) ?? 0,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              // chat section
              // Keyboard section
              const Spacer(),
              _buildKeyboard(context),
              Obx(
                () => AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  alignment: .topCenter,
                  child: controller.state.isPanelOpen.value
                      ? _panelFeatures()
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader({
    required VoidCallback onTap,
    required String urlImage,
    required String displayName,
    required int status,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 35.w,
                height: 35.h,
                padding: const .all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryElementStatus,
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  image: urlImage.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(urlImage),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: urlImage.isEmpty
                    ? Center(
                        child: Text(
                          (urlImage.isNotEmpty)
                              ? urlImage[0].toUpperCase()
                              : "?",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : null,
              ),
              if (status == 1)
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
              if (status == 0)
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
          const SizedBox(width: 15),
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
    );
  }

  Widget _buildKeyboard(BuildContext context) {
    return Row(
      spacing: 20,
      children: [
        Expanded(
          flex: 1,
          child: TextFormField(
            decoration: InputDecoration(
              filled: true,
              suffixIcon: InkWell(
                onTap: () {
                  print("Send messages");
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/icons/send.png",
                    color: AppColors.primaryElement,
                    width: 10.w,
                    height: 10.h,
                  ),
                ),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.thirdElement),
                borderRadius: .all(Radius.circular(10)),
              ),
              hint: Text(
                "Kirim pesan......",
                style: TextStyle(color: AppColors.fourElementText),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 0,
          child: InkWell(
            onTap: () {
              FocusScope.of(context).unfocus();
              controller.toggleFeaturePanel();
            },
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  Widget _panelFeatures() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Row(
            children: [
              FeatureItem(
                onTap: () {
                  print("tap image");
                },
                icon: Icon(Icons.image_outlined, color: AppColors.thirdElement),
              ),
              const SizedBox(width: 12),
              FeatureItem(
                onTap: () {
                  print("tap camera");
                },
                icon: Icon(
                  Icons.camera_alt_outlined,
                  color: AppColors.thirdElement,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
