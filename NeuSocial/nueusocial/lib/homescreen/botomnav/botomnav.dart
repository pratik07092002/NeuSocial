import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nueusocial/CreateCommunityScreen/createcomunity.dart';
import 'package:nueusocial/SearchComunity/JoinCommunity.dart';
import 'package:nueusocial/createaccount/model/usermodel.dart';
import 'package:nueusocial/homescreen/botomnav/bloc/botnav_bloc.dart';
import 'package:nueusocial/homescreen/botomnav/bloc/botnav_event.dart';
import 'package:nueusocial/homescreen/botomnav/bloc/botnav_state.dart';
import 'package:nueusocial/homescreen/homescreenui.dart';
import 'package:nueusocial/loginscreen/loginscreenui.dart';
import 'package:nueusocial/Notification_Screen/NotificationScreen.dart';
import 'package:nueusocial/sharedpref%20screen.dart';
import 'package:nueusocial/utils/ScreenQuery.dart';

BottomNavBloc bottomNavBloc = BottomNavBloc();

class BotoomNav extends StatelessWidget {
  final User userCredential;
  final UserModel userMod;

  const BotoomNav({super.key, required this.userCredential, required this.userMod});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bottomNavBloc,
      child: BotoomNavView(userCredential: userCredential, userMod: userMod),
    );
  }
}

class BotoomNavView extends StatefulWidget {
  final User userCredential;
  final UserModel userMod;

  const BotoomNavView({super.key, required this.userCredential, required this.userMod});

  @override
  _BotoomNavViewState createState() => _BotoomNavViewState();
}

class _BotoomNavViewState extends State<BotoomNavView> {
  File? imageFile;
  late List<Widget> screens;

  void selectImage(ImageSource source) async {
    XFile? pickedImg = await ImagePicker().pickImage(source: source);
    if (pickedImg != null) {
      cropImage(pickedImg);
    }
  }

  void cropImage(XFile file) async {
    CroppedFile? croppedImg = await ImageCropper().cropImage(
      sourcePath: file.path,
      compressQuality: 20,
    );

    if (croppedImg != null) {
      setState(() {
        imageFile = File(croppedImg.path);
      });

      uploadData();
    }
  }

  void displayDialogue() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Choose an option"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                trailing: Icon(Icons.album_sharp),
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.gallery);
                },
                title: Text("Select from Gallery"),
              ),
              ListTile(
                trailing: Icon(Icons.camera_alt),
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.camera);
                },
                title: Text("Click by Camera"),
              ),
            ],
          ),
        );
      },
    );
  }

  void uploadData() async {
    try {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref("ProfilePictures")
          .child(widget.userCredential.uid)
          .putFile(imageFile!);
      TaskSnapshot snapshot = await uploadTask;
      String imgUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        widget.userMod.ProfilePicture = imgUrl;
      });

      await FirebaseFirestore.instance
          .collection("Users")
          .doc(widget.userMod.UserId)
          .update(widget.userMod.toMap());
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    screens = [
      CommunityList(userCredential: widget.userCredential, userModel: widget.userMod),
      NotificationScreen(firebaseuser: widget.userCredential, userModel: widget.userMod)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("Neu", style: TextStyle(color: Colors.white)),
            Text("Social", style: TextStyle(color: Colors.purple[300])),
          ],
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.purple[300]),
      ),
      body: BlocBuilder<BottomNavBloc, BottomNavState>(
        builder: (context, state) {
          if (state is PageLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is PageLoaded) {
            return IndexedStack(
              index: state.index,
              children: screens,
            );
          }
          return IndexedStack(
            index: 0,
            children: screens,
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<BottomNavBloc, BottomNavState>(
        builder: (context, state) {
          int currentIndex = 0;
          if (state is PageLoaded) {
            currentIndex = state.index;
          }
          return BottomNavigationBar(
            backgroundColor: Colors.black,
            selectedItemColor: Colors.purple,
            unselectedItemColor: Colors.grey.shade500,
            unselectedFontSize: 10,
            selectedFontSize: 15,
            currentIndex: currentIndex,
            onTap: (index) {
              if (!bottomNavBloc.isClosed) {
                bottomNavBloc.add(PageTappedEvent(index));
              }
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.list), label: "Communities"),
              BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notification"),
            ],
          );
        },
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/Homebackground1.jpg'),
                fit: BoxFit.fill),
          ),
          child: ListView(
            children: [
              DrawerHeader(
                child: Column(
                  children: [
                    CupertinoButton(
                      child: CircleAvatar(
                        backgroundImage: widget.userMod.ProfilePicture != null
                            ? NetworkImage(widget.userMod.ProfilePicture!)
                            : AssetImage("assets/profile.jpg") as ImageProvider<Object>?,
                        radius: ScreenQuery.screenHeight(context) * .04,
                      ),
                      onPressed: () {
                        displayDialogue();
                      },
                    ),
                    SizedBox(height: ScreenQuery.screenHeight(context) * 0.0055),
                    Text(
                      widget.userMod.Username.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text("Join Community", style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchCommunity(
                      usermod: widget.userMod,
                      firebaseuser: widget.userCredential,
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text("Create Community", style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateCommunityScreen(
                      userCredential: widget.userCredential,
                      usermodel: widget.userMod,
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text("Create Event", style: TextStyle(color: Colors.white)),
              ),
              ListTile(
                title: Text("Your Interestes", style: TextStyle(color: Colors.white)), 
                onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => SelectedCommunitiesScreen(),)),
              ),
              ListTile(
                title: Text("Logout", style: TextStyle(color: Colors.white)),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
