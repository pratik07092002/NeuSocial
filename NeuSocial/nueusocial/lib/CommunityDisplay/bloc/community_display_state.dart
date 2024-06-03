import 'package:equatable/equatable.dart';

abstract class CommunityDisplayState extends Equatable {
  @override
  List<Object> get props => [];
}

class CommunityInitialState extends CommunityDisplayState {}

class CommunityMemberState extends CommunityDisplayState {}

class CommunityNotMemberState extends CommunityDisplayState {}
