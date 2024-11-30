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

class InstructorAuthBody extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController governmentController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController phoneNumberController;
  final TextEditingController bioController;
  final bool obscurePassword;
  final Function togglePasswordVisibility;
  final List<String> egyptianGovernorates;
  final String? Function(String?) validateEmail;
  final String? Function(String?) validatePassword;

  const InstructorAuthBody({
    super.key,
    required this.nameController,
    required this.governmentController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.phoneNumberController,
    required this.bioController,
    required this.obscurePassword,
    required this.togglePasswordVisibility,
    required this.egyptianGovernorates,
    required this.validateEmail,
    required this.validatePassword,
  });

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
                    controller: nameController,
                    icon: Icons.person,
                    width: 180,
                  ),
                  CustomDropdownField(
                    label: 'Government',
                    hintText: 'Select item',
                    controller: governmentController,
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
                controller: emailController,
                validator: validateEmail, // Use passed function
              ),
              const SizedBox(height: 8),
              CustomTextField(
                width: double.infinity,
                label: "Password",
                icon: Icons.lock,
                isPasswordField: obscurePassword,
                hintText: "Enter your password",
                controller: passwordController,
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () => togglePasswordVisibility(),
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                width: double.infinity,
                label: "Confirm Password",
                icon: Icons.lock,
                hintText: "Re-enter your password",
                controller: confirmPasswordController,
                isPasswordField: obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () => togglePasswordVisibility(),
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                width: double.infinity,
                label: "Phone Number",
                icon: Icons.phone,
                hintText: "Enter your phone number",
                controller: phoneNumberController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 8),
              CustomTextField(
                width: double.infinity,
                label: "Bio",
                hintText: "Tell us about yourself...",
                controller: bioController,
                maxLines: 3,
                hasIcon: false,
              ),
              const SizedBox(height: 24),
              BlocListener<MyCubit, MyState>(
                listener: (context, state) {
                  if (state is CreateNewInstructorSuccess) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  } else if (state is MyFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  }
                },
                child: CustomButton(
                  text: 'Sign Up',
                  onPressed: () {
                    context.read<MyCubit>().emitCreateNewInstructor(
                          Instructor(
                            name: nameController.text,
                            email: emailController.text,
                            password: passwordController.text,
                            phoneNumber: phoneNumberController.text,
                            bio: bioController.text,
                            governorate: governmentController.text,
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
                  ).then(
                    (_) {
                      FocusScope.of(context).unfocus();
                    },
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
