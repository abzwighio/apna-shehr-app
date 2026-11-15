import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/app_state.dart';
import 'providers/cart_provider.dart';
import 'views/shell/main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appState = AppState();
  await appState.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: appState),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const ApnaShehrApp(),
    ),
  );
}

class ApnaShehrApp extends StatelessWidget {
  const ApnaShehrApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return MaterialApp(
      title: 'Apna Shehr Online',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(state.lang),
      home: const MainShell(),
    );
  }
}
