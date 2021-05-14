import 'dart:convert';

import 'package:ementor_demo/models/channel/channel.dart';

List<SharingDetail> sharingDetailFromJson(String str) =>
    List<SharingDetail>.from(
        json.decode(str).map((x) => SharingDetail.fromJson(x)));

String sharingDetailToJson(List<SharingDetail> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SharingDetail {
  SharingDetail({
    this.sharingId,
    this.sharingName,
    this.description,
    this.startTime,
    this.endTime,
    this.maximum,
    this.price,
    this.channelId,
    this.imageUrl,
    this.isDisable,
    this.isApproved,
    this.approvedTime,
    this.channel,
    this.comment,
    this.enroll,
  });

  String sharingId;
  String sharingName;
  String description;
  DateTime startTime;
  DateTime endTime;
  int maximum;
  int price;
  String channelId;
  String imageUrl;
  bool isDisable;
  bool isApproved;
  dynamic approvedTime;
  Channel channel;
  dynamic comment;
  dynamic enroll;

  factory SharingDetail.fromJson(Map<String, dynamic> json) => SharingDetail(
        sharingId: json["sharingId"],
        sharingName: json["sharingName"],
        description: json["description"],
        startTime: DateTime.parse(json["startTime"]),
        endTime: DateTime.parse(json["endTime"]),
        maximum: json["maximum"],
        price: json["price"],
        channelId: json["channelId"],
        imageUrl: json["imageUrl"],
        isDisable: json["isDisable"],
        isApproved: json["isApproved"],
        approvedTime: json["approvedTime"],
        channel: Channel.fromJson(json["channel"]),
        comment: json["comment"],
        enroll: json["enroll"],
      );

  Map<String, dynamic> toJson() => {
        "sharingId": sharingId,
        "sharingName": sharingName,
        "description": description,
        "startTime": startTime.toIso8601String(),
        "endTime": endTime.toIso8601String(),
        "maximum": maximum,
        "price": price,
        "channelId": channelId,
        "imageUrl": imageUrl,
        "isDisable": isDisable,
        "isApproved": isApproved,
        "approvedTime": approvedTime,
        "channel": channel.toJson(),
        "comment": comment,
        "enroll": enroll,
      };
}
