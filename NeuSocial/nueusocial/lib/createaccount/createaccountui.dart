import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nueusocial/createaccount/bloc/create_account_bloc.dart';
import 'package:nueusocial/selectcommunity/selectecommunityui.dart';
import 'package:nueusocial/utils/ScreenQuery.dart';
import 'package:nueusocial/widgets/customtextform.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => CreateAccountBloc() , 
    child: SignUpPageView(),
     );
  }
}

class SignUpPageView  extends StatelessWidget {
  SignUpPageView({Key? key}) : super(key: key);

   
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CreateAccountBloc>(context);
    return Container(
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
                        child: BlocSelector<CreateAccountBloc,
                            CreateAccountState, TextEditingController?>(
                          selector: (state) => state.fnamecontroller,
                          builder: (context, fnamecontroller) {
                            return CustomTextForm(
                              hinttext: "First name",
                              prefixicon: Icon(Icons.people),
                              obscure: false,
                              controller: fnamecontroller,
                            );
                          },
                        ),
                      ),
                      SizedBox(width: ScreenQuery.screenWidth(context) * 0.01),
                      Flexible(
                        child: BlocSelector<CreateAccountBloc,
                            CreateAccountState, TextEditingController?>(
                          selector: (state) => state.lnamecontroller,
                          builder: (context, lnamecontroller) {
                            return CustomTextForm(
                              hinttext: "Last name",
                              prefixicon: Icon(Icons.people),
                              obscure: false,
                              controller: lnamecontroller,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ScreenQuery.screenHeight(context) * 0.01),
                  BlocSelector<CreateAccountBloc, CreateAccountState,
                      TextEditingController?>(
                    selector: (state) {
                      return state.phcontroller;
                    },
                    builder: (context, phcontroller) {
                      return CustomTextForm(
                        hinttext: "Enter Phone Number",
                        prefixicon: Icon(Icons.phone),
                        obscure: false,
                        controller: phcontroller,
                      );
                    },
                  ),
                  BlocSelector<CreateAccountBloc, CreateAccountState,
                      TextEditingController?>(
                    selector: (state) {
                      return state.usernamecontroller;
                    },
                    builder: (context, usernamecontroller) {
                      return CustomTextForm(
                        hinttext: "Enter Username",
                        prefixicon: Icon(Icons.people),
                        obscure: false,
                        controller: usernamecontroller,
                      );
                    },
                  ),
                  SizedBox(height: ScreenQuery.screenHeight(context) * 0.01),
                  BlocSelector<CreateAccountBloc, CreateAccountState,
                      TextEditingController?>(
                    selector: (state) {
                      return state.emailcontroller;
                    },
                    builder: (context, emailcontroller) {
                      return CustomTextForm(
                        hinttext: "Enter Email Address",
                        prefixicon: Icon(Icons.email),
                        obscure: false,
                        controller: emailcontroller,
                      );
                    },
                  ),
                  SizedBox(height: ScreenQuery.screenHeight(context) * 0.01),
                  BlocSelector<CreateAccountBloc, CreateAccountState,
                      TextEditingController?>(
                    selector: (state) {
                      return state.password;
                    },
                    builder: (context, password) {
                      return CustomTextForm(
                        hinttext: "Enter Password",
                        prefixicon: Icon(Icons.password),
                        obscure: true,
                        controller: password,
                      );
                    },
                  ),
                  SizedBox(height: ScreenQuery.screenHeight(context) * 0.01),
                  BlocSelector<CreateAccountBloc, CreateAccountState, TextEditingController?>(
                    selector: (state) {
                      return state.cpassword;
                    },
                    builder: (context, cpassword) {
                      return CustomTextForm(
                        hinttext: "Enter Password Again",
                        prefixicon: Icon(Icons.password),
                        obscure: true,
                        controller: cpassword,
                      );
                    },
                  ),
                  SizedBox(height: ScreenQuery.screenHeight(context) * 0.02),
                  Container(
                    width: ScreenQuery.screenWidth(context) * 0.4,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 1),
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: BlocListener<CreateAccountBloc, CreateAccountState>(
                      listener: (context, state) {
                        // TODO: implement listener
                        if(state is CreateAccountSuccessState){

                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SelectCommunityScreen(usercred: state.usercred, Usermod: state.usermode),)
                        );
                        }

                      },
                      child: TextButton(
                        onPressed: () {
                          bloc.add(SignupButtonClickEvent(
                            Password: bloc.state.password!.text,
                             fname: bloc.state.fnamecontroller!.text,
                              lname: bloc.state.lnamecontroller!.text,
                               Phonenum: bloc.state.phcontroller!.text,
                                email: bloc.state.emailcontroller!.text,
                                 Cpassword: bloc.state.cpassword!.text,
                                  Username: bloc.state.usernamecontroller!.text));
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
