import 'package:aldente/routes/app_pages.dart';
import 'package:aldente/services/pocketbase/pocketbase_service.dart';
import 'package:aldente/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services asynchronously
  await Get.putAsync(() => StorageService().init());
  await Get.putAsync(() => PocketbaseService().init());

  // Determine initial route based on authentication status and user role
  String initialRoute = await determineInitialRoute();

  // Run the application
  runApp(
    GetMaterialApp(
      title: "AlDente",
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      getPages: AppPages.routes,
    ),
  );
}

// Determine initial route based on user authentication and role
Future<String> determineInitialRoute() async {
  // Default to LOGIN if not authenticated
  if (!PocketbaseService.to.isAuth) {
    return Routes.LOGIN;
  }

  // Assuming PocketbaseService has a method to get user role
  String? role = await PocketbaseService.to.getUserRole();

  if (role == null) {
    return Routes.LOGIN;
  }

  // Determine route based on user role
  switch (role) {
    case 'client':
      return Routes.BOTTOMNAVBAR;
    case 'doctor':
      return Routes.DOCTORHOME;
    case 'clinic':
      return Routes.CLINICHOME;
    default:
      return Routes.BOTTOMNAVBAR;
  }
}
