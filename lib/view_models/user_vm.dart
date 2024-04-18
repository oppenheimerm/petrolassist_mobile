import 'package:flutter/material.dart';


import '../app_constants.dart';
import '../request_response/authentication_request_response.dart';
import '../service/authentication/authentication_service.dart';
import '../service/local_storage.dart';
import '../utilities/utils.dart';

class UserViewModel with ChangeNotifier {

  final AuthenticationService _authenticationService = AuthenticationService();

  Future<AuthenticationRequestResponse> getCurrentUser() async{
    return await _authenticationService.currentUser();
  }

  void checkAuthentication(BuildContext context) async{
    await getCurrentUser().then((value) async {

      // check here
      if(value.success)
        {
          await Navigator.pushReplacementNamed(context, AppConsts.rootHome);
        }
      else{
        var errorMessage = (value.errorMessage != null) ? value.errorMessage : "Please login.";
        Utils.snackBar(errorMessage!, context);
        await Navigator.pushReplacementNamed(context, AppConsts.rootLogin);
      }
    }).onError((error, stackTrace) => throw Exception(error.toString()));
  }

  void logout(){
    _authenticationService.signOut();
  }

  String? getCarPhotoUrl(){
    var usr = LocalStorageService.getUserFromDisk();
    if(usr != null ){
      var img =  (usr.photo.isNotEmpty)? usr.photo : "";
      if(img.isNotEmpty){
        debugPrint("User photo url: ${"${AppConsts.baseUrl}${AppConsts.memberFolderPostfix}/$img"}");
        return "${AppConsts.baseUrl}${AppConsts.memberFolderPostfix}/$img";
      }else{
        return null;
      }
    }else{
      return null;
    }
  }
}