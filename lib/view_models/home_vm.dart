import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


import '../app_constants.dart';
import '../helpers.dart';
import '../service/authentication/authentication_service.dart';

class HomeViewModel with ChangeNotifier{

  MapStyleTheme mapStyleTheme;
  final AuthenticationService _authenticationService = AuthenticationService();
  bool _loadingMap = true;

  HomeViewModel(
    [this.mapStyleTheme = MapStyleTheme.night]
);


  void setGoogleMapStyle(String googleMapStyle, GoogleMapController controller){
    controller.setMapStyle(googleMapStyle);
    notifyListeners();
  }

  void updateMapTheme(GoogleMapController controller) async {
    try{
      await Helpers.getThemeFile(mapStyleTheme).then((value) {
        if(value != null)
          {
            setGoogleMapStyle(value, controller);
            notifyListeners();
          }
      });
    }
    catch(err){
      debugPrint('Error in home_vm.dart, line: 26: ${err.toString()}');
    }
  }

  void setLoadingState(bool state){
    _loadingMap = state;
    notifyListeners();
  }

  bool getLoadingState(){
    return _loadingMap;
  }

  void logout(BuildContext context) async{
    await _authenticationService.signOut().then((value) {
      Navigator.pushReplacementNamed(context, AppConsts.rootLogin);
    });
  }

}