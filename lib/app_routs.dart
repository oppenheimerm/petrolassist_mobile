import 'package:flutter/material.dart';
import 'package:petrol_assist_mobile/views/home_view.dart';
import 'package:petrol_assist_mobile/views/login_view.dart';
import 'package:petrol_assist_mobile/views/register_view.dart';
import 'package:petrol_assist_mobile/views/route_not_found.dart';
import 'package:petrol_assist_mobile/views/splash_view.dart';
import 'app_constants.dart';



class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppConsts.rootSplash:
        return MaterialPageRoute(
          builder: (context) => const SplashView(),
        );
      case AppConsts.rootLogin:
        return MaterialPageRoute(
          builder: (context) => const LoginView(),
        );
      case AppConsts.rootHome:
        return MaterialPageRoute(
          builder: (context) => const HomeView(),
        );
      case AppConsts.rootRegister:
        return MaterialPageRoute(
          builder: (context) => const RegisterView(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const NotFoundView(),
        );
    }
  }
}
