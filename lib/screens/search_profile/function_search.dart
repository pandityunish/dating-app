// import 'package:couple_match/screens/Search_profile/drink.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:ristey/country_modal/country_state_city_picker.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/screens/search_profile/age_search.dart';
import 'package:ristey/screens/search_profile/drink.dart';
import 'package:ristey/screens/search_profile/height_Screen.dart';

class functions {
  final RangeValues _currentRangeValues = const RangeValues(40, 80);
  final double _currentSliderValue = 0;
  final double _startValue = 20.0;
  final double _endValue = 90.0;
  var startValue = 0.0;
  var endValue = 0.0;
  int value = 2;
  List<int> valueList = [];
  Widget CustomRadioButton(String text, int index) {
    return ElevatedButton(
      onPressed: () {},
      style: ButtonStyle(
          padding: WidgetStateProperty.all<EdgeInsetsGeometry?>(
              const EdgeInsets.symmetric(horizontal: 50, vertical: 20)),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60.0),
                  side: BorderSide(
                      color: (value == index) ? mainColor : Colors.white))),
          backgroundColor: WidgetStateProperty.all<Color>(Colors.white)),
      child: Text(
        text,
        style: TextStyle(
          color: (value == index) ? mainColor : Colors.black,
        ),
      ),
    );
  }

  Future<void> AgeDialog(BuildContext context, var agelist) async {
    var res = await Navigator.of(context).push(MaterialPageRoute(
        builder: (builder) => AgeSelectionScreen(agelist: agelist)));
    print("$res hello");
    return res;
  }

  Future<void> HeightDialog(BuildContext context, var heightlist) async {
    var res = await Navigator.of(context).push(MaterialPageRoute(
        builder: (builder) => HeightScreens(
              heightlist: heightlist,
            )));
    return res;
  }

  Future<void> LocationDialog(BuildContext context, var locationlist) async {
    var res = await Navigator.of(context).push(MaterialPageRoute(
        builder: (builder) => SelectStateData(list: locationlist)));
    return res;
  }

  Future<void> DrinkDialog(BuildContext context, IconData icon, String head,
      List<String> options, List<String> selectedopt) async {
    if (selectedopt.isNotEmpty) {
      for (var i = 0; i < selectedopt.length; i++) {
        valueList.add(
            options.indexWhere((element) => selectedopt[i] == element) + 1);
      }
    }
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return
            // Flexible(
            //   child:
            StatefulBuilder(builder: (context, state) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    head,
                    style: GoogleFonts.poppins(
                        decoration: TextDecoration.none,
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w300),
                  ),
                  Icon(
                    icon,
                    color: Colors.black38,
                  )
                ],
              ),

              // content: Text('Drag the age bar to select your desired age group '),

              content: Drink(value: valueList, option: options),

              actions: [
                SizedBox(
                  width: 100,
                  height: 40,
                  child: ElevatedButton(
                      // textColor: Colors.black,
                      onPressed: () {
                        Navigator.of(context).pop("cancel");
                      },
                      style: ButtonStyle(
                          shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  side: const BorderSide(color: Colors.black))),
                          backgroundColor:
                              WidgetStateProperty.all<Color>(Colors.white)),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      )),
                ),
                SizedBox(
                  width: 100,
                  height: 40,
                  child: ElevatedButton(
                      // textColor: Colors.black,
                      onPressed: () {
                        List<String> ds = [];
                        for (var i = 0; i < valueList.length; i++) {
                          ds.add(options[valueList[i] - 1]);
                        }
                        Navigator.of(context).pop(ds);
                      },
                      style: ButtonStyle(
                          shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  side: const BorderSide(color: Colors.black))),
                          backgroundColor:
                              WidgetStateProperty.all<Color>(Colors.white)),
                      child: const Text(
                        'Accept',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      )),
                ),
              ],
            ),
          );
        });

        // );
      },
    );
  }
}
