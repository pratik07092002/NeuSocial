import 'package:bloc/bloc.dart';
import 'package:nueusocial/utils/ismember.dart';
import 'community_display_event.dart';
import 'community_display_state.dart';

class CommunityDisplayBloc extends Bloc<CommunityDisplayEvent, CommunityDisplayState> {
  CommunityDisplayBloc() : super(CommunityInitialState()) {
    on<CheckUserInMembersEvent>(_updateBtn);
  }

  Future<void> _updateBtn(CheckUserInMembersEvent event, Emitter<CommunityDisplayState> emit) async {
    bool isMember = await isUserMember(event.userid, event.comid);
    print("is member: " + isMember.toString());
    if (isMember) {
      emit(CommunityMemberState());
    } else {
      emit(CommunityNotMemberState());
    }
  }
}
