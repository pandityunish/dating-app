// import 'package:couple_match/globalVars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ristey/global_vars.dart';

import '../../../../Chat/colors.dart';

class MatchingComponents extends StatelessWidget {
  final String title;
  const MatchingComponents({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          leading: CircleAvatar(
            backgroundColor: mainColor,
            backgroundImage: const AssetImage(
              "images/newlogo.png",
            ),
            radius: 20,
          ),
        ),
        const Divider(color: dividerColor),
      ],
    );
  }
}
