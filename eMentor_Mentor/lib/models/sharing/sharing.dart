import 'dart:convert';

Sharing sharingFromJson(String str) => Sharing.fromJson(json.decode(str));

String sharingToJson(Sharing data) => json.encode(data.toJson());

class Sharing {
  Sharing({
    this.sharingName,
    this.description,
    this.startTime,
    this.endTime,
    this.maximum,
    this.price,
    this.channelId,
    this.imageUrl,
  });

  String sharingName;
  String description;
  DateTime startTime;
  DateTime endTime;
  int maximum;
  int price;
  String channelId;
  String imageUrl;

  factory Sharing.fromJson(Map<String, dynamic> json) => Sharing(
        sharingName: json["sharingName"],
        description: json["description"],
        startTime: DateTime.parse(json["startTime"]),
        endTime: DateTime.parse(json["endTime"]),
        maximum: json["maximum"],
        price: json["price"],
        channelId: json["channelId"],
        imageUrl: json["imageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "sharingName": sharingName,
        "description": description,
        "startTime": startTime.toIso8601String(),
        "endTime": endTime.toIso8601String(),
        "maximum": maximum,
        "price": price,
        "channelId": channelId,
        "imageUrl": imageUrl,
      };
}
