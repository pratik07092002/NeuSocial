import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> isUserMember(String userId, String communityId) async {
  try {
    DocumentSnapshot communityDoc = await FirebaseFirestore.instance
        .collection("Communities")
        .doc(communityId)
        .get();

    if (communityDoc.exists) {
      Map<String, dynamic> members = communityDoc.get('Members') as Map<String, dynamic>;
      return members.containsKey(userId) && members[userId] == true;
    } else {
      return false;
    }
  } catch (e) {
    print("Error: $e");
    return false;
  }
}
