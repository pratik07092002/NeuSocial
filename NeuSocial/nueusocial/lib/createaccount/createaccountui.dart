import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nueusocial/createaccount/bloc/create_account_bloc.dart';
import 'package:nueusocial/selectcommunity/selectecommunityui.dart';
import 'package:nueusocial/utils/ScreenQuery.dart';
import 'package:nueusocial/widgets/customtextform.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

CreateAccountBloc createblc = CreateAccountBloc();

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController fnamecontroller = TextEditingController();
  TextEditingController lnamecontroller = TextEditingController();
  TextEditingController phcontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cpassword = TextEditingController();
  TextEditingController usernamecontroller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => createblc,
      child: BlocListener<CreateAccountBloc, CreateAccountState>(
        listener: (context, state) {
         if(state is CreateAccountSuccessState){
           Navigator.push(context, MaterialPageRoute(builder: (context) => SelectCommunityScreen(usercred: state.usercred, Usermod : state.usermode,),));
         }
        },
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/Homebackground1.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Form(
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: ScreenQuery.screenHeight(context) * 0.05),
                      
                     Center(
                        child: Container(
                                            decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.purple,
                                spreadRadius: 8,
                                blurRadius: 7)
                          ]),
                                            child: CircleAvatar(
                        radius: ScreenQuery.screenHeight(context) * 0.08,
                        backgroundImage: const AssetImage("assets/LOGO.jpeg"),
                                            ),
                                          ),
                      ),
                      SizedBox(height: ScreenQuery.screenHeight(context) * 0.05),
                      Row(
                        children: [
                          Flexible(
                            child: CustomTextForm(
                              hinttext: "First name",
                              prefixicon: Icon(Icons.people),
                              obscure: false,
                              controller: fnamecontroller,
                        
                            ),
                          ),
                          SizedBox(
                              width: ScreenQuery.screenWidth(context) * 0.01),
                          Flexible(
                            child: CustomTextForm(
                             
                              hinttext: "Last name",
                              prefixicon: Icon(Icons.people),
                              obscure: false,
                              controller: lnamecontroller,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ScreenQuery.screenHeight(context) * 0.01),
                      CustomTextForm(
                  
                        hinttext: "Enter Phone Number",
                        prefixicon: Icon(Icons.phone),
                        obscure: false,
                        controller: phcontroller,
                      ),
                       CustomTextForm(
                  
                        hinttext: "Enter Username",
                        prefixicon: Icon(Icons.people),
                        obscure: false,
                        controller: usernamecontroller,
                      ),
                      SizedBox(height: ScreenQuery.screenHeight(context) * 0.01),
                      CustomTextForm(
                      
                        hinttext: "Enter Email Address",
                        prefixicon: Icon(Icons.email),
                        obscure: false,
                        controller: emailcontroller,
                      ),
                      SizedBox(height: ScreenQuery.screenHeight(context) * 0.01),
                      CustomTextForm(
                   
                        hinttext: "Enter Password",
                        prefixicon: Icon(Icons.password),
                        obscure: true,
                        controller: password,
                      ),
                      SizedBox(height: ScreenQuery.screenHeight(context) * 0.01),
                      CustomTextForm(
                  
                        hinttext: "Enter Password Again",
                        prefixicon: Icon(Icons.password),
                        obscure: true,
                        controller: cpassword,
                      ),
                      SizedBox(height: ScreenQuery.screenHeight(context) * 0.02),
                      Container(
                        width: ScreenQuery.screenWidth(context) * 0.4,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1),
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextButton(
                          onPressed: () {
                            createblc.add(SignupButtonClickEvent(
                              Password: password.text,
                               fname: fnamecontroller.text,
                                lname: lnamecontroller.text,
                                Phonenum: phcontroller.text,
                                 email: emailcontroller.text,
                                  Cpassword: cpassword.text , 
                                  Username: usernamecontroller.text));
                          },
                          child: Text("Sign Up" , style: TextStyle(color: Colors.white),),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
