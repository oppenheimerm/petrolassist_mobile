import 'package:flutter/material.dart';
import 'package:petrol_assist_mobile/resources/text_string.dart';
import '../app_constants.dart';
import '../service/authentication/authentication_service.dart';
import '../service/network_service.dart';
import '../service/operation_status.dart';




class AuthViewModel with ChangeNotifier {

  late final PANetworkService _networkService = PANetworkService();
  final AuthenticationService _authenticationService = AuthenticationService();

  bool _loginLoading = false;
  bool _signUpLoading = false;

  // Getter Methods
  bool get loginLoading => _loginLoading;

  bool get signUpLoading => _signUpLoading;

  // Setter Methods
  void setLoginLoading(bool newBool) {
    _loginLoading = newBool;
    notifyListeners();
  }

  void setSignUpLoading(bool newBool) {
    _signUpLoading = newBool;
    notifyListeners();
  }

  //  Future loginApi(dynamic data, BuildContext context) async
  Future<OperationStatus?> authenticateUser(
      String username,
      String password) async {

    OperationStatus status = OperationStatus(false, PATextString.couldNotCompleteLogin, AppConsts.couldNotAuthenticateUser);
    //  Do we have network connectivity?
    await _networkService.paGetNetworkStatus().then((value) async {
      if(value){
        //  Connection Ok, send login
        await _authenticationService.requestLoginAPI
          (username, password).then((response) async {
            if(response.success){
              status = OperationStatus(true, PATextString.userAuthenticated, AppConsts.operationSuccess);
            }
            // user has not verified their email
            else if(response.errorType == AppConsts.userEmailNotVerified){
              status = OperationStatus(false, PATextString.verifyEmailAddress, AppConsts.userEmailNotVerified);
            }
            else if(response.errorType == AppConsts.notFound){
              status = OperationStatus(false, PATextString.userNotFound, AppConsts.notFound);
            }
            else{
              //  Catch all
              status = OperationStatus(false, PATextString.couldNotCompleteLogin, AppConsts.operationFailed);
            }
          });
      }
      else{
        // Could not connect to network
        status = OperationStatus(false, "Could not detect network", AppConsts.noNetworkService);
        debugPrint('Could not detect network while attempting to login: ${AppConsts.noNetworkService}');
      }

    });
    return status;

  }

  Future<OperationStatus> registerUser(
      String firstName,
      String lastName,
      String emailAddress,
      String password,
      String confirmPassword,
      bool acceptTerms,
      String mobile
      ) async{

    OperationStatus status = OperationStatus(false, "Could not complete registration", AppConsts.couldNotRegisterUser);
    //  Do we have network connectivity?
    await _networkService.paGetNetworkStatus().then((value) async {

      if(value){
        //  Connection Ok, send register data
        await _authenticationService.registerUser(
            firstName,
            lastName,
            emailAddress,
            password,
            confirmPassword,
            acceptTerms,
            mobile)
          .then((value) {
            status = value;
        });

      }
      else{
        // Could not connect to network
        status = OperationStatus(false, "Could not detect network", AppConsts.noNetworkService);
        debugPrint('Could not detect network while attempting to login: ${AppConsts.noNetworkService}');
      }

    });
    return status;
  }
}