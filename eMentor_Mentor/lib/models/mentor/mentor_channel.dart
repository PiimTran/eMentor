import 'dart:convert';

import 'package:ementor_demo/models/channel/channel.dart';
import 'package:ementor_demo/models/user.dart';

List<MentorChannel> mentorChannelFromJson(String str) =>
    List<MentorChannel>.from(
        json.decode(str).map((x) => MentorChannel.fromJson(x)));

String mentorChannelToJson(List<MentorChannel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MentorChannel {
  MentorChannel({
    this.mentorId,
    this.user,
    this.channels,
    this.isDisable,
  });

  String mentorId;
  User user;
  List<Channel> channels;
  bool isDisable;

  factory MentorChannel.fromJson(Map<String, dynamic> json) => MentorChannel(
        mentorId: json["mentorId"],
        user: User.fromJson(json["user"]),
        channels: List<Channel>.from(
            json["channels"].map((x) => Channel.fromJson(x))),
        isDisable: json["isDisable"],
      );

  Map<String, dynamic> toJson() => {
        "mentorId": mentorId,
        "user": user.toJson(),
        "channels": List<dynamic>.from(channels.map((x) => x.toJson())),
        "isDisable": isDisable,
      };
}
