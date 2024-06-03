import 'package:equatable/equatable.dart';

 class CommunityDisplayEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CheckUserInMembersEvent extends CommunityDisplayEvent {
  final String userid;
  final String comid;

  CheckUserInMembersEvent({required this.userid, required this.comid});

  @override
  List<Object> get props => [userid, comid];
}
