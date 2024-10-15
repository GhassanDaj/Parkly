import 'package:flutter/material.dart';
import 'package:parkly/screens/RenterHomePage.dart';
import 'package:provider/provider.dart';
import '../services/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Profile', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await authProvider.signOut();
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                  child: Text('Logout'),
                ),
                SizedBox(width: 20), // Space between the two buttons
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the renter screen
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => RenterHomePage()),
                    );
                  },
                  child: Text('Switch to Renter'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
