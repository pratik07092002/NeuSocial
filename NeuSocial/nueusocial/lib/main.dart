import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nueusocial/createaccount/model/usermodel.dart';
import 'package:nueusocial/homescreen/botomnav/botomnav.dart';
import 'package:nueusocial/loginscreen/loginscreenui.dart';
import 'package:nueusocial/loginscreen/modelfetch/firebasehelper.dart';
import 'package:uuid/uuid.dart';
var uuid = Uuid();
void main() async{
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
User? currentuser =  await FirebaseAuth.instance.currentUser;

if(currentuser != null)  {
UserModel? currentusermod = await Firebasehelper.getUserModelByID(currentuser.uid);

if(currentusermod != null) {
  runApp(MyAppLoggedin(firebaseuser: currentuser , userModel: currentusermod));
}
else{
  runApp(const MyApp());

}

}else{

  runApp(const MyApp());
}
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      debugShowMaterialGrid: false,
      home: LoginScreen(),
    );
  }
}

class MyAppLoggedin extends StatelessWidget {
final User firebaseuser; 
final UserModel userModel;

  const MyAppLoggedin({super.key, required this.firebaseuser, required this.userModel});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark , primarySwatch: Colors.purple),
      debugShowCheckedModeBanner: false, 
      debugShowMaterialGrid: false,
      home: BotoomNav( userCredential: firebaseuser , userMod: userModel) , 
     
    );
  }
}