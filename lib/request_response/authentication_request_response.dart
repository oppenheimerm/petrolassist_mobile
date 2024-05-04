

import '../models/user.dart';
import '../service/operation_status.dart';

class AuthenticationRequestResponse extends OperationStatus{
  UserModel? user;
  AuthenticationRequestResponse(UserModel user, super.success, super.errorMessage, super.errorType);
}
