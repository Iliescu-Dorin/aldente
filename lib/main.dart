import 'package:aldente/pages/login/first_page.dart';
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
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: const FirstPage(),
    );
  }
}