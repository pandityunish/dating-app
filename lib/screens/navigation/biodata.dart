import 'package:flutter/material.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/screens/navigation/home.dart';
import 'package:ristey/screens/navigation/navigation.dart';
import 'package:ristey/small_functions/profile_completion.dart';

class BioData extends StatefulWidget {
  const BioData({super.key});

  @override
  State<BioData> createState() => _BioDataState();
}

class _BioDataState extends State<BioData> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            children: [
              // SizedBox(
              //   width: 20,
              // ),
              Container(
                // margin: EdgeInsets.only(right: 10),
                child: BigText(
                  text: "Matrimonial Biodata",
                  size: 20,
                  color: mainColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              // SizedBox(
              //   width: 20,
              // )
            ],
          ),
          titleSpacing: 5.0,
          leading: GestureDetector(
            onTap: () async {
              ProfileCompletion profile = ProfileCompletion();
              int profilepercentage = await profile.profileComplete();

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyProfile(
                            profilepercentage: profilepercentage,
                          )));
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              color: mainColor,
              size: 25,
            ),
          ),
          elevation: 0.5,
        ),
        body: const SingleChildScrollView(
          child: Column(
            children: [PdfDesign()],
          ),
        ),
      ),
    );
  }
}
