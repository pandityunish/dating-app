// import 'package:couple_match/screens/navigation/blink_component.dart';
import 'package:flutter/material.dart';

import 'package:ristey/global_vars.dart';
import 'package:ristey/screens/navigation/blinking_component.dart';
import 'dart:async';
import 'package:flutter/material.dart';


class Box extends StatelessWidget {
   Box({
    super.key,
    this.width,
    this.currentusertext,
    // ignore: non_constant_identifier_names
    required this.box_text,
    required this.icon,
    this.fixedWidth = 120.0, // Default fixed width for the box
  });
  // ignore: prefer_typing_uninitialized_variables
  final width;
  // ignore: non_constant_identifier_names, prefer_typing_uninitialized_variables
  final box_text;
  // ignore: prefer_typing_uninitialized_variables
  final icon;
  final double fixedWidth; // Fixed width for the box
  String? currentusertext;
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

    final textWidth = textPainter.maxIntrinsicWidth+18;

    // Set maximum width to 80 pixels
    const maxContainerWidth = 80.0;
    // Calculate the actual width needed for the text plus icon and padding
    final requiredWidth = textWidth + 32.0; // 32 = icon (16) + padding (16)
    // Calculate if text exceeds available text width (container width minus icon and padding)
    final availableTextWidth = maxContainerWidth - 32.0; // 32 = icon (16) + padding (16)
    final shouldUseTickerText = textWidth > availableTextWidth;
    
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxContainerWidth, // Maximum width of 80 pixels
        minWidth: requiredWidth < maxContainerWidth ? requiredWidth : maxContainerWidth, // Use required width if smaller than max
      ),
      child: IntrinsicWidth(
        stepWidth: 1.0, // Force intrinsic width calculation to be more precise
        child: Container(
          margin: const EdgeInsets.only(bottom: 1.5, right: 2),
          height: MediaQuery.of(context).size.height * 0.024,
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
                Expanded(
                  child: shouldUseTickerText
                    ? MarqueeText(
                        text: box_text,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: mainColor,
                        ),
                      )
                    : Text(
                        box_text,
                        // No overflow ellipsis
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: mainColor,
                        ),
                      ),
                ),
                box_text == currentusertext ? const BlinkingDonecreen() : const Center()
            ],
          ),
        ),
      ),
    ));
  }
}

// Custom Marquee Text widget for ticker effect
class MarqueeText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration speed;
  final Duration pauseBetween;

  const MarqueeText({
    Key? key,
    required this.text,
    required this.style,
    this.speed = const Duration(milliseconds: 50),
    this.pauseBetween = const Duration(seconds: 1),
  }) : super(key: key);

  @override
  _MarqueeTextState createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText> with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late Timer _timer;
  bool _isPaused = false;
  
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startMarquee();
    });
  }
  
  void _startMarquee() {
    _timer = Timer.periodic(widget.speed, (timer) {
      if (_scrollController.hasClients) {
        if (_isPaused) return;
        
        final maxScrollExtent = _scrollController.position.maxScrollExtent;
        final currentPosition = _scrollController.offset;
        
        if (currentPosition >= maxScrollExtent) {
          _isPaused = true;
          Future.delayed(widget.pauseBetween, () {
            if (mounted) {
              _scrollController.jumpTo(0.0);
              _isPaused = false;
            }
          });
        } else {
          _scrollController.animateTo(
            currentPosition + 2.0,
            duration: widget.speed,
            curve: Curves.linear,
          );
        }
      }
    });
  }
  
  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      physics: const NeverScrollableScrollPhysics(),
      child: Text(
        widget.text,
        style: widget.style,
      ),
    );
  }
}
