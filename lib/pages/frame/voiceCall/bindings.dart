import 'package:get/get.dart';
import 'package:kabarin_app/pages/frame/voiceCall/controller.dart';

class VoiceCallBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VoiceCallController>(() => VoiceCallController());
  }
}
