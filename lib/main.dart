// lib/main.dart

import 'package:flutter/material.dart';
import 'package:parkly/screens/auth_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:parkly/services/auth_provider.dart';
import 'package:parkly/services/booking_provider.dart';
import 'package:parkly/services/parking_spot_provider.dart';
import 'package:parkly/screens/home_page.dart';
import 'package:parkly/screens/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Ensure correct Firebase options

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ParklyApp());
}

class ParklyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        // other providers...
      ],
      child: MaterialApp(
        title: 'Parkly',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => AuthWrapper(),
          '/login': (context) =>
              LoginPage(), // Make sure this is the login page
          // Other routes can be added here
        },
      ),
    );
  }
}
