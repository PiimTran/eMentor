import 'dart:convert';

import 'package:ementor_demo/models/mentor/mentor_info.dart';
import 'package:ementor_demo/models/sharing/sharing_info.dart';

import '../model.dart';

List<ChannelSharing> channelSharingFromJson(String str) =>
    List<ChannelSharing>.from(
        json.decode(str).map((x) => ChannelSharing.fromJson(x)));

String channelSharingToJson(List<ChannelSharing> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChannelSharing {
  ChannelSharing({
    this.channelId,
    this.topic,
    this.mentor,
    this.sharing,
    this.subscription,
  });

  String channelId;
  Topic topic;
  MentorInfo mentor;
  List<SharingInfo> sharing;
  List<dynamic> subscription;

  factory ChannelSharing.fromJson(Map<String, dynamic> json) => ChannelSharing(
        channelId: json["channelId"],
        topic: Topic.fromJson(json["topic"]),
        mentor: MentorInfo.fromJson(json["mentor"]),
        sharing: List<SharingInfo>.from(
            json["sharing"].map((x) => SharingInfo.fromJson(x))),
        subscription: List<dynamic>.from(json["subscription"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "channelId": channelId,
        "topic": topic.toJson(),
        "mentor": mentor.toJson(),
        "sharing": List<dynamic>.from(sharing.map((x) => x.toJson())),
        "subscription": List<dynamic>.from(subscription.map((x) => x)),
      };
}
