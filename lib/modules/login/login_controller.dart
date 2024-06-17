import 'package:aldente/services/pocketbase/pocketbase_service.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';

class LoginController extends GetxController {
  Future<String?> onLogin(LoginData loginData) async {
    try {
      String email = loginData.name;
      String password = loginData.password;
      await PocketbaseService.to.login(email, password);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> onSignup(SignupData signUpData) async {
    try {
      String? email = signUpData.name;
      String? password = signUpData.password;
      String? name = signUpData.additionalSignupData?["name"];
      if (email == null || password == null || name == null) {
        throw Exception("Invalid data");
      }
      await PocketbaseService.to.signUp(name, email, password);
      await PocketbaseService.to.login(email, password);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  void onLoginComplete() async {
    // Fetch the user's role
    String? role = await PocketbaseService.to.getUserRole();

    if (role == null) {
      // Handle the case when the user's role is not available
      // For example, you can show an error message or redirect to a default route
      Get.offAllNamed(Routes.LOGIN);
      return;
    }

    // Determine the route based on the user's role
    switch (role) {
      case 'client':
        Get.offAllNamed(Routes.BOTTOMNAVBAR);
        break;
      case 'doctor':
        Get.offAllNamed(Routes.DOCTORHOME);
        break;
      case 'clinic':
        Get.offAllNamed(Routes.CLINICHOME);
        break;
      default:
        // Handle unknown roles or redirect to a default route
        Get.offAllNamed(Routes.BOTTOMNAVBAR);
        break;
    }
  }
}
