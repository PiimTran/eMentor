import 'dart:convert';

import 'package:ementor_demo/models/model.dart';

Major majorFromJson(String str) => Major.fromJson(json.decode(str));

String majorToJson(Major data) => json.encode(data.toJson());

class Major {
    Major({
        this.majorId,
        this.majorName,
        this.topics,
    });

    String majorId;
    String majorName;
    List<Topic> topics;

    factory Major.fromJson(Map<String, dynamic> json) => Major(
        majorId: json["majorId"],
        majorName: json["majorName"],
        topics: List<Topic>.from(json["topics"].map((x) => Topic.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "majorId": majorId,
        "majorName": majorName,
        "topics": List<dynamic>.from(topics.map((x) => x.toJson())),
    };
}


