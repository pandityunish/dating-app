import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ristey/global_vars.dart';

class KundaliMatchDataScreen extends StatefulWidget {
  const KundaliMatchDataScreen({
    Key? key,
    required this.m_day,
    required this.m_hour,
    required this.m_lat,
    required this.m_lon,
    required this.m_min,
    required this.m_month,
    required this.m_name,
    required this.m_tzone,
    required this.m_year,
    required this.m_gender,
    required this.m_place,
    required this.m_sec,
    required this.f_day,
    required this.f_hour,
    required this.f_lat,
    required this.f_lon,
    required this.f_min,
    required this.f_month,
    required this.f_name,
    required this.f_tzone,
    required this.f_year,
    required this.f_gender,
    required this.f_place,
    required this.f_sec,
    required this.f_surname,
    required this.m_surname,
  }) : super(
          key: key,
        );

  final m_day;
  final m_hour;
  final m_lat;
  final m_lon;
  final m_min;
  final m_month;
  final m_surname;
  final f_surname;
  final m_name;
  final m_tzone;
  final m_year;
  final m_gender;
  final m_place;
  final m_sec;
  final f_day;
  final f_hour;
  final f_lat;
  final f_lon;
  final f_min;
  final f_month;
  final f_name;
  final f_tzone;
  final f_year;
  final f_gender;
  final f_place;
  final f_sec;

  @override
  KundaliMatchDataScreenState createState() => KundaliMatchDataScreenState();
}

class KundaliMatchDataScreenState extends State<KundaliMatchDataScreen> {
  var data;

