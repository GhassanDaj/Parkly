// services/booking_provider.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parkly/models/parking_spot.dart';
import 'package:parkly/models/booking.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<ParkingSpot> parkingSpots = [];
  List<Booking> bookings = [];
  String errorMessage = '';
  bool isLoading = false; // Added loading state

  BookingProvider() {
    fetchParkingSpots();
    fetchBookings();
    testFirestoreConnection(); // Optional: Test Firestore connection on initialization
  }

  // Test Firestore connection
  Future<void> testFirestoreConnection() async {
    try {
      QuerySnapshot snapshot =
          await _db.collection('parking_spots').limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        print('Firestore is connected and data is accessible.');
      } else {
        print('Firestore is connected but no data found in parking_spots.');
      }
    } catch (e) {
      print('Error testing Firestore connection: $e');
    }
  }

  // Fetch available parking spots
  Future<void> fetchParkingSpots() async {
    setLoading(true); // Start loading
    try {
      QuerySnapshot snapshot = await _db
          .collection('parking_spots')
          .where('isAvailable', isEqualTo: true)
          .get();

      parkingSpots = snapshot.docs
          .map((doc) =>
              ParkingSpot.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      errorMessage = '';
    } catch (e) {
      print('Error fetching parking spots: $e');
      errorMessage = 'Failed to load parking spots.';
      parkingSpots = []; // Ensure parkingSpots is empty on error
    } finally {
      setLoading(false); // End loading
    }
  }

  // Fetch user's bookings
  Future<void> fetchBookings() async {
    try {
      if (_auth.currentUser == null) return;

      QuerySnapshot snapshot = await _db
          .collection('bookings')
          .where('userId', isEqualTo: _auth.currentUser!.uid)
          .get();

      bookings = snapshot.docs
          .map((doc) =>
              Booking.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      notifyListeners();
    } catch (e) {
      print('Error fetching bookings: $e');
    }
  }

  // Create a new booking
  Future<String?> createBooking({
    required ParkingSpot parkingSpot,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      if (_auth.currentUser == null) {
        return 'User not authenticated';
      }

      // Validate booking times
      if (endTime.isBefore(startTime)) {
        return 'End time must be after start time';
      }

      // Calculate the total price based on duration
      double durationInHours = endTime.difference(startTime).inMinutes / 60;
      double totalPrice = parkingSpot.pricePerHour * durationInHours;

      // Add booking to 'bookings' collection
      DocumentReference bookingRef = await _db.collection('bookings').add({
        'userId': _auth.currentUser!.uid,
        'parkingSpotId': parkingSpot.id,
        'startTime': Timestamp.fromDate(startTime),
        'endTime': Timestamp.fromDate(endTime),
        'totalPrice': totalPrice,
      });

      print('Booking created with ID: ${bookingRef.id}');

      // Update 'isAvailable' field in 'parking_spots' collection
      await _db.collection('parking_spots').doc(parkingSpot.id).update({
        'isAvailable': false,
      });

      print('Updated parking spot ${parkingSpot.id} availability to false.');

      // Refresh data
      await fetchParkingSpots();
      await fetchBookings();

      return null; // Success
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: $e');
      return e.message ?? 'Authentication error';
    } on FirebaseException catch (e) {
      print('FirebaseException: $e');
      return e.message ?? 'Firestore error';
    } catch (e) {
      print('Unknown error creating booking: $e');
      return 'An unknown error occurred';
    }
  }

  // Setter for loading state
  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
