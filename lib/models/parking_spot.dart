// lib/models/parking_spot.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class ParkingSpot {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double pricePerHour;
  final bool isAvailable;
  final String? imageUrl; // Optional

  ParkingSpot({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.pricePerHour,
    required this.isAvailable,
    this.imageUrl,
  });

  // Factory method to create a ParkingSpot from Firestore data
  factory ParkingSpot.fromMap(Map<String, dynamic> data, String documentId) {
    return ParkingSpot(
      id: documentId,
      name: data['name'] ?? 'Unnamed Spot',
      address: data['address'] ?? 'No Address Provided',
      latitude: (data['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (data['longitude'] as num?)?.toDouble() ?? 0.0,
      pricePerHour: (data['pricePerHour'] as num?)?.toDouble() ?? 0.0,
      isAvailable: data['isAvailable'] ?? true,
      imageUrl: data['imageUrl'], // Can be null
    );
  }

  // Method to convert ParkingSpot to a Map (useful for Firestore operations)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'pricePerHour': pricePerHour,
      'isAvailable': isAvailable,
      'imageUrl': imageUrl,
    };
  }
}
