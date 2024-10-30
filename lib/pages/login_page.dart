import 'package:flutter/material.dart';
import 'package:loginpage/pages/role_page.dart';
import 'package:loginpage/widgets/auth_prompt.dart';
import 'package:loginpage/widgets/custom_button.dart';
import 'package:loginpage/widgets/custom_text_field.dart';
import 'package:loginpage/widgets/header_title.dart';
import 'package:loginpage/widgets/icon_button.dart';
import 'package:loginpage/widgets/or_divider.dart';
import 'package:loginpage/widgets/remember_me_checkbox.dart';
import 'package:loginpage/widgets/upper_stickers_photo.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;
  bool _rememberMe = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "البريد الإلكتروني مطلوب.";
    }

    String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(emailPattern);
    if (!regex.hasMatch(value)) {
      return "البريد الإلكتروني غير صحيح.";
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "كلمة المرور مطلوبة.";
    }
    if (value.length < 8) {
      return "يجب أن تتكون كلمة المرور من 8 أحرف على الأقل.";
    }
    return null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              const UpperStickersPhoto(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const CustomTitle(text: 'Log In'),
                    CustomTextField(
                      width: 360,
                      label: "Email",
                      icon: Icons.email,
                      hintText: "Your Email",
                      controller: _emailController,
                      validator: validateEmail,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      width: 360,
                      label: "Password",
                      icon: Icons.lock,
                      hintText: "Password",
                      isPasswordField: _obscurePassword,
                      controller: _passwordController,
                      validator: validatePassword,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: togglePasswordVisibility,
                      ),
                    ),
                    RememberMeCheckbox(
                      rememberMe: _rememberMe,
                      onChanged: (bool? value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      onPressed: () {
                        String? emailError =
                            validateEmail(_emailController.text);
                        String? passwordError =
                            validatePassword(_passwordController.text);

                        if (emailError != null) {
                          _showErrorMessage(
                              emailError); // عرض رسالة الخطأ للبريد الإلكتروني
                        } else if (passwordError != null) {
                          _showErrorMessage(
                              passwordError); // عرض رسالة الخطأ لكلمة المرور
                        } else {
                          print(
                              "البريد الإلكتروني: ${_emailController.text}, كلمة المرور: ${_passwordController.text}");
                        }
                      },
                    ),
                    const SizedBox(height: 28),
                    const OrDivider(),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Iconbutton(
                          assetPath: 'assets/images/Googleicon.webp',
                          onPressed: () {},
                        ),
                        const SizedBox(width: 20),
                        Iconbutton(
                          assetPath: 'assets/images/facebookicon.png',
                          onPressed: () {},
                        ),
                        const SizedBox(width: 20),
                        Iconbutton(
                          assetPath: 'assets/images/appstoreicon.png',
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    AuthPrompt(
                      questionText: "Don’t have an account?",
                      actionText: "Sign up",
                      onActionPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RoleSelectionPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
