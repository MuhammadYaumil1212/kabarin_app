import 'dart:convert';

import 'package:get/get.dart';
import 'package:kabarin_app/pages/common/entities/entities.dart';
import 'package:kabarin_app/pages/common/routes/names.dart';
import 'package:kabarin_app/pages/common/services/services.dart';
import 'package:kabarin_app/pages/common/values/values.dart';

import '../apis/user.dart';

class UserStore extends GetxController {
  static UserStore get to => Get.find();

  final _isLogin = false.obs;

  String token = '';
  String accessToken = '';

  final _profile = UserItem().obs;

  bool get isLogin => _isLogin.value;
  UserItem get profile => _profile.value;
  bool get hasToken => token.isNotEmpty;
  bool get hasAccessToken => accessToken.isNotEmpty;
  String getAccessToken() =>
      StorageService.to.getString(STORAGE_USER_ACCESS_TOKEN_KEY);

  @override
  void onInit() {
    super.onInit();
    token = StorageService.to.getString(STORAGE_USER_TOKEN_KEY);
    var profileOffline = StorageService.to.getString(STORAGE_USER_PROFILE_KEY);
    if (profileOffline.isNotEmpty) {
      _isLogin.value = true;
      _profile(UserItem.fromJson(jsonDecode(profileOffline)));
    }
  }

  Future<void> setToken(String value) async {
    await StorageService.to.setString(STORAGE_USER_TOKEN_KEY, value);
    token = value;
  }

  Future<void> setAccessToken(String value) async {
    await StorageService.to.setString(STORAGE_USER_ACCESS_TOKEN_KEY, value);
    accessToken = value;
  }

  Future<String> getProfile() async {
    if (token.isEmpty) return "";
    var result = await UserAPI.getProfile();
    if (result == null) return "";
    var user = UserItem()
      ..access_token = result.token
      ..name = result.name
      ..avatar = result.avatar
      ..description = result.description;

    _profile(user);
    _isLogin.value = true;
    return StorageService.to.getString(STORAGE_USER_PROFILE_KEY);
  }

  Future<void> saveProfile(UserItem profile) async {
    _isLogin.value = true;
    StorageService.to.setString(STORAGE_USER_PROFILE_KEY, jsonEncode(profile));
    _profile(profile);
    setToken(profile.access_token!);
  }

  Future<void> onLogout() async {
    // if (_isLogin.value) await UserAPI.logout();
    await StorageService.to.remove(STORAGE_USER_TOKEN_KEY);
    await StorageService.to.remove(STORAGE_USER_PROFILE_KEY);
    _isLogin.value = false;
    token = '';
    Get.offAllNamed(AppRoutes.SIGN_IN);
  }
}
