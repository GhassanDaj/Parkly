// screens/auth_wrapper.dart
import 'package:flutter/material.dart';
import 'package:parkly/screens/home_page.dart';
import 'package:parkly/screens/home_page.dart';
import 'package:parkly/screens/login_page.dart';
import 'package:parkly/services/auth_provider.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.user != null) {
      return HomePage();
    } else {
      return LoginPage();
    }
  }
}
