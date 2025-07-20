import 'cart.dart'; // Ensure this contains CartItem and CartModel

class Order {
  final List<CartItem> items;
  final String paymentMethod;
  final String? paymentDetail;
  final double total;
  final double discount;
  final String deliveryService;
  final String status;
  final String? shippingAddress;

  Order({
    required this.items,
    required this.paymentMethod,
    this.paymentDetail,
    required this.total,
    this.discount = 0.0,
    this.deliveryService = 'J&T Express',
    this.status = 'Preparing',
    this.shippingAddress,
  });
}

class OrderModel {
  static final List<Order> _orders = [];

  static List<Order> get orders => List.unmodifiable(_orders);

  static void saveOrder({
    required List<CartItem> orderItems,
    required String method,
    String? detail,
    required double orderTotal,
    double discount = 0.0,
    String deliveryService = 'J&T Express',
    String status = 'Preparing',
    String? shippingAddress,
  }) {
    final order = Order(
      items: List<CartItem>.from(orderItems),
      paymentMethod: method,
      paymentDetail: detail,
      total: orderTotal,
      discount: discount,
      deliveryService: deliveryService,
      status: status,
      shippingAddress: shippingAddress,
    );
    _orders.add(order);
  }

  static void deleteOrder(Order order) {
    _orders.remove(order);
  }

  static void deleteOrderAt(int index) {
    if (index >= 0 && index < _orders.length) {
      _orders.removeAt(index);
    }
  }

  static void reorder(int index) {
    if (index >= 0 && index < _orders.length) {
      final order = _orders[index];
      CartModel.items.addAll(order.items);
    }
  }

  static void clearOrders() {
    _orders.clear();
  }
}
