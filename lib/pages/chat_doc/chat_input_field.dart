import 'package:flutter/material.dart';

class ChatInputField extends StatelessWidget {
  final ValueChanged<String> onSubmitted;

  const ChatInputField({super.key, required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              decoration: const InputDecoration.collapsed(
                hintText: 'Send a message',
              ),
              onSubmitted: (text) {
                onSubmitted(text);
                textController.clear();
              },
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {
              onSubmitted(textController.text);
              textController.clear();
            },
          ),
        ],
      ),
    );
  }
}
