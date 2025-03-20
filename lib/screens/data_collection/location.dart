import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geocoding/geocoding.dart' as location3;

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/location_modal.dart';
import 'package:ristey/models/user_modal.dart';
import 'package:ristey/screens/data_collection/about_me.dart';
import 'package:ristey/screens/data_collection/custom_appbar.dart';
import 'package:ristey/screens/navigation/kundali_match.dart';
import 'package:ristey/screens/navigation/service/auth_service.dart';
import 'package:ristey/services/search_service.dart';

import '../../Assets/Error.dart';
import '../../models/shared_pref.dart';

String? location;

class Location1 extends StatefulWidget {
  const Location1({super.key});

  @override
  _LocationState createState() => _LocationState();
  // Position? position;
}

class _LocationState extends State<Location1> {
  Position? _currentPosition;
  String? _currentAddress;

  final _controller = TextEditingController();
  final String _streetNumber = '';
  final String _street = '';
  final String _city = '';
  final String _zipCode = '';
  var lat;
  var lng;
  bool locate = false;
  Future<Position?> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        return Future.error('Location Not Available');
      }
    } else {
      await Geolocator.requestPermission();
      throw Exception('Error');
    }
    
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    // determinePosition();
    getalllocation();
    // _futurePersons = Searchservice().getData();
    super.initState();
  }

  void getalllocation() async {
    alllocations = await Searchservice().getData();
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

//  late Future<List<LocationModel>> _futurePersons;
  List<DataLocation> alllist = [];
  List<LocationModel> alllocations = [];

  void _fileterlocation(String query) {
    alllist.clear();
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

  final _searchController = TextEditingController();
  // final GoogleMapsPlaces _places =
  // GoogleMapsPlaces(apiKey: 'AIzaSyBgldLriecKqG8pYkQIUX5CI72rUREhIrQ');

  // List<Prediction> _predictions = [];
  UserService userService = Get.put(UserService());
  @override
  Widget build(BuildContext context) {
    bool isvisiable = false;

    double heightSuggest1 = 200.0;
    void onSelectedPlace1(DataLocation prediction) async {
      // lat =prediction.lat;
      // lng =prediction.lng;
      String somelocation =
          "${prediction.countryname},${prediction.countrystate},${prediction.countrycity}";
      List<location3.Location> locations =
          await locationFromAddress(somelocation);
      print(locations[0].latitude);
      print(locations[0].longitude);
      lat = locations[0].latitude;
      lng = locations[0].longitude;

      setState(() {
        heightSuggest1 = 0.0;
        _searchController.text =
            "${prediction.countrycity},${prediction.countrystate ?? ""},${prediction.countryname}";
        location = prediction.countrycity;
        try {
          city = prediction.countrycity;
          state = prediction.countrystate ?? "";

          country = prediction.countryname;

          FocusManager.instance.primaryFocus?.unfocus();
        } catch (e) {
          print(e);
        }

        userService.userdata.addAll({
          "location": location,
          "state": state,
          "country": country,
          "city": city,
          "lat": lat,
          "lng": lng
        });

        alllist.clear();
      });
    }

    @override
    void dispose() {
      _searchController.dispose();
      super.dispose();
    }

    bool colorDone2 = false;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        appBar:CustomAppBar(title: "I Live In", iconImage: 'images/icons/location_home.png'),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(10.0).copyWith(bottom: 15),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: [
                      SafeArea(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.,
                            children: [
                            
                              Container(
                                width:
                                    MediaQuery.of(context).size.width *0.9,
                                    height: 43,
                                decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextField(
                                  controller: _searchController,
                                  cursorColor: mainColor,
                                  decoration: InputDecoration(
                                      hintText: 'Search for location',
 contentPadding: EdgeInsets.only(top: 10),
                                      prefixIcon: Icon(
                                        Icons.search,
                                        color: mainColor,
                                      ),
                                      border: InputBorder.none),
                                  onChanged: (value) {
                                    setState(() {
                                      isvisiable = false;
                                    });
                                    // _onSearchChanged(value);
                                    _fileterlocation(value);
                                  },
                                ),
                              ),
                              SizedBox(
                                  height: heightSuggest1,
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: alllist.length,
                                    itemBuilder: (context, index) {
                                      var data = alllist[index];
                                      return SingleChildScrollView(
                                        child: ListTile(
                                            title: Text(
                                                "${data.countrycity},${data.countrystate},${data.countryname}"),
                                            onTap: () {
                                              setState(() {
                                                heightSuggest1 = 0.0;
                                              });
                                              onSelectedPlace1(data);
                                              // filteredPersons.clear();
                                              // _onSelectedPlace3(
                                              //     filteredPersons[index]);
                                              // if (!mounted) return;
                                              print(heightSuggest1);
                                            }),
                                      );
                                    },
                                  )
                          
                                  // }),
                                  ),
                            ],
                          ),
                        ),
                      ),
                      // Text(
                      //   "OR",
                      //   style: TextStyle(
                      //       fontSize: 16,
                      //       color: Colors.black54,
                      //       textBaseline: TextBaseline.alphabetic,
                      //       decoration: TextDecoration.none),
                      // ),
                      const SizedBox(
                        height: 20,
                      ),
                      (locate)
                          ? CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(mainColor),
                              color: mainColor,
                            )
                          : (_currentAddress != null)
                              ? Text(_currentAddress!,
                                  style: const TextStyle(
                                      fontFamily: 'Sans-serif',
                                      decoration: TextDecoration.none,
                                      color: Colors.black,
                                      fontSize: 20))
                              : Container(),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                  // SizedBox(
                  //   height: 50,
                  //   width: 300,
                  //   child: ElevatedButton(
                  //       child: Text(
                  //         "Enable location",
                  //         style: TextStyle(color: Colors.black, fontSize: 16),
                  //       ),
                  //       onPressed: () async {
                  //         LocationPermission permission;
                  //         permission = await Geolocator.checkPermission();
                  //         if (permission == LocationPermission.denied) {
                  //           determinePosition();
                  //         } else {
                  //           setState(() {
                  //             locate = true;
                  //           });
                  //           setState(() async {
                  //             _currentAddress = await getLocation();
                  //             locate = false;
                  //           });

                  //           setData();
                  //         }
                  //       },
                  //       style: ButtonStyle(
                  //           shape: MaterialStateProperty.all<
                  //               RoundedRectangleBorder>(RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(30.0),
                  //             // side: BorderSide(color: main_color),
                  //           )),
                  //           backgroundColor: MaterialStateProperty.all<Color>(
                  //               Colors.white))),
                  // ),
                  // SizedBox(
                  //   height: MediaQuery.of(context).size.height * 0.3,
                  // ),
                  SizedBox(
                    // margin: EdgeInsets.only(left: 15),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            shadowColor: WidgetStateColor.resolveWith(
                                (states) => Colors.black),
                            padding:
                                WidgetStateProperty.all<EdgeInsetsGeometry?>(
                                    const EdgeInsets.symmetric(vertical: 15)),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(60.0),
                                        side: BorderSide(
                                          color: (colorDone2 == false)
                                              ? Colors.white
                                              : mainColor,
                                        ))),
                            backgroundColor:
                                WidgetStateProperty.all<Color>(Colors.white)),
                        onPressed: () {
                          print("$location hello");
                          print(lat);
                          print(lng);
                          if ((lng != null && lng != "")) {
                            setState(() {
                              colorDone2 = true;
                            });
                            print(state);
                            print(country);

                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                    transitionDuration:
                                        const Duration(milliseconds: 0),
                                    reverseTransitionDuration:
                                        const Duration(milliseconds: 0),
                                    pageBuilder: (_, __, ___) =>
                                        const AboutMe()));
                          } else {
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return const AlertDialog(
                                    content: SnackBarContent(
                                      error_text:
                                          "Please Provide Your \n Living Address",
                                      appreciation: "",
                                      icon: Icons.error,
                                      sec: 2,
                                    ),
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                  );
                                });
                          }
                        },
                        child: Text(
                          "Continue",
                          style: (colorDone2 == false)
                              ? const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'Serif',
                                  fontWeight: FontWeight.w700)
                              : TextStyle(
                                  color: mainColor,
                                  fontSize: 20,
                                  fontFamily: 'Serif',
                                  fontWeight: FontWeight.w700),
                        )),
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  // Future<Position> getLocation() async {
  //   // Check if location services are enabled
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     // Location services are not enabled, throw an error
  //     throw 'Location services are disabled.';
  //   }
  //   // Get the current position
  //   Position position = await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high,
  //   );
  //   setState(() {
  //     _currentPosition = position;
  //   });
  //   _getAddressFromLatLng();
  //   return position;
  // }

  // _getCurrentLocation() {
  //   Geolocator.getCurrentPosition(
  //           desiredAccuracy: LocationAccuracy.best,
  //           forceAndroidLocationManager: true)
  //       .then((Position position) {
  //     setState(() {
  //       _currentPosition = position;
  //     });
  //   }).catchError((e) {
  //     print(e);
  //   });
  // }

  // _getAddressFromLatLng() async {
  //   try {
  //     List<Placemark> placemarks = await placemarkFromCoordinates(
  //         _currentPosition!.latitude, _currentPosition!.longitude);

  //     Placemark place = placemarks[0];

  //     setState(() {
  //       _currentAddress =
  //           "${place.locality}, ${place.postalCode}, ${place.country}";
  //       location = _currentAddress;
  //       setData();
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  String? country, state, city;

  Future<String> getLocation() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, throw an error
      throw 'Location services are disabled.';
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    lat = position.latitude;
    lng = position.longitude;
    // Get the address from latitude and longitude
    List<Placemark> placemarks = await GeocodingPlatform.instance!
        .placemarkFromCoordinates(position.latitude, position.longitude);

    country = "${placemarks[0].country}";
    state = "${placemarks[0].administrativeArea}";
    city = "${placemarks[0].locality}";
    print(placemarks);
    // Extract the area name from the address
    String areaName =
        "${placemarks[0].locality}, ${placemarks[0].administrativeArea}, ${placemarks[0].country}";

    setState(() {
      location = areaName;
      setData();
    });
    List<String> parts = country!.split(RegExp(r'[,\s]+'));
    String lastWord = parts.last;

    userService.userdata.addAll({
      "location": location,
      "state": state,
      "country": lastWord,
      "city": city,
      "lat": lat,
      "lng": lng
    });
    return areaName;
  }

  dynamic setData() async {
    SharedPref sharedPref = SharedPref();
    final json2 = await sharedPref.read("uid");
    var uid = json2['uid'];
    final docUser = FirebaseFirestore.instance.collection('user_data').doc(uid);
    try {
      User? userSave = User.fromJson(await sharedPref.read("user"));
      userSave.Location = location;
      userSave.longitude = lng;
      userSave.latitude = lat;
      userSave.city = city;
      userSave.state = state;
      userSave.country = country;
      final json = userSave.toJson();
      await sharedPref.save("user", userSave);
      await docUser.update(json).catchError((error) => print(error));
    } catch (Excepetion) {
      print(Excepetion);
    }
  }
}

// dynamic setData() async{
//   print(location);
//   final docUser = FirebaseFirestore.instance
//       .collection('user_data')
//       .doc(uid);

//   final json = {
//     'Location': location,
//     // 'dob': dob
//   };

//   await docUser.update(json).catchError((error) => print(error));
// }
