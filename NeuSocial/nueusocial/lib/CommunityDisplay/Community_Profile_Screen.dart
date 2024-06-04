import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nueusocial/CommunityDisplay/bloc/community_display_bloc.dart';
import 'package:nueusocial/CommunityDisplay/bloc/community_display_event.dart';
import 'package:nueusocial/CommunityDisplay/bloc/community_display_state.dart';
import 'package:nueusocial/CommunityRoom/Communityroom.dart';
import 'package:nueusocial/CreateCommunityScreen/model/CommunityModel.dart';
import 'package:nueusocial/createaccount/model/usermodel.dart';
import 'package:nueusocial/utils/CardWidgetDisplay.dart';
import 'package:nueusocial/utils/ScreenQuery.dart';
import 'package:nueusocial/utils/ismember.dart';
import 'package:nueusocial/utils/joinCommunity.dart';

class CommunityDisplay extends StatefulWidget {
  final User userCredential;
  final UserModel usermod;
  final CommunityModel communityModel;

  const CommunityDisplay({
    Key? key,
    required this.userCredential,
    required this.usermod,
    required this.communityModel,
  }) : super(key: key);

  @override
  State<CommunityDisplay> createState() => _CommunityDisplayState();
}

class _CommunityDisplayState extends State<CommunityDisplay> {
  late CommunityDisplayBloc _communityDisplayBloc;

  @override
  void initState() {
    super.initState();
    _communityDisplayBloc = CommunityDisplayBloc()
      ..add(CheckUserInMembersEvent(
        userid: widget.userCredential.uid,
        comid: widget.communityModel.ComId.toString(),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _communityDisplayBloc,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 35, 35, 35),
          title: Text(
            widget.communityModel.name.toString(),
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      widget.communityModel.name.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: ScreenQuery.screenHeight(context) * 0.01,
                  ),
                  Center(
                    child: Container(
                      height: ScreenQuery.screenHeight(context) * 0.2,
                      width: ScreenQuery.screenWidth(context) * 0.7,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: getImageProvider(widget.communityModel.Profilepic),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          style: BorderStyle.solid,
                          color: Colors.purple,
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 40,
                            color: Colors.purple,
                            spreadRadius: 10,
                          ),
                        ],
                        borderRadius: BorderRadius.all(
                          Radius.elliptical(40, 60),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenQuery.screenHeight(context) * 0.04,
                  ),
                ],
              ),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      tileColor: Color.fromARGB(255, 35, 35, 35),
                      title: Text(
                        widget.communityModel.name.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        widget.communityModel.desc.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                color: Color.fromARGB(255, 35, 35, 35),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ShowField(
                          name: "Members",
                          value: widget.communityModel.Members != null
                              ? widget.communityModel.Members!.length.toString()
                              : "N/A",
                        ),
                        ShowField(
                          name: "Admin",
                          value: widget.communityModel.Adminname != null
                              ? widget.communityModel.Adminname.toString()
                              : "N/A",
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenQuery.screenHeight(context) * 0.05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ShowField(
                          name: "Status",
                          value: widget.communityModel.ComStatus.toString(),
                        ),
                        ShowField(
                          name: "Type",
                          value: widget.communityModel.Type.toString(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: ScreenQuery.screenHeight(context) * 0.05,
              ),
              Center(
                child: BlocBuilder<CommunityDisplayBloc, CommunityDisplayState>(
                  builder: (context, state) {
                    if (state is CommunityMemberState) {
                      return ElevatedButton(
  onPressed: () async {
    DocumentReference communityRef = FirebaseFirestore.instance.collection("Communities").doc(widget.communityModel.ComId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot communityDoc = await transaction.get(communityRef);

      if (communityDoc.exists) {
        Map<String, dynamic> members = Map<String, dynamic>.from(communityDoc['Members']);

        if (!members.containsKey(widget.usermod.UserId)) {
          members[widget.usermod.UserId.toString()] = true;
          transaction.update(communityRef, {'Members.${widget.usermod.UserId}': true});
        }
      }
    }).then((value) =>  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommunityRoom(
          communityModel: widget.communityModel,
          firebaseuser: widget.userCredential,
          userModel: widget.usermod,
        ),
      ),
    ));

    
  },
  child: Text("Open"),
);

                    } else if (state is CommunityNotMemberState) {
                      return ElevatedButton(
                        onPressed: () async {
                          if (widget.communityModel.ComStatus.toString() == "Private")  {
                            bool isUsermem = await isUserMember(widget.usermod.toString(), widget.communityModel.ComId.toString());
                            if(isUsermem == true){
 Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CommunityRoom(
                                  communityModel: widget.communityModel,
                                  firebaseuser: widget.userCredential,
                                  userModel: widget.usermod,
                                ),
                              ),
                            );
                            }
                          } else {
                             JoinCommunityy joincom = JoinCommunityy();
                            joincom.SendRequest(widget.usermod, widget.userCredential, widget.communityModel);
                           
                          }
                        },
                        child: Text("Join"),
                      );
                    } else {
                      return ElevatedButton(
                        onPressed: null,
                        child: Text("Open"),
                      );
                    }
                  },
                ),
              ),
            ],
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
