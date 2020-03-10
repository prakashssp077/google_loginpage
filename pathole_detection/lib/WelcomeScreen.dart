
import 'package:flutter/material.dart';
import 'package:pathole_detection/introScreen.dart';
import 'package:pathole_detection/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: FlatButton(
          child: Text("click to proceed",style: TextStyle(color: Colors.white),),
          color: Colors.lightBlue,
          onPressed: () async{
            bool visitingFlag = await getVisitedFlag();
            setVisitingFlag();

            if(visitingFlag == true){
              // it is the case when the user is visiting for not first
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => loginPage()
              ));
            }else{
              //it is the case user visiting for first time
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => IntroScreen()
              ));
            }
          },
        ),
      ),
    );
  }

}

setVisitingFlag() async{
  SharedPreferences preferences = await SharedPreferences.getInstance(); //initialize shared preferences in pubsspec.yaml file
  preferences.setBool("alreadyVisited", true);
}
getVisitedFlag() async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool alreadyVisited =preferences.getBool("alreadyVisited")?? false;
  return alreadyVisited;
}