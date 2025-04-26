import 'dart:convert';

import 'package:age_calculator/age_calculator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

// import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;

import 'package:geocoding/geocoding.dart' as location3;
import 'package:ristey/assets/calendar.dart';
import 'package:ristey/chat/colors.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/ads_modal.dart';
import 'package:ristey/models/location_modal.dart';
import 'package:ristey/models/model_location.dart';
import 'package:ristey/screens/data_collection/custom_appbar.dart';
import 'package:ristey/screens/navigation/kundali_match_data.dart';
import 'package:ristey/screens/navigation/service/ads_service.dart';
import 'package:ristey/screens/notification/widget_notification/ads_bar.dart';
import 'package:ristey/services/add_to_profile_service.dart';
import 'package:ristey/services/search_service.dart';

import '../../Assets/Error.dart';

import '../profile/service/notification_service.dart';

List<String> list1 = <String>[
  'Year',
  '1990',
  '1991',
  '1992',
  '1993',
  '1994',
  '1995',
  '1996',
  '1997',
  '1998',
  '1999',
  '2000',
  '2001',
  '2002',
  '2003',
  '2004',
  '2005',
  '2006',
  '2007',
  '2008',
  '2009',
  '2010',
  '2011',
  '2012',
  '2013',
  '2014',
  '2015',
  '2016',
  '2017',
  '2018',
  '2019',
  '2020',
  '2021',
  '2022',
  '2023',
  '2024'
]; //'2000',
List<String> list2 = <String>['Date', 'Two', 'Three', 'Four'];
List<String> list3 = <String>[
  'Month',
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];
List<String> list4 = <String>['Date'];

List<String> list5 = <String>[
  'Date',
  '01',
  '02',
  '03',
  '04',
  '05',
  '06',
  '07',
  '08',
  '09',
  '10',
  '11',
  '12',
  '13',
  '14',
  '15',
  '16',
  '17',
  '18',
  '19',
  '20',
  '21',
  '22',
  '23',
  '24',
  '25',
  '26',
  '27',
  '28',
  '29',
  '30'
];
List<String> timeofbirth = <String>[
  '01',
  '02',
  '03',
  '04',
  '05',
  '06',
  '07',
  '08',
  '09',
  '10',
  '11',
  '12',
  '13',
  '14',
  '15',
  '16',
  '17',
  '18',
  '19',
  '20',
  '21',
  '22',
  '23',
  '24',
  '25',
  '26',
  '27',
  '28',
  '29',
  '30'
];
List<String> list6 = <String>[
  'Date',
  '01',
  '02',
  '03',
  '04',
  '05',
  '06',
  '07',
  '08',
  '09',
  '10',
  '11',
  '12',
  '13',
  '14',
  '15',
  '16',
  '17',
  '18',
  '19',
  '20',
  '21',
  '22',
  '23',
  '24',
  '25',
  '26',
  '27',
  '28',
  '29'
];

List<String> list7 = <String>[
  'Date',
  '01',
  '02',
  '03',
  '04',
  '05',
  '06',
  '07',
  '08',
  '09',
  '10',
  '11',
  '12',
  '13',
  '14',
  '15',
  '16',
  '17',
  '18',
  '19',
  '20',
  '21',
  '22',
  '23',
  '24',
  '25',
  '26',
  '27',
  '28'
];

class DataLocation {
  final String countryname;
  final String countrycity;
  final String countrystate;
  DataLocation({
    required this.countryname,
    required this.countrycity,
    required this.countrystate,
  });
}

List<String> list8 = <String>['Date'];

class KundliMatch extends StatefulWidget {
  const KundliMatch({super.key});

  @override
  State<KundliMatch> createState() => _KundliMatchState();
}

