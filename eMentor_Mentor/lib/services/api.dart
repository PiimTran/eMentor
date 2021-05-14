import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:ementor_demo/models/channel/channel_create.dart';
import 'package:ementor_demo/models/channel/channel_detail.dart';
import 'package:ementor_demo/models/channel/channel_sharing.dart';
import 'package:ementor_demo/models/major.dart';
import 'package:ementor_demo/models/mentor/mentor.dart';
import 'package:ementor_demo/models/mentor/mentor_channel.dart';
import 'package:ementor_demo/models/model.dart';
import 'package:ementor_demo/models/sharing/sharing_detail.dart';
import 'package:ementor_demo/models/user.dart';
import 'package:http/http.dart' as http;

String url = 'https://ementorapi.azurewebsites.net/api';

Future<http.Response> createUser(User user) async {
  final response = await http.post(
    '$url/users',
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: userToJson(user),
  );
  return response;
}

Future<List<User>> getUser() async {
  final response = await http.get('$url/users');
  return userFromJson(response.body);
}

Future<http.Response> createMentor(Mentor mentor) async {
  final response = await http.post(
    '$url/mentors',
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: mentorToJson(mentor),
  );
  return response;
}

Future<String> getMentorId(String email) async {
  var emailStrings = email.split('@');
  final response = await http
      .get('$url/mentors/auth/${emailStrings[0]}%40${emailStrings[1]}');
  return response.body;
}

Future<List<Major>> getMajorList() async {
  final response =
      await http.get('https://ementorapi.azurewebsites.net/api/majors/topics');
  if (response.statusCode == 200) {
    final data = json.decode(response.body) as List;
    return data.map((rawMajor) {
      return Major(
        majorId: rawMajor["majorId"],
        majorName: rawMajor["majorName"],
        topics:
            List<Topic>.from(rawMajor["topics"].map((x) => Topic.fromJson(x))),
      );
    }).toList();
  } else {
    throw Exception(
        'error fetching Majors status code:  ${response.statusCode}');
  }
}

Future<http.Response> createChannel(ChannelCreate channel) async {
  final response = await http.post(
    '$url/channels',
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: channelCreateToJson(channel),
  );
  return response;
}

Future<List<MentorChannel>> getChannelById(String email) async {
  String id = await getMentorId(email);
  // print(id);
  final response = await http.get('$url/mentors/$id');
  if (response.statusCode == 200) {
    // print(response.body);
    return mentorChannelFromJson(response.body);
  } else {
    throw Exception(
        'error get mentor channel status code:  ${response.statusCode}');
  }
}

Future<http.Response> createSharing(Sharing sharing) async {
  final response = await http.post(
    '$url/sharings',
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: sharingToJson(sharing),
  );
  return response;
}

Future<List<ChannelSharing>> getSharingById(String id) async {
  final response = await http.get('$url/channels/$id');
  if (response.statusCode == 200) {
    return channelSharingFromJson(response.body);
  } else {
    throw Exception(
        'error get mentor channel status code:  ${response.statusCode}');
  }
}

Future<List<SharingDetail>> getSharingDetailById(String id) async {
  final response = await http.get('$url/sharings/$id');
  if (response.statusCode == 200) {
    return sharingDetailFromJson(response.body);
  } else {
    throw Exception(
        'error get mentor channel status code:  ${response.statusCode}');
  }
}
