// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/user_modal.dart';
import 'package:ristey/screens/navigation/service/home_service.dart';

// import 'package:couple_match/screens/profile/service/home_service.dart';

class HeightScreens extends StatefulWidget {
  var heightlist;
  HeightScreens({
    Key? key,
    this.heightlist,
  }) : super(key: key);

  @override
  State<HeightScreens> createState() => _HeightScreensState();
}

class _HeightScreensState extends State<HeightScreens> {
  SearchDataList sdl = SearchDataList();
  HomeService homeService = Get.put(HomeService());
  int _minHeight = 0;
  int _maxHeight = 60;
  SavedPref svp = SavedPref();

  late List<DropdownMenuItem<int>> _minHeightDropdownItems;
  late List<DropdownMenuItem<int>> _maxHeightDropdownItems;

  List<DropdownMenuItem<double>> _getDropdownItems(int start, int end) {
    List<DropdownMenuItem<double>> items = [];
    for (int i = start; i <= end; i += 1) {
      items.add(
        DropdownMenuItem(
          value: i * 1.0,
          child: Text(sdl.Height[i]),
        ),
      );
    }
    return items;
  }

  @override
  void initState() {
    setState(() {
      print("${widget.heightlist} height");
      if (widget.heightlist.isNotEmpty) {
        _minHeight = int.parse(widget.heightlist[0]);
        _maxHeight = int.parse(widget.heightlist[1]);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            List<String> res = [_minHeight.toString(), _maxHeight.toString()];
            Navigator.of(context).pop(res);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: mainColor,
          ),
        ),
        toolbarHeight: 80,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ImageIcon(
                const AssetImage('images/icons/height.png'),
                size: 18,
                color: mainColor,
              ),
              Text(
                "Height",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                    fontSize: 20),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Please Select Height Criteria",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        fontFamily: 'Sans-serif'),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 223, 223, 223),
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 26,
                            width: 70,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: mainColor, width: 1)),
                            child: Center(
                              child: Text(
                                "Min Height",
                                style:
                                    TextStyle(color: mainColor, fontSize: 12),
                              ),
                            ),
                          ),
                          Container(
                            height: 26,
                            width: 70,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: mainColor, width: 1)),
                            child: Center(
                              child: Text(
                                "Max Height",
                                style:
                                    TextStyle(color: mainColor, fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              height: 25,
                              width: 70,
                              decoration: BoxDecoration(color: mainColor),
                              child: Center(
                                  child: Text(
                                sdl.Height[_minHeight],
                                style: const TextStyle(color: Colors.white),
                              ))),
                          Container(
                              height: 25,
                              width: 70,
                              decoration: BoxDecoration(color: mainColor),
                              child: Center(
                                  child: Text(
                                sdl.Height[_maxHeight],
                                style: const TextStyle(color: Colors.white),
                              ))),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 25,
                            width: 73,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: mainColor, width: 1)),
                            child: Center(
                              child: DropdownButton<double>(
                                underline: const Text(""),
                                value: _minHeight * 1.0,
                                padding: EdgeInsets.only(left: 4),
                                style: TextStyle(fontSize: 10,color: mainColor),
                                iconEnabledColor: mainColor,
                                items: _getDropdownItems(0, 60),
                                onChanged: (double? value) {
                                  setState(() {
                                    _minHeight = value! ~/ 1;
                                    if (_maxHeight < _minHeight) {
                                      _maxHeight = _minHeight;
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                          Container(
                           height: 25,
                            width: 73,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: mainColor, width: 1)),
                            child: Center(
                              child: DropdownButton<double>(
                                underline: const Text(""),
                                value: _maxHeight * 1.0,
                                padding: EdgeInsets.only(left: 4),

                                
                                style: TextStyle(fontSize: 10,color: mainColor),
                                iconEnabledColor: mainColor,
                                items: _getDropdownItems(_minHeight, 60),
                                onChanged: (double? value) {
                                  setState(() {
                                    _maxHeight = value! ~/ 1;
                                    if (_maxHeight < _minHeight) {
                                      _minHeight = _maxHeight;
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
