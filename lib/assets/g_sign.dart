import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ristey/Assets/Error.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/ads_modal.dart';
import 'package:ristey/models/shared_pref.dart';
import 'package:ristey/screens/data_collection/lets_start.dart';
import 'package:ristey/screens/main_screen.dart';
import 'package:ristey/screens/navigation/service/ads_service.dart';
import 'package:ristey/screens/navigation/service/auth_service.dart';
import 'package:ristey/screens/navigation/service/home_service.dart';
import 'package:ristey/screens/navigation/service/notification_local_function.dart';
import 'package:ristey/screens/notification/widget_notification/ads_bar.dart';
import 'package:ristey/screens/profile/profile_scroll.dart';
import 'package:ristey/screens/profile/service/notification_service.dart';
import 'package:ntp/ntp.dart';
import '../models/user_modal.dart' as usr;

class G_Sign extends StatefulWidget {
  var term;

  G_Sign({Key? key, required this.term}) : super(key: key);

  @override
  State<G_Sign> createState() => _G_SignState();
}

class _G_SignState extends State<G_Sign> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      key: scaffoldKey,
      padding: const EdgeInsets.only(top: 20),
      child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: SignInButton(
              Buttons.GoogleDark,
              padding: const EdgeInsets.all(5),
              onPressed: () async {
                if (widget.term == false) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 1),
                      content: SnackBarContent(
                        error_text: "Term's & Condition is not Marked",
                        appreciation: "",
                        icon: Icons.error,
                        sec: 2,
                      ),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                  );
                } else {
                  try {
                    await signup(context);
                    isLogin = true;
                    // Navigator.of(context).pop();
                    // Tpage.transferPage(context,"gsign");
                    // globals.isLoggedIn = true;

                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => LetsStart()));
                  } catch (e) {
                    print(e);
                  }

                  // }).catchError((e) => print(e));
                }
              },
            ),
          )),
    );
  }

  Position? _currentPosition;
  String? _currentAddress;
  String? location;
  Placemark? place;

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _getAddressFromLatLng();
      });
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);
      place = placemarks[0];
      setState(() {
        _currentAddress =
            "${place!.locality}, ${place!.postalCode}, ${place!.country}";
        // print(_currentAddress);
        location = _currentAddress;
      });
    } catch (e) {
      print(e);
    }
  }
}

String? uid = uid_value;
final FirebaseAuth auth = FirebaseAuth.instance;
UserService authService = Get.put(UserService());
void showads1(BuildContext context) async {
  List<AdsModel> allads2 = [];

  allads2 = await AdsService().getallusers(adsid: "8");

  if (allads2.isEmpty) {
  } else {
    showadsbar(context, allads2, () {
      Navigator.pop(context);
    });
  }
}

Future<dynamic> signup(BuildContext context) async {
  try {
    // Initialize the list for ads
    List<AdsModel> allAds = [];

    // Function to show ads bar
    void showAdsBar() {
      showadsbar(context, allAds, () {
        Navigator.pop(context);
      });
    }

    print("Executing signup...");

    // --- Validate device time -------------------------------------------------
    try {
      final DateTime ntpTime = await NTP.now();
      final DateTime localTime = DateTime.now();
      final Duration drift = ntpTime.difference(localTime).abs();
      // If drift is greater than 5 minutes, abort sign-in to avoid stale tokens
      if (drift > const Duration(minutes: 5)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "Your device time appears to be incorrect. Please enable automatic date & time and try again."),
          duration: Duration(seconds: 5),
        ));
        return;
      }
    } catch (ntpError) {
      // NTP failed – carry on but log the problem
      debugPrint("NTP check failed: $ntpError");
    }
    // -------------------------------------------------------------------------

    // Getting the current location (assuming this is a method from a class)
    _G_SignState location = _G_SignState();
    await location._getCurrentLocation();
    
    // Define result variable at a higher scope
    UserCredential? result;
    User? user;
    
    // Google Sign-In process with stale token handling
    final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
    
    // Handle sign-out more gracefully
    try {
      // First try to sign out from Firebase
      await FirebaseAuth.instance.signOut();
      
      // Then try to sign out from Google Sign-In
      try {
        await googleSignIn.signOut();
      } catch (googleSignOutError) {
        // If Google Sign-Out fails, try disconnecting first
        try {
          await googleSignIn.disconnect();
        } catch (disconnectError) {
          print("Google Sign-In disconnect error (can be ignored): $disconnectError");
        }
        print("Google Sign-Out error (can be ignored): $googleSignOutError");
      }
    } catch (e) {
      // Ignore any sign-out errors as we're about to start a fresh sign-in
      print("Sign-out status (can be ignored): $e");
    }
    
    // Then attempt a fresh sign-in
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    
    if (googleSignInAccount == null) {
      print("Google sign-in canceled by user");
      return;
    }
    
    try {
      // Get fresh authentication tokens
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      
      if (googleSignInAuthentication.idToken == null || 
          googleSignInAuthentication.accessToken == null) {
        throw Exception('Failed to get valid authentication tokens');
      }
      
      // Create fresh credentials
      final AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );
      
      // Sign in with fresh credentials
      result = await auth.signInWithCredential(authCredential);
      user = result.user;
      
      if (user == null) {
        throw Exception('User sign-in completed but user is null');
      }
      
    } catch (e) {
      print("Error during Google sign-in: $e");
      
      // Handle sign-out more gracefully in error case
      try {
        await FirebaseAuth.instance.signOut();
        try {
          await googleSignIn.signOut();
        } catch (e) {
          try {
            await googleSignIn.disconnect();
          } catch (e) {
            print("Error during Google Sign-Out (can be ignored): $e");
          }
        }
      } catch (e) {
        print("Error during sign out (can be ignored): $e");
      }
      
      // Check for specific error conditions
      if (e.toString().contains('stale') || 
          e.toString().contains('expired') ||
          e.toString().contains('invalid-credential')) {
        // Show user-friendly error message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Authentication session expired. Please try signing in again."),
              duration: Duration(seconds: 5),
              action: SnackBarAction(
                label: 'RETRY',
                onPressed: () {
                  // Retry the sign-in process
                  signup(context);
                },
              ),
            ),
          );
        }
        return; // Exit the current sign-in attempt
      } else {
        // For other errors, show a generic error message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Sign-in failed: ${e.toString()}"),
              duration: Duration(seconds: 5),
            ),
          );
        }
      }
      // If we reach here, the sign-in failed
      return;
    }

    // If user is not null, proceed with post-sign-in flow
    if (user != null && result != null) {
      SharedPref sharedPref = SharedPref();
      usr.User userSave = usr.User();

      userSave.displayName = user.displayName;
      userSave.email = user.email!;
      userSave.uid = uid; // Ensure `uid` and `deviceToken` are defined elsewhere
      userSave.token = deviceToken;

      await sharedPref.save("user", userSave);
      await sharedPref.save("currentEmail", user.email);

      is8Ads = true; // Assuming this is defined elsewhere

      if (result.additionalUserInfo!.isNewUser) {
        // New user flow
        await _handleNewUser(result);
      } else {
        // Existing user flow
        await _handleExistingUser(result, userSave);
      }
    }
  } catch (e) {
    // Handle any errors during the sign-in process
    print("Error during sign-up: $e");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Error occurred during sign-up: $e"),
    ));
  }
}

