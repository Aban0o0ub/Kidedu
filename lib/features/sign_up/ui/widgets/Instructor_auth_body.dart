import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loginpage/features/sign_up/logic/cubit/my_cubit.dart';
import 'package:loginpage/features/sign_up/ui/widgets/auth_prompt.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_button.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_dropdown.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_text_field.dart';
import 'package:loginpage/features/sign_up/ui/widgets/header_title.dart';
import 'package:loginpage/features/sign_up/ui/widgets/icon_button.dart';
import 'package:loginpage/features/sign_up/ui/widgets/or_divider.dart';
import '../../../../core/routing/routes.dart';
import '../../data/models/kid.dart';

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
        SizedBox(height: 175.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              const CustomTitle(text: 'Sign Up'),
              SizedBox(height: 11.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTextField(
                    label: 'Name',
                    hintText: 'Enter your name',
                    controller: nameController,
                    icon: Icons.person,
                    width: 170.w,
                  ),
                  SizedBox(width: 8.w),
                  CustomDropdownField(
                    label: 'Government',
                    hintText: 'Select item',
                    controller: governmentController,
                    items: egyptianGovernorates,
                    icon: Icons.location_city,
                    width: 150.w,
                  ),
                ],
              ),
              SizedBox(height: 7.h),
              CustomTextField(
                width: double.infinity.w,
                label: "Email",
                icon: Icons.email,
                hintText: "Your Email",
                controller: emailController,
                validator: validateEmail, // Use passed function
              ),
              SizedBox(height: 7.h),
              CustomTextField(
                width: double.infinity.w,
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
              SizedBox(height: 7.h),
              CustomTextField(
                width: double.infinity.w,
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
              SizedBox(height: 7.h),
              CustomTextField(
                width: double.infinity.w,
                label: "Phone Number",
                icon: Icons.phone,
                hintText: "Enter your phone number",
                controller: phoneNumberController,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 7.h),
              CustomTextField(
                width: double.infinity.w,
                label: "Bio",
                hintText: "Tell us about yourself...",
                controller: bioController,
                maxLines: 3,
                hasIcon: false,
              ),
              SizedBox(height: 21.h),
              BlocListener<MyCubit, MyState>(
                listener: (context, state) {
                  if (state is CreateNewInstructorSuccess) {
                    context.push(Routes.loginPage);
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
                          InstructorData(
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
              SizedBox(height: 24.h),
              const OrDivider(),
              SizedBox(height: 19.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Iconbutton(
                    assetPath: 'assets/images/Googleicon.webp',
                    onPressed: () {
                      // Google
                    },
                  ),
                  SizedBox(width: 20.w),
                  Iconbutton(
                    assetPath: 'assets/images/facebookicon.png',
                    onPressed: () {
                      // Facebook
                    },
                  ),
                  SizedBox(width: 20.w),
                  Iconbutton(
                    assetPath: 'assets/images/appstoreicon.png',
                    onPressed: () {
                      // App Store
                    },
                  ),
                ],
              ),
              SizedBox(height: 25.h),
              AuthPrompt(
                questionText: "Have an account?",
                actionText: "Login",
                onActionPressed: () {
                  context.push(Routes.loginPage).then(
                    (_) {
                      FocusScope.of(context).unfocus();
                    },
                  );
                },
              ),
              SizedBox(height: 50.h),
            ],
          ),
        ),
      ],
    );
  }
}
