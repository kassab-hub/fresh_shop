import 'package:flutter/material.dart';
import 'package:fresh_shop/models/product_model.dart';
import 'package:fresh_shop/services/api_service.dart';
import 'package:fresh_shop/widgets/card_product.dart';
import 'package:fresh_shop/widgets/headers.dart';
import 'package:fresh_shop/widgets/menu.dart';
import 'package:fresh_shop/widgets/search_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final ScrollController _scrollController = ScrollController();

  List<Product> _allProducts = [];
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMorePages = true;
  bool _isInitialLoading = true;
  String? _errorMessage;

  int _selectedCategoryIndex = 0;
  String? _selectedCategoryName;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // جلب المنتجات للقسم المختار (null في البداية يعني جلب الكل)
    _fetchProductsPage(_currentPage, category: _selectedCategoryName);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // نوقف الـ Pagination فقط أثناء البحث النصي الحي
    if (_searchQuery.isNotEmpty) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && _hasMorePages) {
        _fetchProductsPage(_currentPage + 1, category: _selectedCategoryName);
      }
    }
  }

  // 🎯 قمنا بتحديث الدالة لتستقبل اسم القسم وتمرره للـ API Service
  Future<void> _fetchProductsPage(int page, {String? category}) async {
    if (page == 1) {
      setState(() {
        _isInitialLoading = true;
        _errorMessage = null;
      });
    } else {
      setState(() {
        _isLoadingMore = true;
      });
    }

    try {
      final response = await _apiService.fetchProducts(
        page: page,
        category: category,
      );

      setState(() {
        _currentPage = page;
        _hasMorePages = response['meta']['has_more'] ?? false;

        // 🎯 التعديل هنا: جلب القائمة مباشرة لأنها محولة مسبقاً داخل الـ ApiService
        final List<Product> fetchedProducts = response['data'];

        if (page == 1) {
          _allProducts = fetchedProducts;
        } else {
          _allProducts.addAll(fetchedProducts);
        }
        _isInitialLoading = false;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _isInitialLoading = false;
        _isLoadingMore = false;
        _errorMessage = 'حدث خطأ أثناء تحميل المنتجات، يرجى المحاولة لاحقاً.';
      });
    }
  }

  List<Product> _filterProducts() {
    List<Product> factoryList = _allProducts;

    String normalizeArabic(String text) {
      return text
          .trim()
          .toLowerCase()
          .replaceAll('ة', 'ه')
          .replaceAll('ى', 'ي')
          .replaceAll('إ', 'ا')
          .replaceAll('أ', 'ا')
          .replaceAll('آ', 'ا');
    }

    // 🎯 أصبحت الفلترة هنا للـ البحث فقط لأن الأقسام أصبحت تأتي جاهزة ومفلترة من السيرفر بكفاءة 100%
    if (_searchQuery.isNotEmpty) {
      factoryList = factoryList.where((product) {
        final cleanProductName = normalizeArabic(product.name);
        final cleanQuery = normalizeArabic(_searchQuery);
        return cleanProductName.contains(cleanQuery);
      }).toList();
    }

    return factoryList;
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _filterProducts();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16.0),
          children: [
            const Headers(),
            const SizedBox(height: 20),

            SearchField(
              onSearchChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),

            const SizedBox(height: 25),

            Menu(
              selectedIndex: _selectedCategoryIndex,
              onCategorySelected: (index, categoryName) {
                if (_selectedCategoryIndex == index)
                  return; // تمنع إعادة التحميل إذا ضغط نفس القسم

                setState(() {
                  _selectedCategoryIndex = index;
                  _selectedCategoryName = categoryName;
                  _currentPage = 1; // تصفير الصفحات للبدء من جديد للقسم الجديد
                });

                // 🎯 طلب منتجات القسم المختار فوراً من السيرفر برقم صفحة 1
                _fetchProductsPage(1, category: categoryName);
              },
            ),

            const SizedBox(height: 25),
            const Text(
              'المنتجات الطازجة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            if (_isInitialLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 80.0),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_errorMessage != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            else ...[
              if (filteredProducts.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 50.0),
                  child: Center(
                    child: Text('لا توجد منتجات تطابق بحثك حالياً 😔'),
                  ),
                )
              else
                CardProduct(productsList: filteredProducts),

              if (_isLoadingMore && _searchQuery.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
