import 'package:flutter/material.dart';
import '../models/order.dart';
import 'order_summary_page.dart';

class OrderListPage extends StatelessWidget {
  const OrderListPage({super.key});

  Color getStatusColor(String status) {
    switch (status) {
      case 'Preparing':
        return Colors.amber;
      case 'To Pay':
        return Colors.red;
      case 'preparing':
        return Colors.orange;
      case 'To Receive':
        return Colors.blue;
      case 'Completed':
        
        return Colors.grey;
      default:
        return Colors.black45;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orders = OrderModel.orders;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
        backgroundColor: Palette.brown,
        foregroundColor: Colors.white,
      ),
      body: orders.isEmpty
          ? const Center(child: Text('No orders yet.'))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (_, index) {
                final order = orders[index];
                final hasItems = order.items.isNotEmpty;
                final firstItem = hasItems ? order.items.first : null;

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: hasItems
                        ? Image.asset(
                            firstItem!.product.imageAsset,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.shopping_bag),
                    title: hasItems
                        ? Text(
                            firstItem!.product.title,
                            overflow: TextOverflow.ellipsis,
                          )
                        : const Text('No product info'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${order.items.length} item(s) - ₱${order.total.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        if ((order.discount) > 0)
                          Text(
                            'Discount: -₱${order.discount.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 12, color: Colors.green),
                          ),
                        Text(
                          'Status: ${order.status}',
                          style: TextStyle(
                            color: getStatusColor(order.status),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrderSummaryPage(
                            items: order.items,
                            paymentMethod: order.paymentMethod,
                            paymentDetail: order.paymentDetail,
                            total: order.total,
                            discount: order.discount,
                            deliveryService: order.deliveryService,
                            status: order.status,
                            shippingAddress: order.shippingAddress,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}