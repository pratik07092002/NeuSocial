import 'package:equatable/equatable.dart';

class BottomNavState extends Equatable {
  const BottomNavState();

  @override
  List<Object> get props => [];
}

class BottomNavInitial extends BottomNavState {}

class PageLoading extends BottomNavState {}

class PageLoaded extends BottomNavState {
  final int index;

  const PageLoaded(this.index);

  @override
  List<Object> get props => [index];
}
