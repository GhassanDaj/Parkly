// screens/login_page.dart
import 'package:flutter/material.dart';
import 'package:parkly/screens/sign_up_page.dart';
import 'package:parkly/services/auth_provider.dart';
import 'package:parkly/widgets/custom_button.dart';
import 'package:parkly/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String errorMessage = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Theme(
        data: Theme.of(context).copyWith(
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            labelStyle: TextStyle(color: Colors.white70),
            prefixIconColor: Colors.white70,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.white70),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                'assets/background.png',
                fit: BoxFit.cover,
              ),
            ),
            // Semi-transparent overlay
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            // Content
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 80.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App Logo
                    Center(
                      child: Image.asset(
                        'assets/logo.png',
                        height: 120,
                      ),
                    ),
                    SizedBox(height: 40),
                    Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Login to continue',
                      style: TextStyle(fontSize: 18, color: Colors.white70),
                    ),
                    SizedBox(height: 30),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Email Field
                          CustomTextField(
                            label: 'Email',
                            icon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) => email = value,
                            validator: (value) => value != null && value.isEmpty
                                ? 'Enter email'
                                : null,
                          ),
                          SizedBox(height: 20),
                          // Password Field
                          CustomTextField(
                            label: 'Password',
                            icon: Icons.lock,
                            isPassword: true,
                            onChanged: (value) => password = value,
                            validator: (value) =>
                                value != null && value.length < 6
                                    ? 'Password must be at least 6 characters'
                                    : null,
                          ),
                          SizedBox(height: 20),
                          // Error Message
                          if (errorMessage.isNotEmpty)
                            Text(
                              errorMessage,
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          SizedBox(height: 20),
                          // Login Button
                          CustomButton(
                            text: 'Login',
                            isLoading: isLoading,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                  errorMessage = '';
                                });
                                String? result = await authProvider.signIn(
                                    email.trim(), password);
                                if (result != null) {
                                  setState(() {
                                    errorMessage = result;
                                    isLoading = false;
                                  });
                                } else {
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }
                            },
                          ),
                          SizedBox(height: 20),
                          // Or Divider
                          Row(
                            children: [
                              Expanded(child: Divider(color: Colors.white70)),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'OR',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ),
                              Expanded(child: Divider(color: Colors.white70)),
                            ],
                          ),
                          SizedBox(height: 20),
                          // Google Sign-In Button
                          Center(
                            child: SocialIconButton(
                              icon: FontAwesomeIcons.google,
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                  errorMessage = '';
                                });
                                try {
                                  String? result =
                                      await authProvider.signInWithGoogle();
                                  if (result != null) {
                                    setState(() {
                                      errorMessage = result;
                                      isLoading = false;
                                    });
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                } catch (e) {
                                  setState(() {
                                    errorMessage =
                                        'An error occurred during Google Sign-In.';
                                    isLoading = false;
                                  });
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          // Navigate to Sign Up
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\'t have an account?',
                                style: TextStyle(color: Colors.white70),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUpPage()),
                                  );
                                },
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Loading Indicator
            if (isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Social Icon Button Widget
class SocialIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const SocialIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: FaIcon(icon, color: Colors.white),
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(), backgroundColor: Colors.red,
        padding: EdgeInsets.all(16), // Button color
      ),
      onPressed: onPressed,
    );
  }
}
