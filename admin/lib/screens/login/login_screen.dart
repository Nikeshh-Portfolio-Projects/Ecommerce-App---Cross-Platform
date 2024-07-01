import 'package:admin/screens/main/main_screen.dart';
import 'package:admin/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      // savedEmail: 'testing@gmail.com',
      // savedPassword: '12345',
      loginAfterSignUp: false,
      logo: const AssetImage('assets/images/logo.png'),
      onLogin: (LoginData data) {
        context.userProvider.login(data);
      },
      onSignup: (SignupData data) {
        context.userProvider.register(data);
      },
      onSubmitAnimationCompleted: () {
        if(context.userProvider.getLoginUsr()?.sId != null){
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) {
              return MainScreen();
            },
          ));
        }else{
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) {
              return const LoginScreen();
            },
          ));
        }
      },
      onRecoverPassword: (_) => null,
      hideForgotPasswordButton: true
    );
  }
}
