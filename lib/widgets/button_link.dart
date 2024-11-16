import 'package:flutter/material.dart';

class ButtonLink extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final TextDecoration? textDecoration;

  const ButtonLink({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textDecoration,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: color,
          decoration: textDecoration,
        ),
      ),
    );
  }
}
