import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:petrol_assist_mobile/service/locator.dart';
import 'package:petrol_assist_mobile/view_models/auth_vm.dart';
import 'package:petrol_assist_mobile/view_models/user_vm.dart';
import 'package:provider/provider.dart';

import 'app_constants.dart';
import 'app_routs.dart';

Future<void> requestMapsPermission() async{
  await Permission.locationWhenInUse.isDenied.then((value) {
    // if denied vale == true
    if(value){
      Permission.locationWhenInUse.request();
    }
  });
}



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //setupLocator();
  await setupLocator();
  await requestMapsPermission();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserViewModel(),
        )

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Movies App (MVVM Architecture)',
        //  https://docs.flutter.dev/cookbook/design/fonts
        theme: ThemeData(
          fontFamily: 'DM Sans',
          colorScheme: const ColorScheme.dark(),
          textTheme: const TextTheme(

          ),
        ),
        initialRoute: AppConsts.rootSplash,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}