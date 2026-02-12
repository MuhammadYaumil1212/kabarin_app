import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kabarin_app/pages/common/routes/names.dart';
import 'package:kabarin_app/pages/frame/message/state.dart';

import '../../common/entities/user.dart';
import '../../common/store/user.dart';

class SignInController extends GetxController {
  SignInController();
  final state = MessageState();
  final scopes = ['email', 'profile'];
  final serverClientId =
      "1030142167543-hme9aqvovher04ki3j32le10044luv06.apps.googleusercontent.com";
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Future<void> signInWithGoogle() async {
    try {
      EasyLoading.show(
        indicator: CircularProgressIndicator(),
        maskType: .clear,
        status: "Loading...",
      );
      //init server client id
      await GoogleSignIn.instance.initialize(serverClientId: serverClientId);
      //init scopes of login
      final GoogleSignInAccount? accountUser = await GoogleSignIn.instance
          .authenticate(scopeHint: scopes);

      if (accountUser == null) {
        EasyLoading.dismiss(animation: true);
        EasyLoading.showError("Something happened");
        return;
      }

      //get auth info
      final GoogleSignInAuthentication googleAuth = accountUser.authentication;
      //set token credential from auth info
      final credentials = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      //sign in & get user info
      final userCredentials = await _auth.signInWithCredential(credentials);
      final userAcc = userCredentials.user;
      final loginRequestEntity = LoginRequestEntity()
        ..open_id = userAcc?.uid
        ..avatar = userAcc?.photoURL
        ..phone = userAcc?.phoneNumber
        ..name = userAcc?.displayName
        ..type = 2;
      if (userAcc != null) {
        UserItem userItem = UserItem(
          access_token: loginRequestEntity.open_id,
          token: await userAcc.getIdToken(false),
          name: loginRequestEntity.name ?? loginRequestEntity.phone,
          avatar: loginRequestEntity.avatar,
          description: loginRequestEntity.description,
          online: loginRequestEntity.online,
          type: loginRequestEntity.type,
        );
        //save to firestore
        _saveUserToFirestore(userAcc, userItem);
        //save to local db
        await UserStore.to.saveProfile(userItem);
        if (userItem.token != null) {
          await UserStore.to.setToken(userItem.token!);
        }
        EasyLoading.dismiss(animation: true);
        //go to next page
        await Get.offAllNamed(AppRoutes.Message);
      } else {
        EasyLoading.dismiss(animation: true);
        EasyLoading.showError("Something happened");
      }
    } on FirebaseAuthException catch (error) {
      EasyLoading.dismiss(animation: true);
      throw Exception(error.message);
    } catch (error) {
      final errorMessage = error.toString();

      if (errorMessage.contains('canceled') ||
          errorMessage.contains('GoogleSignInExceptionCode.canceled')) {
        EasyLoading.dismiss(animation: true);
        EasyLoading.showError(errorMessage.split(':')[1]);
        return;
      }
    }
  }

  Future<void> _saveUserToFirestore(User userAcc, UserItem userItem) async {
    await _db
        .collection("users")
        .doc(userAcc.uid)
        .set(userItem.toJson(), SetOptions(merge: true));
  }

  Future<User?> signUpWithGoogle(String email, String password) async {
    try {
      final credentials = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credentials.user;
    } on FirebaseAuthException catch (e) {
      printError(info: "Error Auth : ${e.message}");
      throw Exception(e.message ?? "Something happened");
    }
  }

  @override
  void onReady() {
    Future.delayed(
      const Duration(milliseconds: 3000),
      () => Get.offAllNamed(AppRoutes.Message),
    );
    super.onReady();
  }
}
