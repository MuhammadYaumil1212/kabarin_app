import 'package:get/get.dart';
import 'package:kabarin_app/pages/frame/signin/controller.dart';

class SignInBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInController>(() => SignInController());
  }
}
