import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nueusocial/CreateCommunityScreen/model/CommunityModel.dart';

Future<List<CommunityModel>> fetchCommunitiesForMember(String userId) async {
  List<CommunityModel> communities = [];

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("Communities")
        .where("Members.$userId", isEqualTo: true)
        .get();

    querySnapshot.docs.forEach((doc) {
      CommunityModel community = CommunityModel.fromMap(doc.data() as Map<String, dynamic>);
      
      communities.add(community);

    });

    return communities;
  } catch (e) {
    // Handle error
    print("Error fetching communities: $e");
    return [];
  }
}
