part of 'login_via_thirdparty.dart';

class AppleLoginButton extends StatelessWidget implements IAppleLoginButton {
  final VoidCallback onPressed;
  final String? buttonText;
  final double width;
  final double iconSize;
  final double textSize;
  final bool showText;

  const AppleLoginButton({
    super.key,
    required this.onPressed,
    this.buttonText = 'Sign in with Apple',
    this.width = double.infinity,
    this.iconSize = 24.0,
    this.textSize = 16.0,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return buildAppleButton(context);
  }

  @override
  Widget buildAppleButton(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          side: BorderSide(color: buttonColor, width: 1),
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
                      const SizedBox(width: 10),
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

  @override
  Widget icon(double size) {
    return Image.asset(
      AppImages.apple,
      width: size,
      height: size,
      fit: BoxFit.cover,
    );
  }

  @override
  Color get buttonColor => AppColors.apple;

  @override
  Color get textColor => Colors.white;
}
