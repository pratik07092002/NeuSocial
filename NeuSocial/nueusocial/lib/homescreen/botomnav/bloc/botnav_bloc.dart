import 'package:bloc/bloc.dart';
import 'package:nueusocial/homescreen/botomnav/bloc/botnav_event.dart';
import 'package:nueusocial/homescreen/botomnav/bloc/botnav_state.dart';

class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  BottomNavBloc() : super(BottomNavState()){
    on<PageTappedEvent>(_pagetapeventhandel);


  }

  _pagetapeventhandel(PageTappedEvent event , Emitter<BottomNavState> emit) async{
    emit(PageLoading());

    await Future.delayed(Duration(milliseconds: 300)) ;
    emit(PageLoaded(event.index));
  }



}
