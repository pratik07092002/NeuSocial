import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nueusocial/CommunityRoom/model/TextModel.dart';
import 'package:nueusocial/CreateCommunityScreen/model/CommunityModel.dart';
import 'package:nueusocial/Create_Event_Screen/Create_event_Screen.dart';
import 'package:nueusocial/Create_Event_Screen/model/eventmodel.dart';
import 'package:nueusocial/create_Post_Screen/createpostui.dart';
import 'package:nueusocial/createaccount/model/usermodel.dart';
import 'package:nueusocial/utils/ScreenQuery.dart';
import 'package:rxdart/rxdart.dart';

class CommunityRoom extends StatefulWidget {
  final User firebaseuser;
  final CommunityModel communityModel;
  final UserModel userModel;

  const CommunityRoom(
      {Key? key, required this.firebaseuser, required this.communityModel, required this.userModel})
      : super(key: key);

  @override
  State<CommunityRoom> createState() => _CommunityRoomState();
}

class _CommunityRoomState extends State<CommunityRoom> {
  final ScrollController _scrollController = ScrollController();

  Stream<List<dynamic>> _combinedStream() {
    final textStream = FirebaseFirestore.instance
        .collection("Communities")
        .doc(widget.communityModel.ComId)
        .collection("TextHistory")
        .orderBy("time", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {'type': 'text', 'data': doc.data()})
            .toList());

    final eventStream = FirebaseFirestore.instance
        .collection("Communities")
        .doc(widget.communityModel.ComId)
        .collection("EventHistory")
        .orderBy("CreatedOn", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {'type': 'event', 'data': doc.data()})
            .toList());

    return CombineLatestStream.list([textStream, eventStream])
        .map((streams) => streams.expand((stream) => stream).toList());
  }

  Future<UserModel> _getUserModel(String userId) async {
    var doc = await FirebaseFirestore.instance.collection('Users').doc(userId).get();
    if (doc.exists) {
      print("User data: ${doc.data()}");
      return UserModel.fromMap(doc.data()!);
    } else {
      throw Exception("User not found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.communityModel.name.toString(),
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(widget.communityModel.Profilepic ?? ""),
        ),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/Homebackground1.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              StreamBuilder(
                stream: _combinedStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      List<dynamic> combinedData = snapshot.data as List<dynamic>;

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (_scrollController.hasClients) {
                          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                        }
                      });

                      return Expanded(
                        child: Container(
                          width: ScreenQuery.screenWidth(context) * 0.7,
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: combinedData.length,
                            itemBuilder: (context, index) {
                              var item = combinedData[index];
                              if (item['type'] == 'text') {
                                messageMod msg = messageMod.fromMap(item['data']);
                                return FutureBuilder(
                                  future: _getUserModel(msg.Senderid!.toString()),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.done) {
                                      if (snapshot.hasData) {
                                        UserModel sender = snapshot.data as UserModel;
                                        return Card(
                                          color: Color.fromARGB(255, 35, 35, 35),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              ListTile(
                                                title: Text(sender.Username.toString(),
                                                    style: TextStyle(color: Colors.white)),
                                                leading: CircleAvatar(
                                                  backgroundImage: sender.ProfilePicture != null
                                                      ? NetworkImage(sender.ProfilePicture!)
                                                      : AssetImage("assets/profile.jpg") as ImageProvider<Object>?,
                                                  radius: ScreenQuery.screenHeight(context) * .04,
                                                ),
                                              ),
                                              Container(
                                                child: Text(msg.msg.toString(),
                                                    style: TextStyle(color: Colors.white)),
                                              ),
                                              SizedBox(height: ScreenQuery.screenHeight(context) * 0.06),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return Center(child: Text("Error loading sender details"));
                                      }
                                    } else {
                                      return Center(child: CircularProgressIndicator());
                                    }
                                  },
                                );
                              } else if (item['type'] == 'event') {
                                EventModel event = EventModel.fromMap(item['data']);
                                return FutureBuilder(
                                  future: _getUserModel(event.Senderid.toString()),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.done) {
                                      if (snapshot.hasData) {
                                        UserModel creator = snapshot.data as UserModel;
                                        return Card(
                                          color: Color.fromARGB(255, 35, 35, 35),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              ListTile(
                                                title: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.purple,
                                                      border: Border.all(color: Colors.white),
                                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                                    ),
                                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                    child: Text(
                                                      "Event",
                                                      style: TextStyle(color: Colors.white, fontSize: 24),
                                                    ),
                                                  ),
                                                ),
                                                leading: CircleAvatar(
                                                  backgroundImage: creator.ProfilePicture != null
                                                      ? NetworkImage(creator.ProfilePicture!)
                                                      : AssetImage("assets/profile.jpg") as ImageProvider<Object>?,
                                                  radius: ScreenQuery.screenHeight(context) * .04,
                                                ),
                                              ),
                                              Container(
                                                child: Text(event.desc.toString(),
                                                    style: TextStyle(color: Colors.white)),
                                              ),
                                              Text(
                                                  "${event.StartDate!.day}/${event.StartDate!.month}/${event.StartDate!.year} - ${event.EndDate!.day}/${event.EndDate!.month}/${event.EndDate!.year}",
                                                  style: TextStyle(color: Colors.white)),
                                              SizedBox(height: ScreenQuery.screenHeight(context) * 0.06),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return Center(child: Text("Error loading event creator details"));
                                      }
                                    } else {
                                      return Center(child: CircularProgressIndicator());
                                    }
                                  },
                                );
                              }
                              return Container();
                            },
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text("Error"),
                      );
                    } else {
                      return Center(
                        child: Text("No data"),
                      );
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Container(
                            height: ScreenQuery.screenHeight(context) * 0.85,
                            child: CreateEventScreen(
                              communityModel: widget.communityModel,
                              usermod: widget.userModel,
                              firebaseuser: widget.firebaseuser,
                            ),
                          ),
                          isScrollControlled: true,
                        );
                      },
                      child: Text("Event"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Container(
                            height: ScreenQuery.screenHeight(context) * 0.85,
                            child: CreatePostScreen(
                              communityModel: widget.communityModel,
                              firebaseuser: widget.firebaseuser,
                              userModel: widget.userModel,
                            ),
                          ),
                          isScrollControlled: true,
                        );
                      },
                      child: Text("Post"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
