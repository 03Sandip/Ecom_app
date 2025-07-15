import 'package:e_commerce_flutter/utility/extensions.dart';

import '../../utility/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import '../home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      // savedEmail: 'testing@gmail.com',
      // savedPassword: '12345',
      loginAfterSignUp: false,
      logo: const AssetImage('assets/images/logo.png'),
      onLogin: (LoginData loginData) {
        context.userProvider.login(loginData); //call login
      },
      onSignup: (SignupData data) {
        context.userProvider.register(data); // call register
      },
      onSubmitAnimationCompleted: () {
        if (context.userProvider.getLoginUsr()?.sId != null) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) {
              return const HomeScreen();
            },
          ));
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) {
              return const LoginScreen();
            },
          ));
        }
      },
      onRecoverPassword: (_) => null,
      hideForgotPasswordButton: true,
      theme: LoginTheme(
          primaryColor: AppColor.darkGrey,
          accentColor: AppColor.darkOrange,
          buttonTheme: const LoginButtonTheme(
            backgroundColor: AppColor.darkOrange,
          ),
          cardTheme: const CardTheme(
              color: Colors.white, surfaceTintColor: Colors.white),
          titleStyle: const TextStyle(color: Colors.black)),
    );
  }
}
