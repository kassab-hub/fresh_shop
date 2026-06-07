import 'dart:convert';
import 'package:fresh_shop/widgets/global_file.dart'; // تأكد أن AppGlobals بداخل هذا الملف
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';
import 'dart:developer';

class ApiService {
  // الرابط الأساسي النظيف للمشروع (ينتهي بـ api)
  static final Uri baseUrl = Uri.parse(AppGlobals.apiBaseUrl);

  // 1️⃣ جلب المنتجات مع دعم الفلترة ورقم الصفحة
  Future<Map<String, dynamic>> fetchProducts({
    int page = 1,
    String? category,
  }) async {
    try {
      String url = "$baseUrl/products?page=$page";

      if (category != null && category.isNotEmpty) {
        url += "&category=${Uri.encodeComponent(category)}";
      }

      log("🔗 الرابط المستدعى للمنتجات: $url");

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);

        List<Product> products = (decodedData['data'] as List)
            .map((item) => Product.fromJson(item))
            .toList();

        return {'data': products, 'meta': decodedData['meta']};
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

  // 2️⃣ دالة إرسال الطلب وإتمام الشراء (POST)
  Future<bool> sendOrderToLaravel({
    required double totalPrice,
    required List<Map<String, dynamic>> cartItems,
  }) async {
    final Uri url = Uri.parse('$baseUrl/checkout');

    try {
      final prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('user_id');

      log("🔗 رابط الشراء المرسل إليه: $url");
      log("👤 معرف المستخدم المثبت للطلب: $userId");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'user_id': userId,
          'total_price': totalPrice,
          'items': cartItems,
        }),
      );

      if (response.statusCode == 201) {
        log("🎉 تم تسجيل الطلب بنجاح في قاعدة البيانات!");
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

  // 3️⃣ دالة تسجيل دخول مستخدم حالي (POST) - المضافة حديثاً 🎯
  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    final Uri url = Uri.parse('$baseUrl/login');

    try {
      log("🔗 رابط تسجيل الدخول المرسل إليه: $url");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final decodedData = json.decode(response.body);

      if (response.statusCode == 200 && decodedData['status'] == true) {
        // حفظ بيانات الجلسة والمعرّف محلياً في الهاتف فور النجاح
        final prefs = await SharedPreferences.getInstance();
        if (decodedData['token'] != null) {
          await prefs.setString('user_token', decodedData['token']);
        }
        if (decodedData['user']['name'] != null) {
          await prefs.setString('user_name', decodedData['user']['name']);
        }
        if (decodedData['user']['id'] != null) {
          await prefs.setInt('user_id', decodedData['user']['id']);
        }

        log(
          "👋 تم تسجيل دخول المستخدم بنجاح وثبيت المعرف: ${decodedData['user']['id']}",
        );

        return {
          'status': true,
          'message': decodedData['message'] ?? 'تم تسجيل الدخول بنجاح!',
        };
      } else {
        log("فشل تسجيل الدخول من السيرفر: ${response.body}");
        return {
          'status': false,
          'message': decodedData['message'] ?? 'بيانات الدخول غير صحيحة.',
        };
      }
    } catch (e) {
      log("خطأ أثناء الاتصال بالسيرفر (تسجيل الدخول): $e");
      return {
        'status': false,
        'message': '❌ فشل الاتصال بالسيرفر، تأكد من الشبكة.',
      };
    }
  }

  // 4️⃣ دالة تسجيل مستخدم جديد وحفظ جلسته محلياً (POST)
  Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    final Uri url = Uri.parse('$baseUrl/register');

    try {
      log("🔗 رابط التسجيل المرسل إليه: $url");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
        }),
      );

      final decodedData = json.decode(response.body);

      if (response.statusCode == 201 ||
          (response.statusCode == 200 && decodedData['status'] == true)) {
        final prefs = await SharedPreferences.getInstance();
        if (decodedData['token'] != null) {
          await prefs.setString('user_token', decodedData['token']);
        }
        if (decodedData['user']['name'] != null) {
          await prefs.setString('user_name', decodedData['user']['name']);
        }
        if (decodedData['user']['id'] != null) {
          await prefs.setInt('user_id', decodedData['user']['id']);
        }

        log(
          "🎉 تم تسجيل المستخدم وحفظ المعرّف محلياً: ${decodedData['user']['id']}",
        );

        return {
          'status': true,
          'message': decodedData['message'] ?? 'تم إنشاء الحساب بنجاح!',
        };
      } else {
        log("فشل التسجيل من السيرفر: ${response.body}");
        return {
          'status': false,
          'message': decodedData['message'] ?? 'بيانات التسجيل غير صالحة.',
        };
      }
    } catch (e) {
      log("خطأ أثناء الاتصال بالسيرفر (التسجيل): $e");
      return {
        'status': false,
        'message': '❌ فشل الاتصال بالسيرفر، تأكد من الشبكة.',
      };
    }
  }
}
