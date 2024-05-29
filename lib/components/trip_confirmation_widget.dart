import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:petrol_assist_mobile/utilities/utils.dart';
import 'package:petrol_assist_mobile/view_models/home_vm.dart';
import 'package:petrol_assist_mobile/views/home_view.dart';
import 'package:provider/provider.dart';

import '../resources/colours.dart';
import '../resources/styles_constants.dart';
import '../resources/text_string.dart';
import '../view_models/user_vm.dart';

class TripConfirmationWidget extends StatefulWidget {
  const TripConfirmationWidget({
    super.key,
    required this.dark,
    required this.stationAddress,
    required this.startAddress,
    required this.pLineCoordinateList,
    required this.polylineSet,
    required this.mapController
  });

  final bool dark;
  final String stationAddress;
  final String startAddress;
  final List<LatLng> pLineCoordinateList;
  final Set<Polyline> polylineSet;
  //
  final Completer<GoogleMapController> mapController;

  @override
  State<TripConfirmationWidget> createState() => _TripConfirmationWidgetState();
}

class _TripConfirmationWidgetState extends State<TripConfirmationWidget> {
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
                color: widget.dark ? AppColours.paPrimaryColourActive.withOpacity(0.85) : AppColours.paAccentDust.withOpacity(0.85),
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: widget.dark
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
                    color: widget.dark ? AppColours.blackColour1 : Colors.white.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: widget.dark
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
                              Text(PATextString.tripDetails, style: Theme.of(context).textTheme.headlineMedium),
                              const SizedBox(height: PAAppStylesConstants.spaceBetweenItems,),
                              Divider(height:  PAAppStylesConstants.spaceBetweenSections, color: widget.dark? AppColours.paWhiteColour : AppColours.paBlackColour1,),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        height: 8.0,
                                        width: 8.0,
                                        margin: const EdgeInsets.all(2.0),
                                        decoration: BoxDecoration(
                                          color: widget.dark ? AppColours.paWhiteColour : AppColours.paBlackColour2,
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
                                          color: widget.dark ? AppColours.paWhiteColour : AppColours.paBlackColour2,
                                        ),
                                      )
                                    ],
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container( width: 16,),
                                            const Icon(Icons.pin_drop_sharp, size: 16,),
                                            Container( width: 16,),
                                            Text(
                                                Utils.truncateText(widget.startAddress, 36),
                                                style: Theme.of(context).textTheme.headlineSmall
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 28),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container( width: 16,),
                                            const Icon(Icons.local_gas_station_sharp, size: 16,),
                                            Container( width: 16,),
                                            Text(
                                                Utils.truncateText(widget.stationAddress, 36),
                                                style: Theme.of(context).textTheme.headlineSmall
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: PAAppStylesConstants.spaceBetweenSections,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: PAAppStylesConstants.spaceBetweenSections,),
                                  SizedBox(
                                    width: Utils.getScreenWidth(context) * 0.90,
                                    child: ElevatedButton(
                                        child: const Text(PATextString.confirmTrip),
                                        onPressed: () async {
                                          // UserViewModel
                                          // Draw trip polylinesFromOrigineToDestination
                                          await Provider.of<HomeViewModel>(context, listen: false).drawPolyLinesForTrip(
                                              Provider.of<UserViewModel>(context, listen: false),
                                              widget.pLineCoordinateList,
                                              widget.polylineSet,
                                              widget.mapController,
                                              widget.dark
                                          ).then((value) async {
                                            if(value.success){
                                              //   Good to go, take no action here
                                              // all the necessary properties are stored in the UserViewModel
                                            }
                                            else{
                                              //  notify user of error
                                            }
                                          });

                                        }
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: PAAppStylesConstants.spaceBetweenItems,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: PAAppStylesConstants.spaceBetweenSections,),
                                  SizedBox(
                                    width: Utils.getScreenWidth(context) * 0.90,
                                    child: ElevatedButton(
                                        style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                                          backgroundColor: MaterialStateProperty.all<Color>(AppColours.paErrorColour),
                                        ),//Theme.of(context).textTheme.headlineSmall,
                                        onPressed: (){
                                          Provider.of<HomeViewModel>(context, listen: false).cancelTrip(
                                              context,
                                              Provider.of<UserViewModel>(context, listen: false)
                                          );
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const HomeView()),
                                          );

                                        },
                                        child: const Text(PATextString.cancelTrip,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20.0
                                          ),
                                        )
                                    ),
                                  ),
                                  const SizedBox(height: PAAppStylesConstants.spaceBetweenSections,),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),

          ),
        ],
      ),
    );
  }
}
