library country_state_city_picker_nona;

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/screens/data_collection/custom_appbar.dart';
import 'package:ristey/screens/navigation/service/home_service.dart';
import './status_modal.dart' as StatusModel;

class SelectStateData extends StatefulWidget {
  final TextStyle? style;
  final Color? dropdownColor;
  final InputDecoration decoration;
  final double spacing;
  var list;
  SelectStateData({
    Key? key,
    this.decoration =
        const InputDecoration(contentPadding: EdgeInsets.all(0.0)),
    this.spacing = 0.0,
    this.style,
    this.dropdownColor,
    this.list,
    // this.onCountryTap,
    // this.onStateTap,
    // this.onCityTap
  }) : super(key: key);

  @override
  _SelectStateDataState createState() => _SelectStateDataState();
}

class _SelectStateDataState extends State<SelectStateData> {
  List<StatusModel.City> _cities = [];
  final List<StatusModel.StatusModel> _country = [];
  final String _selectedCity = "Choose City";
  final String _selectedCountry = "Choose Country";
  final String _selectedState = "Choose State/Province";
  List<StatusModel.State> _states = [];
  var responses;
  HomeService homeservice = Get.put(HomeService());
  void addlocation() {
    for (var i = 0; i < selectedCounty!.length; i++) {
      selectedCountryList.add(StatusModel.StatusModel(
          emoji: "",
          emojiU: "",
          id: i,
          name: selectedCounty![i]["name"],
          state: []));
    }
    for (var i = 0; i < selectedCity!.length; i++) {
      cityname.add(selectedCity![i]["name"]);
    }
    for (var i = 0; i < selectedState!.length; i++) {
      statename.add(
        selectedState![i]["name"],
      );
    }
    setState(() {});
  }

  @override
  void initState() {
    setdata();
    addlocation();
    getCounty();
    super.initState();
  }

  setdata() {
    // for (var i = 0; i < widget.list[2].length; i++) {
    //   setState(() {
    //     _country.add(widget.list[2][i]);
    //   });
    // }
    // setState(() {
    //   _country.addAll(widget.list[2]);
    // });
  }

  Future getResponse() async {
    var res =
        await rootBundle.loadString('assets/country.json');
    return jsonDecode(res);
  }

  Future getCounty() async {
    var countryres = await getResponse() as List;
    print("getcountry running");
    for (var data in countryres) {
      var model = StatusModel.StatusModel();
      model.name = data['name'];
      model.emoji = data['emoji'];
      if (!mounted) continue;
      setState(() {
        _country.add(model);
      });
    }

    return _country;
  }

  List<StatusModel.StatusModel> selectedCountryList = [];
  List<StatusModel.State> selectedStateList = [];
  List<StatusModel.City> selectedCityList = [];

  List<List<String>> selectedLocation = [[], [], []];

  Future getState() async {
    var response = await getResponse();
    var takestate = response
        .map((map) => StatusModel.StatusModel.fromJson(map))
        .where((item) {
          print(item);
          return selectedCountryList
              .where((element) => item.name == element.name)
              .isNotEmpty;
        })
        .map((item) => item.state)
        .toList();

    var states = takestate as List;
    for (var f in states) {
      if (!mounted) continue;
      setState(() {
        var name = f.map((item) => item).toList();
        for (var statename in name) {
          // print(statename.toString());

          _states.add(statename);
          // setState(() {});
        }
      });
    }

    return _states;
  }

  Future getCity() async {
    var response = await getResponse();
    var takestate = response
        .map((map) => StatusModel.StatusModel.fromJson(map))
        .where((item) => selectedCountryList
            .where((element) => item.name == element.name)
            .isNotEmpty)
        .map((item) => item.state)
        .toList();
    var states = takestate as List;
    for (var f in states) {
      var name = f.where((item) => selectedStateList
          .where((element) => item.name == element.name)
          .isNotEmpty);
      var cityname = name.map((item) => item.city).toList();
      cityname.forEach((ci) {
        // if (!mounted) continue;
        setState(() {
          var citiesname = ci.map((item) => item).toList();
          for (var citynames in citiesname) {
            // print(citynames.toString());

            _cities.add(citynames);
          }
        });
      });
    }
    return _cities;
  }

  bool countryfocus = false;
  bool statefocus = false;
  bool cityfocus = false;

  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _cityscrollController = ScrollController();

