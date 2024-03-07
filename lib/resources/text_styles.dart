import 'package:flutter/material.dart';

// PA to prevent naming conflict
class PATextStyles{

  /// fontSize text 24 / colour white / font weight bold
  static const TextStyle largeTextBold = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w800,
      color: Colors.white
  );
  /// fontSize text 24 / colour white
  static const TextStyle largeText = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      color: Colors.white
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