import 'package:flutter/material.dart';
import 'package:fresh_shop/screens/cart_screen.dart';

class Headers extends StatefulWidget {
  const Headers({super.key});

  @override
  State<Headers> createState() => _HeadersState();
}

class _HeadersState extends State<Headers> {
  @override
  Widget build(BuildContext context) {
    // قمنا بوضع المكونات داخل Column لكي نتمكن من عمل return لها جميعاً معاً
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. الترويسة (Header)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مرحباً بك 👋',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const Text(
                  'تسوق خضار طازجة',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            // زر السلة العلوي
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.shopping_basket_outlined),
                color: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 20), // مسافة بين الترويسة وشريط البحث
        // 2. شريط البحث (Search Bar)
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const TextField(
            decoration: InputDecoration(
              hintText: 'ابحث عن خضار أو فواكه...',
              hintStyle: TextStyle(color: Colors.grey),
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
      ],
    );
  }
}
