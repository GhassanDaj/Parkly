// widgets/custom_text_field.dart
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool isPassword;
  final TextInputType keyboardType;
  final Function(String) onChanged;
  final String? Function(String?)? validator;
  final IconData? icon;

  const CustomTextField({
    Key? key,
    required this.label,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    required this.onChanged,
    this.validator,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        prefixIcon: icon != null ? Icon(icon, color: Colors.white70) : null,
        filled: true,
        fillColor:
            Colors.white.withOpacity(0.1), // Semi-transparent dark background
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.white70),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      style: TextStyle(color: Colors.white), // Set text color to white
      obscureText: isPassword,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
    );
  }
}
