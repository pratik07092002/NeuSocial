import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nueusocial/CreateCommunityScreen/model/CommunityModel.dart';
import 'package:nueusocial/createaccount/model/usermodel.dart';

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

class ClickButtononOpenEvent extends CommunityDisplayEvent{
  final UserModel userModel;
  final User usercred;
  final CommunityModel communityModel;

  ClickButtononOpenEvent({required this.userModel, required this.usercred, required this.communityModel});
  
}
class ClickRequestSentEvent extends CommunityDisplayEvent{
  final UserModel userModel;
  final User usercred;
  final CommunityModel communityModel;

  ClickRequestSentEvent({required this.userModel, required this.usercred, required this.communityModel});
}