import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ementor_demo/models/model.dart';
import 'package:http/http.dart' as http;
import 'package:equatable/equatable.dart';

part 'major_event.dart';
part 'major_state.dart';

class MajorBloc extends Bloc<MajorEvent, MajorState> {
  final http.Client httpClient;

  MajorBloc({this.httpClient});

  @override
  MajorState get initialState => MajorInitial();

  @override
  Stream<MajorState> mapEventToState(MajorEvent event) async* {
    final currentState = state;

    if(event is MajorFetched) {
      try {
        if(currentState is MajorInitial) {
          final majors = await _fetchMajors();
          yield MajorSuccess(majors: majors);
          return;
        }
      } catch (_) {
        yield MajorFailure();
      }
    }
  }

  Future<List<Major>> _fetchMajors() async {
    final response = await httpClient.get('https://ementorapi.azurewebsites.net/api/majors/topics');
    if(response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((rawMajor){
        return Major(
          majorId: rawMajor["majorId"],
        majorName: rawMajor["majorName"],
        topics : List<Topic>.from(rawMajor["topics"].map((x) => Topic.fromJson(x))),
        );
      }).toList();
    } 
    else {
      throw Exception('error fetching Majors status code:  ${response.statusCode}');
    }
  }
 }
