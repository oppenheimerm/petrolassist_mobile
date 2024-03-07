import 'package:get_it/get_it.dart';
import 'local_storage.dart';

//  See: https://www.filledstacks.com/post/flutter-dependency-injection-a-beginners-guide/
final locator = GetIt.I;

Future<void> setupLocator() async{
  //https://www.filledstacks.com/snippet/shared-preferences-service-in-flutter-for-code-maintainability/
  var instance = await LocalStorageService.getInstance();
  //locator.registerSingleton( () => LocalStorageService());
  locator.registerSingleton<LocalStorageService>(instance!);
}