import 'package:flutter/material.dart';
import 'package:petrol_assist_mobile/resources/bottom_sheets_styles.dart';
import 'package:petrol_assist_mobile/resources/checkbox_styles.dart';
import 'package:petrol_assist_mobile/resources/chips_styles.dart';
import 'package:petrol_assist_mobile/resources/colours.dart';
import 'package:petrol_assist_mobile/resources/outline_button_styles.dart';
import 'package:petrol_assist_mobile/resources/text_styles.dart';
import 'package:petrol_assist_mobile/resources/textform_field_styles.dart';

import 'appbar_styles.dart';
import 'elevated_button_theme.dart';

// https://www.youtube.com/watch?v=Ct9CrMegezQ&list=PL5jb9EteFAOAusKTSuJ5eRl1BapQmMDT6&index=4
class PATheme{
  // Make this constructor private; preventing any instantiation.  This
  // allows us to call below static function via this class
  PATheme._();


  /// Returns the application light theme.
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'DM Sans',
    brightness: Brightness.light,
    primaryColor: AppColours.paPrimaryColour,
    scaffoldBackgroundColor: AppColours.paAccentDust,
    textTheme: PATextStyles.lightTextTheme,
    elevatedButtonTheme: PAElevatedButtonStyles.lightElevatedButtonTheme,
    appBarTheme: PAAppBarStyle.lightAppBarTheme,
    bottomSheetTheme: PABottomSheetsStyles.lightBottomSheetsTheme,
    checkboxTheme: PACheckBoxStyle.lightCheckboxTheme,
    chipTheme: PAChipsStyle.lightChipTheme,
    outlinedButtonTheme: PAOutlineButtonStyle.lightOutlineButtonTheme,
    inputDecorationTheme: PATextFormFieldStyle.lightInputDecorationTheme
  );
  /// Returns the application dark theme.
  static ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'DM Sans',
      brightness: Brightness.dark,
      primaryColor: AppColours.paPrimaryColour,
      scaffoldBackgroundColor: AppColours.paBlackColour1,
      textTheme: PATextStyles.darkTextTheme,
      elevatedButtonTheme: PAElevatedButtonStyles.darkElevatedButtonTheme,
      appBarTheme: PAAppBarStyle.darkAppBarTheme,
      bottomSheetTheme: PABottomSheetsStyles.darkBottomSheetsTheme,
      checkboxTheme: PACheckBoxStyle.darkCheckboxTheme,
      chipTheme: PAChipsStyle.darkChipTheme,
      outlinedButtonTheme: PAOutlineButtonStyle.darkOutlineButtonTheme,
      inputDecorationTheme: PATextFormFieldStyle.darkInputDecorationTheme
  );
}