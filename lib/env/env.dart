import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '../petrol_assist_mobile/secret.env')
abstract class Env {
  @EnviedField(varName: 'GOOGLE_API_KEY', obfuscate: true)
  static String googleMapsApiKey = _Env.googleMapsApiKey;
}
