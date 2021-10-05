import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:showroom_front/constants/contants.dart';
import 'package:showroom_front/data/entities/media.dart';
import 'package:showroom_front/data/entities/screen.dart';
import 'package:showroom_front/data/entities/user_data.dart';
import 'package:showroom_front/login/login_screen.dart';
import 'package:showroom_front/utils/shared_prefs_data.dart';
import 'package:firebase_core/firebase_core.dart';

class ShowRoomScreen extends StatefulWidget {
  @override
  _ShowRoomScreenState createState() => _ShowRoomScreenState();
}

class _ShowRoomScreenState extends State<ShowRoomScreen> {
  String formattedTime = DateFormat.jm().format(DateTime.now());
  String imageLink = "";
  int select;
  List test = [];
  List mediaList = [];

  Timer timer;
  UserData user;
  String selectedScreenId;
  List<Screen> listScreens = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getScreenList();
      SharedPrefsData.getUserData().then((userSaved) {
        setState(() {
          user = userSaved;
        });
      });
    });
  }

  _getMediaList() {
    var mediaReference = FirebaseDatabase.instance.reference().child("media");
    mediaReference.onValue.listen((event) {
      mediaList.clear();
      timer?.cancel();
      print(selectedScreenId);
      Map<dynamic, dynamic> map = event.snapshot.value;
      map.forEach((item, value) {
        var media = MediaObject.fromJson(value);
        mediaList.add(media);
      });
      if (mediaList.isNotEmpty) {
        startCarousel();
        displayCurrentImage();
      }
      setState(() {});
    });
  }

  _getScreenList() {
    var screenReference =
        FirebaseDatabase.instance.reference().child("screens");
    screenReference.onValue.listen((event) {
      listScreens.clear();
      Map<dynamic, dynamic> map = event.snapshot.value;
      map.forEach((item, value) {
        listScreens.add(Screen.fromJson(value));
      });
      if (listScreens.isNotEmpty) {
        selectedScreenId = listScreens[0].id.toString();
        _getMediaList();
      }
      setState(() {});
    });
  }

  startCarousel() {
    this.timer = Timer.periodic(Duration(minutes: 1), (Timer t) {
      displayCurrentImage();
    });
  }

  displayCurrentImage() {
    this.mediaList.forEach((media) {
      TimeOfDay _startTime = TimeOfDay(
          hour: int.parse(media.startTime.split(":")[0]),
          minute: int.parse(media.startTime.split(":")[1]));
      TimeOfDay _endTime = TimeOfDay(
          hour: int.parse(media.endTime.split(":")[0]),
          minute: int.parse(media.endTime.split(":")[1]));
      var time = TimeOfDay.now();
      if (time.hour == _startTime.hour && time.hour == _endTime.hour) {
        if (time.minute >= _startTime.minute &&
            time.minute <= _endTime.minute) {
          setState(() {
            imageLink = media.mediaLink;
          });
        }
      } else if (time.hour >= _startTime.hour && time.hour <= _endTime.hour) {
        setState(() {
          imageLink = media.mediaLink;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/app_logo.png',
                          width: 100,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          children: [
                            Text(user?.name ?? "",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: FONT_POPPINS_MEDIUM,
                                    fontSize: 15)),
                            SizedBox(
                              height: 5,
                            ),
                            Text(user?.lastname ?? "",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: FONT_POPPINS_MEDIUM,
                                    fontSize: 15)),
                          ],
                        )
                      ],
                    ),
                    InkWell(
                        onTap: () async {
                          await logout();
                        },
                        child: Column(
                          children: [
                            Icon(Icons.logout_rounded, color: Colors.black),
                            Text("Logout",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: FONT_POPPINS_LIGHT,
                                    fontSize: 11)),
                          ],
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<String>(
                    items: listScreens.map<DropdownMenuItem<String>>((item) {
                      return DropdownMenuItem<String>(
                          child: Text(item.name), value: item.id.toString());
                    }).toList(),
                    value: selectedScreenId,
                    onChanged: (value) {
                      setState(() {

                        this.selectedScreenId = value;
                        select = int.tryParse(value);

                      });
                    },
                  ),
                ],
              ),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CachedNetworkImage(
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: MediaQuery.of(context).size.width * 0.8,
                      fit: BoxFit.contain,
                      imageUrl: this.imageLink,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Column(
                        children: [

                          /*Text("${selectedScreenId}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: FONT_POPPINS_MEDIUM,
                                  fontSize: 13)),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  setState(() {});
                                });
                              },
                              child: Text("get data")),
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('car')
                                .snapshots(),
                            builder: (BuildContext context, snapshot) {
                              if (!snapshot.hasData) {
                                return Text("loading");
                              }
                              return Container(
                                child: snapshot.data.docs[0]['brand'] == "123"
                                    ? Text("test")
                                    : Text(snapshot.data.docs[0]['brand']),
                              );
                            },
                          ),*/
                          Expanded(
                              child: ListView.builder(
                                  itemCount: mediaList.length,
                                  itemBuilder: (context, index) {
                                    if ((mediaList[index].screenId == select)) {
// hey id:3, start:1 ; aa id:4 , start:26

                                      return Column(
                                        children: [
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Container(
                                            height: 220,
                                            width: double.infinity,

                                            child: Stack(
                                              children: [
                                                Card(

                                                  shape:
                                                      RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        color:
                                                            Colors.white70,
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius
                                                            .circular(10),
                                                  ),
                                                  elevation: 10,
                                                  child: Row(

                                                    children: [



                                                      Expanded(
                                                        child: Container(

                                                          child: Column(



                                                            children: [
                                                              Expanded(
                                                                child: ClipRRect(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  child: Container(
                                                                      

                                                                    width: double.infinity,

                                                                    alignment: Alignment.center,

                                                                    child:Image.network("${mediaList[index].mediaLink}",
                                                                      fit: BoxFit.fill,
                                                                      width: double.infinity,
                                                                      height: double.infinity,
                                                                    )
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

                                              ],
                                            ),

                                          ),
                                        ],
                                      );
                                      /*return ListTile(
                                    title: Text("${mediaList[index].screenId}"),
                                  );*/
                                    } else {
                                      return SizedBox(
                                        height: 1,
                                      );
                                    }
                                    ;
                                  })),
                          /* Expanded(
                            child: ListView(
                              children:mediaList.map((e) {
                                if(e.screen_id==4){
                                    return ListTile(
                                    title: Text("${e.screenId}"),
                                  );
                                }
                               ;
                              }).toList(),
                            ),
                          ),*/
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  logout() async {
    await SharedPrefsData.clearData();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return LoginScreen();
    }));
  }
}
