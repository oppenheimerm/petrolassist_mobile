import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:petrol_assist_mobile/models/direction_details_info.dart';
import 'package:petrol_assist_mobile/views/home_view.dart';
import 'package:petrol_assist_mobile/views/login_view.dart';


import '../app_constants.dart';
import '../helpers.dart';
import '../request_response/authentication_request_response.dart';
import '../service/authentication/authentication_service.dart';
import '../service/local_storage.dart';
import '../utilities/utils.dart';

class UserViewModel with ChangeNotifier {

  LatLng? _locationOrigin;
  LatLng? _locationStation;
  String? _addressStringOrigin;
  String? _addressStation;
  LatLngBounds? _boundLatLng;
  late MapStyleTheme _mapStyleTheme;
  // set when the user clicks confirm
  late bool _startAddressConfirmed = false;
  late bool _stationAddressConfirmed = false;
  // set in home_vm / getHumanReadableAddressFromLatLng()
  late bool _hasStartAddress = false;
  late bool _hasDirectionDetailsInfo = false;
  late DirectionDetailsInfo? _directionDetailsInfo;
  late Polyline _polyline;
  late Set<Marker> _markerSet = {};
  late Set<Circle> _circleSet = {};



  LatLng? get locationOrigin { return _locationOrigin; }
  LatLng? get locationStation { return _locationStation; }
  String? get addressStringOrigin { return _addressStringOrigin; }
  String? get addressStation { return _addressStation; }
  MapStyleTheme get mapStyle => _mapStyleTheme;
  bool get startAddressConfirmed => _startAddressConfirmed;
  bool get hasStartAddress => _hasStartAddress;
  bool get stationAddressConfirmed => _stationAddressConfirmed;
  bool get hasDirectionDetailsInfo => _hasDirectionDetailsInfo;
  DirectionDetailsInfo? get directionDetailsInfo => _directionDetailsInfo;
  Polyline get polyline => _polyline;
  LatLngBounds? get boundLatLng { return _boundLatLng; }
  Set<Marker> get markerSet { return _markerSet; }
  Set<Circle> get circleSet { return _circleSet; }

  set locationOrigin(LatLng? tripOrigin){
    _locationOrigin = tripOrigin;
    notifyListeners();
  }

  set locationStation(LatLng? station){
    _locationStation = station;
    notifyListeners();
  }

  set addressStringOrigin(String? address){
    _addressStringOrigin = address;
    notifyListeners();
  }

  set addressStation(String? address){
    _addressStation = address;
    notifyListeners();
  }

  set mapStyle(MapStyleTheme mapStyle) {
    _mapStyleTheme = mapStyle;
    notifyListeners();
  }

  set startAddressConfirmed(bool confirmed){
    _startAddressConfirmed = confirmed;
    notifyListeners();
  }
  set hasStartAddress(bool val){
    _hasStartAddress = val;
    notifyListeners();
  }

  set hasDirectionDetailsInfo(bool val){
    _hasDirectionDetailsInfo = val;
    notifyListeners();
  }

  set stationAddressConfirmed(bool val){
    _stationAddressConfirmed = val;
    notifyListeners();
  }

  set directionDetailsInfo(DirectionDetailsInfo? val){
    _directionDetailsInfo = val;
    notifyListeners();
  }

  set polyline(Polyline val){
    _polyline = val;
    notifyListeners();
  }

  set boundLatLng(LatLngBounds? val){
    _boundLatLng = val;
    notifyListeners();
  }

  set markerSet(Set<Marker> val){
    _markerSet = val;
    notifyListeners();
  }

  set circleSet(Set<Circle> val){
    _circleSet = val;
    notifyListeners();
  }

  final AuthenticationService _authenticationService = AuthenticationService();

  Future<AuthenticationRequestResponse> getCurrentUser() async{
    return await _authenticationService.currentUser();
  }

  void checkAuthentication(BuildContext context) async{
    await getCurrentUser().then((value) async {

      // check here
      if(value.success)
        {
          //await Navigator.pushReplacementNamed(context, AppConsts.rootHome);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeView()),
          );
        }
      else{
        var errorMessage = (value.errorMessage != null) ? value.errorMessage : "Please login.";
        Utils.snackBar(errorMessage!, context);
        //await Navigator.pushReplacementNamed(context, AppConsts.rootLogin);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
        );
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