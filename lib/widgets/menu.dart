import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fresh_shop/widgets/global_file.dart';
import 'package:http/http.dart' as http;

class Menu extends StatefulWidget {
  final int selectedIndex;
  final Function(int index, String? categoryName) onCategorySelected;

  const Menu({
    super.key,
    required this.selectedIndex,
    required this.onCategorySelected,
  });

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  // دالة لجلب الأقسام من سيرفر Laravel API
  Future<List<Map<String, dynamic>>> fetchCategories() async {
    try {
      // نستخدم الأي بي الخاص بسيرفر لاراجون المحلي
      final response = await http.get(
        Uri.parse('${AppGlobals.apiBaseUrl}/categories'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = json.decode(response.body);
        List<dynamic> categoriesData = decodedData['data'];

        // تحويل البيانات المجلوبة إلى List من الـ Maps لتسهيل التعامل معها
        List<Map<String, dynamic>> categories = [
          {'id': null, 'name': 'الكل'}, // إضافة خيار "الكل" يدوياً في البداية
        ];

        for (var item in categoriesData) {
          categories.add({'id': item['id'], 'name': item['name']});
        }
        return categories;
      } else {
        throw Exception('فشل في تحميل الأقسام');
      }
    } catch (e) {
      throw Exception('حدث خطأ أثناء الاتصال بالسيرفر: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchCategories(), // استدعاء الدالة
        builder: (context, snapshot) {
          // 1. أثناء وقت التحميل والجلب من السيرفر
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.green),
            );
          }

          // 2. في حال حدوث خطأ في الاتصال بالسيرفر
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'خطأ في جلب الأقسام',
                style: TextStyle(color: Colors.red[700], fontSize: 12),
              ),
            );
          }

          // 3. في حال عدم وجود بيانات
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('لا توجد أقسام متوفرة'));
          }

          // البيانات أصبحت جاهزة هنا
          final categories = snapshot.data!;

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              bool isSelected = widget.selectedIndex == index;

              return GestureDetector(
                onTap: () {
                  // نرسل الـ index لتغيير المظهر، واسم القسم الفعلي للفلترة المحلية
                  // إذا كان القسم هو الأول (الكل)، نرسل null
                  String? categoryName = index == 0
                      ? null
                      : categories[index]['name'];
                  widget.onCategorySelected(index, categoryName);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : Colors.grey.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          fontSize: isSelected ? 15 : 14,
                        ),
                        child: Text(categories[index]['name'] ?? ''),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
