import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    required this.controller,
    this.focusNode,
    this.validator,
    this.isConfirm = false,
  }) : assert(
         !isConfirm || (isConfirm && validator != null),
         'Validator must be provided for confirm password field.',
       );

  final bool isConfirm;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final FormFieldValidator<String>? validator;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: widget.isConfirm ? 'Confirm Password' : 'Password',
        border: OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: _toggleObscureText,
        ),
      ),
    );
  }

  void _toggleObscureText() {
    if (mounted) {
      setState(() {
        _obscureText = !_obscureText;
      });
    }
  }
}
