import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/screens/search.dart';

class SearchProfileError extends StatefulWidget {
  final bool issearchempty;
  const SearchProfileError({Key? key, required this.issearchempty})
      : super(key: key);

  @override
  State<SearchProfileError> createState() => _SearchProfileErrorState();
}

class _SearchProfileErrorState extends State<SearchProfileError> {
  final TextEditingController _searchController = TextEditingController();
  final double _currentSliderValue = 0;
  final double _startValue = 20.0;
  final double _endValue = 90.0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: widget.issearchempty == true
                ? const Center()
                : Icon(
                    Icons.arrow_back_ios_new,
                    color: mainColor,
                    size: 25,
                  ),
          ),
          middle: Row(
            children: [
              // Icon(
              //   Icons.chevron_left,
              //   size: 45,
              //   color: Colors.black,
              // ),
              BigText(
                text: "Search Profile",
                size: 20,
                color: mainColor,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          previousPageTitle: "",
        ),
        child: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.only(left: 10, right: 15),
            // child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 150),
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            image: const DecorationImage(
                                image:
                                    AssetImage("images/icons/save_pref_error.png"))),
                      ),
                      SizedBox(height: 30,), 
                      Container(
                        margin: const EdgeInsets.only(left: 18, bottom: 120),
                        child: const Text(
                            "Sorry! No Match Found. Please Change your Search Criteria for Better Results",
                            textAlign: TextAlign.center ,
                            style: TextStyle(
                              
                                decoration: TextDecoration.none,
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Sans-serif')),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shadowColor: WidgetStateColor.resolveWith(
                            (states) => Colors.black),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          // side: BorderSide(color: Colors.black),
                        )),
                        backgroundColor:
                            WidgetStateProperty.all<Color>(Colors.white)),
                    child: const Text(
                      "Search Again",
                      style: TextStyle(
                        fontFamily: 'Serif',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Search()),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
            // ),
          ),
        ));
  }
}