  final state = TextEditingController();
  final city = TextEditingController();
  List<StatusModel.StatusModel> countryDataList = [];
  List<StatusModel.State>? stateDataList = [];
  List<StatusModel.City> cityDataList = [];

  countryData(List<StatusModel.StatusModel> data, String val) {
    print("uuuuuuuuuuu$data");

    if (selectedCountryList.isNotEmpty) {
      val = val.split(',').last;
    }

    List<StatusModel.StatusModel> tempCount = _country
        .where((element) =>
            element.name!.toLowerCase().startsWith(val.toLowerCase()))
        .toList();
    print(tempCount);
    setState(() {
      countryDataList = tempCount;
    });
  }

  // List<String> stateDataList = [];

  stateData(List<StatusModel.State> dataList, String val) {
    print("ssssssssss$dataList");
    if (selectedStateList.isNotEmpty) {
      val = val.split(',').last;
    }

    // List<List<StatusModel.State>?> tempCount =

    // List<StatusModel.State>? temp = [];
    // for (List<StatusModel.State>? data
    // in dataList.map((e) => e.state).toList()) {
    List<StatusModel.State> temp = _states
        .where((element) =>
            element.name!.toLowerCase().startsWith(val.toLowerCase()))
        .toList();

    setState(() {
      stateDataList = temp;
    });
  }

  cityData(List<StatusModel.City> data, String val) {
    // print("uuuuuuuuuuu$data");
    if (selectedCityList.isNotEmpty) {
      val = val.split(',').last;
    }

    List<StatusModel.City> tempCount = data
        .where((element) =>
            element.name!.toLowerCase().startsWith(val.toLowerCase()))
        .toList();
    print(tempCount);
    setState(() {
      cityDataList = tempCount;
    });
  }

  // final GoogleMapsPlaces _places =
  //     GoogleMapsPlaces(apiKey: 'AIzaSyBgldLriecKqG8pYkQIUX5CI72rUREhIrQ');
  // List<Prediction> _predictions = [];
  // List<Prediction> _citypredictions = [];
  // final _searchController = TextEditingController();
  List<String> statename = [];
  List<String> cityname = [];

  // void onselectstate(Prediction prediction) async {
  //   statename.add(prediction.structuredFormatting!.mainText);
  //   print(prediction.structuredFormatting!.mainText);
  //   setState(() {});
  // }

