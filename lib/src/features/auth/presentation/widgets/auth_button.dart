import 'package:dhgc_chat_app/src/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    this.onPressed,
    this.buttonText = 'LOGIN',
    this.width = double.infinity,
    this.textSize = 16.0,
    this.buttonColor = AppColors.primaryColor,
    this.textColor = Colors.white,
  });

  final VoidCallback? onPressed;
  final String? buttonText;
  final double width;
  final double textSize;
  final Color? buttonColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          backgroundColor: buttonColor,
          side: BorderSide(color: buttonColor!, width: 1),
        ),
        child: Text(
          buttonText!,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: textSize,
          ),
        ),
      ),
    );
  }
}
