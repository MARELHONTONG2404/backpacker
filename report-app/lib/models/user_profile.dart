class UserProfile {
  UserProfile({
    required this.userId,
    required this.username,
    required this.nickName,
    this.phonenumber,
  });

  final int userId;
  final String username;
  final String nickName;
  final String? phonenumber;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['userId'] as int? ?? 0,
      username: json['username'] as String? ?? '',
      nickName: json['nickName'] as String? ?? '',
      phonenumber: json['phonenumber'] as String?,
    );
  }
}
