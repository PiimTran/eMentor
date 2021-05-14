class Topic {
  Topic({
    this.topicId,
    this.topicName,
    this.majorId,
    this.createdBy,
  });

  String topicId;
  String topicName;
  String majorId;
  String createdBy;

  factory Topic.fromJson(Map<String, dynamic> json) => Topic(
        topicId: json["topicId"],
        topicName: json["topicName"],
        majorId: json["majorId"],
        createdBy: json["createdBy"],
      );

  Map<String, dynamic> toJson() => {
        "topicId": topicId,
        "topicName": topicName,
        "majorId": majorId,
        "createdBy": createdBy,
      };

  // factory Topic.fromJson(Map<String, dynamic> json) => Topic(
  //     topicId: json["topicId"],
  //     topicName: json["topicName"],
  // );

  // Map<String, dynamic> toJson() => {
  //     "topicId": topicId,
  //     "topicName": topicName,
  // };
}
