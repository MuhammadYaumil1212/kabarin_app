import 'package:get/get.dart';
import 'package:kabarin_app/pages/frame/chat/controller.dart';

class ChatBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatController>(() => ChatController());
  }
}
