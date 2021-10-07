import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showroom_front/login/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:showroom_front/onboardingPage/Onboarding.dart';
import 'package:showroom_front/splash_screen.dart';
int isViewed;
int out;
Future <void>  main() async {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,

      )
  );
  WidgetsFlutterBinding.ensureInitialized();
/*  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  isViewed =prefs.getInt('Onboard');*/




    SharedPreferences test = await SharedPreferences.getInstance();
     out= await test.getInt('On');
    print("$out done");









  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {




  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        debugShowCheckedModeBanner: false,
      title: 'Show Room Application',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home:out!=0?Onboarding():SplashScreen()

    );
  }
}









class shared extends StatelessWidget {

  void Onboard() async{
    WidgetsFlutterBinding.ensureInitialized();
    int out = 0;
    SharedPreferences test = await SharedPreferences.getInstance();
    await test.setInt('On', out);
    print("shared setted ");

  }

  Get() async{

    SharedPreferences test = await SharedPreferences.getInstance();
   int out= await test.getInt('On');
    print("$out done");

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: ElevatedButton(
        child: Text("click"),
        onPressed: () async {
         // await Onboard();
          await Get();
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
        },
      ),),
    );
  }
}













class onboard extends StatefulWidget {


  @override
  _onboardState createState() => _onboardState();
}

class _onboardState extends State<onboard> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}







































