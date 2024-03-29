import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect/helpers/dateutils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../models/chat_user.dart';

class ViewOthersProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ViewOthersProfileScreen({Key? key, required this.user})
      : super(key: key);

  @override
  State<ViewOthersProfileScreen> createState() =>
      _ViewOthersProfileScreenState();
}

class _ViewOthersProfileScreenState extends State<ViewOthersProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.user.name),
            backgroundColor: Colors.black,
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Joined On: ',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
              Text(
                  dateutils.getLastMessageTime(
                      context: context,
                      time: widget.user.createdAt,
                      showYear: true),
                  style: const TextStyle(color: Colors.white, fontSize: 15)),
            ],
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
                      imageUrl: widget.user.image,
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person)),
                    ),
                  ),
                  SizedBox(height: height * .03),
                  Text(widget.user.email,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 16)),
                  SizedBox(height: height * .02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'About: ',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                      Text(widget.user.about,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15)),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
