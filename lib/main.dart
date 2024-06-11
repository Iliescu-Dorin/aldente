// import 'package:aldente/pages/login/first_page.dart';
// import 'package:flutter/material.dart';

// import 'bottom_nav_bar.dart';

// void main() => runApp( const MyPersistentBottomNavBar());

// class MyPersistentBottomNavBar extends StatelessWidget {
//   const MyPersistentBottomNavBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'AlDente',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(primarySwatch: Colors.blueGrey),
//       home: const FirstPage(),
//     );
//   }
// }


import 'package:aldente/routes/app_pages.dart';
import 'package:aldente/services/pocketbase_service.dart';
import 'package:aldente/services/storage_service.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => StorageService().init());
  await Get.putAsync(() => PocketbaseService().init());

  runApp(
    GetMaterialApp(
      title: "AlDente",
      debugShowCheckedModeBanner: false,
      initialRoute:
          PocketbaseService.to.isAuth ? Routes.BOTTOMNAVBAR : Routes.LOGIN,
      getPages: AppPages.routes,
    ),
  );
}
