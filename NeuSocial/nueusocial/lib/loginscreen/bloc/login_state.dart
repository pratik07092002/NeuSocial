part of 'login_bloc.dart';

class LoginState  extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoginSuccessState extends LoginState {
  final User userCredential;
  final UserModel usermod;

  LoginSuccessState({required this.userCredential, required this.usermod});
  List<Object?> get props => [userCredential , usermod];

}
class LoginErrorState extends LoginState {
  final String error;

  LoginErrorState({required this.error});
  List<Object?> get props => [];

}
class LoginLoadingState extends LoginState {}
class CreateAccountPageShowState extends LoginState{}

