class ShopItem {
  final String id;
  final String shopId;
  final String name;
  final String unit;
  final double price;
  final double discountPct;
  final String? imageUrl;
  final int? stockQty;
  final bool isAvailable;

  ShopItem({
    required this.id,
    required this.shopId,
    required this.name,
    required this.unit,
    required this.price,
    this.discountPct = 0.0,
    this.imageUrl,
    this.stockQty,
    this.isAvailable = true,
  });

  double get effectivePrice {
    if (discountPct <= 0) return price;
    return price * (100 - discountPct) / 100;
  }

  factory ShopItem.fromMap(Map<String, dynamic> map, [String? fallbackShopId]) {
    return ShopItem(
      id: map['id']?.toString() ?? '',
      shopId: map['shop_id']?.toString() ?? fallbackShopId ?? '',
      name: map['name'] ?? '',
      unit: map['unit'] ?? '',
      price: (map['price_pkr'] ?? map['price'] ?? 0).toDouble(),
      discountPct: (map['discount_pct'] ?? map['discountPct'] ?? 0).toDouble(),
      imageUrl: map['image_url'] ?? map['imageUrl'],
      stockQty: map['stock_qty'] ?? map['stockQty'],
      isAvailable: map['is_available'] ?? true,
    );
  }
}

class Shop {
  final String id;
  final String name;
  final String categoryId;
  final String cityId;
  final String areaId;
  final String address;
  final String phone;
  final String? imageUrl;
  final bool deliveryAvailable;
  final bool bookingAvailable;
  final String? openingTime;
  final String? closingTime;
  final bool? openOverride;
  final double avgRating;
  final int reviewCount;
  final bool isFeatured;
  final List<ShopItem> items;

  Shop({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.cityId,
    required this.areaId,
    required this.address,
    required this.phone,
    this.imageUrl,
    this.deliveryAvailable = false,
    this.bookingAvailable = false,
    this.openingTime,
    this.closingTime,
    this.openOverride,
    this.avgRating = 0.0,
    this.reviewCount = 0,
    this.isFeatured = false,
    this.items = const [],
  });

  bool get isOpen {
    if (openOverride != null) return openOverride!;
    // Default open if no schedule defined
    return true;
  }

  factory Shop.fromMap(Map<String, dynamic> map, [List<ShopItem> shopItems = const []]) {
    final featuredUntil = map['featured_until'];
    bool featured = false;
    if (featuredUntil != null) {
      final dt = DateTime.tryParse(featuredUntil.toString());
      if (dt != null && dt.isAfter(DateTime.now())) {
        featured = true;
      }
    }

    return Shop(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? '',
      categoryId: map['category'] ?? map['categoryId'] ?? '',
      cityId: map['city_id'] ?? map['cityId'] ?? '',
      areaId: map['area_id'] ?? map['areaId'] ?? '',
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
      imageUrl: map['image_url'] ?? map['image'],
      deliveryAvailable: map['delivery_available'] ?? map['deliveryAvailable'] ?? false,
      bookingAvailable: map['booking_available'] ?? map['bookingAvailable'] ?? false,
      openingTime: map['opening_time'] ?? map['openingTime'],
      closingTime: map['closing_time'] ?? map['closingTime'],
      openOverride: map['open_override'],
      avgRating: (map['avg_rating'] ?? 0).toDouble(),
      reviewCount: map['review_count'] ?? 0,
      isFeatured: featured,
      items: shopItems,
    );
  }
}
