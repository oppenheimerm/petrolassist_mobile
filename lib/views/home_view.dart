import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../helpers.dart';
import '../resources/colours.dart';
import '../view_models/home_vm.dart';
import 'edit_profile.dart';



class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  /*@override
  void initState() {
    super.initState();
    getGoogleMap();
  }*/

  final Completer<GoogleMapController> _googleMapCompleterController = Completer<GoogleMapController>();
  GoogleMapController? _mapController;
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
      Position positionOfUser = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
      _currentPositionOfUser = positionOfUser;
      LatLng latLngPositionOfUser = LatLng(_currentPositionOfUser!.latitude, _currentPositionOfUser!.longitude);
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


    return Scaffold(
      appBar: homeAppBar(false),
      body: ChangeNotifierProvider<HomeViewModel>(
        create: (BuildContext context) => _homeViewModel,
        child:Consumer<HomeViewModel>(builder: (context, value, _){
          // we can now use "value", a variable of homeViewModel
          //  i.e value.setGoogleMapStyle()
          return getGoogleMap();
        }),
      ),
    );
  }

  AppBar homeAppBar([bool? showBackButton]) {
    return AppBar(
      title: const Text("PetrolSist"),
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
  }

  getGoogleMap(){
    return  GoogleMap(
      mapType: MapType.normal,
      myLocationButtonEnabled: true,
      initialCameraPosition: _keyGardens,
      onMapCreated: (GoogleMapController googleMapController){
        _mapController = googleMapController;

        //  Not updating
        _homeViewModel.updateMapTheme(googleMapController);
        _googleMapCompleterController.complete(_mapController);
        getUserCurrentLocation();
      }
    );
  }
}

