part of 'notificationbloc_bloc.dart';

abstract class NotificationblocState extends Equatable {
  const NotificationblocState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationblocState {}

class NotificationLoading extends NotificationblocState {}

class NotificationsLoaded extends NotificationblocState {
  final List<QueryDocumentSnapshot> notifications;
  final Map<String, String> notificationStatus;

  const NotificationsLoaded({required this.notifications, required this.notificationStatus});

  @override
  List<Object> get props => [notifications, notificationStatus];
}

class NotificationAccepted extends NotificationblocState {
  final String senderId;

  const NotificationAccepted({required this.senderId});

  @override
  List<Object> get props => [senderId];
}

class NotificationRejected extends NotificationblocState {
  final String senderId;

  const NotificationRejected({required this.senderId});

  @override
  List<Object> get props => [senderId];
}
