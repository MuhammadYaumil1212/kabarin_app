import 'package:get/get.dart';
import 'package:kabarin_app/pages/common/routes/names.dart';
import 'package:kabarin_app/pages/frame/chat/index.dart';

class ChatController extends GetxController {
  ChatController();
  final state = ChatState();

  void goToContact() => Get.offAllNamed(AppRoutes.Contact);
  void toggleFeaturePanel() {
    state.isPanelOpen.value = !state.isPanelOpen.value;
  }
}
