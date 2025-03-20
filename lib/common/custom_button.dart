// import 'package:couple_match/common/global.dart';
import 'package:flutter/material.dart';
import 'package:ristey/common/global.dart';

class CustomButtonD extends StatelessWidget {
  final String name;
  final VoidCallback callback;
  const CustomButtonD({super.key, required this.name, required this.callback});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: primarycolor,
            maximumSize: const Size(250, 70),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
        onPressed: callback,
        child: Text(name));
  }
}
