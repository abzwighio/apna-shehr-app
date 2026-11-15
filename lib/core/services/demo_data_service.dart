import '../../models/city_area.dart';
import '../../models/shop.dart';
import '../../models/mosque.dart';
import '../../models/post.dart';

class DemoDataService {
  static List<City> get cities => [
        City(id: 'hyderabad', name: 'Hyderabad', nameUr: 'حیدرآباد'),
        City(id: 'karachi', name: 'Karachi', nameUr: 'کراچی'),
        City(id: 'nawabshah', name: 'Nawabshah', nameUr: 'نواب شاہ'),
        City(id: 'halani', name: 'Halani', nameUr: 'ہلانی'),
        City(id: 'kandiaro', name: 'Kandiaro', nameUr: 'کنڈیارو'),
        City(id: 'lakha-road', name: 'Lakha Road', nameUr: 'لاکھا روڈ'),
      ];

  static List<Area> get areas => [
        Area(id: 'latifabad', cityId: 'hyderabad', name: 'Latifabad', nameUr: 'لطیف آباد'),
        Area(id: 'qasimabad', cityId: 'hyderabad', name: 'Qasimabad', nameUr: 'قاسم آباد'),
        Area(id: 'saddar', cityId: 'hyderabad', name: 'Saddar', nameUr: 'صدر'),
        Area(id: 'clifton', cityId: 'karachi', name: 'Clifton', nameUr: 'کلفٹن'),
        Area(id: 'gulshan', cityId: 'karachi', name: 'Gulshan-e-Iqbal', nameUr: 'گلشن اقبال'),
        Area(id: 'main-bazaar', cityId: 'nawabshah', name: 'Main Bazaar', nameUr: 'مین بازار'),
        Area(id: 'station-road', cityId: 'lakha-road', name: 'Station Road', nameUr: 'اسٹیشن روڈ'),
      ];

  static List<Shop> get initialShops => [
        Shop(
          id: 'shop-1',
          name: 'Al-Madina Karyana & General Store',
          categoryId: 'karyana',
          cityId: 'hyderabad',
          areaId: 'latifabad',
          address: 'Shop # 4, Unit 7, Latifabad, Hyderabad',
          phone: '03001234567',
          deliveryAvailable: true,
          bookingAvailable: false,
          avgRating: 4.8,
          reviewCount: 32,
          isFeatured: true,
          items: [
            ShopItem(id: 'i1', shopId: 'shop-1', name: 'Basmati Rice (Super Kernel)', unit: 'kg', price: 320, discountPct: 5),
            ShopItem(id: 'i2', shopId: 'shop-1', name: 'Dal Chana (Special)', unit: 'kg', price: 260),
            ShopItem(id: 'i3', shopId: 'shop-1', name: 'Chakki Atta (Fresh)', unit: '10kg', price: 1350, discountPct: 8),
            ShopItem(id: 'i4', shopId: 'shop-1', name: 'Cooking Oil (1 Litre Pouch)', unit: 'litre', price: 510),
          ],
        ),
        Shop(
          id: 'shop-2',
          name: 'Subhan Allah Fresh Sabzi & Fruit Shop',
          categoryId: 'sabzi',
          cityId: 'hyderabad',
          areaId: 'latifabad',
          address: 'Main Market, Latifabad No. 8',
          phone: '03129876543',
          deliveryAvailable: true,
          bookingAvailable: false,
          avgRating: 4.6,
          reviewCount: 19,
          items: [
            ShopItem(id: 'i5', shopId: 'shop-2', name: 'Aloo (Fresh Potato)', unit: 'kg', price: 80),
            ShopItem(id: 'i6', shopId: 'shop-2', name: 'Piyaz (Red Onion)', unit: 'kg', price: 120, discountPct: 10),
            ShopItem(id: 'i7', shopId: 'shop-2', name: 'Tamatar (Fresh Red Tomatoes)', unit: 'kg', price: 90),
          ],
        ),
        Shop(
          id: 'shop-3',
          name: 'Ustad Aslam Bike Auto Workshop',
          categoryId: 'bike_mechanic',
          cityId: 'hyderabad',
          areaId: 'latifabad',
          address: 'Near Bilal Masjid, Unit 6',
          phone: '03337654321',
          deliveryAvailable: false,
          bookingAvailable: true,
          avgRating: 4.9,
          reviewCount: 45,
          items: [
            ShopItem(id: 'i8', shopId: 'shop-3', name: 'Full Engine Tuning & Service', unit: 'bike', price: 500),
            ShopItem(id: 'i9', shopId: 'shop-3', name: 'Engine Oil Change', unit: 'bike', price: 150),
            ShopItem(id: 'i10', shopId: 'shop-3', name: 'Wheel Air Pressure Check', unit: 'check', price: 0),
          ],
        ),
        Shop(
          id: 'shop-4',
          name: 'Sindh LPG Gas & Accessories',
          categoryId: 'gas',
          cityId: 'hyderabad',
          areaId: 'latifabad',
          address: 'Auto Bhan Road, Latifabad',
          phone: '03451122334',
          deliveryAvailable: true,
          bookingAvailable: false,
          avgRating: 4.7,
          reviewCount: 12,
          isFeatured: true,
          items: [
            ShopItem(id: 'i11', shopId: 'shop-4', name: 'Domestic Gas Cylinder (11.8 kg)', unit: 'cylinder', price: 3400, discountPct: 6),
            ShopItem(id: 'i12', shopId: 'shop-4', name: 'Commercial Gas Cylinder (45.4 kg)', unit: 'cylinder', price: 12800),
            ShopItem(id: 'i13', shopId: 'shop-4', name: 'Gas Regulator + Safety Pipe', unit: 'set', price: 850),
          ],
        ),
      ];

