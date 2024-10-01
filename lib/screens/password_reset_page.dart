// screens/password_reset_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parkly/services/auth_provider.dart';
import 'package:parkly/widgets/custom_button.dart';
import 'package:parkly/widgets/custom_text_field.dart';

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({Key? key}) : super(key: key);

  @override
  PasswordResetPageState createState() => PasswordResetPageState();
}

class PasswordResetPageState extends State<PasswordResetPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String message = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Instruction Text
              Text(
                'Enter your email address and we\'ll send you a link to reset your password.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 30),
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter email';
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                            .hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    // Message
                    if (message.isNotEmpty)
                      Text(
                        message,
                        style: TextStyle(
                            color: message.contains('sent')
                                ? Colors.green
                                : Colors.redAccent),
                      ),
                    SizedBox(height: 20),
                    // Send Reset Link Button
                    CustomButton(
                      text: 'Send Reset Link',
                      isLoading: isLoading,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                            message = '';
                          });
                          String? result =
                              await authProvider.resetPassword(email.trim());
                          if (result != null) {
                            setState(() {
                              message = result;
                              isLoading = false;
                            });
                          } else {
                            setState(() {
                              message =
                                  'A password reset link has been sent to $email';
                              isLoading = false;
                            });
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
