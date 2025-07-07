import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ristey/assets/error.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/ads_modal.dart';
import 'package:ristey/screens/navigation/service/ads_service.dart';
import 'package:ristey/screens/navigation/service/home_service.dart';
import 'package:ristey/screens/navigation/service/support_service.dart';
import 'package:ristey/screens/notification/widget_notification/ads_bar.dart';
import 'package:ristey/screens/profile/service/notification_service.dart';
import 'package:ristey/services/add_to_profile_service.dart';
import 'package:screenshot/screenshot.dart';
import 'package:pdf/widgets.dart' as pw;

ScreenshotController screenshotController = ScreenshotController();

class PdfDesign extends StatefulWidget {
  const PdfDesign({
    Key? key,
  }) : super(key: key);

  @override
  State<PdfDesign> createState() => _PdfDesignState();
}

class _PdfDesignState extends State<PdfDesign> {
  bool downloadButtonVisibility = true;
  Permission? permission;
  String age = '30';
  Uint8List? _imageFile;
  bool isContactvisible = true;
  bool isSizedvisible = false;
  String getDateTime() {
    DateTime dateofbirth = DateTime.fromMillisecondsSinceEpoch(userSave.dob!);
    var dt = dateofbirth.toString().substring(0, 10).split("-");
    var dob = "${dt[2]}-${dt[1]}-${dt[0]}";
    // String dateOfBirth = DateFormat('yyyy-MM-dd').format(now);
    // return dateOfBirth;
    return dob;
  }

  calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  String dob = "";
  List<AdsModel> contactads = [];
  List<AdsModel> contactlessads = [];
  List<AdsModel> sharecontactads = [];
  List<AdsModel> sharecontactlessads = [];
  List<AdsModel> usercontactads = [];
  List<AdsModel> usercontactlessads = [];
  List<AdsModel> usersharecontactads = [];
  List<AdsModel> usersharecontactlessads = [];
  void getads() async {
    usercontactads = adsuser.where((element) => element.adsid == "61").toList();
    usercontactlessads =
        adsuser.where((element) => element.adsid == "62").toList();
    usersharecontactads =
        adsuser.where((element) => element.adsid == "63").toList();
    usersharecontactlessads =
        adsuser.where((element) => element.adsid == "64").toList();

    contactads = await AdsService().getallusers(adsid: "61");
    contactlessads = await AdsService().getallusers(adsid: "62");
    sharecontactads = await AdsService().getallusers(adsid: "63");
    sharecontactlessads = await AdsService().getallusers(adsid: "64");
    setState(() {});
  }

  @override
  void initState() {
    getads();
    DateTime dateofbirth = DateTime.fromMillisecondsSinceEpoch(userSave.dob!);

    dob = DateFormat('yyyy-MM-dd').format(dateofbirth);
    super.initState();
  }

