import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showroom_front/login/login_screen.dart';

class Body extends StatefulWidget {


  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  void OnboardingCach() async{
    int isViewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('Onboard', isViewed);


  }
  int currentPage=0;
  List <Widget> pages=[
    OnbaordingContent(
      title: 'test1',
      desc:'test1',
      image: "assets/images/contact.png",

    ),
    OnbaordingContent(
      title: 'test2',
      desc:'test2',
      image: "assets/images/contact.png",

    ),
    OnbaordingContent(
      title: 'test3',
      desc:'test3',
      image: "assets/images/contact.png",

    ),
  ];
  PageController _controller=PageController();
  @override
  Widget build(BuildContext context) {


    Size size=MediaQuery.of(context).size;
    return Scaffold(

      body: Stack(
        children: [
          PageView.builder(
            onPageChanged: (index){
              setState(() {
                currentPage=index;
              });
            },
            itemCount: pages.length,
              scrollDirection: Axis.horizontal,// the axis
              controller:_controller,
              itemBuilder: (context,int index){
            return pages[index];
            }),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
         children: [
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
           children:List.generate(pages.length,(int index) {

            return AnimatedContainer(duration: Duration(milliseconds: 200),
              height: size.height *0.01,
              width: (index ==currentPage ) ? 25:10,
              margin: EdgeInsets.symmetric(horizontal: 5,vertical: 30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: (index ==currentPage ) ? Colors.blue : Colors.blue.withOpacity(0.5)
              ),


            );

          }),
           ),
           SizedBox(
             height: 10,
           ),

           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 20),
                 child: GestureDetector(

                     onTap: ()async {

                       Navigator.pushReplacement(context,
                           MaterialPageRoute(builder: (context) {
                             return LoginScreen();
                           }));
                     },
                     child: Text('skip',

                       style: TextStyle(
                           fontSize: 20,
                           fontWeight: FontWeight.bold,
                           color: Colors.blueAccent
                       ),)
                 ),
               ),
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 20),
                 child: InkWell(

                   child:AnimatedContainer(
                     duration: Duration(milliseconds: 200),
                     height: 50,
                     width: (currentPage == pages.length - 1 ) ? 150 : 100,
                     child: DirectionMethode(controller: _controller,
                         currentPage: currentPage,
                         pages: pages,
                         press:(currentPage == pages.length - 1 ) ?    ()async{
                           await OnboardingCach();

                           Navigator.pushReplacement(context,
                               MaterialPageRoute(builder: (context) {
                                 return LoginScreen();
                               }));


                         } : ()async{
                           await OnboardingCach();
                           _controller.nextPage(duration:Duration(milliseconds: 300), curve: Curves.easeInOutQuint);}

                     ),
                   ),
                 ),
               ),


             ],
           )





         ],
          )
        ],

      ),
    ) ;
  }
}

class DirectionMethode extends StatelessWidget {
  final Function press;
  const DirectionMethode({
    Key key,
    @required PageController controller,
    @required this.currentPage,
    @required this.pages, this.press,
  }) : _controller = controller, super(key: key);

  final PageController _controller;
  final int currentPage;
  final List<Widget> pages;

  @override
  Widget build(BuildContext context) {
    return FlatButton(onPressed: press,



      child: (currentPage == pages.length - 1 ) ? Text('Get Started') : Text('next'),
      color: Colors.blueAccent.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),

    );
  }
}









class OnbaordingContent extends StatelessWidget {
  final String title;
  final String image;
  final String desc;
  const OnbaordingContent({
    Key key, this.title, this.image, this.desc,

  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return SafeArea(
      child: Column(




       children: [


         Text(
             title,

           style:TextStyle(
             color: Colors.orange,
             fontSize: size.height *0.09

           )
         ),
         SizedBox(height: size.height * 0.1,),
         Text(desc),
         Image.asset(
           image,
         height: size.height * 0.4,)
       ],
      ),
    );
  }
}
