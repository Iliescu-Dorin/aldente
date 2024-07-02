import 'package:aldente/services/pocketbase/pocketbase_service.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../routes/app_pages.dart';

class LoginController extends GetxController {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future<String?> onLogin(LoginData loginData) async {
    return _handleAuthOperation(
        () => PocketbaseService.to.login(loginData.name, loginData.password));
  }

  Future<String?> onSignup(SignupData signUpData) async {
    return _handleAuthOperation(() async {
      String? email = signUpData.name;
      String? password = signUpData.password;
      String? name = signUpData.additionalSignupData?["name"];

      if (email == null || password == null || name == null) {
        throw Exception("Invalid data");
      }

      await PocketbaseService.to.signUp(name, email, password);
      await PocketbaseService.to.login(email, password);
    });
  }

  Future<String?> onGoogleLogin() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return 'Google sign in cancelled';
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a function that returns the access token
      dynamic accessTokenFunction(Uri uri) => googleAuth.accessToken;

      await PocketbaseService.to.authWithOAuth2(
        'google',
        accessTokenFunction,
        googleAuth.idToken,
        googleUser.email,
        googleUser.displayName,
      );

      // If we reach here, authentication was successful
      return null;
    } catch (e) {
      if (e is Exception) {
        return e.toString();
      }
      return 'An unexpected error occurred during Google sign in';
    }
  }

  Future<String?> _handleAuthOperation(
      Future<void> Function() operation) async {
    try {
      await operation();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  void onLoginComplete() async {
    String? role = await PocketbaseService.to.getUserRole();
    String route = _getRouteForRole(role);
    Get.offAllNamed(route);
  }

  String _getRouteForRole(String? role) {
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
}
