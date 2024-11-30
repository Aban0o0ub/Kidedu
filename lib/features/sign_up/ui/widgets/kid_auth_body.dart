import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/features/home/ui/home_page.dart';
import 'package:loginpage/features/login/ui/login_page.dart';
import 'package:loginpage/features/sign_up/data/models/kid.dart';
import 'package:loginpage/features/sign_up/logic/cubit/my_cubit.dart';
import 'package:loginpage/features/sign_up/ui/widgets/auth_prompt.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_button.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_dropdown.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_text_field.dart';
import 'package:loginpage/features/sign_up/ui/widgets/header_title.dart';
import 'package:loginpage/features/sign_up/ui/widgets/icon_button.dart';
import 'package:loginpage/features/sign_up/ui/widgets/or_divider.dart';

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
  });

  @override
  KidAuthBodyState createState() => KidAuthBodyState();
}

class KidAuthBodyState extends State<KidAuthBody> {
  String? _selectedGender;

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

  void _selectGender(String value) {
    setState(() {
      _selectedGender = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 200),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const CustomTitle(text: 'Sign Up'),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTextField(
                    label: 'Name',
                    hintText: 'Enter your name',
                    controller: widget.nameController,
                    icon: Icons.person,
                    width: 180,
                  ),
                  CustomDropdownField(
                    label: 'Government',
                    hintText: 'Select item',
                    controller: widget.governmentController,
                    items: egyptianGovernorates,
                    icon: Icons.location_city,
                    width: 180,
                    height: 48,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              CustomTextField(
                width: double.infinity,
                label: "Email",
                icon: Icons.email,
                hintText: "Your Email",
                controller: widget.emailController,
                validator: widget.validateEmail,
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
              ),
              const SizedBox(height: 8),
              CustomTextField(
                width: double.infinity,
                icon: Icons.numbers,
                label: "Age",
                hintText: "between 0 and 15",
                keyboardType: TextInputType.number,
                controller: widget.ageController,
              ),
              const SizedBox(height: 15),
              Column(
                children: [
                  const Text(
                    "Gender",
                    style: TextStyle(
                      color: Color(0xFF02457A),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => _selectGender('Female'),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/femaleicon.png',
                              width: 50,
                              height: 50,
                            ),
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'Female',
                                  groupValue: _selectedGender,
                                  onChanged: (value) => _selectGender(value!),
                                ),
                                const Text("Female",
                                    style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 30),
                      GestureDetector(
                        onTap: () => _selectGender('Male'),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/maleicon.png',
                              width: 50,
                              height: 50,
                            ),
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'Male',
                                  groupValue: _selectedGender,
                                  onChanged: (value) => _selectGender(value!),
                                ),
                                const Text("Male",
                                    style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              BlocListener<MyCubit, MyState>(
                listener: (context, state) {
                  if (state is CreateNewKidSuccess) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  } else if (state is MyFailure) {
                    // هنا إذا كانت حالة الفشل
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  }
                },
                child: CustomButton(
                  text: 'Sign Up',
                  onPressed: () {
                    context.read<MyCubit>().emitCreateNewKid(
                          Kid(
                            age: int.tryParse(widget.ageController.text),
                            name: widget.nameController.text,
                            email: widget.emailController.text,
                            password: widget.passwordController.text,
                            phoneNumber: widget.phoneNumberController.text,
                            gender: _selectedGender ?? '',
                            governorate: widget.governmentController.text,
                          ),
                        );
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
              ),
              const SizedBox(height: 55),
            ],
          ),
        ),
      ],
    );
  }
}
