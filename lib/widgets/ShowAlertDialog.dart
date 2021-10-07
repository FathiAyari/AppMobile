

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:showroom_front/login/login_screen.dart';
import 'package:showroom_front/utils/shared_prefs_data.dart';

ShowAlertDialog(BuildContext context){

Widget Positive=TextButton(onPressed: (){
  logout(context);
}, child: Text(" Yes"));
Widget Negative=TextButton(onPressed: (){
  Navigator.pop(context);
}, child: Text(" No"));


AlertDialog alert = AlertDialog(
  title: Text("Notice"),
  content: Text("Hey do you want to log out ?"),
  actions: [
    Negative,
    Positive,

  ],
);

showDialog(
  context: context,
  builder: (BuildContext context) {
    return alert;
  },
);

}


logout(BuildContext context) async {
  await SharedPrefsData.clearData();
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
    return LoginScreen();
  }));
}