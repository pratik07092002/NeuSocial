part of 'notificationbloc_bloc.dart';


abstract class NotificationblocEvent extends Equatable {
  const NotificationblocEvent();
}

class FetchNotificationsEvent extends NotificationblocEvent {
  final String adminUserId;

  const FetchNotificationsEvent({required this.adminUserId});

  @override
  List<Object> get props => [adminUserId];
}

class ClickAcceptEvent extends NotificationblocEvent {
  final String comid;
  final String senderId;
  final String requestId;

  const ClickAcceptEvent({required this.comid, required this.senderId, required this.requestId});

  @override
  List<Object> get props => [comid, senderId, requestId];
}

class ClickRejectEvent extends NotificationblocEvent {
  final String senderId;
  final String requestId;

  const ClickRejectEvent({required this.senderId, required this.requestId});

  @override
  List<Object> get props => [senderId, requestId];
}
