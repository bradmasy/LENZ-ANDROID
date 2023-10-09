class AppUser {
  int? userid;
  String? username;
  String? email;
  String? token;

  @override
  String toString() {
    return 'AppUser{userid: $userid, username: $username, email: $email, token: $token}';
  }
}
