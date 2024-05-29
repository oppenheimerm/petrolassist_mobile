import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:petrol_assist_mobile/view_models/search_station_vm.dart';
import 'package:petrol_assist_mobile/view_models/user_vm.dart';
import 'package:provider/provider.dart';

import '../app_constants.dart';
import '../components/trip_confirmation_widget.dart';
import '../components/trip_selector_widget.dart';
import '../resources/colours.dart';
import '../resources/text_string.dart';
import '../utilities/utils.dart';
import '../view_models/home_vm.dart';



class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  late final TextEditingController tripStartTextEditingController = TextEditingController();
  late final TextEditingController tripEndTextEditingController = TextEditingController();
  final Completer<GoogleMapController> _googleMapCompleterController = Completer<GoogleMapController>();
  final TextEditingController _searchController = TextEditingController();
  final HomeViewModel _homeViewModel = HomeViewModel( );
  final SearchStationsViewModel _searchStationsViewModel = SearchStationsViewModel();

  GoogleMapController? _mapController;
  // The current position of the user.
  // Position? _currentPositionOfUser;


  List<LatLng> pLineCoordinateList = [];

  //  TODO - remove in view model
  //Set<Polyline> polylineSet = {};
  // TODO - remove below, now set in user view model.
  //Set<Marker> markerSet = {};
  // TODO - remove below, now set in user view model.
  //Set<Circle> circleSet = {};

  bool openNavigationDrawer = true;

  //  TODO - remove if not being used
  //BitmapDescriptor? activeNearbyIcon;


  //  Testing, just use this location as initial
  //Kew Gardens / TW9 3JR (51.4777125 , -0.2882984)
  static const CameraPosition _keyGardens = CameraPosition(
    target: LatLng(51.4777125, -0.2882984),
    zoom: 15.0,
  );


  @override
  void dispose() {
    _mapController!.dispose();
    _searchController.dispose();
    tripStartTextEditingController.dispose();
    tripEndTextEditingController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final dark = Utils.isDarkMode(context);


    return SafeArea(
      child: Scaffold(
        // No appbar here
        /*appBar: homeAppBar(false),*/
        body: ChangeNotifierProvider<HomeViewModel>(
          create: (BuildContext context) => _homeViewModel,
          child:Consumer<HomeViewModel>(builder: (context, value, _){
            // we can now use "value", a variable of homeViewModel
            //  i.e value.setGoogleMapStyle()

            //  Set search controller text
            _searchController.text = value.addressStringFromLatLng != null ? value.addressStringFromLatLng! : PATextString.acquiringLocation;
            return Stack(
              children: [

                getGoogleMap( dark),
                value.buildProfileTile(context, _homeViewModel.getUser!.firstName, Provider.of<UserViewModel>(context, listen:  false).getCarPhotoUrl()),
                //value.buildTextField(context),
                buildCurrentLocationIcon(context, dark, tripStartTextEditingController,
                    tripEndTextEditingController),

                //  TODO - preform a null check on _mapController first, empty, return
                // empty widget
                getTripSelectionWidgets(Provider.of<UserViewModel>(context, listen: false), dark),


                // map icon switcher
                /*AnimatedSwitcher(
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
                ),*/
                Provider.of<HomeViewModel>(context, listen: false).getMapIcon(dark, context),

              ],
            );
          }),
        ),
      ),
    );


  }


  Future<void> resetMapBounds(LatLngBounds latLngBounds, GoogleMapController mapController) async {
    //final GoogleMapController controller = await _googleMapCompleterController!.future;
    mapController.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 65));
  }

  Widget getTripSelectionWidgets(UserViewModel userViewModel, bool dark)  {


    if(userViewModel.hasDirectionDetailsInfo == true && userViewModel.directionDetailsInfo != null)
      {
        //  TODO - Begin Trip widget here
        //  We no longer need the the TripConfirmationWidget or TripSelectorWidget widgets
        //  show an empty widget
        return TripConfirmationWidget(
          dark: dark, stationAddress: Provider.of<UserViewModel>(context).addressStation!,
          startAddress: Provider.of<UserViewModel>(context).addressStringOrigin!,
          pLineCoordinateList: pLineCoordinateList,
          polylineSet: _homeViewModel.polylineSet,
          mapController: _googleMapCompleterController,

        );
      }
    else{

      // reset the map
      //_homeViewModel.getUserCurrentLocation(context, _homeViewModel, _mapController);
      return Provider.of<UserViewModel>(context, listen: false).stationAddressConfirmed ?
      TripConfirmationWidget(
        dark: dark, stationAddress: Provider.of<UserViewModel>(context).addressStation!,
        startAddress: Provider.of<UserViewModel>(context).addressStringOrigin!,
        pLineCoordinateList: pLineCoordinateList,
        polylineSet: _homeViewModel.polylineSet,
        mapController: _googleMapCompleterController,

      ) :

      TripSelectorWidget(
          dark: dark,
          searchStationsViewModel: _searchStationsViewModel,
          searchController: _searchController,
          mapController: _mapController,
      );
    }

  }


  //  TODO- remove, now in view model
  /*getUserCurrentLocation() async {
    try {
      // Get the real current position of the user
      Position positionOfUser = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation
      );
      _homeViewModel.setCurrentPosition(positionOfUser);

      // Don't user BuildContext across async gaps.  Guard with the
      // (!mounted) check
      if (!mounted) return;
      Provider.of<UserViewModel>(context, listen:  false).locationOrigin  = LatLng(
         _homeViewModel.currentPosition!.latitude, _homeViewModel.currentPosition!.longitude
      );


      // Set the location and animate the camera on google maps to the users current position
      CameraPosition cameraPosition =
      CameraPosition(target: Provider.of<UserViewModel>(context, listen:  false).locationOrigin!, zoom: 15);
      //  _mapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      _mapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      //print("This is our address: $humanReadableAddress");
    } catch (err) {
      debugPrint(err.toString());
      // Fix: Don't use context across async gaps.
      if (!context.mounted) return;
      Utils.snackBar(PATextString.checkNetwork, context);
    }
  }*/

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
          polylines: _homeViewModel.polylineSet,
          markers: Provider.of<UserViewModel>(context).markerSet,
          circles: Provider.of<UserViewModel>(context).circleSet,
          onMapCreated: (GoogleMapController googleMapController) async {
            _mapController = googleMapController;
            //  Error with provider here
            await Provider.of<HomeViewModel>(context, listen: false).updateMapTheme(googleMapController, dark);

            // TODO - NOT SURE IF I NEED THIS??
            //_googleMapCompleterController.complete(_mapController);

            //  DON'T use BuildContext across asynchronous gaps.
            if (!context.mounted) return;
            await Provider.of<HomeViewModel>(context, listen: false).getUserCurrentLocation(
              context,
                Provider.of<HomeViewModel>(context, listen: false),
              _mapController
            );
          },

        //  TODO
        //onCameraMoveStarted: _homeViewModel.updateCurrentLocationSet(false),

          onCameraMove: (CameraPosition? position){

            // If we're returning to this screen from the Station details, where
            // we have already selected the station:
            //Provider.of<UserViewModel>(context, listen: false).stationAddressConfirmed == true
            // ignore camera moves
            if(Provider.of<UserViewModel>(context, listen: false).stationAddressConfirmed == true){
              return;
            }else{
              if( Provider.of<UserViewModel>(context, listen: false).locationOrigin != position?.target){
                // set it to this new target

                // TODO
                // reset location
                Provider.of<UserViewModel>(context, listen: false).locationOrigin = position?.target;
                // set by user on button click event
                Provider.of<UserViewModel>(context, listen: false).startAddressConfirmed = false;
                Provider.of<UserViewModel>(context, listen: false).hasStartAddress = false;
              };
            }

          },

        // TODO
        onCameraIdle: () async {
            // here we get address from lat/long

          // If we're returning to this screen from the Station details, where
          // Where we have already selected the station:
          //Provider.of<UserViewModel>(context, listen: false).stationAddressConfirmed == true
          // return
          if(Provider.of<UserViewModel>(context, listen: false).stationAddressConfirmed == true){
            return;
          }else{
            await _homeViewModel.getHumanReadableAddressFromLatLng(Provider.of<UserViewModel>(context, listen: false));
          }

        },
      ),

    );
  }

  Visibility currentLatLongLocation(HomeViewModel vm){
    return Visibility(
      visible: Provider.of<UserViewModel>(context, listen:  false).startAddressConfirmed == true,
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

