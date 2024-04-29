import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../app_constants.dart';
import '../env/env.dart';
import '../resources/text_string.dart';
import 'network_service.dart';
import 'operation_status.dart';

abstract class NetworkGetRequestsBase {
  Future<OperationStatus?> resendVerificationToken(String email);
  Future<dynamic> reverseGeoCodeRequest(double latitude, double longitude);
}

class NetworkGetRequests implements NetworkGetRequestsBase {
  late final PANetworkService _networkService = PANetworkService();

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
}
