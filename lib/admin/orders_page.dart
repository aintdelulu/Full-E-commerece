import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/auth_service.dart';
import '../models/user.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool _isCurved = true;
  AppUser? _selectedUser;

  @override
  void initState() {
    super.initState();
    _selectedUser = AuthService.users.first;
  }

  List<FlSpot> get _spots {
    final data = _selectedUser?.weeklyOrders ?? [];
    return List.generate(data.length, (index) => FlSpot(index.toDouble(), data[index]));
  }

  @override
  Widget build(BuildContext context) {
    final total = _spots.fold(0.0, (sum, spot) => sum + spot.y);
    final avg = total / (_spots.isEmpty ? 1 : _spots.length);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Order Trends", style: Theme.of(context).textTheme.headlineSmall),
              const Spacer(),
              DropdownButton<AppUser>(
                value: _selectedUser,
                onChanged: (AppUser? user) {
                  setState(() {
                    _selectedUser = user;
                  });
                },
                items: AuthService.users.map((user) {
                  return DropdownMenuItem<AppUser>(
                    value: user,
                    child: Text(user.username),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text("Total Orders: ${total.toStringAsFixed(1)} • Avg/Day: ${avg.toStringAsFixed(1)}"),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.show_chart, color: Colors.brown),
              const SizedBox(width: 8),
              const Text("Brown Line = Orders"),
              const Spacer(),
              Row(
                children: [
                  const Text("Curved"),
                  Switch(
                    value: _isCurved,
                    onChanged: (val) => setState(() => _isCurved = val),
                    activeColor: Colors.brown,
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: 6,
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 42,
                      getTitlesWidget: (value, _) => Text('${value.toInt()}'),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        switch (value.toInt()) {
                          case 0:
                            return const Text('Mon');
                          case 1:
                            return const Text('Tue');
                          case 2:
                            return const Text('Wed');
                          case 3:
                            return const Text('Thu');
                          case 4:
                            return const Text('Fri');
                          default:
                            return const Text('');
                        }
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: _spots,
                    isCurved: _isCurved,
                    color: Colors.brown,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.brown.withOpacity(0.2),
                    ),
                    dotData: FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
