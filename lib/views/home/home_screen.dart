import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_translations.dart';
import '../../providers/app_state.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/categories_grid.dart';
import 'widgets/cheap_slider.dart';
import 'widgets/nearby_shops.dart';
import 'widgets/registration_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void _showLocationPicker(BuildContext context) {
    final state = context.read<AppState>();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(AppTranslations.text('select_city', state.lang)),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: state.cities.length,
              itemBuilder: (c, idx) {
                final city = state.cities[idx];
                final isSelected = state.selectedCity?.id == city.id;
                return ListTile(
                  title: Text(state.lang == 'ur' ? city.nameUr : city.name),
                  trailing: isSelected ? const Icon(Icons.check, color: AppColors.primary) : null,
                  onTap: () {
                    state.selectCity(city);
                    Navigator.pop(ctx);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    if (state.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    final isUrdu = state.lang == 'ur';

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.white, size: 20),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () => _showLocationPicker(context),
              child: Row(
                children: [
                  Text(
                    state.selectedArea != null
                        ? '${isUrdu ? state.selectedArea!.nameUr : state.selectedArea!.name}, ${isUrdu ? state.selectedCity?.nameUr : state.selectedCity?.name}'
                        : (isUrdu ? 'علاقہ منتخب کریں' : 'Select Location'),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => state.toggleLanguage(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                AppTranslations.text('switch_lang', state.lang),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
        onPressed: () => RegistrationSheet.show(context),
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => state.loadDataForCurrentArea(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              const SearchBarWidget(),

              // Referral / Invite Banner
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F5429), Color(0xFF177A3D)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.card_giftcard, color: AppColors.gold, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isUrdu ? 'دوستوں کو لائیں، فری فیچرڈ حاصل کریں' : 'Invite friends, earn Featured days',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isUrdu
                                ? 'اپنی دکان کو شہر کی ٹاپ لسٹ میں لانے کے لیے دوستوں سے شیئر کریں'
                                : 'Get free 7 days top placement for your shop when friends join',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Categories Grid
              const CategoriesGrid(),

              // Saste Products Carousel
              const CheapSlider(),

              // Shops Near You Section Title
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppTranslations.text('shops_near_you', state.lang),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (state.selectedCategoryId != null)
                      TextButton(
                        onPressed: () => state.selectCategory(null),
                        child: Text(
                          isUrdu ? 'فلٹر ہٹائیں' : 'Clear Filter',
                          style: const TextStyle(color: AppColors.primary, fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ),

              // Nearby Shops List
              const NearbyShops(),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
