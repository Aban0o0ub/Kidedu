# Translation Files Guide

## ملفات الترجمة - دليل الاستخدام

### الملفات المتاحة
- `en-US.json` - الترجمة الإنجليزية
- `ar-SA.json` - الترجمة العربية

### كيفية استخدام الترجمات

#### 1. استيراد المكتبة
```dart
import 'package:easy_localization/easy_localization.dart';
```

#### 2. استخدام الترجمة في النصوص
```dart
// بدلاً من
Text("Login")

// استخدم
Text("login".tr())

// أو
Text("Login".tr())
```

#### 3. أمثلة عملية
```dart
// في الأزرار
ElevatedButton(
  onPressed: () {},
  child: Text("Sign up".tr()),
)

// في العناوين
AppBar(
  title: Text("Settings".tr()),
)

// في الرسائل
SnackBar(
  content: Text("Account created successfully".tr()),
)
```

### إضافة ترجمات جديدة

#### الخطوات:
1. أضف الكلمة الجديدة في `en-US.json`:
```json
{
  "new_word": "New Word"
}
```

2. أضف الترجمة العربية في `ar-SA.json`:
```json
{
  "new_word": "كلمة جديدة"
}
```

3. استخدمها في الكود:
```dart
Text("new_word".tr())
```

### تجهيز التطبيق للترجمة

#### في main.dart:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('ar', 'SA')],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'US'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      // ... باقي الإعدادات
    );
  }
}
```

#### في pubspec.yaml:
```yaml
dependencies:
  easy_localization: ^3.0.3

flutter:
  assets:
    - assets/translations/
```

### نصائح مهمة

#### 1. استخدام الكلمات المناسبة
```dart
// جيد
"login".tr()
"Sign up".tr()
"Settings".tr()

// تجنب
"تسجيل الدخول".tr() // لا تضع العربية كمفتاح
```

#### 2. التعامل مع النصوص الطويلة
```dart
// للرسائل الطويلة
"Account created successfully".tr()

// للأوصاف
"Enroll in the course to access lessons".tr()
```

#### 3. تجميع الكلمات المترابطة
```dart
// مجموعة المصادقة
"login".tr()
"Sign up".tr()
"Logout".tr()
"Email".tr()
"Password".tr()

// مجموعة الإعدادات
"Settings".tr()
"Privacy Policy".tr()
"Terms & Conditions".tr()
"Change Password".tr()
```

### قائمة الكلمات الأساسية

#### المصادقة والمستخدم
- login, Sign up, Logout, Email, Password
- Kid, Instructor, Admin, Profile, Role

#### التنقل والواجهة  
- Settings, Home, Search, Filter, Categories
- Save, Edit, Delete, Add, Cancel, OK

#### الكورسات والتعلم
- My Courses, Course Details, Lessons, Reviews
- Enroll, Start Learning, Continue Learning, Complete

#### العامة
- Loading, Error, Success, Retry, Close, Open
- Help, Support, About, Version, Update

### إرشادات الترجمة

#### للعربية:
- استخدم المصطلحات المناسبة للفئة العمرية (الأطفال)
- تجنب الكلمات المعقدة
- استخدم "كورس" بدلاً من "دورة" للبساطة
- استخدم "تطبيق" بدلاً من "برنامج"

#### للإنجليزية:
- استخدم كلمات بسيطة ومفهومة
- كن مختصراً وواضحاً
- استخدم المصطلحات المألوفة في التطبيقات

### استكشاف الأخطاء

#### إذا لم تظهر الترجمة:
1. تأكد من وجود الكلمة في ملف JSON
2. تأكد من استخدام `.tr()` 
3. تأكد من إعداد EasyLocalization بشكل صحيح
4. تأكد من مسار ملفات الترجمة في pubspec.yaml

#### إذا ظهرت الكلمة باللغة الخاطئة:
1. تحقق من إعداد اللغة الافتراضية
2. تأكد من تطابق أسماء الملفات مع الـ locales
3. تحقق من إعدادات اللغة في الجهاز

---

هذا الدليل يغطي جميع احتياجات الترجمة في التطبيق. لأي استفسارات إضافية، راجع وثائق easy_localization الرسمية. 