import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/app_state.dart';
import '../../../models/category.dart';

class CategoriesGrid extends StatelessWidget {
  const CategoriesGrid({Key? key}) : super(key: key);

  IconData _getCategoryIcon(String icon) {
    switch (icon) {
      case 'cart':
        return Icons.shopping_cart_outlined;
      case 'leaf':
        return Icons.eco_outlined;
      case 'apple':
        return Icons.apple_outlined;
      case 'milk':
        return Icons.water_drop_outlined;
      case 'burger':
        return Icons.fastfood_outlined;
      case 'mobile':
        return Icons.phone_android_outlined;
      case 'fuel':
        return Icons.local_gas_station_outlined;
      case 'scissors':
        return Icons.content_cut_outlined;
      case 'bulb':
        return Icons.lightbulb_outline;
      case 'bike':
        return Icons.two_wheeler_outlined;
      case 'car':
        return Icons.directions_car_outlined;
      case 'home':
        return Icons.home_work_outlined;
      default:
        return Icons.store_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final categories = state.categories.take(8).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 0.82,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = state.selectedCategoryId == cat.id;

          return InkWell(
            onTap: () => state.selectCategory(cat.id),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryLight : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: isSelected ? 1.5 : 1.0,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.12)
                          : AppColors.canvas,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getCategoryIcon(cat.icon),
                      color: isSelected ? AppColors.primary : AppColors.primaryDark,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      state.lang == 'ur' ? cat.nameUr : cat.nameEn,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
                      ),
                    ),
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
