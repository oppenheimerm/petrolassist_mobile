

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum MapStyleTheme{
  night,
  silver
}

class Helpers{
  static const String themesUrl = "assets/themes";

  static String _getMapStyleTheme(MapStyleTheme request){
    var requestType =  request.name;
    switch(requestType){
      case 'night':
        return "$themesUrl/night_style.json";
      case 'silver':
        return "$themesUrl/silver_style.json";
      default:
        throw const FormatException('Invalid MapStyleTheme!');
    }
  }

  //  https://docs.flutter.dev/ui/assets/assets-and-images#:~:text=Each%20Flutter%20app%20has%20a,%3Aflutter%2Fservices.dart%20.
  //  https://api.flutter.dev/flutter/widgets/DefaultAssetBundle/of.html
  static Future<String?> getThemeFile(MapStyleTheme mapStyleTheme) async{

    String? theme;

    var source = _getMapStyleTheme(mapStyleTheme);
    if(source.isEmpty)
      {
        return theme;
      }
    else
      {
        try{
          await rootBundle.loadString(source).then((value) async {
            theme = value;
              return theme;
          });
        }
        catch(err)
        {
          debugPrint("getThemeFile() failed with the following error: ${err.toString()} ");
          return theme;
        }
      }
    return theme;
  }


}