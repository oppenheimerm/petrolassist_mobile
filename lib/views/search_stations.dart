import 'package:flutter/material.dart';
import 'package:petrol_assist_mobile/views/home_view.dart';
import 'package:provider/provider.dart';

import '../resources/colours.dart';
import '../resources/styles_constants.dart';
import '../resources/text_string.dart';
import '../utilities/utils.dart';
import '../view_models/search_stations_vm.dart';

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

  final SearchStationViewModel _searchStationViewModel = SearchStationViewModel();

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

    return SafeArea(
      child: Scaffold(
        backgroundColor: dark ? AppColours.paAccentDust : AppColours.blackColour1,
        appBar: AppBar(
          elevation: 2,
          backgroundColor: dark? AppColours.paAccentDust : AppColours.paWhiteColour,
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
        body: ChangeNotifierProvider<SearchStationViewModel>(
          create: (BuildContext context) => _searchStationViewModel,

          child: Consumer<SearchStationViewModel>(builder: (context, vm, _){
          return vm.searchStationsLoading ?
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.orange,
                  backgroundColor: Colors.blueGrey,
                  value: 0.33,
                ),
              ) :
            ListView.builder(
                itemCount: vm.getStations()?.length,
              itemBuilder: (context, index){
                  //  TODO Make sure that the stations list is not null
                  //  TODO Handle empty list
                  final station = vm.getStations()?.toList()[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4, top: 4, right: 4, bottom: 8),
                      child: ListTile(
                        //leading: CircleAvatar(child: Image.network(Utils.getPetrolStationLogoPrefix(station!.logo)),),
                        leading: Container(
                          width: 84,
                          height: 84,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 4,
                              color: dark ? AppColours.paPrimaryColour : AppColours.paAccentDust.withOpacity(0.67),
                            ),
                            // Add Some Shadow
                            boxShadow: [
                              BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: dark? AppColours.paWhiteColour.withOpacity(0.09) : AppColours.blackColour1.withOpacity(0.15),
                                offset: const Offset(-3, 9),
                              ),
                            ],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(Utils.getPetrolStationLogoPrefix(station!.logo)),
                            ),
                            ),
                          ),
                        title: Text(
                          Utils.truncateText(station.stationName, 28),
                          style:  Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: /*Text(
                          Utils.getDistanceAwayText(station.distance, station.siUnit),
                        ),*/
                        Row(
                          children: [
                            //  Expands the child of a Row, Column, or Flex so that the child
                            //  fills the available space
                            Icon(
                              Icons.local_gas_station_sharp,
                              color: station.stationOnline ? AppColours.paPrimaryColour : AppColours.blackColour1.withOpacity(0.45),
                            ),
                            const SizedBox( width: PAAppStylesConstants.spaceBetweenItems,),
                            Text(
                              Utils.getDistanceAwayText(station.distance, station.siUnit,),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        trailing: const CircleAvatar(
                          child: Icon(Icons.info_sharp),
                        ),
                      ),
                    ),
                  );
              });

          }),
        ),
      ),
    );
  }
}
