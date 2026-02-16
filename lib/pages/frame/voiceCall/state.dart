import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:kabarin_app/pages/common/entities/contact.dart';

class VoiceCallState {
  var isPickup = false.obs;
  var isMutedSpeaker = false.obs;
  var isMutedMic = false.obs;
  var tokenChat = "".obs;
  ContactItem contact = ContactItem();
}
