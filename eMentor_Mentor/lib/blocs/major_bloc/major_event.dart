part of 'major_bloc.dart';

abstract class MajorEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MajorFetched extends MajorEvent {}