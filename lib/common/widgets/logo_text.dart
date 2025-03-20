import 'package:flutter/material.dart';
import 'package:ristey/global_vars.dart';

class LogoText extends StatelessWidget {
  const LogoText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(TextSpan(style: const TextStyle(fontSize: 20), children: [
      const TextSpan(
          text: "Free",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: "Showg",
          )),
      TextSpan(
          text: "rishteywala",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: mainColor,
              fontFamily: "Showg")),
      // TextSpan(
      //     text: ".in", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Showg")),
    ]));
  }
}
