class Category {
  final String id;
  final String nameEn;
  final String nameUr;
  final String icon;
  final bool isService;

  Category({
    required this.id,
    required this.nameEn,
    required this.nameUr,
    required this.icon,
    this.isService = false,
  });

  static List<Category> get initialCategories => [
        Category(id: 'karyana', nameEn: 'Karyana / Grocery', nameUr: 'کریانہ / جنرل اسٹور', icon: 'cart'),
        Category(id: 'sabzi', nameEn: 'Fresh Sabzi', nameUr: 'تازہ سبزی', icon: 'leaf'),
        Category(id: 'fruit', nameEn: 'Fresh Fruit', nameUr: 'تازہ پھل', icon: 'apple'),
        Category(id: 'dairy', nameEn: 'Milk & Dairy', nameUr: 'دودھ اور دہی', icon: 'milk'),
        Category(id: 'fastfood', nameEn: 'Fast Food', nameUr: 'فاسٹ فوڈ', icon: 'burger'),
        Category(id: 'mobile', nameEn: 'Mobile Accessories', nameUr: 'موبائل ایکسیسریز', icon: 'mobile'),
        Category(id: 'gas', nameEn: 'LPG Gas Cylinder', nameUr: 'گیس سلنڈر', icon: 'fuel'),
        Category(id: 'salon', nameEn: 'Hair Salon', nameUr: 'ہیئر سیلون', icon: 'scissors', isService: true),
        Category(id: 'electrician', nameEn: 'Electrician', nameUr: 'الیکٹریشن', icon: 'bulb', isService: true),
        Category(id: 'bike_mechanic', nameEn: 'Bike Mechanic', nameUr: 'موٹر سائیکل مکینک', icon: 'bike', isService: true),
        Category(id: 'car_mechanic', nameEn: 'Car Mechanic', nameUr: 'کار مکینک', icon: 'car', isService: true),
        Category(id: 'realestate', nameEn: 'Real Estate Agency', nameUr: 'پراپرٹی ڈیلر', icon: 'home', isService: true),
      ];
}
