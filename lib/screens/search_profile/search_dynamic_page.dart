import 'package:flutter/material.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/screens/data_collection/custom_appbar.dart';
import 'package:ristey/screens/search_profile/drink.dart';

String? DrinkStatus;

class DynamicPage extends StatefulWidget {
  DynamicPage(
      {super.key,
      required this.icon,
      required this.head,
      required this.options,
      required this.selectedopt});
  var icon;
  String head;
  List<dynamic> options;
  List<dynamic> selectedopt;
  @override
  State<DynamicPage> createState() => _DynamicPageState();
}

class _DynamicPageState extends State<DynamicPage> {
  List<int> valueList = [];
  @override
  void initState() {
    super.initState();
    if (widget.selectedopt.isNotEmpty) {
      for (var i = 0; i < widget.selectedopt.length; i++) {
        valueList.add(widget.options
            .indexWhere((element) => widget.selectedopt[i] == element));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        // A ScrollView that creates custom scroll effects using slivers.
        appBar: CustomAppBar(title:widget.head , iconImage: widget.icon,onBackButtonPressed: () {
            List<String> ds = [];
              for (var i = 0; i < valueList.length; i++) {
                // if (valueList[i] != 0) {
                ds.add(widget.options[valueList[i]]);
                // }
              }
              Navigator.of(context).pop(ds);
        },) ,
        // AppBar(
        //   // bottom: PreferredSize(
        //   //   preferredSize: Size.fromHeight(100.0), // Set the height here
        //   //   child: ,
        //   // ),
        //   backgroundColor: Colors.white,
        //   leading: InkWell(
        //     onTap: () {
        //       List<String> ds = [];
        //       for (var i = 0; i < valueList.length; i++) {
        //         // if (valueList[i] != 0) {
        //         ds.add(widget.options[valueList[i]]);
        //         // }
        //       }
        //       Navigator.of(context).pop(ds);
        //     },
        //     child: Icon(
        //       Icons.arrow_back_ios,
        //       color: mainColor,
        //     ),
        //   ),
        //   flexibleSpace: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     // crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [
        //       const SizedBox(
        //         height: 30,
        //       ),
        //       // Icon(
        //       //   widget.icon,
        //       //   color: main_color,
        //       // ),
        //       ImageIcon(
        //         AssetImage(widget.icon),
        //         size: 15,
        //         color: mainColor,
        //       ),
        //       // SizedBox(
        //       //   width: 4,
        //       // ),
        //       Text(
        //         widget.head,
        //         style: const TextStyle(
        //             color: Colors.black,
        //             fontFamily: 'Sans-serif',
        //             fontWeight: FontWeight.w700,
        //             fontSize: 24),
        //       )
        //     ],
        //   ),
        // ),
        body: WillPopScope(
          onWillPop: () async {
            List<String> ds = [];
            for (var i = 0; i < valueList.length; i++) {
              // if (valueList[i] != 0) {
              ds.add(widget.options[valueList[i]]);
              // }
            }
            Navigator.of(context).pop(ds);
            return true;
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
               
                Center(
                    child: SizedBox(
                  // height: MediaQuery.of(context).size.height * 0.85,
                  child: Column(
                    children: [
                      Drink(value: valueList, option: widget.options),
                    ],
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
