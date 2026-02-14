import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kabarin_app/pages/common/style/color.dart';
import 'package:kabarin_app/pages/frame/chat/controller.dart';

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
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
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
}
