import 'package:flutter/material.dart';

class CustomDialogs {
  void alertDialog(BuildContext context, String title) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: width * 0.05),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              color: Colors.black,
            ),
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              title: Text(
                title,
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                'No Internet Connection.',
                style: TextStyle(color: Colors.white),
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showCircularProgressDialog(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: SizedBox(
            width: width * 0.1,
            height: width * 0.1,
            child: CircularProgressIndicator.adaptive(
              backgroundColor: Colors.blue,
              strokeWidth: width * 0.018,
              semanticsLabel: 'Circular Progress Indicator',
            ),
          ),
        );
      },
    );
  }
}
