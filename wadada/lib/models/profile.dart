class Profile {
  String memberNickname;
  DateTime memberBirthday;
  String memberGender; // F or M
  String memberEmail;
  String memberProfileImage;

  Profile({
    required this.memberNickname,
    required this.memberBirthday,
    required this.memberGender,
    required this.memberEmail,
    required this.memberProfileImage,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      memberNickname: json['memberNickname'] as String,
      memberBirthday: DateTime.parse(json['memberBirthday'] as String),
      memberGender: json['memberGender'] as String,
      memberEmail: json['memberEmail'] as String,
      memberProfileImage: json['memberProfileImage'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'memberNickname': memberNickname,
      'memberBirthday': memberBirthday.toIso8601String(),
      'memberGender': memberGender,
      'memberEmail': memberEmail,
      'memberProfileImage': memberProfileImage,
    };
  }

  @override
  String toString() {
    return 'Profile(memberNickname: $memberNickname, memberBirthday: $memberBirthday, memberGender: $memberGender, memberEmail: $memberEmail, memberProfileImage: $memberProfileImage)';
  }
}
