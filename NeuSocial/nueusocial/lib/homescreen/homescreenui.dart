import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nueusocial/CommunityDisplay/Community_Profile_Screen.dart';
import 'package:nueusocial/CreateCommunityScreen/model/CommunityModel.dart';
import 'package:nueusocial/createaccount/model/usermodel.dart';
import 'package:nueusocial/homescreen/model/fetchcom.dart';

class CommunityList extends StatelessWidget {
  final User userCredential;
  final UserModel userModel;

  const CommunityList({Key? key, required this.userCredential, required this.userModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/Homebackground1.jpg'), fit: BoxFit.cover )),
        child: SafeArea(
          
          child: FutureBuilder<List<CommunityModel>>(
            future: fetchCommunitiesForMember(userCredential.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No communities Joined.' , style: TextStyle(color: Colors.white),),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final community = snapshot.data![index];
                    return ListTile(
  title: Text(
    community.name.toString(),
    style: TextStyle(color: Colors.white),
  ),
  subtitle: Text(community.Type.toString()),
  leading: CircleAvatar(
  backgroundImage: 
       getImageProvider(community.Profilepic)
),

  onTap: () => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CommunityDisplay(
        userCredential: userCredential,
        usermod: userModel,
        communityModel: community,
      ),
    ),
  ),
);

                  },
                );
              }
            },
          ),
        ),
      ),
      
    );
  }
  ImageProvider getImageProvider(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return NetworkImage(imageUrl);
    } else {
      return AssetImage("assets/profilecom.jpg");
    }
  }
}
