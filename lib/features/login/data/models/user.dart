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

///////////////////////////////////////////////// 
class ForgetPasswordResponse {
  final String message;
  final String? token; // خليها nullable

  ForgetPasswordResponse({
    required this.message,
    this.token,
  });

  factory ForgetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgetPasswordResponse(
      message: json['message'] ?? '',
      token: json['token'], // ممكن تبقى null
    );
  }

  @override
  String toString() =>
      'ForgetPasswordResponse(message: $message, token: ${token != null ? token!.substring(0, 10) + "..." : "null"})';
}


class ForgetPasswordRequest {
  final String email;
  final String role;
  
  ForgetPasswordRequest({
    required this.email,
    required this.role,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'role': role,
    };
  }
  
  @override
  String toString() => 'ForgetPasswordRequest(email: $email, role: $role)';
}

class ResetPasswordRequest {
  final String newPassword;
  //final String role;
  //final String token;

  ResetPasswordRequest({
    required this.newPassword,
   // required this.role,
  //  required this.token,
  });

  Map<String, dynamic> toJson() {
    return {
      'newPassword': newPassword,
     // 'role': role,
     // 'token': token,
    };
  }

  @override
  String toString() =>
      'ResetPasswordRequest(newPassword: [HIDDEN],';
}


