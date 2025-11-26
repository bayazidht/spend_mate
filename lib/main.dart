// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:spend_mate/services/auth_service.dart';
import 'package:spend_mate/screens/wrapper.dart'; // Handles auth state
// (Assuming you have firebase_options.dart from FlutterFire CLI)
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SpendMateApp());
}

class SpendMateApp extends StatelessWidget {
  const SpendMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide the AuthService throughout the widget tree
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        // Add other providers like TransactionProvider, CategoryProvider here
      ],
      child: MaterialApp(
        title: 'Spend Mate',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          // Define a theme with purple/blue accents like in the screenshots
          brightness: Brightness.light,
        ),
        home: const Wrapper(), // Check auth state and show relevant screen
      ),
    );
  }
}