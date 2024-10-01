// lib/models/booking.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parkly/models/parking_spot.dart';

class Booking {
  final String id;
  final String userId;
  final String parkingSpotId;
  final DateTime startTime;
  final DateTime endTime;
  final double totalPrice;
  final ParkingSpot parkingSpot; // Reference to the ParkingSpot

  Booking({
    required this.id,
    required this.userId,
    required this.parkingSpotId,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.parkingSpot,
  });

  factory Booking.fromMap(
      Map<String, dynamic> data, String documentId, ParkingSpot spot) {
    return Booking(
      id: documentId,
      userId: data['userId'] ?? '',
      parkingSpotId: data['parkingSpotId'] ?? '',
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp).toDate(),
      totalPrice: (data['totalPrice'] as num?)?.toDouble() ?? 0.0,
      parkingSpot: spot,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'parkingSpotId': parkingSpotId,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'totalPrice': totalPrice,
    };
  }
}
