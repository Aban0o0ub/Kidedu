import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: "Change Password",
          onBackPressed: () => Navigator.pop(context),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _buildPasswordField(
                controller: oldPasswordController,
                label: "Old Password",
                obscureText: _obscureOld,
                onToggle: () => setState(() => _obscureOld = !_obscureOld),
              ),
              const SizedBox(height: 20),
              _buildPasswordField(
                controller: newPasswordController,
                label: "New Password",
                obscureText: _obscureNew,
                onToggle: () => setState(() => _obscureNew = !_obscureNew),
              ),
              const SizedBox(height: 20),
              _buildPasswordField(
                controller: confirmPasswordController,
                label: "Confirm New Password",
                obscureText: _obscureConfirm,
                onToggle: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),
              const SizedBox(height: 40),
             CustomButton(onPressed:(){},text: "Change", ),
            ],
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
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(
        color: Color(0xFF02457A),
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          label == "Old Password" ? Icons.lock_open : Icons.lock,
          color: Color(0xFF02457A),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_outlined : Icons.visibility_off,
            color: Colors.white60,
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
