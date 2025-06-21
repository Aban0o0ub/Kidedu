import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/injection/injection.dart';
import '../../../../core/regex/app_regex.dart';
import '../../../sign_up/ui/widgets/custom_button.dart';
import '../../../sign_up/ui/widgets/custom_text_field.dart';
import '../../logic/cubit/my_cubit.dart';

class SendResetLinkPage extends StatefulWidget {
  const SendResetLinkPage({super.key});

  @override
  SendResetLinkPageState createState() => SendResetLinkPageState();
}

class SendResetLinkPageState extends State<SendResetLinkPage> {
  bool isSubmitted = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  LoginCubit authCubit =
      getIt<LoginCubit>(); 

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!AppRegex.isValidEmail(value)) {
      return 'Please enter a valid email';
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
          'Send reset link',
          style: TextStyle(
            color: Color(0xFF02457A),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: BlocListener<LoginCubit, LoginState>(
          // أو LoginState حسب implementation بتاعك
          listener: (context, state) {
            if (state is ForgetPasswordSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.response.message),
                  backgroundColor: Colors.green,
                ),
              );
              // Navigate back or to verification page
              Navigator.pop(context);
            } else if (state is ForgetPasswordFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: _formKey,
                autovalidateMode: isSubmitted
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    BlocBuilder<RoleCubit, String?>(
                      builder: (context, role) {
                        return role != null
                            ? Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF02457A).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xFF02457A)
                                        .withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.person,
                                      color: Color(0xFF02457A),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Reset password for: ${role.toUpperCase()}',
                                      style: const TextStyle(
                                        color: Color(0xFF02457A),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink();
                      },
                    ),

                    // Email Field - استخدم نفس style الـ CustomTextField لو موجود
                    CustomTextField(
                      width: 360,
                      label: "Email",
                      icon: Icons.email,
                      hintText: "Your Email",
                      controller: _emailController,
                      validator: validateEmail,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),

                    const SizedBox(height: 40),

                    // Send Button
                    BlocBuilder<LoginCubit, LoginState>(
                      builder: (context, state) {
                        return CustomButton(
                          onPressed: () {
                            if (state is ForgetPasswordLoading) {
                              return;
                            }

                            setState(() {
                              isSubmitted = true;
                            });

                            if (_formKey.currentState!.validate()) {
                              final email = _emailController.text.trim();
                              final role = context.read<RoleCubit>().state;

                              context.read<LoginCubit>().emitForgetPassword(
                                    email: email,
                                    role: role,
                                  );
                            }
                          },
                          child: state is ForgetPasswordLoading
                              ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Sending...',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                )
                              : const Text(
                                  'Send reset link',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
