import 'package:aldente/constant.dart';
import 'package:aldente/pages/chat_doc/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemma/flutter_gemma.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];

  void _handleGemmaMessage(Message message) {
    setState(() {
      _messages.add(message);
    });
  }

  void _handleHumanMessage(String text) {
    setState(() {
      _messages.add(Message(text: text, isUser: true));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          'AlDente ChatDoc',
          style: TextStyle(fontSize: 20),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              kBackgroundColor,
            ],
          ),
        ),
        child: FutureBuilder(
          future: FlutterGemmaPlugin.instance.isInitialized,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data == true) {
              return ChatListWidget(
                gemmaHandler: _handleGemmaMessage,
                humanHandler: _handleHumanMessage,
                messages: _messages,
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}