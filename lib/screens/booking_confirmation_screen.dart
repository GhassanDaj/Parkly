// lib/screens/booking_confirmation_screen.dart

import 'package:flutter/material.dart';
import 'package:parkly/models/parking_spot.dart';
import 'package:parkly/services/booking_provider.dart';
import 'package:provider/provider.dart';

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
  bool _isSubmitting = false;
  String _errorMessage = '';

  // Function to pick start time
  Future<void> _pickStartTime() async {
    DateTime initialDate = DateTime.now().add(Duration(hours: 1));
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (time != null) {
        setState(() {
          _startTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  // Function to pick end time
  Future<void> _pickEndTime() async {
    if (_startTime == null) {
      setState(() {
        _errorMessage = 'Please select a start time first.';
      });
      return;
    }

    DateTime initialDate = _startTime!.add(Duration(hours: 1));
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: _startTime!.add(Duration(minutes: 30)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (time != null) {
        setState(() {
          _endTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  // Function to submit booking
  Future<void> _submitBooking() async {
    if (_startTime == null || _endTime == null) {
      setState(() {
        _errorMessage = 'Please select both start and end times.';
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = '';
    });

    final bookingProvider =
        Provider.of<BookingProvider>(context, listen: false);

    String? error = await bookingProvider.createBooking(
      parkingSpot: widget.parkingSpot,
      startTime: _startTime!,
      endTime: _endTime!,
    );

    setState(() {
      _isSubmitting = false;
    });

    if (error != null) {
      setState(() {
        _errorMessage = error;
      });
    } else {
      // Navigate to success screen or show a success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Booking Confirmed'),
          content: Text('Your parking spot has been booked successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Confirm Booking'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Display Parking Spot Details
              Text(
                widget.parkingSpot.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                widget.parkingSpot.address,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 20),
              // Start Time Picker
              ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text(
                  _startTime == null
                      ? 'Select Start Time'
                      : 'Start: ${_startTime.toString()}',
                ),
                trailing: Icon(Icons.keyboard_arrow_down),
                onTap: _pickStartTime,
              ),
              // End Time Picker
              ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text(
                  _endTime == null
                      ? 'Select End Time'
                      : 'End: ${_endTime.toString()}',
                ),
                trailing: Icon(Icons.keyboard_arrow_down),
                onTap: _pickEndTime,
              ),
              SizedBox(height: 20),
              // Display Error Message
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              Spacer(),
              // Submit Button
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitBooking,
                child: _isSubmitting
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text('Confirm Booking'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50), // Full width button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
