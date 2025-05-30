import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NetworkAvatar extends StatelessWidget {
  final String imageUrl;
  final String? initials;
  final double size;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final bool isCircular;
  final Widget? placeholder;
  final Widget? errorWidget;
  final IconData? errorIcon;

  const NetworkAvatar({
    super.key,
    required this.imageUrl,
    this.initials,
    this.size = 40,
    this.backgroundColor = Colors.blueGrey,
    this.textColor = Colors.white,
    this.borderRadius = 0,
    this.isCircular = true,
    this.placeholder,
    this.errorWidget,
    this.errorIcon = Icons.person,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircular ? null : BorderRadius.circular(borderRadius),
        color: backgroundColor,
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          width: size,
          height: size,
          placeholder: (context, url) => placeholder ?? _buildPlaceholder(),
          errorWidget:
              (context, url, error) => errorWidget ?? _buildErrorWidget(),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child:
          initials != null
              ? Center(
                child: Text(
                  initials!,
                  style: TextStyle(
                    color: textColor,
                    fontSize: size * 0.35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
              : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: Colors.grey[300],
      child:
          initials != null
              ? Center(
                child: Text(
                  initials!,
                  style: TextStyle(
                    color: textColor,
                    fontSize: size * 0.35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
              : Icon(errorIcon, size: size * 0.6),
    );
  }
}

class CircleAvatarWidget extends StatelessWidget {
  const CircleAvatarWidget({
    super.key,
    required this.imageUrl,
    this.initials,
    this.size = 40,
    this.isOnline = true,
  });

  final String imageUrl;
  final String? initials;
  final double size;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          NetworkAvatar(
            imageUrl: imageUrl,
            size: size,
            backgroundColor: Colors.grey[200]!,
            textColor: Colors.black,
            initials: initials,
          ),
          if (isOnline)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: size * 0.25,
                height: size * 0.25,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: size / 30,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
