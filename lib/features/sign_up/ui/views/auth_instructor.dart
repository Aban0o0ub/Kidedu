import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/core/injection/injection.dart';
import 'package:loginpage/core/widgets/arrow_back.dart';
import 'package:loginpage/features/sign_up/logic/cubit/my_cubit.dart';
import 'package:loginpage/features/sign_up/ui/widgets/Instructor_auth_body.dart';
import 'package:loginpage/features/sign_up/ui/widgets/upper_stickers_photo.dart';

class AuthInstructor extends StatefulWidget {
  const AuthInstructor({super.key});

  @override
  AuthInstructorState createState() => AuthInstructorState();
}

class AuthInstructorState extends State<AuthInstructor> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _governmentController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool _obscurePassword = true;

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

  void togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  final List<String> egyptianGovernorates = [
    'Alexandria',
    'Aswan',
    'Asyut',
    'Beheira',
    'Beni Suef',
    'Cairo',
    'Dakahlia',
    'Damietta',
    'Faiyum',
    'Gharbia',
    'Giza',
    'Ismailia',
    'Kafr El Sheikh',
    'Luxor',
    'Matruh',
    'Minya',
    'Monufia',
    'New Valley',
    'North Sinai',
    'Port Said',
    'Qalyubia',
    'Qena',
    'Red Sea',
    'Sharqia',
    'Sohag',
    'South Sinai',
    'Suez'
  ];

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
                InstructorAuthBody(
                  nameController: _nameController,
                  governmentController: _governmentController,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  confirmPasswordController: _confirmPasswordController,
                  phoneNumberController: _phoneNumberController,
                  bioController: _bioController,
                  obscurePassword: _obscurePassword,
                  togglePasswordVisibility: togglePasswordVisibility,
                  egyptianGovernorates: egyptianGovernorates,
                  validateEmail: validateEmail,
                  validatePassword: validatePassword,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
