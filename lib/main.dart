import "dart:io";

import "package:cloud_firestore/cloud_firestore.dart";
import 'package:flutter/material.dart';
import "package:firebase_core/firebase_core.dart";
import "features/onboarding/screens/get_started_screen.dart";
import "features/auth/screens/login_screen.dart";
import "features/auth/screens/register_screen.dart";
import "features/profile/screens/profile_screen.dart";
import 'package:provider/provider.dart';
import 'common/providers/user_id_provider.dart';

const bool USE_EMULATOR = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (USE_EMULATOR) {
    await _connectToEmulator();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserIdProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> _connectToEmulator() async {
  final localhost = Platform.isAndroid ? '10.0.2.2' : 'localhost';

  FirebaseFirestore.instance.settings = Settings(
    host: '$localhost:8080',
    sslEnabled: false,
    persistenceEnabled: false,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Runmate",
      routes: {
        '/': (context) => const GetStartedScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const ProfileScreen(), // ProfileScreen sẽ nhận arguments
      },
      initialRoute: '/',
    );
  }
}
