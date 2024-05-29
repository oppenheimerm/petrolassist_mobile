import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:petrol_assist_mobile/service/network_get_request.dart';
import 'package:petrol_assist_mobile/view_models/user_vm.dart';
import 'package:provider/provider.dart';

import '../app_constants.dart';
import '../components/shimmer_search.dart';
import '../helpers.dart';
import '../models/direction_details_info.dart';
import '../models/station.dart';
import '../models/user.dart';
import '../resources/colours.dart';
import '../resources/styles_constants.dart';
import '../resources/text_string.dart';
import '../service/local_storage.dart';
import '../service/network_service.dart';
import '../service/operation_status.dart';
import '../utilities/utils.dart';
import '../views/station.dart';

class HomeViewModel with ChangeNotifier {

  //final AuthenticationService _authenticationService = AuthenticationService();
  final NetworkGetRequests _networkGetRequests = NetworkGetRequests();
  final PANetworkService _networkService = PANetworkService();

  Position? _userPosition;
  bool _searchStationsLoading = true;
  bool _showMapIcon = true;

  //  TODO - remvove if not being used
  //bool _loadingMap = true;

  List<StationModel>? _stations;

  String? _addressStringFromLatLng;
  String? _addressStringToLatLng;

  //  This package contains functions to decode google encoded polyline string
  //  which returns a list of co-ordinates indicating route between two
  //  geographical position
  //
  //  Set<E> class - https://api.flutter.dev/flutter/dart-core/Set-class.html
  Set<Polyline> _polylineSet = {};

  UserModel? get getUser => LocalStorageService.getUserFromDisk();
  Position? get currentPosition => _userPosition;

  bool get searchStationsLoading => _searchStationsLoading;

  String? get addressStringFromLatLng { return _addressStringFromLatLng; }
  String? get addressStringToLatLng { return _addressStringToLatLng; }
  Set<Polyline> get polylineSet { return _polylineSet; }
  bool get showMapIcon { return _showMapIcon; }

  set addressStringFromLatLng(String? addressString){
    _addressStringFromLatLng = addressStringFromLatLng;
    notifyListeners();
  }

  set searchStationsLoading(bool loading){
    _searchStationsLoading = loading;
    notifyListeners();
  }

  set addressStringToLatLng(String? addressString){
    _addressStringToLatLng = addressString;
    notifyListeners();
  }

  set polylineSet(Set<Polyline> val) {
    _polylineSet = val;
    notifyListeners();
  }

  set showMapIcon(bool val){
    _showMapIcon = val;
    notifyListeners();
  }

  HomeViewModel();

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


