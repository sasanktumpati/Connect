import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect/api/api.dart';
import 'package:connect/helpers/dateutils.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';
import '../models/chat_user.dart';
import '../models/message.dart';
import '../widgets/message_card.dart';
import 'viewprofile.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _list = [];
  final _textController = TextEditingController();
  bool _showEmoji = false, _isUploading = false;

  get height => MediaQuery.of(context).size.height;
  get width => MediaQuery.of(context).size.height;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final backColor = Theme.of(context).colorScheme.background;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secColor = Theme.of(context).colorScheme.secondary;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        // ignore: deprecated_member_use
        child: WillPopScope(
          onWillPop: () {
            if (_showEmoji) {
              setState(() => _showEmoji = !_showEmoji);
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),
            ),
            backgroundColor: const Color.fromARGB(255, 234, 248, 255),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: APIs.getAllMessages(widget.user),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const SizedBox();
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          _list = data
                                  ?.map((e) => Message.fromJson(e.data()))
                                  .toList() ??
                              [];

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                                reverse: true,
                                itemCount: _list.length,
                                padding: EdgeInsets.only(top: height * .01),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return MessageCard(message: _list[index]);
                                });
                          } else {
                            return const Center(
                              child: Text('Say Hi!',
                                  style: TextStyle(fontSize: 20)),
                            );
                          }
                      }
                    },
                  ),
                ),
                if (_isUploading)
                  const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                          child: CircularProgressIndicator(strokeWidth: 2))),
                _chatInput(),
                if (_showEmoji)
                  SizedBox(
                    height: height * .35,
                    child: EmojiPicker(
                      textEditingController: _textController,
                      config: Config(
                        bgColor: const Color.fromARGB(255, 234, 248, 255),
                        columns: 8,
                        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ViewProfileScreen(user: widget.user)));
        },
        child: StreamBuilder(
            stream: APIs.getUserInfo(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

              return Row(
                children: [
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon:
                          const Icon(Icons.arrow_back, color: Colors.black54)),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(height * .03),
                    child: CachedNetworkImage(
                      width: height * .05,
                      height: height * .05,
                      imageUrl:
                          list.isNotEmpty ? list[0].image : widget.user.image,
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(list.isNotEmpty ? list[0].name : widget.user.name,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 2),
                      Text(
                          list.isNotEmpty
                              ? list[0].isOnline
                                  ? 'Online'
                                  : dateutils.getLastActiveTime(
                                      context: context,
                                      lastActive: list[0].lastActive)
                              : dateutils.getLastActiveTime(
                                  context: context,
                                  lastActive: widget.user.lastActive),
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black54)),
                    ],
                  )
                ],
              );
            }));
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: height * .01, horizontal: width * .025),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(() => _showEmoji = !_showEmoji);
                      },
                      icon: const Icon(Icons.emoji_emotions,
                          color: Colors.blueAccent, size: 25)),
                  Expanded(
                      child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onTap: () {
                      if (_showEmoji) setState(() => _showEmoji = !_showEmoji);
                    },
                    decoration: const InputDecoration(
                        hintText: 'Connect Here......',
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        border: InputBorder.none),
                  )),
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final List<XFile> images =
                            await picker.pickMultiImage(imageQuality: 70);

                        for (var i in images) {
                          log('Image Path: ${i.path}');
                          setState(() => _isUploading = true);
                          await APIs.sendChatImage(widget.user, File(i.path));
                          setState(() => _isUploading = false);
                        }
                      },
                      icon: const Icon(Icons.image,
                          color: Colors.blueAccent, size: 26)),
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 70);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() => _isUploading = true);
                          await APIs.sendChatImage(
                              widget.user, File(image.path));
                          setState(() => _isUploading = false);
                        }
                      },
                      icon: const Icon(Icons.camera_alt_rounded,
                          color: Colors.blueAccent, size: 26)),
                  SizedBox(width: width * .02),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                if (_list.isEmpty) {
                  APIs.sendFirstMessage(
                      widget.user, _textController.text, Type.text);
                } else {
                  APIs.sendMessage(
                      widget.user, _textController.text, Type.text);
                }
                _textController.text = '';
              }
            },
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            color: Colors.green,
            child: const Icon(Icons.send, color: Colors.white, size: 28),
          )
        ],
      ),
    );
  }
}
