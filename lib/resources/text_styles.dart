import 'package:flutter/material.dart';
import 'package:petrol_assist_mobile/resources/colours.dart';

// PA to prevent naming conflict
class PATextStyles{
  PATextStyles._();

  //  See notes on use of .copyWith()
  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith( fontSize: 32, fontWeight: FontWeight.w700, color: AppColours.paBlackColour1 ),
    headlineMedium: const TextStyle().copyWith( fontSize: 24, fontWeight: FontWeight.w600, color: AppColours.paBlackColour1 ),
    headlineSmall: const TextStyle().copyWith( fontSize: 18, fontWeight: FontWeight.w400, color: AppColours.paBlackColour1 ),

    titleLarge: const TextStyle().copyWith( fontSize: 20, fontWeight: FontWeight.w500, color: AppColours.paBlackColour1 ),
    titleMedium: const TextStyle().copyWith( fontSize: 16, fontWeight: FontWeight.w400, color: AppColours.paBlackColour1 ),
    titleSmall: const TextStyle().copyWith( fontSize: 16, fontWeight: FontWeight.w300, color: AppColours.paBlackColour1 ),

    bodyLarge: const TextStyle().copyWith( fontSize: 14, fontWeight: FontWeight.w500, color: AppColours.paBlackColour1 ),
    bodyMedium: const TextStyle().copyWith( fontSize: 14, fontWeight: FontWeight.w400, color: AppColours.paBlackColour1 ),
    bodySmall: const TextStyle().copyWith( fontSize: 14, fontWeight: FontWeight.w500, color: AppColours.paBlackColour1 ),

    labelLarge: const TextStyle().copyWith( fontSize: 12.8, fontWeight: FontWeight.w500, color: AppColours.paBlackColour1 ),
    labelMedium: const TextStyle().copyWith( fontSize: 12.8, fontWeight: FontWeight.w500, color: AppColours.paBlackColour1.withOpacity(0.7) ),
  );

  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith( fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white ),
    headlineMedium: const TextStyle().copyWith( fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white ),
    headlineSmall: const TextStyle().copyWith( fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white ),

    titleLarge: const TextStyle().copyWith( fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white ),
    titleMedium: const TextStyle().copyWith( fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white ),
    titleSmall: const TextStyle().copyWith( fontSize: 16, fontWeight: FontWeight.w300, color: Colors.white ),

    bodyLarge: const TextStyle().copyWith( fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white ),
    bodyMedium: const TextStyle().copyWith( fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white ),
    bodySmall: const TextStyle().copyWith( fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white ),

    labelLarge: const TextStyle().copyWith( fontSize: 12.8, fontWeight: FontWeight.w500, color: Colors.white ),
    labelMedium: const TextStyle().copyWith( fontSize: 12.8, fontWeight: FontWeight.w500, color: Colors.white ),
  );

  /// fontSize text 24 / colour white / font weight bold
  static const TextStyle largeTextBold = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w800,
      color: AppColours.paWhiteColour
  );
  /// fontSize text 24 / colour white
  static const TextStyle largeText = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      color: AppColours.paWhiteColour
  );

  static const TextStyle regularText = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: Colors.white
  );

  static const TextStyle regularTextBold = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w800,
      color: Colors.white
  );

  static const TextStyle smallText = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.white
  );
}