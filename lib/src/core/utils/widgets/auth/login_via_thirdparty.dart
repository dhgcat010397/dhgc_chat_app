import 'package:dhgc_chat_app/src/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

import 'package:dhgc_chat_app/src/core/utils/constants/app_images.dart';

part 'google_login_button.dart';
part 'facebook_login_button.dart';
part 'apple_login_button.dart';

abstract class LoginButtonBase extends StatelessWidget {
  final VoidCallback onPressed;
  final String? buttonText;
  final double width;
  final double iconSize;
  final double textSize;
  final bool showText;

  const LoginButtonBase({
    super.key,
    required this.onPressed,
    this.buttonText,
    this.width = double.infinity,
    this.iconSize = 24.0,
    this.textSize = 16.0,
    this.showText = true,
  });

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
          side: BorderSide(color: borderColor, width: 1),
        ),
        child:
            showText && buttonText != null
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    icon(iconSize),
                    if (showText && buttonText != null)
                      const SizedBox(width: 10),
                    if (showText && buttonText != null)
                      Text(
                        buttonText!,
                        style: TextStyle(
                          color: textColor,
                          fontSize: textSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                )
                : icon(iconSize),
      ),
    );
  }

  /// Returns the icon widget to be displayed in the button.
  Widget icon(double size);

  /// Returns the color of the button background.
  Color get buttonColor => Colors.white;

  /// Returns the color of the text in the button.
  Color get textColor => Colors.black87;

  /// Returns the color of the border of the button.
  Color get borderColor => Colors.grey.shade300;
}

abstract class IAppleLoginButton {
  Widget buildAppleButton(BuildContext context);
  Widget icon(double size);
  Color get buttonColor => Colors.black;
  Color get textColor => Colors.white;
}
