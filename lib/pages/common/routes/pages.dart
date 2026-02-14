import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kabarin_app/pages/common/middlewares/middlewares.dart';
import 'package:kabarin_app/pages/frame/chat/bindings.dart';
import 'package:kabarin_app/pages/frame/chat/view.dart';
import 'package:kabarin_app/pages/frame/contact/bindings.dart';
import 'package:kabarin_app/pages/frame/contact/view.dart';
import 'package:kabarin_app/pages/frame/message/index.dart';
import 'package:kabarin_app/pages/frame/profile/bindings.dart';
import 'package:kabarin_app/pages/frame/profile/view.dart';
import 'package:kabarin_app/pages/frame/signin/index.dart';
import 'package:kabarin_app/pages/frame/welcome/index.dart';

import 'routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.INITIAL;
  static final RouteObserver<Route> observer = RouteObservers();
  static List<String> history = [];

  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.INITIAL,
      page: () => const WelcomeView(),
      binding: WelcomeBinding(),
    ),

    GetPage(
      name: AppRoutes.SIGN_IN,
      page: () => const SignInView(),
      binding: SignInBinding(),
    ),

    GetPage(
      name: AppRoutes.Message,
      page: () => const MessageView(),
      middlewares: [RouteAuthMiddleware(priority: 1)],
      binding: MessageBinding(),
    ),

    GetPage(
      name: AppRoutes.Profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),

    GetPage(
      name: AppRoutes.Contact,
      page: () => const ContactView(),
      binding: ContactBinding(),
    ),

    GetPage(
      name: AppRoutes.Chat,
      page: () {
        final args = Get.parameters as Map<String, dynamic>? ?? {};
        return ChatView(
          toName: args['to_name'] ?? "Unknown Name",
          toAvatar: args['to_avatar'] ?? "",
          toOnline: args['to_online'] ?? 0.toString(),
        );
      },
      binding: ChatBinding(),
    ),
  ];
}
