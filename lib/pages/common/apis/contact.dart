import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kabarin_app/pages/common/entities/entities.dart';

class ContactAPI {
  // static Future<ContactResponseEntity> post_contact() async {
  //   var response = await HttpUtil().post('api/contact');
  //   return ContactResponseEntity.fromJson(response);
  // }

  static Future<List<ContactItem>?> postContact() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('contacts')
        .get();
    List<ContactItem> allData = querySnapshot.docs.map((doc) {
      return ContactItem.fromFirestore(
        doc as DocumentSnapshot<Map<String, dynamic>>,
        null,
      );
    }).toList();
    return allData;
  }
}
