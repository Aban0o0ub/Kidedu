import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/helper/cache_helper.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/widgets/appbar.dart';
import '../../../../core/widgets/language_settings.dart';
import '../widgets/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // احذف isDarkMode من هنا - مش محتاجه
  bool isNotificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Settings'.tr(),
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSwitchTile(
                icon: Icons.dark_mode,
                text: "dark_mode".tr(),
                value: themeProvider.isDarkMode, // ✅ صحيح
                onChanged: (value) {
                  // ✅ الحل الصحيح
                  themeProvider.setThemeValue(value);
                },
              ),
              _buildDivider(),
              _buildSwitchTile(
                icon: Icons.notifications,
                text: "notifications".tr(),
                value: isNotificationsEnabled,
                onChanged: (val) {
                  setState(() {
                    isNotificationsEnabled = val;
                  });
                },
              ),
              _buildDivider(),
              _buildListTile(
                Icons.payment,
                "payment".tr(),
              ),
              _buildDivider(),
              _buildListTile(
                Icons.language,
                "language".tr(),
                trailingText: context.locale.languageCode == 'ar'
                    ? 'arabic'.tr()
                    : 'english'.tr(),
                showArrow: true,
                onTap: () => LanguageBottomSheet.show(context),
              ),
              _buildDivider(),
              _buildListTile(
                Icons.lock,
                "Change Password".tr(),
                onTap: () {
                  FocusScope.of(context).unfocus();
                  context.push(Routes.changePassword);
                },
              ),
              _buildDivider(),
              _buildListTile(
                Icons.privacy_tip,
                "Privacy Policy".tr(),
                showArrow: false,
                onTap: () {
                  context.push(Routes.policyPage);
                },
              ),
              _buildDivider(),
              _buildListTile(
                Icons.description,
                "Terms And Conditions".tr(),
                showArrow: false,
                onTap: () {
                  context.push(Routes.conditionsPage);
                },
              ),
              const SizedBox(height: 20),
              _buildDivider(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Contact Us".tr(),
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                      color: Color(0xFF02457A)),
                ),
              ),
              Wrap(
                spacing: 16,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Image.asset(
                      'assets/images/facebookicon.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Image.asset(
                      'assets/images/whatsapp.jpeg',
                      width: 40,
                      height: 40,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Image.asset(
                      'assets/images/linkedin.jpeg',
                      width: 40,
                      height: 40,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Image.asset(
                      'assets/images/github.jpeg',
                      width: 40,
                      height: 40,
                    ),
                  ),
                ],
              ),
              const SizedBox(height:16),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), 
                        ),
                      ),
                      onPressed: () {
                        _showLogoutConfirmationDialog(context);
                      },
                      child: Text(
                        "Logout".tr(),
                        style: const TextStyle(
                            fontSize: 16,color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildSwitchTile({
  required IconData icon,
  required String text,
  required bool value,
  required Function(bool) onChanged,
}) {
  return SwitchListTile(
    secondary: Icon(icon, color: const Color(0xFF02457A)),
    title: Text(text,
        style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 24,
            color: Color(0xFF02457A))),
    value: value,
    onChanged: onChanged,
    activeColor: Colors.blue, // لون الـ switch لما يكون مفعل
  );
}

Widget _buildDivider() {
  return const Divider(
    color: Color(0xFF02457A),
    thickness: 2,
    height: 20,
  );
}

Widget _buildListTile(
  IconData icon,
  String text, {
  String? trailingText,
  bool showArrow = true,
  VoidCallback? onTap,
}) {
  return ListTile(
    leading: Icon(icon, color: const Color(0xFF02457A)),
    title: Text(
      text,
      style: const TextStyle(
          fontWeight: FontWeight.w500, fontSize: 24, color: Color(0xFF02457A)),
    ),
    trailing: trailingText != null
        ? Text(trailingText, style: const TextStyle(color: Colors.grey))
        : (showArrow ? const Icon(Icons.arrow_forward_ios, size: 16) : null),
    onTap: onTap,
  );
}

void _showLogoutConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure to logout?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _performLogout(context);
            },
            child: const Text("Logout"),
          ),
        ],
      );
    },
  );
}

Future<void> _performLogout(BuildContext context) async {
  try {
    await CacheHelper.clear();

    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Success"),
            content: const Text("Logout successfully"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go(Routes.roleSelectionPage);
                },
                child: const Text("Okay"),
              ),
            ],
          );
        },
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during logout: $e')),
      );
    }
  }
}
