import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:kabarin_app/pages/common/routes/names.dart';
import 'package:kabarin_app/pages/frame/contact/index.dart';

import '../../common/apis/contact.dart';

class ContactController extends GetxController {
  ContactController();
  final state = ContactState();

  void goToMessage() async => await Get.offAllNamed(AppRoutes.Message);

  @override
  void onReady() {
    getContact();
    super.onReady();
  }

  void getContact() async {
    EasyLoading.show(
      indicator: CircularProgressIndicator(),
      maskType: .clear,
      status: "Loading...",
    );
    final getContact = await ContactAPI.postContact();
    if (getContact != null) {
      state.contacts.value = getContact;
      EasyLoading.dismiss(animation: true);
    }
  }
}
