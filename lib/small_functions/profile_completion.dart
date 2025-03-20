import 'package:flutter/material.dart';
import 'package:ristey/global_vars.dart';

class ProfileCompletion {
  var profilePercentage = 50;

  int profileComplete() {
    if (userSave.imageUrls != null && userSave.imageUrls!.isNotEmpty) {
      profilePercentage += 10;
    }

    if (userSave.About_Me != null && userSave.About_Me!.trim().isNotEmpty) {
      profilePercentage += 10;
    }
    if (userSave.Partner_Prefs != null &&
        userSave.Partner_Prefs!.trim().isNotEmpty) {
      profilePercentage += 10;
    }
    if (userSave.verifiedStatus == "verified") {
      profilePercentage += 20;
    }
    return profilePercentage;
  }
}
