import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nueusocial/CreateCommunityScreen/model/CommunityModel.dart';
import 'package:nueusocial/createaccount/model/usermodel.dart';
import 'package:uuid/uuid.dart';

part 'createcom_event.dart';
part 'createcom_state.dart';

class CreatecomBloc extends Bloc<CreatecomEvent, CreatecomState> {
  CreatecomBloc() : super(DropdownSelectedState('Sports', 'Public')) {
    on<SubmitButtonClicked>(_createCommunity);
    on<DropdownItemSelected>(_dropDown);
    on<DropdownStatusItemSelected>(_dropDownStatus);
  }

  void _dropDownStatus(DropdownStatusItemSelected event, Emitter<CreatecomState> emit) {
    if (state is DropdownSelectedState) {
      final currentState = state as DropdownSelectedState;
      emit(DropdownSelectedState(currentState.selectedItem, event.statusSelected));
    } else {
      emit(DropdownSelectedState('Sports', event.statusSelected));
    }
  }

  void _dropDown(DropdownItemSelected event, Emitter<CreatecomState> emit) {
    if (state is DropdownSelectedState) {
      final currentState = state as DropdownSelectedState;
      emit(DropdownSelectedState(event.selectedItem, currentState.statusSelected));
    } else {
      emit(DropdownSelectedState(event.selectedItem, 'Public'));
    }
  }

void _createCommunity(SubmitButtonClicked event, Emitter<CreatecomState> emit) async {
  emit(CreatecomLoadingState());

  try {
    if (event.userModel.UserId == null) {
      emit(CreatComerrorState(error: "User model is null"));
      return;
    }

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("Communities")
        .where("name", isEqualTo: event.name)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      emit(CreatComerrorState(error: "Community name already exists"));
      return;
    }

    String cid = Uuid().v1();
    Map<String, dynamic> membersmap = {
      event.userModel.UserId.toString(): true
    };
    CommunityModel CommMod = CommunityModel(
      name: event.name,
      Profilepic: event.imageurl ?? "",
      Admin: event.userModel.UserId,
      Type: event.Value,
      Members: membersmap,
      ComStatus: event.ComStatus,
      desc: event.desc,
      ComId: cid,
      Adminname: event.userModel.Username
    );

    await FirebaseFirestore.instance
        .collection("Communities")
        .doc(cid)
        .set(CommMod.tomap());

 
    Map<String, dynamic> comadmin = {
      event.userModel.UserId.toString(): true
    };
    event.userModel.ComAdmin = comadmin;
    await FirebaseFirestore.instance.collection("Users").doc(event.userModel.UserId).set(event.userModel.toMap());

    emit(CreatecomSubmitState(
      userCredential: event.userCredential,
      communityModel: CommMod,
      usermod: event.userModel,
    ));
  } on FirebaseException catch (e) {
    emit(CreatComerrorState(error: e.code.toString()));
  }
}


}
