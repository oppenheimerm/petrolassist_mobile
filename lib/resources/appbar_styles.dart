
import 'package:flutter/material.dart';
import 'package:petrol_assist_mobile/resources/colours.dart';

class PAAppBarStyle {
  // Make this constructor private; preventing any instantiation.  This
  // allows us to call below static function via this class
  PAAppBarStyle._();

  static const lightAppBarTheme = AppBarTheme(
    elevation: 5,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(
      color:  AppColours.paBlackColour1,
      size: 24
    ),
    actionsIconTheme: IconThemeData(
      color: AppColours.paBlackColour1,
      size: 24,
    ),
      titleTextStyle: TextStyle(
      fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColours.paBlackColour1
    )
  );

  static const darkAppBarTheme = AppBarTheme(
      elevation: 5,
      centerTitle: false,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(
          color:  AppColours.paPrimaryColour,
          size: 24
      ),
      actionsIconTheme: IconThemeData(
        color: AppColours.paWhiteColour,
        size: 24,
      ),
      titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColours.paWhiteColour
      )
  );

}