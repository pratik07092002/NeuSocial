import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nueusocial/CommunityRoom/model/TextModel.dart';
import 'package:nueusocial/CreateCommunityScreen/model/CommunityModel.dart';
import 'package:nueusocial/createaccount/model/usermodel.dart';
import 'package:nueusocial/main.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key, required this.firebaseuser, required this.userModel, required this.communityModel});
  final User firebaseuser;
  final UserModel userModel;
  final CommunityModel communityModel;

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _messagecontroller = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.cancel , color: Colors.white,),
        ),
        title: Text('Create Post' , style: TextStyle(color: Colors.purple.shade100),),
        actions: [
          IconButton(
            onPressed: () {
              // Add your send logic here
            String message =  _messagecontroller.text.trim();
            messageMod newmsg = messageMod(
              Sender: widget.userModel.name , 
              msg: message , 
              msgid: uuid.v1() , 
              time: DateTime.now() , 
              Senderid: widget.userModel.UserId
            );

            FirebaseFirestore.instance.collection("Communities").doc(widget.communityModel.ComId).collection("TextHistory").doc(newmsg.msgid).set(newmsg.tomap());
Navigator.pop(context);
            },
            icon: Icon(Icons.send , color: Colors.purple,),
          ),
        ],
      ),
      body: Container(
         decoration: BoxDecoration(
           
            color: Colors.black
          ),
        child: SafeArea(
          
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 8),
                      child: CircleAvatar(
                        child: Icon(Icons.verified_user),
                      ),
                    ),
                    SizedBox(width: 10),
                    Flexible(
                      child: TextField(
                        controller: _messagecontroller,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "What's Happening?",
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.album, size: 40 , color: Colors.purple.shade400,),
            Icon(Icons.camera, size: 40 , color: Colors.purple.shade400,),
          ],
        ),
      ),
    );
  }
}
