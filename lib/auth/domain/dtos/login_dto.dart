class LoginDTO {
  String email;
  String password;

  LoginDTO(this.email, this.password);

  Map<String, dynamic> toJson() => {"email": email, "password": password};
}
