import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_translations.dart';
import '../../providers/app_state.dart';
import '../shops/shop_detail_screen.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({Key? key}) : super(key: key);

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final TextEditingController _codeController = TextEditingController();
  bool _isProcessing = false;

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing) return;
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final code = barcode.rawValue;
      if (code != null && code.isNotEmpty) {
        _isProcessing = true;
        _handleShopCode(code);
        break;
      }
    }
  }

  void _handleShopCode(String rawCode) {
    final state = context.read<AppState>();

    // Extract shop id from URL if scanned a full web link (e.g. apnashehronline.pages.dev/shop.html?id=shop-1)
    String cleanId = rawCode;
    if (rawCode.contains('id=')) {
      cleanId = Uri.parse(rawCode).queryParameters['id'] ?? rawCode;
    }

    final matched = state.shops.firstWhere(
      (s) => s.id == cleanId || s.name.toLowerCase() == cleanId.toLowerCase(),
      orElse: () => state.shops.isNotEmpty ? state.shops.first : state.shops.first,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ShopDetailScreen(shop: matched),
      ),
    ).then((_) {
      _isProcessing = false;
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final isUrdu = state.lang == 'ur';

    return Scaffold(
      appBar: AppBar(
        title: Text(AppTranslations.text('scan_qr', state.lang)),
      ),
      body: Column(
        children: [
          // Camera Viewport
          Expanded(
            flex: 3,
            child: Stack(
              alignment: Alignment.center,
              children: [
                MobileScanner(
                  onDetect: _onDetect,
                ),
                // Scanning Overlay Frame
                Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary, width: 3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                Positioned(
                  bottom: 24,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.65),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      AppTranslations.text('scan_instructions', state.lang),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Manual Code Entry Fallback
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppTranslations.text('manual_code_hint', state.lang),
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _codeController,
                          decoration: InputDecoration(
                            hintText: isUrdu ? 'دکان کا کوڈ درج کریں' : 'e.g. shop-1',
                            prefixIcon: const Icon(Icons.qr_code, color: AppColors.primary),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (_codeController.text.trim().isNotEmpty) {
                            _handleShopCode(_codeController.text.trim());
                          }
                        },
                        child: Text(AppTranslations.text('open_shop', state.lang)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
