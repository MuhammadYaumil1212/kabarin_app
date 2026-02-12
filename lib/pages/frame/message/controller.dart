import 'package:get/get.dart';
import 'package:kabarin_app/pages/common/routes/names.dart';
import 'package:kabarin_app/pages/frame/message/state.dart';

import '../../common/store/user.dart';

class MessageController extends GetxController {
  MessageController();
  final state = MessageState();

  @override
  void onInit() {
    // TODO: implement onInit
    _loadProfileData();
    super.onInit();
  }

  void _loadProfileData() async {
    await UserStore.to.getProfile();
  }

  void goToProfile() async => await Get.offAllNamed(AppRoutes.Profile);
}
