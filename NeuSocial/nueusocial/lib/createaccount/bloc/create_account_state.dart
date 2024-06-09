part of 'create_account_bloc.dart';

class CreateAccountState extends Equatable {
  final TextEditingController? fnamecontroller;
  final TextEditingController? lnamecontroller;
  final TextEditingController? phcontroller;
  final TextEditingController? emailcontroller;
  final TextEditingController? password;
  final TextEditingController? cpassword;
  final TextEditingController? usernamecontroller;

  CreateAccountState({
    this.fnamecontroller,
    this.lnamecontroller,
    this.phcontroller,
    this.emailcontroller,
    this.password,
    this.cpassword,
    this.usernamecontroller,
  });

  CreateAccountState copyWith({
    TextEditingController? fnamecontroller,
    TextEditingController? lnamecontroller,
    TextEditingController? phcontroller,
    TextEditingController? emailcontroller,
    TextEditingController? password,
    TextEditingController? cpassword,
    TextEditingController? usernamecontroller,
  }) {
    return CreateAccountState(
      fnamecontroller: fnamecontroller ?? this.fnamecontroller,
      lnamecontroller: lnamecontroller ?? this.lnamecontroller,
      phcontroller: phcontroller ?? this.phcontroller,
      emailcontroller: emailcontroller ?? this.emailcontroller,
      password: password ?? this.password,
      cpassword: cpassword ?? this.cpassword,
      usernamecontroller: usernamecontroller ?? this.usernamecontroller,
    );
  }

  @override
  List<Object?> get props => [
        fnamecontroller,
        lnamecontroller,
        phcontroller,
        emailcontroller,
        password,
        cpassword,
        usernamecontroller,
      ];
}

class CreateAccountSuccessState extends CreateAccountState {
  final User usercred;
  final UserModel usermode;

  CreateAccountSuccessState({
    required this.usercred,
    required this.usermode,
  });

  @override
  List<Object?> get props => [usercred, usermode];
}

class CreateAccountLoadingState extends CreateAccountState {}

class CreateAccountErrorState extends CreateAccountState {
  final String error;

  CreateAccountErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}
