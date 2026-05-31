import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ApiService {
  // الرابط الأساسي لسيرفر Laragon
  static const String baseUrl = 'http://fresh-shop-api.test/api';

  // دالة جلب المنتجات من قاعدة بيانات MySQL عبر Laravel
  Future<List<Product>> fetchProducts() async {
    final Uri url = Uri.parse('$baseUrl/products');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // تحويل نص الـ JSON القادم من السيرفر إلى قائمة ديناميكية
        List<dynamic> body = jsonDecode(response.body);

        // تحويل القائمة الديناميكية إلى قائمة من موديل Product
        return body
            .map(
              (item) => Product(
                name: item['name'],
                image: item['image'],
                price: double.parse(item['price'].toString()),
                unit: item['unit'],
              ),
            )
            .toList();
      } else {
        throw Exception(
          'فشل في تحميل البيانات: كود الحالة ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('حدث خطأ أثناء الاتصال بالسيرفر: $e');
    }
  }
}
