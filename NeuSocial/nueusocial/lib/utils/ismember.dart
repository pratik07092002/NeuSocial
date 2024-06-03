import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> isUserMember(String userId, String communityId) async {
  try {
    QuerySnapshot communityDoc = await FirebaseFirestore.instance
        .collection("Communities")
        .where("Members.${userId}" , isEqualTo: true).get();

      if(communityDoc.docs.isNotEmpty){
        return true;
      }else{
        return false;
      }
  } catch (e) {
    print("Error: $e");
    return false; // Handle error gracefully
  }
}