import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_translations.dart';
import '../../providers/app_state.dart';
import '../home/widgets/registration_sheet.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  void _openSupportWhatsApp() async {
    const phone = '923001234567';
    final uri = Uri.parse('https://wa.me/$phone?text=Salam!%20Apna%20Shehr%20Online%20support%20chahiye.');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final isUrdu = state.lang == 'ur';

    return Scaffold(
      appBar: AppBar(
        title: Text(AppTranslations.text('account', state.lang)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User Profile Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primaryLight,
                    child: const Icon(Icons.person, size: 36, color: AppColors.primary),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isUrdu ? 'مہمان صارف' : 'Guest Customer',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          state.selectedCity != null
                              ? '${isUrdu ? state.selectedArea?.nameUr : state.selectedArea?.name}, ${isUrdu ? state.selectedCity?.nameUr : state.selectedCity?.name}'
                              : 'Pakistan',
                          style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(isUrdu ? 'لاگ ان جلد فعال ہو جائے گا' : 'Login flow opening')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                    ),
                    child: Text(isUrdu ? 'لاگ ان' : 'Login'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Refer & Earn Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F5429), Color(0xFF177A3D)],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.card_giftcard, color: AppColors.gold, size: 28),
                      const SizedBox(width: 10),
                      Text(
                        isUrdu ? 'دوستوں کو انوائٹ کریں اور کمائیں' : 'Refer Friends & Earn',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isUrdu
                        ? 'اپنے ریفرل لنک کے ذریعے دوستوں کو جوڑیں اور دکان کے لیے فری فیچرڈ ڈیز حاصل کریں۔'
                        : 'Invite friends with your referral link and earn Featured Days for your business.',
                    style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: AppColors.textPrimary,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(isUrdu ? 'ریفرل لنک کاپی ہو گیا!' : 'Referral link copied!')),
                      );
                    },
                    child: Text(
                      isUrdu ? 'ریفرل لنک شیئر کریں' : 'Share Invite Link',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Menu Items Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.language, color: AppColors.primary),
                    title: Text(isUrdu ? 'زبان تبدیل کریں' : 'Switch Language'),
                    subtitle: Text(isUrdu ? 'اردو (فعال)' : 'English (Active)'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => state.toggleLanguage(),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.add_business_outlined, color: AppColors.primary),
                    title: Text(isUrdu ? 'کاروبار یا مسجد رجسٹر کریں' : 'Register Shop / Mosque'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => RegistrationSheet.show(context),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.headset_mic_outlined, color: AppColors.primary),
                    title: Text(isUrdu ? 'رابطہ اور ہیلپ لائن (WhatsApp)' : 'Customer Support (WhatsApp)'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _openSupportWhatsApp,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
