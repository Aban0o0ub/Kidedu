import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/injection/injection.dart';
import '../../../sign_up/ui/views/role_page.dart';
import '../../../sign_up/ui/widgets/auth_prompt.dart';
import '../../../sign_up/ui/widgets/custom_button.dart';
import '../../../sign_up/ui/widgets/custom_text_field.dart';
import '../../../sign_up/ui/widgets/header_title.dart';
import '../../../sign_up/ui/widgets/icon_button.dart';
import '../../../sign_up/ui/widgets/or_divider.dart';
import '../../../sign_up/ui/widgets/upper_stickers_photo.dart';
import '../../data/models/user.dart';
import '../../logic/cubit/my_cubit.dart';
import '../widgets/remember_me_checkbox.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;
  bool _rememberMe = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  LoginCubit loginCubit = getIt<LoginCubit>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
    });
  }

  void togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<String> checkUserType(String email) async {
    if (email.contains('instructor')) {
      return 'instructor';
    } else {
      return 'kid';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => loginCubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                const UpperStickersPhoto(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const CustomTitle(text: 'Log In'),
                      CustomTextField(
                        width: 360,
                        label: "Email",
                        icon: Icons.email,
                        hintText: "Your Email",
                        controller: _emailController,
                        validator: validateEmail,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16),
                      ),
                      const SizedBox(height: 24),
                      CustomTextField(
                        width: 360,
                        label: "Password",
                        icon: Icons.lock,
                        hintText: "Password",
                        isPasswordField: _obscurePassword,
                        controller: _passwordController,
                        validator: validatePassword,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16),
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
                      RememberMeCheckbox(
                        rememberMe: _rememberMe,
                        onChanged: (bool? value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      BlocListener<LoginCubit, MyState>(
                        bloc: loginCubit,
                        listener: (context, state) {
                          if (state is LoginInstructorSuccess) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RoleSelectionPage(),
                              ),
                            );
                          } else if (state is LoginKidSuccess) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>  const RoleSelectionPage(),
                              ),
                            );
                          } else if (state is MyFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.error)),
                            );
                          }
                        },
                        child: CustomButton(
                          onPressed: () async {
                            final email = _emailController.text.trim();
                            final password = _passwordController.text.trim();

                            if (email.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Please enter your email')),
                              );
                              return;
                            }

                            if (password.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Please enter your password')),
                              );
                              return;
                            }

                            final user = User(email: email, password: password);

                            String userType = await checkUserType(email);

                            if (userType == 'instructor') {
                              context
                                  .read<LoginCubit>()
                                  .emitLoginUserInstructor(user);
                            } else if (userType == 'kid') {
                              context.read<LoginCubit>().emitLoginUserKid(user);
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 28),
                      const OrDivider(),
                      const SizedBox(height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Iconbutton(
                            assetPath: 'assets/images/Googleicon.webp',
                            onPressed: () {},
                          ),
                          const SizedBox(width: 20),
                          Iconbutton(
                            assetPath: 'assets/images/facebookicon.png',
                            onPressed: () {},
                          ),
                          const SizedBox(width: 20),
                          Iconbutton(
                            assetPath: 'assets/images/appstoreicon.png',
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      AuthPrompt(
                        questionText: "Don’t have an account?",
                        actionText: "Sign up",
                        onActionPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const RoleSelectionPage()),
                          ).then((_) {
                            FocusScope.of(context).unfocus();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
