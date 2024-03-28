import 'package:flutter/material.dart';
import 'package:petrol_assist_mobile/resources/colours.dart';

class PATextFormFieldStyle {
  // Make this constructor private; preventing any instantiation.  This
  // allows us to call below static function via this class
  PATextFormFieldStyle._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3, /* The max number of lines the InputDecoration.errorText can occupy */
    prefixIconColor: AppColours.paGreyColour,
    suffixIconColor: AppColours.paGreyColour,
    /* Remember copyWith() -  allows the user to create a new object by copying
       existing data and modifying selected fields.
    */
    labelStyle: const TextStyle().copyWith(fontSize: 16, color: AppColours.paBlackColour1),
    hintStyle: const TextStyle().copyWith(fontSize: 16, color: AppColours.paBlackColour1),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle:  const TextStyle().copyWith(color: AppColours.paBlackColour1.withOpacity(0.8)),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(width: 1, color: AppColours.paGreyColour),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(width: 1, color: AppColours.paGreyColour),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(width: 1, color: AppColours.paBlackColour1),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(width: 1, color: AppColours.paErrorColour),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(width: 2, color: AppColours.paErrorFocusColour),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3, /* The max number of lines the InputDecoration.errorText can occupy */
    prefixIconColor: AppColours.paWhiteColour,
    suffixIconColor: AppColours.paWhiteColour,
    /* Remember copyWith() -  allows the user to create a new object by copying
       existing data and modifying selected fields.
    */
    labelStyle: const TextStyle().copyWith(fontSize: 16, color: AppColours.paWhiteColour),
    hintStyle: const TextStyle().copyWith(fontSize: 16, color: AppColours.paWhiteColour),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle:  const TextStyle().copyWith(color: AppColours.paWhiteColour.withOpacity(0.8)),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(width: 1, color: AppColours.paWhiteColour),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(width: 1, color: AppColours.paWhiteColour),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(width: 1, color: AppColours.paWhiteColour),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(width: 1, color: AppColours.paErrorColour),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(width: 2, color: AppColours.paErrorFocusColour),
    ),
  );
}