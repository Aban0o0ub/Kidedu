import 'package:flutter/material.dart';
import '../../../../core/widgets/appbar.dart';
import '../../../../core/widgets/privacy_policy.dart';
import '../../../../core/widgets/terms_conditions.dart';
import '../widgets/logout_delete.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;
  bool isNotificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    //var themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Settings'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSwitchTile(
                icon: Icons.dark_mode,
                text: "Dark mode",
                value: isDarkMode,
                onChanged: (value) {
                  setState(() {
                    isDarkMode = value; // 🔹 مجرد تغيير في الحالة المحلية فقط
                  });
                },
              ),
              _buildDivider(),
              _buildSwitchTile(
                icon: Icons.notifications,
                text: "Notifications",
                value: isNotificationsEnabled,
                onChanged: (val) {
                  setState(() {
                    isNotificationsEnabled = val;
                  });
                },
              ),
              _buildDivider(),
              _buildListTile(Icons.payment, "Payment"),
              _buildDivider(),
              _buildListTile(Icons.language, "Language",
                  trailingText: "English", showArrow: true),
              _buildDivider(),
              _buildListTile(Icons.lock, "Change Password"),
              _buildDivider(),
              _buildListTile(
                Icons.privacy_tip,
                "Privacy Policy",
                showArrow: false,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PolicyPage()),
                  );
                },
              ),
              _buildDivider(),
              _buildListTile(Icons.description, "Terms And Conditions",
                  showArrow: false,
                  onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ConditionsPage()),
                  );
                },),
              const SizedBox(height: 20),
              _buildDivider(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Contact Us",
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
                      'assets/images/facebookicon.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
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
                      'assets/images/facebookicon.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                //mainAxisAlignment:MainAxisAlignment.center, // توزيع متساوٍ بين العناصر
                children: [
                  Expanded(
                    child: SimpleSettingsTile(
                      title: "Logout",
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Clicked Logout')),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: SimpleSettingsTile(
                      title: "Delete Account",
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Clicked Delete Account')),
                        );
                      },
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

Widget _buildSwitchTile(
    {required IconData icon,
    required String text,
    required bool value,
    required Function(bool) onChanged}) {
  return SwitchListTile(
    secondary: Icon(icon, color: Color(0xFF02457A)),
    title: Text(text,
        style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 24,
            color: Color(0xFF02457A))),
    value: value,
    onChanged: onChanged,
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
  VoidCallback? onTap, // ✅ تمرير onTap كمعامل
}) {
  return ListTile(
    leading: Icon(icon, color: Color(0xFF02457A)),
    title: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
    ),
    trailing: trailingText != null
        ? Text(trailingText, style: const TextStyle(color: Colors.grey))
        : (showArrow ? const Icon(Icons.arrow_forward_ios, size: 16) : null),
    onTap: onTap, // ✅ جعل العنصر قابلًا للنقر
  );
}
