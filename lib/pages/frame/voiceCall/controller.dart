import 'package:get/get.dart';
import 'package:kabarin_app/pages/frame/voiceCall/index.dart';

class VoiceCallController extends GetxController {
  VoiceCallController();
  final state = VoiceCallState();
  void pickedUp() => state.isPickup.value = true;
  void muteSpeaker() => state.isMutedSpeaker.toggle();
  void muteMic() => state.isMutedMic.toggle();
  void endCall() => Get.back(closeOverlays: true);
}
