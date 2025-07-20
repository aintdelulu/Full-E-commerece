import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart.dart';
import '../widgets/helpers.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;
  String _selectedSize = 'M';
  final List<String> _sizes = ['S', 'M', 'L', 'XL'];

  @override
  Widget build(BuildContext context) {
    final p = ModalRoute.of(context)!.settings.arguments as Product?;

    return simpleScaffold(
      context,
      'Product Detail',
      null,
      p == null
          ? const Center(child: Text('No product'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 4 / 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        p.imageAsset,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(p.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('₱${p.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, color: Colors.brown)),
                  const SizedBox(height: 24),

                  // Size dropdown
                  Row(
                    children: [
                      const Text('Size:', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 10),
                      DropdownButton<String>(
                        value: _selectedSize,
                        items: _sizes
                            .map((size) => DropdownMenuItem(value: size, child: Text(size)))
                            .toList(),
                        onChanged: (val) {
                          setState(() => _selectedSize = val!);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Quantity selector
                  Row(
                    children: [
                      const Text('Quantity:', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                      ),
                      Text('$_quantity', style: const TextStyle(fontSize: 16)),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => setState(() => _quantity++),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Add to cart button
                  Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text("Add to Cart"),
                      onPressed: () {
                        for (int i = 0; i < _quantity; i++) {
                          CartModel.add(p);
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("${p.title} (Size $_selectedSize) x$_quantity added to cart!")),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
