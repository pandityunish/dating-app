import 'package:flutter/material.dart';
import 'package:ristey/chat/colors.dart';
import 'package:ristey/global_vars.dart';

class SnackBarContent extends StatefulWidget {
  const SnackBarContent(
      {super.key,
      required this.error_text,
      required this.appreciation,
      required this.icon,
      required this.sec});
  final error_text;
  final appreciation;
  final IconData icon;
  final sec;

  @override
  State<SnackBarContent> createState() => _SnackBarContentState();
}

class _SnackBarContentState extends State<SnackBarContent> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: widget.sec), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
      
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        
            Icon(
              widget.icon,
              size: 55.0,
              color: mainColor,
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.appreciation,
                style: TextStyle(
                    fontSize: (widget.appreciation == "" ||
                            widget.appreciation == null)
                        ? 0
                        : 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.error_text,
                    style: const TextStyle(
                        fontSize: 14, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ]),
                SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }
}

class SnackBarContent3 extends StatefulWidget {
  const SnackBarContent3(
      {super.key,
      required this.error_text,
      required this.appreciation,
      required this.icon});
  final error_text;
  final appreciation;
  final IconData icon;

  @override
  State<SnackBarContent3> createState() => _SnackBarContent3State();
}

class _SnackBarContent3State extends State<SnackBarContent3> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: mainColor),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          widget.icon,
                          size: 35.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        widget.appreciation,
                        style: const TextStyle(
                            fontSize: 1,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.error_text,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SnackBarContent2 extends StatefulWidget {
  const SnackBarContent2(
      {super.key, required this.error_text, required this.icon});
  final error_text;
  final IconData icon;

  @override
  State<SnackBarContent2> createState() => _SnackBarContent2State();
}

class _SnackBarContent2State extends State<SnackBarContent2> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: mainColor),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          widget.icon,
                          size: 35.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text.rich(TextSpan(
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Arial'),
                          children: [
                            const TextSpan(
                                text: "Couple",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Arial')),
                            TextSpan(
                                text: "match",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: mainColor,
                                    fontFamily: 'Arial')),
                          ])),
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.error_text,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
