import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/injection/injection.dart';
import '../../../../core/regex/app_regex.dart';
import '../../../../core/widgets/arrow_back.dart';
import '../../logic/cubit/my_cubit.dart';
import '../widgets/kid_auth_body.dart';
import '../widgets/upper_stickers_photo.dart';

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

String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Name is required';
  } else if (!AppRegex.isValidName(value)) {
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

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    } else if (!AppRegex.validPhoneNumber(value)) {
      return 'Enter a valid Egyptian phone number';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    } else if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }
 String? validateAge(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your age';
  }

  return AppRegex.validAge(value);  
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
                BlocConsumer<MyCubit, MyState>(
                  listener: (context, state) {
                    if (state is MyFailure) {
                      String message = "Something went wrong";
                      if (state.error == "SIGN_UP_FAILED") {
                        message = "This email is already used";
                      }

                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Row(
                            children: const [
                              Icon(Icons.warning, color: Colors.amber),
                              SizedBox(width: 8),
                              Text(
                                'Sign Up Failed',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          content: Text(
                            message,
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

                    if (state is CreateNewKidSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            "Account created successfully",
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.all(10),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return KidAuthBody(
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
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
