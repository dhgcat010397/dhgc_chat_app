import 'package:flutter/material.dart';

class TextDivider extends StatelessWidget {
  const TextDivider({
    super.key,
    this.text = "OR",
    this.textStyle = const TextStyle(
      color: Colors.black54,
      fontWeight: FontWeight.bold,
    ),
    this.backgroundColor = Colors.white,
    this.dividerColor = Colors.black54,
    this.height = 40.0,
    this.thickness = 1.0,
    this.indent = 20.0,
    this.endIndent = 20.0,
  });

  final String text;
  final TextStyle textStyle;
  final Color backgroundColor;
  final Color dividerColor;
  final double height;
  final double thickness;
  final double indent;
  final double endIndent;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Divider(
          color: dividerColor,
          height: height,
          thickness: thickness,
          indent: indent,
          endIndent: endIndent,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          color: backgroundColor,
          child: Text(text, style: textStyle),
        ),
      ],
    );
  }
}
