import 'package:get/get.dart';
import 'package:kabarin_app/pages/frame/welcome/controller.dart';

class WelcomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<WelcomeController>(WelcomeController());
  }
}
