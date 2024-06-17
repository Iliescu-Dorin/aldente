import 'package:flutter/material.dart';

class ClinicHome extends StatelessWidget {
  const ClinicHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ClinicHome'),
      ),
      body: const Center(
        child: Text('Add Page', style: TextStyle(fontSize: 25)),
      ),
    );
  }
}