  // void onselectcity(Prediction prediction) async {
  //   cityname.add(prediction.structuredFormatting!.mainText);
  //   print(prediction.structuredFormatting!.mainText);
  //   setState(() {});
  // }

// 🇦🇫    Afghanistan
  @override
  Widget build(BuildContext context) {
    // void onSearchChanged(String value) async {
    //   print(value);
    //   // print(_places.searchByText(value));
    //   var res = await _places.searchByText(value);
    //   print(res.results.length);
    //   if (value.isNotEmpty) {
    //     var response = await _places.autocomplete(value, types: [
    //       "(regions)"
    //     ]); // Use "regions" for a broader search, including states.

    //     // Filter the predictions to include only states
    //     List<Prediction> statePredictions =
    //         response.predictions.where((prediction) {
    //       return prediction.types.contains('administrative_area_level_1');
    //     }).toList();

    //     setState(() {
    //       _predictions = statePredictions;
    //     });

    //     print(statePredictions);
    //   }
    // }

    // void cityonSearchChanged(String value) async {
    //   print(value);
    //   // print(_places.searchByText(value));
    //   var res = await _places.searchByText(value);
    //   print(res.results.length);
    //   if (value.isNotEmpty) {
    //     var response = await _places.autocomplete(value, types: ["(cities)"]);

    //     setState(() {
    //       _citypredictions = response.predictions;
    //     });
    //     print(response.predictions);
    //   }
    // }

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(title: "Location", iconImage: 'images/icons/location.png',onBackButtonPressed: () {
            if (selectedCountryList.isEmpty &&
                  statename.isEmpty &&
                  cityname.isEmpty) {
                homeservice.saveprefdata.value.statelocation = [];
                homeservice.saveprefdata.value.citylocation = [];
                homeservice.saveprefdata.value.location = [];
                setState(() {});
              } else {
                for (var element in selectedCountryList) {
                  selectedLocation[0].add(element.name.toString());
                }
                for (var element in statename) {
                  selectedLocation[1].add(element.toString());
                }
                for (var element in cityname) {
                  selectedLocation[2].add(element);
                }
                selectedCity!.clear();
                selectedCounty!.clear();
                selectedState!.clear();
                for (var i = 0; i < cityname.length; i++) {
                  selectedCity!.add({"name": cityname[i]});
                }
                for (var i = 0; i < selectedCountryList.length; i++) {
                  selectedCounty!.add({"name": selectedCountryList[i].name});
                }
                for (var i = 0; i < statename.length; i++) {
                  selectedState!.add({"name": statename[i]});
                }
                setState(() {});
              }
              // selectedLocation = [selectedCountryList, selectedStateList];
              Navigator.of(context).pop(selectedLocation);
        },) ,
        // CupertinoNavigationBar(
        //   leading: GestureDetector(
        //     onTap: () {
            
        //     },
        //     child: Icon(
        //       Icons.arrow_back_ios_new,
        //       color: mainColor,
        //       size: 25,
        //     ),
        //   ),
        //   middle: SingleChildScrollView(
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         ImageIcon(
        //           const AssetImage('images/icons/location_home.png'),
        //           size: 15,
        //           color: mainColor,
        //         ),
        //         const SizedBox(
        //           width: 8,
        //         ),
        //         Container(
        //           // margin: EdgeInsets.only(right: 12),
        //           child: const DefaultTextStyle(
        //               style: TextStyle(
        //                   color: Colors.black,
        //                   fontFamily: 'Sans-serif',
        //                   fontWeight: FontWeight.w700,
        //                   fontSize: 24),
        //               child: Text("Location")),
        //         )
        //       ],
        //     ),
        //   ),
        //   previousPageTitle: "",
        // ),
        body: Container(
     
            padding: const EdgeInsets.symmetric(horizontal: 20),
            // height: MediaQuery.of(context).size.height * 9.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              Expanded(
                child: Column(
                  children: [
                      SizedBox(height: 10),
                  Focus(
                    onFocusChange: (val) {
                      countryfocus = val;
                      setState(() {});
                    },
                    child: SingleChildScrollView(
                      child: Container(
                        margin:
                            const EdgeInsets.symmetric(horizontal: 10),
                        decoration: containerStyle,
                        height: 50,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                                
                          // reverse: true,
                          children: [
                            ...List<Widget>.generate(
                                selectedCountryList.length,
                                (index) => GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedCountryList.removeWhere(
                                              (element) =>
                                                  selectedCountryList[
                                                          index]
                                                      .name ==
                                                  element.name);
                                          removeState();
                                        });
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.symmetric(
                                                vertical: 10,
                                                horizontal: 5),
                                        padding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 5),
                                        height: 20,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: const Color.fromARGB(
                                                255, 230, 228, 228)),
                                        child: Row(
                                          children: [
                                            Text(
                                                selectedCountryList[index]
                                                    .name!),
                                            Icon(
                                                size: 15,
                                                CupertinoIcons
                                                    .clear_circled,
                                                color: mainColor),
                                          ],
                                        ),
                                      ),
                                    )),
                            Container(
                              // decoration: containerStyle,
                              height: 50,
                              width: width - 50,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5),
                              child: TextField(
                                cursorColor: mainColor,
                                
                                decoration: textFiedstyle.copyWith(
                                  hintText: 'Country',
                                ),
                                controller: countryController,
                                // maxLength: 5,
                                onChanged: (value) {
                                  countryData(_country, value);
                                
                                  _scrollController.jumpTo(0);
                                },
                                scrollPhysics: const ScrollPhysics(),
                                
                                scrollController: _scrollController,
                                // focusNode: countryfocus,
                                
                                // onChanged: (value) {
                                
                                // },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // countryfoc
                  //us.addListener(() { })
                  const SizedBox(
                    height: 10,
                  ),
                  countryfocus
                      ? SizedBox(
                          height:
                              MediaQuery.of(context).size.height * 0.29,
                          // height: 230,
                          child: SingleChildScrollView(
                            child: Column(
                              children: countrySuggetion(countryDataList),
                            ),
                          ),
                        )
                      : Container(),
                  const SizedBox(height: 20),
                                
                  countryfocus
                      ? Container()
                      : Focus(
                          onFocusChange: (val) {
                            statefocus = val;
                            setState(() {});
                          },
                          child: Container(
                            decoration: containerStyle,
                            height: 50,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10),
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              // child: ListView(
                              children: [
                                ...List<Widget>.generate(
                                    statename.length,
                                    (index) => GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              statename.removeWhere(
                                                  (element) =>
                                                      statename[index] ==
                                                      element);
                                              // kkk
                                            });
                                          },
                                          child: Container(
                                            margin: const EdgeInsets
                                                .symmetric(
                                                vertical: 10,
                                                horizontal: 5),
                                            padding: const EdgeInsets
                                                .symmetric(horizontal: 5),
                                            height: 20,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10),
                                                color:
                                                    const Color.fromARGB(
                                                        255,
                                                        230,
                                                        228,
                                                        228)),
                                            child: Row(
                                              children: [
                                                Text(statename[index]),
                                                Icon(
                                                  size: 15,
                                                  CupertinoIcons
                                                      .clear_circled,
                                                  color: mainColor,
                                                )
                                              ],
                                            ),
                                          ),
                                        )),
                                Container(
                                  height: 50,
                                  width: width - 50,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: TextField(
                                    cursorColor: mainColor,
                                
                                    decoration: textFiedstyle.copyWith(
                                        hintText: 'State'),
                                
                                    // focusNode: countryfocus,
                                    controller: stateController,
                                    onChanged: (value) {
                                      // onSearchChanged(value);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                                
                  const SizedBox(
                    height: 10,
                  ),
                                
                  statefocus
                      ? SizedBox(
                          height:
                              MediaQuery.of(context).size.height * 0.22,
                          child: SingleChildScrollView(
                            child: Column(
                                // children: stateSuggetion1(_predictions),
                                ),
                          ),
                        )
                      : Container(),
                  const SizedBox(height: 20),
                                
                  countryfocus || statefocus
                      ? Container()
                      : Focus(
                          onFocusChange: (val) {
                            cityfocus = val;
                            _cityscrollController.jumpTo(width);
                            setState(() {});
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10),
                            decoration: containerStyle,
                            height: 50,
                            child: ListView(
                              controller: _cityscrollController,
                              scrollDirection: Axis.horizontal,
                              children: [
                                ...List<Widget>.generate(
                                    cityname.length,
                                    (index) => GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              cityname.removeWhere(
                                                  (element) =>
                                                      cityname[index] ==
                                                      element);
                                            });
                                          },
                                          child: Container(
                                            margin: const EdgeInsets
                                                .symmetric(
                                                vertical: 10,
                                                horizontal: 5),
                                            padding: const EdgeInsets
                                                .symmetric(horizontal: 5),
                                            height: 20,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10),
                                                color:
                                                    const Color.fromARGB(
                                                        255,
                                                        230,
                                                        228,
                                                        228)),
                                            child: Row(
                                              children: [
                                                Text(cityname[index]),
                                                Icon(
                                                  size: 15,
                                                  CupertinoIcons
                                                      .clear_circled,
                                                  color: mainColor,
                                                )
                                              ],
                                            ),
                                          ),
                                        )),
                                Container(
                                  height: 50,
                                  width: width - 50,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: TextField(
                                    cursorColor: mainColor,
                                
                                    decoration: textFiedstyle.copyWith(
                                        hintText: 'City'),
                                
                                    // focusNode: countryfocus,
                                    controller: cityController,
                                    onChanged: (value) {
                                      // cityonSearchChanged(value);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  // countryfocus.addListener(() { })
                  // count
                  // ryfocus
                  const SizedBox(
                    height: 10,
                  ),
                                
                  cityfocus
                      ? SizedBox(
                          height:
                              MediaQuery.of(context).size.height * 0.15,
                          child: SingleChildScrollView(
                            child: Column(
                                // children: citySuggetion1(_citypredictions),
                                ),
                          ),
                        )
                      : Container(),
                  ],
                ),
              ),
              
