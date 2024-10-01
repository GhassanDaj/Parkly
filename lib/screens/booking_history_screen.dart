// screens/booking_history_screen.dart
import 'package:flutter/material.dart';
import 'package:parkly/models/booking.dart';
import 'package:parkly/services/booking_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Bookings'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: RefreshIndicator(
        onRefresh: bookingProvider.fetchBookings,
        child: ListView.builder(
          itemCount: bookingProvider.bookings.length,
          itemBuilder: (context, index) {
            Booking booking = bookingProvider.bookings[index];
            return ListTile(
              title: Text('Booking ID: ${booking.id}'),
              subtitle: Text(
                'Start: ${DateFormat('yyyy-MM-dd – kk:mm').format(booking.startTime)}\n'
                'End: ${DateFormat('yyyy-MM-dd – kk:mm').format(booking.endTime)}\n'
                'Total Price: \$${booking.totalPrice.toStringAsFixed(2)}',
              ),
            );
          },
        ),
      ),
    );
  }
}
