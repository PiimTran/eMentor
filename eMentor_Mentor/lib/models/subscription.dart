class Subscription {
  Subscription({
    this.subscriptionId,
    this.menteeId,
    this.channelId,
    this.isDisable,
    this.timeSubscripted,
  });

  String subscriptionId;
  String menteeId;
  String channelId;
  bool isDisable;
  DateTime timeSubscripted;

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        subscriptionId: json["subscriptionId"],
        menteeId: json["menteeId"],
        channelId: json["channelId"],
        isDisable: json["isDisable"],
        timeSubscripted: DateTime.parse(json["timeSubscripted"]),
      );

  Map<String, dynamic> toJson() => {
        "subscriptionId": subscriptionId,
        "menteeId": menteeId,
        "channelId": channelId,
        "isDisable": isDisable,
        "timeSubscripted": timeSubscripted.toIso8601String(),
      };
}
