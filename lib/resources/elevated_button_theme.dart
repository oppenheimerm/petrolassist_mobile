import 'package:flutter/material.dart';
import 'package:petrol_assist_mobile/resources/colours.dart';
import 'package:petrol_assist_mobile/resources/styles_constants.dart';

// PA to prevent naming conflict
class PAElevatedButtonStyles {
  // Make this constructor private; preventing any instantiation.  This
  // allows us to call below static function via this class
  PAElevatedButtonStyles._();

  /// Light theme(default)
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: PAAppStylesConstants.maxButtonElevation,
      foregroundColor: AppColours.paWhiteColour,
      backgroundColor: AppColours.paPrimaryColour,
      disabledForegroundColor: AppColours.paDisabledColour,/* DUPLICATE STYLE FOR NOW*/
      disabledBackgroundColor: AppColours.paDisabledColour,/* DUPLICATE STYLE FOR NOW*/
      side: BorderSide( color: AppColours.paBlackColour1.withOpacity(0.2)),/* Border */
      padding: const EdgeInsets.symmetric(vertical: 20),
      textStyle: const TextStyle(fontSize: 20, color: AppColours.paWhiteColour, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
      )
    );

  /// Dark Theme
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          elevation: PAAppStylesConstants.maxButtonElevation,
          foregroundColor: AppColours.paBlackColour1,
          backgroundColor: AppColours.paPrimaryColour,
          disabledForegroundColor: AppColours.paDisabledColour,/* DUPLICATE STYLE FOR NOW*/
          disabledBackgroundColor: AppColours.paDisabledColour,/* DUPLICATE STYLE FOR NOW*/
          side: const BorderSide( color: AppColours.paBlackColour2),/* Border */
          padding: const EdgeInsets.symmetric(vertical: 20),
          textStyle: const TextStyle(fontSize: 20, color: AppColours.paWhiteColour, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
      )
  );
}