import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/injection/injection.dart';
import '../../../../core/regex/app_regex.dart';
import '../../../../core/routing/routes.dart';
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
  bool _rememberMe = false;
  bool isSubmitted = false;

  final _formKey = GlobalKey<FormState>();

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

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
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
    return Scaffold(
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
                child: Form(
                  key: _formKey,
                  autovalidateMode: isSubmitted
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
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
                        isPasswordField: true,
                        controller: _passwordController,
                        validator: validatePassword,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16),
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
                      BlocListener<LoginCubit, LoginState>(
                        listener: (context, state) {
                          if (state is LoginInstructorSuccess) {
                            context.read<RoleCubit>().selectRole('instructor');
                            context.push(Routes.instructorProfilePage);
                          } else if (state is LoginKidSuccess) {
                            context.read<RoleCubit>().selectRole('kid');
                            context.pushReplacement(Routes.homePage);
                          } else if (state is LoginFailure) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Row(
                                  children: const [
                                    Icon(Icons.warning, color: Colors.amber),
                                    SizedBox(width: 8),
                                    Text(
                                      'Login Failed',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                content: Text(
                                  state.error,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
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
                        },
                        child: CustomButton(
                          onPressed: () async {
                            setState(() {
                              isSubmitted = true;
                            });
                            if (_formKey.currentState!.validate()) {
                              final email = _emailController.text.trim();
                              final password = _passwordController.text.trim();

                              final role = context.read<RoleCubit>().state;

                              final user = User(
                                email: email,
                                password: password,
                                role: role,
                              );

                              context
                                  .read<LoginCubit>()
                                  .emitLoginUser(user: user);
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
                          final role = context.read<RoleCubit>().state;

                          if (role == 'kid') {
                            context.read<RoleCubit>().selectRole('kid');
                            context.push(Routes.authKidPage);
                          } else if (role == 'instructor') {
                            context.read<RoleCubit>().selectRole('instructor');
                            context.push(Routes.authInstructorPage);
                          }

                          FocusScope.of(context).unfocus();
                        },
                      ),
                      SizedBox(height:70 ,)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
} 

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import '../../../../core/injection/injection.dart';
// import '../../../../core/routing/routes.dart';
// import '../../../sign_up/ui/widgets/auth_prompt.dart';
// import '../../../sign_up/ui/widgets/or_divider.dart';
// import '../../../sign_up/ui/widgets/upper_stickers_photo.dart';
// import '../../data/models/user.dart';
// import '../../logic/cubit/my_cubit.dart';
// import '../widgets/login_form.dart';
// import '../widgets/social_login_buttons.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//   @override
//   LoginPageState createState() => LoginPageState();
// }
// class LoginPageState extends State<LoginPage> {
//   bool _rememberMe = false;
//   bool isSubmitted = false;
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   LoginCubit loginCubit = getIt<LoginCubit>();
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       FocusScope.of(context).unfocus();
//     });
//   }
//   void showErrorMessage(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//   Future<String> checkUserType(String email) async {
//     if (email.contains('instructor')) {
//       return 'instructor';
//     } else {
//       return 'kid';
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: GestureDetector(
//         onTap: () {
//           FocusScope.of(context).unfocus();
//         },
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const UpperStickersPhoto(),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: LoginForm(
//                   formKey: _formKey,
//                   emailController: _emailController,
//                   passwordController: _passwordController,
//                   rememberMe: _rememberMe,
//                   onRememberMeChanged: (value) {
//                     setState(() {
//                       _rememberMe = value ?? false;
//                     });
//                   },
//                   onSubmit: () async {
//                     setState(() {
//                       isSubmitted = true;
//                     });
//                     if (_formKey.currentState!.validate()) {
//                       final email = _emailController.text.trim();
//                       final password = _passwordController.text.trim();
//                       final role = context.read<RoleCubit>().state;
//                       final user = User(
//                         email: email,
//                         password: password,
//                         role: role,
//                       );
//                       context.read<LoginCubit>().emitLoginUser(
//                         user: user,
//                       );
//                     }
//                   },
//                 ),
//               ),
//               const SizedBox(height: 28),
//               const OrDivider(),
//               const SizedBox(height: 28),
//               SocialLoginButtons(),
//               const SizedBox(height: 28),
//               AuthPrompt(
//                 questionText: "Don’t have an account?",
//                 actionText: "Sign up",
//                 onActionPressed: () {
//                   final role = context.read<RoleCubit>().state;
//                   if (role == 'kid') {
//                     context.read<RoleCubit>().selectRole('kid');
//                     context.push(Routes.authKidPage);
//                   } else if (role == 'instructor') {
//                     context.read<RoleCubit>().selectRole('instructor');
//                     context.push(Routes.authInstructorPage);
//                   }
//                   FocusScope.of(context).unfocus();
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

