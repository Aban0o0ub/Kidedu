import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../helper/cache_helper.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.language),
      title: Text('language'.tr()),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.locale.languageCode == 'ar' ? 'arabic'.tr() : 'english'.tr(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
      onTap: () => _showLanguageDialog(context),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('language'.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Text('🇺🇸'),
                title: Text('english'.tr()),
                onTap: () {
                  context.setLocale(const Locale('en', 'US'));
                  Navigator.of(context).pop();
                },
                trailing: context.locale.languageCode == 'en'
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
              ),
              ListTile(
                leading: const Text('🇸🇦'),
                title: Text('arabic'.tr()),
                onTap: () {
                  context.setLocale(const Locale('ar', 'SA'));
                  Navigator.of(context).pop();
                },
                trailing: context.locale.languageCode == 'ar'
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }
}

// طريقة بديلة - BottomSheet للغات
class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const LanguageBottomSheet(),
    );
  }

  Future<void> saveLanguage(String languageCode) async {
    await CacheHelper.setData(key: 'language', value: languageCode);
  }

  Future<String> getSavedLanguage() async {
    return await CacheHelper.getData(key: 'language') ?? 'en';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'language'.tr(),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Text('🇺🇸', style: TextStyle(fontSize: 24)),
            title: Text('english'.tr()),
            onTap: () async {
              context.setLocale(const Locale('en', 'US'));
              await saveLanguage('en');
              Navigator.of(context).pop();
            },
            trailing: context.locale.languageCode == 'en'
                ? const Icon(Icons.check, color: Colors.green)
                : null,
          ),
          ListTile(
            leading: const Text('🇸🇦', style: TextStyle(fontSize: 24)),
            title: Text('arabic'.tr()),
            onTap: () async {
              context.setLocale(const Locale('ar', 'SA'));
              await saveLanguage('ar');
              Navigator.of(context).pop();
            },
            trailing: context.locale.languageCode == 'ar'
                ? const Icon(Icons.check, color: Colors.green)
                : null,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}