import 'dart:async';
import 'dart:convert';

import 'package:age_calculator/age_calculator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:get/get.dart';
// import 'package:google_maps_webservice/places.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:ristey/assets/calendar.dart';
import 'package:ristey/assets/error.dart';
import 'package:ristey/assets/t_page.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/ads_modal.dart';
import 'package:ristey/models/location_modal.dart';
import 'package:ristey/models/model_location.dart';

import 'package:ristey/models/shared_pref.dart';
import 'package:ristey/screens/data_collection/religion.dart';
import 'package:ristey/screens/main_screen.dart';
import 'package:ristey/screens/navigation/kundali_match.dart';
import 'package:ristey/screens/navigation/service/ads_service.dart';
import 'package:ristey/screens/navigation/service/auth_service.dart';
import 'package:ristey/screens/notification/widget_notification/ads_bar.dart';
import 'package:ristey/services/search_service.dart';

List<String> list1 = <String>[
  'Year',
  '1976',
  '1978',
  '1979',
  '1970',
  '1980',
  '1981',
  '1982',
  '1983',
  '1984',
  '1985',
  '1986',
  '1987',
  '1988',
  '1989',
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

List<String> minutes = <String>[
  'Minute',
  "00",
  "01",
  "02",
  "03",
  "04",
  "05",
  "06",
  "07",
  "08",
  "09",
  "10",
  "11",
  "12",
  "13",
  "14",
  "15",
  "16",
  "17",
  "18",
  "19",
  "20",
  "21",
  "22",
  "23",
  "24",
  "25",
  "26",
  "27",
  "28",
  "29",
  "30",
  "31",
  "32",
  "33",
  "35",
  "36",
  "37",
  "38",
  "39",
  "40",
  "41",
  "42",
  "43",
  "44",
  "45",
  "46",
  "47",
  "48",
  "49",
  "50",
  "51",
  "52",
  "53",
  "54",
  "55",
  "56",
  "57",
  "58",
  "59"
];
String selectedhours = "Hour";
String selectedminutes = "Minute";
List<String> hours = <String>[
  'Hour',
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
];
List<String> ampm = ['Am', 'Pm'];
String selectedampm = "Am";
List<String> list8 = <String>['Date'];

class LetsStart extends StatefulWidget {
  const LetsStart({Key? key}) : super(key: key);

  @override
  State<LetsStart> createState() => _LetsStartState();
}

class _LetsStartState extends State<LetsStart> {
  TextEditingController name = TextEditingController();
  TextEditingController surname = TextEditingController();
  late ScrollController _scrollController;

  TextEditingController Phone = TextEditingController();
  TextEditingController placeofbirthcontroller = TextEditingController();
  TextEditingController birthPlaceController = TextEditingController();
  final _searchController = TextEditingController();
  String? location;
  // List<Prediction> _predictions = [];
  List<String> landmarkssug = [];
  // void _onSelectedPlace(Prediction prediction) async {
  //   var placeDetail = await _places.getDetailsByPlaceId(prediction.placeId!);

  //   if (!mounted) return;
  //   setState(() {
  //     _searchController.text = prediction.description!;
  //     location = prediction.description!;
  //     birthPlaceController.text = location!;
  //     _predictions.clear();
  //     // landmarkssug.clear();
  //   });
  // }

  void _onSelectedPlace1(DataLocation prediction) async {
    if (!mounted) return;
    setState(() {
      _searchController.text = prediction.countrycity;
      location =
          "${prediction.countrycity},${prediction.countrystate ?? ""},${prediction.countryname}";
      birthPlaceController.text = location!;
      // _predictions.clear();
      // landmarkssug.clear();
    });
  }

  void getalllocation() async {
    alllocations = await Searchservice().getData();
    setState(() {});
  }

  List<DataLocation> alllist = [];
  List<LocationModel> alllocations = [];
  late Future<List<ModelLocation>> _futurePersons;
  void _fileterlocation(String query) {
    alllist.clear();
    print(query);
    allcities.clear();
    height_suggest1 = 200;
    for (var country in alllocations) {
      for (var state in country.state) {
        for (var city in state.city) {
          if (city.name.toLowerCase().contains(query.toLowerCase())) {
            alllist.add(DataLocation(
                countryname: country.name,
                countrycity: city.name,
                countrystate: state.name));
            allcities.add("${city.name},${state.name ?? ""},${country.name}");
          }
        }
      }
    }
    setState(() {});
  }

  SharedPref sharedPref = SharedPref();
  // final GoogleMapsPlaces _places =
  //     GoogleMapsPlaces(apiKey: 'AIzaSyBgldLriecKqG8pYkQIUX5CI72rUREhIrQ');
  int? dob_timestamp;
  var phone_num;
  var User_Name;
  var placeofbirth;
  var User_SurName;
  bool male_gender = false;
  bool female_gender = false;
  var dob = "";
  var gender;
  DateTime? pickedDate;
  DateDuration duration = DateDuration();
  String dropdownValuem1 = list1.first;
  String dropdownValuem2 = list2.first;
  String dropdownValuem3 = list3.first;
  String dropdownValuem4 = list8.first;
  String? mmonth;
  String? age;
  final FocusNode _focusNode = FocusNode();

  // DateDuration? duration;
  DateDuration? dateOfBirth;

  DateTime? dateTime;
  updateMaleDate(var date, var month, var year) {
    // print("update male date called");
    // print("$date  $month $year");
    // mdate = date;
    // mmonth = month;
    // myear = year;
    DateTime birthday = DateTime(year, month, date);

    duration = AgeCalculator.age(birthday);
    print(duration.years);
    age = duration.years.toString();

    setState(() {
      dob = duration.toString();
      dob_timestamp = birthday.millisecondsSinceEpoch;
    });
  }

  var height_suggest1 = 0.0;
  // void _onSearchChanged(String value) async {
  //   if (value.isNotEmpty) {
  //     var response = await _places.autocomplete(
  //       value,
  //       types: [
  //         "locality",
  //         "administrative_area_level_1",
  //         "administrative_area_level_2",
  //         "country"
  //       ],
  //     );
  //     if (!mounted) return;
  //     setState(() {
  //       var filteredPredictions = response.predictions
  //           .where((prediction) => prediction.types.contains("locality"))
  //           .toList();
  //       _predictions = filteredPredictions;
  //       height_suggest1 = 200;
  //     });
  //     for (var i = 0; i < _predictions.length; i++) {
  //       landmarkssug.add(_predictions[i].description!);
  //     }
  //     setState(() {});
  //   }
  // }

  List<String> allcities = [];
  void getallcities() async {
    List<LocationModel> allmodels = [];
    // _allmodels=await Searchservice().getData();
// for (var i = 0; i < _allmodels.length; i++) {
//   for (var j = 0; j < _allmodels[i].state.length; j++) {
//     for (var k = 0; k < _allmodels[i].state[j].city.length; k++) {
//      allcities.add("${_allmodels[i].state[i].city[k].name},${_allmodels[i].state[j].name},${_allmodels[i].name}") ;
//     }
//   }
// }
    setState(() {});
  }

  Future getPhoneDetails() async {
    var res = await rootBundle
        .loadString('lib/country_modal/assets/phone_details.json');
    setState(() {
      phoneDetailState = jsonDecode(res) as List;
    });
    print("Phone state ready ${phoneDetailState.length}");
  }

  List<dynamic> phoneDetailState = [];

  TextEditingController dateInput = TextEditingController();
  @override
  @override
  void initState() {
    super.initState();

    // Initialize phone details
    getPhoneDetails();

    // Set the initial value of the text field
    dateInput.text = "";

    // Fetch all ads
    getallads();

    // Fetch all locations
    getalllocation();

    // Initialize the scroll controller
    _scrollController = ScrollController();

    // Add a post frame callback to run some code after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      runtpage();
    });
  }

  final _focusNode1 = FocusNode();
  final _focusNode2 = FocusNode();
  final _focusNode3 = FocusNode();
  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<AdsModel> allads = [];

  void getallads() async {
    allads = await AdsService().getallusers(adsid: "2");
    if (allads.isNotEmpty) {
      Timer.run(() {
        showadsbar(context, allads, () {
          Navigator.pop(context);
        });
      });
    }
    setState(() {});
  }

  bool register = false;
  var error = "";

  runtpage() {
    // Future.delayed(const Duration(seconds: 1), () {
    print('One second has passed.'); // Prints after 1 second.
    Tpage.transferPage(context, "main");
    // });
  }

  PhoneNumber? phoneNumberState;

  Future<bool> checkNumber() async {
    if (phoneNumberState == null) {
      return false;
    }

    for (var item in phoneDetailState) {
      if (item['iso_code'] == phoneNumberState!.countryISOCode) {
        if (item['phone_number_length'] == phoneNumberState!.number.length) {
          return true;
        }
      }
    }

    return false;
  }

  final key = GlobalKey<FormState>();
  UserService service = Get.put(UserService());
  void onpressed() async {
    final isNumberValid = await checkNumber();
    if (User_Name == null || User_Name == "") {
      setState(() {
        error = "Please Write Your Name";
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: SnackBarContent(
                  error_text: "Please Enter Name",
                  appreciation: "",
                  icon: Icons.error,
                  sec: 1,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              );
            });
      });
    } else if (User_SurName == null || User_SurName == "") {
      setState(() {
        error = "Please Write Your Surname";
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: SnackBarContent(
                  error_text: "Please Enter Surname",
                  appreciation: "",
                  icon: Icons.error,
                  sec: 1,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              );
            });
      });
    } else if (!isNumberValid) {
      print("Our number isValid ${isNumberValid}");
      setState(() {
        error = "Please Enter Valid Contact Number";
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: SnackBarContent(
                  error_text: "Please Enter Valid Contact Number",
                  appreciation: "",
                  icon: Icons.error,
                  sec: 1,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              );
            });
      });
    } else if (gender == null || gender == "") {
      setState(() {
        error = "Please Select Gender";
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: SnackBarContent(
                  error_text: "Please Select Gender",
                  appreciation: "",
                  icon: Icons.error,
                  sec: 1,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              );
            });
      });
    } else if (dob == "") {
      setState(() {
        error = "Please Select Your Time of Birth";
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: SnackBarContent(
                  error_text: "Please Select Time of Birth",
                  appreciation: "",
                  icon: Icons.error,
                  sec: 1,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              );
            });
      });
    } else if (gender == "male" && duration.years < 21) {
      setState(() {
        error = "Age must be greater than 21";
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: SnackBarContent(
                  error_text: "Age must be \n Greater than 21",
                  appreciation: "",
                  icon: Icons.error,
                  sec: 2,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              );
            });
      });
    } else if (gender == "female" && duration.years < 18) {
      setState(() {
        error = "";
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: SnackBarContent(
                  error_text: "Age must be \n greater than 18",
                  appreciation: "",
                  icon: Icons.error,
                  sec: 2,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              );
            });
      });
    } else if (selectedhours == "Hours") {
      setState(() {
        error = "";
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: SnackBarContent(
                  error_text: "Please Select Time of Birth",
                  appreciation: "",
                  icon: Icons.error,
                  sec: 2,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              );
            });
      });
    } else if (selectedminutes == "Minutes") {
      setState(() {
        error = "";
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: SnackBarContent(
                  error_text: "Please Select Minutes",
                  appreciation: "",
                  icon: Icons.error,
                  sec: 2,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              );
            });
      });
    } else if (birthPlaceController.text.isEmpty) {
      setState(() {
        error = "";
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: SnackBarContent(
                  error_text: "Please Enter Place of Birth",
                  appreciation: "",
                  icon: Icons.error,
                  sec: 2,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              );
            });
      });
    } else if (!allcities.contains(birthPlaceController.text)) {
      setState(() {
        error = "";
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: SnackBarContent(
                  error_text: "Please Enter Valid Place of Birth",
                  appreciation: "",
                  icon: Icons.error,
                  sec: 2,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              );
            });
      });
    } else {
      setState(() {
        color_done2 = true;
        error = "";
      });
      service.newuserdata.addAll({"name": User_Name});
      print(age);

      UserService().createincompleteprofilebyregister(
          aboutme: "",
          diet: "",
          disability: "",
          drink: "",
          education: "",
          height: "",
          income: "",
          patnerprefs: "",
          smoke: "",
          displayname: User_Name,
          email: userSave.email!,
          religion: "",
          name: User_Name,
          surname: User_SurName,
          phone: phone_num,
          gender: gender,
          kundalidosh: "",
          martialstatus: "",
          profession: "",
          location: "Ghazni",
          city: "Ghazni",
          state: "Afghanistan",
          imageurls: [],
          blocklists: [],
          reportlist: [],
          shortlist: [],
          country: "",
          token: "",
          age: "",
          lat: 33.5471303,
          lng: 68.4221352,
          timeofbirth: "",
          placeofbirth: birthPlaceController.text,
          puid: "",
          dob: 32323);
      print(birthPlaceController.text);
      Navigator.push(
          context,
          PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 0),
              reverseTransitionDuration: const Duration(milliseconds: 0),
              pageBuilder: (_, __, ___) => Religion(
                    User_Name: User_Name,
                    User_SurName: User_SurName,
                    age: age!,
                    dob: dob_timestamp!,
                    gender: gender,
                    phone_num: phone_num,
                    placeofbirth: birthPlaceController.text,
                    timeofbirth:
                        "$selectedhours:$selectedminutes $selectedampm",
                  )));
    }
  }

  String countrycode = "";
  @override
  Widget build(BuildContext context) {
    // setState(() {
    // print(male_gender);
    if (male_gender == true) {
      setState(() {
        gender = "male";
      });
    } else if (female_gender == true) {
      setState(() {
        gender = "female";
      });
    }
    // });
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.white,
            
            leading: GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FirstScreen(),
                    ),
                    (route) => false);
              },
              child: Icon(
                Icons.arrow_back_ios_new,
                color: mainColor,
                size: 25,
              ),
            ),
            // actionsForegroundColor: Colors.white,
            title: Row(
              children: [
                // Icon(Icons.arrow_back_ios_new),
                Container(
                  margin: const EdgeInsets.only(right: 150),
                  child: Text(
                    "Let's Start",
                    style: TextStyle(fontSize: 24, color: mainColor),
                  ),
                ),
              ],
            ),
         
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
              
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            child: SizedBox(
                              height: 50,
                              child: CupertinoTextField(
                                // height: 20.0,
                                maxLength: 12,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(
                                      "[a-zA-Z]")), // Allow only alphabets
                                ],
                                maxLengthEnforcement: MaxLengthEnforcement
                                    .enforced, // show error message
                                // maxLengthEnforcedMessage: 'You have reached the maximum character limit of 50',
                                placeholder: "Enter Name",
                                placeholderStyle: TextStyle(color: newtextColor),
                                focusNode: _focusNode1,
                                controller: name,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _focusNode1.hasFocus
                                        ? mainColor
                                        : Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                textInputAction: TextInputAction.next,
                                onChanged: (name) => {
                                  setState(() {
                                    User_Name = name;
                                  })
                                },
                              ),
                            ),
                          ),
                        ),
                  
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 10),
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            child: SizedBox(
                              height: 50,
                              child: CupertinoTextField(
                                maxLength: 12,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(
                                      "[a-zA-Z]")), // Allow only alphabets
                                ],
                                maxLengthEnforcement:
                                    MaxLengthEnforcement.enforced,
                                placeholder: "Enter Surname",
                                placeholderStyle: TextStyle(color: newtextColor),
                                focusNode: _focusNode2,
                                controller: surname,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _focusNode2.hasFocus
                                        ? mainColor
                                        : Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                textInputAction: TextInputAction.next,
                                onChanged: (surname) => {
                                  setState(() {
                                    User_SurName = surname;
                                  })
                                },
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   height: 20,
                        // ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 10),
                          child: Material(
                            color: Colors.white,
                            child: Container(
                              child: IntlPhoneField(
                                focusNode: _focusNode,
                                flagsButtonPadding:
                                    const EdgeInsets.only(top: 20, bottom: 0),
                                controller: Phone,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],
                  
                                decoration: InputDecoration(
                                  focusColor: mainColor,
                                  hoverColor: mainColor,
                  
                                  //decoration for Input Field
                                  contentPadding: const EdgeInsets.only(
                                    top: 25,
                                    left: 20,
                                    right: 20,
                                  ),
                                  // labelText: 'Phone Number',
                  
                                  hintText: "Enter Contact Number",
                                  hintStyle:
                                       TextStyle(color: newtextColor),
                                  border: InputBorder.none,
                                  errorStyle: const TextStyle(
                                    color: Colors.red, // Error text color
                                    fontSize: 14.0, // Error text font size
                                  ),
                                ),
                                onCountryChanged: (value) {
                                  phone_num = "";
                                  Phone.clear();
                                  print(phone_num);
                                  setState(() {});
                                },
                                initialCountryCode:
                                    'IN', //default contry code, NP for Nepal
                                onChanged: (phone) {
                                  setState(() {
                                    phone_num =
                                        phone.countryCode + phone.number;
                                    countrycode = phone.countryCode;
                                    phoneNumberState = phone;
                                  });
                                },
                                onSubmitted: (phoneNum) =>
                                    print('Submitted $phoneNum'),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 46,
                                width: 150,
                                child: ElevatedButton(
                                    onPressed: () {
                                      _focusNode.unfocus();
                                      setState(() {
                                        male_gender = !male_gender;
                                        female_gender = false;
                                        if (!male_gender) {
                                          gender = "";
                                        }
                                      });
                                    },
                                    style: male_gender
                                        ? ButtonStyle(
                                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25.0),
                                                    side: BorderSide(
                                                        color: mainColor))),
                                            backgroundColor:
                                                WidgetStateProperty.all<Color>(
                                                    Colors.white))
                                        : ButtonStyle(
                                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(25.0))),
                                            backgroundColor: WidgetStateProperty.all<Color>(Colors.white)),
                                    child: Text("Male",
                                        style: TextStyle(
                                          fontFamily: 'Sans-serif',
                                          fontWeight: FontWeight.w400,
                                          color: male_gender
                                              ? mainColor
                                              : newtextColor,
                                          fontSize: 14,
                                        ))),
                              ),
                              SizedBox(
                                width: 150,
                                height: 46,
                                child: ElevatedButton(
                                    onPressed: () {
                                      _focusNode.unfocus();
                                      setState(() {
                                        female_gender = !female_gender;
                                        male_gender = false;
                                        if (!female_gender) {
                                          gender = "";
                                        }
                                      });
                                    },
                                    style: female_gender
                                        ? ButtonStyle(
                                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25.0),
                                                    side: BorderSide(
                                                        color: mainColor))),
                                            backgroundColor:
                                                WidgetStateProperty.all<Color>(
                                                    Colors.white))
                                        : ButtonStyle(
                                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(25.0))),
                                            backgroundColor: WidgetStateProperty.all<Color>(Colors.white)),
                                    child: Text("Female",
                                        style: TextStyle(
                                          fontFamily: 'Sans-serif',
                                          fontWeight: FontWeight.w400,
                                          color: female_gender
                                              ? mainColor
                                              : newtextColor,
                                          fontSize: 14,
                                        ))),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 20, bottom: 15,top: 15),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Date Of Birth",
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontSize: 20,
                                    fontFamily: 'Sans-serif',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                  
                        Calender(
                          useTwentyOneYears: male_gender,
                          setdate: updateMaleDate,
                        ),
                  
                        DefaultTextStyle(
                            style: const TextStyle(
                              fontFamily: 'Sans-serif',
                              color: Colors.black,
                              fontSize: 20,
                            ),
                            child: Text(dob)),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 20, bottom: 15),
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Time Of Birth",
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontSize: 20,
                                    fontFamily: 'Sans-serif',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Card(
                              elevation: 4,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: SizedBox(
                                height: 46,
                                width: MediaQuery.of(context).size.width * 0.29,
                                child: Center(
                                  child: DropdownButton<String>(
                                    alignment: AlignmentDirectional.center,
                                    underline: Container(
                                      color: Colors.white,
                                    ),
                                    value: selectedhours,
                  iconEnabledColor: newtextColor,
                                    items: hours.map((value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value,style: TextStyle(color: newtextColor),),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedhours = newValue!;
                                        // _updateDaysInMonth();
                                      });
                                    },
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
                                width: MediaQuery.of(context).size.width * 0.29,
                                child: Center(
                                  child: DropdownButton<String>(
                                    alignment: AlignmentDirectional.center,
                                    underline: Container(
                                      color: Colors.white,
                                    ),
                                    value: selectedminutes,
                                    iconEnabledColor: newtextColor,
                                    items: minutes.map((value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value,style: TextStyle(color: newtextColor)),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedminutes = newValue!;
                                        // _updateDaysInMonth();
                                      });
                                    },
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
                                width: MediaQuery.of(context).size.width * 0.29,
                                child: Center(
                                  child: DropdownButton<String>(
                                    alignment: AlignmentDirectional.center,
                                    underline: Container(
                                      color: Colors.white,
                                    ),
                                    value: selectedampm,
                                    iconEnabledColor: newtextColor,
                                    items: ampm.map((value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value,style: TextStyle(color: newtextColor)),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedampm = newValue!;
                                        // _updateDaysInMonth();
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                  
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 3),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            child: TextFormField(
                              controller: birthPlaceController,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.name,
                              onChanged: (value) {
                                _fileterlocation(value);
                                _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.easeOut,
                                );
                              },
                              onTap: () {
                                _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.easeOut,
                                );
                              },
                              focusNode: _focusNode3,
                              decoration:  InputDecoration(
                                  hintText: "Enter Place of Birth",
                                  hintStyle: TextStyle(color: newtextColor),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(10)),
                            ),
                          ),
                        ),
                        Stack(
                          children: [
                            const SizedBox(height: 1),
                            SizedBox(
                              height: height_suggest1,
                              child: Card(
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
                                            _onSelectedPlace1(data);
                  
                                            setState(() {
                                              height_suggest1 = 0.0;
                                            });
                                          }),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                      
                        // const SizedBox(
                        //   height: 20,
                        // ),
                      ],
                    ),
                  ),
                ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SizedBox(
                          // margin: EdgeInsets.only(left: 15),
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  shadowColor: WidgetStateColor.resolveWith(
                                      (states) => Colors.black),
                                  padding: WidgetStateProperty.all<
                                          EdgeInsetsGeometry?>(
                                      const EdgeInsets.symmetric(vertical: 15)),
                                  shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(60.0),
                                          side: BorderSide(
                                            color: (color_done2 == false)
                                                ? Colors.white
                                                : mainColor,
                                          ))),
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          Colors.white)),
                              onPressed: () {
                                onpressed();
                              },
                              child: Text(
                                "Register",
                                style: (color_done2 == false)
                                    ? const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Serif')
                                    : TextStyle(
                                        color: mainColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Serif'),
                              )),
                        ),
                  ),
              ],
            ),
          )),
    );
  }

  bool color_done2 = false;
  DateDuration? PickedDate;
}
