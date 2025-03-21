import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/screens/navigation/service/home_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DependencyInjection {
  static void init() {
    Get.put<NetworkController>(NetworkController(), permanent: true);
    Get.put<ScreenshotController>(ScreenshotController(), permanent: true);
  }
}

class InternetController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  late final StreamSubscription<List<ConnectivityResult>>
      _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(NetStatus);
  }

  void NetStatus(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.none)) {
      Get.rawSnackbar(
        title: "No Internet",
        message: 'Connect to the internet to continue.',
        icon: Icon(Icons.wifi_off, color: mainColor),
        isDismissible: true,
        duration: const Duration(days: 1),
        shouldIconPulse: true,
      );
    } else {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
    }
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel(); // Clean up listener
    super.onClose();
  }
}

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void _updateConnectionStatus(
      List<ConnectivityResult> connectivityResult) async {
    if (connectivityResult == ConnectivityResult.none) {
      Get.dialog(
        WillPopScope(
          onWillPop: () async => false,
          child: CupertinoAlertDialog(
            title: Icon(
              Icons.error,
              color: mainColor,
            ),
            content: const Text('No Internet Connection'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Get.back(); // Close the dialog
                },
                child: Text(
                  'OK',
                  style: TextStyle(color: mainColor),
                ),
              )
            ],
          ),
        ),
        barrierDismissible: false,
      );
    } else {
      if (Get.isDialogOpen != null && Get.isDialogOpen!) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        String? useremail = sharedPreferences.getString("email");
        if (useremail != null) {
          await HomeService().getuserdata();
        }
        Get.back();
      }
    }
  }
}

class CallController extends GetxController {
  dynamic incomingSDPOffer;

  @override
  void onInit() {
    super.onInit();
  }

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void _updateConnectionStatus() async {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: CupertinoAlertDialog(
          title: Icon(
            Icons.error,
            color: mainColor,
          ),
          content: const Text('Someone is calling you'),
          actions: <Widget>[
            TextButton(
              onPressed: () {},
              child: Text(
                'Accept',
                style: TextStyle(color: mainColor),
              ),
            )
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }
}

class ScreenshotController extends GetxController {
  static const platform = MethodChannel('com.freerishtey.android/screenshot');

  @override
  void onInit() {
    super.onInit();
    platform.setMethodCallHandler(_methodCallHandler);
  }

  Future<void> _methodCallHandler(MethodCall call) async {
    if (call.method == "onScreenshot") {
      _handleScreenshot();
    }
    if (call.method == "onScreenRecording") {
      _handleScreenRecording();
    }
  }

  void _handleScreenshot() {
    // Your global method logic for screenshot detection
    print("Screenshot detected");
    // You can add more functionality here
  }

  void _handleScreenRecording() {
    // Your global method logic for screen recording detection
    print("Screen recording detected");
    // You can add more functionality here
  }
}
