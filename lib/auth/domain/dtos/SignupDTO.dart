class SignupDTO {
  String username;
  String email;
  String password;
  String firstName;
  String lastName;

  SignupDTO(
      this.username, this.email, this.password, this.firstName, this.lastName);

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "password": password,
        "first_name": firstName,
        "last_name": lastName
      };
}
