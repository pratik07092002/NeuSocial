import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nueusocial/CommunityDisplay/model/requestmodel.dart';
import 'package:nueusocial/CreateCommunityScreen/model/CommunityModel.dart';
import 'package:nueusocial/createaccount/model/usermodel.dart';

class JoinCommunityy{
  Future<void> SendRequest(UserModel userModel , User firebaseuser , CommunityModel communityModel) async {


    RequestModel reqmod = RequestModel(AdminUserid: communityModel.Admin , SenderUserid: userModel.UserId , isAccepted: false , Communityname: communityModel.name  , SenderUsername: userModel.Username  , Communityid: communityModel.ComId);

    FirebaseFirestore.instance.collection("JoinRequests").doc(reqmod.SenderUserid).set(reqmod.tomap());
    
  }
}