// lib/pages/cart_page.dart
import 'package:flutter/material.dart';
import '../widgets/helpers.dart';
import '../models/cart.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> _items = [];

  @override
  void initState() {
    super.initState();
    _items = List<CartItem>.from(CartModel.items);
  }

  double get totalPrice =>
      _items.fold(0, (sum, item) => sum + item.product.price * item.quantity);

  void _removeItem(int index) {
    setState(() {
      CartModel.items.removeAt(index);
      _items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: Palette.brown,
        foregroundColor: Colors.white,
      ),
      body: _items.isEmpty
          ? const Center(child: Text('Your cart is empty.'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (_, i) {
                      final item = _items[i];
                      return ListTile(
                        leading: Image.asset(item.product.imageAsset, width: 50),
                        title: Text(item.product.title),
                        subtitle: Text(
                          'Size: ${item.size}\n'
                          'Quantity: ${item.quantity}\n'
                          'Subtotal: ₱${(item.product.price * item.quantity).toStringAsFixed(2)}',
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeItem(i),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '₱${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.brown,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    icon: const Icon(Icons.payment),
                    label: const Text('Proceed to Checkout'),
                    onPressed: () {
                      Navigator.pushNamed(context, '/checkout');
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
