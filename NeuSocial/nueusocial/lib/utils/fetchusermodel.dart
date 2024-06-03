import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nueusocial/createaccount/model/usermodel.dart';

class PageHelper {
  static Future<UserModel?> getUserbyid(String uid) async {
    UserModel? userModel;
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection("Users")
        .where("UserId", isEqualTo: uid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      userModel = UserModel.fromMap(querySnapshot.docs.first.data());
    }

    return userModel;
  }
}