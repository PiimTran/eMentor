import 'dart:convert';

import 'package:ementor_demo/models/channel/channel.dart';

import '../mentor/mentor.dart';
import '../model.dart';
import '../subscription.dart';

List<ChannelDetail> channelDetailFromJson(String str) =>
    List<ChannelDetail>.from(
        json.decode(str).map((x) => ChannelDetail.fromJson(x)));

String channelDetailToJson(List<ChannelDetail> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChannelDetail {
  ChannelDetail({
    this.channelId,
    this.topic,
    this.mentor,
    this.sharing,
    this.subscription,
  });

  String channelId;
  Topic topic;
  Mentor mentor;
  List<Sharing> sharing;
  List<Subscription> subscription;

  factory ChannelDetail.fromJson(Map<String, dynamic> json) => ChannelDetail(
        channelId: json["channelId"],
        topic: Topic.fromJson(json["topic"]),
        mentor: Mentor.fromJson(json["mentor"]),
        sharing:
            List<Sharing>.from(json["sharing"].map((x) => Sharing.fromJson(x))),
        subscription: List<Subscription>.from(
            json["subscription"].map((x) => Subscription.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "channelId": channelId,
        "topic": topic.toJson(),
        "mentor": mentor.toJson(),
        "sharing": List<dynamic>.from(sharing.map((x) => x.toJson())),
        "subscription": List<dynamic>.from(subscription.map((x) => x.toJson())),
      };
}
