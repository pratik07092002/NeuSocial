part of 'search_com_bloc.dart';

class SearchComState extends Equatable {
  final Statuss status;
  final List<CommunityModel> ComList;
  final List<CommunityModel> TempComList;

  SearchComState({this.status = Statuss.loading, this.ComList = const [], this.TempComList = const []});

  SearchComState copyWith({Statuss? status, List<CommunityModel>? ComList, List<CommunityModel>? TempComList}) {
    return SearchComState(
      status: status ?? this.status,
      ComList: ComList ?? this.ComList,
      TempComList: TempComList ?? this.TempComList,
    );
  }

  @override
  List<Object?> get props => [status, ComList, TempComList];
}
