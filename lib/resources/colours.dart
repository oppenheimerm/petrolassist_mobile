import 'package:flutter/material.dart';

class AppColours {
  static const paWhiteColour = Color(0xffFAF7F7);
  static const paPrimaryColour = Color(0xffA1D18E);
  static const paPrimaryColourActive = Color(0xff9EE6A6);

  static const paAccentDust = Color(0xffCDCCC6);
  static const paAccentDustActive = Color(0xffBABAB6);
  static const paBlackColour1 = Color(0xff303030);
  static const paBlackColour2 = Color(0xff141516);/* darker */
  static const paDisabledColour = Color(0xffB5B3A8);
  static const paGreyColour = Color(0xff3C3F40);
  static const paErrorColour = Color(0xffC0392B);
  static const paErrorFocusColour = Color(0xffD35400);

  // Background Colours
  static const paBackgroundColourLight = paWhiteColour;
  static const paBackgroundColourDark = paBlackColour1;

  //  Text Colours
  static const paTextColourPrimary = paBlackColour1;
  static const paTextColourSecondary = paGreyColour;
  static const paTextColourWhite = paWhiteColour;

  //  Errors / Validation
  /* Same as primary colour, but should we change it,
  * we'll stick with this colour for success */
  static const paSuccessColour = Color(0xff13AE70);
  static const paWarningColour = Color(0xffF39C12);
  static const paInfoColour = Color(0xff3498DB);




  static const buttonOKColour = paPrimaryColour;
  static const semiTransparentColour = Colors.grey;
  static const transparentColour = Colors.transparent;

  //  new scheme
  static const highlightColour = Color(0xff13AE70);
  static const blackColour1 = Color(0xff22272C);//Dark
  static const blackColour2 = Color(0xff141516);//Darker
  static const greyColour = Color(0xff2E343B);//Darkest
}
