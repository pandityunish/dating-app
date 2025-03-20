// import 'package:couple_match/globalVars.dart';
import 'package:flutter/material.dart';
import 'package:ristey/global_vars.dart';

class BlinkingColorScreen extends StatefulWidget {
  const BlinkingColorScreen({super.key});

  @override
  _BlinkingColorScreenState createState() => _BlinkingColorScreenState();
}

class _BlinkingColorScreenState extends State<BlinkingColorScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500), // duration for one cycle
      vsync: this,
    )..repeat(reverse: true); // repeat the animation in reverse

    // Initialize the ColorTween animation
    _colorAnimation = ColorTween(
      begin: const Color.fromARGB(255, 0, 161, 5), // starting color
      end: Colors.white, // ending color
    ).animate(_controller);
  }

  @override
  void dispose() {
    // Dispose the controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _colorAnimation,
        builder: (context, child) {
          return Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                color: _colorAnimation.value, shape: BoxShape.circle),
          );
        },
      ),
    );
  }
}

class BlinkingDonecreen extends StatefulWidget {
  const BlinkingDonecreen({super.key});

  @override
  _BlinkingDonecreenState createState() => _BlinkingDonecreenState();
}

class _BlinkingDonecreenState extends State<BlinkingDonecreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000), // duration for one cycle
      vsync: this,
    )..repeat(reverse: true); // repeat the animation in reverse

    // Initialize the ColorTween animation
    _colorAnimation = ColorTween(
      begin: mainColor, // starting color
      end: Colors.white, // ending color
    ).animate(_controller);
  }

  @override
  void dispose() {
    // Dispose the controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _colorAnimation,
        builder: (context, child) {
          return Icon(
            Icons.done,
            color: _colorAnimation.value,
            size: 14,
          );
        },
      ),
    );
  }
}

class BlinkingNumber extends StatefulWidget {
  final Color color;
  final String number;

  const BlinkingNumber({super.key, required this.color, required this.number});
  @override
  _BlinkingNumberState createState() => _BlinkingNumberState();
}

class _BlinkingNumberState extends State<BlinkingNumber>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500), // duration for one cycle
      vsync: this,
    )..repeat(reverse: true); // repeat the animation in reverse

    // Initialize the ColorTween animation
    _colorAnimation = ColorTween(
      begin: widget.color, // starting color
      end: Colors.white, // ending color
    ).animate(_controller);
  }

  @override
  void dispose() {
    // Dispose the controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _colorAnimation,
        builder: (context, child) {
          return Container(
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
                color: _colorAnimation.value, shape: BoxShape.circle),
            constraints: const BoxConstraints(
              minWidth: 8.0,
              minHeight: 8.0,
            ),
            child: Center(
                child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                widget.number,
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),
            )),
          );
          //  Icon(Icons.done,color: _colorAnimation.value,size: 14,);
        },
      ),
    );
  }
}
