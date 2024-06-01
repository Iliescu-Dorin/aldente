import 'package:flutter/material.dart';

import 'bottom_nav_bar.dart';

void main() => runApp( const MyPersistentBottomNavBar());

class MyPersistentBottomNavBar extends StatelessWidget {
  const MyPersistentBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Persistent Bottom Nav Bar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const BottomNavBar(),
    );
  }
}