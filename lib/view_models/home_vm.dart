import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:petrol_assist_mobile/service/network_get_request.dart';

import '../app_constants.dart';
import '../helpers.dart';
import '../models/user.dart';
import '../request_response/directions.dart';
import '../resources/colours.dart';
import '../resources/styles_constants.dart';
import '../resources/text_string.dart';
import '../service/authentication/authentication_service.dart';
import '../service/local_storage.dart';
import '../service/network_service.dart';
import '../utilities/utils.dart';

class HomeViewModel with ChangeNotifier {
  MapStyleTheme _mapStyleTheme;
  final AuthenticationService _authenticationService = AuthenticationService();
  final NetworkGetRequests _networkGetRequests = NetworkGetRequests();
  final PANetworkService _networkService = PANetworkService();

  //  PetrolAssist geo point
  //PAGeoPoint? _userCurrentPAGeoPoint;
  // Google maps detailed location information.
  Position? _userPosition;
  bool _loadingMap = true;
  bool _currentLocationSet = false;

//  pickUpLocation
  LatLng? _locationOrigin;
  String? _addressStringFromLatLng;


  UserModel? get getUser => LocalStorageService.getUserFromDisk();
  //PAGeoPoint? get getUserCurrentLocation => _userCurrentPAGeoPoint;
  bool get currentLocationSet  => _currentLocationSet;
  Position? get currentPosition => _userPosition;
  LatLng? get locationOrigin { return _locationOrigin; }
  String? get addressStringFromLatLng { return _addressStringFromLatLng; }


  MapStyleTheme get mapStyle => _mapStyleTheme;

  set mapStyle(MapStyleTheme mapStyle) {
    _mapStyleTheme = mapStyle;
    notifyListeners();
  }

  set locationOrigin(LatLng? latLng){
    _locationOrigin = latLng;
    notifyListeners();
  }

  set addressStringFromLatLng(String? addressString){
    _addressStringFromLatLng = addressStringFromLatLng;
    notifyListeners();
  }

  set currentLocationSet(bool currentLocationSet){
    _currentLocationSet = currentLocationSet;
    notifyListeners();
  }


  HomeViewModel([this._mapStyleTheme = MapStyleTheme.silver]);

  /*void setCurrentLocation(PAGeoPoint paGeoPoint){
    _userCurrentPAGeoPoint = paGeoPoint;
    _currentLocationSet = true;
    notifyListeners();
  }*/

  void setCurrentPosition(Position position){
    _userPosition = position;
    notifyListeners();
  }

  LatLng? getLatLngFromPosition(Position? position){
    if(position != null){
      return LatLng(position.latitude, position.longitude);
    }
    return null;
  }

  Future updateMapTheme(GoogleMapController controller, bool isDarkMode) async {
    try {
      //color: dark ? AppColours.paWhiteColour : AppColours.blackColour1.withOpacity(0.85),
      var style = isDarkMode ? MapStyleTheme.night : MapStyleTheme.silver;
      await Helpers.getThemeFile(style).then((value) {
        if (value != null) {
          _setGoogleMapStyle(value, controller);
          notifyListeners();
        }
      });
    } catch (err) {
      debugPrint('Error in home_vm.dart, line: 26: ${err.toString()}');
    }
  }

