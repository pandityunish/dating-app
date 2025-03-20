import 'package:flutter/material.dart';
import 'package:ristey/chat/colors.dart';
import 'package:ristey/global_vars.dart';

class AgeSelectionScreen extends StatefulWidget {
  AgeSelectionScreen({super.key, this.agelist});
  var agelist;
  @override
  State<AgeSelectionScreen> createState() => _AgeSelectionScreenState();
}

class _AgeSelectionScreenState extends State<AgeSelectionScreen> {
  int _minAge = (userSave.gender == "female") ? 21 : 18;
  int _maxAge = 70;
  @override
  void initState() {
    super.initState();
    setState(() {
      print("${widget.agelist} hlsdjfa");
      if (widget.agelist.isNotEmpty) {
        _minAge = int.parse(widget.agelist[0]);
        _maxAge = int.parse(widget.agelist[1]);
      }
    });
  }

  List<DropdownMenuItem<int>> _getDropdownItems(int start, int end) {
    List<DropdownMenuItem<int>> items = [];
    for (int i = start; i <= end; i++) {
      items.add(
        DropdownMenuItem(
          value: i,
          child: Text(i.toString()),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              List<String> res = [_minAge.toString(), _maxAge.toString()];
              print(res);

              Navigator.of(context).pop(res);
              setState(() {});
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
                  const AssetImage('images/icons/calender.png'),
                  size: 25,
                  color: mainColor,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "Age",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: mainColor,
                      fontSize: 20),
                ),
              ],
            ),
          ),
        ),
        body: WillPopScope(
          onWillPop: () async {
            List<String> res = [_minAge.toString(), _maxAge.toString()];

            Navigator.of(context).pop(res);
            setState(() {});
            return true;
          },
          child: SingleChildScrollView(
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
                        "Please Select Age Preference",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 20),
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
                          padding: const EdgeInsets.only(top: 15,left: 15,right: 15,),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 30,
                                width: 70,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: mainColor, width: 1)),
                                child:  Center(
                                  child: Text("Min Age",style: TextStyle(color: mainColor),),
                                ),
                              ),
                              Container(
                                height: 30,
                                width: 70,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: mainColor, width: 1)),
                                child:  Center(
                                  child: Text("Max Age",style: TextStyle(color: mainColor),),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35,vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: mainColor),
                                  child: Center(
                                      child: Text(
                                    _minAge.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ))),
                              Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: mainColor),
                                  child: Center(
                                      child: Text(
                                    _maxAge.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ))),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 30,
                                width: 70,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: mainColor, width: 1)),
                                child: Center(
                                  // child: DropdownButton(
                                  //     alignment: Alignment.center,
                                  //     style: const TextStyle(
                                  //         fontSize: 20, color: Colors.black),
                                  //     items: porductCategories.map((String item) {
                                  //       return DropdownMenuItem(
                                  //           value: item, child: Text(item));
                                  //     }).toList(),
                                  //     value: categoty,
                                  //     icon: const Icon(Icons.keyboard_arrow_down),
                                  //     onChanged: (String? newval) {
                                  //       setState(() {
                                  //         categoty = newval!;
                                  //       });
                                  //     }),
                                  child: DropdownButton<int>(
                                    underline: const Text(""),
                                    value: _minAge,
                                    style: TextStyle(color: mainColor),
                                    iconEnabledColor: mainColor,
                                    items: _getDropdownItems(
                                        (userSave.gender == "female") ? 21 : 18,
                                        70),
                                    onChanged: (int? value) {
                                      setState(() {
                                        _minAge = value!;
                                        if (_maxAge < _minAge) {
                                          _maxAge = _minAge;
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                height: 30,
                                width: 70,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: mainColor, width: 1)),
                                child: Center(
                                  // child: DropdownButton(
                                  //     alignment: Alignment.center,
                                  //     style: const TextStyle(
                                  //         fontSize: 20, color: Colors.black),
                                  //     items: porductCategories1.map((String item) {
                                  //       return DropdownMenuItem(
                                  //           value: item, child: Text(item));
                                  //     }).toList(),
                                  //     value: categoty1,
                                  //     icon: const Icon(Icons.keyboard_arrow_down),
                                  //     onChanged: (String? newval) {
                                  //       setState(() {
                                  //         categoty1 = newval!;
                                  //       });
                                  //     }),
                                  child: DropdownButton<int>(
                                    underline: const Text(""),
                                    value: _maxAge,
                                     style: TextStyle(color: mainColor),
                                    iconEnabledColor: mainColor,
                                    items: _getDropdownItems(_minAge + 1, 70),
                                    onChanged: (int? value) {
                                      setState(() {
                                        _maxAge = value!;
                                        if (_maxAge < _minAge) {
                                          _minAge = _maxAge;
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
        ),
      ),
    );
  }
}
