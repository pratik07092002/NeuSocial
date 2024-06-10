import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nueusocial/createaccount/createaccountui.dart';
import 'package:nueusocial/homescreen/botomnav/botomnav.dart';
import 'package:nueusocial/loginscreen/bloc/login_bloc.dart';
import 'package:nueusocial/utils/ScreenQuery.dart';
import 'package:nueusocial/widgets/customtextform.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: LoginScreenView(),
      );
  }
}

class LoginScreenView extends StatefulWidget {
  LoginScreenView({Key? key}) : super(key: key);

  @override
  State<LoginScreenView> createState() => _LoginScreenViewState();
}

class _LoginScreenViewState extends State<LoginScreenView> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  SizedBox(
                    height: ScreenQuery.screenHeight(context) * 0.1,
                  ),
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
                  SizedBox(
                    height: ScreenQuery.screenHeight(context) * 0.08,
                  ),
                  BlocListener<LoginBloc, LoginState>(
                    listener: (context, state) {
                         if(state is LoginSuccessState){
                     Navigator.push(context, MaterialPageRoute(builder: (context) =>
                      BotoomNav(userCredential: state.userCredential, userMod: state.usermod)));

                      }
                    },
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<LoginBloc>().add(
                          LoginClickEvent(
                            email: _emailController.text,
                            password: _passwordController.text,
                          ),
                        );
                      },
                      child: Text("Login"),
                    ),
                  ),
                  SizedBox(height: 10),
                  BlocListener<LoginBloc, LoginState>(
                    listener: (context, state) {
                      // TODO: implement listener
if(state is CreateAccountPageShowState){
  print("create account page");
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage(),) );

}                      
                    },
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<LoginBloc>().add(
                          CreateAccountClickEvent(),
                        );
                      },
                      child: Text("Create account"),
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
