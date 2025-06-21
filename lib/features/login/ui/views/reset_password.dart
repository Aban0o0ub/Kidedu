import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/regex/app_regex.dart';
import '../../../../core/routing/routes.dart';
import '../../logic/cubit/my_cubit.dart';

class ResetPasswordPage extends StatefulWidget {
  final String? token;
  
  const ResetPasswordPage({
    super.key,
    this.token, String? role,
  });

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool isPasswordVisible = false;
  bool isSubmitted = false;
  String? currentToken;

  @override
  void initState() {
    super.initState();
    _initializeToken();
  }

  void _initializeToken() {
    // أولاً نجرب الـ token اللي جاي من الـ constructor
    if (widget.token != null && widget.token!.isNotEmpty) {
      currentToken = widget.token;
      return;
    }

    // ثانياً نجرب الـ arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic> && args['token'] != null) {
        setState(() {
          currentToken = args['token'];
        });
        return;
      }
      
      // ثالثاً نجرب الـ query parameters (لو استخدمنا GoRouter)
      final uri = Uri.base;
      if (uri.queryParameters.containsKey('token')) {
        setState(() {
          currentToken = uri.queryParameters['token'];
        });
        return;
      }
      
      // لو مش لقينا token، نعرض رسالة خطأ
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid reset link. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  // Validation methods
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

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    } else if (value != newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Color(0xFF02457A)),
        title: const Text(
          "Reset Password",
          style: TextStyle(
            color: Color(0xFF02457A),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            autovalidateMode: isSubmitted
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            child: Column(
              children: [
                // New Password Field
                TextFormField(
                  controller: newPasswordController,
                  obscureText: !isPasswordVisible,
                  validator: validatePassword,
                  style: const TextStyle(color: Color(0xFF02457A)),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF02457A)),
                    hintText: "New Password",
                    hintStyle: const TextStyle(color: Color(0xFF02457A)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF02457A)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF02457A)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF02457A)),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off,
                        color: const Color(0xFF02457A),
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Confirm Password Field
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: !isPasswordVisible,
                  validator: validateConfirmPassword,
                  style: const TextStyle(color: Color(0xFF02457A)),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock, color: Color(0xFF02457A)),
                    hintText: "Confirm New Password",
                    hintStyle: const TextStyle(color: Color(0xFF02457A)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF02457A)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF02457A)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF02457A)),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                
                // Reset Button with BlocListener
                BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) {
                    if (state is ResetPasswordSuccess) {
                      // Success - navigate to login or show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.response.message),
                          backgroundColor: Colors.green,
                        ),
                      );
                      // Navigate to login page
                      context.pushReplacement(Routes.loginPage); // أو الـ route المناسب
                    } else if (state is ResetPasswordFailure) {
                      // Error - show error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.error),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: state is ResetPasswordLoading
                            ? null
                            : () {
                                setState(() {
                                  isSubmitted = true;
                                });
                                
                                if (_formKey.currentState!.validate()) {
                                  // التحقق من وجود الـ token
                                  if (currentToken == null || currentToken!.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Invalid reset link'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }
                                  
                                  // استدعاء الـ cubit method
                                  context.read<LoginCubit>().emitResetPassword(
                                    newPassword: newPasswordController.text.trim(),
                                    token: currentToken!,
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: state is ResetPasswordLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "Reset Password",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
