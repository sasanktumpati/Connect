import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../api/api.dart';
import '../helpers/dialogs.dart';
import '../models/chat_user.dart';
import 'login.dart';

class ProfileScreen extends StatelessWidget {
  final ChatUser user;

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Screen'),
        backgroundColor: Colors.black,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.red,
          onPressed: () async {
            CustomDialogs.showCircularProgressDialog(context);

            await apiData.updateActiveStatus(false);

            await apiData.auth.signOut().then((value) async {
              await GoogleSignIn().signOut().then((value) {
                Navigator.pop(context);
                apiData.auth = FirebaseAuth.instance;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              });
            });
          },
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * .05),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(width: width, height: height * .03),
              ClipRRect(
                borderRadius: BorderRadius.circular(height * .1),
                child: CachedNetworkImage(
                  width: height * .2,
                  height: height * .2,
                  fit: BoxFit.cover,
                  imageUrl: user.image,
                  errorWidget: (context, url, error) =>
                      const CircleAvatar(child: Icon(CupertinoIcons.person)),
                ),
              ),
              SizedBox(height: height * .03),
              Text(
                user.email,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: height * .05),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.white),
                title: Text(
                  'Name: ${user.name}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: height * .02),
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.white),
                title: Text(
                  'About: ${user.about}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
