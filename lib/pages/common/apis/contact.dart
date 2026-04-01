import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kabarin_app/pages/common/entities/entities.dart';

class ContactAPI {
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

  static Future<ContactItem?> getContactById(String docId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
          .instance
          .collection('contacts')
          .doc(docId)
          .get();
      if (doc.exists) {
        return ContactItem.fromFirestore(doc, null);
      }
      return null;
    } catch (e) {
      print("Error mengambil data kontak: $e");
      return null;
    }
  }
}
