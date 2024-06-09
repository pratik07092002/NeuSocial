import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nueusocial/createaccount/model/usermodel.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState()) {
    on<LoginClickEvent>(_login);
    on<CreateAccountClickEvent>(_Switch);
  }
  void _login(LoginClickEvent event , Emitter<LoginState> emit) async{
    emit(LoginLoadingState());

    try {
      if(event.email.isEmpty || event.password.isEmpty){
        emit(LoginErrorState(error: "Please Enter Valid Credentials"));
      }
      else{
        UserCredential usercred = await FirebaseAuth.instance.signInWithEmailAndPassword(email: event.email, password: event.password);
        String Userid = usercred.user!.uid;

       DocumentSnapshot docsnap = await FirebaseFirestore.instance.collection("Users").doc(Userid).get();
       UserModel fetchmod = UserModel.fromMap(docsnap.data() as Map<String , dynamic>);

       emit(LoginSuccessState(userCredential: usercred.user!, usermod: fetchmod));

      }
      
    } on FirebaseAuthException catch (e) {
      emit(LoginErrorState(error: e.code.toString()));
    }
  }

  void _Switch(CreateAccountClickEvent event , Emitter<LoginState> emit) {
emit(CreateAccountPageShowState());
emit(LoginState());
  }
}
