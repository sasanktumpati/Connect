import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect/api/api.dart';
import 'package:connect/helpers/dateutils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/chat_user.dart';
import '../models/message.dart';
import '../screens/chat_screen.dart';

class UserCard extends StatefulWidget {
  UserCard({super.key, required ChatUser user});

  late final ChatUser user;

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  Message? _message;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final backColor = Theme.of(context).colorScheme.background;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secColor = Theme.of(context).colorScheme.secondary;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: width * .04, vertical: 4),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen(user: widget.user)));
          },
          child: StreamBuilder(
            stream: APIs.getLastMessage(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
              if (list.isNotEmpty) _message = list[0];

              return ListTile(
                leading: InkWell(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(height * .03),
                    child: CachedNetworkImage(
                      width: height * .055,
                      height: height * .055,
                      imageUrl: widget.user.image,
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person)),
                    ),
                  ),
                ),
                title: Text(widget.user.name),
                subtitle: Text(
                    _message != null
                        ? _message!.type == Type.image
                            ? 'image'
                            : _message!.msg
                        : widget.user.about,
                    maxLines: 1),
                trailing: _message == null
                    ? null
                    : _message!.read.isEmpty &&
                            _message!.fromId != APIs.user.uid
                        ? Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                                color: Colors.blueAccent.shade400,
                                borderRadius: BorderRadius.circular(10)),
                          )
                        : Text(
                            dateutils.getLastMessageTime(
                                context: context, time: _message!.sent),
                            style: const TextStyle(color: Colors.black54),
                          ),
              );
            },
          )),
    );
  }
}
