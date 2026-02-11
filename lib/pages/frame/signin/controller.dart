import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kabarin_app/pages/common/routes/names.dart';
import 'package:kabarin_app/pages/frame/message/state.dart';

import '../../common/entities/user.dart';

class SignInController extends GetxController {
  SignInController();
  final state = MessageState();
  final scopes = ['email', 'profile'];
  final serverClientId =
      "1030142167543-hme9aqvovher04ki3j32le10044luv06.apps.googleusercontent.com";
  final _auth = FirebaseAuth.instance;

  Future<void> signInWithGoogle() async {
    try {
      //init server client id
      await GoogleSignIn.instance.initialize(serverClientId: serverClientId);
      //init scopes of login
      final GoogleSignInAccount accountUser = await GoogleSignIn.instance
          .authenticate(scopeHint: scopes);
      //get auth info
      final GoogleSignInAuthentication googleAuth = accountUser.authentication;
      //set token credential from auth info
      final credentials = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      //sign in & get user info
      final userCredentials = await _auth.signInWithCredential(credentials);
      final userAcc = userCredentials.user;
      LoginRequestEntity loginRequestEntity = LoginRequestEntity();
      loginRequestEntity.avatar = userAcc?.photoURL;
      loginRequestEntity.email = userAcc?.email;
      loginRequestEntity.name = userAcc?.displayName;
      loginRequestEntity.open_id = userAcc?.uid;
      loginRequestEntity.type = 2;
    } on FirebaseAuthException catch (error) {
      throw Exception(error.message);
    }
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

  void signOut() async {
    await _auth.signOut();
    await GoogleSignIn.instance.signOut();
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
