import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:petrol_assist_mobile/view_models/user_vm.dart';
import 'package:provider/provider.dart';

import '../helpers.dart';
import '../resources/colours.dart';
import '../utilities/utils.dart';
import '../view_models/home_vm.dart';
import 'edit_profile.dart';



class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  @override
  void initState() {
    super.initState();
    //getGoogleMap();
  }

  final Completer<GoogleMapController> _googleMapCompleterController = Completer<GoogleMapController>();
  GoogleMapController? _mapController;
  // The current position of the user.
  Position? _currentPositionOfUser;

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

  getUserCurrentLocation() async{
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
  }

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
      
                getGoogleMap(value, dark),

                value.buildProfileTile(context, _homeViewModel.getUser!.firstName, userVM.getCarPhotoUrl()),
                value.buildTextField(context),
                value.buildCurrentLocationIcon(),
                value.buildBottomSheets(context,  dark),
                //https://www.youtube.com/watch?v=NgTk1oh_N5g&list=PLWNYjcx_ZHPco3yijOw-KwBQwjjcHc5Rj&index=11


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

  getGoogleMap(HomeViewModel homeVm, bool dark){
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
          onMapCreated: (GoogleMapController googleMapController) async {
            _mapController = googleMapController;


            //  Not updating
            //_homeViewModel.updateMapTheme(googleMapController);
            //color: dark ? AppColours.paWhiteColour : AppColours.blackColour1.withOpacity(0.85),
            //_homeViewModel.mapStyle = MapStyleTheme.silver;
            await _homeViewModel.updateMapTheme(googleMapController, dark);
            //_homeViewModel.mapStyleTheme = dark ? _homeViewModel.mapStyleTheme.silver : _homeViewModel.mapStyleTheme.
            _googleMapCompleterController.complete(_mapController);
            getUserCurrentLocation();
          }
      )
    );
  }
}