  Future<String?> getHumanReadableAddressFromLatLng(UserViewModel userViewModel) async {
    //String apiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}}=${Env.googleMapsApiKey}";
    //String? humanReadableAddress = "";
    String? reply;
    await _networkService.paGetNetworkStatus().then((value) async {

      if (value) {
        await _networkGetRequests.reverseGeoCodeRequest( userViewModel.locationOrigin!.latitude, userViewModel.locationOrigin!.longitude).then((value) async {

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
              reply = humanReadableRequest;
              userViewModel.hasStartAddress = true;
              userViewModel.addressStringOrigin = humanReadableRequest;
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

  Future<OperationStatus> getOriginToDestinationDetails(UserViewModel userViewModel) async {

    OperationStatus status = OperationStatus(
        false, AppConsts.noNetworkDetected, AppConsts.operationFailed);

    await _networkService.paGetNetworkStatus().then((value) async {

      if (value) {
        await _networkGetRequests.getDirections( userViewModel.locationOrigin, userViewModel.locationStation).then((value) async {

          if(value == AppConsts.couldNotGetDirection) {
            status = OperationStatus(false, "Unable to get station directions", AppConsts.operationFailed);
          }else{
            if(value != null){
              DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();
              directionDetailsInfo.ePoints = value["routes"][0]["overview_polyline"]["points"];

              directionDetailsInfo.distanceText = value["routes"][0]["legs"][0]["distance"]["text"];
              directionDetailsInfo.distanceValue = value["routes"][0]["legs"][0]["distance"]["value"];

              directionDetailsInfo.durationText = value["routes"][0]["legs"][0]["duration"]["text"];
              directionDetailsInfo.durationValue = value["routes"][0]["legs"][0]["duration"]["value"];

              userViewModel.hasDirectionDetailsInfo = true;
              userViewModel.directionDetailsInfo = directionDetailsInfo;
              notifyListeners();
              status = OperationStatus(true, "", AppConsts.operationSuccess);
            }

          }
        });

      }else {
        // Could not connect to network
        status = OperationStatus(false, AppConsts.noNetworkDetected, AppConsts.operationFailed);
      }
    });
    return status;
  }

  void cancelTrip( BuildContext context, UserViewModel vm){
    //  RESET
    //  UserView model
    vm.locationOrigin = null;
    vm.locationStation = null;
    vm.addressStringOrigin = null;
    vm.addressStation = null;
    vm.startAddressConfirmed = false;
    vm.hasStartAddress = false;
    vm.stationAddressConfirmed = false;
    vm.hasDirectionDetailsInfo = false;
    vm.directionDetailsInfo = null;
    vm.boundLatLng = null;
    vm.markerSet.clear();
    vm.circleSet.clear();

    // HomeViewModel
    addressStringFromLatLng = null;
    _stations = null;
    addressStringFromLatLng = null;
    addressStringToLatLng = null;
    addressStringFromLatLng = null;
    showMapIcon = true;
    polylineSet.clear();

  }


  Future<OperationStatus>drawPolyLinesForTrip( UserViewModel userVM, List<LatLng> pLineCoordinateList,
      Set<Polyline> polylineSet, Completer<GoogleMapController> mapController, bool dark) async{

    // in the homeView display loading dialog, while we process this work
    OperationStatus status = OperationStatus(false, AppConsts.couldNotCompleteOperation, AppConsts.operationFailed);

    await getOriginToDestinationDetails(userVM).then((value) async{
      if(value.success){

        // get value from userVM
        PolylinePoints polylinePoints = PolylinePoints();


        if(userVM.directionDetailsInfo != null){
          if(userVM.directionDetailsInfo!.ePoints != null){
            // Got to figure out a better way to deal with nullability.
            List<PointLatLng> decodePolylinePointsResultList =
              polylinePoints.decodePolyline(userVM.directionDetailsInfo!.ePoints!);

            pLineCoordinateList.clear();
            for (var pointLatLng in decodePolylinePointsResultList) {
              pLineCoordinateList.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
            }

            polylineSet.clear();

            Polyline polyline = Polyline(
                color: dark? Colors.amberAccent : Colors.blue,
                polylineId: const PolylineId("PolylineId"),
                jointType: JointType.round,
                points: pLineCoordinateList,
                startCap: Cap.roundCap,
                endCap: Cap.roundCap,
                geodesic: true,
                width: 5
            );

            userVM.polyline = polyline;
            polylineSet.add(polyline);

            LatLngBounds boundLatLng;
            if(userVM.locationOrigin!.latitude > userVM.locationStation!.latitude &&
            userVM.locationOrigin!.longitude > userVM.locationStation!.longitude){
              boundLatLng = LatLngBounds(southwest: userVM.locationStation!, northeast: userVM.locationOrigin!);
            }else if(userVM.locationOrigin!.longitude > userVM.locationStation!.longitude){
              boundLatLng = LatLngBounds(
                  southwest: LatLng(userVM.locationOrigin!.latitude, userVM.locationStation!.longitude),
                  northeast: LatLng(userVM.locationStation!.latitude, userVM.locationOrigin!.longitude )
              );
            }
            else if(userVM.locationOrigin!.latitude > userVM.locationStation!.latitude ){
              boundLatLng = LatLngBounds(
                  southwest: LatLng(userVM.locationStation!.latitude, userVM.locationOrigin!.longitude),
                  northeast: LatLng(userVM.locationOrigin!.latitude,  userVM.locationStation!.longitude)
              );
            }
            else{
              boundLatLng = LatLngBounds(southwest: userVM.locationOrigin!, northeast: userVM.locationStation!);
            }


            userVM.boundLatLng = boundLatLng;

            Marker originMarker = Marker(
                markerId: const MarkerId("originID"),
                infoWindow: InfoWindow(title: userVM.addressStringOrigin, snippet: "Start location"),
                position: userVM.locationOrigin!,
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
            );

            Marker destinationMarker = Marker(
                markerId: const MarkerId("destinationID"),
                infoWindow: InfoWindow(title: userVM.addressStation, snippet: "Petrol station"),
                position: userVM.locationStation!,
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
            );

            userVM.markerSet.add(originMarker);
            userVM.markerSet.add(destinationMarker);
            showMapIcon = false;

            Circle originCircle = Circle(
                circleId: const CircleId("originId"),
                fillColor: dark ? AppColours.paWhiteColour : AppColours.paBlackColour1,
                radius: 12,
                strokeColor: dark ? AppColours.paWhiteColour : AppColours.paBlackColour1,
                center: userVM.locationOrigin!
            );

            Circle destinationCircle = Circle(
                circleId: const CircleId("destinationId"),
                fillColor: dark ? AppColours.paWhiteColour : AppColours.paBlackColour1,
                radius: 12,
                strokeColor: dark ? AppColours.paWhiteColour : AppColours.paBlackColour1,
                center: userVM.locationStation!
            );

            userVM.circleSet.add(originCircle);
            userVM.circleSet.add(destinationCircle);


            // reset map bounds
            await resetMapBounds(boundLatLng, mapController);

            status = OperationStatus(true, AppConsts.noNetworkDetected, AppConsts.operationFailed);


          }else{
            OperationStatus status = OperationStatus(false, AppConsts.couldNotCompleteOperation, AppConsts.couldNotGetPolyLinePoints);
          }
        }
      }
      else{
        // Failed
        return status;
      }
    });
    return status;

  }

  Widget getMapIcon(bool dark, BuildContext context){

    //  Just return an empty widget if true
    if(Provider.of<HomeViewModel>(context, listen: true).showMapIcon){
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation){
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        },
        child: Provider.of<UserViewModel>(context, listen: true).hasStartAddress ?
        Align(
          alignment: Alignment.center,
          child:   Image(
            height: 36,
            image: AssetImage( dark ? AppConsts.locationPinIconLight : AppConsts.locationPinIconDark),
          ),
        )
            :
        Align(
          alignment: Alignment.center,
          child: Icon(
            Icons.refresh_sharp,
            size: 36,
            color: dark ? AppColours.paWhiteColour : AppColours.blackColour1,
          ),
        ),
      );
    }else{
      return const SizedBox.shrink();
    }
  }

  Future<void> resetMapBounds(LatLngBounds latLngBounds, Completer<GoogleMapController> mapController) async {
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 65));
  }

  //  TODO - remvove if not being used
  /*
  void setLoadingState(bool state) {
    _loadingMap = state;
    notifyListeners();
  }*/

  //  TODO - remvove if not being used
  /*bool getLoadingState() {
    return _loadingMap;
  }*/


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
                  Utils.getGreeting(name),
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


  getUserCurrentLocation(BuildContext context, HomeViewModel homeVM,
      GoogleMapController? mapController) async {
    try {
      // Get the real current position of the user
      Position positionOfUser = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation
      );

      homeVM.setCurrentPosition(positionOfUser);

      // Don't user BuildContext across async gaps.  Guard with the
      // (!mounted) check
      if (!context.mounted) return;
      Provider.of<UserViewModel>(context, listen:  false).locationOrigin  = LatLng(
          homeVM.currentPosition!.latitude, homeVM.currentPosition!.longitude
      );


      // Set the location and animate the camera on google maps to the users current position
      CameraPosition cameraPosition =
      CameraPosition(target: Provider.of<UserViewModel>(context, listen:  false).locationOrigin!, zoom: 15);
      //  _mapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      mapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      //print("This is our address: $humanReadableAddress");
    } catch (err) {
      debugPrint(err.toString());
      // Fix: Don't use context across async gaps.
      if (!context.mounted) return;
      Utils.snackBar(PATextString.checkNetwork, context);
    }
  }


  //  TODO  - update call to controller .setMapStyle - deprecated
  void _setGoogleMapStyle(
      String googleMapStyle, GoogleMapController controller) {
    // TODO setMapStyle deprecated
    controller.setMapStyle(googleMapStyle);
    notifyListeners();
  }

  Future updateMapTheme(GoogleMapController controller, bool isDarkMode) async {
    try {
      //color: dark ? AppColours.paWhiteColour : AppColours.blackColour1.withOpacity(0.85),
      var style = isDarkMode ? MapStyleTheme.night : MapStyleTheme.silver;
      await Helpers.getThemeFile(style).then((value) {
        if (value != null) {
          _setGoogleMapStyle(value, controller);
        }
      });
    } catch (err) {
      debugPrint('Error in home_vm.dart, line: 26: ${err.toString()}');
    }
  }
}

Container doModalBottomSheet(BuildContext context, bool dark,
    HomeViewModel homeViewModel, TextEditingController tripStartTextEditingController,
    TextEditingController tripEndTextEditingController) {
  return Container(
    height: (Utils.getScreenHeight(context)),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
    child: SafeArea(
      top: false,
      child: Column(
        children: <Widget>[
          //Text(PATextString.selectStation, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: PAAppStylesConstants.spaceBetweenItems,),
          Divider(height:  PAAppStylesConstants.spaceBetweenSections, color: dark? AppColours.paWhiteColour : AppColours.paBlackColour1,),
          const SizedBox(height: PAAppStylesConstants.spaceBetweenItems,),
          Row(
            children: [
              Column(
                children: [
                  Container(
                    height: 8.0,
                    width: 8.0,
                    margin: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      color: dark ? AppColours.paWhiteColour : AppColours.paBlackColour2,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    height: 40.0,
                    width: 8.0,
                    decoration: const BoxDecoration(
                      color: AppColours.paPrimaryColour,
                    ),
                  ),
                  Container(
                    height: 8.0,
                    width: 8.0,
                    margin: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      color: dark ? AppColours.paWhiteColour : AppColours.paBlackColour2,
                    ),
                  )
                ],
              ),
              Expanded(
                  child: Column(
                    children: [
                      TextFormField(
                        readOnly: true,
                        controller: tripStartTextEditingController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          isDense: true,
                          prefixIcon: Icon(Icons.search_sharp),
                        ),
                      ),
                      TextFormField(
                        controller: tripEndTextEditingController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          isDense: true,
                          hintText: PATextString.whichStation,
                          prefixIcon: Icon(Icons.search_sharp),
                        ),
                        //  onChange not needed
                        //onChanged: ,
                      )
                    ],
                  )
              ),
            ],
          ),
          const SizedBox(height: PAAppStylesConstants.spaceBetweenSections,),

          Expanded(
              child:           // search shimmer while loading
              homeViewModel.searchStationsLoading ? buildSearchShimmer() :
              ListView.builder(
                  itemCount:  homeViewModel._stations?.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index){
                    //  TODO Make sure that the stations list is not null
                    //  TODO Handle empty list
                    final station = homeViewModel._stations?.toList()[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4, top: 8, right: 4, bottom: 8),
                        child: ListTile(
                          leading: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 4,
                                color: dark ? AppColours.paAccentDust.withOpacity(0.67) : AppColours.paPrimaryColour.withOpacity(0.67),
                              ),
                              // Add Some Shadow
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: dark? AppColours.paWhiteColour.withOpacity(0.18) : AppColours.blackColour1.withOpacity(0.15),
                                  offset: const Offset(-3, 9),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(8.0),
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(Utils.getPetrolStationLogoPrefix(station!.logo)),
                              ),
                            ),
                          ),
                          title: Text(
                            Utils.truncateText(station.stationName, 28),
                            style:  Theme.of(context).textTheme.headlineSmall,
                          ),
                          subtitle: Row(
                            children: [
                              //  Expands the child of a Row, Column, or Flex so that the child
                              //  fills the available space

                              getStationStatusIcon(station.stationOnline, 30),
                              const SizedBox( width: PAAppStylesConstants.spaceBetweenItems,),
                              Text(
                                Utils.getDistanceAwayText(station.distance, station.siUnit,),
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                            ],
                          ),
                          trailing: GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StationView(station: station),
                                ),);
                            },
                            child: CircleAvatar(
                              backgroundColor: dark? AppColours.paWhiteColour.withOpacity(0.18) : AppColours.blackColour1.withOpacity(0.15),
                              child: const Icon(Icons.more_horiz_sharp, size: 40.0,),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
              ),
          ),



          // listview with results
          const SizedBox(height: PAAppStylesConstants.spaceBetweenItems,),
          SizedBox(
            width: Utils.getScreenWidth(context),
            child: ElevatedButton(onPressed: (){}, child: Text( PATextString.forgotPassword,
                style: Theme.of(context).textTheme.bodySmall, )
            ),
          ),
          const SizedBox(height: PAAppStylesConstants.spaceBetweenSections,),
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

  showBottomSheet(BuildContext context, bool dark, HomeViewModel homeViewModel,
      TextEditingController tripStartTextEditingController,
      TextEditingController tripEndTextEditingController){
    showModalBottomSheet<void>(

        context: context,
        builder: (BuildContext context) {
          return doModalBottomSheet(context, dark, homeViewModel, tripStartTextEditingController,
          tripEndTextEditingController);
        });
  }

  Widget buildCurrentLocationIcon(BuildContext context, bool dark, TextEditingController tripStartTextEditingController,  TextEditingController tripEndTextEditingController) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8, right: 8),
        child: GestureDetector(
          onTap: (){
            //https://api.flutter.dev/flutter/material/showModalBottomSheet.html
            showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return DraggableScrollableSheet(
                    expand: false,
                    initialChildSize: 0.85,
                    maxChildSize: 0.85,
                    minChildSize: 0.25,
                      builder: (context, scrollController) => doModalBottomSheet(context, dark, Provider.of<HomeViewModel>(context),
                      tripStartTextEditingController, tripEndTextEditingController),
                  );
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

Widget buildSearchShimmer(){
  return Card(
    child: Padding(
      padding: const EdgeInsets.only(left: 4, top: 8, right: 4, bottom: 8),
      child: ListTile(
        leading: ShimmerWidget.circular(
          width: 64,
          height: 64,
          shapeBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
          ),
        ),
        title: const ShimmerWidget.rectangular(height:12),
        subtitle: const ShimmerWidget.rectangular(height: 8, width: 104.0 )/* 55% of screen width */,
        trailing: const ShimmerWidget.circular(width: 40, height: 40),
      ),
    ),
  );
}

  Icon getStationStatusIcon(bool online, double size){
    return online ? Icon(Icons.check_circle_outline_sharp, color: AppColours.paPrimaryColour, size: size,):
        Icon(Icons.error_outline_sharp, color: AppColours.paErrorColour, size: size,);
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
