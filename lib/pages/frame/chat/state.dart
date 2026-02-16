import 'package:get/get.dart';
import 'package:kabarin_app/pages/common/entities/entities.dart';

class ChatState {
  RxList<Msgcontent> msgChat = <Msgcontent>[].obs;
  final contacts = Rxn<ContactItem>();
  var isPanelOpen = false.obs;
  var toToken = "".obs;
  var toName = "".obs;
  var toAvatar = "".obs;
  var toOnline = "".obs;
}