  showdialog() {
    Get.dialog(Dialog(
      // insetPadding: EdgeInsets.symmetric(horizontal: 15),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Column(
        children: [
          SizedBox(
            width: 300,
            height: 50,
            child: ElevatedButton(
              style: ButtonStyle(
                  shadowColor:
                      WidgetStateColor.resolveWith((states) => Colors.black),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60.0),
                          side: const BorderSide(
                            color: Colors.white,
                          ))),
                  backgroundColor:
                      WidgetStateProperty.all<Color>(Colors.white)),
              onPressed: () async {
                // if (downloadButtonVisibility == true) {
                downloadButtonVisibility = false;
                if (!mounted) return;
                setState(() {});
                NotificationService().addtoadminnotification(
                    userid: userSave.uid!,
                    useremail: userSave.email!,
                    subtitle: "DOWNLOAD BIODATA",
                    userimage: userSave.imageUrls!.isEmpty
                        ? ""
                        : userSave.imageUrls![0],
                    title:
                        "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} DOWNLOAD BIODATA");
                await createPDF();
                // downloadButtonVisibility = true;
                if (!mounted) return;
                setState(() {});
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        content: SnackBarContent(
                          error_text: "Download Successfully",
                          appreciation: "",
                          icon: Icons.check_circle,
                          sec: 2,
                        ),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      );
                    });
                // }
              },
              child: const Text(
                "Download with contact",
                style: TextStyle(
                  fontFamily: 'Serif',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 300,
            height: 50,
            child: ElevatedButton(
              style: ButtonStyle(
                  shadowColor:
                      WidgetStateColor.resolveWith((states) => Colors.black),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60.0),
                          side: const BorderSide(
                            color: Colors.white,
                          ))),
                  backgroundColor:
                      WidgetStateProperty.all<Color>(Colors.white)),
              onPressed: () async {
                // if (downloadButtonVisibility == true) {
                downloadButtonVisibility = false;
                isContactvisible = false;

                if (!mounted) return;
                setState(() {});
                NotificationService().addtoadminnotification(
                    userid: userSave.uid!,
                    useremail: userSave.email!,
                    subtitle: "DOWNLOAD BIODATA",
                    userimage: userSave.imageUrls!.isEmpty
                        ? ""
                        : userSave.imageUrls![0],
                    title:
                        "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} SHARE BIODATA (W)");
                await createPDF();
                // downloadButtonVisibility = true;
                if (!mounted) return;
                setState(() {});
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        content: SnackBarContent(
                          error_text: "Download Successfully",
                          appreciation: "",
                          icon: Icons.check_circle,
                          sec: 2,
                        ),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      );
                    });
                // }
              },
              child: const Text(
                "Download without contact",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Serif',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      textStyle: GoogleFonts.montserrat(),
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Screenshot(
                controller: screenshotController,
                child: Container(
                  width: 420,
                  height: 544,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/blackbg.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      //This is the main container for the profile image,name and titles.
                      SizedBox(
                        width: 500,
                        child: Row(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: <Widget>[
                                Image.asset(
                                  'assets/images/greenheaderbg.png',
                                  width: 260,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  left: 20,
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            "MATRIMONIAL",
                                            style:
                                                CustomTextStyle.heavyboldwhite,
                                          ),
                                          Text("BIODATA",
                                              style: CustomTextStyle
                                                  .heavyboldwhite),
                                          const SizedBox(
                                            height: 32,
                                          ),
                                          isContactvisible
                                              ? Text(
                                                  userSave.displayName![0]
                                                          .toUpperCase() +
                                                      userSave.displayName!
                                                          .substring(1),
                                                  style: CustomTextStyle
                                                      .heavyboldblue)
                                              : Text(
                                                  userSave.displayName![0]
                                                      .toUpperCase(),
                                                  style: CustomTextStyle
                                                      .heavyboldblue),
                                          Text(
                                            userSave.surname![0].toUpperCase() +
                                                userSave.surname!.substring(1),
                                            style:
                                                CustomTextStyle.heavyboldblue,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 130,
                                  top: -3,
                                  child: Stack(children: <Widget>[
                                    Positioned(
                                      left: 15,
                                      top: 15,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        child: Image.network(
                                          userSave.imageUrls![0],
                                          width: 130,
                                          fit: BoxFit.cover,
                                          height: 130,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      child: Image.asset(
                                        'assets/images/circular-style.png',
                                        width: 152,
                                        height: 152,
                                      ),
                                    )
                                  ]),
                                ),
                                Positioned(
                                  left: 275,
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Text("EDUCATION",
                                              style:
                                                  CustomTextStyle.normalblue),
                                          Text(
                                            userSave.Education!,
                                            style: CustomTextStyle.normalwhite,
                                          ),
                                          const SizedBox(
                                            height: 22,
                                          ),
                                          Text("INCOME",
                                              style:
                                                  CustomTextStyle.normalblue),
                                          Text(
                                            userSave.Income!,
                                            style: CustomTextStyle.normalwhite,
                                          ),
                                          const SizedBox(
                                            height: 22,
                                          ),
                                          Text("PROFESSION",
                                              style:
                                                  CustomTextStyle.normalblue),
                                          Text(
                                            userSave.Profession!,
                                            style: CustomTextStyle.normalwhite,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      //Container for User Details
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //Left Part of User Details Strating with Gender
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text("Gender: ",
                                            style: CustomTextStyle.Smallbold),
                                        Text(
                                          userSave.gender!,
                                          style: CustomTextStyle.Smallnormal,
                                        )
                                      ],
                                    ),

                                    Row(
                                      children: [
                                        const Text("Date of Birth: ",
                                            style: CustomTextStyle.Smallbold),
                                        Text(
                                          dob,
                                          style: CustomTextStyle.Smallnormal,
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text("Place of Birth: ",
                                            style: CustomTextStyle.Smallbold),
                                        SizedBox(
                                          width: Get.width * 0.2,
                                          child: Text(
                                            userSave.placeofbirth!,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: CustomTextStyle.Smallnormal,
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text("Time of Birth: ",
                                            style: CustomTextStyle.Smallbold),
                                        Text(
                                          userSave.timeofbirth!,
                                          style: CustomTextStyle.Smallnormal,
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text("Age: ",
                                            style: CustomTextStyle.Smallbold),
                                        Text(
                                          calculateAge(DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      userSave.dob!))
                                              .toString(),
                                          style: CustomTextStyle.Smallnormal,
                                        )
                                      ],
                                    ),

                                    Row(
                                      children: [
                                        const Text("Religion: ",
                                            style: CustomTextStyle.Smallbold),
                                        Text(
                                          userSave.religion!,
                                          style: CustomTextStyle.Smallnormal,
                                        )
                                      ],
                                    ),

                                    userSave.religion == "Hindu"
                                        ? Row(
                                            children: [
                                              const Text("Kundli Dosh: ",
                                                  style: CustomTextStyle
                                                      .Smallbold),
                                              Text(
                                                userSave.KundaliDosh!,
                                                style:
                                                    CustomTextStyle.Smallnormal,
                                              )
                                            ],
                                          )
                                        : Container(),

                                    Row(
                                      children: [
                                        const Text("Marital Status: ",
                                            style: CustomTextStyle.Smallbold),
                                        Text(
                                          userSave.MartialStatus!,
                                          style: CustomTextStyle.Smallnormal,
                                        )
                                      ],
                                    ),

                                    Row(
                                      children: [
                                        const Text("Diet: ",
                                            style: CustomTextStyle.Smallbold),
                                        Text(
                                          userSave.Diet!,
                                          style: CustomTextStyle.Smallnormal,
                                        )
                                      ],
                                    ),

                                    Row(
                                      children: [
                                        const Text("Drink: ",
                                            style: CustomTextStyle.Smallbold),
                                        Text(
                                          userSave.Drink!,
                                          style: CustomTextStyle.Smallnormal,
                                        )
                                      ],
                                    ),

                                    // Row(
                                    //   children: [
                                    //     Text("Gender: ",style: CustomTextStyle.Smallbold),
                                    //     Text(, style: CustomTextStyle.Smallnormal,)
                                    //   ],
                                    // ),

                                    Row(
                                      children: [
                                        const Text("Smoke: ",
                                            style: CustomTextStyle.Smallbold),
                                        Text(
                                          userSave.Smoke!,
                                          style: CustomTextStyle.Smallnormal,
                                        )
                                      ],
                                    ),

                                    Row(
                                      children: [
                                        const Text("Disability: ",
                                            style: CustomTextStyle.Smallbold),
                                        Text(
                                          userSave.Disability!,
                                          style: CustomTextStyle.Smallnormal,
                                        )
                                      ],
                                    ),

                                    Row(
                                      children: [
                                        const Text("Height: ",
                                            style: CustomTextStyle.Smallbold),
                                        Text(
                                          userSave.Height!,
                                          style: CustomTextStyle.Smallnormal,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 50),

                              //Contact part
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "CONTACT",
                                    style: CustomTextStyle.boldblue,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      // Image.asset(
                                      //   'assets/images/phone.png',
                                      //   width: 18,
                                      //   height: 18,
                                      //   fit: BoxFit.cover,
                                      // ),
                                      Container(
                                        height: 17,
                                        width: 17,
                                        decoration: BoxDecoration(
                                            color: mainColor,
                                            shape: BoxShape.circle),
                                        child: const Center(
                                          child: Icon(
                                            Icons.person,
                                            size: 10,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        userSave.puid!,
                                        style: CustomTextStyle.midsmallnormal,
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Visibility(
                                    visible: isSizedvisible,
                                    child: const SizedBox(
                                      width: 150,
                                    ),
                                  ),
                                  Visibility(
                                    visible: isContactvisible,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              'assets/images/phone.png',
                                              width: 18,
                                              height: 18,
                                              fit: BoxFit.cover,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              userSave.phone!,
                                              style: CustomTextStyle
                                                  .midsmallnormal,
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              'assets/images/email.png',
                                              width: 17,
                                              height: 17,
                                              fit: BoxFit.cover,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              userSave.email!,
                                              style: CustomTextStyle
                                                  .midsmallnormal,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 1,
                                      ),
                                      Image.asset(
                                        'assets/images/home.png',
                                        width: 17,
                                        height: 17,
                                        fit: BoxFit.cover,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "${userSave.city!},${userSave.state!},${userSave.country}",
                                        style: CustomTextStyle.midsmallnormal,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      SizedBox(
                        width: 345,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "ABOUT ME",
                              style: CustomTextStyle.boldblue,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              (userSave.About_Me == null ||
                                      userSave.About_Me == "")
                                  ? "Welcome to my profile. I'm here to find someone who appreciates authenticity and kindness. Hope you find what you're looking for."
                                  : userSave.About_Me!,
                              style: CustomTextStyle.midsmallnormal,
                            )
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      SizedBox(
                        width: 345,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "EXPECTATIONS",
                              style: CustomTextStyle.boldblue,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              (userSave.Partner_Prefs == null ||
                                      userSave.Partner_Prefs == "")
                                  ? "I am looking for a meaningful connection based on mutual respect, trust and shared values. Someone who is ready to grow and learn with me on this journey I would like to Connect"
                                  : userSave.Partner_Prefs!,
                              style: CustomTextStyle.midsmallnormal,
                            )
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Container(
                          //   width: MediaQuery.of(context).size.width - 120,
                          //   height: 10,
                          // ),
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            height: MediaQuery.of(context).size.height * 0.04,
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: const Image(
                              image:
                                  AssetImage("images/icons/free_ristawala.png"),
                            ),
                          ),
                          SizedBox(
                              width: 95,
                              child: Image.asset(
                                'assets/images/qrcode.png',
                                width: 48,
                                height: 48,
                                color: Colors.white.withOpacity(0.8),
                                colorBlendMode: BlendMode.modulate,
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                // width: MediaQuery.of(context).size.height * 0.2,
                width: 300,
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                      shadowColor: WidgetStateColor.resolveWith(
                          (states) => Colors.black),
                      // padding:
                      //     MaterialStateProperty.all<EdgeInsetsGeometry?>(
                      //         EdgeInsets.symmetric(vertical: 17)),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60.0),
                              side: const BorderSide(
                                color: Colors.white,
                              ))),
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.white)),
                  onPressed: () async {
                    SupprotService().deletesendlink(
                        email: userSave.email!, value: "To Download Biodata");

                    // showdialog();
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: SizedBox(
                            height: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  // width: MediaQuery.of(context).size.height * 0.2,
                                  width: 350,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        shadowColor:
                                            WidgetStateColor.resolveWith(
                                                (states) => Colors.black),
                                        // padding:
                                        //     MaterialStateProperty.all<EdgeInsetsGeometry?>(
                                        //         EdgeInsets.symmetric(vertical: 17)),
                                        shape: WidgetStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(60.0),
                                                side: const BorderSide(
                                                  color: Colors.white,
                                                ))),
                                        backgroundColor:
                                            WidgetStateProperty.all<Color>(
                                                Colors.white)),
                                    onPressed: () async {
                                      // showdialog();
                                      HomeService().createbiodataprofile(
                                        editname:
                                            "Download by ${userSave.name}",
                                      );

                                      AddToProfileService()
                                          .updatedownloadbiodata();
                                      if (!mounted) return;
                                      setState(() {});
                                      SupprotService().deletesendlink(
                                          email: userSave.email!,
                                          value: "To Download Biodata");
                                      NotificationService().addtoadminnotification(
                                          userid: userSave.uid!,
                                          useremail: userSave.email!,
                                          subtitle: "DOWNLOAD BIODATA",
                                          userimage: userSave.imageUrls!.isEmpty
                                              ? ""
                                              : userSave.imageUrls![0],
                                          title:
                                              "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} DOWNLOAD BIODATA");
                                      await createPDF();
                                      // downloadButtonVisibility = true;
                                      if (!mounted) return;
                                      setState(() {});
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return const AlertDialog(
                                              content: SnackBarContent(
                                                error_text:
                                                    "Download Successfully",
                                                appreciation: "",
                                                icon: Icons.check_circle,
                                                sec: 2,
                                              ),
                                              backgroundColor:
                                                  Colors.transparent,
                                              elevation: 0,
                                            );
                                          }).whenComplete(() {
                                        if (usercontactads.isNotEmpty) {
                                          showadsbar(context, usercontactads,
                                              () async {
                                            Navigator.pop(context);
                                          });
                                        } else {
                                          if (contactads.isNotEmpty) {
                                            showadsbar(context, contactads,
                                                () async {
                                              Navigator.pop(context);
                                            });
                                          }
                                        }
                                      });
                                    },
                                    child: const Text(
                                      "Download with Contact",
                                      style: TextStyle(
                                        fontFamily: 'Sans-serif',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  // width: MediaQuery.of(context).size.height * 0.2,
                                  width: 380,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        shadowColor:
                                            WidgetStateColor.resolveWith(
                                                (states) => Colors.black),
                                        // padding:
                                        //     MaterialStateProperty.all<EdgeInsetsGeometry?>(
                                        //         EdgeInsets.symmetric(vertical: 17)),
                                        shape: WidgetStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(60.0),
                                                side: const BorderSide(
                                                  color: Colors.white,
                                                ))),
                                        backgroundColor:
                                            WidgetStateProperty.all<Color>(
                                                Colors.white)),
                                    onPressed: () async {
                                      HomeService().createbiodataprofile(
                                        editname:
                                            "Download by ${userSave.name} (W)",
                                      );

                                      AddToProfileService()
                                          .updatedownloadbiodata();
                                      SupprotService().deletesendlink(
                                          email: userSave.email!,
                                          value: "To Download Biodata");
                                      isContactvisible = false;
                                      isSizedvisible = true;
                                      if (!mounted) return;
                                      setState(() {});
                                      NotificationService().addtoadminnotification(
                                          userid: userSave.uid!,
                                          useremail: userSave.email!,
                                          subtitle: "DOWNLOAD BIODATA",
                                          userimage: userSave.imageUrls!.isEmpty
                                              ? ""
                                              : userSave.imageUrls![0],
                                          title:
                                              "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} DOWNLOAD BIODATA(W)");
                                      await createPDF();
                                      if (!mounted) return;
                                      setState(() {});
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return const AlertDialog(
                                              content: SnackBarContent(
                                                error_text:
                                                    "Download Successfully",
                                                appreciation: "",
                                                icon: Icons.check_circle,
                                                sec: 2,
                                              ),
                                              backgroundColor:
                                                  Colors.transparent,
                                              elevation: 0,
                                            );
                                          }).whenComplete(() {
                                        if (usercontactlessads.isNotEmpty) {
                                          showadsbar(
                                              context, usercontactlessads,
                                              () async {
                                            Navigator.pop(context);
                                          });
                                        } else {
                                          if (contactlessads.isNotEmpty) {
                                            showadsbar(context, contactlessads,
                                                () async {
                                              Navigator.pop(context);
                                            });
                                          }
                                        }
                                      });

                                      // }
                                    },
                                    child: const Text(
                                      "Download without Contact",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Sans-serif',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: const Text(
                    "Download",
                    style: TextStyle(
                      fontFamily: 'Sans-serif',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                // width: MediaQuery.of(context).size.height * 0.2,
                width: 300,
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                      shadowColor: WidgetStateColor.resolveWith(
                          (states) => Colors.black),
                      // padding:
                      //     MaterialStateProperty.all<EdgeInsetsGeometry?>(
                      //         EdgeInsets.symmetric(vertical: 17)),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60.0),
                              side: const BorderSide(
                                color: Colors.white,
                              ))),
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.white)),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: SizedBox(
                            height: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  // width: MediaQuery.of(context).size.height * 0.2,
                                  width: 300,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        shadowColor:
                                            WidgetStateColor.resolveWith(
                                                (states) => Colors.black),
                                        // padding:
                                        //     MaterialStateProperty.all<EdgeInsetsGeometry?>(
                                        //         EdgeInsets.symmetric(vertical: 17)),
                                        shape: WidgetStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(60.0),
                                                side: const BorderSide(
                                                  color: Colors.white,
                                                ))),
                                        backgroundColor:
                                            WidgetStateProperty.all<Color>(
                                                Colors.white)),
                                    onPressed: () async {
                                      // showdialog();
                                      HomeService().createbiodataprofile(
                                        editname: "Shared by ${userSave.name} ",
                                      );

                                      SupprotService().deletesendlink(
                                          email: userSave.email!,
                                          value: "To Download Biodata");
                                      if (!mounted) return;
                                      setState(() {});
                                      AddToProfileService().updatesupport();
                                      await _takeScreenshotandShare();
                                      NotificationService().addtoadminnotification(
                                          userid: userSave.uid!,
                                          useremail: userSave.email!,
                                          subtitle: "DOWNLOAD BIODATA",
                                          userimage: userSave.imageUrls!.isEmpty
                                              ? ""
                                              : userSave.imageUrls![0],
                                          title:
                                              "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} SHARE BIODATA");
                                      if (!mounted) return;
                                      setState(() {});
                                      SupprotService().deletesendlink(
                                          email: userSave.email!,
                                          value: "To Download Biodata");
                                      if (usersharecontactads.isNotEmpty) {
                                        showadsbar(context, usersharecontactads,
                                            () async {
                                          Navigator.pop(context);
                                        });
                                      } else {
                                        if (sharecontactads.isNotEmpty) {
                                          showadsbar(context, sharecontactads,
                                              () async {
                                            Navigator.pop(context);
                                          });
                                        }
                                      }
                                    },
                                    child: const Text(
                                      "Share with Contact",
                                      style: TextStyle(
                                        fontFamily: 'Sans-serif',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  // width: MediaQuery.of(context).size.height * 0.2,
                                  width: 350,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        shadowColor:
                                            WidgetStateColor.resolveWith(
                                                (states) => Colors.black),
                                        // padding:
                                        //     MaterialStateProperty.all<EdgeInsetsGeometry?>(
                                        //         EdgeInsets.symmetric(vertical: 17)),
                                        shape: WidgetStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(60.0),
                                                side: const BorderSide(
                                                  color: Colors.white,
                                                ))),
                                        backgroundColor:
                                            WidgetStateProperty.all<Color>(
                                                Colors.white)),
                                    onPressed: () async {
                                      HomeService().createbiodataprofile(
                                        editname:
                                            "Shared by ${userSave.name} (W)",
                                      );
                                      AddToProfileService().updatesupport();
                                      NotificationService().addtoadminnotification(
                                          userid: userSave.uid!,
                                          useremail: userSave.email!,
                                          subtitle: "DOWNLOAD BIODATA",
                                          userimage: userSave.imageUrls!.isEmpty
                                              ? ""
                                              : userSave.imageUrls![0],
                                          title:
                                              "${userSave.name!.substring(0, 1)} ${userSave.surname!.toUpperCase()} ${userSave.puid} SHARE BIODATA (W)");
                                      SupprotService().deletesendlink(
                                          email: userSave.email!,
                                          value: "To Download Biodata");

                                      isContactvisible = false;
                                      isSizedvisible = true;
                                      if (!mounted) return;
                                      setState(() {});
                                      await _takeScreenshotandShare();

                                      if (!mounted) return;
                                      setState(() {});
                                      if (usersharecontactads.isNotEmpty) {
                                        showadsbar(context, usersharecontactads,
                                            () async {
                                          Navigator.pop(context);
                                        });
                                      } else {
                                        if (sharecontactads.isNotEmpty) {
                                          showadsbar(context, sharecontactads,
                                              () async {
                                            Navigator.pop(context);
                                          });
                                        }
                                      }
                                      // }
                                    },
                                    child: const Text(
                                      "Share without Contact",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Sans-serif',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: const Text(
                    "Share",
                    style: TextStyle(
                      fontFamily: 'Sans-serif',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _takeScreenshotandShare() async {
    _imageFile = null;
    print("ok");
    screenshotController
        .capture(delay: const Duration(milliseconds: 500), pixelRatio: 2.0)
        .then((Uint8List? image) async {
      if (!mounted) return;
      setState(() {
        _imageFile = image;
      });

      final pdf = pw.Document(
        pageMode: PdfPageMode.fullscreen,
      );

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Image(
              pw.MemoryImage(_imageFile!),
              fit: pw.BoxFit.contain,
            );
          },
        ),
      );

      // Save the PDF to a temporary file
      final output = await getTemporaryDirectory();
      final filePath = File('${output.path}/${userSave.puid}.pdf');
      await filePath.writeAsBytes(await pdf.save());
      
      // Import the share_plus package at the top of the file if not already imported
      // import 'package:share_plus/share_plus.dart';
      
      // Share the PDF file
      await Share.shareXFiles(
        [XFile(filePath.path)],
        text: 'Check out my profile from Free Risthey Wala',
        subject: 'Free Risthey Wala Profile',
      );
      
      isContactvisible = true;
      isSizedvisible = false;
      setState(() {});
    }).catchError((onError) {
      print("Error sharing PDF: $onError");
    });
  }

  createPDF() async {
    // await _takeScreenshotandShare(false);
    screenshotController
        .capture(delay: const Duration(milliseconds: 500), pixelRatio: 2.0)
        .then((Uint8List? image) async {
      if (!mounted) return;
      setState(() {
        _imageFile = image;
      });

      final pdf = pw.Document(
        pageMode: PdfPageMode.fullscreen,
      );

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Image(
                pw.MemoryImage(
                  _imageFile!,
                ),
                // width: PdfPageFormat.a4.width,

                // // alignment: pw.Alignment.centerLeft,

                // height: PdfPageFormat.a4.height,
                fit: pw.BoxFit.contain);
          },
        ),
      );

      // Save the PDF to a file
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/${userSave.puid}.pdf');
      print(file);
      await file.writeAsBytes(await pdf.save());
      final result = await OpenFile.open(file.path);
      isContactvisible = true;
      isSizedvisible = false;
      setState(() {});
      if (result.type != ResultType.done) {
        // Handle the error here
        print("Error opening the PDF: ${result.message}");
      }
    });
  }

  Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
    final path = (await getExternalStorageDirectory())!.path;
    print("Path : $path");
    final file = File('$path/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open("$path/$fileName");
  }

  Future<Uint8List> readImageData() async {
    final directory = (await getExternalStorageDirectory())!.path;
    print("Directory : $directory");
    final file = File('$directory/${userSave.puid}.png');
    return await file.readAsBytes();
  }
}

