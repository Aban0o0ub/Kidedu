import 'package:flutter/material.dart';
import 'package:loginpage/features/home/ui/home_page.dart';
import 'package:loginpage/features/login/ui/login_page.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_button.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_dropdown.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_text_field.dart';
import 'package:loginpage/features/sign_up/ui/widgets/header_title.dart';
import 'package:loginpage/features/sign_up/ui/widgets/icon_button.dart';
import 'package:loginpage/features/sign_up/ui/widgets/or_divider.dart';

class KidAuthBody extends StatefulWidget {
  const KidAuthBody({super.key});

  @override
  KidAuthBodyState createState() => KidAuthBodyState();
}

class KidAuthBodyState extends State<KidAuthBody> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _governmentController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  bool _obscurePassword = true;
  String? _selectedGender;

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

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _selectGender(String value) {
    setState(() {
      _selectedGender = value;
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
                    controller: _nameController,
                    icon: Icons.person,
                    width: 180,
                  ),
                  CustomDropdownField(
                    label: 'Government',
                    hintText: 'Select item',
                    controller: _governmentController,
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
                controller: _emailController,
              ),
              const SizedBox(height: 8),
              CustomTextField(
                width: double.infinity,
                label: "Password",
                icon: Icons.lock,
                isPasswordField: _obscurePassword,
                hintText: "Enter your password",
                controller: _passwordController,
                validator: validatePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: togglePasswordVisibility,
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                width: double.infinity,
                label: "Confirm Password",
                icon: Icons.lock,
                hintText: "Re-enter your password",
                controller: _confirmPasswordController,
                isPasswordField: _obscurePassword,
                validator: validatePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: togglePasswordVisibility,
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                width: double.infinity,
                label: "Phone Number",
                icon: Icons.phone,
                hintText: "Enter your phone number",
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 8),
              CustomTextField(
                width: double.infinity,
                icon: Icons.numbers,
                label: "Age",
                hintText: "between 0 and 15",
                keyboardType: TextInputType.number,
                controller: _ageController,
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
              CustomButton(
                text: 'Sign Up',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  ).then((_) {
                    FocusScope.of(context).unfocus();
                  });
                },
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF02457A),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 55),
            ],
          ),
        ),
      ],
    );
  }
}
