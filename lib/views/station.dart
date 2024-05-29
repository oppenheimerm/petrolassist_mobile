import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';


import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:petrol_assist_mobile/models/station.dart';
import 'package:petrol_assist_mobile/resources/colours.dart';
import 'package:petrol_assist_mobile/resources/styles_constants.dart';
import 'package:petrol_assist_mobile/view_models/home_vm.dart';
import 'package:petrol_assist_mobile/view_models/station_vm.dart';
import 'package:petrol_assist_mobile/views/home_view.dart';
import 'package:provider/provider.dart';

import '../resources/text_string.dart';
import '../utilities/utils.dart';
import '../view_models/user_vm.dart';


class StationView extends StatefulWidget {
  const StationView({
    super.key,
    required this.station,
  });

  final StationModel station;

  @override
  State<StationView> createState() => _StationViewState();
}

class _StationViewState extends State<StationView> {

  final StationViewModel _stationViewModel = StationViewModel();
  final HomeViewModel _homeViewModel = HomeViewModel();

  final Completer<GoogleMapController> _googleMapCompleterController = Completer<GoogleMapController>();
  GoogleMapController? _mapController;

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final dark = Utils.isDarkMode(context);
    //final userVM = Provider.of<UserViewModel>(context, listen: true);

    return SafeArea(
      child: Scaffold(
          body: ChangeNotifierProvider<StationViewModel>(
            //create: (BuildContext context) => _homeViewModel,
            create: (BuildContext context) => _stationViewModel,
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Image.network(Utils.getPetrolStationCoverPhoto(widget.station.logo)),
                ),
                buttonArrow(context),
                scroll(dark),
              ],
            ),
          ),
      ),
    );
  }

  buttonArrow(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: (){
          Navigator.pop(context);
        },
        child: Container(
          height: 48,
          width:48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24)
              ),
              child: const Icon(
                Icons.arrow_back_sharp,
                size: 24,
                color: AppColours.blackColour1,
                weight: 800,
              ),
            ),
          ),
          ),
      ),
    );
  }

  scroll(bool dark){
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
        maxChildSize: 1.0,
        minChildSize: 0.6,
        builder: (context, scrollController
        ){
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: dark ? AppColours.paBlackColour1 : AppColours.paAccentDust,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0)
          )
        ),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 4,
                      width: 34,
                      color: AppColours.paBlackColour1,
                    ),
                  ],
                ),
              ),
              Text(widget.station.stationName, style:  Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: PAAppStylesConstants.spaceBetweenItems),
              Text("${widget.station.stationAddress} ${widget.station.stationPostcode}", style:  Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: PAAppStylesConstants.spaceBetweenItems),
              Row(
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Icon(
                        Icons.map_outlined,
                        color: AppColours.paWhiteColour,
                        size: 50,
                      ),
                      const SizedBox( width: PAAppStylesConstants.spaceBetweenItems,),
                      Text(
                        Utils.getDistanceAwayText(widget.station.distance, widget.station.siUnit,),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox( width: PAAppStylesConstants.spaceBetweenItems,),
                  const Spacer(),
                  const Icon( Icons.rate_review_outlined, size: 50,),
                  const SizedBox( width: PAAppStylesConstants.spaceBetweenItems,),
                  Text(
                    " 4.5 / 4",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox( width: PAAppStylesConstants.spaceBetweenItems,),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(
                      height: 4,
                      color: AppColours.paWhiteColour,
                    ),
                  ),
                  const SizedBox( width: PAAppStylesConstants.spaceBetweenItems,),
                ],
              ),
              const SizedBox(height: PAAppStylesConstants.spaceBetweenItems),
              // Map
              Container(
                //color: AppColours.paAccentDust,
                decoration: BoxDecoration(
                  color: AppColours.blackColour2,
                  borderRadius: BorderRadius.circular(12.0)
                ),

                padding: const EdgeInsets.all(4.0),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 300,
                        width: Utils.getScreenWidth(context) * 0.85,
                        child: getGoogleMap( dark, widget.station, widget.station.latitude, widget.station.longitude, _homeViewModel),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: PAAppStylesConstants.spaceBetweenItems),
              Text(PATextString.stationDetails, style:  Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: PAAppStylesConstants.spaceBetweenItems),

              Row(
                children: [

                  // Assistance available
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Image(
                      image: dark ? const AssetImage('assets/images/icons/pump-assistance-icon-light.png',) : const AssetImage('assets/images/icons/pump-assistance-icon-dark.png',),
                    ),
                  ),

                  const SizedBox( width: PAAppStylesConstants.spaceBetweenItems,),
                  Text(
                    widget.station.stationOnline ? "YES" : "NO",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),

                  const Spacer(),
                  //   Pay by app
                  const Icon( Icons.smartphone_outlined, size: 50,),
                  const SizedBox( width: PAAppStylesConstants.spaceBetweenItems,),
                  Text(
                    widget.station.payByApp ? "YES" : "NO",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),

                ],
              ),
              const SizedBox(height: PAAppStylesConstants.spaceBetweenItems),
              Row(
                children: [
                  // Pay at pump
                  const Icon( Icons.local_gas_station_outlined, size: 50,),
                  const SizedBox( width: PAAppStylesConstants.spaceBetweenItems,),
                  Text(
                    widget.station.payAtPump ? "YES" : "NO",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const Spacer(),

                  // Accessible Toilets nearby
                  const Icon(Icons.info_outline, size: 50,),
                  const SizedBox( width: PAAppStylesConstants.spaceBetweenItems,),
                  Text(
                    widget.station.accessibleToiletNearby ? "YES" : "NO",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              const SizedBox( height:  PAAppStylesConstants.spaceBetweenSections),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        child: const Text(PATextString.confirmStationSelection),
                        onPressed: (){
                          Provider.of<UserViewModel>(context, listen: false).stationAddressConfirmed = true;
                          var coordinates = setStationGeoCoordinates(widget.station.latitude, widget.station.longitude);
                          Provider.of<UserViewModel>(context, listen: false).locationStation = coordinates;
                          Provider.of<UserViewModel>(context, listen: false).addressStation = "${widget.station.stationName} ${widget.station.stationAddress} ${widget.station.stationPostcode}";
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeView(),
                            ),);
                        }),
                  ),
                ],
              ),

            ],
          ),
        ),
      );
    });
  }

  getStationLocation(double lat, double lngt) async {
    try {

      var thisStationLatLng = LatLng(
          lat, lngt
      );


      // Set the location and animate the camera on google maps to the users current position
      CameraPosition cameraPosition =
      CameraPosition(target: thisStationLatLng, zoom: 15);
      _mapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));


      //print("This is our address: $humanReadableAddress");
    } catch (err) {
      debugPrint(err.toString());
      // Fix: Don't use context across async gaps.
      if (!context.mounted) return;
      Utils.snackBar(PATextString.checkNetwork, context);
    }
  }

  LatLng setStationGeoCoordinates(double lat, double long){
    return LatLng(
        lat,long
    );
  }

  GoogleMap getGoogleMap(bool darkMode, StationModel station, double lat, double longt, HomeViewModel homeViewModel){
    return GoogleMap(
      mapType: MapType.normal,
      myLocationButtonEnabled: true,
      // Hide map controls
      zoomControlsEnabled: false,
      scrollGesturesEnabled: false,
      tiltGesturesEnabled: false,
      rotateGesturesEnabled: false,
      zoomGesturesEnabled: false,
      // for testing on emulator we'll use our keyGarden var
      initialCameraPosition: CameraPosition(
        target: LatLng(lat, longt),
        zoom: 15.0,
      ),
      markers: {
        Marker(
          markerId: MarkerId(station.stationAddress),
          position: LatLng(station.latitude, station.longitude)
      )},
      onMapCreated: (GoogleMapController googleMapController) async {
        _mapController = googleMapController;
        await homeViewModel.updateMapTheme(googleMapController, darkMode);
        _googleMapCompleterController.complete(_mapController);
        //locateUserPosition
        getStationLocation(lat, longt);
      },
    );
  }
}
