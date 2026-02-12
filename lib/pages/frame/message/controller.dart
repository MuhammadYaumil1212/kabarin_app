import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:kabarin_app/pages/common/routes/names.dart';
import 'package:kabarin_app/pages/frame/message/state.dart';

import '../../common/store/user.dart';

class MessageController extends GetxController {
  MessageController();
  final state = MessageState();

  final displayName = "";

  @override
  void onReady() {
    EasyLoading.show(
      indicator: CircularProgressIndicator(),
      maskType: .clear,
      status: "Loading...",
    );
    _loadProfileData();
    super.onReady();
  }

  void _loadProfileData() async {
    final getProf = await UserStore.to.getProfile();
    if (getProf.isNotEmpty) {
      EasyLoading.dismiss(animation: true);
      final getUser = UserStore.to.profile;
      state.name.value = getUser.name!;
      state.avatar.value = getUser.avatar!;
    } else {
      EasyLoading.showError("Network error");
    }
  }

  void goToProfile() async => await Get.offAllNamed(AppRoutes.Profile);
}
