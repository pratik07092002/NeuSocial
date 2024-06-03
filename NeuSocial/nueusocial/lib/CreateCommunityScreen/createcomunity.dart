import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nueusocial/CommunityDisplay/Community_Profile_Screen.dart';
import 'package:nueusocial/CreateCommunityScreen/bloc/createcom_bloc.dart';
import 'package:nueusocial/createaccount/model/usermodel.dart';
import 'package:nueusocial/main.dart';
import 'package:nueusocial/utils/ScreenQuery.dart';
import 'package:nueusocial/widgets/customtextform.dart';

class CreateCommunityScreen extends StatefulWidget {
  final UserModel usermodel;
  final User userCredential;

  CreateCommunityScreen({super.key, required this.usermodel, required this.userCredential});

  @override
  _CreateCommunityScreenState createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends State<CreateCommunityScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _selectedImage;

  final List<String> types = ['Sports', 'Cinema', 'Music', 'Football', 'Tennis', 'Cricket'];
  final List<String> comStatus = ['Public', 'Private'];

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(sourcePath: pickedFile.path , compressQuality: 20);
      if (croppedFile != null) {
        setState(() {
          _selectedImage = File(croppedFile.path);
        });
      }
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      String fileName = uuid.v1();
      Reference storageRef = FirebaseStorage.instance.ref().child('community_images/$fileName');
      UploadTask uploadTask = storageRef.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreatecomBloc(),
      child: Builder(
        builder: (context) {
          return BlocListener<CreatecomBloc, CreatecomState>(
            listener: (context, state) {
              if (state is CreatecomSubmitState) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CommunityDisplay(
                      userCredential: state.userCredential,
                      usermod: state.usermod,
                      communityModel: state.communityModel,
                    ),
                  ),
                );
              }
            },
            child: Scaffold(
              appBar: AppBar(title: Text("Create Community" , style: TextStyle(color: Colors.white),) , backgroundColor: Colors.black, iconTheme: IconThemeData(color: Colors.white),),
              body: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/Homebackground1.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SafeArea(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              CupertinoButton(
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: _selectedImage != null
                                      ? FileImage(_selectedImage!)
                                      : AssetImage('assets/ComLogo.webp') as ImageProvider,
                                ),
                                onPressed: _selectImage,
                              ),
                              SizedBox(height: 20),
                              CustomTextForm(
                                hinttext: "Enter name Of Community",
                                prefixicon: Icon(Icons.people_alt),
                                obscure: false,
                                controller: _nameController,
                              ),
                              SizedBox(height: ScreenQuery.screenHeight(context) * 0.04),
                              CustomTextForm(
                                hinttext: "Description",
                                prefixicon: Icon(Icons.description),
                                obscure: false,
                                controller: _descriptionController,
                                maxkength: 100,
                                maxlines: 4,
                              ),
                              BlocBuilder<CreatecomBloc, CreatecomState>(
                                builder: (context, state) {
                                  String selectedType = types[0];
                                  String selectedStatus = comStatus[0];

                                  if (state is DropdownSelectedState) {
                                    selectedType = state.selectedItem;
                                    selectedStatus = state.statusSelected;
                                  }

                                  return Column(
                                    children: [
                                      DropdownButton<String>(
                                        value: selectedType,
                                        style: TextStyle(color: Colors.white),
                                        dropdownColor: Colors.black,
                                        hint: Text("Type" , style: TextStyle(color: Colors.white),),
                                        items: types.map((String type) {
                                          return DropdownMenuItem<String>(
                                            value: type,
                                            child: Text(type),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          if (value != null) {
                                            context.read<CreatecomBloc>().add(DropdownItemSelected(value));
                                          }
                                        },
                                      ),
                                      DropdownButton<String>(
                                        value: selectedStatus,
                                        style: TextStyle(color: Colors.white),
                                        dropdownColor: Colors.black,
                                        hint: Text("Status"),
                                        items: comStatus.map((String status) {
                                          return DropdownMenuItem<String>(
                                            value: status,
                                            child: Text(status),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          if (value != null) {
                                            context.read<CreatecomBloc>().add(DropdownStatusItemSelected(value));
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ),
                              SizedBox(height: ScreenQuery.screenHeight(context) * 0.1),
                              ElevatedButton(
                                onPressed: () async {
                                  final state = context.read<CreatecomBloc>().state;
                                  String selectedType = types[0];
                                  String selectedStatus = comStatus[0];

                                  if (state is DropdownSelectedState) {
                                    selectedType = state.selectedItem;
                                    selectedStatus = state.statusSelected;
                                  }

                                  String? imageUrl;
                                  if (_selectedImage != null) {
                                    imageUrl = await _uploadImage(_selectedImage!);
                                  }

                                  context.read<CreatecomBloc>().add(
                                    SubmitButtonClicked(
                                      Value: selectedType,
                                      userModel: widget.usermodel,
                                      userCredential: widget.userCredential,
                                      desc: _descriptionController.text,
                                      name: _nameController.text,
                                      ComStatus: selectedStatus,
                                      imageurl: imageUrl,
                                    ),
                                  );
                                },
                                child: Text("Submit"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
