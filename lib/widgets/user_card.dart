import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserCard extends StatefulWidget {
  const UserCard({super.key});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final backColor = Theme.of(context).colorScheme.background;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secColor = Theme.of(context).colorScheme.secondary;

    return Card(
      elevation: 2,
      shadowColor: Colors.black,
      color: const Color.fromRGBO(10, 38, 61, 0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  children: [Icon(Icons.person)],
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: "Course Name\n",
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: height * 0.02,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Year    ",
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: height * 0.02,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              flex: 1,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Course Code   \n",
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: height * 0.02,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
