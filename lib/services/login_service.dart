import 'package:aldente/routes/app_pages.dart';
import 'package:aldente/services/pocketbase/pocketbase_service.dart';

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
