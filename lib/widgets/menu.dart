import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  // 🎯 أضفنا هذه المتغيرات لاستقبال التحكم من الشاشة الرئيسية
  final int selectedIndex;
  final Function(int) onCategorySelected;

  const Menu({
    super.key,
    required this.selectedIndex,
    required this.onCategorySelected,
  });

  // قائمة الأقسام الثابتة
  final List<String> categories = const ['الكل', 'خضروات', 'فواكه', 'ورقيات'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          bool isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () {
              // 🎯 عندما يضغط المستخدم، نرسل رقم القسم للشاشة الرئيسية فوراً
              onCategorySelected(index);
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
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
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
                    child: Text(categories[index]),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
