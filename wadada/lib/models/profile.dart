class Profile {
  String memberNickname;
  DateTime memberBirthday;
  String memberGender; // F or M
  String memberEmail;
  String memberProfileImage;
  int memberLevel;
  int memberExp;

  Profile(
      {required this.memberNickname,
      required this.memberBirthday,
      required this.memberGender,
      required this.memberEmail,
      required this.memberProfileImage,
      required this.memberExp,
      required this.memberLevel});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      memberNickname: json['memberNickname'] as String? ?? '',
      memberBirthday: DateTime.parse(json['memberBirthday'] as String),
      memberGender: json['memberGender'] as String? ?? '',
      memberEmail: json['memberEmail'] as String? ?? '',
      memberProfileImage: json['memberProfileImage'] as String? ?? '',
      memberLevel: json['memberLevel'] as int? ?? 0,
      memberExp: json['memberExp'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'memberNickname': memberNickname,
      'memberBirthday': memberBirthday.toIso8601String(),
      'memberGender': memberGender,
      'memberEmail': memberEmail,
      'memberProfileImage': memberProfileImage,
      'memberLevel': memberLevel,
      'memberExp': memberExp,
    };
  }

  @override
  String toString() {
    return 'Profile(memberNickname: $memberNickname, memberBirthday: $memberBirthday, memberGender: $memberGender, memberEmail: $memberEmail, memberProfileImage: $memberProfileImage, memberLevel: $memberLevel, memberExp: $memberExp)';
  }
}
