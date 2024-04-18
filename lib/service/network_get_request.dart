import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../app_constants.dart';
import '../resources/text_string.dart';
import 'network_service.dart';
import 'operation_status.dart';

abstract class NetworkGetRequestsBase {
  Future<OperationStatus?> resendVerificationToken(String email);
}

class NetworkGetRequests implements NetworkGetRequestsBase{

  @override
  Future<OperationStatus?> resendVerificationToken(String email) async{

    OperationStatus status = OperationStatus(false, PATextString.couldNotResendEmail, AppConsts.operationFailed);

    //  request verification token resend
    var url = AppConsts.getUrl(ApiRequestType.resendVerificationToken).toString() + email;

    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      //  200, so it just sends back: "Email verification resent." message
      //var successMassage = response.body;
      status = OperationStatus(true, PATextString.resendEmailRequestSuccess, AppConsts.operationSuccess);
    }else if(response.statusCode == 404){
      // account not found
      status = OperationStatus(false, PATextString.accountNotFound, AppConsts.operationFailed);
    }else if(response.statusCode == 400){
      status = OperationStatus(false, PATextString.badRequest, AppConsts.operationFailed);
    }/*
        TODO - Account already verified
        */
    return status;

  }
}