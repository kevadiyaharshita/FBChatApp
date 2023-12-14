class UserModal {
  String uid;
  String userName;
  String email;
  String profilePic;

  UserModal({
    required this.uid,
    required this.userName,
    required this.email,
    required this.profilePic,
  });

  factory UserModal.fromMap({required Map data}) {
    return UserModal(
        uid: data['uid'],
        userName: data['userName'],
        email: data['email'],
        profilePic: data['profilePic']);
  }

  Map<String, dynamic> get toMap {
    return {
      'uid': uid,
      'userName': userName,
      'email': email,
      'profilePic': profilePic,
    };
  }
}
