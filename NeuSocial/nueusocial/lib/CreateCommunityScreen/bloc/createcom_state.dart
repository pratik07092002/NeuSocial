part of 'createcom_bloc.dart';

class CreatecomState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreatecomSubmitState extends CreatecomState {
  final User userCredential;
  final UserModel usermod;
  final CommunityModel communityModel;

  CreatecomSubmitState({required this.userCredential, required this.communityModel, required this.usermod});

  @override
  List<Object?> get props => [userCredential, usermod, communityModel];
}

class CreatecomLoadingState extends CreatecomState {}

class DropdownSelectedState extends CreatecomState {
  final String selectedItem;
  final String statusSelected;

  DropdownSelectedState(this.selectedItem, this.statusSelected);

  @override
  List<Object> get props => [selectedItem, statusSelected];
}

class CreatComerrorState extends CreatecomState {
  final String error;

  CreatComerrorState({required this.error});

  @override
  List<Object?> get props => [error];
}
