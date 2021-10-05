import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:showroom_front/login/login_screen.dart';
import 'package:showroom_front/show_room.dart';
import 'package:showroom_front/utils/shared_prefs_data.dart';

class SplashScreen extends StatefulWidget {


  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(Duration(seconds: 1), () {
        SharedPrefsData.getUserData().then((user) {
          if (user != null) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return ShowRoomScreen();
            }));
          } else {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return LoginScreen();
            }));
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,

        child: Center(
          child: Image.asset("assets/images/app_logo.png",
              width: MediaQuery.of(context).size.width * 0.4),
        ),
      ),
    );
  }
}
