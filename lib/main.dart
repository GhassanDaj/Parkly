// lib/main.dart

import 'package:flutter/material.dart';
import 'package:parkly/screens/home_page.dart';
import 'package:parkly/services/auth_provider.dart';
import 'package:parkly/services/booking_provider.dart';
import 'package:parkly/services/parking_spot_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Ensure this is correctly set up

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:
        DefaultFirebaseOptions.currentPlatform, // Ensure correct initialization
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
        ChangeNotifierProvider<BookingProvider>(
          create: (_) => BookingProvider(),
        ),
        ChangeNotifierProvider<ParkingSpotProvider>(
          create: (_) => ParkingSpotProvider()
            ..fetchParkingSpots(), // Fetch spots on initialization
        ),
        // Add other providers here
      ],
      child: MaterialApp(
        title: 'Parkly',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
        // Define routes if necessary
      ),
    );
  }
}
