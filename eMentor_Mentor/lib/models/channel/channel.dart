import 'dart:convert';

List<Channel> channelFromJson(String str) =>
    List<Channel>.from(json.decode(str).map((x) => Channel.fromJson(x)));

String channelToJson(List<Channel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Channel {
  Channel({
    this.channelId,
    this.topicName,
    this.mentorName,
  });

  String channelId;
  String topicName;
  String mentorName;

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
        channelId: json["channelId"],
        topicName: json["topicName"],
        mentorName: json["mentorName"],
      );

  Map<String, dynamic> toJson() => {
        "channelId": channelId,
        "topicName": topicName,
        "mentorName": mentorName,
      };
}
