import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ristey/assets/notification_pop_up.dart';
import 'package:ristey/firebase_options.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/shared_pref.dart';
import 'package:ristey/models/user_modal.dart';
import 'package:ristey/netcheck.dart';
import 'package:ristey/screens/incoming_audio_call.dart';
import 'package:ristey/screens/incoming_call.dart';
import 'package:ristey/screens/navigation/service/home_service.dart';
import 'package:ristey/screens/profile/splash_video.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart';
import 'package:ristey/theme_config.dart';

import './global_vars.dart' as glb;

void main() async {
  Get.put(InternetController(), permanent: true);
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);


  // Initialize Firebase App Check
  await FirebaseAppCheck.instance.activate(
    // Use debug provider for development

    // webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    // For Android debug builds, use debug provider
    androidProvider: AndroidProvider.debug,
    
    // For iOS debug builds, use debug provider
    appleProvider: AppleProvider.debug,
  );
  
  initializeTimeZones();

  final NotificationData notificationData = NotificationData();
  notificationData.requestNotificationPermission();
  notificationData.isTokenRefresh();

  // Retrieve device token for notifications
  notificationData.getDeviceToken().then((value) {
    glb.deviceToken = value;
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Check if user is authenticated
  final sharedPreferences = await SharedPreferences.getInstance();
  final String? userEmail = sharedPreferences.getString("email");
  final String? userLocation = sharedPreferences.getString("location");

  if (userEmail == null && userLocation == null) {
    runApp(const MainApp());
  } else {
    await _handleAuthenticatedUser();
    runApp(const AuthenticatedApp());
  }
}

Future<void> _handleAuthenticatedUser() async {
  try {
    SharedPref sharedPref = SharedPref();
    User userSave = User.fromJson(await sharedPref.read("user"));

    HomeService().getuserdata();
    glb.userSave = userSave;
  } catch (e) {
    if (kDebugMode) {
      print("Error during authentication: $e");
    }
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (message.data['route'] == "audio" || message.data['route'] == "video") {
    // Handle audio/video notifications
  } else if (message.data['sound'] == 'chatnot' ||
      message.data['sound'] == 'navnot') {
    await NotificationData().showNotification(message);
  }

  if (kDebugMode) {
    print("Background message received: ${message.messageId}");
    print('Message data: ${message.data}');
    print('Notification title: ${message.notification?.title}');
    print('Notification body: ${message.notification?.body}');
  }
}

class AuthenticatedApp extends StatelessWidget {
  const AuthenticatedApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: [
        GetPage(name: '/incoming-call', page: () => IncomingCallScreen()),
        GetPage(
            name: '/audio-incoming-call',
            page: () => IncomingAudioCallScreen()),
      ],
      theme: getAppTheme(),
      navigatorKey: NavigationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const SplashVideo(),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final StreamSubscription _subscription;
  final HomeService _homeService = Get.put(HomeService());

  bool _isDeviceConnected = false;
  bool _isAlertSet = false;
  String? _city, _state, _country;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _checkConnectivity();
    _subscribeToConnectivityChanges();
    await _checkLocationServiceAndRetrievePosition();
  }

  Future<void> _checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      _showNoInternetDialog();
    }
  }

  void _subscribeToConnectivityChanges() {
    _subscription = Connectivity().onConnectivityChanged.listen((result) async {
      _isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (!_isDeviceConnected && !_isAlertSet) {
        _showNoInternetDialog();
        setState(() => _isAlertSet = true);
      }
    });
  }

  Future<void> _checkLocationServiceAndRetrievePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await _showEnableLocationDialog();
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition();
      final placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      _city = placemarks[0].locality;
      _state = placemarks[0].administrativeArea;
      _country = placemarks[0].country;

      if (glb.userSave.email?.isNotEmpty ?? false) {
        _homeService.updatelocation(
          lat: position.latitude,
          lng: position.longitude,
          email: glb.userSave.email!,
          city: _city!,
          state: _state!,
          country: _country!,
          location: "$_city, ${placemarks[0].postalCode}, $_country",
        );
      }
    } catch (e) {
      print("Error retrieving location: $e");
    }
  }

  Future<void> _showEnableLocationDialog() async {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Enable Location"),
        content: const Text(
            "Location services are disabled. Please enable them in settings."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showNoInternetDialog() {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Icon(Icons.error, color: Colors.red),
        content: const Text('No Internet Connection'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              _isDeviceConnected =
                  await InternetConnectionChecker().hasConnection;
              if (!_isDeviceConnected) {
                _showNoInternetDialog();
              }
            },
            child: const Text('Retry', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: [
        GetPage(name: '/incoming-call', page: () => IncomingCallScreen()),
        GetPage(
            name: '/audio-incoming-call',
            page: () => IncomingAudioCallScreen()),
      ],
      theme: getAppTheme(),
      title: 'Couple Mate',
      home: const SplashVideo(),
      debugShowCheckedModeBanner: false,
    );
  }
}
