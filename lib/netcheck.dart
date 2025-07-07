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
      if (!(Get.isDialogOpen ?? false)) {
        Get.dialog(
          WillPopScope(
            onWillPop: () async => false,
            child: CupertinoAlertDialog(
              title: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Icon(Icons.error, color: mainColor, size: 50),
                  const SizedBox(height: 10),
                  Text(
                    'No Internet Connection',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
          barrierDismissible: false,
        );
      }
    } else {
      if (Get.isDialogOpen ?? false) {
        Get.back(); // Close the dialog when internet reconnects
      }
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
