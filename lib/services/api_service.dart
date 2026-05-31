import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ApiService {
  // الرابط الأساسي (تأكد من عدم وجود مائلة مائلة إضافية في النهاية)
  static const String baseUrl =
      'http://192.168.1.101/fresh-shop-api/public/api';

  Future<List<Product>> fetchProducts() async {
    // هنا يتم دمج الرابط الأساسي مع الـ Endpoint المخصص للمنتجات
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
