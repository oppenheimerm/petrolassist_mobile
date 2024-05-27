import 'package:flutter/material.dart';
import 'package:petrol_assist_mobile/resources/colours.dart';

// PA to prevent naming conflict
class PABottomSheetsStyles {
  // Make this constructor private; preventing any instantiation.  This
  // allows us to call below static function via this class
  PABottomSheetsStyles._();

  static BottomSheetThemeData lightBottomSheetsTheme = BottomSheetThemeData(
    showDragHandle: true,
    backgroundColor: AppColours.paAccentDust,
    modalBackgroundColor: AppColours.paAccentDust,
    constraints: const BoxConstraints( minWidth: double.infinity),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
  );

  static BottomSheetThemeData darkBottomSheetsTheme = BottomSheetThemeData(
      showDragHandle: true,
      backgroundColor: AppColours.paBlackColour1,
      modalBackgroundColor: AppColours.paBlackColour1,
      constraints: const BoxConstraints( minWidth: double.infinity),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
  );

}