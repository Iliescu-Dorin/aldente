import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:get/get.dart';
import 'login_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'AlDente',
      theme: _buildLoginTheme(),
      logo: const AssetImage('assets/icon.png'),
      onLogin: controller.onLogin,
      onSignup: controller.onSignup,
      additionalSignupFields: _buildAdditionalSignupFields(),
      onSubmitAnimationCompleted: controller.onLoginComplete,
      loginAfterSignUp: true,
      hideForgotPasswordButton: true,
      onRecoverPassword: (_) => Future.value(null),
      loginProviders: [_buildGoogleLoginProvider()],
    );
  }

  LoginTheme _buildLoginTheme() {
    return LoginTheme(
      pageColorLight: Colors.black,
    );
  }

  List<UserFormField> _buildAdditionalSignupFields() {
    return const [
      UserFormField(keyName: 'name', displayName: 'Name'),
    ];
  }

  LoginProvider _buildGoogleLoginProvider() {
    return LoginProvider(
      icon: FontAwesomeIcons.google,
      label: 'Google',
      callback: controller.onGoogleLogin,
    );
  }
}