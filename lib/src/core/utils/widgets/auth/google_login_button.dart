part of 'login_via_thirdparty.dart';

class GoogleLoginButton extends LoginButtonBase {
  const GoogleLoginButton({
    super.key,
    required super.onPressed,
    super.buttonText = 'Sign in with Google',
    super.width,
    super.iconSize,
    super.showText,
  });

  @override
  Widget icon(double size) {
    return Image.asset(
      AppImages.google,
      fit: BoxFit.cover,
      width: size,
      height: size,
    );
  }

  @override
  Color get buttonColor => Colors.white;

  @override
  Color get textColor => Colors.black87;

  @override
  Color get borderColor => Colors.grey.shade300;
}
