part of 'notificationbloc_bloc.dart';

class NotificationblocEvent  extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ClickAcceptEvent extends NotificationblocEvent{
 final CommunityModel commod;

  ClickAcceptEvent({required this.commod});
}
class ClickRejectEvent extends NotificationblocEvent{}