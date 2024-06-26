import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'notificationbloc_event.dart';
part 'notificationbloc_state.dart';

class NotificationblocBloc extends Bloc<NotificationblocEvent, NotificationblocState> {
  NotificationblocBloc() : super(NotificationInitial()) {
    on<FetchNotificationsEvent>(_fetchNotifications);
    on<ClickAcceptEvent>(_accept);
    on<ClickRejectEvent>(_reject);
  }

  Future<void> _fetchNotifications(FetchNotificationsEvent event, Emitter<NotificationblocState> emit) async {
    try {
      emit(NotificationLoading()); 
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("JoinRequests")
          .where("AdminUserid", isEqualTo: event.adminUserId)
          .get();

      List<QueryDocumentSnapshot> notifications = snapshot.docs;

      emit(NotificationsLoaded(notifications: notifications, notificationStatus: {}));
    } catch (e) {
      print("Error fetching notifications: $e");
    }
  }

  Future<void> _accept(ClickAcceptEvent event, Emitter<NotificationblocState> emit) async {
    try {
      DocumentReference communityRef = FirebaseFirestore.instance.collection("Communities").doc(event.comid);
      DocumentReference requestRef = FirebaseFirestore.instance.collection("JoinRequests").doc(event.requestId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot communityDoc = await transaction.get(communityRef);
        Map<String, dynamic> members = Map<String, dynamic>.from(communityDoc['Members']);
        if (!members.containsKey(event.senderId)) {
          members[event.senderId] = true;
          transaction.update(communityRef, {'Members.${event.senderId}': true});
        }

        transaction.delete(requestRef);
      });

      final currentState = state as NotificationsLoaded;
      final updatedStatus = Map<String, String>.from(currentState.notificationStatus);
      updatedStatus[event.senderId] = 'Accepted';

      emit(NotificationsLoaded(notifications: currentState.notifications, notificationStatus: updatedStatus));
    } catch (e) {
      print("Error accepting request: $e");
    }
  }

  Future<void> _reject(ClickRejectEvent event, Emitter<NotificationblocState> emit) async {
    try {
      DocumentReference requestRef = FirebaseFirestore.instance.collection("JoinRequests").doc(event.requestId);

      await requestRef.delete();

      final currentState = state as NotificationsLoaded;
      final updatedStatus = Map<String, String>.from(currentState.notificationStatus);
      updatedStatus[event.senderId] = 'Rejected';

      emit(NotificationsLoaded(notifications: currentState.notifications, notificationStatus: updatedStatus));
    } catch (e) {
      print("Error rejecting request: $e");
    }
  }
}