  static List<Mosque> get initialMosques => [
        Mosque(
          id: 'm-1',
          name: 'Jamia Masjid Bilal (جامع مسجد بلال)',
          cityId: 'hyderabad',
          areaId: 'latifabad',
          address: 'Unit # 6, Latifabad, Hyderabad',
          imamName: 'Maulana Hafiz Abdul Rehman',
          imamPhone: '03011234567',
          fajr: '05:30',
          zuhr: '01:30',
          asr: '04:45',
          maghrib: '06:05',
          isha: '08:00',
          jumuah: '01:45',
          hasMadrasa: true,
          madrasaName: 'Madrasa Taleem-ul-Quran',
          madrasaTiming: '03:00 PM – 06:30 PM',
          madrasaContact: '03011234567',
          madrasaInfo: 'Hifz-e-Quran, Nazra with Tajweed, and Dars-e-Nizami (Primary)',
        ),
        Mosque(
          id: 'm-2',
          name: 'Markazi Jamia Masjid (مرکزی جامع مسجد)',
          cityId: 'hyderabad',
          areaId: 'latifabad',
          address: 'Block D, Unit # 7, Latifabad',
          imamName: 'Mufti Muhammad Salman',
          imamPhone: '03159988776',
          fajr: '05:35',
          zuhr: '01:30',
          asr: '04:50',
          maghrib: '06:05',
          isha: '08:15',
          jumuah: '02:00',
        ),
      ];

  static List<Post> get initialPosts => [
        Post(
          id: 'p-1',
          authorName: 'Apna Shehr Team',
          authorType: 'admin',
          text: 'Khush Amdeed! Apna Shehr Online mobile app par aap apne shehr ki dukanon se live rates check kar sakte hain, direct order kar sakte hain aur masajid ke Namaz timings dekh sakte hain.',
          createdAt: DateTime.now().subtract(const Duration(hours: 3)),
          likesCount: 24,
          commentsCount: 5,
        ),
        Post(
          id: 'p-2',
          authorName: 'Al-Madina Karyana Store',
          authorType: 'shop',
          shopName: 'Al-Madina Karyana & General Store',
          text: 'Tamam ahl-e-shehr ke liye khushkhabri! Taza Basmati Chawal aur Chakki Atta par 8% tak ki discount offer shuru ho chuki hai. Ghar bethe delivery hasil karein.',
          createdAt: DateTime.now().subtract(const Duration(hours: 7)),
          likesCount: 15,
          commentsCount: 2,
        ),
      ];
}
