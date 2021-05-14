class MentorInfo {
  MentorInfo({
    this.mentorId,
    this.email,
    this.fullname,
    this.avatarUrl,
    this.description,
  });

  String mentorId;
  String email;
  String fullname;
  String avatarUrl;
  String description;

  factory MentorInfo.fromJson(Map<String, dynamic> json) => MentorInfo(
        mentorId: json["mentorId"],
        email: json["email"],
        fullname: json["fullname"],
        avatarUrl: json["avatarUrl"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "mentorId": mentorId,
        "email": email,
        "fullname": fullname,
        "avatarUrl": avatarUrl,
        "description": description,
      };
}
