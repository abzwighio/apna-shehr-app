import 'package:flutter/material.dart';
import '../models/shop.dart';
import '../models/order.dart';

class CartProvider extends ChangeNotifier {
  String? _shopId;
  String? _shopName;
  final Map<String, OrderLineItem> _items = {};

  String? get shopId => _shopId;
  String? get shopName => _shopName;
  List<OrderLineItem> get items => _items.values.toList();
  int get itemCount => _items.values.fold(0, (sum, i) => sum + i.qty);
  double get totalAmount => _items.values.fold(0.0, (sum, i) => sum + i.subtotal);

  void addItem(Shop shop, ShopItem item) {
    if (_shopId != null && _shopId != shop.id) {
      // Switched shop: clear previous cart
      _items.clear();
    }
    _shopId = shop.id;
    _shopName = shop.name;

    if (_items.containsKey(item.id)) {
      final existing = _items[item.id]!;
      _items[item.id] = OrderLineItem(
        itemId: existing.itemId,
        name: existing.name,
        unit: existing.unit,
        price: existing.price,
        qty: existing.qty + 1,
      );
    } else {
      _items[item.id] = OrderLineItem(
        itemId: item.id,
        name: item.name,
        unit: item.unit,
        price: item.effectivePrice,
        qty: 1,
      );
    }
    notifyListeners();
  }

  void removeItem(String itemId) {
    if (!_items.containsKey(itemId)) return;
    if (_items[itemId]!.qty > 1) {
      final existing = _items[itemId]!;
      _items[itemId] = OrderLineItem(
        itemId: existing.itemId,
        name: existing.name,
        unit: existing.unit,
        price: existing.price,
        qty: existing.qty - 1,
      );
    } else {
      _items.remove(itemId);
    }
    if (_items.isEmpty) {
      _shopId = null;
      _shopName = null;
    }
    notifyListeners();
  }

  int getItemQty(String itemId) {
    return _items[itemId]?.qty ?? 0;
  }

  void clearCart() {
    _items.clear();
    _shopId = null;
    _shopName = null;
    notifyListeners();
  }
}
