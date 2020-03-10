import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'loginPage.dart';

class IntroScreen extends StatelessWidget{
  List<String> namelist = ["1.prakash","2.John Richard","3.Faiz Ahmed","4.Milton Subash"];
  List<PageViewModel> getPages(){
    return[
      PageViewModel(
        title: "TRAFFIC INFO WITH POTHOLE DETECTION AND WARNING SYSTEM",
        body: " $namelist",
        image: Center(
          child: Image.asset("assets/pothole.png", height: 175.0),
        ),
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.w900, fontSize: 20.0),
          bodyTextStyle: TextStyle( fontSize: 20.0),
        ),
      ),
      PageViewModel(
        title: "Accelerometer",
        body: "Accelerometer senses the vibration and if the vibration value"
            "is equal to the one specified the code the latitude and longitude value of "
            "the pothole is stored in the database",
        image: Center(
          child: Image.asset("assets/accmeter.jpg", height: 175.0),
        ),
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.w900, fontSize: 20.0),
          bodyTextStyle: TextStyle( fontSize: 20.0),
        ),
      ),
      PageViewModel(
        title: "To avoid Accident while travelling",
        body: "",
        image: Center(
          child: Image.asset("assets/safe.png", height: 175.0),
        ),
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.w900, fontSize: 20.0),
        ),
      ),
    ];
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: IntroductionScreen(
        globalBackgroundColor: Colors.white,
        curve: Curves.easeOut,  //page between animations

        pages: getPages(),
        done: Text("Done", style: TextStyle(color: Colors.black),),
        onDone: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context){
                return loginPage();
              }
          ));
        },
        showSkipButton: true,
        skip: const Text("Skip"),
      ),

    );
  }

}