import 'package:flutter/material.dart';
import 'package:petrol_assist_mobile/views/home_view.dart';
import 'package:petrol_assist_mobile/views/station.dart';
import 'package:provider/provider.dart';

import '../components/shimmer_search.dart';
import '../resources/colours.dart';
import '../resources/styles_constants.dart';
import '../resources/text_string.dart';
import '../utilities/utils.dart';
import '../view_models/search_station_vm.dart';


class SearchStationsView extends StatefulWidget {
  const SearchStationsView({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.countryId,
    required this.distanceUnit
  });

  final double latitude;
  final double longitude;
  final int countryId;
  final int distanceUnit;
  @override
  State<SearchStationsView> createState() => _SearchStationsViewState();
}

class _SearchStationsViewState extends State<SearchStationsView> {

  final SearchStationsViewModel _searchStationViewModel = SearchStationsViewModel(
  );

  @override
  void initState(){
    //  initState must be a method which takes no parameters and returns void{
    _searchStationViewModel.getNearestStations(widget.latitude, widget.longitude,
        widget.countryId, widget.distanceUnit);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final dark = Utils.isDarkMode(context);

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

    return SafeArea(
      child: Scaffold(
        backgroundColor: dark ? AppColours.blackColour2 : AppColours.paAccentDust,
        appBar: AppBar(
          elevation: 2,
          backgroundColor: dark? AppColours.blackColour1 : AppColours.paWhiteColour,
          leading: BackButton(
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomeView())
              );
            },
          ),
          title: Text( PATextString.nearestStationResults, style: Theme.of(context).textTheme.headlineMedium),
        ),
        body: ChangeNotifierProvider<SearchStationsViewModel>(
          create: (BuildContext context) => _searchStationViewModel,

          child: Consumer<SearchStationsViewModel>(builder: (context, vm, _){

            if(vm.searchStationsLoading){
              return ListView.builder(
                  itemCount: 20,
                  itemBuilder: (context, index){
                    return buildSearchShimmer();
                  }
              );
            }else if(vm.getStations()?.length != null)
            {
              return ListView.builder(
                  itemCount: vm.getStations()?.length,
                  itemBuilder: (context, index){
                    //  TODO Make sure that the stations list is not null
                    //  TODO Handle empty list
                    final station = vm.getStations()?.toList()[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4, top: 8, right: 4, bottom: 8),
                        child: ListTile(
                          tileColor: dark? AppColours.paBlackColour1 : AppColours.paAccentDust,
                          leading: Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 4,
                                color: dark ? AppColours.paAccentDust.withOpacity(0.67) : AppColours.paBlackColour1.withOpacity(0.20),
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
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              Utils.truncateText(station.stationName, 22),
                              style:  Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w700
                              ),
                            ),
                          ),
                          subtitle:
                          Row(
                            children: [
                              //  Expands the child of a Row, Column, or Flex so that the child
                              //  fills the available space
                              _searchStationViewModel.getStationStatusIcon(station.stationOnline, 30),
                              const SizedBox( width: PAAppStylesConstants.spaceBetweenItems,),
                              Text(
                                Utils.getDistanceAwayText(station.distance, station.siUnit,),
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500
                                ),
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
                  });
            }else{
              return const Center(child: Text('No items'));
            }


          }),
        ),
      ),

    );;

  }
}
