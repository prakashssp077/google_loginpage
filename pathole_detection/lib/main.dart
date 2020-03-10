import 'package:flutter/material.dart';
import 'package:pathole_detection/LoginScreen/auth_service.dart';
import 'package:pathole_detection/WelcomeScreen.dart';
import 'package:pathole_detection/maps/mapPage.dart';
import 'HomeController.dart';
import 'LoginScreen/sign_up_page.dart';
import 'introScreen.dart';
import 'maps/Splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: AuthService(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: HomeController(),
        debugShowCheckedModeBanner: false,
       /* routes: {
          'home':(_) => mapPage(),
        }, */
       routes: <String , WidgetBuilder>{
         '/signUp' : (BuildContext context) => SignUpView(authFormType: AuthFormType.signUp,),
         '/signIn' : (BuildContext context) => SignUpView(authFormType: AuthFormType.signIn,),
         '/home' : (BuildContext context) => HomeController()
      },
      ),
    );
  }
}

