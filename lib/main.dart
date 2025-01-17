import "dart:io";
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:flutter/material.dart';
import "package:firebase_core/firebase_core.dart";
import "package:provider/provider.dart";
import "package:runmate/features/challenge/screens/challenge_screen.dart";
import "package:runmate/firebase_options.dart";
import "package:runmate/initialize_data.dart";
import "common/providers/user_id_provider.dart";
import "features/challenge/screens/detail_challenge_owner_screen.dart";
import "features/let_run/screens/run_screen.dart";
import "features/onboarding/screens/get_started_screen.dart";
import "features/auth/screens/login_screen.dart";
import "features/auth/screens/register_screen.dart";
import "features/profile/screens/profile_screen.dart";
import "features/test_screen.dart";
import 'common/widgets/custom_bottom_navbar.dart';
import "package:firebase_app_check/firebase_app_check.dart";

const bool USE_EMULATOR = false;
const bool INITIALIZE_FIREBASE = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (USE_EMULATOR) {
    await _connectToEmulator();
  }

  if (INITIALIZE_FIREBASE) {
    InitializeFirebase.initialize();
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
        '/profile': (context) => const ProfileScreen(),
        '/let_run': (context) => const RunScreen(),
        '/test': (context) => const UserFormScreen(),
        '/challenge': (context) => const ChallengeScreen(),
        '/home': (context) =>
            const CustomBottomNavbar(), // ProfileScreen sẽ nhận arguments
      },
      initialRoute: '/',
    );
  }
}
