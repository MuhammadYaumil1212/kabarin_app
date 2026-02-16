import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:kabarin_app/pages/common/entities/contact.dart';

class VoiceCallState {
  var isMutedSpeaker = false.obs;
  var isMutedMic = false.obs;
  var tokenChat = "".obs;
  var isJoined = false.obs;
  ContactItem contact = ContactItem();
}
