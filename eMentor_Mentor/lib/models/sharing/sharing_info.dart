class SharingInfo {
  SharingInfo({
    this.sharingId,
    this.sharingName,
    this.price,
    this.mentorName,
    this.startTime,
    this.endTime,
    this.imageUrl,
    this.isApproved,
  });

  String sharingId;
  String sharingName;
  int price;
  String mentorName;
  DateTime startTime;
  DateTime endTime;
  String imageUrl;
  bool isApproved;

  factory SharingInfo.fromJson(Map<String, dynamic> json) => SharingInfo(
        sharingId: json["sharingId"],
        sharingName: json["sharingName"],
        price: json["price"],
        mentorName: json["mentorName"],
        startTime: DateTime.parse(json["startTime"]),
        endTime: DateTime.parse(json["endTime"]),
        imageUrl: json["imageUrl"],
        isApproved: json["isApproved"],
      );

  Map<String, dynamic> toJson() => {
        "sharingId": sharingId,
        "sharingName": sharingName,
        "price": price,
        "mentorName": mentorName,
        "startTime": startTime.toIso8601String(),
        "endTime": endTime.toIso8601String(),
        "imageUrl": imageUrl,
        "isApproved": isApproved,
      };
}
