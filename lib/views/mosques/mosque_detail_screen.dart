import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_translations.dart';
import '../../providers/app_state.dart';
import '../../models/mosque.dart';

class MosqueDetailScreen extends StatelessWidget {
  final Mosque mosque;

  const MosqueDetailScreen({Key? key, required this.mosque}) : super(key: key);

  void _callImam(String? phone) async {
    if (phone == null || phone.isEmpty) return;
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _openWhatsApp(String? phone) async {
    if (phone == null || phone.isEmpty) return;
    var cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanPhone.startsWith('0')) {
      cleanPhone = '92${cleanPhone.substring(1)}';
    }
    final uri = Uri.parse('https://wa.me/$cleanPhone?text=Assalam-o-Alaikum!%20Apna%20Shehr%20Online%20se%20rabta%20kiya%20hai.');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _buildPrayerRow(String nameUr, String nameEn, String time, bool isNext, String lang) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isNext ? AppColors.primaryLight : Colors.transparent,
        border: const Border(bottom: BorderSide(color: AppColors.border, width: 0.8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (isNext)
                const Icon(Icons.star, color: AppColors.primary, size: 18)
              else
                const SizedBox(width: 18),
              const SizedBox(width: 8),
              Text(
                lang == 'ur' ? nameUr : nameEn,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isNext ? FontWeight.bold : FontWeight.w500,
                  color: isNext ? AppColors.primaryDark : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isNext ? FontWeight.bold : FontWeight.bold,
              color: isNext ? AppColors.primaryDark : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final isUrdu = state.lang == 'ur';
    final nextPrayer = mosque.getNextPrayer();

    return Scaffold(
      appBar: AppBar(
        title: Text(mosque.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.mosque, color: AppColors.primary, size: 36),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mosque.name,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              mosque.address,
                              style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (mosque.imamName != null) ...[
                    const Divider(height: 24),
                    Row(
                      children: [
                        const Icon(Icons.person_outline, color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          '${isUrdu ? "امام صاحب" : "Imam"}: ${mosque.imamName}',
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.call, color: AppColors.primary, size: 16),
                            label: Text(AppTranslations.text('call', state.lang)),
                            onPressed: () => _callImam(mosque.imamPhone),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.chat_bubble_outline, size: 16),
                            label: Text(AppTranslations.text('whatsapp', state.lang)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF25D366),
                            ),
                            onPressed: () => _openWhatsApp(mosque.imamPhone),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Namaz Timetable Card
            Text(
              isUrdu ? 'اوقاتِ نماز (لائیو ٹائم ٹیبل)' : 'Daily Prayer Timings',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildPrayerRow('فجر', 'Fajr', mosque.fajr, nextPrayer['name'] == 'Fajr', state.lang),
                  _buildPrayerRow('ظہر', 'Zuhr', mosque.zuhr, nextPrayer['name'] == 'Zuhr', state.lang),
                  _buildPrayerRow('عصر', 'Asr', mosque.asr, nextPrayer['name'] == 'Asr', state.lang),
                  _buildPrayerRow('مغرب', 'Maghrib', mosque.maghrib, nextPrayer['name'] == 'Maghrib', state.lang),
                  _buildPrayerRow('عشاء', 'Isha', mosque.isha, nextPrayer['name'] == 'Isha', state.lang),
                  _buildPrayerRow('جمعہ المبارک', 'Jumuah', mosque.jumuah, false, state.lang),
                ],
              ),
            ),

            // Madrasa section if applicable
            if (mosque.hasMadrasa) ...[
              const SizedBox(height: 20),
              Text(
                isUrdu ? 'ملحقہ دینی مدرسہ / جامعہ' : 'Madrasa Information',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mosque.madrasaName ?? (isUrdu ? 'جامعہ تعلیم القرآن' : 'Islamic Madrasa'),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                    ),
                    const SizedBox(height: 6),
                    if (mosque.madrasaTiming != null)
                      Text(
                        '${isUrdu ? "اوقات" : "Timings"}: ${mosque.madrasaTiming}',
                        style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                      ),
                    if (mosque.madrasaInfo != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        mosque.madrasaInfo!,
                        style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                      ),
                    ],
                  ],
                ),
              ),
            ],

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
