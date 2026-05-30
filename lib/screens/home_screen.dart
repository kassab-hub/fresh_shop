import 'package:flutter/material.dart';
import 'package:fresh_shop/models/product_model.dart';
import 'package:fresh_shop/widgets/Card_product.dart';
import 'package:fresh_shop/widgets/headers.dart';
import 'package:fresh_shop/widgets/menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Product> myProducts = [
    Product(
      name: 'تفاح أحمر',
      image: 'assets/images/apple.png',
      price: 1.75,
      unit: '1 كيلو',
    ),
    Product(
      name: 'بروكلي طازج',
      image: 'assets/images/broccoli.png',
      price: 2.20,
      unit: '500 غرام',
    ),
    Product(
      name: 'موز هندي',
      image: 'assets/images/banana.png',
      price: 1.25,
      unit: '1 كيلو',
    ),
    Product(
      name: 'جزر عضوي',
      image: 'assets/images/carrot.png',
      price: 0.90,
      unit: '1 كيلو',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // التعديل 1: جعل الشاشة بالكامل قابلة للتمرير لمنع الانهيار
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. الترويسة (Header) + زر السلة
                const Headers(), // استدعاء الترويسة التي أنشأناها في ملف headers

                const SizedBox(height: 25),

                // 3. قائمة الأقسام (Categories) - عرض أفقي
                const Menu(), // استدعاء قائمة الأقسام التي أنشأناها في ملف menu.dart

                const SizedBox(height: 25),

                // عنوان قبل المنتجات
                const Text(
                  'المنتجات الطازجة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 15),

                // 4. قائمة المنتجات (Products) - عرض أفقي
                CardProduct(
                  productsList: myProducts,
                ), // استدعاء الكارد الذي أنشأناه في ملف Card_product.dart
              ],
            ),
          ),
        ),
      ),
    );
  }
}
