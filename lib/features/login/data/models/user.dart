class User {
  final String? email;
  final String? password;

  User({this.email, this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['Email'],
      password: json['Password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Email': email,
      'Password': password,
    };
  }
}
