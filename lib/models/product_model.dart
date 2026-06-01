class Product {
  final int id;
  final String name;
  final String image;
  final double price;
  final String unit;
  final String category; // 🎯 تم إضافة حقل القسم هنا لربطه مع القائمة

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.unit,
    required this.category, // مطلوب عند إنشاء أي منتج
  });

  // 💡 دالة تحويل الـ JSON القادم من لارافيل إلى كائن برمي داخل فلاتر
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      unit: json['unit'],
      category: json['category'] ?? 'عام',

      // 🎯 الحل السحري والمرن لاستقبال السعر بأي صيغة كانت
      price: json['price'] is num
          ? (json['price'] as num).toDouble()
          : double.tryParse(json['price'].toString()) ?? 0.0,
    );
  }
}
