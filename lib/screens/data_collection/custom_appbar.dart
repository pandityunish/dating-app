import 'package:flutter/material.dart';
import 'package:ristey/global_vars.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackButtonPressed;

final String iconImage;
  const CustomAppBar({
    Key? key,
    required this.title,
    this.onBackButtonPressed, required this.iconImage,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(100); // Customize height here

  @override
  Widget build(BuildContext context) {
    return  PreferredSize(
  preferredSize: const Size.fromHeight(100), // Adjust AppBar height
  child: AppBar(
   
    leading: GestureDetector(
      onTap:onBackButtonPressed ?? () {
        Navigator.of(context).pop();
      },
      child: Icon(
        Icons.arrow_back_ios_new,
        color: mainColor,
        size: 25,
      ),
    ),
    flexibleSpace: Padding(
      padding: const EdgeInsets.only(top: 0), // Adjust padding for alignment
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(
               AssetImage(iconImage),
              size: 30,
              color: mainColor,
            ),
            const SizedBox(
              height: 8,
            ),
             DefaultTextStyle(
              style: TextStyle(
                color: mainColor,
                fontFamily: 'Sans-serif',
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
              child: Text(title),
            ),
          ],
        ),
      ),
    ),
  ),
);
  }
}
