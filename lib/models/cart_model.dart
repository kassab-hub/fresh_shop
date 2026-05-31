import 'product_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}

// هذه هي القائمة العالمية التي سنخزن فيها المنتجات المضافة
List<CartItem> globalCart = [];
