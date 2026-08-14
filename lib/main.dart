import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/app_constants.dart';
import 'config/app_theme.dart';
import 'config/routes.dart';
import 'core/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Gracefully initialize Firebase core if options are provided or fallback to mock mode
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization deferred to fallback mode: $e');
  }

  runApp(const ProviderScope(child: VisionUxApp()));
}

class VisionUxApp extends ConsumerWidget {
  const VisionUxApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