  //  TODO - Test and remve
  /*getUserCurrentLocation(
      bool isMounted,
      BuildContext context,
      Position? currentPositionOfUser,
      GoogleMapController? mapController) async {
    try {
      // Get the real current position of the user
      Position positionOfUser = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      currentPositionOfUser = positionOfUser;
      // Convert to lat/long type
      LatLng latLngPositionOfUser = LatLng(
          currentPositionOfUser!.latitude, currentPositionOfUser!.longitude);
      // Set the location and animate the camera on google maps to the users current position
      CameraPosition cameraPosition =
          CameraPosition(target: latLngPositionOfUser, zoom: 15);
      mapController!
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      String humanReadableAddress = "";

      //https://stackoverflow.com/questions/72505027/do-not-use-buildcontexts-across-async-gaps-after-update-pub-yaml-to-the-major-v
      //https://stackoverflow.com/questions/72667782/undefined-name-mounted
      String addressRequestReply =
          await searchAddressForGeographicCoordinates(currentPositionOfUser);
      if (addressRequestReply == PATextString.noNetworkDetected) {
        if (!isMounted) return;
        Utils.snackBar(PATextString.checkNetwork, context);
      } else if (addressRequestReply == PATextString.couldNotGeoCodeLocation) {
        if (!isMounted) return;
        Utils.snackBar(PATextString.checkNetwork, context);
      } else {
        // Should be an array here
        humanReadableAddress = addressRequestReply;
        //humanReadableAddress = addressRequestReply["results"][0]["formatted-address"];
      }

      //print("This is our address: $humanReadableAddress");
    } catch (err) {
      debugPrint(err.toString());
    }
  }*/

  /*resetPosition(double latitude, double longitude){
    _currentLocationSet = false;
    _userCurrentPAGeoPoint?.locationLatitude = latitude;
    _userCurrentPAGeoPoint?.locationLongitude = latitude;
    notifyListeners();
  }*/

  /*Future<String?> updateAddressGeographicCoordinates() async{
    String? reply;
    await _networkService.paGetNetworkStatus().then((value) async {

      if (value) {
        if(_userCurrentPAGeoPoint?.locationLatitude != null && _userCurrentPAGeoPoint?.locationLongitude != null){
          await _networkGetRequests.reverseGeoCodeRequest(
              _userCurrentPAGeoPoint!.locationLatitude!, _userCurrentPAGeoPoint!.locationLongitude!).then((value) async {

            if(value == PATextString.noNetworkDetected) {
              reply = PATextString.noNetworkDetected;
            }else if( value == PATextString.couldNotGeoCodeLocation){
              reply = PATextString.couldNotGeoCodeLocation;
            }else{
              if(value != null){
                // Should be an array here
                String humanReadableRequest = "";
                humanReadableRequest = value["results"][0]["formatted_address"];
;
                // TODO - Should do an addition check for null location name
                _userCurrentPAGeoPoint?.locationName = humanReadableRequest;
                _currentLocationSet = true;
                reply = PATextString.geoCodeSuccess;
                notifyListeners();
              }

            }
          });
        }else{
          reply = "ERROR";
        }

      }else {
        // Could not connect to network
        reply = PATextString.noNetworkDetected;
      }
    });
    return reply;
  }*/

  Future<String?> getHumanReadableAddressFromLatLng() async {
    //String apiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}}=${Env.googleMapsApiKey}";
    //String? humanReadableAddress = "";
    String? reply;
    await _networkService.paGetNetworkStatus().then((value) async {

      if (value) {
        await _networkGetRequests.reverseGeoCodeRequest(_locationOrigin!.latitude, _locationOrigin!.longitude).then((value) async {

          if(value == PATextString.noNetworkDetected) {
            reply = PATextString.noNetworkDetected;
          }else if( value == PATextString.couldNotGeoCodeLocation){
            reply = PATextString.couldNotGeoCodeLocation;
          }else{
            if(value != null){
              // Should be an array here
              String humanReadableRequest = "";
              humanReadableRequest = value["results"][0]["formatted_address"];
              _addressStringFromLatLng = humanReadableRequest;
              _currentLocationSet = true;
              reply = humanReadableRequest;
              notifyListeners();
            }

          }
        });

      }else {
        // Could not connect to network
        reply = PATextString.noNetworkDetected;
      }
    });
    return reply;
  }

  void _setGoogleMapStyle(
      String googleMapStyle, GoogleMapController controller) {
    // TODO setMapStyle deprecated
    controller.setMapStyle(googleMapStyle);
    notifyListeners();
  }

  void setLoadingState(bool state) {
    _loadingMap = state;
    notifyListeners();
  }

  bool getLoadingState() {
    return _loadingMap;
  }

