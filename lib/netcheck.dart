import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ristey/global_vars.dart';

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
      // Get.rawSnackbar(
      //   title: "No Internet",
      //   message: 'Connect to the internet to continue.',
      //   icon: Icon(Icons.wifi_off, color: mainColor),
      //   isDismissible: true,
      //   duration: const Duration(days: 1),
      //   shouldIconPulse: true,
      // );

      Get.rawSnackbar(
          titleText: Container(
            width: double.infinity,
            height: Get.height * (.950),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Icon(
                    Icons.wifi_off,
                    size: 100,
                    color: mainColor,
                  ),
                ),
                Text(
                  "No Internet Connection",
                  style: TextStyle(fontSize: 20, color: mainColor),
                )
              ],
            ),
          ),
          messageText: Container(),
          backgroundColor: Colors.black,
          isDismissible: false,
          duration: Duration(days: 1));
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
