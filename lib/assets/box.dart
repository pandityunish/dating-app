// import 'package:couple_match/screens/navigation/blink_component.dart';
import 'package:flutter/material.dart';

import 'package:ristey/global_vars.dart';
import 'package:ristey/screens/navigation/blinking_component.dart';

class Box extends StatelessWidget {
  const Box({
    super.key,
    this.width,
    // ignore: non_constant_identifier_names
    required this.box_text,
    required this.icon,
    required this.currentusertext,
  });
  // ignore: prefer_typing_uninitialized_variables
  final width;
  // ignore: non_constant_identifier_names, prefer_typing_uninitialized_variables
  final box_text;
  // ignore: prefer_typing_uninitialized_variables
  final icon;
  final String currentusertext;
  @override
  Widget build(BuildContext context) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: box_text,
        style: const TextStyle(fontSize: 12),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    final textWidth = textPainter.maxIntrinsicWidth;

    return Container(
        margin: const EdgeInsets.only(bottom: 1.5, right: 2),
        height: MediaQuery.of(context).size.height * 0.024,
        // width: (width == null) ? box_text.length * 8 + 32.0 : width,
        width: textWidth + 40 + textWidth * 0.08,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(33.0),
          border: Border.all(color: mainColor, width: 0.5),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              const SizedBox(
                width: 5,
              ),
              ImageIcon(
                AssetImage(icon),
                size: 16,
                color: mainColor,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                box_text,
                // textScaleFactor: 1.0,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: mainColor,
                ),
              ),
              box_text == currentusertext ? BlinkingDonecreen() : const Center()
            ],
          ),
        ));
  }
}
