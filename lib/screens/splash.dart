import 'package:connect/screens/home.dart';
import 'package:connect/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomeScreen()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => LoginScreen()));
      }
    });
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
            top: height * 0.9,
            left: width * 0.01,
            right: width * 0.01,
            height: height * 0.08,
            child: Center(
              child: Text(
                'Sasank Tumpati',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w100,
                  fontSize: height * 0.03,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}











// import 'package:connect/screens/home.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   Future.delayed(Duration(milliseconds: 1000), () {
  //     Navigator.pushReplacement(
  //         context, MaterialPageRoute(builder: (_) => HomeScreen()));
  //   });
  // }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return SafeArea(
//       child: Scaffold(
//           backgroundColor: Colors.black,
//           body: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Center(
//                 child: Icon(
//                   Icons.chat,
//                   size: height * 0.15,
//                   color: Colors.white,
//                 ),
//               ),
//               SizedBox(
//                 height: height * 0.05,
//               ),
              // CircularProgressIndicator.adaptive(
              //   backgroundColor: Colors.white,
              //   strokeWidth: width * 0.018,
              //   strokeAlign: width * 0.005,
              //   semanticsLabel: 'Circular Progress Indicator',
              // ),
//             ],
//           )),
//     );
//   }
// }
