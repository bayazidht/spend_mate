import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:spend_mate/providers/category_provider.dart';
import 'package:spend_mate/providers/settings_provider.dart';
import 'package:spend_mate/providers/theme_provider.dart';
import 'package:spend_mate/services/auth_service.dart';
import 'package:spend_mate/providers/transaction_provider.dart'; // নতুন import
import 'package:spend_mate/screens/wrapper.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const SpendMateApp());
}

class SpendMateApp extends StatelessWidget {
  const SpendMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),

        StreamProvider<User?>.value(
          value: AuthService().user,
          initialData: null,
          catchError: (_, __) => null,
        ),

        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),

        ChangeNotifierProxyProvider<User?, TransactionProvider>(
          create: (context) => TransactionProvider(null),
          update: (context, user, previousProvider) {
            if (user != null) {
              return TransactionProvider(user);
            }
            return TransactionProvider(null);
          },
          lazy: false,
        ),

        ChangeNotifierProxyProvider<User?, CategoryProvider>(
          create: (context) => CategoryProvider(null),
          update: (context, user, previousProvider) {
            if (user != null) {
              return CategoryProvider(user);
            }
            return CategoryProvider(null);
          },
          lazy: false,
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Spend Mate',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,

            theme: ThemeData(
              primarySwatch: Colors.deepPurple,
              primaryColor: const Color(0xFF6A1B9A),
              brightness: Brightness.light,
              useMaterial3: true,
            ),

            darkTheme: ThemeData(
              primarySwatch: Colors.deepPurple,
              primaryColor: const Color(0xFFBB86FC),
              brightness: Brightness.dark,
              scaffoldBackgroundColor:
                  Colors.black,
              useMaterial3: true,
            ),
            home: const Wrapper(),
          );
        },
      ),
    );
  }
}
