import 'dart:async';

import 'package:aldente/pages/chat_doc/chat_message.dart';
import 'package:aldente/services/gemma_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemma/core/message.dart';

class GemmaInputField extends StatefulWidget {
  final List<Message> messages;
  final ValueChanged<Message> onMessageReceived;

  const GemmaInputField({
    super.key,
    required this.messages,
    required this.onMessageReceived,
  });

  @override
  GemmaInputFieldState createState() => GemmaInputFieldState();
}

class GemmaInputFieldState extends State<GemmaInputField> {
  final GemmaLocalService _gemmaService = GemmaLocalService();
  String _currentMessageText = '';

  StreamSubscription<String?>? _messageSubscription;

  @override
  void initState() {
    super.initState();
    _startMessageProcessing();
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    super.dispose();
  }

  void _startMessageProcessing() {
    _messageSubscription =
        _gemmaService.processMessageAsync(widget.messages).listen(
      (token) {
        if (token == null) {
          widget.onMessageReceived(Message(text: _currentMessageText));
          setState(() {
            _currentMessageText = '';
          });
        } else {
          setState(() {
            _currentMessageText += token;
          });
        }
      },
      onError: (error) {
        print('Error processing message: $error');
        setState(() {
          _currentMessageText =
              'Sorry, an error occurred while processing your message.';
        });
      },
      onDone: () {
        print('Message processing completed');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ChatMessageWidget(message: Message(text: _currentMessageText)),
    );
  }
}
