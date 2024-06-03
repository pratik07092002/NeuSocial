part of 'search_com_bloc.dart';

class SearchComEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TextFieldSearch extends SearchComEvent {
  final String SearchText;

  TextFieldSearch({required this.SearchText});

  @override
  List<Object?> get props => [SearchText];
}

class SearchUpdateevent extends SearchComEvent {}
