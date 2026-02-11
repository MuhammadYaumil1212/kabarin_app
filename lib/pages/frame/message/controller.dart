import 'package:get/get.dart';
import 'package:kabarin_app/pages/common/routes/names.dart';
import 'package:kabarin_app/pages/frame/message/state.dart';

class MessageController extends GetxController {
  MessageController();
  final state = MessageState();

  @override
  void onReady() {
    Future.delayed(
      const Duration(milliseconds: 3000),
      () => Get.offAllNamed(AppRoutes.Message),
    );
    super.onReady();
  }
}