                // OutlinedButton(
                //   onPressed: () {},
                //   child: Padding(
                //     padding:
                //         EdgeInsets.symmetric(horizontal: width / 3, vertical: 17),
                //     child: const Text(
                //       'Contiune',
                //       style: TextStyle(
                //                   fontFamily: 'Serif',
                //                   fontSize: 20,
                //                   fontWeight: FontWeight.w700,
                //                   color: Colors.black,
                //                 ),
                //     ),
                //   ),
                //   style: OutlinedButton.styleFrom(
                //       shape: const StadiumBorder(), shadowColor: Colors.black),
                // ),
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: SizedBox(
                    width: 300,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          shadowColor: WidgetStateColor.resolveWith(
                              (states) => Colors.black),
                          // padding:
                          //     MaterialStateProperty.all<EdgeInsetsGeometry?>(
                          //         EdgeInsets.symmetric(vertical: 17)),
                          shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60.0),
                          )),
                          backgroundColor:
                              WidgetStateProperty.all<Color>(
                                  Colors.white)),
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                          fontFamily: 'Serif',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () {
                        if (selectedCountryList.isEmpty &&
                            statename.isEmpty &&
                            cityname.isEmpty) {
                          homeservice.saveprefdata.value.statelocation =
                              [];
                          homeservice.saveprefdata.value.citylocation =
                              [];
                          homeservice.saveprefdata.value.location = [];
                          setState(() {});
                        } else {
                          for (var element in selectedCountryList) {
                            selectedLocation[0]
                                .add(element.name.toString());
                          }
                          for (var element in statename) {
                            selectedLocation[1].add(element.toString());
                          }
                          for (var element in cityname) {
                            selectedLocation[2].add(element);
                          }
                          homeservice.saveprefdata.value.citylocation
                              .clear();
                          homeservice.saveprefdata.value.location
                              .clear();
                          homeservice.saveprefdata.value.statelocation
                              .clear();
                          selectedCity!.clear();
                          selectedCounty!.clear();
                          selectedState!.clear();
                          for (var i = 0; i < cityname.length; i++) {
                            selectedCity!.add({"name": cityname[i]});
                          }
                          for (var i = 0;
                              i < selectedCountryList.length;
                              i++) {
                            selectedCounty!.add(
                                {"name": selectedCountryList[i].name});
                          }
                          for (var i = 0; i < statename.length; i++) {
                            selectedState!.add({"name": statename[i]});
                          }
                          setState(() {});
                        }
                            
                        print(selectedLocation);
                        Navigator.of(context).pop(selectedLocation);
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            )),
      ),
    );
  }

  void removeState() {
    _states = [];
    stateDataList = [];
    getState().then((value) {
      var i = selectedStateList.length - 1;
      while (i >= 0) {
        print(i);
        print("${selectedStateList[i].name}");
        if (!value.map((e) => e.id).contains(selectedStateList[i].id)) {
          selectedStateList
              .removeWhere((element) => element.id == selectedStateList[i].id);
        }
        i--;
      }
      removeCity();
    });
  }

  void removeCity() {
    _cities = [];
    cityDataList = [];
    // getState();

    // _states = [];
    // stateDataList = [];
    getCity().then((value) {
      var i = selectedCityList.length - 1;
      while (i >= 0) {
        print(i);
        print("${selectedCityList[i].name}");
        if (!value.map((e) => e.id).contains(selectedCityList[i].id)) {
          selectedCityList
              .removeWhere((element) => element.id == selectedCityList[i].id);
        }
        i--;
      }
    });
  }

  List<Widget> countrySuggetion(List<StatusModel.StatusModel> countryList) {
    List<Widget> countrytemp = [];
    // scrollDirection: Axis.vertical,
    // physics: BouncingScrollPhysics(),

    // List<String> countryList = countryLists.;
    for (StatusModel.StatusModel country in countryList) {
      countrytemp.add(Container(
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                  color: const Color.fromARGB(255, 225, 223, 223), width: 1)),
          child: ListTile(
            title: Text(country.name!,
                style: TextStyle(
                  color: mainColor,
                )),
            iconColor: Colors.black,
            leading: Icon(
              Icons.location_on_outlined,
              color: mainColor,
            ),
            onTap: () {
              if (selectedCountryList.contains(country)) {
                selectedCountryList.remove(country);
                removeState();
                setState(() {});
              } else {
                selectedCountryList.add(country);
                _states = [];
                stateDataList = [];
                getState();
                countryfocus = false;
                countryController.clear();
                setState(() {});
              }
            },
            trailing: selectedCountryList.contains(country)
                ? Icon(
                    CupertinoIcons.check_mark,
                    color: mainColor,
                  )
                : null,
          ),
        ),
      ));
    }

    return countrytemp;
  }

  List<Widget> stateSuggetion(List<StatusModel.State> stateList) {
    List<Widget> statetemp = [];
    for (StatusModel.State state in stateList) {
      statetemp.add(Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
                color: const Color.fromARGB(255, 225, 223, 223), width: 1)),
        child: ListTile(
          iconColor: Colors.black,
          leading: Icon(
            Icons.location_on_outlined,
            color: mainColor,
          ),
          title: Text(state.name!,
              style: TextStyle(
                color: mainColor,
              )),
          onTap: () {
            if (selectedStateList.contains(state)) {
              selectedStateList.remove(state);
              // _cities = [];
              // cityDataList = [];
              // getCity();
              removeCity();

              setState(() {});
            } else {
              selectedStateList.add(state);
              statefocus = false;
              stateController.clear();
              cityDataList = [];
              _cities = [];
              getCity();
            }
            setState(() {});
          },
          trailing: selectedStateList.map((e) => e.id).contains(state.id)
              ? Icon(
                  CupertinoIcons.check_mark,
                  color: mainColor,
                )
              : null,
        ),
      ));
    }

    return statetemp;
  }

  // List<Widget> stateSuggetion1(List<Prediction> stateList) {
  //   List<Widget> statetemp = [];
  //   for (Prediction state in stateList) {
  //     statetemp.add(Container(
  //       margin: const EdgeInsets.symmetric(
  //         horizontal: 10,
  //       ),
  //       decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(5),
  //           border: Border.all(
  //               color: const Color.fromARGB(255, 225, 223, 223), width: 1)),
  //       child: ListTile(
  //         iconColor: Colors.black,
  //         leading: Icon(
  //           Icons.location_on_outlined,
  //           color: mainColor,
  //         ),
  //         title: Text(state.description!,
  //             style: TextStyle(
  //               color: mainColor,
  //             )),
  //         onTap: () {
  //           if (statename.contains(state.structuredFormatting!.mainText)) {
  //             statename.remove(state.structuredFormatting!.mainText);
  //             // _cities = [];
  //             // cityDataList = [];
  //             // getCity();
  //             statename.remove(state.structuredFormatting!.mainText);

  //             setState(() {});
  //           } else {
  //             onselectstate(state);
  //             statefocus = false;
  //             stateController.clear();
  //             cityDataList = [];
  //             _cities = [];
  //           }
  //           setState(() {});
  //         },
  //         // trailing:
  //         // selectedStateList.map((e) => e.id).contains(state.id)
  //         //     ? Icon(
  //         //         CupertinoIcons.check_mark,
  //         //         color: mainColor,
  //         //       )
  //         //     : null,
  //       ),
  //     ));
  //   }

  //   return statetemp;
  // }

