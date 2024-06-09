import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:nueusocial/createaccount/model/usermodel.dart';

part 'create_account_event.dart';
part 'create_account_state.dart';

class CreateAccountBloc extends Bloc<CreateAccountEvent, CreateAccountState> {
  CreateAccountBloc() : super(CreateAccountState()) {
    on<SignupButtonClickEvent>(_createacc);
    on<SignupInitialEvent>(_initialistage);
  }

  void _createacc(SignupButtonClickEvent event , Emitter<CreateAccountState> emit) async{
emit(CreateAccountLoadingState());

if(event.lname.isEmpty && event.fname.isEmpty){
  emit(CreateAccountErrorState(error: "Please Enter name"));
}
else if(event.Password != event.Cpassword){
  emit(CreateAccountErrorState(error: "Passwords did not match"));
}else{
  try {
    UserCredential usercred = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: event.email, password: event.Password);
    String uname = "${event.fname} ${event.lname}";
    String userid = usercred.user!.uid;

    UserModel usermod = UserModel(
      ProfilePicture: "",
      UserId: userid , 
      email: event.email , 
      name: uname , 
      phonenumber: event.Phonenum , 
      Username: event.Username , 
      
    );
    await FirebaseFirestore.instance.collection("Users").doc(userid).set(usermod.toMap());

    emit(CreateAccountSuccessState(usercred: usercred.user!, usermode: usermod));
  } on FirebaseAuthException catch (e) {
    emit(CreateAccountErrorState(error: e.code.toString()));
  }
}
  }

  FutureOr<void> _initialistage(SignupInitialEvent event, Emitter<CreateAccountState> emit) {
    emit(state.copyWith(
      fnamecontroller: TextEditingController() , 
      lnamecontroller: TextEditingController() , 
      cpassword: TextEditingController() , 
      emailcontroller: TextEditingController() , 
      password: TextEditingController(), 
      phcontroller: TextEditingController() , 
      usernamecontroller: TextEditingController()
      ));
  }
}
