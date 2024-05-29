import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:petrol_assist_mobile/view_models/search_station_vm.dart';
import 'package:provider/provider.dart';

import '../resources/colours.dart';
import '../resources/styles_constants.dart';
import '../resources/text_string.dart';
import '../view_models/user_vm.dart';
import '../views/search_stations_view.dart';

class TripSelectorWidget extends StatelessWidget {
  const TripSelectorWidget({
    super.key,
    required this.dark,
    required this.searchStationsViewModel,
    required this.searchController,
    required this.mapController
  });

  final bool dark;
  final SearchStationsViewModel searchStationsViewModel;
  final TextEditingController searchController;
  final GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: dark ? AppColours.paPrimaryColourActive.withOpacity(0.85) : AppColours.paAccentDust.withOpacity(0.85),
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: dark
                        ? AppColours.paWhiteColour.withOpacity(0.35)
                        : AppColours.blackColour1.withOpacity(0.35),
                    spreadRadius: 4,
                    blurRadius: 10,
                  ),
                ]
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: dark ? AppColours.blackColour1 : Colors.white.withOpacity(0.65),
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
                  child: SafeArea(
                    top: false,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top:8.0, bottom: 12.0, left: 8.0),
                          child: Column(
                            children: [
                              Text(PATextString.selectCurrentLocation, style: Theme.of(context).textTheme.headlineMedium),
                              const SizedBox(height: PAAppStylesConstants.spaceBetweenItems,),
                              Text(PATextString.dragMapToMovePin, style: Theme.of(context).textTheme.headlineSmall),
                              const Divider( height: 32.0,),
                              //searchInput(dark),
                              TextFormField(
                                controller: searchController,
                                keyboardType: TextInputType.streetAddress,
                                decoration: InputDecoration(
                                  hintText: "Search",
                                  prefixIcon: Container(
                                    margin: const EdgeInsets.all(16.0),
                                    color: dark? AppColours.paWhiteColour : AppColours.blackColour1,
                                    child: Icon(
                                      Icons.square_sharp,
                                      size: 10,
                                      color: dark? AppColours.paPrimaryColour : AppColours.paAccentDust,
                                    ),
                                  ),
                                  suffix: const Icon( Icons.search_sharp),
                                ),
                              ),
                              const SizedBox(height: PAAppStylesConstants.spaceBetweenItems,),
                              ElevatedButton(
                                // use full width
                                  style: FilledButton.styleFrom(
                                      minimumSize: const Size.fromHeight(48.0)
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8 ),
                                    child: Text(PATextString.confirmLocation),
                                  ),

                                  onPressed: () {
                                    //
                                    Provider.of<UserViewModel>(context, listen: false).startAddressConfirmed = true;
                                    searchStationsViewModel.getNearestStations(
                                        Provider.of<UserViewModel>(context, listen: false).locationOrigin!.latitude,
                                        Provider.of<UserViewModel>(context, listen: false).locationOrigin!.longitude,
                                        0
                                    );
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => SearchStationsView(
                                            latitude: Provider.of<UserViewModel>(context, listen: false).locationOrigin!.latitude,
                                            longitude: Provider.of<UserViewModel>(context, listen: false).locationOrigin!.longitude,
                                            distanceUnit: 0,
                                        ),
                                      ),
                                    );
                                  }
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );;
  }
}
