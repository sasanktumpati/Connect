import 'dart:math';

import 'package:connect/api/api.dart';
import 'package:connect/helpers/dialogs.dart';
import 'package:connect/screens/home.dart';
import 'package:connect/services/connectivity_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../services/google_signin.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ConnectivityController connectivityController = ConnectivityController();
  @override
  void initState() {
    super.initState();
    ConnectivityController.init();
  }

  bool get _connected => ConnectivityController.isConnectedToInternet();

  _loginbuttonClick() {
    CustomDialogs customDialogs = CustomDialogs();

    CustomDialogs.showCircularProgressDialog(context);

    if (_connected) {
      signInWithGoogle().then((User) async {
        Navigator.pop(context);
        if (kDebugMode) {
          print(User);
        }
        if (User != null) {
          if ((await apiData.userExists())) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          } else {
            await apiData.createUser().then((value) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()));
            }).catchError((error) {
              CustomDialogs.alertDialog(context, "Error creating user: $error");
            });
          }
        }
      }).catchError((error) {
        CustomDialogs.alertDialog(
            context, "Error signing in with Google: $error");
      });
    } else {
      Navigator.pop(context);
      CustomDialogs.alertDialog(context, 'No Internet Connection');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final backColor = Theme.of(context).colorScheme.background;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      backgroundColor: backColor,
      body: Stack(
        children: [
          Positioned(
            top: height * 0.15,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Connect',
                style: TextStyle(
                    fontSize: height * 0.05, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Positioned(
            top: height * 0.23,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Stay Linked, Stay Connected',
                style: TextStyle(
                    fontSize: height * 0.025,
                    fontWeight: FontWeight.bold,
                    color: secColor),
              ),
            ),
          ),
          Positioned(
            top: height * 0.3,
            left: width * 0.05,
            right: width * 0.05,
            child: Center(
              child: Image.asset('assets/1.png'),
            ),
          ),
          Positioned(
            top: height * 0.8,
            left: width * 0.15,
            right: width * 0.15,
            height: height * 0.08,
            child: ElevatedButton.icon(
              onPressed: () {
                _loginbuttonClick();
              },
              icon: Image.asset(
                'assets/google.png',
                scale: 18,
              ),
              label: Text(
                'Login with Google',
                style: TextStyle(
                    color: backColor,
                    fontWeight: FontWeight.bold,
                    fontSize: height * 0.024),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
