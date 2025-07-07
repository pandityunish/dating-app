import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomRoundedInputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String placeholder;
  final Color placeholderColor;
  final Color activeBorderColor;
  final Color inactiveBorderColor;
  final int length;
  final List<TextInputFormatter> inputFormatters;
  final Function(String) onChanged;

  const CustomRoundedInputField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.placeholder,
    required this.placeholderColor,
    required this.activeBorderColor,
    required this.inactiveBorderColor,
    required this.length,
    required this.inputFormatters,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CustomRoundedInputField> createState() =>
      _CustomRoundedInputFieldState();
}

class _CustomRoundedInputFieldState extends State<CustomRoundedInputField> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      setState(() {}); // Refresh border on focus change
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: SizedBox(
          height: 48,
          child: CupertinoTextField(
            maxLength: widget.length,
            inputFormatters: widget.inputFormatters,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            placeholder: widget.placeholder,
            placeholderStyle: TextStyle(color: widget.placeholderColor),
            controller: widget.controller,
            focusNode: widget.focusNode,
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.focusNode.hasFocus
                    ? widget.activeBorderColor
                    : widget.inactiveBorderColor,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            textInputAction: TextInputAction.next,
            onChanged: widget.onChanged,
          ),
        ),
      ),
    );
  }
}
