import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HyperlinkText extends StatelessWidget {
  final String normalText;
  final String linkText;
  final VoidCallback onTap;

  const HyperlinkText({
    required this.normalText,
    required this.linkText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: normalText,
        style: TextStyle(color: Colors.black54, fontSize: 14),
        children: [
          TextSpan(
            text: linkText,
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    );
  }
}