Future<void> _handleNewUser(UserCredential result) async {
  authService.userdata.addAll({"token": result.credential!.accessToken});
  await NotificationService().addtoadminnotification(
    userid: "value.id",
    useremail: result.user!.email!,
    subtitle: "ONLINE PROFILES",
    userimage: "",
    title: "${result.user!.email!} TRIED TO LOGIN",
  );
  Get.offAll(const LetsStart());
}

Future<void> _handleExistingUser(
    UserCredential result, usr.User userSave) async {
  userSave.email = result.user!.email!;
  int statusCode = await authService.finduser(result.user!.email!);

  if (statusCode == 200) {
    await _loginUser(result);
  } else if (statusCode == 400) {
    await NotificationService().addtoadminnotification(
      userid: "value.id",
      useremail: result.user!.email!,
      subtitle: "ONLINE PROFILES",
      userimage: "",
      title: "${result.user!.email!} TRIED TO LOGIN AS USER",
    );
    Get.offAll(const LetsStart());
  }
}

Future<void> _loginUser(UserCredential result) async {
  await HomeService().addtoken(
    email: result.user!.email!,
    token: result.credential!.accessToken!,
  );

  HomeService().getuserdata().then((value) async {
    await NotificationService().addtoadminnotification(
      userid: value.id,
      useremail: value.email,
      subtitle: "ONLINE PROFILES",
      userimage: value.imageurls.isEmpty ? "" : value.imageurls[0],
      title:
          "${value.name.substring(0, 1)} ${value.surname.toUpperCase()} ${value.puid} LOGIN PROFILE",
    );

    await HomeService().addtoken(
      email: result.user!.email!,
      token: result.credential!.accessToken!,
    );

    await HomeService().updatelogin(email: result.user!.email!, mes: "true");

    await NotificationService().addtonotification(
      email: result.user!.email!,
      title: "LOGIN PROFILE SUCCESSFULLY",
    );

    // Show notifications for unseen activities or messages
    _showUnseenNotifications();

    Get.offAll(MainAppContainer(notiPage: false));
  });
}

void _showUnseenNotifications() {
  // Notify about unseen activities
  for (var i = 0; i < activitieslists.length; i++) {
    if (activitieslists[i].isSeen != null && !activitieslists[i].isSeen!) {
      NotificationServiceLocal().showNotification(
        body: "",
        id: i,
        payLoad: activitieslists[i].title,
        title: activitieslists[i].title,
      );
    }
  }

  // Notify about unseen messages
  for (var i = 0; i < unseenmessages.length; i++) {
    NotificationServiceLocal().showNotification(
      body: unseenmessages[i]["title"],
      id: i,
      payLoad: unseenmessages[i]["title"],
      title: unseenmessages[i]["username"],
    );
  }
}
