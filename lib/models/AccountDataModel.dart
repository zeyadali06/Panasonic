// ignore_for_file: file_names

class AccountData {
  String? email;
  String? username;
  String? uid;
  int? phone;
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
      phone: data['phone'] as int,
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

  @override
  String toString() {
    return "Email: $email\nUsername: $username\nPhone: $phone\nuid: $uid\nDark: $dark\n";
  }
}
