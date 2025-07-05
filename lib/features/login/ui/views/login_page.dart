import 'package:easy_localization/easy_localization.dart';
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

  // ✅ الإيميل والباسورد الصحيح للأدمن
  static const String ADMIN_EMAIL = 'Kidedu2026@gmail.com';
  static const String ADMIN_PASSWORD = 'Kidedu1234@'; // ✅ الباسورد الصحيح

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
    }

    // ✅ للأدمن مش محتاج email validation معقد
    if (_isAdminEmail(value.trim())) {
      return null;
    }

    // للمستخدمين العاديين
    if (!AppRegex.isValidEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    // ✅ للأدمن - تخفيف شروط الباسورد
    if (_isAdminEmail(_emailController.text.trim())) {
      return null; // الأدمن مش محتاج شروط معقدة
    }

    // ✅ للمستخدمين العاديين - الشروط الكاملة
    if (!AppRegex.hasLowercase(value)) {
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

  // ✅ التحقق من إيميل الأدمن
  bool _isAdminEmail(String email) {
    return email.trim() == ADMIN_EMAIL;
  }

  // ✅ التحقق من بيانات الأدمن كاملة
  bool _isAdminCredentials(String email, String password) {
    return email.trim() == ADMIN_EMAIL && password.trim() == ADMIN_PASSWORD;
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
                      CustomTitle(text: 'Log In'.tr()),
                      CustomTextField(
                        width: 360,
                        label: "Email".tr(),
                        icon: Icons.email,
                        hintText: "Your Email".tr(),
                        controller: _emailController,
                        validator: validateEmail,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16),
                      ),
                      const SizedBox(height: 24),
                      CustomTextField(
                        width: 360,
                        label: "Password".tr(),
                        icon: Icons.lock,
                        hintText: "Password".tr(),
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
                          if (state is LoginInstructorSuccess ||
                              state is LoginKidSuccess ||
                              state is LoginAdminSuccess) {
                            // ✅ التعامل مع الأدمن أولاً
                            if (state is LoginAdminSuccess) {
                              context.read<RoleCubit>().selectRole('admin');
                              context.pushReplacement(Routes.adminEarnings);
                              return;
                            }

                            // ✅ للمستخدمين العاديين
                            if (state is LoginInstructorSuccess) {
                              context
                                  .read<RoleCubit>()
                                  .selectRole('instructor');
                              context.pushReplacement(
                                  Routes.instructorProfilePage);
                            } else if (state is LoginKidSuccess) {
                              context.read<RoleCubit>().selectRole('kid');
                              context.pushReplacement(Routes.homePage);
                            }
                          } else if (state is LoginFailure) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Row(
                                  children: [
                                    Icon(Icons.warning, color: Colors.amber),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Login Failed',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
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

                              if (_isAdminCredentials(email, password)) {
                                final user = User(
                                  email: email,
                                  password: password,
                                  role: 'admin',
                                );
                                context
                                    .read<LoginCubit>()
                                    .emitLoginUser(user: user);
                                return;
                              }

                              final currentRole =
                                  context.read<RoleCubit>().state;
                              if (currentRole == 'admin') {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Row(
                                      children: [
                                        Icon(Icons.warning,
                                            color: Colors.amber),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Invalid Admin Credentials',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    content: const Text(
                                        'Please enter the correct admin email and password.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                                return;
                              }

                              final roleForBackend =
                                  (currentRole == 'instructor')
                                      ? 'instructor'
                                      : 'kid';

                              final user = User(
                                email: email,
                                password: password,
                                role: roleForBackend,
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
                        questionText: "Don't have an account?".tr(),
                        actionText: "Sign up".tr(),
                        onActionPressed: () {
                          final role = context.read<RoleCubit>().state;

                          if (role == 'kid' || role == 'admin') {
                            context.read<RoleCubit>().selectRole('kid');
                            context.push(Routes.authKidPage);
                          } else if (role == 'instructor') {
                            context.read<RoleCubit>().selectRole('instructor');
                            context.push(Routes.authInstructorPage);
                          }

                          FocusScope.of(context).unfocus();
                        },
                      ),
                      const SizedBox(height: 70),
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
