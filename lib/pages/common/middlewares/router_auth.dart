import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kabarin_app/pages/common/store/store.dart';

import '../routes/names.dart';

class RouteAuthMiddleware extends GetMiddleware {
  @override
  int? priority = 0;

  RouteAuthMiddleware({required this.priority});

  @override
  RouteSettings? redirect(String? route) {
    if (UserStore.to.isLogin ||
        route == AppRoutes.SIGN_IN ||
        route == AppRoutes.INITIAL) {
      return null;
    } else {
      Future.delayed(
        Duration(seconds: 2),
        () => Get.snackbar("Tips", "Login expired, please login again!"),
      );
      return RouteSettings(name: AppRoutes.SIGN_IN);
    }
  }
}
