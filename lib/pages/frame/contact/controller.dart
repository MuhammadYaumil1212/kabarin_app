import 'package:get/get.dart';
import 'package:kabarin_app/pages/common/routes/names.dart';
import 'package:kabarin_app/pages/frame/contact/index.dart';

class ContactController extends GetxController {
  ContactController();
  final state = ContactState();

  void goToMessage() async => await Get.offAllNamed(AppRoutes.Message);
}
