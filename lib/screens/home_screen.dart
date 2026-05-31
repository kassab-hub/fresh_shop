import 'package:flutter/material.dart';
import 'package:fresh_shop/models/product_model.dart';
import 'package:fresh_shop/services/api_service.dart'; // استيراد ملف الخدمة الجديد
import 'package:fresh_shop/widgets/Card_product.dart';
import 'package:fresh_shop/widgets/headers.dart';
import 'package:fresh_shop/widgets/menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // إنشاء كائن من الـ ApiService لاستخدامه في جلب البيانات
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // خلفية متناسقة ومريحة للعين
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. الترويسة (Header) + زر السلة
                const Headers(),

                const SizedBox(height: 25),

                // 2. قائمة الأقسام (Categories) - عرض أفقي
                const Menu(),

                const SizedBox(height: 25),

                // عنوان قبل المنتجات
                const Text(
                  'المنتجات الطازجة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 15),

                // 3. شبكة المنتجات الحقيقية المجلوبة من قاعدة البيانات
                FutureBuilder<List<Product>>(
                  future: _apiService
                      .fetchProducts(), // استدعاء الدالة من مجلد الـ Services
                  builder: (context, snapshot) {
                    // أولاً: حالة انتظار البيانات (جاري التحميل)
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 50.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    // ثانياً: في حال حدوث خطأ في الاتصال أو السيرفر
                    else if (snapshot.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30.0),
                          child: Text(
                            'خطأ في الاتصال بالخلفية البرمجية:\n${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }
                    // ثالثاً: عند وصول البيانات بنجاح وعرضها داخل الكارد
                    else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return CardProduct(productsList: snapshot.data!);
                    }
                    // رابعاً: حالة احتياطية إذا كانت قاعدة البيانات فارغة تماماً
                    else {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 50.0),
                        child: Center(
                          child: Text('لا توجد منتجات معروضة حالياً في المتجر'),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
