part of 'createcom_bloc.dart';

class CreatecomEvent extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SubmitButtonClicked extends CreatecomEvent{
  final String Value;
  final String desc;
  final String name;
  final String ComStatus;
  final UserModel userModel;
  final User userCredential;
  final String? imageurl;
  SubmitButtonClicked(  { required this.imageurl, required this.Value, required this.ComStatus ,  required this.userModel, required this.userCredential, required this.desc, required this.name});
  List<Object?> get props => [Value , desc , name  , userCredential , userModel , ComStatus , imageurl];

}

class DropdownItemSelected extends CreatecomEvent {
  final String selectedItem;

   DropdownItemSelected(this.selectedItem );

  @override
  List<Object> get props => [selectedItem ];
}

class DropdownStatusItemSelected extends CreatecomEvent {
  final String statusSelected;

   DropdownStatusItemSelected( this.statusSelected);

  @override
  List<Object> get props => [ statusSelected];
}