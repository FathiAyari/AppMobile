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
import 'package:showroom_front/widgets/ShowAlertDialog.dart';

class ShowRoomScreen extends StatefulWidget {
  @override
  _ShowRoomScreenState createState() => _ShowRoomScreenState();
}

class _ShowRoomScreenState extends State<ShowRoomScreen> {


  String formattedTime = DateFormat("HH:mm").format(DateTime.now());
  int myMinute;
  int myHour;

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
     myHour =int.tryParse(formattedTime.split(":")[0]);
    myMinute =int.tryParse(formattedTime.split(":")[1]);

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


      setState(() {
        select = int.tryParse(selectedScreenId);
      });
      Map<dynamic, dynamic> map = event.snapshot.value;
      map.forEach((item, value) {
        var media = MediaObject.fromJson(value);
        mediaList.add(media);
      });
      if (mediaList.isNotEmpty) {
       /* startCarousel();
        displayCurrentImage();*/
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

/*  startCarousel() {
    this.timer = Timer.periodic(Duration(minutes: 1), (Timer t) {
      displayCurrentImage();
    });
  }*/

/*  displayCurrentImage() {
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
  }*/

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
                          ShowAlertDialog(context,user?.name);
                        },
                        child: Column(
                          children: [
                            Icon(Icons.logout, color: Colors.black),
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
                  Container(
                    width: 200,
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(20),
                     boxShadow: [
                       BoxShadow(
                         color: Colors.black.withOpacity(0.08),
                         blurRadius: 1,
                         spreadRadius: 0.0,
                         offset: Offset(1.0, 2.0), // shadow direction: bottom right
                       )
                     ],


                   ),
                    child: DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        alignedDropdown: true,

                        child: DropdownButton<String>(

                          items: listScreens.map<DropdownMenuItem<String>>((item) {
                            return DropdownMenuItem<String>(


                                child: Text(item.name), value: item.id.toString());
                          }).toList(),
                          value: selectedScreenId,
                          onChanged: (value) {
                            setState(() {

                              this.selectedScreenId = value;
                              select = int.tryParse(value);
                              formattedTime = DateFormat("HH:mm").format(DateTime.now());
                               myHour=int.tryParse(formattedTime.split(":")[0]);
                               myMinute=int.tryParse(formattedTime.split(":")[1]);
                               print(myHour);
                               print(myMinute);




                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: ListView.builder(
                            itemCount: mediaList.length,
                            itemBuilder: (context, index) {
                              int mediaStartMunite= int.tryParse((mediaList[index].startTime).split(":")[1]) ;
                              int mediaStartHour= int.tryParse((mediaList[index].startTime).split(":")[0]) ;
                              int mediaEndMunite= int.tryParse((mediaList[index].endTime).split(":")[1]) ;
                              int mediaEndHour= int.tryParse((mediaList[index].endTime).split(":")[0]) ;
                                  if ((mediaList[index].screenId == select && myHour> mediaStartHour && myHour<mediaEndHour) ||
                                      (myHour==mediaStartHour && myMinute> mediaStartMunite && myHour< mediaEndHour && mediaList[index].screenId == select)||
                                      (myHour==mediaEndHour && myMinute<mediaEndMunite && myMinute>mediaStartMunite&&myHour== mediaStartHour && mediaList[index].screenId == select)||
                                      (myHour==mediaEndHour && myMinute<mediaEndMunite && myHour> mediaStartHour && mediaList[index].screenId == select)
                                  ) {







                                return Content(mediaList: mediaList,index:index);

                              } else {

                                return SizedBox(
                                  height: 1,
                                );
                              }

                            })),
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

class Content extends StatelessWidget {
  const Content({
    Key key,
    @required this.mediaList,
    @required this.index,
  }) : super(key: key);

  final List mediaList;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        Container(
          height: 200,
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
  }
}
