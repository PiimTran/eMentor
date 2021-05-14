import 'dart:convert';

ChannelCreate channelCreateFromJson(String str) =>
    ChannelCreate.fromJson(json.decode(str));

String channelCreateToJson(ChannelCreate data) => json.encode(data.toJson());

class ChannelCreate {
  ChannelCreate({
    this.topicId,
    this.mentorId,
  });

  String topicId;
  String mentorId;

  factory ChannelCreate.fromJson(Map<String, dynamic> json) => ChannelCreate(
        topicId: json["topicId"],
        mentorId: json["mentorId"],
      );

  Map<String, dynamic> toJson() => {
        "topicId": topicId,
        "mentorId": mentorId,
      };
}
