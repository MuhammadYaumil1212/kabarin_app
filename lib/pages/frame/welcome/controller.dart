import 'package:get/get.dart';
import 'package:kabarin_app/pages/common/routes/names.dart';
import 'package:kabarin_app/pages/frame/welcome/state.dart';

class WelcomeController extends GetxController {
  WelcomeController();
  final state = WelcomeState();

  @override
  void onReady() {
    print("Ready welcoming");
    Future.delayed(
      const Duration(seconds: 3),
      () => Get.offAllNamed(AppRoutes.Message),
    );
    super.onReady();
  }
}
