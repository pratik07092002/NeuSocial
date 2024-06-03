import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nueusocial/createaccount/model/usermodel.dart';

class NotificationScreen extends StatefulWidget {
  final User firebaseuser;
  final UserModel userModel;

  NotificationScreen({Key? key, required this.firebaseuser, required this.userModel})
      : super(key: key);

  @override
  State<NotificationScreen> createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Homebackground1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("JoinRequests")
                    .where("AdminUserid", isEqualTo: widget.userModel.UserId)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error"));
                  } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index)  {
                          DocumentSnapshot doc = snapshot.data!.docs[index];
                        
                          String Comname = doc['Communityname'];
                          String Sendername = doc['SenderUsername'];
                          String comid = doc['Communityid'];
                          String Senderuserid = doc['SenderUserid'];
                          return Card(
                           
                              child: ListTile(
                              
                                title: Text("JoinRequest") , 
                                subtitle: Column(children: [
                                   Text("${Sendername}  has requested to Join Your Community ${Comname} "),
                                  
                                 Row(
  children: [
    TextButton(
      onPressed: () async {
        DocumentReference communityRef = FirebaseFirestore.instance.collection("Communities").doc(comid);
        
        FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot communityDoc = await transaction.get(communityRef);
          
          Map<String, dynamic> members = Map<String, dynamic>.from(communityDoc['Members']);

          if (!members.containsKey(Senderuserid)) {
            members[Senderuserid] = true;

            transaction.update(communityRef, {'Members.${Senderuserid}': true});
          }
        });
      },
      child: Text("Accept"),
    ),
    TextButton(
      onPressed: () {

      },
      child: Text("Decline"),
    ),
  ],
)



                                 ],),
                              ),
                            );
                          
                        },
                      ),
                    );
                  } else {
                    // No data found
                    return Center(child: Text("No notifications found" ));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
