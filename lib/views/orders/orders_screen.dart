import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_translations.dart';
import '../../providers/app_state.dart';
import '../../models/order.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status) {
      case 'accepted':
      case 'preparing':
        return AppColors.blue;
      case 'on_way':
        return AppColors.goldDark;
      case 'delivered':
        return AppColors.green;
      case 'cancelled':
        return AppColors.red;
      default:
        return AppColors.primary;
    }
  }

  String _getStatusText(String status, bool isUrdu) {
    switch (status) {
      case 'accepted':
        return isUrdu ? 'منظور شدہ' : 'Accepted';
      case 'preparing':
        return isUrdu ? 'تیار ہو رہا ہے' : 'Preparing';
      case 'on_way':
        return isUrdu ? 'راستے میں ہے' : 'On The Way';
      case 'delivered':
        return isUrdu ? 'ڈیلیور ہو گیا' : 'Delivered';
      case 'cancelled':
        return isUrdu ? 'منسوخ' : 'Cancelled';
      default:
        return isUrdu ? 'موصول ہوا' : 'Order Placed';
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final isUrdu = state.lang == 'ur';

    // Sample active order representation
    final sampleOrders = [
      AppOrder(
        id: 'ord-101',
        shopId: 'shop-1',
        shopName: 'Al-Madina Karyana & General Store',
        customerName: 'Muhammad Ali',
        customerPhone: '03001234567',
        deliveryAddress: 'Flat 4B, Latifabad Unit 7',
        totalPkr: 1670,
        status: 'on_way',
        createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
        items: [
          OrderLineItem(itemId: 'i1', name: 'Basmati Rice (Super Kernel)', unit: 'kg', price: 320, qty: 1),
          OrderLineItem(itemId: 'i3', name: 'Chakki Atta (Fresh)', unit: '10kg', price: 1350, qty: 1),
        ],
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(AppTranslations.text('orders', state.lang)),
      ),
      body: sampleOrders.isEmpty
          ? Center(
              child: Text(
                isUrdu ? 'ابھی تک کوئی آرڈر نہیں دیا گیا' : 'No active orders placed yet',
                style: const TextStyle(color: AppColors.textMuted),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sampleOrders.length,
              itemBuilder: (context, index) {
                final order = sampleOrders[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              order.shopName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: _getStatusColor(order.status).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                _getStatusText(order.status, isUrdu),
                                style: TextStyle(
                                  color: _getStatusColor(order.status),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Order ID: #${order.id}',
                          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                        ),
                        const Divider(height: 20),
                        Column(
                          children: order.items
                              .map(
                                (i) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${i.qty}x ${i.name}', style: const TextStyle(fontSize: 13)),
                                      Text('Rs. ${i.subtotal.toStringAsFixed(0)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isUrdu ? 'کل رقم:' : 'Total Amount:',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Text(
                              'Rs. ${order.totalPkr.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
