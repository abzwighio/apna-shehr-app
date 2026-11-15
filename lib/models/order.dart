class OrderLineItem {
  final String itemId;
  final String name;
  final String unit;
  final double price;
  final int qty;

  OrderLineItem({
    required this.itemId,
    required this.name,
    required this.unit,
    required this.price,
    required this.qty,
  });

  double get subtotal => price * qty;

  Map<String, dynamic> toMap() => {
        'item_id': itemId,
        'name': name,
        'unit': unit,
        'price': price,
        'qty': qty,
      };

  factory OrderLineItem.fromMap(Map<String, dynamic> map) => OrderLineItem(
        itemId: map['item_id']?.toString() ?? '',
        name: map['name'] ?? '',
        unit: map['unit'] ?? '',
        price: (map['price'] ?? 0).toDouble(),
        qty: (map['qty'] ?? 1).toInt(),
      );
}

class AppOrder {
  final String id;
  final String shopId;
  final String shopName;
  final String customerName;
  final String customerPhone;
  final String deliveryAddress;
  final String? notes;
  final double totalPkr;
  final String status; // 'placed', 'accepted', 'preparing', 'on_way', 'delivered', 'cancelled'
  final DateTime createdAt;
  final List<OrderLineItem> items;

  AppOrder({
    required this.id,
    required this.shopId,
    required this.shopName,
    required this.customerName,
    required this.customerPhone,
    required this.deliveryAddress,
    this.notes,
    required this.totalPkr,
    this.status = 'placed',
    required this.createdAt,
    required this.items,
  });

  factory AppOrder.fromMap(Map<String, dynamic> map) {
    var rawItems = map['items'];
    List<OrderLineItem> parsedItems = [];
    if (rawItems is List) {
      parsedItems = rawItems.map((i) => OrderLineItem.fromMap(Map<String, dynamic>.from(i))).toList();
    }

    return AppOrder(
      id: map['id']?.toString() ?? '',
      shopId: map['shop_id']?.toString() ?? '',
      shopName: map['shop_name'] ?? 'Shop',
      customerName: map['customer_name'] ?? '',
      customerPhone: map['customer_phone'] ?? '',
      deliveryAddress: map['delivery_address'] ?? '',
      notes: map['notes'],
      totalPkr: (map['total_pkr'] ?? 0).toDouble(),
      status: map['status'] ?? 'placed',
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : DateTime.now(),
      items: parsedItems,
    );
  }
}
