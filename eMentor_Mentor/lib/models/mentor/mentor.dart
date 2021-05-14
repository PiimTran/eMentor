import 'dart:convert';

import 'package:ementor_demo/models/user.dart';

Mentor mentorFromJson(String str) => Mentor.fromJson(json.decode(str));

String mentorToJson(Mentor data) => json.encode(data.toJson());

class Mentor {
  Mentor({
    this.user,
  });

  User user;

  factory Mentor.fromJson(Map<String, dynamic> json) => Mentor(
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
      };
}
