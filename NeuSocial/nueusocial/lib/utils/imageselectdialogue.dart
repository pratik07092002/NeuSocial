import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nueusocial/createaccount/model/usermodel.dart';

class DisplayDialoguescreen {
  File? imageFile;

  Future<void> selectImage(ImageSource source, BuildContext context , User usercred , UserModel usermod) async {
    try {
      XFile? pickedImg = await ImagePicker().pickImage(source: source);
      if (pickedImg != null) {
        File? croppedFile = await cropImage(pickedImg);
        if (croppedFile != null) {
          imageFile = croppedFile;
          // Handle the cropped file (e.g., upload or display it)
        } else {
          // Handle case where cropping was cancelled or failed
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image cropping failed or cancelled')));
        }
      } else {
        // Handle case where no image was picked
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No image selected')));
      }
    } catch (e) {
      // Handle errors here, such as permissions denied or no image picked
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error picking or cropping image: $e')));
    }

      if (imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No image selected for upload')));
      return;
    }

    try {
      UploadTask uploadTask = FirebaseStorage.instance.ref("ProfilePictures").child(usercred.uid).putFile(imageFile!);
      TaskSnapshot snapshot = await uploadTask;
      String imgurl = await snapshot.ref.getDownloadURL();

      usermod.ProfilePicture = imgurl;

      await FirebaseFirestore.instance.collection("Users").doc(usermod.UserId).set(usermod.toMap());

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile picture uploaded successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error uploading image: $e')));
    }
  }

  Future<File?> cropImage(XFile file) async {
    try {
      CroppedFile? croppedImg = await ImageCropper().cropImage(
        sourcePath: file.path,
        compressQuality: 20,
      );

      if (croppedImg != null) {
        return File(croppedImg.path);
      }
    } catch (e) {
      // Handle errors here, such as cropping failed
      debugPrint('Error cropping image: $e');
    }
    return null;
  }

  void displayDialogue(BuildContext context , User usercred , UserModel userModel ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Choose an option"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.album_sharp),
                title: Text("Select from Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.gallery, context , usercred , userModel );
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("Click by Camera"),
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.camera, context , usercred , userModel );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  
}
