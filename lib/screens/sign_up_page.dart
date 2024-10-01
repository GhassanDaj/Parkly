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
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String confirmPassword = '';
  String role = 'customer'; // Default role
  String errorMessage = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/images/signup_illustration.png',
                height: 250,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Create an Account',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Sign up to get started',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'Password',
                    isPassword: true,
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'Confirm Password',
                    isPassword: true,
                    onChanged: (value) {
                      setState(() {
                        confirmPassword = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != password) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: role,
                    decoration: const InputDecoration(labelText: 'Role'),
                    items: [
                      DropdownMenuItem(value: 'customer', child: Text('Customer')),
                      DropdownMenuItem(value: 'renter', child: Text('Renter')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        role = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  if (errorMessage.isNotEmpty)
                    Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Sign Up',
                    isLoading: isLoading,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                          errorMessage = '';
                        });
                        if (password != confirmPassword) {
                          setState(() {
                            errorMessage = 'Passwords do not match';
                            isLoading = false;
                          });
                          return;
                        }
                        String? result = await authProvider.signUp(email.trim(), password, role);
                        if (result != null) {
                          setState(() {
                            errorMessage = result;
                            isLoading = false;
                          });
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                          // Navigate to login page after successful sign-up
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  // Navigate to Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(color: Colors.black54),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(color: Theme.of(context).primaryColor),
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
