import 'package:flutter/material.dart';

import '../helpers.dart';
import '../models/user.dart';
import '../service/local_storage.dart';

class StationViewModel with ChangeNotifier {

  UserModel? get getUser => LocalStorageService.getUserFromDisk();

}