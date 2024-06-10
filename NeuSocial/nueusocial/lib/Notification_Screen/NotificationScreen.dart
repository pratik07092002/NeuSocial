import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nueusocial/Notification_Screen/bloc/notificationbloc_bloc.dart';
import 'package:nueusocial/createaccount/model/usermodel.dart';
import 'package:nueusocial/loginscreen/modelfetch/firebasehelper.dart';
import 'package:nueusocial/utils/imagegetter.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => NotificationblocBloc(),
    child: NotificationScreen(), );
  }
}

class NotificationScreenView extends StatefulWidget {
  final User firebaseuser;
  final UserModel userModel;

  NotificationScreenView({Key? key, required this.firebaseuser, required this.userModel})
      : super(key: key);

  @override
  State<NotificationScreenView> createState() => NotificationScreenViewState();
}

class NotificationScreenViewState extends State<NotificationScreenView> {
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("JoinRequests")
                    .where("AdminUserid", isEqualTo: widget.userModel.UserId)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/Homebackground1.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error"));
                  } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot doc = snapshot.data!.docs[index];

                          String Comname = doc['Communityname'];
                          String Sendername = doc['SenderUsername'];
                          String comid = doc['Communityid'];
                          String Senderuserid = doc['SenderUserid'];

                          return FutureBuilder<UserModel?>(
                            future: Firebasehelper.getUserModelByID(Senderuserid),
                            builder: (context, userModelSnapshot) {
                              if (userModelSnapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              } else if (userModelSnapshot.hasError) {
                                return Center(child: Text("Error loading user"));
                              } else if (userModelSnapshot.hasData) {
                                UserModel? Sendermod = userModelSnapshot.data;
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    color: Color.fromARGB(255, 35, 35, 35),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            title: Text("Join Request", style: TextStyle(color: Colors.white)),
                                          ),
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: ImageProviderUtil.getImageProvider(
                                                  Sendermod!.ProfilePicture.toString(),
                                                  "assets/profilecom.jpg",
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  "${Sendername} has requested to join your community ${Comname}",
                                                  style: TextStyle(color: Colors.white),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              TextButton(
                                                onPressed: () async {
                                           context.read<NotificationblocBloc>().add(ClickAcceptEvent(commod:  ));
                                                },
                                                child: Text("Accept"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  // Decline logic here
                                           context.read<NotificationblocBloc>().add(ClickRejectEvent());

                                                },
                                                child: Text("Decline"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return Center(child: Text("No user data found"));
                              }
                            },
                          );
                        },
                      ),
                    );
                  } else {
                    // No data found
                    return Center(child: Text("No notifications found", style: TextStyle(color: Colors.white)));
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
