import 'package:get/get.dart';

import '../../common/entities/contact.dart';

class ContactState {
  RxList<ContactItem> contacts = <ContactItem>[].obs;
  var onlineStatus = false;
}
