import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import 'dart:developer';

class ApiService {
  // الرابط الأساسي الصحيح للشبكة الداخلية
  static const String baseUrl = 'http://10.55.15.21/fresh-shop-api/public/api';

  /// 1. جلب المنتجات بنظام الصفحات مع دعم الفلترة حسب التصنيف (GET)
  // 🎯 التعديل: جعل البارامترات Named Parameters وإضافة `String? category`
  Future<Map<String, dynamic>> fetchProducts({
    int page = 1,
    String? category,
  }) async {
    try {
      // بناء الرابط الأساسي مع رقم الصفحة
      String url = '$baseUrl/products?page=$page';

      // 🎯 التعديل: إذا تم تمرير اسم قسم معين (وليس الكل)، نقوم بإضافته للرابط مع تشفيره بأمان لدعم اللغة العربية
      if (category != null && category.isNotEmpty) {
        url += '&category=${Uri.encodeComponent(category)}';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);

        // تحويل المصفوفة القادمة من لارافيل إلى كائنات الـ Model
        List<Product> products = (decodedData['data'] as List)
            .map((item) => Product.fromJson(item))
            .toList();

        return {
          'data': products,
          'meta': decodedData['meta'], // بيانات الـ Paging الأساسية
        };
      } else {
        throw Exception(
          'فشل في جلب البيانات من السيرفر: ${response.statusCode}',
        );
      }
    } catch (e) {
      log("خطأ أثناء جلب المنتجات: $e");
      rethrow;
    }
  }

  /// 2. دالة إرسال الطلب وإتمام الشراء (POST)
  Future<bool> sendOrderToLaravel({
    required double totalPrice,
    required List<Map<String, dynamic>> cartItems,
  }) async {
    final Uri url = Uri.parse('$baseUrl/checkout');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'total_price': totalPrice, 'items': cartItems}),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        log("فشل السيرفر في الاستجابة: ${response.body}");
        return false;
      }
    } catch (e) {
      log("خطأ أثناء الاتصال بالسيرفر (إرسال الطلب): $e");
      return false;
    }
  }
}
