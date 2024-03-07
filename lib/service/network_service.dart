import 'package:connectivity_plus/connectivity_plus.dart';

abstract class PAAppNetworkService {
  Future<bool>paGetNetworkStatus();
}


class PANetworkService implements PAAppNetworkService {


  @override
  Future<bool>paGetNetworkStatus() async
  {
    var connectionResult = await Connectivity().checkConnectivity();
    if(connectionResult != ConnectivityResult.mobile && connectionResult != ConnectivityResult.wifi) {
      return false;
    }else {
      return true;
    }
  }
}