class _KundliMatchState extends State<KundliMatch>
    with SingleTickerProviderStateMixin {
  // GoogleMapsPlaces _places =
  //     GoogleMapsPlaces(apiKey: 'AIzaSyBgldLriecKqG8pYkQIUX5CI72rUREhIrQ');
  final _searchController = TextEditingController();
  final _searchController2 = TextEditingController();
  String? location;
  String? location2;
  DateDuration? duration;
  DateDuration? dateOfBirth;
  // late Future<List<ModelLocation>> _futurePersons;
  var height_suggest1 = 0.0;
  var height_suggest2 = 0.0;
  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  bool _isFocused = false;
  int mdate = 1;
  List<DataLocation> alllist = [];
  List<LocationModel> alllocations = [];
  void getalllocation() async {
    alllocations = await Searchservice().getData();
    setState(() {});
  }

  void _fileterlocation(String query) {
    alllist.clear();
    print(query);
    height_suggest1 = 200;
    for (var country in alllocations) {
      for (var state in country.state) {
        for (var city in state.city) {
          if (city.name.toLowerCase().contains(query.toLowerCase())) {
            alllist.add(DataLocation(
                countryname: country.name,
                countrycity: city.name,
                countrystate: state.name));
          }
        }
      }
    }
    setState(() {});
  }

  void _fileterlocation2(String query) {
    alllist.clear();
    print(query);
    height_suggest2 = 200;
    for (var country in alllocations) {
      for (var state in country.state) {
        for (var city in state.city) {
          if (city.name.toLowerCase().contains(query.toLowerCase())) {
            alllist.add(DataLocation(
                countryname: country.name,
                countrycity: city.name,
                countrystate: state.name));
          }
        }
      }
    }
    setState(() {});
  }

  int mmonth = 1;
  int myear = 1;
  int fdate = 1;
  int fmonth = 1;
  int fyear = 1;
  List<AdsModel> userads = [];
  List<AdsModel> userkundliads = [];
  void getads() async {
    userads = await AdsService().getallusers(adsid: "59");
    userkundliads = adsuser.where((element) => element.adsid == "59").toList();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getads();
    _focusNode.addListener(_onFocusChange);
    getalllocation();
    // _futurePersons = Searchservice().getData();
    setState(() {});
    _focusNode2.addListener(() {
      _onFocusChange2;
    });
  }

  List<DataLocation> list = [];

  List<ModelLocation> _filterPersons(
      List<ModelLocation> persons, String query) {
    query = query.toLowerCase();
    // list.clear();
    // height_suggest1=200;

    return persons.where((person) {
      final name = person.city.toLowerCase();
      final city = person.city.toLowerCase();
      return name.contains(query) || city.contains(query);
    }).toList();
  }

  updateMaleDate(var date, var month, var year) {
    mdate = date;
    mmonth = month;
    myear = year;
  }

  updateFemaleDate(var date, var month, var year) {
    fdate = date;
    fmonth = month;
    fyear = year;
  }

  void _onFocusChange() {
    if (_isFocused) {
      if (!mounted) return;

      setState(() {
        height_suggest1 = 0.0;
      });
    }
    if (!mounted) return;
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _onFocusChange2() {
    if (_isFocused) {
      if (!mounted) return;
      setState(() {
        height_suggest2 = 0.0;
      });
    }
    if (!mounted) return;
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  // List<Prediction> _predictions = [];
  // List<Prediction> _predictions2 = [];
  // void _onSearchChanged(String value) async {
  //   if (value.isNotEmpty) {
  //     var response = await _places.autocomplete(value);
  //     if (!mounted) return;
  //     setState(() {
  //       _predictions = response.predictions;
  //       height_suggest1 = 200;
  //     });
  //   }
  // }

  // void _onSearchChanged2(String value) async {
  //   if (value.isNotEmpty) {
  //     var response = await _places.autocomplete(value);
  //     if (!mounted) return;
  //     setState(() {
  //       _predictions2 = response.predictions;
  //       height_suggest2 = 200;
  //     });
  //   }
  // }

  var latf;
  var lngf;
  var latm;
  var lngm;
  TextEditingController birthPlaceController = TextEditingController();
  TextEditingController birthPlaceController2 = TextEditingController();
  // void _onSelectedPlace(Prediction prediction) async {
  //   var placeDetail = await _places.getDetailsByPlaceId(prediction.placeId!);
  //   latm = placeDetail.result.geometry?.location.lat;
  //   lngm = placeDetail.result.geometry?.location.lng;

  //   // TODO: Use the lat/lng to display the selected place on the map or save it to your database
  //   if (!mounted) return;
  //   setState(() {
  //     _searchController.text = prediction.description!;
  //     location = prediction.description!;
  //     birthPlaceController.text = location!;
  //     // _predictions.clear();
  //   });
  // }

  void _onSelectedPlace3(DataLocation prediction) async {
    String somelocation =
        "${prediction.countryname},${prediction.countrystate},${prediction.countrycity}";
    List<location3.Location> locations =
        await locationFromAddress(somelocation);
    latm = locations[0].latitude;
    lngm = locations[0].longitude;
    // TODO: Use the lat/lng to display the selected place on the map or save it to your database
    if (!mounted) return;
    setState(() {
      _searchController.text = prediction.countrycity!;
      location =
          "${prediction.countrycity},${prediction.countrystate ?? ""},${prediction.countryname}";
      birthPlaceController.text = location!;
      // _predictions.clear();
    });
  }

  void _onSelectedPlace4(DataLocation prediction) async {
    String somelocation =
        "${prediction.countryname},${prediction.countrystate},${prediction.countrycity}";
    List<location3.Location> locations =
        await locationFromAddress(somelocation);
    print(locations[0].latitude);
    print(locations[0].longitude);
    latf = locations[0].latitude;
    lngf = locations[0].longitude;

    if (!mounted) return;
    setState(() {
      _searchController2.text = prediction.countrycity!;
      location2 =
          "${prediction.countrycity},${prediction.countrystate ?? ""},${prediction.countrycity}";
      birthPlaceController2.text = location2!;
      // _predictions2.clear();
    });
  }

  // void _onSelectedPlace2(Prediction prediction) async {
  //   var placeDetail = await _places.getDetailsByPlaceId(prediction.placeId!);
  //   latf = placeDetail.result.geometry?.location.lat;
  //   lngf = placeDetail.result.geometry?.location.lng;

  //   // TODO: Use the lat/lng to display the selected place on the map or save it to your database
  //   if (!mounted) return;
  //   setState(() {
  //     _searchController2.text = prediction.description!;
  //     location2 = prediction.description!;
  //     birthPlaceController2.text = location2!;
  //     _predictions2.clear();
  //   });
  // }

  var containerHeight;

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _searchController2.dispose();
    _focusNode2.removeListener(_onFocusChange);
    _focusNode2.dispose();
    super.dispose();
  }

  DateTime? dateTime;
  void pickdate() async {
    dateTime = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2025));
    if (!mounted) return;
    setState(() {});
  }

  String dropdownValuem1 = list1.first;
  String dropdownValuem2 = list2.first;
  String dropdownValuem3 = list3.first;
  String dropdownValuem4 = list8.first;
  String dropdownValuef1 = list1.first;
  String dropdownValuef2 = list2.first;
  String dropdownValuef3 = list3.first;
  String dropdownValuef4 = list8.first;
  // String? mmonth;
  // String? fmonth;

  String categoty = "AM";
  List<String> porductCategories = ["AM", "PM"];
  List<String> dayCategories = ["AM", "PM"];
  List<String> monthCategories = ["AM", "PM"];
  List<String> yearCategories = ["AM", "PM"];
  TextEditingController groomnamecontroller = TextEditingController();
  TextEditingController bridenamecontroller = TextEditingController();

  //Time COde

  String? mselectedHour;
  String? mselectedMinute;
  String mselectedAMPM = "AM";

  void saveSelectedValues() {
    int hour = int.parse(mselectedHour ?? "00");
    if (mselectedAMPM == "PM" && hour != 12) {
      hour += 12;
    } else if (mselectedAMPM == "AM" && hour == 12) {
      hour = 0;
    }
    int minute = int.parse(mselectedMinute ?? "00");
    print("Selected Hour: $hour");
    print("Selected Minute: $minute");
  }

  String? fselectedHour;
  String? fselectedMinute;
  String fselectedAMPM = "AM";

  void fsaveSelectedValues() {
    int hour = int.parse(fselectedHour ?? "01");
    if (fselectedAMPM == "PM" && hour != 12) {
      hour += 12;
    } else if (fselectedAMPM == "AM" && hour == 12) {
      hour = 0;
    }
    int minute = int.parse(fselectedMinute ?? "00");
    print("Selected Hour: $hour");
    print("Selected Minute: $minute");
  }

  @override
  Widget build(BuildContext context) {
    double bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          appBar: CustomAppBar(title: "Kundli Match", iconImage: 'images/icons/kundli.png') ,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            const Padding(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: Text(
                                "Groom Information",
                                style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontFamily: 'Sans-serif',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: TextFormField(
                                controller: groomnamecontroller,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter your name";
                                  }
                                  return null;
                                },
                                decoration:  InputDecoration(
                                    hintText: "Enter Groom's Name",
                                    hintStyle: TextStyle(color: newtextColor),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(10)),
                              ),
                            ),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            const Padding(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: Text(
                                "Date Of Birth",
                                style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontFamily: 'Sans-serif',
                                  color: Color(0xFF333333),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                ),
                              ),
                            ),

                            Calender(
                              useTwentyOneYears: true,
                              setdate: updateMaleDate,
                            ),

                            const Padding(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: Text(
                                "Time Of Birth",
                                style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontFamily: 'Sans-serif',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Card(
                                  elevation: 4,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  child: SizedBox(
                                    height: 46,
                                    width: MediaQuery.of(context).size.width *
                                        0.29,
                                    child: Center(
                                      child: DropdownButton<String>(
                                        underline: Container(
                                          color: Colors.white,
                                        ),
                                        value: mselectedHour,
                                        iconEnabledColor: newtextColor,

                                        hint:  Text(
                                          "Hour",
                                          style: TextStyle(color: newtextColor),
                                        ),
                                        onChanged: (value) {
                                          if (!mounted) return;
                                          setState(() {
                                            mselectedHour = value!;
                                            saveSelectedValues();
                                          });
                                        },
                                        items: List.generate(12, (int index) {
                                          String minute =
                                              index.toString().padLeft(2, '0');
                                          return DropdownMenuItem<String>(
                                            value: minute,
                                            child: Text(minute),
                                          );
                                        }),
                                      ),
                                      //  DropdownButton<String>(
                                      //   underline: Container(
                                      //     color: Colors.white,
                                      //   ),
                                      //   value: mselectedHour,
                                      //   onChanged: (value) {
                                      //     if (!mounted) return;
                                      //     setState(() {
                                      //       mselectedHour = value!;
                                      //       saveSelectedValues();
                                      //     });
                                      //   },
                                      //   items: List.generate(60, (int index) {

                                      //      String hour =
                                      //         index.toString().padLeft(2, '0');
                                      //     return DropdownMenuItem<String>(
                                      //       value: hour,
                                      //       child: Text(hour),
                                      //     );
                                      //   }),
                                      // ),
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 4,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  child: SizedBox(
                                    height: 46,
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Center(
                                      child: DropdownButton<String>(
                                        underline: Container(
                                          color: Colors.white,
                                        ),
                                        value: mselectedMinute,
                                        iconEnabledColor: newtextColor,
                                        hint:  Text(
                                          "Minute",
                                          style: TextStyle(color: newtextColor),
                                        ),
                                        onChanged: (value) {
                                          if (!mounted) return;
                                          setState(() {
                                            mselectedMinute = value!;
                                            saveSelectedValues();
                                          });
                                        },
                                        items: List.generate(60, (int index) {
                                          String minute =
                                              index.toString().padLeft(2, '0');
                                          return DropdownMenuItem<String>(
                                            value: minute,
                                            child: Text(minute),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Container(
                                    height: 46,
                                    width: MediaQuery.of(context).size.width *
                                        0.29,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Center(
                                      child: DropdownButton<String>(
                                        underline: Container(
                                          color: Colors.white,
                                        ),
                                        value: mselectedAMPM,
                                        iconEnabledColor: newtextColor,

                                        onChanged: (value) {
                                          if (!mounted) return;
                                          setState(() {
                                            mselectedAMPM = value!;
                                            saveSelectedValues();
                                          });
                                        },
                                        items: <DropdownMenuItem<String>>[
                                           DropdownMenuItem<String>(
                                            value: "AM",
                                            child: Text("AM",style: TextStyle(color: newtextColor),),
                                          ),
                                           DropdownMenuItem<String>(
                                            value: "PM",
                                            child: Text("PM",style: TextStyle(color: newtextColor),),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: TextFormField(
                                controller: birthPlaceController,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.name,
                                onChanged: (value) {
                                  // _onSearchChanged(value);
                                  _fileterlocation(value);
                                  setState(() {});
                                },
                                focusNode: _focusNode,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    setState(() {
                                      height_suggest1 = 0.0;
                                    });
                                    return "Enter your name";
                                  }
                                  return location;
                                },
                                decoration:  InputDecoration(
                                    hintText: "Enter Place of Birth",
                                    border: InputBorder.none,
                                        hintStyle: TextStyle(color: newtextColor),

                                    contentPadding: EdgeInsets.all(10)),
                              ),
                            ),
                            Stack(
                              children: [
                                const SizedBox(height: 1),
                                Container(
                                  height: height_suggest1,
                                  child: Card(
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: alllist.length,
                                      itemBuilder: (context, index) {
                                        return SingleChildScrollView(
                                          child: ListTile(
                                              title: Text(
                                                  "${alllist[index].countrycity},${alllist[index].countrystate ?? ""},${alllist[index].countryname}"),
                                              onTap: () {
                                                _onSelectedPlace3(
                                                    alllist[index]);
                                                if (!mounted) return;
                                                setState(() {
                                                  height_suggest1 = 0.0;
                                                });
                                              }),
                                        );
                                      },
                                    ),
                                    // }
                                    // }),
                                  ),
                                ),
                              ],
                            ),

                            const Padding(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              // padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Bride Information",
                                style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontFamily: 'Sans-serif',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: TextFormField(
                                controller: bridenamecontroller,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter your name";
                                  }
                                  return null;
                                },
                                decoration:  InputDecoration(
                                    hintText: "Enter Bride's Name",
                                    border: InputBorder.none,
                                        hintStyle: TextStyle(color: newtextColor),

                                    contentPadding: EdgeInsets.all(10)),
                              ),
                            ),

                            const Padding(
                              // padding: const EdgeInsets.all(8.0),
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: Text(
                                "Date of Birth",
                                style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontFamily: 'Sans-serif',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Calender(
                              useTwentyOneYears: false,
                              setdate: updateFemaleDate,
                            ),
                            const Padding(
                              // padding: const EdgeInsets.all(8.0),
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: Text(
                                "Time of Birth",
                                style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontFamily: 'Sans-serif',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                ),
                              ),
                            ),

                            Row(
                              children: [
                                Card(
                                  elevation: 4,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  child: SizedBox(
                                    height: 46,
                                    width: MediaQuery.of(context).size.width *
                                        0.29,
                                    child: Center(
                                      child: DropdownButton<String>(
                                        underline: Container(
                                          color: Colors.white,
                                        ),
                                        value: fselectedHour,
                                        hint:  Text(
                                          "Hour",
                                          style: TextStyle(color: newtextColor),
                                        ),
                                        onChanged: (value) {
                                          if (!mounted) return;
                                          setState(() {
                                            fselectedHour = value!;
                                            fsaveSelectedValues();
                                          });
                                        },
                                        items: List.generate(12, (int index) {
                                          String minute =
                                              index.toString().padLeft(2, '0');
                                          return DropdownMenuItem<String>(
                                            value: minute,
                                            child: Text(minute),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 4,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  child: SizedBox(
                                    height: 46,
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Center(
                                      child: DropdownButton<String>(
                                        underline: Container(
                                          color: Colors.white,
                                        ),
                                        value: fselectedMinute,
                                        hint: Text(
                                          "Minute",
                                          style: TextStyle(color: newtextColor),
                                        ),
                                        onChanged: (value) {
                                          if (!mounted) return;
                                          setState(() {
                                            fselectedMinute = value!;
                                            fsaveSelectedValues();
                                          });
                                        },
                                        items: List.generate(60, (int index) {
                                          String minute =
                                              index.toString().padLeft(2, '0');
                                          return DropdownMenuItem<String>(
                                            value: minute,
                                            child: Text(minute),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Container(
                                    height: 46,
                                    width: MediaQuery.of(context).size.width *
                                        0.29,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Center(
                                      child: DropdownButton<String>(
                                        underline: Container(
                                          color: Colors.white,
                                        ),
                                        value: fselectedAMPM,
                                        onChanged: (value) {
                                          if (!mounted) return;
                                          setState(() {
                                            fselectedAMPM = value!;
                                            fsaveSelectedValues();
                                          });
                                        },
                                        items: <DropdownMenuItem<String>>[
                                           DropdownMenuItem<String>(
                                            value: "AM",
                                            child: Text("AM",style: TextStyle(color: newtextColor),),
                                          ),
                                           DropdownMenuItem<String>(
                                            value: "PM",
                                            child: Text("PM",style: TextStyle(color: newtextColor),),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    top: 1.0,
                                    left: 1.0,
                                    right: 1.0,
                                  ),
                                  child: TextFormField(
                                    scrollPadding: EdgeInsets.only(
                                        bottom: bottomInsets + 40.0),
                                    controller: birthPlaceController2,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.name,
                                    onChanged: (value) {
                                      _fileterlocation2(value);
                                      setState(() {});
                                    },
                                    focusNode: _focusNode2,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        setState(() {
                                          height_suggest2 = 0.0;
                                        });
                                        return "Enter your birth place";
                                      }
                                      return location2;
                                    },
                                    decoration:  InputDecoration(
                                        hintText: "Enter Place of Birth",
                                        hintStyle: TextStyle(color: newtextColor),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.all(10)),
                                  ),
                                )),
                            Stack(
                              children: [
                                const SizedBox(
                                  height: 1,
                                ),
                                SizedBox(
                                  height: height_suggest2,
                                  child: Card(
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: alllist.length,
                                      itemBuilder: (context, index) {
                                        return SingleChildScrollView(
                                          child: ListTile(
                                              title: Text(
                                                  "${alllist[index].countrycity},${alllist[index].countrystate ?? ""},${alllist[index].countryname}"),
                                              onTap: () {
                                                _onSelectedPlace4(
                                                    alllist[index]);
                                                if (!mounted) return;
                                                setState(() {
                                                  height_suggest2 = 0.0;
                                                });
                                              }),
                                        );
                                      },
                                    ),
                                    // }
                                    // }),
                                  ),
                                ),
                              ],
                            ),

                            // SizedBox(height: _animation.value),
                          ]),
                      // SizedBox(height:10,),
                      Container(
                        margin: const EdgeInsets.only(
                          top: 18,
                        ),
                        child: Center(
                          child: SizedBox(
                            width: Get.width,
                            height: 50,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  shadowColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.black),
                                  // padding:
                                  //     MaterialStateProperty.all<EdgeInsetsGeometry?>(
                                  //         EdgeInsets.symmetric(vertical: 17)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60.0),
                                  )),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white)),
                              child: const Text(
                                "Match",
                                style: TextStyle(
                                  fontFamily: 'Serif',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                              onPressed: () async {
                                if (groomnamecontroller.text != null &&
                                    groomnamecontroller.text != '' &&
                                    bridenamecontroller.text != null &&
                                    bridenamecontroller.text != '' &&
                                    mmonth != null &&
                                    mmonth != '' &&
                                    fmonth != null &&
                                    fmonth != '' &&
                                    mdate != null &&
                                    mdate != '' &&
                                    fdate != null &&
                                    fdate != '' &&
                                    myear != null &&
                                    myear != '' &&
                                    fyear != null &&
                                    fyear != '' &&
                                    mselectedHour != null &&
                                    mselectedHour != '' &&
                                    fselectedHour != null &&
                                    fselectedHour != '' &&
                                    mselectedMinute != null &&
                                    mselectedMinute != '' &&
                                    fselectedMinute != null &&
                                    fselectedMinute != '' &&
                                    location != null &&
                                    location != '' &&
                                    location2 != null &&
                                    location2 != '' &&
                                    latm != null &&
                                    latm != '' &&
                                    lngm != null &&
                                    lngm != '' &&
                                    latf != null &&
                                    latf != '' &&
                                    lngf != null &&
                                    lngf != '') {
                                  var data;
                                  print(mselectedHour);
                                  var url = Uri.parse(
                                      'https://api.kundali.astrotalk.com/v1/combined/match_making');
                                  print(userSave.latitude);
                                  print(userSave.longitude);
                                  var payload = {
                                    "m_detail": {
                                      "day": mdate,
                                      "hour": mselectedHour,
                                      "lat": latm,
                                      "lon": lngm,
                                      "min": mselectedMinute,
                                      "month": mmonth,
                                      "name": groomnamecontroller.text,
                                      "tzone": "5.5",
                                      "year": myear,
                                      "gender": "male",
                                      "place": location,
                                      "sec": 0
                                    },
                                    "f_detail": {
                                      "day": fdate,
                                      "hour": fselectedHour,
                                      "lat": latf,
                                      "lon": lngf,
                                      "min": fselectedMinute,
                                      "month": fmonth,
                                      "name": bridenamecontroller.text,
                                      "tzone": "5.5",
                                      "year": fyear,
                                      "gender": "female",
                                      "place": location2,
                                      "sec": 0
                                    },
                                    "languageId": 1
                                  };

                                  var body = json.encode(payload);

                                  var response = await http.post(url,
                                      body: body,
                                      headers: {
                                        'Content-Type': 'application/json'
                                      });
                                  print("*********************");
                                  print(response.body);
                                  print("*********************");
                                  if (response.statusCode == 200) {
                                    if (!mounted) return;
                                    setState(() {
                                      data = json.decode(response.body);
                                    });
                                    print(data["ashtkoot"]["varna"]
                                        ["description"]);
                                  } else {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return const AlertDialog(
                                            content: SnackBarContent(
                                              error_text:
                                                  "Please Select Different Date And Time",
                                              appreciation: "",
                                              icon: Icons.error,
                                              sec: 1,
                                            ),
                                            backgroundColor: Colors.transparent,
                                            elevation: 0,
                                          );
                                        });
                                    print(
                                        'Request failed with status: ${response.statusCode}.');
                                  }
                                  NotificationService().addtoadminnotification(
                                      userid: userSave.uid!,
                                      subtitle: "KUNDALI MATCH",
                                      useremail: userSave.email!,
                                      userimage: userSave.imageUrls!.isEmpty
                                          ? ""
                                          : userSave.imageUrls![0],
                                      title:
                                          "${userSave!.name!.substring(0, 1).toUpperCase()} ${userSave!.surname!.toUpperCase()} ${userSave!.puid} USES KUNDLI MATCH");
                                  AddToProfileService().addtokundaliprofile(
                                      gname: groomnamecontroller.text,
                                      gplace: location!,
                                      bam: fselectedAMPM,
                                      bkundli: data['manglik']
                                                  ['male_manglik_dosha'] ==
                                              false
                                          ? "Non- Manglik".toUpperCase()
                                          : "Manglik".toUpperCase(),
                                      gkundli: data['manglik']
                                                  ['female_manglik_dosha'] ==
                                              false
                                          ? "Non- Manglik".toUpperCase()
                                          : "Manglik".toUpperCase(),
                                      gam: mselectedAMPM,
                                      gday: mdate.toString(),
                                      gmonth: mmonth.toString(),
                                      gyear: myear.toString(),
                                      ghour: mselectedHour!,
                                      gsec: mselectedMinute!,
                                      bname: bridenamecontroller.text,
                                      bday: fdate.toString(),
                                      bmonth: fmonth.toString(),
                                      byear: fyear.toString(),
                                      bhour: fselectedHour!,
                                      bsec: fselectedMinute!,
                                      bplace: location2!,
                                      totalgun: data['ashtkoot']['total']
                                              ['received_points']
                                          .toString());
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (builder) =>
                                          KundaliMatchDataScreen1(
                                            m_name: groomnamecontroller.text,
                                            f_name: bridenamecontroller.text,
                                            m_month: mmonth,
                                            f_month: fmonth,
                                            m_day: mdate,
                                            f_surname: bridenamecontroller.text,
                                            m_surname: groomnamecontroller.text,
                                            f_day: fdate,
                                            m_year: myear,
                                            f_year: fyear,
                                            m_hour: mselectedHour,
                                            f_hour: fselectedHour,
                                            m_min: mselectedMinute,
                                            f_min: fselectedMinute,
                                            m_place: location,
                                            f_place: location2,
                                            m_gender: "Male",
                                            f_gender: "Female",
                                            m_lat: latm,
                                            m_lon: lngm,
                                            f_lat: latf,
                                            f_lon: lngf,
                                            m_sec: 0,
                                            f_sec: 0,
                                            m_tzone: "5.5",
                                            f_tzone: "5.5",
                                          )));
                                  if (userkundliads.isNotEmpty) {
                                    showadsbar(context, userkundliads,
                                        () async {
                                      Navigator.pop(context);
                                    });
                                  } else {
                                    if (userads.isNotEmpty) {
                                      showadsbar(context, userads, () async {
                                        Navigator.pop(context);
                                      });
                                    }
                                  }
                                } else {
                                  if (!mounted) return;
                                  setState(() {
                                    // var error = "Please Enter All Details";
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return const AlertDialog(
                                            content: SnackBarContent(
                                              error_text:
                                                  "Please Enter All Details",
                                              appreciation: "",
                                              icon: Icons.error,
                                              sec: 1,
                                            ),
                                            backgroundColor: Colors.transparent,
                                            elevation: 0,
                                          );
                                        });
                                  });
                                }
                                // print(object)
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
