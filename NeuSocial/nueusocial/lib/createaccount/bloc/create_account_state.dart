part of 'create_account_bloc.dart';

class CreateAccountState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];

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
