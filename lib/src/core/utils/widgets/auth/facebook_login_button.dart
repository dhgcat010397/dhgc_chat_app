part of 'login_via_thirdparty.dart';

class FacebookLoginButton extends LoginButtonBase {
  const FacebookLoginButton({
    super.key,
    required super.onPressed,
    super.buttonText = 'Sign in with Facebook',
    super.width,
    super.iconSize,
    super.showText,
  });

  @override
  Widget icon(double size) {
    return Image.asset(
      AppImages.facebook,
      fit: BoxFit.cover,
      width: size,
      height: size,
    );
  }

  @override
  Color get buttonColor => AppColors.facebook;

  @override
  Color get textColor => Colors.white;

  @override
  Color get borderColor => AppColors.facebook;
}
