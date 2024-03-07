import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


import '../resources/colours.dart';
import '../view_models/user_vm.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  final UserViewModel _vm = UserViewModel();

  @override
  void initState() {
    super.initState();
    _vm.checkAuthentication(context);
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logos/logo-dark.png",
              height: 200,
            ),
            SizedBox(height: height * .08),
            SpinKitWaveSpinner(
              color: AppColours.buttonOKColour.withOpacity(.6),
              trackColor: AppColours.buttonOKColour.withOpacity(.4),
              duration: const Duration(seconds: 3),
              curve: Curves.fastOutSlowIn,
              waveColor: AppColours.buttonOKColour,
            )
          ],
        ),
      ),
    );
  }
}
