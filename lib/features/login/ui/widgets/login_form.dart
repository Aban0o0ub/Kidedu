import 'package:flutter/material.dart';
import '../../../sign_up/ui/widgets/custom_button.dart';
import '../../../sign_up/ui/widgets/custom_text_field.dart';
import '../../../sign_up/ui/widgets/header_title.dart';
import '../../../../core/regex/app_regex.dart';
import 'remember_me_checkbox.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.onSubmit,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool rememberMe;
  final ValueChanged<bool?> onRememberMeChanged;
  final VoidCallback onSubmit;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!AppRegex.isValidEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (!AppRegex.hasLowercase(value)) {
      return 'Password must contain at least one lowercase letter';
    } else if (!AppRegex.hasUppercase(value)) {
      return 'Password must contain at least one uppercase letter';
    } else if (!AppRegex.hasNumber(value)) {
      return 'Password must contain at least one number';
    } else if (!AppRegex.hasSpecialCharacter(value)) {
      return 'Password must contain at least one special character';
    } else if (!AppRegex.hasMinLength(value)) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          const CustomTitle(text: 'Log In'),
          CustomTextField(
            width: 360,
            label: "Email",
            icon: Icons.email,
            hintText: "Your Email",
            controller: emailController,
            validator: validateEmail,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
          const SizedBox(height: 24),
          CustomTextField(
            width: 360,
            label: "Password",
            icon: Icons.lock,
            hintText: "Password",
            isPasswordField: true,
            controller: passwordController,
            validator: validatePassword,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
          RememberMeCheckbox(
            rememberMe: rememberMe,
            onChanged: onRememberMeChanged,
          ),
          const SizedBox(height: 24),
          CustomButton(onPressed: onSubmit),
        ],
      ),
    );
  }
}
