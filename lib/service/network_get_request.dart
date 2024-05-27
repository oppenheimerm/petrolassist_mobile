import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../app_constants.dart';
import '../env/env.dart';
import '../models/station.dart';
import '../resources/text_string.dart';
import 'network_service.dart';
import 'operation_status.dart';

abstract class NetworkGetRequestsBase {
  Future<OperationStatus?> resendVerificationToken(String email);
  Future<dynamic> reverseGeoCodeRequest(double latitude, double longitude);
  Future<OperationStatus?> getNearbyStations(double lat, double longt, intDistanceUnit);
  Future<dynamic> getDirections(LatLng origin, LatLng destination);
}

class NetworkGetRequests implements NetworkGetRequestsBase {
  late final PANetworkService _networkService = PANetworkService();

  @override
  Future<dynamic> getDirections(LatLng? origin, LatLng? destination) async{
    // url https://maps.googleapis.com/maps/api/directions/json
    //   ?destination=Montreal
    //   &origin=Toronto
    //   &key=YOUR_API_KEY

    dynamic reply;

    if( origin != null && destination != null){
      var urlPostfix = "origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=${Env.googleMapsApiKey}";
      var url = AppConsts.getUrl(ApiRequestType.requestDirections).toString() + urlPostfix;

      await http.get(
        Uri.parse(url),
      ).then((value) async {
        if (value.statusCode == 200) {
          String responseData = value.body;
          var decodeResponseData = jsonDecode(responseData);
          reply = decodeResponseData;
        }else {
          // If the server did not return a 200 OK response,
          // then throw an exception.
          reply = AppConsts.couldNotGetDirection;
        }
      });
    }else{
      reply = AppConsts.couldNotGetDirection;
    }

    return reply;
  }

  @override
  Future<dynamic> reverseGeoCodeRequest(double latitude, double longitude) async {
    //  Do we have network connectivity?
    //https://maps.googleapis.com/maps/api/geocode/json?latlng=
    // https://maps.googleapis.com/maps/api/geocode/json?latlng=

    var urlPostfix = "$latitude,$longitude&key=${Env.googleMapsApiKey}";
    var url = AppConsts.getUrl(ApiRequestType.requestGeoCodeLocation).toString() + urlPostfix;

    dynamic reply;

    await http.get(
      Uri.parse(url),
    ).then((value) async {
      if (value.statusCode == 200) {
        String responseData = value.body;
        var decodeResponseData = jsonDecode(responseData);
        reply = decodeResponseData;
      }else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        reply = PATextString.couldNotGeoCodeLocation;
      }
    });
    return reply;
  }

  //  Remove - keep in viewmodel
  @override
  Future<OperationStatus?> resendVerificationToken(String email) async {
    OperationStatus status = OperationStatus(
        false, PATextString.couldNotResendEmail, AppConsts.operationFailed);

    //  request verification token resend
    var url =
        AppConsts.getUrl(ApiRequestType.resendVerificationToken).toString() +
            email;

    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      //  200, so it just sends back: "Email verification resent." message
      //var successMassage = response.body;
      status = OperationStatus(true, PATextString.resendEmailRequestSuccess,
          AppConsts.operationSuccess);
    } else if (response.statusCode == 404) {
      // account not found
      status = OperationStatus(
          false, PATextString.accountNotFound, AppConsts.operationFailed);
    } else if (response.statusCode == 400) {
      status = OperationStatus(
          false, PATextString.badRequest, AppConsts.operationFailed);
    } /*
        TODO - Account already verified
        */
    return status;
  }

//  TODO Remove
  @override
  Future<OperationStatus?> getNearbyStations(double lat, double longt, intDistanceUnit) async {

    dynamic reply;

    //  ?fromLat=51.5237747&fromLongt=-0.065196&countryId=1&units=1
    var url =
        "${AppConsts.getUrl(ApiRequestType.requestStationsData)}?fromLat=$lat&fromLongt=$longt&units=$intDistanceUnit";

    final response = await http.get(
      Uri.parse(url),
    );


    await http.get(
      Uri.parse(url),
    ).then((value) async {
      if (value.statusCode == 200) {

        String responseData = value.body;
        //https://docs.flutter.dev/cookbook/networking/background-parsing
        final parsed = (jsonDecode(responseData) as List).cast<Map<String, dynamic>>();
        reply = parsed.map<StationModel>((json) => StationModel.fromJson(json)).toList();
        return reply;

      }else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        reply = PATextString.couldNotGetStationsData;
      }
    });
    return reply;

  }
}
