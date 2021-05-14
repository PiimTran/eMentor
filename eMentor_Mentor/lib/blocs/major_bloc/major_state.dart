part of 'major_bloc.dart';

abstract class MajorState extends Equatable {
  const MajorState();
  @override
  List<Object> get props => [];
}

class MajorInitial extends MajorState {}

class MajorSuccess extends MajorState {
  final List<Major> majors;

  const MajorSuccess({this.majors});

  MajorSuccess copyWith({List<Major> majors}) {
    return MajorSuccess(
      majors: majors ?? this.majors,
    );
  }

  @override
  List<Object> get props => [majors];

}


class MajorFailure extends MajorState {}
