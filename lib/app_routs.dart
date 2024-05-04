import 'package:flutter/material.dart';
import 'package:petrol_assist_mobile/views/home_view.dart';
import 'package:petrol_assist_mobile/views/login_view.dart';
import 'package:petrol_assist_mobile/views/register_view.dart';
import 'package:petrol_assist_mobile/views/route_not_found.dart';
import 'package:petrol_assist_mobile/views/search_stations.dart';
import 'package:petrol_assist_mobile/views/splash_view.dart';
import 'package:petrol_assist_mobile/views/verify_emailView.dart';
import 'app_constants.dart';

// Not recommended
//  https://docs.flutter.dev/ui/navigation

/*class Routes {
  static Route<dynamic> generateRoute(
      RouteSettings settings, {
        String emailAddress = '',
        double latitude = 0.0,
        double longitude = 0.0,
        int countryId = 1,
        int distanceUnit = 0
      }
      ) {
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
      case AppConsts.verifyEmail:
        return MaterialPageRoute(
          builder: (context) =>  VerifyEmailView(emailAddress: emailAddress,),
        );
      case AppConsts.rootSearchStations:
        return MaterialPageRoute(
            builder: (context) =>  SearchStationsView(
              latitude: latitude,
              longitude: longitude,
              countryId: countryId,
              distanceUnit: distanceUnit,
            ),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const NotFoundView(),
        );
    }
  }
}*/
