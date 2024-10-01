// models/booking.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String id;
  final String userId;
  final String parkingSpotId;
  final DateTime startTime;
  final DateTime endTime;
  final double totalPrice;

  Booking({
    required this.id,
    required this.userId,
    required this.parkingSpotId,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
  });

  factory Booking.fromMap(Map<String, dynamic> data, String documentId) {
    return Booking(
      id: documentId,
      userId: data['userId'] ?? '',
      parkingSpotId: data['parkingSpotId'] ?? '',
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp).toDate(),
      totalPrice: data['totalPrice']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'parkingSpotId': parkingSpotId,
      'startTime': startTime,
      'endTime': endTime,
      'totalPrice': totalPrice,
    };
  }
}
