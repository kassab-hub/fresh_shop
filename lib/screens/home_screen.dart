import 'package:flutter/material.dart';
import 'package:fresh_shop/models/product_model.dart';
import 'package:fresh_shop/screens/login_screen.dart';
import 'package:fresh_shop/services/api_service.dart';
import 'package:fresh_shop/widgets/card_product.dart';
import 'package:fresh_shop/widgets/headers.dart';
import 'package:fresh_shop/widgets/menu.dart';
import 'package:fresh_shop/widgets/search_field.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 🎯 مضاف لجلب بيانات الجلسة وتسجيل الخروج

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

  String _userName =
      'مستخدم'; // 🎯 لتخزين اسم المستخدم القادم من السيرفر محلياً

  @override
  void initState() {
    super.initState();
    _loadUserData(); // 🎯 جلب اسم المستخدم عند فتح الشاشة
    _fetchProductsPage(_currentPage, category: _selectedCategoryName);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // 🎯 دالة قراءة بيانات جلسة المستخدم المسجل
  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'مستخدم دائم';
    });
  }

  // 🎯 دالة تسجيل الخروج والعودة لصفحة الدخول بنظافة
  // 🎯 الدالة المحدثة لتسجيل الخروج والانتقال المباشر بدون نظام الـ Routes
  void _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // مسح الـ user_id والـ token تماماً من ذاكرة الهاتف

    if (mounted) {
      // الانتقال مباشرة إلى شاشة تسجيل الدخول وتفريغ شجرة الصفحات السابقة لمنع العودة
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ), // 👈 الانتقال المباشر لكائن الشاشة
        (route) => false,
      );
    }
  }

  void _scrollListener() {
    if (_searchQuery.isNotEmpty) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && _hasMorePages) {
        _fetchProductsPage(_currentPage + 1, category: _selectedCategoryName);
      }
    }
  }

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
          .replaceAll('ى', 'i') // تم إبقاؤها كما هي لديك للاستقرار
          .replaceAll('إ', 'ا')
          .replaceAll('أ', 'ا')
          .replaceAll('آ', 'ا');
    }

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

      // 🎯 مضاف: إضافة شريط علوي أنيق يحتوي على اسم المستخدم وزر تسجيل الخروج
      appBar: AppBar(
        title: Text(
          'أهلاً بك، $_userName 🍃',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading:
            false, // يمنع ظهور سهم العودة للخلف بشكل إجباري
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            tooltip: 'تسجيل الخروج',
            onPressed: _handleLogout,
          ),
        ],
      ),

      body: SafeArea(
        child: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          children: [
            const Headers(),
            const SizedBox(height: 15),

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
                if (_selectedCategoryIndex == index) {
                  return;
                }
                setState(() {
                  _selectedCategoryIndex = index;
                  _selectedCategoryName = categoryName;
                  _currentPage = 1;
                });

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
