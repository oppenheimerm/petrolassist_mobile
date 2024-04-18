import 'package:flutter/material.dart';
import 'package:petrol_assist_mobile/resources/text_string.dart';
import 'package:petrol_assist_mobile/service/network_get_request.dart';

import '../app_constants.dart';
import '../service/network_service.dart';
import '../service/operation_status.dart';
import '../utilities/utils.dart';


class VerifyEmailViewModel with ChangeNotifier{
  final NetworkGetRequests _networkGetRequests = NetworkGetRequests();
  final PANetworkService _networkService = PANetworkService();

  //  Private member with leading _
  late String _email = "";

  // Getter Methods
    String get emailAddress  => _email;


  // Setter Methods
  void setEmailAddress(String newEmail) {
    _email = newEmail;
    notifyListeners();
  }

  void clearEmailAddress(){
    _email = "";
    notifyListeners();
  }

  /// Redirect the user to the login page.
  void continueClick(BuildContext context){
    Navigator.pushNamed(context, AppConsts.rootLogin);
  }

  // TODO Not sure we really need the return OperationStatus,
  // if should just redirect the user to login
  Future<OperationStatus?> resendVerificationToken(BuildContext context) async {
    OperationStatus? status;
    await _networkService.paGetNetworkStatus().then((value) async {
      if (value) {
        //  Connection Ok, make get request
        _networkGetRequests.resendVerificationToken(_email)
            .then((response) async {
              status = response;
              if(status?.success == true){
                Utils.snackBar(PATextString.pleaseLogin, context);
                await Navigator.pushReplacementNamed(context, AppConsts.rootLogin);
              }
              else if(status?.errorType == AppConsts.operationFailed)
                {
                  Utils.snackBar(PATextString.pleaseCreateAnAccount, context);
                  await Navigator.pushReplacementNamed(context, AppConsts.rootLogin);
                }
              else{
                Utils.snackBar(PATextString.pleaseCreateAnAccount, context);
                await Navigator.pushReplacementNamed(context, AppConsts.rootLogin);
              }
        });
      }
      else {
        // Could not connect to network
        status = OperationStatus(
            false, PATextString.noNetworkDetected, AppConsts.noNetworkService
        );
        Utils.snackBar(PATextString.noNetworkDetected, context);
      }
    });
    return status;
  }
}