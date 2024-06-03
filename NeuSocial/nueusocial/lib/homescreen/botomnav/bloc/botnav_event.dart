import 'package:equatable/equatable.dart';

abstract class BottomNavEvent extends Equatable {
  const BottomNavEvent();

  @override
  List<Object> get props => [];
}

class PageTappedEvent extends BottomNavEvent {
  final int index;

  const PageTappedEvent(this.index);

  @override
  List<Object> get props => [index];
}
