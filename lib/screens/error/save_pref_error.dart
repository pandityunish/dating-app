import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ristey/screens/search_pref/saved_pref.dart';

// import '../Assets/ayushWidget/big_text.dart';
// import 'search.dart';

class SavePreferencesError extends StatefulWidget {
  final bool isfirst;
  const SavePreferencesError({Key? key, required this.isfirst})
      : super(key: key);

  @override
  State<SavePreferencesError> createState() => _SavePreferencesErrorState();
}

class _SavePreferencesErrorState extends State<SavePreferencesError> {
  final TextEditingController _searchController = TextEditingController();
  final double _currentSliderValue = 0;
  final double _startValue = 20.0;
  final double _endValue = 90.0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        // navigationBar: CupertinoNavigationBar(
        //   middle: Row(
        //     children: [
        //       // Icon(
        //       //   Icons.chevron_left,
        //       //   size: 45,
        //       //   color: Colors.black,
        //       // ),
        //       BigText(
        //         text: "Save Preferences",
        //         size: 20,
        //         color: main_color,
        //         fontWeight: FontWeight.w700,
        //       )
        //     ],
        //   ),
        //   previousPageTitle: "",
        // ),
        child: SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.only(left: 10, right: 15),
        // child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 150),
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  image: const DecorationImage(
                      image: AssetImage("images/icons/save_pref_error.png"))),
            ),
            Container(
              margin: const EdgeInsets.only(left: 18, bottom: 150),
              child: Text(
                "Sorry! No Match Found Please Change Your Preferences For Better Results",
                style: GoogleFonts.poppins(
                    decoration: TextDecoration.none,
                    color: Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              ),
            ),
            // Container(
            //   margin: EdgeInsets.only(bottom: 50),
            //   alignment: Alignment.center,
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //         minimumSize: Size(200, 50),
            //         elevation: 0,
            //         shape: const RoundedRectangleBorder(
            //           borderRadius: BorderRadius.all(Radius.circular(50)),
            //         )),
            //     child: Text("Save Again"),
            //     onPressed: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => SearchPreferences()));
            //     },
            //   ),
            // ),
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                    shadowColor:
                        WidgetStateColor.resolveWith((states) => Colors.black),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      // side: BorderSide(color: Colors.black),
                    )),
                    backgroundColor:
                        WidgetStateProperty.all<Color>(Colors.white)),
                child: Text(
                  widget.isfirst == false ? "Save Again" : "Save Preference",
                  style: const TextStyle(
                    fontFamily: 'Serif',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchPreferences()));
                },
              ),
            ),
          ],
        ),
        // ),
      ),
    ));
  }
}
