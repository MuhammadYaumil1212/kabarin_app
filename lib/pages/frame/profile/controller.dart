import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kabarin_app/pages/common/routes/names.dart';
import 'package:kabarin_app/pages/frame/profile/index.dart';

import '../../common/store/user.dart';

class ProfileController extends GetxController {
  ProfileController();
  final state = ProfileState();
  var isProfileEditing = false.obs;
  var currentStatus = "Online".obs;
  final _auth = FirebaseAuth.instance;
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  final List<String> statusOptions = ["Online", "Busy", "Offline"];

  @override
  void onInit() {
    super.onInit();
    var user = UserStore.to.profile;
    nameController = TextEditingController(text: user.name ?? "");
    descriptionController = TextEditingController(text: user.description ?? "");
    currentStatus.value = (user.online == 1) ? "Online" : "Offline";
  }

  void toggleEditProfile() {
    isProfileEditing.toggle();
  }

  void onStatusChanged(String? newValue) {
    if (newValue != null) {
      currentStatus.value = newValue;
    }
  }

  void signOut() async {
    await _auth.signOut();
    await GoogleSignIn.instance.signOut();
    await UserStore.to.onLogout();
    await Get.offAllNamed(AppRoutes.SIGN_IN);
  }

  void saveProfile() {
    String name = nameController.text;
    String desc = descriptionController.text;
    String status = currentStatus.value;
    print("Saving: $name, $desc, $status");
  }

  void goToMessage() async => await Get.offAllNamed(AppRoutes.Message);

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
