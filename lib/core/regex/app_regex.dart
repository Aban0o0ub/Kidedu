class AppRegex {
  // Check if the email is valid
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w\.-]+@[a-zA-Z\d-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  // Check if the password contains at least one lowercase letter
  static bool hasLowercase(String password) {
    return RegExp(r'[a-z]').hasMatch(password);
  }

  // Check if the password contains at least one uppercase letter
  static bool hasUppercase(String password) {
    return RegExp(r'[A-Z]').hasMatch(password);
  }

  // Check if the password contains at least one number
  static bool hasNumber(String password) {
    return RegExp(r'\d').hasMatch(password);
  }

  // Check if the password meets the minimum length requirement
  static bool hasMinLength(String password) {
    return RegExp(r'.{8,}').hasMatch(password);
  }

  // Check if the password contains at least one special character
  static bool hasSpecialCharacter(String password) {
    return RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
  }

  static bool validPhoneNumber(String phoneNumber) {
    return RegExp(r'^01[0-2,5]{1}[0-9]{8}$').hasMatch(phoneNumber);
  }
static bool isValidName(String name) {
  return RegExp(r'^[A-Z][a-zA-Z ]+$').hasMatch(name);
}
 static String? validAge(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your age';
  } else {
    final int? age = int.tryParse(value);
    if (age == null) {
      return 'Age must be a valid number';
    } else if (age < 1) {
      return 'Age must be at least 1 years old';
    } else if (age > 15) {
      return 'Age must be no more than 15 years old';
    } else if (age < 0) {
      return 'Age cannot be negative';
    }
  }
  return null;
}


}
