part of 'sharing_bloc.dart';

abstract class SharingState extends Equatable {
  const SharingState();
  @override
  List<Object> get props => [];
}

class SharingInitial extends SharingState {}

class SharingSuccess extends SharingState {
  final List<Sharing> sharings;
  final bool isMax;

  const SharingSuccess({this.isMax, this.sharings});

  SharingSuccess copyWith({
    List<Sharing> sharings,
    bool isMax,
  }) {
    return SharingSuccess(
      sharings: sharings ?? this.sharings,
      isMax: isMax ?? this.isMax,
    );
  }

  @override
  List<Object> get props => [sharings, isMax];

  @override
  String toString() =>
      'PostSuccess { posts: ${sharings.length}, hasReachedMax: $isMax }';
}

class SharingFailure extends SharingState {}
