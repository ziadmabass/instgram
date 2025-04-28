class UserModel {
  final String uid;
  final String username;
  final String email;
  final String profile;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.profile,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      profile: map['profile'] ?? '',
    );
  }
}
