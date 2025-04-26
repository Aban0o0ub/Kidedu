class User {
  final String? email;
  final String? password;
  final String? role; 

  User({this.email, this.password, this.role}); 

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['Email'],
      password: json['Password'],
      role: json['role'], 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Email': email,
      'Password': password,
      'role': role, 
    };
  }
}
