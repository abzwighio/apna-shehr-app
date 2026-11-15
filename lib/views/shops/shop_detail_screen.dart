import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_translations.dart';
import '../../providers/app_state.dart';
import '../../providers/cart_provider.dart';
import '../../models/shop.dart';
import '../orders/orders_screen.dart';

class ShopDetailScreen extends StatelessWidget {
  final Shop shop;

  const ShopDetailScreen({Key? key, required this.shop}) : super(key: key);

  void _callPhone(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _openWhatsApp(String phone, [String? customMessage]) async {
    var cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanPhone.startsWith('0')) {
      cleanPhone = '92${cleanPhone.substring(1)}';
    }
    final msg = customMessage ?? 'Salam! Main ne Apna Shehr Online app par aap ki dukaan dekhi hai.';
    final uri = Uri.parse('https://wa.me/$cleanPhone?text=${Uri.encodeComponent(msg)}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _checkoutWithWhatsApp(BuildContext context, CartProvider cart, String lang) {
    if (cart.items.isEmpty) return;

    final buffer = StringBuffer();
    buffer.writeln('Salam! Main Apna Shehr Online se order karna chahta hoon:');
    buffer.writeln('-----------------------------------');
    for (var i in cart.items) {
      buffer.writeln('• ${i.name} (${i.qty} x Rs. ${i.price.toStringAsFixed(0)}) = Rs. ${i.subtotal.toStringAsFixed(0)}');
    }
    buffer.writeln('-----------------------------------');
    buffer.writeln('Total Bill: Rs. ${cart.totalAmount.toStringAsFixed(0)}');
    buffer.writeln('Delivery Address: ');

    _openWhatsApp(shop.phone, buffer.toString());
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final cart = context.watch<CartProvider>();
    final isUrdu = state.lang == 'ur';

    return Scaffold(
      appBar: AppBar(
        title: Text(shop.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              // Share shop
            },
          ),
        ],
      ),
      bottomNavigationBar: cart.itemCount > 0 && cart.shopId == shop.id
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${cart.itemCount} ${isUrdu ? "اشیاء" : "Items"}',
                          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                        ),
                        Text(
                          'Rs. ${cart.totalAmount.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.shopping_bag_outlined),
                      label: Text(isUrdu ? 'آرڈر کنفرم کریں' : 'Confirm Order'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onPressed: () => _checkoutWithWhatsApp(context, cart, state.lang),
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shop Header Card
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.store, color: AppColors.primary, size: 36),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              shop.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              shop.address,
                              style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Badges
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: shop.isOpen ? AppColors.green : AppColors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        shop.isOpen
                            ? AppTranslations.text('open', state.lang)
                            : AppTranslations.text('closed', state.lang),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: shop.isOpen ? AppColors.green : AppColors.red,
                        ),
                      ),
                      const SizedBox(width: 16),
                      if (shop.deliveryAvailable)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.emerald.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            AppTranslations.text('delivery', state.lang),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.emerald,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.call, color: AppColors.primary),
                          label: Text(AppTranslations.text('call', state.lang)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primary),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          onPressed: () => _callPhone(shop.phone),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.chat_bubble_outline),
                          label: Text(AppTranslations.text('whatsapp', state.lang)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF25D366),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          onPressed: () => _openWhatsApp(shop.phone),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Products / Services Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                shop.bookingAvailable
                    ? (isUrdu ? 'سروسز اور ریٹس' : 'Services & Rates')
                    : (isUrdu ? 'دکان کی پروڈکٹس اور ریٹس' : 'Items & Daily Rates'),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            if (shop.items.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    isUrdu ? 'اس وقت کوئی آئٹم لسٹ نہیں ہے' : 'No items listed yet',
                    style: const TextStyle(color: AppColors.textMuted),
                  ),
                ),
              )
            else
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: shop.items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = shop.items[index];
                  final qty = cart.getItemQty(item.id);

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    item.effectivePrice == 0
                                        ? AppTranslations.text('free', state.lang)
                                        : 'Rs. ${item.effectivePrice.toStringAsFixed(0)} / ${item.unit}',
                                    style: const TextStyle(
                                      color: AppColors.primaryDark,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  if (item.discountPct > 0) ...[
                                    const SizedBox(width: 8),
                                    Text(
                                      'Rs. ${item.price.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        color: AppColors.textMuted,
                                        fontSize: 11,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: AppColors.red.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        '-${item.discountPct.toInt()}%',
                                        style: const TextStyle(
                                          color: AppColors.red,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Add to Cart / Stepper
                        if (!shop.bookingAvailable)
                          qty == 0
                              ? OutlinedButton(
                                  onPressed: () => cart.addItem(shop, item),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: AppColors.primary),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  ),
                                  child: Text(
                                    AppTranslations.text('add_to_cart', state.lang),
                                    style: const TextStyle(fontSize: 12, color: AppColors.primary),
                                  ),
                                )
                              : Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle_outline, color: AppColors.primary),
                                      onPressed: () => cart.removeItem(item.id),
                                    ),
                                    Text(
                                      '$qty',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add_circle, color: AppColors.primary),
                                      onPressed: () => cart.addItem(shop, item),
                                    ),
                                  ],
                                ),
                      ],
                    ),
                  );
                },
              ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
