// ignore_for_file: file_names

class AccountData {
  String? email;
  String? username;
  String? uid;
  String? phone;
  bool dark;

  AccountData({
    this.email,
    this.username,
    this.phone,
    this.uid,
    required this.dark,
  });

  factory AccountData.fromFireStore(dynamic data) {
    return AccountData(
      email: data['email'],
      username: data['username'],
      phone: data['phone'],
      uid: data['uid'],
      dark: data['dark'] as bool,
    );
  }

  void setnull() {
    email = null;
    username = null;
    uid = null;
    phone = null;
    dark = false;
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
      'phone': phone,
      'uid': uid,
      'dark': dark,
    };
  }

  @override
  String toString() {
    return "Email: $email\nUsername: $username\nPhone: $phone\nuid: $uid\nDark: $dark\n";
  }
}
