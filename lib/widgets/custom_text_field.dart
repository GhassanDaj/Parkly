// widgets/custom_text_field.dart
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
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
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    _obscureText = widget.isPassword;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () => setState(() {
                  _obscureText = !_obscureText;
                }),
              )
            : null,
      ),
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      onChanged: widget.onChanged,
    );
  }
}
