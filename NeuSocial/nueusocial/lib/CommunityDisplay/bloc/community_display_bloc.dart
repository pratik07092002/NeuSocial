import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nueusocial/utils/ismember.dart';
import 'package:nueusocial/utils/joinCommunity.dart';
import 'community_display_event.dart';
import 'community_display_state.dart';

class CommunityDisplayBloc extends Bloc<CommunityDisplayEvent, CommunityDisplayState> {
  CommunityDisplayBloc() : super(CommunityInitialState()) {
    on<CheckUserInMembersEvent>(_updatebtn);
    on<ClickButtononOpenEvent>(_clickButton);
    on<ClickRequestSentEvent>(_RequestSent);
  }

  Future<void> _updatebtn(CheckUserInMembersEvent event, Emitter<CommunityDisplayState> emit) async {
   
    bool isMember = await isUserMember(event.userid , event.comid);
print("is member" + isMember.toString());
    if (isMember) {
      
      emit(CommunityMemberState());


    } else {
      emit(CommunityNotMemberState());


    }

  }

  FutureOr<void> _clickButton(ClickButtononOpenEvent event, Emitter<CommunityDisplayState> emit) {

   
                          emit(ComunityPageOpenState());
                          emit(CommunityMemberState());
      
 

  }

  FutureOr<void> _RequestSent(ClickRequestSentEvent event, Emitter<CommunityDisplayState> emit) async{

   try {
      if (event.communityModel.ComStatus.toString() ==
                            "Private") {
                          JoinCommunityy joincom = JoinCommunityy();
                          joincom.SendRequest(event.userModel,
                              event.usercred, event.communityModel);
                        }
                        else if(event.communityModel.ComStatus.toString() == "Public"){
                              DocumentReference communityRef = FirebaseFirestore.instance.collection("Communities").doc(event.communityModel.ComId);

                          FirebaseFirestore.instance.runTransaction((transaction) async {
                            DocumentSnapshot communityDoc = await transaction.get(communityRef);

                            Map<String, dynamic> members = Map<String, dynamic>.from(communityDoc['Members']);

                            if (!members.containsKey(event.userModel.UserId)) {
                              members[event.userModel.UserId.toString()] = true;

                              transaction.update(communityRef, {'Members.${event.userModel.UserId}': true});
                            }
                          });
                          emit(ComunityPageOpenState());
                        }
     emit(ComunityJoinRequestSentState());
        bool isMember = await isUserMember(event.userModel.UserId.toString() , event.communityModel.ComId.toString());
print("is member" + isMember.toString());
    if (isMember) {
      
      emit(CommunityMemberState());


    } else {
      emit(CommunityNotMemberState());


    }
   } catch (e) {
      emit(ComunityPageOpenErrorState());
     
   }
  }
}