  static String getGreeting(String name) {
    //  https://stackoverflow.com/questions/65185443/if-time-is-before-or-after-specific-time-display-good-morning-good-afternoon
    String greeting = "";
    DateTime now = DateTime.now();
    int hours = now.hour;

    if (hours >= 1 && hours <= 12) {
      greeting = "Good Morning $name";
    } else if (hours >= 12 && hours <= 16) {
      greeting = "Good Afternoon $name";
    } else if (hours >= 16 && hours <= 21) {
      greeting = "Good Evening $name";
    } else if (hours >= 21 && hours <= 24) {
      greeting = "Good Night $name";
    }

    return greeting;
  }

  Widget buildProfileTile(BuildContext context, String name, imageUrl) {
    return Positioned(
      top: 20,
      left: 20,
      right: 20,
      child: SizedBox(
        width: Utils.getScreenWidth(context),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 4,
                  color: AppColours.paPrimaryColour,
                ),
                // Add Some Shadow
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 2,
                    blurRadius: 10,
                    color: AppColours.paWhiteColour.withOpacity(0.09),
                    offset: const Offset(-3, 9),
                  ),
                ],
                shape: BoxShape.circle,
                image: _carImage(imageUrl),
              ),
            ),
            const SizedBox(
              width: PAAppStylesConstants.md,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getGreeting(name),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(
                  height: PAAppStylesConstants.xs,
                ),
                Text(PATextString.nearestPetrol,
                    style: Theme.of(context).textTheme.headlineMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }

  showBottomSheet(BuildContext context){
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return doModalBottomSheet(context);
        });
  }

  Widget buildCurrentLocationIcon(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8, right: 8),
        child: GestureDetector(
          onTap: (){
            //https://api.flutter.dev/flutter/material/showModalBottomSheet.html
            showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return doModalBottomSheet(context);
                });
          },
          child: const CircleAvatar(
            radius: 20,
            backgroundColor: AppColours.paPrimaryColour,
            child: Icon(
              Icons.my_location_sharp,
              color: AppColours.paWhiteColour,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBottomSheets(BuildContext context, bool dark) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: (Utils.getScreenWidth(context) * 0.65),
        height: 28,
        decoration: BoxDecoration(
            color: dark
                ? AppColours.paWhiteColour
                : AppColours.blackColour1.withOpacity(0.85),
            boxShadow: [
              BoxShadow(
                color: dark
                    ? AppColours.paWhiteColour.withOpacity(0.48)
                    : AppColours.blackColour1.withOpacity(0.85),
                spreadRadius: 4,
                blurRadius: 10,
              ),
            ],
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12), topLeft: Radius.circular(12))),
        child: Center(
          child: Container(
            width: (Utils.getScreenWidth(context) * 0.6),
            height: 2,
            color: dark ? AppColours.blackColour1 : AppColours.paWhiteColour,
          ),
        ),
      ),
    );
  }

  //  https://api.flutter.dev/flutter/material/showModalBottomSheet.html
  Container doModalBottomSheet(BuildContext context) {
    return Container(
      width: Utils.getScreenWidth(context),
      height: (Utils.getScreenHeight(context) * 0.5),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8), topRight: Radius.circular(8)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('Modal BottomSheet'),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close BottomSheet'),

              //https://www.youtube.com/watch?v=NgTk1oh_N5g&list=PLWNYjcx_ZHPco3yijOw-KwBQwjjcHc5Rj&index=11
              // Flutter drop down https://blog.logrocket.com/creating-dropdown-list-flutter/
            ),
          ],
        ),
      ),
    );
  }

  void logout(BuildContext context) async {
    await _authenticationService.signOut().then((value) {
      Navigator.pushReplacementNamed(context, AppConsts.rootLogin);
    });
  }

  DecorationImage _carImage(String? image) {
    if (image != null && image.isNotEmpty) {
      // use the network image
      return DecorationImage(image: NetworkImage(image), fit: BoxFit.cover);
    } else {
      // default image
      return const DecorationImage(
          image: AssetImage("assets/images/mini_countryman.jpg"),
          fit: BoxFit.cover);
    }
  }

}
