// screens/booking_confirmation_screen.dart
import 'package:flutter/material.dart';
import 'package:parkly/models/parking_spot.dart';
import 'package:parkly/services/booking_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final ParkingSpot parkingSpot;

  const BookingConfirmationScreen({Key? key, required this.parkingSpot})
      : super(key: key);

  @override
  _BookingConfirmationScreenState createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  DateTime? _startTime;
  DateTime? _endTime;
  String errorMessage = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Booking'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Parking Spot Details
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.local_parking,
                        size: 40, color: Theme.of(context).primaryColor),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.parkingSpot.name,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            widget.parkingSpot.address,
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[700]),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '\$${widget.parkingSpot.pricePerHour.toStringAsFixed(2)}/hr',
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Booking Details
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: Column(
                  children: [
                    // Start Time Picker
                    ListTile(
                      leading: Icon(Icons.calendar_today,
                          color: Theme.of(context).primaryColor),
                      title: Text('Start Time'),
                      subtitle: Text(
                        _startTime != null
                            ? DateFormat('yyyy-MM-dd – kk:mm')
                                .format(_startTime!)
                            : 'Select start time',
                        style: TextStyle(fontSize: 16),
                      ),
                      trailing: Icon(Icons.keyboard_arrow_down),
                      onTap: () => _pickDateTime(context, isStartTime: true),
                    ),
                    Divider(),
                    // End Time Picker
                    ListTile(
                      leading: Icon(Icons.calendar_today,
                          color: Theme.of(context).primaryColor),
                      title: Text('End Time'),
                      subtitle: Text(
                        _endTime != null
                            ? DateFormat('yyyy-MM-dd – kk:mm').format(_endTime!)
                            : 'Select end time',
                        style: TextStyle(fontSize: 16),
                      ),
                      trailing: Icon(Icons.keyboard_arrow_down),
                      onTap: () => _pickDateTime(context, isStartTime: false),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Error Message
            if (errorMessage.isNotEmpty)
              Container(
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.redAccent),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        errorMessage,
                        style: TextStyle(color: Colors.redAccent, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),

            if (errorMessage.isNotEmpty) SizedBox(height: 20),

            // Confirm Booking Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _confirmBooking,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: isLoading
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : Text(
                        'Confirm Booking',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDateTime(BuildContext context,
      {required bool isStartTime}) async {
    DateTime now = DateTime.now();
    DateTime initialDate =
        isStartTime ? now : (_startTime ?? now).add(Duration(hours: 1));

    // Pick Date
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: isStartTime ? now : (_startTime ?? now),
      lastDate: now.add(Duration(days: 365)),
    );

    if (pickedDate == null) return;

    // Pick Time
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );

    if (pickedTime == null) return;

    DateTime combined = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      if (isStartTime) {
        _startTime = combined;
        // Reset end time if it's before the new start time
        if (_endTime != null && _endTime!.isBefore(_startTime!)) {
          _endTime = null;
        }
      } else {
        _endTime = combined;
      }
    });
  }

  Future<void> _confirmBooking() async {
    final bookingProvider =
        Provider.of<BookingProvider>(context, listen: false);

    if (_startTime == null || _endTime == null) {
      setState(() {
        errorMessage = 'Please select both start and end times.';
      });
      return;
    }

    if (_endTime!.isBefore(_startTime!)) {
      setState(() {
        errorMessage = 'End time must be after start time.';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    String? result = await bookingProvider.createBooking(
      parkingSpot: widget.parkingSpot,
      startTime: _startTime!,
      endTime: _endTime!,
    );

    setState(() {
      isLoading = false;
      errorMessage = result ?? '';
    });

    if (result == null) {
      // Booking was successful
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking confirmed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      // Navigate back to home or another desired screen
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }
}
