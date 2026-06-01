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
    // 🎯 بقيت الـ Row فقط لتضم الترحيب وزر السلة، وحذفنا الـ Column وشريط البحث القديم
    return Row(
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

        // زر السلة العلوي الاحترافي
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
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
    );
  }
}
