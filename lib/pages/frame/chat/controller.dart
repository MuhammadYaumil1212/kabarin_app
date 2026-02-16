import 'package:get/get.dart';
import 'package:kabarin_app/pages/common/apis/apis.dart';
import 'package:kabarin_app/pages/common/routes/names.dart';
import 'package:kabarin_app/pages/frame/chat/index.dart';

class ChatController extends GetxController {
  ChatController();
  final state = ChatState();
  final getName = Get.parameters['to_name'];
  final getAvatar = Get.parameters['to_avatar'];
  final token = Get.parameters['to_token'];

  @override
  Future<void> onInit() async {
    var contactById = ContactAPI.getContactById(token!);
    state.contacts.value = await contactById;
    super.onInit();
  }

  void goToContact() => Get.offAllNamed(AppRoutes.Contact);
  void goToVideoCall() => Get.offAllNamed(AppRoutes.VideoCall);
  void goToVoiceCall() async {
    Get.offAllNamed(
      AppRoutes.VoiceCall,
      parameters: {
        "to_token": ?token,
        "to_name": getName ?? "",
        "to_avatar": getAvatar ?? "",
      },
    );
  }

  void toggleFeaturePanel() {
    state.isPanelOpen.value = !state.isPanelOpen.value;
  }
}
