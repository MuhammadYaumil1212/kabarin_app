import 'package:get/get.dart';
import 'package:kabarin_app/pages/common/routes/names.dart';
import 'package:kabarin_app/pages/frame/message/state.dart';

class MessageController extends GetxController {
  MessageController();
  final state = MessageState();

  void goToProfile() async => await Get.offAllNamed(AppRoutes.Profile);
}
