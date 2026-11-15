import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/app_state.dart';

class RegistrationSheet extends StatelessWidget {
  const RegistrationSheet({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const RegistrationSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final isUrdu = state.lang == 'ur';

    final types = [
      {'id': 'shop', 'titleEn': 'Shop / General Store', 'titleUr': 'دکان / کریانہ اسٹور', 'subEn': 'Sell grocery, food or retail items', 'subUr': 'سامان فروخت اور آرڈر لیں', 'icon': Icons.shopping_bag_outlined},
      {'id': 'bike', 'titleEn': 'Bike Mechanic Workshop', 'titleUr': 'موٹر سائیکل مکینک ورکشاپ', 'subEn': 'Tuning, oil change & maintenance', 'subUr': 'ٹیوننگ اور مرمت کی سروسز', 'icon': Icons.two_wheeler_outlined},
      {'id': 'car', 'titleEn': 'Car Mechanic / Auto Workshop', 'titleUr': 'کار مکینک / آٹو ورکشاپ', 'subEn': 'Car tuning, oil, denting/painting', 'subUr': 'گاڑیوں کی مکمل سروسز', 'icon': Icons.directions_car_outlined},
      {'id': 'gas', 'titleEn': 'LPG Gas Cylinder Shop', 'titleUr': 'ایل پی جی گیس سلنڈر', 'subEn': 'Cylinder delivery & accessories', 'subUr': 'سلنڈر اور ریگولیٹر وغیرہ', 'icon': Icons.local_gas_station_outlined},
      {'id': 'realestate', 'titleEn': 'Real Estate Agency', 'titleUr': 'پراپرٹی ڈیلر / ایجنسی', 'subEn': 'Plots, houses for buy/rent', 'subUr': 'پلاٹ اور مکانات خرید و فروخت', 'icon': Icons.home_work_outlined},
      {'id': 'mosque', 'titleEn': 'Jamia Masjid', 'titleUr': 'جامع مسجد', 'subEn': 'Publish daily live Namaz timings', 'subUr': 'نماز کے اوقات لائیو اپڈیٹ کریں', 'icon': Icons.mosque_outlined},
      {'id': 'madrasa', 'titleEn': 'Madrasa / Islamic School', 'titleUr': 'جامعہ / دینی مدرسہ', 'subEn': 'Hifz, Nazra, academic courses', 'subUr': 'حفظ، ناظرہ اور درجات کی معلومات', 'icon': Icons.menu_book_outlined},
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isUrdu ? 'نیا کاروبار یا ادارہ رجسٹر کریں' : 'Register New Business or Institution',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textMuted),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: types.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = types[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 4),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(item['icon'] as IconData, color: AppColors.primary),
                  ),
                  title: Text(
                    isUrdu ? item['titleUr'] as String : item['titleEn'] as String,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  subtitle: Text(
                    isUrdu ? item['subUr'] as String : item['subEn'] as String,
                    style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isUrdu
                              ? '${item['titleUr']} رجسٹریشن فارم جلد دستیاب ہوگا'
                              : 'Registration for ${item['titleEn']} opening soon',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
