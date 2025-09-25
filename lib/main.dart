import 'package:ecommerce/pages/home_page.dart';
import 'package:ecommerce/pages/private/profile_page.dart';
import 'package:ecommerce/pages/public/login_page.dart';
import 'package:ecommerce/pages/public/onboarding_screen.dart';
import 'package:ecommerce/pages/public/register_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ecommerce/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/models/cart_model.dart';
import 'package:device_preview_plus/device_preview_plus.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    DevicePreview(
      enabled: true,
      tools: const [...DevicePreview.defaultTools],
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => OnboardingScreen(),
          '/home': (_) => const HomePage(),
          '/login': (_) => const LoginPage(),
          '/register': (_) => const RegisterPage(),
          '/private/profile': (_) => const ProfilePage(),
        },
      ),
    );
  }
}