class CustomTextStyle {
  static const TextStyle Smallbold = TextStyle(
    fontSize: 8,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle Smallnormal = TextStyle(
    fontSize: 7,
    color: Colors.white,
  );

  static const TextStyle midsmallnormal = TextStyle(
    fontSize: 9,
    color: Colors.white,
  );

  static TextStyle midbold = TextStyle(
    fontSize: 13,
    color: mainColor,
    fontWeight: FontWeight.bold,
  );

  static TextStyle heavyboldwhite = GoogleFonts.montserrat(
    color: Colors.white,
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );

  static TextStyle heavyboldblue = GoogleFonts.montserrat(
    color: const Color(0xff0697d3),
    fontSize: 15.5,
    fontWeight: FontWeight.w900,
  );

  static TextStyle boldblue = GoogleFonts.montserrat(
      color: const Color(0xff0697d3),
      fontSize: 14,
      fontWeight: FontWeight.w800,
      letterSpacing: 0.8);
  static TextStyle normalblue = TextStyle(
    color: mainColor,
    fontSize: 11,
    fontWeight: FontWeight.w900,
    letterSpacing: 1,
  );
  static TextStyle normalwhite = const TextStyle(
      color: Colors.white, fontSize: 10, fontWeight: FontWeight.w400);
}
