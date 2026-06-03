import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fresh_shop/screens/home_screen.dart';
import 'package:fresh_shop/widgets/global_file.dart';
// قم باستيراد الشاشة الرئيسية هنا بعد إنشائها
// import 'home_screen.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // خلفية بيضاء مريحة
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0), // هوامش جانبية للشاشة
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. الصورة الترحيبية
              Expanded(
                flex: 3, // تأخذ مساحة أكبر وتتجاوب مع الشاشات المختلفة
                child: CachedNetworkImage(
                  imageUrl: '${AppGlobals.url_upload}welcome.png',
                  fit: BoxFit.contain,

                  // أثناء التحميل: يعرض مؤشر التحميل الأخضر الذي صممته
                  placeholder: (context, url) => const Center(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        color: Colors.green,
                        strokeWidth: 2,
                      ),
                    ),
                  ),

                  // في حال الخطأ: بدلاً من الأيقونة، يعرض صورتك المحلية 'welcome.png'
                  errorWidget: (context, url, error) {
                    return const Icon(Icons.eco, size: 50, color: Colors.green);
                  },
                ),
              ),

              const SizedBox(height: 30), // مسافة بين الصورة والنص
              // 2. النص الترحيبي
              Text(
                'تسوق الخضروات والفاكهة\nطازجة يومياً',
                textAlign: TextAlign.center, // لتوسيط النص لو نزل على سطرين
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 40), // مسافة بين النص والزر
              // 3. زر البدء
              SizedBox(
                width:
                    double.infinity, // الزر يأخذ عرض الشاشة بالكامل بشكل أنيق
                height: 55, // طول مناسب للضغط
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0, // إلغاء الظل ليكون التصميم فلات وحديث
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        15,
                      ), // حواف دائرية ناعمة
                    ),
                  ),
                  onPressed: () {
                    // الانتقال للشاشة الرئيسية واستبدال الشاشة الحالية بها
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ), // استبدلها باسم شاشتك الرئيسية
                    );
                  },
                  child: const Text('ابدأ الآن'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
