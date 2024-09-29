// screens/sign_up_page.dart
import 'package:flutter/material.dart';
import 'package:parkly/screens/login_page.dart';
import 'package:parkly/services/auth_provider.dart';
import 'package:parkly/widgets/custom_button.dart';
import 'package:parkly/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String confirmPassword = '';
  String errorMessage = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Illustration
            Center(
              child: Image.asset(
                'assets/images/signup_illustration.png',
                height: 250,
              ),
            ),
            SizedBox(height: 30),
            // Welcome Text
            Text(
              'Create Account',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Sign up to get started',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 30),
            // Form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Email Field
                  CustomTextField(
                    label: 'Email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => email = value,
                    validator: (value) =>
                        value != null && value.isEmpty ? 'Enter email' : null,
                  ),
                  SizedBox(height: 20),
                  // Password Field
                  CustomTextField(
                    label: 'Password',
                    icon: Icons.lock_outline,
                    isPassword: true,
                    onChanged: (value) => password = value,
                    validator: (value) => value != null && value.length < 6
                        ? 'Password must be at least 6 characters'
                        : null,
                  ),
                  SizedBox(height: 20),
                  // Confirm Password Field
                  CustomTextField(
                    label: 'Confirm Password',
                    icon: Icons.lock_outline,
                    isPassword: true,
                    onChanged: (value) => confirmPassword = value,
                    validator: (value) => value != null && value != password
                        ? 'Passwords do not match'
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
                  // Sign Up Button
                  CustomButton(
                    text: 'Sign Up',
                    isLoading: isLoading,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                          errorMessage = '';
                        });
                        String? result =
                            await authProvider.signUp(email.trim(), password);
                        if (result != null) {
                          setState(() {
                            errorMessage = result;
                            isLoading = false;
                          });
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                          // Navigate to home or login page after successful sign-up
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        }
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  // Navigate to Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(color: Colors.black54),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
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
    );
  }
}
