import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:petrol_assist_mobile/view_models/user_vm.dart';



import '../app_constants.dart';
import '../helpers.dart';
import '../models/user.dart';
import '../resources/colours.dart';
import '../resources/styles_constants.dart';
import '../resources/text_string.dart';
import '../service/authentication/authentication_service.dart';
import '../service/local_storage.dart';
import '../utilities/utils.dart';

class HomeViewModel with ChangeNotifier{

  MapStyleTheme _mapStyleTheme;
  final AuthenticationService _authenticationService = AuthenticationService();
  bool _loadingMap = true;

  UserModel? get getUser => LocalStorageService.getUserFromDisk();

  MapStyleTheme get mapStyle => _mapStyleTheme;

  set mapStyle(MapStyleTheme mapStyle) {
    _mapStyleTheme = mapStyle;
    notifyListeners();
  }

  HomeViewModel(
      [
        this._mapStyleTheme = MapStyleTheme.silver
      ]
);

  Future updateMapTheme(GoogleMapController controller,  bool isDarkMode) async {
    try{

      //color: dark ? AppColours.paWhiteColour : AppColours.blackColour1.withOpacity(0.85),
      var style = isDarkMode ? MapStyleTheme.night : MapStyleTheme.silver ;
      await Helpers.getThemeFile(style).then((value) {
        if(value != null)
          {
            _setGoogleMapStyle(value, controller);
            notifyListeners();
          }
      });
    }
    catch(err){
      debugPrint('Error in home_vm.dart, line: 26: ${err.toString()}');
    }
  }

  void _setGoogleMapStyle(String googleMapStyle, GoogleMapController controller){
    // TODO setMapStyle deprecated
    controller.setMapStyle(googleMapStyle);
    notifyListeners();
  }

  void setLoadingState(bool state){
    _loadingMap = state;
    notifyListeners();
  }

  bool getLoadingState(){
    return _loadingMap;
  }

  static String getGreeting(String name){

    //  https://stackoverflow.com/questions/65185443/if-time-is-before-or-after-specific-time-display-good-morning-good-afternoon
    String greeting = "";
    DateTime now = DateTime.now();
    int hours = now.hour;

    if(hours>=1 && hours<=12){
      greeting = "Good Morning $name";
    } else if(hours>=12 && hours<=16){
      greeting = "Good Afternoon $name";
    } else if(hours>=16 && hours<=21){
      greeting = "Good Evening $name";
    } else if(hours>=21 && hours<=24){
      greeting = "Good Night $name";
    }

    return greeting;

  }

  Widget buildProfileTile(BuildContext context, String name, imageUrl){
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
                    spreadRadius: 2, blurRadius: 10,
                    color: AppColours.paWhiteColour.withOpacity(0.09),
                    offset: const Offset(-3 , 9),
                  ),
                ],
                shape: BoxShape.circle,
                image: _carImage(imageUrl),
              ),
            ),
            const SizedBox(width: PAAppStylesConstants.md,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  getGreeting(name),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: PAAppStylesConstants.xs,),
                Text(PATextString.nearestPetrol, style: Theme.of(context).textTheme.headlineMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(BuildContext context){
    return Positioned(
      top: 136,
      left: 20,
      right: 20,
      child: SizedBox(
        width: Utils.getScreenWidth(context),
        height: 60,
        child:  SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (){
              /*Navigator.pushReplacementNamed(context, AppConsts.rootRegister);*/
            }, child: const Text(PATextString.search),
          ),
        ),
      ),
    );
  }

  Widget buildCurrentLocationIcon(){
    return const Align(
      alignment: Alignment.bottomRight,
        child: Padding(
          padding: EdgeInsets.only( bottom: 8, right: 8),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: AppColours.paPrimaryColour,
            child: Icon(Icons.my_location_sharp, color: AppColours.paWhiteColour,),
          ),
        ),
    );
  }

  Widget buildBottomSheets(BuildContext context, bool dark){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: (Utils.getScreenWidth(context) * 0.65),
        height: 28,
        decoration: BoxDecoration(
          color: dark ? AppColours.paWhiteColour : AppColours.blackColour1.withOpacity(0.85),
          boxShadow: [
            BoxShadow(
              color: dark ? AppColours.paWhiteColour.withOpacity(0.48) : AppColours.blackColour1.withOpacity(0.85),
              spreadRadius: 4,
              blurRadius: 10,
            ),
          ],
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(12), topLeft: Radius.circular(12)
          )
        ),
        child: Center(
          child: Container(
            width: (Utils.getScreenWidth(context) * 0.6),
            height: 2,
            color: dark ? AppColours.blackColour1 : AppColours.paWhiteColour,
          ),
        ),
      ),
    );
  }

  void logout(BuildContext context) async{
    await _authenticationService.signOut().then((value) {
      Navigator.pushReplacementNamed(context, AppConsts.rootLogin);
    });
  }

  DecorationImage _carImage(String? image){

    if(image != null && image.isNotEmpty){
      // use the network image
      return DecorationImage(
          image: NetworkImage(image),
          fit: BoxFit.cover
      );
    }else{
      // default image
      return const DecorationImage(
          image: AssetImage("assets/images/mini_countryman.jpg"),
          fit: BoxFit.cover
      );
    }
  }

}