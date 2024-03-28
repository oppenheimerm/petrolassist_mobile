enum AuthStatus {
  notDetermined,
  notSignedIn,
  signedIn,
}

enum ApiRequestType{
  login,
  register,
  refreshToken
}

AuthStatus getStatus(String authStatus)
{
  var status = AuthStatus.notDetermined;

  switch(authStatus)
  {
    case 'notDetermined':
      status = AuthStatus.notDetermined;
      break;
    case 'notSignedIn':
      status = AuthStatus.signedIn;
      break;
    case 'signedIn':
      status = AuthStatus.signedIn;
      break;
  }

  return status;
}

String authStatusToString(AuthStatus authStatus)
{
  String status = "notDetermined";

  switch(authStatus)
  {
    case AuthStatus.notDetermined:
      status = "notDetermined";
      break;
    case AuthStatus.notSignedIn:
      status = "notSignedIn";
      break;
    case AuthStatus.signedIn:
      status = "signedIn";
      break;
  }

  return status;
}

AuthStatus authStatusFromString(String string){
  AuthStatus status = AuthStatus.notSignedIn;

  switch(string){
    case "notDetermined":
      status = AuthStatus.notDetermined;
      break;
    case "notSignedIn":
      status = AuthStatus.notSignedIn;
      break;
    case "signedIn":
      status = AuthStatus.signedIn;
      break;
    case "AuthStatus.signedIn":
      status = AuthStatus.signedIn;
      break;
    case "AuthStatus.notDetermined":
      status = AuthStatus.notDetermined;
      break;
    case "AuthStatus.notSignedIn":
      status = AuthStatus.notSignedIn;
      break;
  }

  return status;
}

class AppConsts{

  // Logo routs
  static const String appLogoDarkMode =  "assets/images/logos/logo-light.png";
  static const String appLogoLightMode = "assets/images/logos/logo-dark.png";

  //  Routes
  static const String rootSplash = "/splash";
  static const String rootLogin = "/login";
  static const String rootHome = "/home";
  static const String rootRegister = "/register";

  //static const String baseUrl = "https://psusersapi.azurewebsites.net";
  //static const String baseUrl = "http://192.168.1.152:8000";
  static const String baseUrl = "http://10.0.2.2: 7147";
  static const String memberFolderPostfix = "/usersimages";

//  Keys


  //    UserModel keys for storage
  static const String userId = 'id';
  static const String firstName = 'firstName';
  static const String lastName = 'lastName';
  static const String jwtToken = 'jwtToken';
  static const String photo = 'photo';
  static const String emailAddress = 'emailAddress';
  static const String mobile = 'mobileNumber';
  static const String distanceUnit = 'distanceUnit';
  static const String authStatus = 'authStatus';
  static const String loginTimeStamp = 'loginTimeStamp';
  static const String refreshToken = 'refreshToken';
  static const String refreshTokenExpiry = 'refreshTokenExpiry';

  static const int operationSuccess = 0;
  static const int refreshedTokensForUser = 1;
  static const int persistedUserToStorage = 2;

  //  const message types
  //    3000 range Errors
  static const int noSavedUserInstance = 3000;
  static const int couldNotAuthenticateUser = 3001;
  static const int refreshTokensForUserFail = 3002;
  static const int couldNotCompleteNetworkRequest = 3003;
  static const int couldNotDeleteStoredUser = 3004;
  static const int couldNotPersistUser = 3005;
  static const int couldNotPersistKeyValue = 3006;


  //  const network Errors
  static const int unauthorized = 401;
  static const int notFound = 404;
  //  503 Service Unavailable
  static const int internalServerError = 500;
  static const int notNetworkService = 503;

  static String? getUrl(ApiRequestType request){
    var requestType = request.name;
    switch(requestType){
      case 'login' :
        return "$baseUrl/api/Account/authenticate";
      case 'refreshToken':
        return "$baseUrl/api/Account/refresh-token";
      default:
        throw const FormatException('Invalid ApiRequestType!');
    }
  }
}



