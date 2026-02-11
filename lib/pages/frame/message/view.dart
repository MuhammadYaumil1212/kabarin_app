import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:kabarin_app/pages/common/style/color.dart';
import 'package:kabarin_app/pages/frame/message/controller.dart';

class MessageView extends GetView<MessageController> {
  const MessageView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.scaffoldBackground,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Message Page")],
        ),
      ),
    );
  }
}
