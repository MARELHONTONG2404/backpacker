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
    int readInt(dynamic value) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return UserProfile(
      userId: readInt(json['userId']),
      username: json['username'] as String? ?? '',
      nickName: json['nickName'] as String? ?? '',
      phonenumber: json['phonenumber'] as String?,
    );
  }
}
