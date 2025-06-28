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
import '../../../../core/regex/app_regex.dart';
import '../../data/models/kid.dart';

class InstructorAuthBody extends StatefulWidget {
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
  State<InstructorAuthBody> createState() => _InstructorAuthBodyState();
}

class _InstructorAuthBodyState extends State<InstructorAuthBody> {
  final _formKey = GlobalKey<FormState>();
  bool isSubmitted = false;

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != widget.passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    } else if (!AppRegex.isValidName(value)) {
      return 'Name must start with a capital letter and contain only letters';
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

  String? validateGovernorate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a governorate';
    }
    return null;
  }

  String? validateBio(String? value) {
    if (value == null || value.isEmpty) {
      return 'Bio is required';
    }
    if (value.length < 10) {
      return 'Bio must be at least 10 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 175.h),
        Form(
          key: _formKey,
          autovalidateMode: isSubmitted
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          child: Padding(
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
                      controller: widget.nameController,
                      icon: Icons.person,
                      width: 170.w,
                      validator: validateName,
                    ),
                    SizedBox(width: 8.w),
                    CustomDropdownField(
                      label: 'Government',
                      hintText: 'Select item',
                      controller: widget.governmentController,
                      items: widget.egyptianGovernorates,
                      icon: Icons.location_city,
                      width: 150.w,
                      validator: validateGovernorate,
                    ),
                  ],
                ),
                SizedBox(height: 7.h),
                CustomTextField(
                  width: double.infinity.w,
                  label: "Email",
                  icon: Icons.email,
                  hintText: "Your Email",
                  controller: widget.emailController,
                  validator: widget.validateEmail,
                ),
                SizedBox(height: 7.h),
                CustomTextField(
                  width: double.infinity.w,
                  label: "Password",
                  icon: Icons.lock,
                  isPasswordField: widget.obscurePassword,
                  hintText: "Enter your password",
                  controller: widget.passwordController,
                  validator: widget.validatePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      widget.obscurePassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () => widget.togglePasswordVisibility(),
                  ),
                ),
                SizedBox(height: 7.h),
                CustomTextField(
                  width: double.infinity.w,
                  label: "Confirm Password",
                  icon: Icons.lock,
                  hintText: "Re-enter your password",
                  controller: widget.confirmPasswordController,
                  isPasswordField: widget.obscurePassword,
                  validator: validateConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      widget.obscurePassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () => widget.togglePasswordVisibility(),
                  ),
                ),
                SizedBox(height: 7.h),
                CustomTextField(
                  width: double.infinity.w,
                  label: "Phone Number",
                  icon: Icons.phone,
                  hintText: "Enter your phone number",
                  controller: widget.phoneNumberController,
                  keyboardType: TextInputType.phone,
                  validator: validatePhoneNumber,
                ),
                SizedBox(height: 7.h),
                CustomTextField(
                  width: double.infinity.w,
                  label: "Bio",
                  hintText: "Tell us about yourself...",
                  controller: widget.bioController,
                  maxLines: 3,
                  hasIcon: false,
                  validator: validateBio,
                ),
                SizedBox(height: 21.h),
                BlocListener<MyCubit, MyState>(
                  listener: (context, state) {
                    if (state is CreateNewInstructorSuccess) {
                      context.push(Routes.loginPage);
                    }
                  },
                  child: CustomButton(
                    text: 'Sign Up',
                    onPressed: () {
                      setState(() {
                        isSubmitted = true;
                      });

                      if (_formKey.currentState!.validate()) {
                        context.read<MyCubit>().emitCreateNewInstructor(
                          InstructorData(
                            name: widget.nameController.text,
                            email: widget.emailController.text,
                            password: widget.passwordController.text,
                            phoneNumber: widget.phoneNumberController.text,
                            bio: widget.bioController.text,
                            governorate: widget.governmentController.text,
                          ),
                        );
                      }
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
        ),
      ],
    );
  }
}