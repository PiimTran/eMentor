import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:ementor_demo/models/channel/channel.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

part 'channel_event.dart';
part 'channel_state.dart';

class ChannelBloc extends Bloc<ChannelEvent, ChannelState> {
  final http.Client httpClient;

  ChannelBloc({this.httpClient});

  @override
  ChannelState get initialState => ChannelInitial();

  @override
  Stream<ChannelState> mapEventToState(
    ChannelEvent event,
  ) async* {
    final currentState = state;
    if (event is ChannelFetched && !_isMax(currentState)) {
      try {
        if (currentState is ChannelInitial) {
          final channels = await _fetchChannels(0, 15);
          yield ChannelSuccess(channels: channels, isMax: false);
        }
        if (currentState is ChannelSuccess) {
          final channels =
              await _fetchChannels(currentState.channels.length, 15);
          yield channels.isEmpty
              ? currentState.copyWith(isMax: true)
              : ChannelSuccess(
                  channels: currentState.channels + channels,
                  isMax: false,
                );
        }
      } catch (_) {
        yield ChannelFailure();
      }
    }
  }

  bool _isMax(ChannelState state) => state is ChannelSuccess && state.isMax;

  Future<List<Channel>> _fetchChannels(int startIndex, int limit) async {
    final response = await httpClient.get(
        'https://ementorapi.azurewebsites.net/api/channels?_start=$startIndex&_limit=$limit');
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((rawChannel) {
        return Channel(
          channelId: rawChannel['channelId'],
          mentorName: rawChannel['mentorName'],
          topicName: rawChannel['topicName'],
        );
      }).toList();
    } else {
      throw Exception(
          'error fetching Channels status code:  ${response.statusCode}');
    }
  }
}
