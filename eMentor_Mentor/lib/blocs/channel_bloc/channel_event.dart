part of 'channel_bloc.dart';

abstract class ChannelEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ChannelFetched extends ChannelEvent {}
