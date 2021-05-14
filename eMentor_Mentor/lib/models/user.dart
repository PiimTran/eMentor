import 'dart:convert';

List<User> userFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));
String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.email,
    this.phone,
    this.fullname,
    this.yearOfBirth,
    this.avatarUrl,
  });

  String email;
  String phone;
  String fullname;
  int yearOfBirth;
  String avatarUrl;

  factory User.fromJson(Map<String, dynamic> json) => User(
        email: json["email"],
        phone: json["phone"],
        fullname: json["fullname"],
        yearOfBirth: json["yearOfBirth"],
        avatarUrl: json["avatarUrl"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "phone": phone,
        "fullname": fullname,
        "yearOfBirth": yearOfBirth,
        "avatarUrl": avatarUrl,
      };
}
