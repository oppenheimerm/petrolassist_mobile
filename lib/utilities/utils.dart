import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:petrol_assist_mobile/app_constants.dart';
import '../resources/colours.dart';

class Utils {
  // Make this constructor private; preventing any instantiation.  This
  // allows us to call below static function via this class
  Utils._();

  static double? getRandomHeight() {
    //  Use final when you need variables that cannot be reassigned
    //  but can be computed at runtime. Use const for values that are
    //  known at compile time to enhance performance and ensure
    //  immutability.
    final random = Random();
    const minHeight = 300;
    const maxHeight = 550;
    const heightDifference = 100;
    final randomHeight =
        random.nextInt(maxHeight - minHeight - heightDifference + 1) +
            minHeight;
    return randomHeight.toDouble();
  }

  //want to group widgets together in a group so that they are traversed in a particular order

  /// Manages focus traversal to the scoped controls of this [context],
  /// also takes a [current] and [nextFocus] parameter.
  static void fieldFocusChange(BuildContext context,
      FocusNode current,
      FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static void changeFocusNode(BuildContext context,
      {required FocusNode current, required FocusNode next}) {
    current.unfocus();
    FocusScope.of(context).requestFocus(next);
  }

  /// App wide snack bar helper.  Displays a [message]
  /// with on [context].
  static snackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 16,
            color: AppColours.paWhiteColour,
          ),
        ),
        showCloseIcon: true,
        backgroundColor: AppColours.buttonOKColour,
        elevation: 2,
      ),
    );
  }

  /// adjust brightness if is in dark mode.
  ///
  static bool isDarkMode(BuildContext context) {
    return Theme
        .of(context)
        .brightness == Brightness.dark;
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery
        .of(context)
        .size
        .height;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery
        .of(context)
        .size
        .width;
  }

  static bool isIos(){
    return Platform.isIOS;
  }

  static bool isAndroid(){
    return Platform.isAndroid;
  }

  //  TODO not tested
  static String getPetrolStationLogoPrefix(String logo){
    //http://localhost:5008/img/logos/texaco_logo_100_x_100.jpg
    var prefix = AppConsts.stationLogoBaseurl;
    var url = "$prefix/${logo}_logo_200_x_200.jpg";
    return url;
  }

  //  TODO not tested
  static String getPetrolStationCoverPhoto(String logo){
    var prefix = AppConsts.stationLogoBaseurl;
    var url = "$prefix/${logo}_cover.png";
    return url;
  }

  //  TODO not tested
  static String getDistanceAwayText(double distance, int unit){
    var reply = ( unit == 0 ) ? "${distance.toStringAsFixed(3)} km(s) away." : "${distance.toStringAsFixed(3)} mi(s) away.";
    return reply;
  }


  static String getGreeting(String name) {
    String greeting = "";
    DateTime now = DateTime.now();
    int hours = now.hour;

    if (hours >= 1 && hours <= 12) {
      greeting = "Good Morning $name";
    } else if (hours >= 12 && hours <= 16) {
      greeting = "Good Afternoon $name";
    } else if (hours >= 16 && hours <= 21) {
      greeting = "Good Evening $name";
    } else if (hours >= 21 && hours <= 24) {
      greeting = "Good Night $name";
    }

    return greeting;
  }

}