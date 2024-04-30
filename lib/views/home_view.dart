import 'dart:async';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:petrol_assist_mobile/view_models/user_vm.dart';
import 'package:provider/provider.dart';

import '../app_constants.dart';
import '../helpers.dart';
import '../resources/colours.dart';
import '../resources/styles_constants.dart';
import '../resources/text_string.dart';
import '../utilities/utils.dart';
import '../view_models/home_vm.dart';
import 'edit_profile.dart';



class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  //final _globalKey = GlobalKey();
  //bool get isMounted => _globalKey.currentState != null && _globalKey.currentState!.mounted;

  //  This package contains functions to decode google encoded polyline string
  //  which returns a list of co-ordinates indicating route between two
  //  geographical position
  //
  //  Set<E> class - https://api.flutter.dev/flutter/dart-core/Set-class.html
  Set<Polyline> polylineSet = {};
  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};

  bool openNavigationDrawer = true;

//  We'll substitute with active nearby stations
  bool activeNearbyDriverKeysLoaded = false;


  BitmapDescriptor? activeNearbyIcon;

  @override
  void initState() {
    super.initState();
    //getGoogleMap();
  }

  final Completer<GoogleMapController> _googleMapCompleterController = Completer<GoogleMapController>();
  GoogleMapController? _mapController;
  // The current position of the user.
 // Position? _currentPositionOfUser;

  final HomeViewModel _homeViewModel = HomeViewModel(
      MapStyleTheme.silver
  );

  //late final UserModel? _userModel;

  //  Testing, just use this location as initial
  //Kew Gardens / TW9 3JR (51.4777125 , -0.2882984)
  static const CameraPosition _keyGardens = CameraPosition(
    target: LatLng(51.4777125, -0.2882984),
    zoom: 15.0,
  );


  /*@override
  void initState() async {
    super.initState();
    _userModel = await UserViewModel().getCurrentUser();
  }*/

  /*getUserCurrentLocation() async{
    try{
      // Get the real current position of the user
      Position positionOfUser = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
      _currentPositionOfUser = positionOfUser;
      // Convert to lat/long type
      LatLng latLngPositionOfUser = LatLng(_currentPositionOfUser!.latitude, _currentPositionOfUser!.longitude);
      // Set the location and animate the camera on google maps to the users current position
      CameraPosition cameraPosition = CameraPosition(target: latLngPositionOfUser, zoom: 15);
      _mapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    }catch(err){
      debugPrint(err.toString());
    }
  }*/

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final dark = Utils.isDarkMode(context);
    final userVM = Provider.of<UserViewModel>(context, listen: true);

    return SafeArea(
      child: Scaffold(
        // No appbar here
        /*appBar: homeAppBar(false),*/
        body: ChangeNotifierProvider<HomeViewModel>(
          create: (BuildContext context) => _homeViewModel,
          child:Consumer<HomeViewModel>(builder: (context, value, _){
            // we can now use "value", a variable of homeViewModel
            //  i.e value.setGoogleMapStyle()
            return Stack(
              children: [
      
                getGoogleMap( dark),

                value.buildProfileTile(context, _homeViewModel.getUser!.firstName, userVM.getCarPhotoUrl()),
                //value.buildTextField(context),
                value.buildCurrentLocationIcon(context),
                value.buildBottomSheets(context,  dark),
                //https://www.youtube.com/watch?v=NgTk1oh_N5g&list=PLWNYjcx_ZHPco3yijOw-KwBQwjjcHc5Rj&index=11
                Align(
                  alignment: Alignment.center,
                  child:   Image(
                    height: 40,
                    image: AssetImage( dark ? AppConsts.locationPinIconLight : AppConsts.locationPinIconDark),
                  ),
                ),

                // SHOW / HIDE
                // WORKS 29/04/2024
                //currentLatLongLocation(value),
                 // UI for searching location
                Positioned(
                    top: 120,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColours.paPrimaryColourActive.withOpacity(0.85),
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: dark
                                      ? AppColours.paWhiteColour.withOpacity(0.48)
                                      : AppColours.blackColour1.withOpacity(0.45),
                                  spreadRadius: 4,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColours.blackColour1,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top:8.0, bottom: 8.0, left: 8.0),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.location_on_sharp, color: AppColours.paWhiteColour,),
                                            const SizedBox(width: PAAppStylesConstants.sm,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(PATextString.from, style: Theme.of(context).textTheme.headlineMedium),
                                                //Text(("${value.addressStringToLatLng != null ? value.addressStringToLatLng?.substring(0, 28) : "Click for stations" }  "), style: Theme.of(context).textTheme.headlineSmall),
                                                Text(("${value.addressStringFromLatLng != null ? value.addressStringFromLatLng?.substring(0, 28) : PATextString.acquiringLocation }  "), style: Theme.of(context).textTheme.headlineSmall),
                                                //Text(("${value.addressStringFromLatLng?.substring(0, 28)}..." ?? ""), style: Theme.of(context).textTheme.headlineSmall),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: PAAppStylesConstants.spaceBetweenItems,),

                                      Divider(
                                        height: 1,
                                        thickness: 2,
                                        color: AppColours.paPrimaryColourActive.withOpacity(0.85),
                                      ),

                                      const SizedBox(height: PAAppStylesConstants.spaceBetweenItems),

                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 12.0, left: 8.0),
                                        child: GestureDetector(
                                          onTap: (){},
                                          child: Row(
                                            children: [
                                              const Icon(Icons.location_on_sharp, color: AppColours.paWhiteColour,),
                                              const SizedBox(width: PAAppStylesConstants.sm,),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(PATextString.from, style: Theme.of(context).textTheme.headlineMedium),
                                                  //Text(("${value.addressStringFromLatLng?.substring(0, 28)}..." ?? ""), style: Theme.of(context).textTheme.headlineSmall),
                                                  Text(("${value.addressStringToLatLng != null ? value.addressStringToLatLng?.substring(0, 28) : PATextString.clickForStations }  "), style: Theme.of(context).textTheme.headlineSmall),
                                                ],


                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ),

              ],
            );
          }),
        ),
      ),
    );
  }

  /*AppBar homeAppBar([bool? showBackButton]) {
    return AppBar(
      title: const Text("PetrolAssist"),
      centerTitle: true,
      automaticallyImplyLeading: false,
      backgroundColor: AppColours.transparentColour,
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () =>{
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EditProfileView()),
            )
        },
          icon: const Icon(Icons.settings_sharp),),
        IconButton(
            onPressed: () {
              _homeViewModel.logout(context);
            },
            icon: const Icon(Icons.logout_sharp))
      ],
    );
  }*/

  getUserCurrentLocation() async {
    try {
      // Get the real current position of the user
      Position positionOfUser = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation
      );
      _homeViewModel.setCurrentPosition(positionOfUser);

      _homeViewModel.locationOrigin = LatLng(
         _homeViewModel.currentPosition!.latitude, _homeViewModel.currentPosition!.longitude
      );


      // Set the location and animate the camera on google maps to the users current position
      CameraPosition cameraPosition =
      CameraPosition(target: _homeViewModel.locationOrigin!, zoom: 15);
      _mapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));


      //print("This is our address: $humanReadableAddress");
    } catch (err) {
      debugPrint(err.toString());
      if (!context.mounted) return;
      Utils.snackBar(PATextString.checkNetwork, context);
    }
  }

  getGoogleMap(bool dark) {
    return  Positioned(
      top: 120,
      left: 0,
      right: 0,
      bottom: 0,
      child: GoogleMap(
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          // Hide map controls
          zoomControlsEnabled: false,
          // for testing on emulator we'll use our keyGarden var
          initialCameraPosition: _keyGardens,
          polylines: polylineSet,
          markers: markerSet,
          circles: circleSet,
          onMapCreated: (GoogleMapController googleMapController) async {
            _mapController = googleMapController;
            await _homeViewModel.updateMapTheme(googleMapController, dark);
            _googleMapCompleterController.complete(_mapController);
            //locateUserPosition
            getUserCurrentLocation();
          },

          // TODO
        // Causes endless loop
          onCameraMove: (CameraPosition? position){
            if( _homeViewModel.locationOrigin != position?.target){
              // set it to this new target

              // TODO
              // reset location
             _homeViewModel.locationOrigin = position?.target;
             _homeViewModel.currentLocationSet = false;
            };
          },

        // TODO
        onCameraIdle: () async {
            // here we get address from lat/long
          await _homeViewModel.getHumanReadableAddressFromLatLng();
        },
      ),

    );
  }

  Visibility currentLatLongLocation(HomeViewModel vm){
    return Visibility(
      visible: vm.currentLocationSet == true,
      child: Positioned(
        top: 140,
        right: 20,
        left: 20,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColours.paBlackColour2.withOpacity(0.2)),
            color: AppColours.paPrimaryColour.withOpacity(0.85),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(20),
          //Text(PATextString.loginTitle, style: Theme.of(context).textTheme.headlineSmall),
          child: Center(
            child: Text(vm.addressStringFromLatLng ?? "",
              style: const TextStyle(
                  fontSize: 16, color: AppColours.blackColour1, fontWeight: FontWeight.w600
              ),
              overflow: TextOverflow.visible, softWrap: true,),
          ),
        ),
      ),
    );
  }
}

