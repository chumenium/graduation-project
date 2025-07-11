import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'core/theme_notifier.dart';

import 'features/auth/pages/login_page.dart';
import 'features/home/pages/main_navigation.dart';

// ▼ マイページ内遷移先
import 'features/mypage/pages/preference_settings_screen.dart';
import 'features/mypage/pages/profile_settings_screen.dart';
import 'features/mypage/pages/notification_settings_screen.dart';
import 'features/mypage/pages/view_history_screen.dart';
import 'features/mypage/pages/solved_history_screen.dart';
import 'features/mypage/pages/consulted_history_screen.dart';
import 'features/mypage/pages/coupon_screen.dart';
import 'features/mypage/pages/payment_request_screen.dart';
import 'features/mypage/pages/terms_screen.dart';
import 'features/mypage/pages/privacy_policy_screen.dart';

import 'features/mypage/provider/user_profile_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'features/profile/pages/user_profile_screen.dart';

void testFirestore() async {
  final test = FirebaseFirestore.instance;
  final snapshot = await test.collection('debug_test').doc('hello').get();
  print(snapshot.exists ? 'Firestore OK' : 'Not Found');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '相談マッチングアプリ',
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: themeNotifier.themeMode,
      // home: const MainNavigation(),
      home: const AuthGate(), // ← 本番用はこちらに切り替え
      routes: {
        '/view_history': (context) => const ViewHistoryScreen(),
        '/solved_history': (context) => const SolvedHistoryScreen(),
        '/consulted_history': (context) => const ConsultedHistoryScreen(),
        '/coupon': (context) => const CouponScreen(),
        '/payment_request': (context) => const PaymentRequestScreen(),
        '/profile_settings': (context) => const ProfileSettingsScreen(),
        '/notification_settings': (context) =>
            const NotificationSettingsScreen(),
        '/preference_settings': (context) => const PreferenceSettingsScreen(),
        '/terms': (context) => const TermsScreen(),
        '/privacy_policy': (context) => const PrivacyPolicyScreen(),
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const MainNavigation();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
