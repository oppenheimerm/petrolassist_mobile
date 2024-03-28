//  This service will use the Singleton pattern and instances will
//  be retrieved through a getInstance() static function. We’ll
//  keep a static instance of the SharedPreferences as well as the
//  instance for our service.
//
//  https://www.filledstacks.com/snippet/shared-preferences-service-in-flutter-for-code-maintainability/
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../app_constants.dart';
import '../models/user.dart';
import 'operation_status.dart';


class LocalStorageService {
  static LocalStorageService? _instance;
  static SharedPreferences? _preferences;


  //  Where '??=' is a null aware operator.  Dart offers
  //  this handy operators for dealing with values that
  //  might be null. The ??= assignment operator, which
  //  assigns a value to a variable only if that variable
  //  is currently null.  Not that our return type is
  //  also nullable(LocalStorageService?)
  //
  //  https://dart.dev/codelabs/dart-cheatsheet
  static Future<LocalStorageService?> getInstance() async {
    _instance ??= LocalStorageService();

    _preferences ??= await SharedPreferences.getInstance();

    return _instance;
  }


  static UserModel? getUserFromDisk() {
    try{
      //  To guard access to a property or method of an object that might be null,
      //  put a question mark (?) before the dot (.):

      var authStatus = ((_preferences?.getString( AppConsts.authStatus) != null)
          ? authStatusFromString( _preferences!.getString( AppConsts.authStatus)! )
          : AuthStatus.notSignedIn);

      var timeStamp = (( _preferences?.getString(AppConsts.loginTimeStamp) != null)
          ? DateTime.parse( _preferences!.getString( AppConsts.loginTimeStamp )! )
          : null);

      //var expTime =  _preferences?.getString(AppConsts.refreshTokenExpiry);
      var refreshTokenExpiry = (( _preferences?.getString(AppConsts.refreshTokenExpiry) != null)
          ? DateTime.parse( _preferences!.getString( AppConsts.refreshTokenExpiry )! )
          : null);

      var user = UserModel(
        (_preferences?.getString( AppConsts.userId) ?? "" ),
        (_preferences?.getString( AppConsts.firstName) ?? ""),
        (_preferences?.getString( AppConsts.lastName) ?? ""),
        (_preferences?.getString( AppConsts.jwtToken) ?? ""),
        (_preferences?.getString( AppConsts.photo) ?? ""),
        (_preferences?.getString( AppConsts.emailAddress) ?? ""),
        (_preferences?.getString( AppConsts.mobile) ?? ""),
        (_preferences?.getInt( AppConsts.distanceUnit) ?? 1),
        authStatus,
        timeStamp,
        _preferences?.getString( AppConsts.refreshToken),
        refreshTokenExpiry,
      );

      return user;
    }catch(err){
      return UserModel.getNullUser();
    }
  }



  //  TODO You're not properly handling this async code!
  static Future<OperationStatus> deleteUser() async {
    try {
      var futureList = <Future>[
        _preferences!.remove( AppConsts.userId),
        _preferences!.remove( AppConsts.firstName),
        _preferences!.remove( AppConsts.lastName),
        _preferences!.remove( AppConsts.jwtToken),
        _preferences!.remove( AppConsts.photo),
        _preferences!.remove( AppConsts.emailAddress),
        _preferences!.remove( AppConsts.mobile),
        _preferences!.remove( AppConsts.distanceUnit),
        _preferences!.remove( AppConsts.authStatus),
        _preferences!.remove( AppConsts.loginTimeStamp),
        _preferences!.remove( AppConsts.refreshToken),
        _preferences!.remove( AppConsts.refreshTokenExpiry),
      ];
      var result = await Future.wait(futureList);
      var persistenceResult = result.any((value) => value == false);
      if(persistenceResult){
        debugPrint('Could not persist user');
        return OperationStatus(
            false,
            "Delete operation failed.",
            AppConsts.couldNotDeleteStoredUser);
      }else{
        return OperationStatus(
            true,
            "Successfully deleted user.",
            AppConsts.operationSuccess
        );
      }
    } catch (err) {
      return OperationStatus(
          false,
          "Delete operation failed.",
          AppConsts.couldNotDeleteStoredUser);
    }
  }


  static Future<OperationStatus> persistUser(UserModel userToSave) async {
    try {
      var futureList = <Future>[
        _preferences!.setString( AppConsts.userId, userToSave.id),
        _preferences!.setString( AppConsts.firstName, userToSave.firstName),
        _preferences!.setString( AppConsts.lastName, userToSave.lastName),
        _preferences!.setString( AppConsts.jwtToken, userToSave.jwtToken),
        _preferences!.setString( AppConsts.photo, userToSave.photo),
        _preferences!.setString( AppConsts.emailAddress, userToSave.emailAddress),
        _preferences!.setString( AppConsts.mobile, userToSave.mobileNumber),
        _preferences!.setInt( AppConsts.distanceUnit, userToSave.distanceUnit),
        _preferences!.setString( AppConsts.authStatus, userToSave.authStatus.toString()),
        _preferences!.setString( AppConsts.loginTimeStamp, userToSave.loginTimeStamp.toString()),
        //  Make sure below is not null
        _preferences!.setString( AppConsts.refreshToken, userToSave.refreshToken.toString()),
        _preferences!.setString( AppConsts.refreshTokenExpiry, userToSave.refreshTokenExpiry.toString())
      ];

      var result = await Future.wait(futureList);
      //  Do something with persistStatus value
      var persistenceResult = result.any((value) => value == false);
      if(persistenceResult){
        debugPrint('Could not persist user');
        return OperationStatus(false, "Could not persist user", AppConsts.couldNotPersistUser);
      }else{
        debugPrint('Successfully updated user data');
        return OperationStatus(true, 'Successfully saved user data.', AppConsts.operationSuccess);
      }

    } catch (err) {
      debugPrint(err.toString());
      return OperationStatus(false, "Could not persist user", AppConsts.couldNotPersistUser);
    }
  }

  static OperationStatus saveStringToDisk(String key, String content) {

    //_preferences.setString(UserKey, content);
    //  To guard access to a property or method of an object that might be null,
    //  put a question mark (?) before the dot (.):
    try {
      _preferences?.setString(key, content);
      return OperationStatus(true, 'Saved user with $key and value: $content', AppConsts.operationSuccess);
    } catch (err) {
      return OperationStatus(false, 'Could not save data with $key.', AppConsts.couldNotPersistKeyValue);
    }
  }
}