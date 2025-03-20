import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ristey/global_vars.dart';
// import 'package:couple_match/screens/data_collection/smoke.dart';

String? DrinkStatus;

class Drink extends StatefulWidget {
  Drink({
    super.key,
    required this.value,
    required this.option,
  });
  List<int> value;
  List<dynamic> option;
  @override
  State<Drink> createState() => _ReligionState();
}

class _ReligionState extends State<Drink> {
  List<int> value = [];

  @override
  void initState() {
    // TODO: implement initState
    value = widget.value;
  }

  Widget CustomRadioButton(String text, int index) {
    return ElevatedButton(
      onPressed: () {
        // print("clicked");
        if (index == 0) {
          if (value.contains(index)) {
            setState(() {
              value.clear();
            });
          } else {
            value.clear();
            for (var i = 0; i < widget.option.length; i++) {
              print(i);
              setState(() {
                // DrinkStatus = text;
                value.add(i);
                print(i);
                // setData();
              });
            }
          }
        } else {
          if (value.contains(0)) {
            value.clear();
          }
          if (value.contains(index)) {
            setState(() {
              value.remove(index);
            });
          } else {
            setState(() {
              // DrinkStatus = text;
              value.add(index);
              // setData();
            });
          }
        }
      },
      style: ButtonStyle(
          padding: WidgetStateProperty.all<EdgeInsetsGeometry?>(
              const EdgeInsets.symmetric(vertical: 20)),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60.0),
                  side: BorderSide(
                      color:
                          (value.contains(index)) ? mainColor : Colors.white))),
          backgroundColor: WidgetStateProperty.all<Color>(Colors.white)),
      child: Text(
        text,
        style: TextStyle(
          color: (value.contains(index)) ? mainColor : Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: CupertinoPageScaffold(
          child: Column(
        children: [
          // SizedBox(
          //   height: 10,
          // ),
          Center(
              child: Container(
            // height: MediaQuery.of(context).size.height * 0.68,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Expanded(
                  // child:
                  // Column(
                  //   children: [
                  //     SizedBox(
                  //         width: MediaQuery.of(context).size.width * 0.9,
                  //         child: CustomRadioButton("Any", 0)),
                  //   ],
                  // ),

                  ListView.builder(
                      itemCount: widget.option.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            // Column(
                            //   children: [
                            //     Container(
                            //         width:
                            //             MediaQuery.of(context).size.width * 0.9,
                            //         child: CustomRadioButton("Any", 0)),
                            //   ],
                            // ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: CustomRadioButton(
                                    widget.option[index], index)),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        );
                      }),
                  // // )
                ],
              ),
            ),
          ))
        ],
      )),
    );
  }
}

// dynamic setData() async{
//   print(DrinkStatus);
//   final docUser = FirebaseFirestore.instance
//       .collection('user_data')
//       .doc(uid);

//   final json = {
//     'Drink': DrinkStatus,
//     // 'dob': dob
//   };

//   await docUser.update(json).catchError((error) => print(error));
// }
/*dynamic setData() async {
  SharedPref sharedPref = SharedPref();
  final json2 = await sharedPref.read("uid");
  var uid = json2['uid'];
  print(DrinkStatus);
  final docUser = FirebaseFirestore.instance.collection('user_data').doc(uid);
  try {
    User? userSave = User.fromJson(await sharedPref.read("user"));
    print(userSave.toString());

    userSave.Drink = DrinkStatus;
    print(userSave.toJson().toString());
    final json = userSave.toJson();

    await docUser.update(json).catchError((error) => print(error));

    sharedPref.save("user", userSave);
  } catch (Excepetion) {
    print(Excepetion);
  }
}*/
