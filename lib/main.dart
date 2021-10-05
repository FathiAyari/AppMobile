import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showroom_front/login/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:showroom_front/onboardingPage/Onboarding.dart';
import 'package:showroom_front/splash_screen.dart';
int isViewed;
Future <void>  main() async {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,

      )
  );
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  isViewed =prefs.getInt('Onboard');
  print("te");


  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Show Room Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isViewed!=0 ?Onboarding():SplashScreen(),
    );
  }
}
