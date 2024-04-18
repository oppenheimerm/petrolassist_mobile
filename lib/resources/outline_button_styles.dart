import 'package:flutter/material.dart';
import 'package:petrol_assist_mobile/resources/colours.dart';
import 'package:petrol_assist_mobile/resources/styles_constants.dart';

//  Chips are compact elements that represent an attribute, text, entity, or action.
//  see: https://m3.material.io/components/chips/overview

class PAOutlineButtonStyle {
  // Make this constructor private; preventing any instantiation.  This
  // allows us to call below static function via this class
  PAOutlineButtonStyle._();

  static final lightOutlineButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: PAAppStylesConstants.maxButtonElevation,
      foregroundColor: AppColours.paBlackColour1,
      side: const BorderSide( color: AppColours.paPrimaryColour, width: 2),/* Border */
      textStyle: const TextStyle(fontSize: 24, color: AppColours.paBlackColour1, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
    ),
  );

  static final darkOutlineButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
        elevation: PAAppStylesConstants.maxButtonElevation,
        foregroundColor: AppColours.paWhiteColour,
        side: const BorderSide( color: AppColours.paPrimaryColour),/* Border */
        textStyle: const TextStyle(fontSize: 24, color: AppColours.paBlackColour1, fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
    ),
  );
}
