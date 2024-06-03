import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:nueusocial/CreateCommunityScreen/model/CommunityModel.dart';
import 'package:nueusocial/enums/Statusscreen.dart';

part 'search_com_event.dart';
part 'search_com_state.dart';

class SearchComBloc extends Bloc<SearchComEvent, SearchComState> {
  List<CommunityModel> tempList = [];

  SearchComBloc() : super(SearchComState()) {
    on<TextFieldSearch>(_searchevent);
    on<SearchUpdateevent>(_UpdateDisplay);
  }

  void _UpdateDisplay(SearchUpdateevent event, Emitter<SearchComState> emit) async {
    try {
      QuerySnapshot querysnap = await FirebaseFirestore.instance.collection("Communities").get();
      List<CommunityModel> ListData = querysnap.docs.map((e) => CommunityModel.fromMap(e.data() as Map<String, dynamic>)).toList();
      emit(state.copyWith(status: Statuss.success, ComList: ListData, TempComList: ListData));
    } catch (e) {
      emit(state.copyWith(status: Statuss.failure));
    }
  }

  void _searchevent(TextFieldSearch event, Emitter<SearchComState> emit) {
    tempList = state.ComList.where((element) => element.name!.toLowerCase().contains(event.SearchText.toLowerCase())).toList();
    emit(state.copyWith(TempComList: tempList));
  }
}
