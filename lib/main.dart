import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:spend_mate/services/auth_service.dart';
import 'package:spend_mate/providers/transaction_provider.dart'; // নতুন import
import 'package:spend_mate/screens/wrapper.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart'; // নতুন import

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
    return MultiProvider(
      providers: [
        // 1. AuthService (Provides User stream)
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),

        // 2. StreamProvider for User (Handles logged-in state)
        StreamProvider<User?>.value(
          value: AuthService().user,
          initialData: null,
          catchError: (_, __) => null,
        ),

        // 3. ChangeNotifierProxyProvider (Depends on the User stream)
        // এটি নিশ্চিত করে যে User যখন লগ ইন করবে তখনই TransactionProvider তৈরি হবে
        ChangeNotifierProxyProvider<User?, TransactionProvider>(
          create: (context) => TransactionProvider(null), // Initial provider with null user
          update: (context, user, previousProvider) {
            // Re-create the provider only when the user status changes
            if (user != null) {
              return TransactionProvider(user);
            }
            // If user logs out, keep the previous provider or return a null-user version
            return TransactionProvider(null);
          },
          lazy: false,
        ),
      ],
      child: MaterialApp(
        title: 'Spend Mate',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          brightness: Brightness.light,
        ),
        home: const Wrapper(),
      ),
    );
  }
}