import 'dart:async';
import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:ementor_demo/models/model.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

part 'sharing_event.dart';
part 'sharing_state.dart';

class SharingBloc extends Bloc<SharingEvent, SharingState> {
  final http.Client httpClient;

  SharingBloc({this.httpClient});

  @override
  SharingState get initialState => SharingInitial();

  // câu giờ để load list
  @override
  Stream<Transition<SharingEvent, SharingState>> transformEvents(
    Stream<SharingEvent> events,
    TransitionFunction<SharingEvent, SharingState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<SharingState> mapEventToState(SharingEvent event) async* {
    final currentState = state;
    if (event is SharingFetched && !_isMax(currentState)) {
      try {
        if (currentState is SharingInitial) {
          final sharings = await _fetchSharings(0, 15);
          yield SharingSuccess(sharings: sharings, isMax: false);
          return;
        }
        if (currentState is SharingSuccess) {
          final sharings =
              await _fetchSharings(currentState.sharings.length, 15);
          yield sharings.isEmpty
              ? currentState.copyWith(isMax: true)
              : SharingSuccess(
                  sharings: currentState.sharings + sharings,
                  isMax: false,
                );
        }
      } catch (_) {
        yield SharingFailure();
      }
    }
  }

  bool _isMax(SharingState state) => state is SharingSuccess && state.isMax;

  Future<List<Sharing>> _fetchSharings(int startIndex, int limit) async {
    final response = await httpClient.get(
        'https://ementorapi.azurewebsites.net/api/sharings?_start=$startIndex&_limit=$limit');
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((rawSharing) {
        return Sharing(
          // sharingId: rawSharing["sharingId"],
          sharingName: rawSharing["sharingName"],
          // description: rawSharing["description"],
          // startTime: DateTime.parse(rawSharing["startTime"]),
          // endTime: DateTime.parse(rawSharing["endTime"]),
          // maximum: rawSharing["maximum"],
          price: rawSharing["price"],
          // channelId: rawSharing["channelId"],
          imageUrl: rawSharing["imageUrl"],
          // topicId: rawSharing["topicName"],
        );
      }).toList();
    } else {
      throw Exception(
          'error fetching Sharings status code:  ${response.statusCode}');
    }
  }
}
