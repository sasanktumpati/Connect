import 'package:flutter/material.dart';

import '../widgets/user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final backColor = Theme.of(context).colorScheme.background;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      backgroundColor: backColor,
      appBar: AppBar(
        title: Text(
          'Connect',
          style:
              TextStyle(fontSize: height * 0.03, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: backColor,
        leading: IconButton(
          padding: EdgeInsets.symmetric(
              vertical: height * 0.001, horizontal: width * 0.05),
          icon: Icon(
            Icons.menu,
          ),
          color: primaryColor,
          iconSize: height * 0.035,
          onPressed: () {},
        ),
      ),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return UserCard();
        },
      ),
    );
  }
}
