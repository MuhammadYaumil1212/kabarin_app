import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kabarin_app/pages/common/apis/apis.dart';
import 'package:kabarin_app/pages/common/entities/entities.dart';
import 'package:kabarin_app/pages/common/routes/names.dart';
import 'package:kabarin_app/pages/common/store/store.dart';
import 'package:kabarin_app/pages/common/values/strings.dart';
import 'package:kabarin_app/pages/common/values/values.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseMassagingHandler {
  FirebaseMassagingHandler._();
  static const String keyAcceptCall = "ACCEPT_CALL";
  static const String keyRejectCall = "REJECT_CALL";

  static Future<void> config() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await AwesomeNotifications().initialize('assets/images/kabarin_logo.png', [
      NotificationChannel(
        channelKey: AppStrings.AppName,
        channelName: 'Call Notifications',
        channelDescription: 'Notification channel for incoming calls',
        defaultColor: AppColors.primaryElement,
        importance: NotificationImportance.Max,
        ledColor: Colors.white,
        channelShowBadge: true,
        locked: true,
        defaultRingtoneType: DefaultRingtoneType.Ringtone,
        playSound: true,
        enableVibration: true,
        soundSource: 'resource://raw/alert',
      ),
      // Channel untuk Pesan Biasa
      NotificationChannel(
        channelKey: 'chatty_message',
        channelName: 'Message Notifications',
        channelDescription: 'Notification channel for chat messages',
        defaultColor: AppColors.primaryElement,
        importance: NotificationImportance.High,
        channelShowBadge: true,
        playSound: true,
        enableVibration: true,
      ),
    ]);

    // 2. Request Permissions
    await messaging.requestPermission(
      sound: true,
      badge: true,
      alert: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );

    // Request Permission Awesome Notification (Wajib untuk Android 13+)
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }

    // 3. Setup Listeners (Untuk menangani tombol Terima/Tolak)
    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
    );

    // 4. Handle Pesan saat Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("\n notification on onMessage function \n");
      print(message);
      if (message.data.isNotEmpty) {
        _receiveNotification(message);
      }
      if (message.notification != null) {
        _showNotification(message: message);
      }
    });
  }

  /// METHOD STATIS UNTUK MENANGANI AKSI TOMBOL NOTIFIKASI
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    // Ambil data payload yang kita simpan saat membuat notifikasi
    final payload = receivedAction.payload;
    if (payload == null) return;

    String to_token = payload["token"] ?? "";
    String to_name = payload["name"] ?? "";
    String to_avatar = payload["avatar"] ?? "";
    String doc_id = payload["doc_id"] ?? "";
    String call_role = "audience"; // role penerima

    // Logika Tombol Tolak
    if (receivedAction.buttonKeyPressed == keyRejectCall) {
      print("Call Rejected");
      await _sendNotifications("cancel", to_token, to_avatar, to_name, doc_id);
      await AwesomeNotifications().cancel(receivedAction.id!);
    }
    // Logika Tombol Terima
    else if (receivedAction.buttonKeyPressed == keyAcceptCall) {
      print("Call Accepted");

      // Tentukan rute berdasarkan tipe panggilan di payload
      String callType = payload["call_type"] ?? "";
      String route = callType == "voice"
          ? AppRoutes.VoiceCall
          : AppRoutes.VideoCall;

      if (callType == "video") {
        ConfigStore.to.isCallVocie = true;
      }

      Get.toNamed(
        route,
        parameters: {
          "to_token": to_token,
          "to_name": to_name,
          "to_avatar": to_avatar,
          "doc_id": doc_id,
          "call_role": call_role,
        },
      );
    }
  }

  static Future<void> _receiveNotification(RemoteMessage message) async {
    var data = message.data;
    // Cek apakah data valid
    if (data["call_type"] != null) {
      String callType = data["call_type"];

      // Jika cancel, hapus semua notifikasi panggilan
      if (callType == "cancel") {
        await AwesomeNotifications().cancelAll();
        // Tutup Snackbar jika ada (fallback)
        if (Get.isSnackbarOpen) {
          Get.closeAllSnackbars();
        }
        // Jika sedang di layar call, kembali
        if (Get.currentRoute.contains(AppRoutes.VoiceCall) ||
            Get.currentRoute.contains(AppRoutes.VideoCall)) {
          Get.back();
        }
        var _prefs = await SharedPreferences.getInstance();
        await _prefs.setString("CallVocieOrVideo", "");
        return;
      }

      // Jika Voice atau Video Call
      if (callType == "voice" || callType == "video") {
        var to_token = data["token"];
        var to_name = data["name"];
        var to_avatar = data["avatar"];
        var doc_id = data["doc_id"] ?? "";

        if (to_token != null && to_name != null && to_avatar != null) {
          // Tampilkan Awesome Notification (Menggantikan Get.snackbar)
          await AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: 100, // ID konstan agar bisa ditimpa/cancel
              channelKey: 'chatty_call',
              title: 'Incoming ${callType == "voice" ? "Voice" : "Video"} Call',
              body: '$to_name is calling you...',
              category:
                  NotificationCategory.Call, // Kategori PENTING untuk Call
              largeIcon: to_avatar, // Menampilkan foto profil penelepon
              wakeUpScreen: true,
              fullScreenIntent: true,
              autoDismissible: false,
              backgroundColor: AppColors.primaryElement,
              payload: {
                "token": to_token,
                "name": to_name,
                "avatar": to_avatar,
                "doc_id": doc_id,
                "call_type": callType,
              },
            ),
            actionButtons: [
              NotificationActionButton(
                key: keyRejectCall,
                label: 'Decline',
                color: Colors.red,
                autoDismissible: true,
                actionType: ActionType
                    .SilentAction, // Tidak membuka aplikasi full, cuma eksekusi logic
              ),
              NotificationActionButton(
                key: keyAcceptCall,
                label: 'Accept',
                color: Colors.green,
                autoDismissible: true,
                actionType: ActionType.Default, // Membuka aplikasi
              ),
            ],
          );
        }
      }
    }
  }

  static Future<void> _sendNotifications(
    String call_type,
    String to_token,
    String to_avatar,
    String to_name,
    String doc_id,
  ) async {
    CallRequestEntity callRequestEntity = new CallRequestEntity();
    callRequestEntity.call_type = call_type;
    callRequestEntity.to_token = to_token;
    callRequestEntity.to_avatar = to_avatar;
    callRequestEntity.doc_id = doc_id;
    callRequestEntity.to_name = to_name;
    var res = await ChatAPI.call_notifications(params: callRequestEntity);
    if (res.code == 0) {
      print("sendNotifications success");
    }
  }

  static Future<void> _showNotification({RemoteMessage? message}) async {
    RemoteNotification? notification = message!.notification;
    AndroidNotification? androidNotification = message.notification!.android;

    if (notification != null && androidNotification != null) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: notification.hashCode,
          channelKey: 'chatty_message', // Gunakan channel pesan
          title: notification.title,
          body: notification.body,
          notificationLayout: NotificationLayout.Default,
          payload: message.data.map(
            (key, value) => MapEntry(key, value.toString()),
          ),
        ),
      );
    }
  }
}
