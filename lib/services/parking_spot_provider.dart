// lib/services/parking_spot_provider.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parkly/models/parking_spot.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ParkingSpotProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<ParkingSpot> _parkingSpots = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<ParkingSpot> get parkingSpots => _parkingSpots;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Stream<List<ParkingSpot>> get parkingSpotsStream {
    return _db.collection('parking_spots').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ParkingSpot.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  /// **Fetches all available parking spots from Firestore**
  Future<void> fetchParkingSpots() async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot = await _db.collection('parking_spots').get();

      List<ParkingSpot> fetchedSpots = snapshot.docs.map((doc) {
        return ParkingSpot.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      _parkingSpots = fetchedSpots;
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to fetch parking spots: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// **Listens to real-time updates of parking spots**
  void listenToParkingSpots() {
    _db.collection('parking_spots').snapshots().listen((snapshot) {
      _parkingSpots = snapshot.docs.map((doc) {
        return ParkingSpot.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      notifyListeners();
    });
  }

  /// **Updates the availability status of a parking spot**
  Future<String?> updateParkingSpotAvailability(
      String spotId, bool isAvailable) async {
    try {
      await _db.collection('parking_spots').doc(spotId).update({
        'isAvailable': isAvailable,
      });
      // Update local list
      int index = _parkingSpots.indexWhere((spot) => spot.id == spotId);
      if (index != -1) {
        _parkingSpots[index] = ParkingSpot(
          id: _parkingSpots[index].id,
          name: _parkingSpots[index].name,
          address: _parkingSpots[index].address,
          latitude: _parkingSpots[index].latitude,
          longitude: _parkingSpots[index].longitude,
          pricePerHour: _parkingSpots[index].pricePerHour,
          isAvailable: isAvailable,
          imageUrl: _parkingSpots[index].imageUrl,
        );
        notifyListeners();
      }
      return null; // Success
    } catch (e) {
      print('Error updating parking spot availability: $e');
      return 'Failed to update parking spot availability';
    }
  }
}
