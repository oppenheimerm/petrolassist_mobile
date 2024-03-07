import 'package:flutter/material.dart';

import 'authentication_service.dart';

//  InheritedWidget class
//  Inherited widgets, when referenced in this way, will cause
//  the consumer to rebuild when the inherited widget itself changes state.
//  https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html
class AuthProvider extends InheritedWidget {
  const AuthProvider({required super.key, required super.child, required this.auth});
  final AuthenticationService auth;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static AuthProvider of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<AuthProvider>() as AuthProvider);
  }
}