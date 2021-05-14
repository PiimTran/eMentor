part of 'sharing_bloc.dart';

abstract class SharingEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SharingFetched extends SharingEvent {}