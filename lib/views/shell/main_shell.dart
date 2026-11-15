import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_translations.dart';
import '../../providers/app_state.dart';
import '../home/home_screen.dart';
import '../feed/feed_screen.dart';
import '../scan/qr_scanner_screen.dart';
import '../mosques/mosques_screen.dart';
import '../account/account_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({Key? key}) : super(key: key);

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    FeedScreen(),
    QrScannerScreen(),
    MosquesScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.white,
        elevation: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Home
              _buildNavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: AppTranslations.text('home', state.lang),
                index: 0,
              ),
              // Feed
              _buildNavItem(
                icon: Icons.dynamic_feed_outlined,
                activeIcon: Icons.dynamic_feed,
                label: AppTranslations.text('feed', state.lang),
                index: 1,
              ),
              // Center Spacer for Notch / Floating QR
              const SizedBox(width: 48),
              // Mosques
              _buildNavItem(
                icon: Icons.mosque_outlined,
                activeIcon: Icons.mosque,
                label: AppTranslations.text('mosques', state.lang),
                index: 3,
              ),
              // Account
              _buildNavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: AppTranslations.text('account', state.lang),
                index: 4,
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 4,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 28),
        onPressed: () {
          setState(() {
            _currentIndex = 2; // Jump to QR Scanner
          });
        },
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.primary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
