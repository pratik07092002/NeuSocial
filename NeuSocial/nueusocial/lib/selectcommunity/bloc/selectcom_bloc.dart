import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'selectcom_event.dart';
import 'selectcom_state.dart';

class SelectcomBloc extends Bloc<SelectcomEvent, SelectcomState> {
  SelectcomBloc()
      : super(SelectcomState(
          selectedCommunities: {},
          isSkipButtonVisible: false,
        )) {
    on<ToggleCommunitySelection>((event, emit) async {
      final selectedCommunities = Set<String>.from(state.selectedCommunities);
      if (selectedCommunities.contains(event.community)) {
        selectedCommunities.remove(event.community);
      } else {
        selectedCommunities.add(event.community);
      }

      final isSkipButtonVisible = selectedCommunities.isNotEmpty;

      emit(state.copyWith(
        selectedCommunities: selectedCommunities,
        isSkipButtonVisible: isSkipButtonVisible,
      ));

      // Save selected state in shared preferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool(event.community, selectedCommunities.contains(event.community));
    });
  }
}
