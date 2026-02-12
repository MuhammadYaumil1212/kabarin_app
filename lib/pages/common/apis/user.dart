import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kabarin_app/pages/common/entities/entities.dart';
import 'package:kabarin_app/pages/common/utils/utils.dart';

import '../store/user.dart';

class UserAPI {
  static Future<UserLoginResponseEntity> Login({
    LoginRequestEntity? params,
  }) async {
    var response = await HttpUtil().post(
      'api/login',
      queryParameters: params?.toJson(),
    );
    return UserLoginResponseEntity.fromJson(response);
  }

  static Future<UserData?> getProfile() async {
    DocumentSnapshot docSnap = await FirebaseFirestore.instance
        .collection("users")
        .doc(UserStore.to.getAccessToken())
        .get();
    if (docSnap.exists) {
      return UserData.fromFirestore(
        docSnap as DocumentSnapshot<Map<String, dynamic>>,
        null,
      );
    } else {
      return null;
    }
  }

  static Future<BaseResponseEntity> UpdateProfile({
    LoginRequestEntity? params,
  }) async {
    var response = await HttpUtil().post(
      'api/update_profile',
      queryParameters: params?.toJson(),
    );
    return BaseResponseEntity.fromJson(response);
  }
}
