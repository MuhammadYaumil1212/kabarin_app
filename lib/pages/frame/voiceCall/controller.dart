import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kabarin_app/pages/common/apis/apis.dart';
import 'package:kabarin_app/pages/common/routes/names.dart';
import 'package:kabarin_app/pages/frame/voiceCall/index.dart';

import '../../common/entities/contact.dart';
import '../../common/entities/msg.dart';
import '../../common/store/user.dart';

class VoiceCallController extends GetxController {
  VoiceCallController();
  final state = VoiceCallState();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final token = UserStore.to.profile.token;
  final tokenChat = Get.parameters['to_token'];

  void pickedUp() => state.isPickup.value = true;
  void muteSpeaker() => state.isMutedSpeaker.toggle();
  void muteMic() => state.isMutedMic.toggle();

  @override
  void onInit() async {
    var contact = await ContactAPI.getContactById(tokenChat!);
    if (contact != null) {
      state.contact = contact;
    } else {
      print("Kontak dengan ID tersebut tidak ditemukan.");
    }
    super.onInit();
  }

  void goToChat(ContactItem item) async {
    var fromMessage = await _db
        .collection("message")
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (Msg msg, options) => msg.toFirestore(),
        )
        .where("from_token", isEqualTo: token)
        .where("to_token", isEqualTo: item.token)
        .get();

    var toMessage = await _db
        .collection("message")
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (Msg msg, options) => msg.toFirestore(),
        )
        .where("from_token", isEqualTo: item.token)
        .where("to_token", isEqualTo: token)
        .get();

    if (fromMessage.docs.isEmpty && toMessage.docs.isEmpty) {
      var profile = UserStore.to.profile;

      var msgData = Msg(
        from_token: profile.token,
        to_token: item.token,
        from_name: profile.name,
        from_avatar: profile.avatar,
        to_avatar: item.avatar,
        to_name: item.name,
        from_online: profile.online,
        to_online: item.online,
        last_msg: "",
        last_time: Timestamp.now(),
        msg_num: 0,
      );

      var docId = await _db
          .collection("message")
          .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg msg, option) => msg.toFirestore(),
          )
          .add(msgData);

      debugPrint("Making New Docs.......");
      debugPrint("DocID ; ${fromMessage.docs.first.id}");
      debugPrint("fromMessage ; ${fromMessage.docs.length}");
      debugPrint("toMessage ; ${toMessage.docs.length}");
      debugPrint("toName ; ${item.name}");
      debugPrint("toToken ; ${item.token}");
      debugPrint("toAvatar ; ${item.avatar}");
      debugPrint("toOnline ; ${item.online}");

      Get.offAllNamed(
        AppRoutes.Chat,
        parameters: {
          "doc_id": docId.id,
          "to_token": item.token ?? "",
          "to_name": item.name ?? "",
          "to_avatar": item.avatar ?? "",
          "to_online": item.online.toString(),
        },
      );
    } else {
      if (fromMessage.docs.first.id.isNotEmpty) {
        Get.offAllNamed(
          AppRoutes.Chat,
          parameters: {
            "doc_id": fromMessage.docs.first.id,
            "to_token": item.token ?? "",
            "to_name": item.name ?? "",
            "to_avatar": item.avatar ?? "",
            "to_online": item.online.toString(),
          },
        );
      }
    }
  }
}
