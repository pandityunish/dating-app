// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class KundaliCircle extends StatelessWidget {
  final int percentage;
  final double match;
  const KundaliCircle({
    Key? key,
    required this.percentage,
    required this.match,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> allitems = [
      {"name": "Profile\n Match", "percentage": percentage, "total": 100},
      {"name": "Kundli\n Match", "percentage": match, "total": 36}
    ];
    return Container(
      width: 35,
      height: 35,
      decoration:
          const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      child: CarouselSlider.builder(
        options: CarouselOptions(
          height: 35,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 2),
          aspectRatio: 16 / 9,
          viewportFraction: 1,
        ),
        itemCount: allitems.length,
        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
            Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                allitems[itemIndex]["name"],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 7,
                  fontFamily: "Sans-serif",
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    allitems[itemIndex]["percentage"].toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 7,
                      fontFamily: "Sans-serif",
                    ),
                  ),
                  Text(
                    "/",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 8,
                      fontFamily: "Sans-serif",
                    ),
                  ),
                  Text(
                    allitems[itemIndex]["total"].toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 7,
                      fontFamily: "Sans-serif",
                    ),
                  ),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
