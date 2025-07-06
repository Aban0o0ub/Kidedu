import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loginpage/features/sign_up/data/models/kid.dart';
import 'package:loginpage/features/sign_up/logic/cubit/my_cubit.dart';
import 'package:loginpage/features/sign_up/ui/widgets/auth_prompt.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_button.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_dropdown.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_text_field.dart';
import 'package:loginpage/features/sign_up/ui/widgets/header_title.dart';
import 'package:loginpage/features/sign_up/ui/widgets/icon_button.dart';
import 'package:loginpage/features/sign_up/ui/widgets/or_divider.dart';
import 'package:loginpage/features/sign_up/ui/widgets/select_gender.dart';
import '../../../../core/regex/app_regex.dart';
import '../../../../core/routing/routes.dart';

class KidAuthBody extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController ageController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController phoneNumberController;
  final TextEditingController governmentController;
  final bool obscurePassword;
  final Function togglePasswordVisibility;
  final String? Function(String?) validateEmail;
  final String? Function(String?) validatePassword;
  final Function(String)? onGenderSelected;

  const KidAuthBody({
    super.key,
    required this.nameController,
    required this.ageController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.phoneNumberController,
    required this.governmentController,
    required this.obscurePassword,
    required this.togglePasswordVisibility,
    required this.validateEmail,
    required this.validatePassword,
    required this.onGenderSelected,
  });

  @override
  KidAuthBodyState createState() => KidAuthBodyState();
}

class KidAuthBodyState extends State<KidAuthBody> {
  String? _selectedGender;
  final _formKey = GlobalKey<FormState>();
  bool isSubmitted = false;
  // final TextEditingController _emailController = TextEditingController();

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
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != widget.passwordController.text) {
      return 'Passwords do not match';
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 200),
        Form(
          key: _formKey,
          autovalidateMode: isSubmitted
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const CustomTitle(text: 'Sign Up'),
                const SizedBox(height: 12),
                CustomTextField(
                  label: 'Name',
                  hintText: 'Enter your name',
                  controller: widget.nameController,
                  icon: Icons.person,
                  width: double.infinity,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                CustomDropdownField(
                  label: 'Governorate',
                  hintText: 'Select item',
                  controller: widget.governmentController,
                  items: egyptianGovernorates,
                  icon: Icons.location_city,
                  width: double.infinity,
                  height: 48,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a governorate';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  width: double.infinity,
                  label: "Email",
                  icon: Icons.email,
                  hintText: "Your Email",
                  controller: widget.emailController,
                  validator: validateEmail,
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  width: double.infinity,
                  label: "Password",
                  icon: Icons.lock,
                  isPasswordField: widget.obscurePassword,
                  hintText: "Enter your password",
                  controller: widget.passwordController,
                  validator: widget.validatePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      widget.obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () => widget.togglePasswordVisibility(),
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  width: double.infinity,
                  label: "Confirm Password",
                  icon: Icons.lock,
                  hintText: "Re-enter your password",
                  controller: widget.confirmPasswordController,
                  isPasswordField: widget.obscurePassword,
                  validator: widget.validatePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      widget.obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () => widget.togglePasswordVisibility(),
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  width: double.infinity,
                  label: "Phone Number",
                  icon: Icons.phone,
                  hintText: "Enter your phone number",
                  controller: widget.phoneNumberController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  width: double.infinity,
                  icon: Icons.numbers,
                  label: "Age",
                  hintText: "between 0 and 15",
                  keyboardType: TextInputType.number,
                  controller: widget.ageController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    final age = int.tryParse(value);
                    if (age == null || age < 0 || age > 15) {
                      return 'Age must be between 0 and 15';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                SelectGender(
                  onGenderSelected: (String gender) {
                    setState(() {
                      _selectedGender = gender;
                    });
                  },
                  initialGender: '',
                ),
                const SizedBox(height: 20),
                BlocListener<MyCubit, MyState>(
                  listener: (context, state) {
                    if (state is CreateNewKidSuccess) {
                      context.push(Routes.loginPage);
                    } else if (state is MyFailure) {
                      if (state.error != "SIGN_UP_FAILED") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.error)),
                        );
                      }
                    }
                  },
                  child: CustomButton(
                    text: 'Sign Up',
                    onPressed: () async {
                      setState(() {
                        isSubmitted = true;
                      });
                      if (_formKey.currentState!.validate()) {
                        if (_selectedGender == null ||
                            _selectedGender!.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please select gender')),
                          );
                          return;
                        }
                        context.read<MyCubit>().emitCreateNewKid(
                              KidData(
                                age: int.tryParse(widget.ageController.text),
                                name: widget.nameController.text,
                                email: widget.emailController.text,
                                password: widget.passwordController.text,
                                phoneNumber: widget.phoneNumberController.text,
                                gender: _selectedGender,
                                governorate: widget.governmentController.text,
                              ),
                            );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 28),
                const OrDivider(),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Iconbutton(
                      assetPath: 'assets/images/Googleicon.webp',
                      onPressed: () {
                        // Google
                      },
                    ),
                    const SizedBox(width: 20),
                    Iconbutton(
                      assetPath: 'assets/images/facebookicon.png',
                      onPressed: () {
                        // Facebook
                      },
                    ),
                    const SizedBox(width: 20),
                    Iconbutton(
                      assetPath: 'assets/images/appstoreicon.png',
                      onPressed: () {
                        // App Store
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                AuthPrompt(
                  questionText: "Have an account?",
                  actionText: "Login",
                  onActionPressed: () {
                    context.push(Routes.loginPage);
                  },
                ),
                const SizedBox(height: 55),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