  Future<void> sendPostRequest() async {
    var url =
        Uri.parse('https://api.kundali.astrotalk.com/v1/combined/match_making');

    var payload = {
      "m_detail": {
        "day": widget.m_day,
        "hour": widget.m_hour,
        "lat": widget.m_lat,
        "lon": widget.m_lon,
        "min": widget.m_min,
        "month": widget.m_month,
        "name": widget.m_name,
        "tzone": widget.m_tzone,
        "year": widget.m_year,
        "gender": widget.m_gender,
        "place": widget.m_place,
        "sec": widget.m_sec
      },
      "f_detail": {
        "day": widget.f_day,
        "hour": widget.f_hour,
        "lat": widget.f_lat,
        "lon": widget.f_lon,
        "min": widget.f_min,
        "month": widget.f_month,
        "name": widget.f_name,
        "tzone": widget.f_tzone,
        "year": widget.f_year,
        "gender": widget.f_gender,
        "place": widget.f_place,
        "sec": widget.f_sec
      },
      "languageId": 1
    };

    var body = json.encode(payload);

    var response = await http
        .post(url, body: body, headers: {'Content-Type': 'application/json'});
    print(response.body);
    if (response.statusCode == 200) {
      if (!mounted) return;
      setState(() {
        data = json.decode(response.body);
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  initState() {
    sendPostRequest();
    //   print(
    //     widget.m_day,
    //   );
    //   print(widget.m_hour);
    //   // print(widget.m_hour);
    //   print(widget.m_lon);
    //   print(widget.m_lat);
    //   print(widget.m_min);
    //   print(widget.m_month);
    //   print(widget.m_name);
    //   // print(widget.m_name);
    //   print(widget.m_tzone);
    //   print(widget.m_year);
    //   print(widget.m_gender);
    //   print(widget.m_place);
    //   print(widget.m_sec);

    //   print(
    //     widget.f_day,
    //   );
    //   print(widget.f_hour);
    //   // print(widget.f_hour);
    //   print(widget.f_lon);
    //   print(widget.f_lat);
    //   print(widget.f_min);
    //   print(widget.f_month);
    //   print(widget.f_name);
    //   // print(widget.m_name);
    //   print(widget.f_tzone);
    //   print(widget.f_year);
    //   print(widget.f_gender);
    //   print(widget.f_place);
    //   print(widget.f_sec);
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('Display Data from Server'),
    //   ),
    //   body: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         ElevatedButton(
    //           onPressed: sendPostRequest,
    //           child: const Text('Send POST Request'),
    //         ),
    //         if (data != null)
    //           Padding(
    //             padding: const EdgeInsets.all(16.0),
    //             child: Text(
    //               'Data from Server: ${data['manglik']['male_manglik_dosha']}',
    //               style: const TextStyle(fontSize: 20.0),
    //             ),
    //           ),
    //       ],
    //     ),
    //   ),
    // );
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Row(
            children: [
              BigText(
                text: "Kundli Match",
                size: 20,
                color: mainColor,
                fontWeight: FontWeight.w700,
              )
            ],
          ),
          previousPageTitle: "",
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              color: mainColor,
              size: 25,
            ),
          ),
        ),
        child: Container(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                Container(
                  //   margin: const EdgeInsets.only(top: 30, left: 20, bottom: 20),
                  child: SizedBox(
                    width: 300,
                    height: 70,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          shadowColor: WidgetStateColor.resolveWith(
                              (states) => Colors.black),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                          backgroundColor:
                              WidgetStateProperty.all<Color>(Colors.white)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${widget.m_name!.substring(0, 1).toUpperCase()} ${widget.m_surname.substring(0, 1).toUpperCase() + widget.m_surname.substring(1)}",
                            style: const TextStyle(
                              fontFamily: "Serif",
                              color: Colors.black,
                              fontSize: 25,
                              fontStyle: FontStyle.normal,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          (data != null)
                              ? Text(
                                  (data['manglik']['male_manglik_dosha'] ==
                                          false)
                                      ? "Non- Manglik".toUpperCase()
                                      : "Manglik".toUpperCase(),
                                  style: TextStyle(
                                      fontFamily: "Serif",
                                      color: mainColor,
                                      fontSize: 16,
                                      fontStyle: FontStyle.normal,
                                      decoration: TextDecoration.none),
                                )
                              : CircularProgressIndicator(
                                  color: mainColor,
                                ),
                        ],
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                Container(
                  //   margin: const EdgeInsets.only(top: 30, left: 20, bottom: 20),
                  child: SizedBox(
                    width: 300,
                    height: 70,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          shadowColor: WidgetStateColor.resolveWith(
                              (states) => Colors.black),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                          backgroundColor:
                              WidgetStateProperty.all<Color>(Colors.white)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${widget.f_name!.substring(0, 1).toUpperCase()} ${widget.f_surname.substring(0, 1).toUpperCase() + widget.f_surname.substring(1)}",
                            style: const TextStyle(
                              fontFamily: "Serif",
                              color: Colors.black,
                              fontSize: 25,
                              fontStyle: FontStyle.normal,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          (data != null)
                              ? Text(
                                  (data['manglik']['female_manglik_dosha'] ==
                                          false)
                                      ? "Non- Manglik".toUpperCase()
                                      : "Manglik".toUpperCase(),
                                  style: TextStyle(
                                      fontFamily: "Serif",
                                      color: mainColor,
                                      fontSize: 16,
                                      fontStyle: FontStyle.normal,
                                      decoration: TextDecoration.none),
                                )
                              : CircularProgressIndicator(
                                  color: mainColor,
                                ),
                        ],
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                Container(
                  //   margin: const EdgeInsets.only(top: 30, left: 20, bottom: 20),
                  child: SizedBox(
                    width: 300,
                    height: 40,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          shadowColor: WidgetStateColor.resolveWith(
                              (states) => Colors.black),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                          backgroundColor:
                              WidgetStateProperty.all<Color>(Colors.white)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          (data != null)
                              ? Text(
                                  "Total Gun Milan ${data['ashtkoot']['total']['received_points']}/36"
                                      .toUpperCase(),
                                  style: const TextStyle(
                                      fontFamily: "Serif",
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontStyle: FontStyle.normal,
                                      decoration: TextDecoration.none),
                                )
                              : CircularProgressIndicator(
                                  color: mainColor,
                                ),
                        ],
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class KundaliMatchDataScreen1 extends StatefulWidget {
  const KundaliMatchDataScreen1({
    Key? key,
    required this.m_day,
    required this.m_hour,
    required this.m_lat,
    required this.m_lon,
    required this.m_min,
    required this.m_month,
    required this.m_name,
    required this.m_tzone,
    required this.m_year,
    required this.m_gender,
    required this.m_place,
    required this.m_sec,
    required this.f_day,
    required this.f_hour,
    required this.f_lat,
    required this.f_lon,
    required this.f_min,
    required this.f_month,
    required this.f_name,
    required this.f_tzone,
    required this.f_year,
    required this.f_gender,
    required this.f_place,
    required this.f_sec,
    required this.f_surname,
    required this.m_surname,
  }) : super(
          key: key,
        );

  final m_day;
  final m_hour;
  final m_lat;
  final m_lon;
  final m_min;
  final m_month;
  final m_surname;
  final f_surname;
  final m_name;
  final m_tzone;
  final m_year;
  final m_gender;
  final m_place;
  final m_sec;
  final f_day;
  final f_hour;
  final f_lat;
  final f_lon;
  final f_min;
  final f_month;
  final f_name;
  final f_tzone;
  final f_year;
  final f_gender;
  final f_place;
  final f_sec;

  @override
  KundaliMatchDataScreen1State createState() => KundaliMatchDataScreen1State();
}

class KundaliMatchDataScreen1State extends State<KundaliMatchDataScreen1> {
  var data;

  Future<void> sendPostRequest() async {
    var url =
        Uri.parse('https://api.kundali.astrotalk.com/v1/combined/match_making');

    var payload = {
      "m_detail": {
        "day": widget.m_day,
        "hour": widget.m_hour,
        "lat": widget.m_lat,
        "lon": widget.m_lon,
        "min": widget.m_min,
        "month": widget.m_month,
        "name": widget.m_name,
        "tzone": widget.m_tzone,
        "year": widget.m_year,
        "gender": widget.m_gender,
        "place": widget.m_place,
        "sec": widget.m_sec
      },
      "f_detail": {
        "day": widget.f_day,
        "hour": widget.f_hour,
        "lat": widget.f_lat,
        "lon": widget.f_lon,
        "min": widget.f_min,
        "month": widget.f_month,
        "name": widget.f_name,
        "tzone": widget.f_tzone,
        "year": widget.f_year,
        "gender": widget.f_gender,
        "place": widget.f_place,
        "sec": widget.f_sec
      },
      "languageId": 1
    };

    var body = json.encode(payload);

    var response = await http
        .post(url, body: body, headers: {'Content-Type': 'application/json'});
    print(response.body);
    if (response.statusCode == 200) {
      if (!mounted) return;
      setState(() {
        data = json.decode(response.body);
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  initState() {
    sendPostRequest();
    //   print(
    //     widget.m_day,
    //   );
    //   print(widget.m_hour);
    //   // print(widget.m_hour);
    //   print(widget.m_lon);
    //   print(widget.m_lat);
    //   print(widget.m_min);
    //   print(widget.m_month);
    //   print(widget.m_name);
    //   // print(widget.m_name);
    //   print(widget.m_tzone);
    //   print(widget.m_year);
    //   print(widget.m_gender);
    //   print(widget.m_place);
    //   print(widget.m_sec);

    //   print(
    //     widget.f_day,
    //   );
    //   print(widget.f_hour);
    //   // print(widget.f_hour);
    //   print(widget.f_lon);
    //   print(widget.f_lat);
    //   print(widget.f_min);
    //   print(widget.f_month);
    //   print(widget.f_name);
    //   // print(widget.m_name);
    //   print(widget.f_tzone);
    //   print(widget.f_year);
    //   print(widget.f_gender);
    //   print(widget.f_place);
    //   print(widget.f_sec);
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('Display Data from Server'),
    //   ),
    //   body: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         ElevatedButton(
    //           onPressed: sendPostRequest,
    //           child: const Text('Send POST Request'),
    //         ),
    //         if (data != null)
    //           Padding(
    //             padding: const EdgeInsets.all(16.0),
    //             child: Text(
    //               'Data from Server: ${data['manglik']['male_manglik_dosha']}',
    //               style: const TextStyle(fontSize: 20.0),
    //             ),
    //           ),
    //       ],
    //     ),
    //   ),
    // );
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Row(
            children: [
              BigText(
                text: "Kundli Match",
                size: 20,
                color: mainColor,
                fontWeight: FontWeight.w700,
              )
            ],
          ),
          previousPageTitle: "",
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              color: mainColor,
              size: 25,
            ),
          ),
        ),
        child: Container(
          child: Center(
            child: Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                Container(
                  //   margin: const EdgeInsets.only(top: 30, left: 20, bottom: 20),
                  child: SizedBox(
                    width: 300,
                    height: 70,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          shadowColor: WidgetStateColor.resolveWith(
                              (states) => Colors.black),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                          backgroundColor:
                              WidgetStateProperty.all<Color>(Colors.white)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${widget.m_surname.substring(0, 1).toUpperCase() + widget.m_surname.substring(1)}",
                            style: const TextStyle(
                              fontFamily: "Serif",
                              color: Colors.black,
                              fontSize: 25,
                              fontStyle: FontStyle.normal,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          (data != null)
                              ? Text(
                                  (data['manglik']['male_manglik_dosha'] ==
                                          false)
                                      ? "Non- Manglik".toUpperCase()
                                      : "Manglik".toUpperCase(),
                                  style: TextStyle(
                                      fontFamily: "Serif",
                                      color: mainColor,
                                      fontSize: 16,
                                      fontStyle: FontStyle.normal,
                                      decoration: TextDecoration.none),
                                )
                              : CircularProgressIndicator(
                                  color: mainColor,
                                ),
                        ],
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                Container(
                  //   margin: const EdgeInsets.only(top: 30, left: 20, bottom: 20),
                  child: SizedBox(
                    width: 300,
                    height: 70,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          shadowColor: WidgetStateColor.resolveWith(
                              (states) => Colors.black),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                          backgroundColor:
                              WidgetStateProperty.all<Color>(Colors.white)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            " ${widget.f_surname.substring(0, 1).toUpperCase() + widget.f_surname.substring(1)}",
                            style: const TextStyle(
                              fontFamily: "Serif",
                              color: Colors.black,
                              fontSize: 25,
                              fontStyle: FontStyle.normal,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          (data != null)
                              ? Text(
                                  (data['manglik']['female_manglik_dosha'] ==
                                          false)
                                      ? "Non- Manglik".toUpperCase()
                                      : "Manglik".toUpperCase(),
                                  style: TextStyle(
                                      fontFamily: "Serif",
                                      color: mainColor,
                                      fontSize: 16,
                                      fontStyle: FontStyle.normal,
                                      decoration: TextDecoration.none),
                                )
                              : CircularProgressIndicator(
                                  color: mainColor,
                                ),
                        ],
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                Container(
                  //   margin: const EdgeInsets.only(top: 30, left: 20, bottom: 20),
                  child: SizedBox(
                    width: 300,
                    height: 40,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          shadowColor: WidgetStateColor.resolveWith(
                              (states) => Colors.black),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                          backgroundColor:
                              WidgetStateProperty.all<Color>(Colors.white)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          (data != null)
                              ? Text(
                                  "Total Gun Milan ${data['ashtkoot']['total']['received_points']}/36"
                                      .toUpperCase(),
                                  style: const TextStyle(
                                      fontFamily: "Serif",
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontStyle: FontStyle.normal,
                                      decoration: TextDecoration.none),
                                )
                              : CircularProgressIndicator(
                                  color: mainColor,
                                ),
                        ],
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
