import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> isUserMember(String userId, String communityId) async {
  try {
    DocumentSnapshot communityDoc = await FirebaseFirestore.instance
        .collection("Communities")
        .doc(communityId)
        .get();
        
    if (communityDoc.exists) {
      Map<String, dynamic> data = communityDoc.data() as Map<String, dynamic>;
      if (data.containsKey('Members') && data['Members'].containsKey(userId)) {
        print("Member true");
        return true;
      } else {
        print("Member false");
        return false;
      }
    } else {
      print("Community document does not exist");
      return false;
    }
  } catch (e) {
    print("Error: $e");
    return false; // Handle error gracefully
  }
}
