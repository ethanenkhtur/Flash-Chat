// ignore_for_file: unused_local_variable

import 'package:flash_chat_flutter/screens/welcome_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_flutter/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  static const chatScreen = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

final User? _loggedInUser = FirebaseAuth.instance.currentUser;

class _ChatScreenState extends State<ChatScreen> {
  String messageText = '';
  String? emaill;
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('messages');
  final messageTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      if (_loggedInUser != null) {
        emaill = _loggedInUser!.email;
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.popAndPushNamed(context, WelcomeScreen.welcomeScreen);
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: const Color(0xFF40C4FF),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessagesStream(users: _users),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      _users.add({
                        'sender': emaill,
                        'text': messageText,
                      }).catchError((error) {
                        if (kDebugMode) print('Failed to send message');
                      });
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  const MessagesStream({
    Key? key,
    required CollectionReference<Object?> users,
  })  : _users = users,
        super(key: key);

  final CollectionReference<Object?> _users;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _users.snapshots(),
      builder: (context, snapshot) {
        List<MessageBubble> textWidgets = [];
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent[400]),
          );
        }
        final messages = snapshot.data!.docs.reversed;
        for (QueryDocumentSnapshot<Object?> message in messages) {
          final messageText = message.get('text');
          final messageSender = message.get('sender');

          final currentUser = _loggedInUser?.email;

          final messageWidget = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: currentUser == messageSender,
          );
          textWidgets.add(messageWidget);
        }

        return Expanded(
            child: ListView(
          reverse: true,
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
          children: textWidgets,
        ));
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble(
      {Key? key, required this.sender, required this.text, required this.isMe})
      : super(key: key);

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          sender,
          style: const TextStyle(color: Colors.black54, fontSize: 17.0),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 11.0, horizontal: 8.0),
          child: Material(
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.blueGrey[50],
            borderRadius: BorderRadius.only(
              topLeft:
                  isMe ? const Radius.circular(30.0) : const Radius.circular(0),
              topRight: isMe
                  ? const Radius.circular(0.0)
                  : const Radius.circular(30.0),
              bottomLeft: const Radius.circular(30.0),
              bottomRight: const Radius.circular(30.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 20.0,
                  color: isMe ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
