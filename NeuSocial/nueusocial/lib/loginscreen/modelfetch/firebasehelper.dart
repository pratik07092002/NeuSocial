import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nueusocial/createaccount/model/usermodel.dart';

class Firebasehelper {

 static Future<UserModel?> getUserModelByID(String uid) async{
  UserModel? userModel;
   DocumentSnapshot docsnap =  await FirebaseFirestore.instance.collection("Users").doc(uid).get();

  if(docsnap.data() != null){
    userModel = UserModel.fromMap(docsnap.data() as Map<String , dynamic>);
  }

  return userModel;
   }
}