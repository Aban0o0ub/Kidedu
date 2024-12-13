import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/core/injection/injection.dart';
import 'package:loginpage/core/widgets/arrow_back.dart';
import 'package:loginpage/features/sign_up/logic/cubit/my_cubit.dart';
import 'package:loginpage/features/sign_up/ui/widgets/kid_auth_body.dart';
import 'package:loginpage/features/sign_up/ui/widgets/upper_stickers_photo.dart';

class AuthKid extends StatefulWidget {
  const AuthKid({super.key});

  @override
  State<AuthKid> createState() => _AuthKidState();
}

class _AuthKidState extends State<AuthKid> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _governmentController = TextEditingController();
  TextEditingController _selectedGenderController = TextEditingController();
  bool _obscurePassword = true;

  void togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MyCubit>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Stack(
              children: [
                const UpperStickersPhoto(),
                const ArrowBack(),
                KidAuthBody(
                  governmentController: _governmentController,
                  phoneNumberController: _phoneNumberController,
                  nameController: _nameController,
                  ageController: _ageController,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  confirmPasswordController: _confirmPasswordController,
                  obscurePassword: _obscurePassword,
                  togglePasswordVisibility: togglePasswordVisibility,
                  validateEmail: validateEmail,
                  validatePassword: validatePassword,
                  onGenderSelected: (String gender) {
                    setState(() {
                      _selectedGenderController.text = gender;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
