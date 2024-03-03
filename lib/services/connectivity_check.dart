import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityController {
  static ValueNotifier<bool> isConnected = ValueNotifier(false);

  static Future<void> init() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    isInternetConnected(result);
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      isInternetConnected(result);
    });
  }

  static bool isInternetConnected(ConnectivityResult? result) {
    if (result == ConnectivityResult.none) {
      isConnected.value = false;
      return false;
    } else if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      isConnected.value = true;
      return true;
    }
    return false;
  }

  static bool isConnectedToInternet() {
    return isConnected.value;
  }
}


// void initState() {
//     super.initState();
//     ConnectivityController.init();
//   }