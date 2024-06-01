import 'package:flutter/material.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Persistent Bottom Nav Bar'),
      ),
      body: const Center(
        child: Text('Add Page', style: TextStyle(fontSize: 25)),
      ),
    );
  }
}