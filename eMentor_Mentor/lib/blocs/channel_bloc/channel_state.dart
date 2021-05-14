part of 'channel_bloc.dart';

abstract class ChannelState extends Equatable {
  const ChannelState();
  @override
  List<Object> get props => [];
}

class ChannelInitial extends ChannelState {}

class ChannelSuccess extends ChannelState {
  final List<Channel> channels;
  final bool isMax;

  const ChannelSuccess({this.channels,this.isMax}); 

  ChannelSuccess copyWith({
    List<Channel> sharings,
    bool isMax,
  }) {
    return ChannelSuccess(
      channels: sharings ?? this.channels,
      isMax: isMax ?? this.isMax,
    );
  }

  @override
  List<Object> get props => [channels, isMax];
}

class ChannelFailure extends ChannelState {}
