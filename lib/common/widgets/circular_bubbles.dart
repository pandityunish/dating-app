import 'package:flutter/material.dart';
import 'package:ristey/global_vars.dart';

class CircularBubles extends StatelessWidget {
  final String url;
  var height = 60.0;
  CircularBubles({super.key, required this.url, this.height = 60.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: height,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          // border: Border.all(color: mainColor, width: 2),
          image: DecorationImage(
              image: NetworkImage(
                url,
              ),
              fit: BoxFit.cover)),
    );
  }
}