//   List<Widget> citySuggetion1(List<Prediction> cityList) {
//     List<Widget> citytemp = [];
//     for (Prediction city in cityList) {
//       citytemp.add(Container(
//         margin: const EdgeInsets.symmetric(
//           horizontal: 10,
//         ),
//         decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(5),
//             border: Border.all(
//                 color: const Color.fromARGB(255, 225, 223, 223), width: 1)),
//         child: ListTile(
//           title: Text(city.description!,
//               style: TextStyle(
//                 color: mainColor,
//               )),
//           iconColor: Colors.black,
//           leading: Icon(
//             Icons.location_on_outlined,
//             color: mainColor,
//           ),
//           onTap: () {
//             if (cityname.contains(city.structuredFormatting!.mainText)) {
//               cityname.remove(city.structuredFormatting!.mainText);
//               // _cities = [];
//               // cityDataList = [];
//               // getCity();
//               cityname.remove(city.structuredFormatting!.mainText);

//               setState(() {});
//             } else {
//               onselectcity(city);
//               cityfocus = false;
//               cityController.clear();
//               cityDataList = [];
//             }
//             setState(() {});
//             // if (selectedCityList.contains(city)) {
//             //   selectedCityList.remove(city);
//             // } else {
//             //   selectedCityList.add(city);
//             //   cityfocus = false;
//             //   cityController.clear();
//             // }
//             // setState(() {});
//           },
//           // trailing: selectedCityList.contains(city)
//           //     ? Icon(
//           //         CupertinoIcons.check_mark,
//           //         color: mainColor,
//           //       )
//           //     : null,
//         ),
//       ));
//     }

//     return citytemp;
//   }
}

InputDecoration textFiedstyle = InputDecoration(
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(color: Colors.transparent)),
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(color: Colors.transparent)),
);
BoxDecoration containerStyle = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10),
  boxShadow: [
    BoxShadow(
      color: const Color.fromARGB(255, 208, 207, 207).withOpacity(0.5),
      spreadRadius: 2,
      blurRadius: 2,
      offset: const Offset(0, 0), // changes position of shadow
    ),
  ],
);
