# Apna Shehr Online (اپنا شہر آن لائن) - Real Native Mobile App

Yeh **Apna Shehr Online** (`https://apnashehronline.pages.dev/`) ki 100% **Real Native Flutter Android App** hai. Yeh koi WebView ya web wrapper nahi hai, balke native Flutter components, hardware camera QR scanner, direct telephony deep-links, dynamic Namaz timing engine aur live Supabase database ke sath build ki gayi hai.

---

## 🌟 Features Summary

1. **Brand Identity & Theme:**
   - Official Pakistani Emerald Green (`#177a3d`) color scheme.
   - Dual Language Support: **English & Urdu (اردو)** with dynamic RTL typography.
   - 5-tab Bottom Navigation with central floating QR Scanner button.

2. **Hyperlocal Directory & 12 Categories:**
   - Karyana, Sabzi, Fruit, Dairy, Fast Food, Mobile, LPG Gas, Salon, Electrician, Bike Mechanic, Car Mechanic, Real Estate.
   - City & Area selection modal (Hyderabad, Karachi, Nawabshah, Lakha Road, Halani, Kandiaro).
   - "Saste Products" horizontal carousel showing cheapest verified items in the city.
   - Live Open/Closed indicator dots, delivery badges, and minimum rates.

3. **Shop Catalog & Ordering:**
   - Direct Phone Call (`tel:`) and WhatsApp chat deep-links.
   - For Retail/Goods: In-app Add-to-Cart with stepper (`+` / `-`), total PKR calculator, and one-tap WhatsApp order generation.
   - For Services: Booking & inquiry options.

4. **Mosques & Madrasas Directory:**
   - Live daily Namaz timetable (Fajr, Zuhr, Asr, Maghrib, Isha, Jumuah).
   - Dynamic **Next Prayer** engine that calculates the upcoming prayer relative to the local clock.
   - Madrasa academic records (Timing, Courses, Teachers, Students) and direct Imam contact.

5. **In-Store "Scan & Bill":**
   - Real hardware camera barcode/QR scanner (`mobile_scanner`).
   - Scans in-store shop QR codes instantly and opens that shop's catalog.
   - Manual shop code fallback input.

6. **Community Newsfeed & Orders:**
   - City updates and announcements with like counters (👍, ❤️) and comments.
   - Orders status pipeline (`Placed` -> `Accepted` -> `Preparing` -> `On The Way` -> `Delivered`).

7. **Database & Offline Resilience:**
   - Live Supabase synchronization (`rhplvbznkywuqzcrsuns.supabase.co`).
   - Seamless offline fallback (`demo_data_service.dart`) so the app never shows a blank screen even without internet.

---

## 📁 Project Structure

```
apna_shehr_app/
├── android/
│   └── app/src/main/AndroidManifest.xml   # Camera, Internet, Phone permissions
├── pubspec.yaml                           # Flutter packages & dependencies
├── lib/
│   ├── main.dart                          # App Entrypoint
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart            # Brand Green & Accent Colors
│   │   │   └── supabase_config.dart       # Live Supabase API Keys
│   │   ├── theme/
│   │   │   └── app_theme.dart             # Material 3 & Urdu/English Fonts
│   │   ├── localization/
│   │   │   └── app_translations.dart      # EN / UR Translation Strings
│   │   └── services/
│   │       ├── supabase_service.dart      # Live Supabase Database API
│   │       └── demo_data_service.dart     # Offline Demo Cache
│   ├── models/
│   │   ├── city_area.dart                 # Cities & Areas
│   │   ├── category.dart                  # 12 Hyperlocal Categories
│   │   ├── shop.dart                      # Shop & Catalog Items
│   │   ├── mosque.dart                    # Mosque & Prayer Times
│   │   ├── order.dart                     # Order & Line Items
│   │   └── post.dart                      # Community Feed Posts
│   ├── providers/
│   │   ├── app_state.dart                 # City/Area/Category/Search State
│   │   └── cart_provider.dart             # Shopping Cart State
│   └── views/
│       ├── shell/main_shell.dart          # 5-Tab Shell + Center QR FAB
│       ├── home/
│       │   ├── home_screen.dart           # Main Home View
│       │   └── widgets/                   # Search, Categories, Cheap Slider, Shops
│       ├── shops/shop_detail_screen.dart  # Shop Details & Cart
│       ├── mosques/
│       │   ├── mosques_screen.dart        # Mosques Directory
│       │   └── mosque_detail_screen.dart  # Namaz Timetable & Madrasa
│       ├── scan/qr_scanner_screen.dart    # Live Camera QR Scanner
│       ├── feed/feed_screen.dart          # Community Feed
│       ├── orders/orders_screen.dart      # Orders Tracker
│       └── account/account_screen.dart    # Profile & Referrals
```

---

## 🛠️ How to Run & Build APK (Roman Urdu Guide)

### 1. Requirements:
- Computer par **Flutter SDK** aur **Android Studio** (ya VS Code) hona chahiye.
- Agar install nahi hai to:
  1. [flutter.dev](https://docs.flutter.dev/get-started/install/windows/mobile) se Flutter download karein.
  2. Android Studio install karke Android SDK aur Command-line tools tick karein.

### 2. Dependencies Install Karein:
Terminal ya Command Prompt mein is folder ke andar yeh command chalayein:
```bash
flutter pub get
```

### 3. Mobile Par Run / Test Karein:
Apna Android mobile USB ke zariye connect karein (USB Debugging ON karein) ya Android Studio ka Emulator start karein, phir run karein:
```bash
flutter run
```

### 4. Real APK File Banana (Build APK):
Jab aap chahein ke doston ko ya customers ko dene ke liye direct installable APK file ban jaye, to yeh command chalayein:
```bash
flutter build apk --release
```
Yeh command mukammal hote hi aapko aapki real APK is path par mil jayegi:
`build/app/outputs/flutter-apk/app-release.apk`
Is APK ko aap kisi bhi Android phone par install kar sakte hain!
