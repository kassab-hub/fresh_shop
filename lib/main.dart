import 'package:flutter/material.dart';
import 'package:fresh_shop/screens/welcome_screen.dart';
import 'widgets/colors.dart'; // استيراد ملف الألوان

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'متجر الخضار والفواكه',
      debugShowCheckedModeBanner: false, // إخفاء شريط الديباج المزعج
      // ----------- إعدادات الثيم العام للتطبيق -----------
      theme: ThemeData(
        useMaterial3: true, // استخدام أحدث واجهات فلاتر المعتمدة
        // 1. الألوان الأساسية
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.accent,
          background: AppColors.background,
        ),

        // 2. الخط الافتراضي لكل التطبيق
        fontFamily: 'Myfonts',

        // 3. ثيم افتراضي وموحد لكل الأزرار (ElevatedButton) في التطبيق
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                AppColors.primary, // سيصبح الأخضر هو الافتراضي للأزرار
            foregroundColor: Colors.white, // لون النص داخل الزر
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),

        // 4. ثيم شريط التطبيق العلوي (AppBar)
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: AppColors.textDark),
        ),
      ),

      // --------------------------------------------------
      home: const Welcome(), // شاشة البداية
    );
  }
}
