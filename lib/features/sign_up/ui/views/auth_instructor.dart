import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/injection/injection.dart';
import '../../../../core/widgets/arrow_back.dart';
import '../../logic/cubit/my_cubit.dart';
import '../widgets/Instructor_auth_body.dart';
import '../widgets/upper_stickers_photo.dart';

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

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    if (!RegExp(r'^[A-Z][a-zA-Z]*$').hasMatch(value)) {
      return 'Name must start with a capital letter and contain only letters';
    }
    return null;
  }

  String? validateGovernorate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a governorate';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

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
    return null;
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    if (!RegExp(r'^\d{11}$').hasMatch(value)) {
      return 'Phone number must be exactly 11 digits';
    }
    return null;
  }

  String? validateBio(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your bio';
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
