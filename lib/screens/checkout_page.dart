import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../models/order.dart';
import 'order_summary_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _paymentMethod = 'cash';
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _cardController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final Map<String, double> _vouchers = {
    'NONE': 0,
    'DISCOUNT10': 10.0,
    'SAVE20': 20.0,
    'FREESHIP': 30.0,
  };
  String _selectedVoucher = 'NONE';
  double get _voucherDiscount => _vouchers[_selectedVoucher] ?? 0.0;

  @override
  Widget build(BuildContext context) {
    final items = CartModel.items;
    final originalTotal = CartModel.totalPrice;
    final discountedTotal = (originalTotal - _voucherDiscount).clamp(0, double.infinity);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Palette.brown,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Your Items:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, i) {
                  final item = items[i];
                  return ListTile(
                    leading: Image.asset(item.product.imageAsset, width: 40),
                    title: Text(item.product.title),
                    subtitle: Text(
                      'Size: ${item.size} | Qty: ${item.quantity} | ₱${item.totalPrice.toStringAsFixed(2)}',
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // 🏠 Shipping Address
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Shipping Address',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            // 🎁 Voucher
            DropdownButtonFormField<String>(
              value: _selectedVoucher,
              decoration: const InputDecoration(
                labelText: 'Select Voucher',
                border: OutlineInputBorder(),
              ),
              items: _vouchers.entries.map((entry) {
                return DropdownMenuItem(
                  value: entry.key,
                  child: Text('${entry.key} - ₱${entry.value.toStringAsFixed(2)}'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedVoucher = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // 💳 Payment Method
            const Text('Select Payment Method:'),
            Column(
              children: [
                RadioListTile(
                  value: 'cash',
                  groupValue: _paymentMethod,
                  onChanged: (v) => setState(() => _paymentMethod = v.toString()),
                  title: const Text('Cash'),
                ),
                RadioListTile(
                  value: 'gcash',
                  groupValue: _paymentMethod,
                  onChanged: (v) => setState(() => _paymentMethod = v.toString()),
                  title: const Text('GCash'),
                ),
                if (_paymentMethod == 'gcash')
                  TextField(
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'Mobile Number'),
                  ),
                RadioListTile(
                  value: 'card',
                  groupValue: _paymentMethod,
                  onChanged: (v) => setState(() => _paymentMethod = v.toString()),
                  title: const Text('Debit/Credit Card'),
                ),
                if (_paymentMethod == 'card')
                  TextField(
                    controller: _cardController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Card Number'),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // 💰 Totals
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Original Total:', style: TextStyle(fontSize: 14)),
                Text('₱${originalTotal.toStringAsFixed(2)}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Voucher Discount:', style: TextStyle(fontSize: 14)),
                Text('-₱${_voucherDiscount.toStringAsFixed(2)}'),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total to Pay:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  '₱${discountedTotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ✅ Confirm Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Palette.brown,
                side: BorderSide(color: Palette.brown),
                minimumSize: const Size.fromHeight(45),
              ),
              onPressed: () {
                String msg = 'Order placed using $_paymentMethod';

                if (_addressController.text.isEmpty) {
                  msg = 'Please enter a shipping address';
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                  return;
                }

                if (_paymentMethod == 'gcash' && _mobileController.text.isEmpty) {
                  msg = 'Please enter your GCash mobile number';
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                  return;
                }

                if (_paymentMethod == 'card' && _cardController.text.isEmpty) {
                  msg = 'Please enter your card number';
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                  return;
                }

                final paymentDetail = _paymentMethod == 'gcash'
                    ? _mobileController.text
                    : _paymentMethod == 'card'
                        ? _cardController.text
                        : null;

                final address = _addressController.text.trim();
                final itemsCopy = items.map((item) => item.copy()).toList();

                OrderModel.saveOrder(
                  orderItems: itemsCopy,
                  method: _paymentMethod,
                  detail: paymentDetail,
                  orderTotal: discountedTotal.toDouble(),      // ✅ Cast to double
                  discount: _voucherDiscount.toDouble(),       // ✅ Cast to double
                  shippingAddress: address,
                );

                CartModel.clear();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OrderSummaryPage(
                      items: itemsCopy,
                      paymentMethod: _paymentMethod,
                      paymentDetail: paymentDetail,
                      total: discountedTotal.toDouble(),        // ✅ Cast to double
                      discount: _voucherDiscount.toDouble(),     // ✅ Cast to double
                      deliveryService: 'J&T Express',
                      status: 'Preparing',
                      shippingAddress: address,
                    ),
                  ),
                );
              },
              child: const Text('Confirm Order'),
            ),
          ],
        ),
      ),
    );
  }
}