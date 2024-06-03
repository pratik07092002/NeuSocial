part of 'create_account_bloc.dart';

class CreateAccountEvent  extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SignupButtonClickEvent extends CreateAccountEvent{
  final String fname;
  final String lname;
  final String Phonenum;
  final String email;
  final String Cpassword;
final String Password;
final String Username;
  SignupButtonClickEvent({required this.Password, required this.fname, required this.lname, required this.Phonenum, required this.email, required this.Cpassword , required this.Username});
  
  @override 
  List<Object> get props => [fname,lname , Phonenum , email , Cpassword , Password , Username];
  
  }
