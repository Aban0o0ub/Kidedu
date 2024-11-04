import 'package:flutter/material.dart';
import 'package:loginpage/views/home_page.dart';
import 'package:loginpage/views/login_page.dart';
import 'package:loginpage/widgets/arrow_back.dart';
import 'package:loginpage/widgets/auth_prompt.dart';
import 'package:loginpage/widgets/custom_button.dart';
import 'package:loginpage/widgets/custom_text_field.dart';
import 'package:loginpage/widgets/header_title.dart';
import 'package:loginpage/widgets/icon_button.dart';
import 'package:loginpage/widgets/or_divider.dart';
import 'package:loginpage/widgets/upper_stickers_photo.dart';

class AuthKid extends StatefulWidget {
  const AuthKid({super.key});

  @override
  AuthKidState createState() => AuthKidState();
}

class AuthKidState extends State<AuthKid> {
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
    return Scaffold(
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
              Column(
                children: [
                  const SizedBox(
                    height: 200,
                  ),
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
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
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
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
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
                            // Label
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
                                // Female option
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
                                            onChanged: (value) =>
                                                _selectGender(value!),
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
                                            onChanged: (value) =>
                                                _selectGender(value!),
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
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
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
                        AuthPrompt(
                          questionText: "Have an account?",
                          actionText: "Login",
                          onActionPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            ).then((_) {
                              FocusScope.of(context).unfocus();
                            });
                          },
                        ),
                        const SizedBox(height: 55),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDropdownField extends StatelessWidget {
  const CustomDropdownField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.items,
    required this.icon,
    this.width = 180,
    this.height = 56,
  });

  final String label;
  final String hintText;
  final TextEditingController controller;
  final List<String> items;
  final IconData icon;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF02457A),
              fontSize: 24,
            ),
          ),
          SizedBox(
            height: height,
            child: DropdownButtonFormField<String>(
              value: controller.text.isEmpty ? null : controller.text,
              items: items
                  .map((String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ))
                  .toList(),
              onChanged: (String? newValue) {
                controller.text = newValue ?? '';
              },
              decoration: InputDecoration(
                prefixIcon: Icon(
                  icon,
                  color: const Color(0xFF9D9D9D),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15), // ضبط المسافة الداخلية
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Color(0xFF9D9D9D),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF02457A),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF02457A),
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              dropdownColor: Colors.white,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF02457A),
              ),
              isExpanded: true,
              iconSize: 30,
            ),
          ),
        ],
      ),
    );
  }
}
