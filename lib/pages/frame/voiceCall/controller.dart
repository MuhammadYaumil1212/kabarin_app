import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kabarin_app/pages/common/apis/apis.dart';
import 'package:kabarin_app/pages/common/routes/names.dart';
import 'package:kabarin_app/pages/frame/voiceCall/index.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/entities/contact.dart';
import '../../common/entities/msg.dart';
import '../../common/store/user.dart';
import '../../common/values/server.dart';

class VoiceCallController extends GetxController {
  VoiceCallController();
  final state = VoiceCallState();
  final AudioPlayer player = AudioPlayer();
  String appId = APPID;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final token = UserStore.to.profile.token;
  final tokenChat = Get.parameters['to_token'];
  late final RtcEngine engine;

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
    initEngine();
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

  Future<void> initEngine() async {
    await player.setAsset("assets/audio_mixing/Sound_Horizon.mp3");
    engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(appId: appId));
    engine.registerEventHandler(
      RtcEngineEventHandler(
        onError: (ErrorCodeType err, String msg) {
          print("Error Type : ${err}");
          print("Error message : ${msg}");
        },
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          print("On Connection : ${connection.toJson()}");
          state.isJoined.value = true;
        },
        onUserJoined:
            (RtcConnection connection, int remoteUid, int elapsed) async {
              await player.pause();
            },
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          print("my stats : ${stats.toJson()}");
          state.isJoined.value = false;
        },
        onRtcStats: (RtcConnection connection, RtcStats stats) {
          print("time...");
          print(stats.duration);
        },
      ),
    );
    await engine.enableAudio();
    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await engine.setAudioProfile(
      profile: .audioProfileDefault,
      scenario: .audioScenarioGameStreaming,
    );
    await joinChannel();
  }

  Future<void> joinChannel() async {
    print("Joined Channel");
    await Permission.microphone.request();
    EasyLoading.show(
      indicator: const CircularProgressIndicator(),
      maskType: .clear,
      dismissOnTap: false,
    );
    await engine.joinChannel(
      token:
          "007eJxTYKhWmx2myHOgXN4q6Zh010n7S1FFM5UWX5H1XHh3F08NX7ICg5m5kXlykqVpomWqkYmlqWGScZpZklmSuWmqSZJpqoGlmNjkzIZARoYnwhqsjAwQCOLzMWQnJiUWZeY5ZyTm5aXmMDAAAKZpIAE=",
      channelId: "kabarinChannel",
      uid: 0,
      options: ChannelMediaOptions(clientRoleType: .clientRoleBroadcaster),
    );
    EasyLoading.dismiss();
  }

  void leaveChannel() async {
    EasyLoading.show(
      indicator: const CircularProgressIndicator(),
      maskType: .clear,
      dismissOnTap: false,
    );
    await player.pause();
    state.isJoined.value = false;
    EasyLoading.dismiss();
  }

  void _dispose() async {
    await player.pause();
    await engine.leaveChannel();
    await engine.release();
    await player.stop();
  }

  @override
  void onClose() {
    _dispose();
    super.onClose();
  }

  @override
  void dispose() async {
    _dispose();
    super.dispose();
  }
}
