import 'package:flutter/material.dart';
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

    OperationStatus status = OperationStatus(false, "Could not complete login", AppConsts.couldNotAuthenticateUser);
    //  Do we have network connectivity?
    await _networkService.paGetNetworkStatus().then((value) async {

      if(value){
        //  Connection Ok, send login
        await _authenticationService.requestLoginAPI
          (username, password).then((value) {
          status = value;
        });

      }
      else{
        // Could not connect to network
        status = OperationStatus(false, "Could not detect network", AppConsts.notNetworkService);
        debugPrint('Could not detect network while attempting to login: ${AppConsts.notNetworkService}');
      }

    });
    return status;

  }
  //  Future<OperationStatus> registerUser(){}
}