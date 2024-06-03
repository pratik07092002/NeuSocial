import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nueusocial/createaccount/createaccountui.dart';
import 'package:nueusocial/homescreen/botomnav/botomnav.dart';
import 'package:nueusocial/loginscreen/bloc/login_bloc.dart';
import 'package:nueusocial/utils/ScreenQuery.dart';
import 'package:nueusocial/widgets/customtextform.dart';
LoginBloc loginBloc = LoginBloc();
class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => loginBloc,
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BotoomNav(
                  userCredential: state.userCredential,
                  userMod: state.usermod,
                ),
              ),
            );
          } else if (state is CreateAccountPageShowState) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpPage()),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/Homebackground1.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Form(
                  child: Column(
                    children: [
                      SizedBox(height: ScreenQuery.screenHeight(context) * 0.1), 
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
                  SizedBox(height: ScreenQuery.screenHeight(context)*0.1,),

                      CustomTextForm(
                        hinttext: "Enter Email",
                        prefixicon: Icon(Icons.email),
                        obscure: false,
                        controller: _emailController,
                      
                      ),
                      SizedBox(height: ScreenQuery.screenHeight(context) * 0.01),
                      CustomTextForm(
                        
                        hinttext: "Enter Password",
                        prefixicon: Icon(Icons.password),
                        obscure: true,
                        controller: _passwordController,
                      ),
                      SizedBox(height: ScreenQuery.screenHeight(context)*0.08,),
                      ElevatedButton(
                        onPressed: () {
                          loginBloc.add(
                            LoginClickEvent(
                              email: _emailController.text,
                              password: _passwordController.text,
                            ),
                          );
                        },
                        child: Text("Login"),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          loginBloc.add(
                            CreateAccountClickEvent(),
                          );
                        },
                        child: Text("Create account"),
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
