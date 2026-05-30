// ignore: file_names
import 'package:flutter/material.dart';
import '../models/product_model.dart'; // 1. استيراد الموديل

class CardProduct extends StatelessWidget {
  // 2. طلب قائمة المنتجات عند استدعاء هذا الكارد
  final List<Product> productsList;

  const CardProduct({super.key, required this.productsList});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: productsList.length, // 3. الاعتماد على طول القائمة الحقيقية
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemBuilder: (context, index) {
        // جلب بيانات المنتج الحالي بناءً على ترتيبه (index)
        final product = productsList[index];

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // صورة المنتج
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  // 4. التعديل هنا: استدعاء المتغير الديناميكي product.image بدون علامات تنصيص
                  child: Image(
                    image: AssetImage(
                      product.image,
                    ), // تم الإصلاح لقراءة مسار الصورة من الموديل مباشرة
                    fit: BoxFit.contain,
                    // كود احتياطي: في حال لم يجد فلاتر الصورة، يعرض أيقونة افتراضية بدلاً من انهيار الشاشة
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.eco,
                        size: 50,
                        color: Colors.green,
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 5. اسم المنتج الحقيقي
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    // 6. وحدة القياس الحقيقية
                    Text(
                      product.unit,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 7. سعر المنتج الحقيقي
                        Text(
                          '${product.price.toStringAsFixed(2)} د.أ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.black,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
