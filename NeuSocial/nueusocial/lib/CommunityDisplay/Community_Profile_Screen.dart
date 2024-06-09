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
import 'package:nueusocial/utils/imagegetter.dart';

class CommunityDisplay extends StatelessWidget {
  final User userCredential;
  final UserModel usermod;
  final CommunityModel communityModel;
  const CommunityDisplay(
      {super.key,
      required this.userCredential,
      required this.usermod,
      required this.communityModel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommunityDisplayBloc()
        ..add(CheckUserInMembersEvent(
            userid: usermod.UserId.toString(),
            comid: communityModel.ComId.toString())),
      child: CommunityDisplayView(
        communityModel: communityModel,
        userCredential: userCredential,
        usermod: usermod,
      ),
    );
  }
}

class CommunityDisplayView extends StatefulWidget {
  final User userCredential;
  final UserModel usermod;
  final CommunityModel communityModel;

  const CommunityDisplayView({
    Key? key,
    required this.userCredential,
    required this.usermod,
    required this.communityModel,
  }) : super(key: key);

  @override
  State<CommunityDisplayView> createState() => _CommunityDisplayViewState();
}

class _CommunityDisplayViewState extends State<CommunityDisplayView> {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CommunityDisplayBloc>(context);
    return Scaffold(
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
                        image:
                            ImageProviderUtil.getImageProvider(widget.communityModel.Profilepic , "assets/profilecom.jpg"),
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
                    return BlocListener<CommunityDisplayBloc,
                        CommunityDisplayState>(
                      listener: (context, state) {
                        // TODO: implement listener
                        if (state is ComunityPageOpenState) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CommunityRoom(
                                    firebaseuser: widget.userCredential,
                                    communityModel: widget.communityModel,
                                    userModel: widget.usermod),
                              ));
                        }
                      },
                      child: ElevatedButton(
                        onPressed: () {
                          bloc.add(ClickButtononOpenEvent(
                              communityModel: widget.communityModel,
                              userModel: widget.usermod,
                              usercred: widget.userCredential));
                        },
                        child: Text("Open"),
                      ),
                    );
                  } else if (state is CommunityNotMemberState) {
                    return BlocListener<CommunityDisplayBloc, CommunityDisplayState>(
                      listener: (context, state) {
                        // TODO: implement listener
                        if(state is ComunityJoinRequestSentState){
                           ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("Request Sent"),
    ),
  );
                        }
                      },
                      child: ElevatedButton(
                        onPressed: () {
                          bloc.add(ClickRequestSentEvent(userModel: widget.usermod,
                           usercred: widget.userCredential,
                            communityModel: widget.communityModel));
                        },
                        child: Text("Join"),
                      ),
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
    );
  }

  
}
