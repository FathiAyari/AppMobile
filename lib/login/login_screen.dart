import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showroom_front/constants/contants.dart';
import 'package:showroom_front/data/entities/user_data.dart';
import 'package:showroom_front/login/login_controller.dart';
import 'package:showroom_front/show_room.dart';
import 'package:showroom_front/utils/shared_prefs_data.dart';
import 'package:showroom_front/widgets/app_button.dart';
import 'package:showroom_front/widgets/app_loading.dart';
import 'package:showroom_front/widgets/app_textfield.dart';
import 'package:showroom_front/widgets/info_message.dart';

class LoginScreen extends StatefulWidget {


  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  LoginController loginController = LoginController();
 StreamSubscription _readUserData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/blur_background.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.circular(5),
                          color: Color(0x22000000)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 30, top: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/app_logo.png", width: 150),
                            Text("Showroom",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: FONT_POPPINS_MEDIUM,
                                    fontSize: 25)),
                            const SizedBox(
                              height: 30,
                            ),
                            Text("Authentification",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: FONT_POPPINS_MEDIUM,
                                    fontSize: 15)),
                            SizedBox(
                              height: 50,
                            ),
                            AppTextField(
                              placeholder: "Username",
                              controller: this.loginController.usernameController,
                              colorTheme: Colors.white,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            AppTextField.password(
                              placeholder: "Mot de passe",
                              controller: this.loginController.passwordController,
                              colorTheme: Colors.white,
                              onSubmit: () {
                                loginUser(context);
                              },
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            AppButton(
                              buttonText: "S'authentifier",
                              onClickHandler: () async {

                                loginUser(context);
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  loginUser(BuildContext appContext) {
    bool inputVerification = loginController.verifInputField();
    if (inputVerification) {
      AppLoading().show(context);
      var mediaReference = FirebaseDatabase.instance.reference().child("users");
      _readUserData = mediaReference.onValue.listen((event) {
        Map<dynamic, dynamic> map = event.snapshot.value;
        map.forEach((item, value) {
          var user = UserData.fromJson(value);
          if (user.login == loginController.usernameController.text &&
              user.password == loginController.passwordController.text) {
            SharedPrefsData.saveUserData(user).then((value) {
              _readUserData.cancel();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return ShowRoomScreen();
              }));
            });
          }
        });
        InfoMessage(message: "Identifiant ou mot de passe incorrect")
            .show(context);
      });
    } else {
      InfoMessage(message: "Veuillez saisir vos coordonnées").show(context);
    }
  }
}
