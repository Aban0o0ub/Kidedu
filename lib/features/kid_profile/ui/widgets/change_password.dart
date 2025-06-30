import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/core/regex/app_regex.dart';
import 'package:loginpage/features/kid_profile/logic/cubit/kid_profile_cubit.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_button.dart';
import '../../../../core/widgets/appbar.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    if (!AppRegex.hasSpecialCharacter(value)) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: "Change Password",
          onBackPressed: () => Navigator.pop(context),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildPasswordField(
                  controller: oldPasswordController,
                  label: "Old Password",
                  obscureText: _obscureOld,
                  onToggle: () => setState(() => _obscureOld = !_obscureOld),
                  validator: validatePassword,
                ),
                const SizedBox(height: 20),
                _buildPasswordField(
                  controller: newPasswordController,
                  label: "New Password",
                  obscureText: _obscureNew,
                  onToggle: () => setState(() => _obscureNew = !_obscureNew),
                  validator: validatePassword,
                ),
                const SizedBox(height: 20),
                _buildPasswordField(
                  controller: confirmPasswordController,
                  label: "Confirm New Password",
                  obscureText: _obscureConfirm,
                  onToggle: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != newPasswordController.text.trim()) {
                      return 'New password and confirmation do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                BlocConsumer<KidProfileCubit, KidProfileState>(
                  listener: (context, state) {
                    if (state is ChangePasswordSuccess) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Row(
                            children: const [
                              Icon(Icons.check_circle, color: Colors.green),
                              SizedBox(width: 8),
                              Text(
                                'Success',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          content: const Text(
                            'Password changed successfully',
                            style: TextStyle(fontSize: 16),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: const Color(0xFF02457A),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    } else if (state is ChangePasswordFailure) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Row(
                            children: const [
                              Icon(Icons.warning, color: Colors.amber),
                              SizedBox(width: 8),
                              Text(
                                'Password Change Failed',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          content: Text(
                            state.error.replaceAll("Exception:", "").trim(),
                            style: const TextStyle(fontSize: 16),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: const Color(0xFF02457A),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return CustomButton(
                      text: 'Change',
                      onPressed: () {
                        if (_formKey.currentState?.validate() != true) return;

                        final oldPassword = oldPasswordController.text.trim();
                        final newPassword = newPasswordController.text.trim();

                        if (oldPassword == newPassword) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Row(
                                children: const [
                                  Icon(Icons.warning, color: Colors.amber),
                                  SizedBox(width: 8),
                                  Text(
                                    'Password Change Failed',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              content: const Text(
                                'New password must be different from old password',
                                style: TextStyle(fontSize: 16),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: const Color(0xFF02457A),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                          return;
                        }

                        context.read<KidProfileCubit>().emitChangePassword(
                              oldPassword: oldPassword,
                              newPassword: newPassword,
                            );
                      },
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

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggle,
    required String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(
          label == "Old Password" ? Icons.lock_open : Icons.lock,
          color: const Color(0xFF02457A),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_outlined : Icons.visibility_off,
            color: const Color(0xFF02457A),
          ),
          onPressed: onToggle,
        ),
        labelText: label,
        labelStyle: const TextStyle(
          color: Color(0xFF02457A),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF02457A),
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }
}
