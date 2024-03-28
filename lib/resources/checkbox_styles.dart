import 'package:flutter/material.dart';
import 'package:petrol_assist_mobile/resources/colours.dart';

class PACheckBoxStyle {
  // Make this constructor private; preventing any instantiation.  This
  // allows us to call below static function via this class
  PACheckBoxStyle._();

  static CheckboxThemeData lightCheckboxTheme =  CheckboxThemeData(
    shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(4)),
    checkColor: MaterialStateProperty.resolveWith((states) {
      if(states.contains(MaterialState.selected)){
        return AppColours.paWhiteColour;
      }else{
        return AppColours.paBlackColour1;
      }
    }),
    fillColor: MaterialStateProperty.resolveWith((states){
      if(states.contains(MaterialState.selected)){
        return AppColours.paPrimaryColour;
      }else{
        return Colors.transparent;
      }
    })

  );

  static CheckboxThemeData darkCheckboxTheme =  CheckboxThemeData(
      shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(4)),
      checkColor: MaterialStateProperty.resolveWith((states) {
        if(states.contains(MaterialState.selected)){
          return AppColours.paBlackColour1;
        }else{
          return Colors.transparent;
        }
      }),
      fillColor: MaterialStateProperty.resolveWith((states){
        if(states.contains(MaterialState.selected)){
          return AppColours.paPrimaryColour;
        }else{
          return Colors.transparent;
        }
      })

  );

}