import 'package:aldente/pages/chat_doc/chat_screen.dart';
import 'package:aldente/pages/chat_doc/theme.dart';
import 'package:flutter/material.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Gemma Example',
      theme: darkTheme,
      home: const SafeArea(child: ChatScreen()),
    );
  }
}