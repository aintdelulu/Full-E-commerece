import 'package:flutter/material.dart';
import '../models/cart.dart';

class OrderSummaryPage extends StatefulWidget {
  const OrderSummaryPage({
    super.key,
    required this.items,
    required this.paymentMethod,
    this.paymentDetail,
    required this.total,
    required this.discount,
    required this.deliveryService,
    this.status,
    this.shippingAddress,
  });

  final List<CartItem> items;
  final String paymentMethod;
  final String? paymentDetail;
  final double total;
  final double discount;
  final String deliveryService;
  final String? status;
  final String? shippingAddress;

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  late String currentStatus;
  String? cancelReason;

  final List<String> steps = ['Preparing', 'To Ship', 'To Deliver', 'To Rate'];

  @override
  void initState() {
    super.initState();
    currentStatus = (widget.status?.isNotEmpty == true) ? widget.status! : "Preparing";
  }

  int getStatusStepIndex(String status) {
    switch (status.toLowerCase()) {
      case 'preparing':
        return 0;
      case 'to ship':
        return 1;
      case 'to deliver':
        return 2;
      case 'to rate':
        return 3;
      default:
        return 0;
    }
  }

  Color getStepColor(String step) {
    final current = currentStatus.toLowerCase();
    final stepLower = step.toLowerCase();

    if (stepLower == current) {
      return Colors.orange;
    } else if (getStatusStepIndex(step) < getStatusStepIndex(currentStatus)) {
      return Colors.green;
    } else {
      return Colors.grey;
    }
  }

  IconData getStepIcon(String step) {
    final stepLower = step.toLowerCase();
    switch (stepLower) {
      case 'preparing':
        return Icons.kitchen;
      case 'to ship':
        return Icons.local_shipping;
      case 'to deliver':
        return Icons.delivery_dining;
      case 'to rate':
        return Icons.rate_review;
      default:
        return Icons.info;
    }
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String? selectedReason;
        return AlertDialog(
          title: const Text("Cancel Order"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Please select a reason for cancellation:"),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Reason",
                ),
                items: const [
                  DropdownMenuItem(value: "Changed my mind", child: Text("Changed my mind")),
                  DropdownMenuItem(value: "Found a better price", child: Text("Found a better price")),
                  DropdownMenuItem(value: "Item no longer needed", child: Text("Item no longer needed")),
                  DropdownMenuItem(value: "Other", child: Text("Other")),
                ],
                onChanged: (value) {
                  selectedReason = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Back"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Confirm Cancel"),
              onPressed: () {
                if (selectedReason != null) {
                  setState(() {
                    currentStatus = "Preparing";
                    cancelReason = selectedReason;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Order cancelled")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please select a reason")),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildStep(String title) {
    final color = getStepColor(title);
    final icon = getStepIcon(title);
    final isActive = getStatusStepIndex(currentStatus) >= getStatusStepIndex(title);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(title, style: TextStyle(color: isActive ? Colors.black : Colors.grey)),
      ],
    );
  }

  Widget buildConnector(bool active) {
    return Container(
      width: 30,
      height: 3,
      color: active ? Colors.green : Colors.grey.shade300,
    );
  }

  @override
  Widget build(BuildContext context) {
    final discountedTotal = (widget.total - widget.discount).clamp(0, double.infinity);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Summary'),
        backgroundColor: Palette.brown,
        foregroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth > 600;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Stepper
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(steps.length * 2 - 1, (index) {
                              if (index.isEven) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: buildStep(steps[index ~/ 2]),
                                );
                              } else {
                                return buildConnector(getStatusStepIndex(currentStatus) > (index ~/ 2));
                              }
                            }),
                          ),
                        ),
                        const SizedBox(height: 16),

                        /// Delivery
                        Row(
                          children: [
                            const Icon(Icons.local_shipping, size: 20, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              'Delivery: ${widget.deliveryService}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        /// Shipping Address
                        if (widget.shippingAddress != null && widget.shippingAddress!.isNotEmpty) ...[
                          const Text('Shipping Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text(widget.shippingAddress!),
                          const SizedBox(height: 16),
                        ],

                        /// Items
                        const Text('Items', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const Divider(),
                        ...widget.items.map((item) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  item.product.imageAsset,
                                  width: isWideScreen ? 60 : 40,
                                  height: isWideScreen ? 60 : 40,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.product.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                                      Text('Size: ${item.size} | Qty: ${item.quantity} | ₱${item.totalPrice.toStringAsFixed(2)}'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        const Divider(height: 32),

                        /// Payment Info
                        const Text('Payment Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text('Method: ${widget.paymentMethod}'),
                        if (widget.paymentDetail != null) Text('Details: ${widget.paymentDetail}'),
                        const SizedBox(height: 16),

                        /// Price Breakdown
                        const Text('Price Breakdown', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          const Text('Subtotal:'), Text('₱${widget.total.toStringAsFixed(2)}'),
                        ]),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          const Text('Discount:'), Text('-₱${widget.discount.toStringAsFixed(2)}'),
                        ]),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('Total Amount', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(),
                            Text(
                              '₱${discountedTotal.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        /// Cancel Button
                        if (currentStatus.toLowerCase() == "preparing")
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: _showCancelDialog,
                              icon: const Icon(Icons.cancel),
                              label: const Text("Cancel Order"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              ),
                            ),
                          ),
                      ],
                    ),
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

class Palette {
  static const Color brown = Color(0xFF8B4513);
}