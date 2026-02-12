import 'package:get/get.dart';
import 'package:kabarin_app/pages/frame/contact/controller.dart';

class ContactBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactController>(() => ContactController());
  }
}
