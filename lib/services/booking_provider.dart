// lib/services/booking_provider.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parkly/models/booking.dart';
import 'package:parkly/models/parking_spot.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Booking> _bookings = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Booking> get bookings => _bookings;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Fetch all bookings for the current user
  Future<void> fetchBookings() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_auth.currentUser == null) {
        _errorMessage = 'User not authenticated';
        _isLoading = false;
        notifyListeners();
        return;
      }

      QuerySnapshot snapshot = await _db
          .collection('bookings')
          .where('userId', isEqualTo: _auth.currentUser!.uid)
          .get();

      List<Booking> fetchedBookings = [];

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String parkingSpotId = data['parkingSpotId'];

        // Fetch ParkingSpot details
        DocumentSnapshot spotSnapshot =
            await _db.collection('parking_spots').doc(parkingSpotId).get();
        if (spotSnapshot.exists) {
          ParkingSpot spot = ParkingSpot.fromMap(
              spotSnapshot.data() as Map<String, dynamic>, spotSnapshot.id);
          Booking booking = Booking.fromMap(data, doc.id, spot);
          fetchedBookings.add(booking);
        }
      }

      _bookings = fetchedBookings;
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to fetch bookings: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// **Create a new booking**
  ///
  /// **Parameters:**
  /// - `parkingSpot`: The ParkingSpot being booked.
  /// - `startTime`: The start time of the booking.
  /// - `endTime`: The end time of the booking.
  ///
  /// **Returns:**
  /// - `String?`: Returns `null` if successful, otherwise an error message.
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

      // Check if the parking spot is still available
      DocumentSnapshot spotSnapshot =
          await _db.collection('parking_spots').doc(parkingSpot.id).get();
      if (!spotSnapshot.exists) {
        return 'Parking spot does not exist';
      }

      bool isAvailable = spotSnapshot['isAvailable'] ?? true;
      if (!isAvailable) {
        return 'Parking spot is no longer available';
      }

      // Calculate the total price based on duration
      double durationInHours =
          endTime.difference(startTime).inMinutes / 60.0; // Fractional hours
      double totalPrice = parkingSpot.pricePerHour * durationInHours;

      // Add booking to 'bookings' collection
      DocumentReference bookingRef = await _db.collection('bookings').add({
        'userId': _auth.currentUser!.uid,
        'parkingSpotId': parkingSpot.id,
        'startTime': Timestamp.fromDate(startTime),
        'endTime': Timestamp.fromDate(endTime),
        'totalPrice': totalPrice,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('Booking created with ID: ${bookingRef.id}');

      // Update 'isAvailable' field in 'parking_spots' collection
      await _db.collection('parking_spots').doc(parkingSpot.id).update({
        'isAvailable': false,
      });

      print('Updated parking spot ${parkingSpot.id} availability to false.');

      // Optionally, add the new booking to the local list
      // You might want to fetch bookings again or append locally
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

  // Optional: Implement cancellation of bookings
  Future<String?> cancelBooking(String bookingId, String parkingSpotId) async {
    try {
      // Delete the booking document
      await _db.collection('bookings').doc(bookingId).delete();

      // Update the parking spot's availability
      await _db.collection('parking_spots').doc(parkingSpotId).update({
        'isAvailable': true,
      });

      // Refresh bookings
      await fetchBookings();

      return null; // Success
    } on FirebaseException catch (e) {
      print('FirebaseException: $e');
      return e.message ?? 'Firestore error';
    } catch (e) {
      print('Unknown error cancelling booking: $e');
      return 'An unknown error occurred';
    }
  }
}
