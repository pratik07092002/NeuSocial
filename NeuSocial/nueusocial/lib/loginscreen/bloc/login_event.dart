part of 'login_bloc.dart';

class LoginEvent extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoginClickEvent extends LoginEvent{
  final String email;
  final String password;

  LoginClickEvent({required this.email, required this.password});
  List<Object?> get props => [email , password];
}
class LoginErrorEvent extends LoginEvent{
  final String error;

  LoginErrorEvent({required this.error});
  List<Object?> get props => [error];

}

class CreateAccountClickEvent extends LoginEvent{}



