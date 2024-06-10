import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:nueusocial/CreateCommunityScreen/model/CommunityModel.dart';

part 'notificationbloc_event.dart';
part 'notificationbloc_state.dart';

class NotificationblocBloc extends Bloc<NotificationblocEvent, NotificationblocState> {
  NotificationblocBloc() : super(NotificationblocState()) {
    on<ClickAcceptEvent>(_Accept);
    on<ClickRejectEvent>(_reject);
  }
  

  FutureOr<void> _Accept(ClickAcceptEvent event, Emitter<NotificationblocState> emit) {
    
           DocumentReference communityRef = FirebaseFirestore.instance.collection("Communities").doc(comid);

                                                  FirebaseFirestore.instance.runTransaction((transaction) async {
                                                    DocumentSnapshot communityDoc = await transaction.get(communityRef);

                                                    Map<String, dynamic> members = Map<String, dynamic>.from(communityDoc['Members']);

                                                    if (!members.containsKey(Senderuserid)) {
                                                      members[Senderuserid] = true;

                                                      transaction.update(communityRef, {'Members.${Senderuserid}': true});
                                                    }
                                                  });
    emit(RequestAcceptState());
  }

  FutureOr<void> _reject(ClickRejectEvent event, Emitter<NotificationblocState> emit) {
  }
}
