import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nueusocial/Notification_Screen/bloc/notificationbloc_bloc.dart';
import 'package:nueusocial/createaccount/model/usermodel.dart';
import 'package:nueusocial/loginscreen/modelfetch/firebasehelper.dart';
import 'package:nueusocial/utils/imagegetter.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key, required this.firebaseuser, required this.userModel});
  final User firebaseuser;
  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationblocBloc()..add(FetchNotificationsEvent(adminUserId: userModel.UserId.toString())),
      child: NotificationScreenView(firebaseuser: firebaseuser, userModel: userModel),
    );
  }
}

class NotificationScreenView extends StatefulWidget {
  final User firebaseuser;
  final UserModel userModel;

  NotificationScreenView({Key? key, required this.firebaseuser, required this.userModel}) : super(key: key);

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
          child: BlocBuilder<NotificationblocBloc, NotificationblocState>(
            builder: (context, state) {
              if (state is NotificationInitial || state is NotificationLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is NotificationsLoaded) {
                return ListView.builder(
                  itemCount: state.notifications.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = state.notifications[index];

                    String comname = doc['Communityname'];
                    String sendername = doc['SenderUsername'];
                    String comid = doc['Communityid'];
                    String senderuserid = doc['SenderUserid'];
                    String requestId = doc.id;

                    return FutureBuilder<UserModel?>(
                      future: Firebasehelper.getUserModelByID(senderuserid),
                      builder: (context, userModelSnapshot) {
                        if (userModelSnapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (userModelSnapshot.hasError) {
                          return Center(child: Text("Error loading user"));
                        } else if (userModelSnapshot.hasData) {
                          UserModel? sendermod = userModelSnapshot.data;
                          String notificationStatus = '';
                          if (state.notificationStatus.containsKey(senderuserid)) {
                            notificationStatus = state.notificationStatus[senderuserid]!;
                          }

                          if (notificationStatus == 'Accepted') {
                            return Card(
                              color: Color.fromARGB(255, 35, 35, 35),
                              child: ListTile(
                                title: Text("Join Request Accepted", style: TextStyle(color: Colors.white)),
                                subtitle: Text("${sendername} has joined the community ${comname}", style: TextStyle(color: Colors.white)),
                              ),
                            );
                          } else if (notificationStatus == 'Rejected') {
                            return Card(
                              color: Color.fromARGB(255, 35, 35, 35),
                              child: ListTile(
                                title: Text("Join Request Rejected", style: TextStyle(color: Colors.white)),
                              ),
                            );
                          } else {
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
                                              sendermod!.ProfilePicture.toString(),
                                              "assets/profilecom.jpg",
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              "${sendername} has requested to join your community ${comname}",
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
                                            onPressed: () {
                                              context.read<NotificationblocBloc>().add(ClickAcceptEvent(comid: comid, senderId: senderuserid, requestId: requestId));
                                            },
                                            child: Text("Accept"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              context.read<NotificationblocBloc>().add(ClickRejectEvent(senderId: senderuserid, requestId: requestId));
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
                          }
                        } else {
                          return Center(child: Text("No user data found"));
                        }
                      },
                    );
                  },
                );
              } else {
                return Center(child: Text("No notifications found", style: TextStyle(color: Colors.white)));
              }
            },
          ),
        ),
      ),
    );
  }
}
