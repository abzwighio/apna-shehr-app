import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_translations.dart';
import '../../providers/app_state.dart';
import 'mosque_detail_screen.dart';

class MosquesScreen extends StatelessWidget {
  const MosquesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final mosques = state.mosques;
    final isUrdu = state.lang == 'ur';

    return Scaffold(
      appBar: AppBar(
        title: Text(AppTranslations.text('mosques', state.lang)),
      ),
      body: mosques.isEmpty
          ? Center(
              child: Text(
                isUrdu ? 'اس علاقے میں مساجد کا ڈیٹا جلد شامل کیا جائے گا' : 'No mosques found for this area yet.',
                style: const TextStyle(color: AppColors.textMuted),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mosques.length,
              itemBuilder: (context, index) {
                final m = mosques[index];
                final nextPrayer = m.getNextPrayer();

                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MosqueDetailScreen(mosque: m),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.mosque, color: AppColors.primary, size: 28),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      m.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      m.address,
                                      style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          // Next Prayer Card
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.access_time_filled, color: AppColors.primary, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  '${AppTranslations.text('next_prayer', state.lang)}: ',
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  '${isUrdu ? nextPrayer['nameUr'] : nextPrayer['name']} (${nextPrayer['time']})',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                                const Spacer(),
                                const Icon(Icons.chevron_right, color: AppColors.primary),
                              ],
                            ),
                          ),
                          if (m.hasMadrasa) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.menu_book, color: AppColors.goldDark, size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  m.madrasaName ?? (isUrdu ? 'ملحقہ دینی مدرسہ' : 'Affiliated Madrasa'),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.goldDark,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
