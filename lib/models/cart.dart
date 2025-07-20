// lib/models/cart.dart
import 'product.dart';

class CartItem {
  final Product product;
  int quantity;
  String size;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.size = 'M',
  });

  double get subtotal => product.price * quantity;
  double get totalPrice => subtotal;

  get price => null;

  /// ✅ Creates a deep copy of this cart item
  CartItem copy() {
    return CartItem(
      product: product, // assuming Product is immutable
      quantity: quantity,
      size: size,
    );
  }
}

class CartModel {
  static final List<CartItem> _items = [];

  /// ✅ Unmodifiable view of cart items
  static List<CartItem> get items => List.unmodifiable(_items);

  /// Add a product to the cart with optional quantity/size
  static void add(Product product, {int quantity = 1, String size = 'M'}) {
    final index = _items.indexWhere((item) =>
        item.product.id == product.id &&
        item.size.toLowerCase() == size.toLowerCase());

    if (index != -1) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity, size: size));
    }
  }

  /// Remove a specific cart item
  static void remove(CartItem item) {
    _items.remove(item);
  }

  /// Clear all items in the cart
  static void clear() {
    _items.clear();
  }

  /// Compute total cart price
  static double get totalPrice =>
      _items.fold(0.0, (sum, item) => sum + item.subtotal);
}
