class CurrentMember {
  final String memberNickname;
  final String memberGender;
  final String memberProfileImage;
  final String memberId;
  final int memberLevel;
  final bool memberReady;
  final bool manager;

  CurrentMember({
    required this.memberNickname,
    required this.memberGender,
    required this.memberProfileImage,
    required this.memberId,
    required this.memberLevel,
    required this.memberReady,
    required this.manager,
  });

  // Deserialize from JSON
  factory CurrentMember.fromJson(Map<String, dynamic> json) {
    return CurrentMember(
      memberNickname: json['memberNickname'],
      memberGender: json['memberGender'],
      memberProfileImage: json['memberProfileImage'],
      memberId: json['memberId'],
      memberLevel: json['memberLevel'],
      memberReady: json['memberReady'],
      manager: json['manager'],
    );
  }

  // Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'memberNickname': memberNickname,
      'memberGender': memberGender,
      'memberProfileImage': memberProfileImage,
      'memberId': memberId,
      'memberLevel': memberLevel,
      'memberReady': memberReady,
      'manager': manager,
    };
  }
}
