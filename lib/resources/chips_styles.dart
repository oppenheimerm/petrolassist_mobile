import 'package:flutter/material.dart';
import 'package:petrol_assist_mobile/resources/colours.dart';

//  Chips are compact elements that represent an attribute, text, entity, or action.
//  see: https://m3.material.io/components/chips/overview

class PAChipsStyle {
  // Make this constructor private; preventing any instantiation.  This
  // allows us to call below static function via this class
  PAChipsStyle._();

  static ChipThemeData lightChipTheme = ChipThemeData(
    disabledColor: AppColours.paDisabledColour.withOpacity(0.6),
    labelStyle: const TextStyle(color: AppColours.paBlackColour1),
    selectedColor: AppColours.paPrimaryColour,
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    checkmarkColor: AppColours.paWhiteColour,
  );

  static ChipThemeData darkChipTheme = const ChipThemeData(
    disabledColor: AppColours.paDisabledColour,
    labelStyle: TextStyle(color: AppColours.paWhiteColour),
    selectedColor: AppColours.paPrimaryColour,
    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    checkmarkColor: AppColours.paWhiteColour,
  );
}
