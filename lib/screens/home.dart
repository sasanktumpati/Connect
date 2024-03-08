import 'dart:developer';

import 'package:connect/api/api.dart';
import 'package:connect/helpers/dialogs.dart';
import 'package:connect/screens/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/chat_user.dart';
import '../widgets/user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> _list = [];
  final List<ChatUser> _searchList = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    apiData.getSelfInfo();

    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');

      if (apiData.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          apiData.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          apiData.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final backColor = Theme.of(context).colorScheme.background;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secColor = Theme.of(context).colorScheme.secondary;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: backColor,
          title: _isSearching
              ? TextField(
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: 'Name, Email, ...'),
                  autofocus: true,
                  style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
                  onChanged: (val) {
                    _searchList.clear();

                    for (var i in _list) {
                      if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                          i.email.toLowerCase().contains(val.toLowerCase())) {
                        _searchList.add(i);
                        setState(() {
                          _searchList;
                        });
                      }
                    }
                  },
                )
              : const Text('Connect'),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                  });
                },
                icon: Icon(_isSearching
                    ? CupertinoIcons.clear_circled_solid
                    : Icons.search)),
          ],
        ),
        floatingActionButton: SizedBox(
          width: 56,
          height: 56,
          child: FloatingActionButton(
            onPressed: () => _addChatUserDialog(),
            child: const Icon(Icons.person_add_alt),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.black,
          surfaceTintColor: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.home),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ProfileScreen(user: apiData.me)));
                },
                icon: const Icon(Icons.person),
              ),
            ],
          ),
        ),
        body: StreamBuilder(
          stream: apiData.getMyUsersId(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return const Center(child: CircularProgressIndicator());

              case ConnectionState.active:
              case ConnectionState.done:
                return StreamBuilder(
                  stream: apiData.getAllUsers(
                      snapshot.data?.docs.map((e) => e.id).toList() ?? []),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        _list = data
                                ?.map((e) => ChatUser.fromJson(e.data()))
                                .toList() ??
                            [];

                        if (_list.isNotEmpty) {
                          return ListView.builder(
                              itemCount: _isSearching
                                  ? _searchList.length
                                  : _list.length,
                              padding: EdgeInsets.only(top: height * .01),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return UserCard(
                                    user: _isSearching
                                        ? _searchList[index]
                                        : _list[index]);
                              });
                        } else {
                          return const Center(
                            child: Text('No Connections Found!',
                                style: TextStyle(fontSize: 20)),
                          );
                        }
                    }
                  },
                );
            }
          },
        ),
      ),
    );
  }

  void _addChatUserDialog() {
    String email = '';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: const [
                  Icon(
                    Icons.person_add,
                    color: Colors.white,
                    size: 28,
                  ),
                  Text('  Add User')
                ],
              ),
              content: TextFormField(
                maxLines: null,
                onChanged: (value) => email = value,
                decoration: InputDecoration(
                    hintText: 'Email Id',
                    prefixIcon: const Icon(Icons.email, color: Colors.white),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),
              actions: [
                MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel',
                        style: TextStyle(color: Colors.white, fontSize: 16))),
                MaterialButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      if (email.isNotEmpty) {
                        await apiData.addChatUser(email).then((value) {
                          if (!value) {
                            CustomDialogs.alertDialog(
                                context, 'User does not Exists!');
                          }
                        });
                      }
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ))
              ],
            ));
  }
}
