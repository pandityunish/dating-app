import 'dart:async';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color mainColor;
  final bool colorDone;
  final TextStyle? textStyle;
  final double? width;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.mainColor = Colors.blue,
    this.colorDone = false,
    this.textStyle,
    this.width,
    this.padding,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool showBorderHighlight = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? MediaQuery.of(context).size.width * 0.9,
      height: 48,
      child: ElevatedButton(
        style: ButtonStyle(
          shadowColor: MaterialStateProperty.resolveWith(
              (states) => Colors.black),

          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60.0),
              side: BorderSide(
                color: showBorderHighlight
                    ? widget.mainColor
                    : (!widget.colorDone)
                        ? Colors.white
                        : widget.mainColor,
                width: showBorderHighlight ? 2.0 : 1.0,
              ),
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ),
        onPressed: () {
          // Show border highlight temporarily
          setState(() {
            showBorderHighlight = true;
          });
          
          // Reset border highlight after a millisecond
          Timer(const Duration(milliseconds: 400), () {
            if (mounted) {
              setState(() {
                showBorderHighlight = false;
              });
            }
          });
          
          widget.onPressed();
        },
        child: Text(
          widget.text,
          style: widget.textStyle ??
            (!widget.colorDone
              ?  TextStyle(
                  color: showBorderHighlight?widget.mainColor: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Serif')
              : TextStyle(
                  color: widget.mainColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Serif')),
        ),
      ),
    );
  }
}
