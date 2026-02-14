import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:kabarin_app/pages/common/apis/apis.dart';
import 'package:kabarin_app/pages/common/entities/entities.dart';
import 'package:kabarin_app/pages/common/routes/names.dart';
import 'package:kabarin_app/pages/common/store/store.dart';
import 'package:kabarin_app/pages/frame/contact/index.dart';

import '../../common/apis/contact.dart';

class ContactController extends GetxController {
  ContactController();
  final state = ContactState();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final token = UserStore.to.profile.token;

  void goToMessage() async => await Get.offAllNamed(AppRoutes.Message);

  @override
  void onReady() {
    getContact();
    super.onReady();
  }

  void getContact() async {
    EasyLoading.show(
      indicator: CircularProgressIndicator(),
      maskType: .clear,
      status: "Loading...",
    );
    final getContact = await ContactAPI.postContact();
    if (getContact != null) {
      state.contacts.value = getContact;
      EasyLoading.dismiss(animation: true);
    }
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

      print("Making New Docs.......");
      print("DocID ; ${docId.id}");
      print("fromMessage ; ${fromMessage.docs.length}");
      print("toMessage ; ${toMessage.docs.length}");
      print("toName ; ${item.name}");
      print("toToken ; ${item.token}");
      print("toAvatar ; ${item.avatar}");
      print("toOnline ; ${item.online}");

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
      Get.snackbar("Error", "Something Happened, please try again");
    }
  }
}
