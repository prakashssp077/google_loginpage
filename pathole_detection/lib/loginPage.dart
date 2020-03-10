import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pathole_detection/maps/Splash.dart';
import 'package:pathole_detection/maps/mapPage.dart';

import 'dotScreen/Constants.dart';

class loginPage extends StatefulWidget{
  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  String myText = null;
  bool _isLoggedIn = false;
  final DocumentReference documentReference = Firestore.instance.document("myData/dummy");
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn =  GoogleSignIn();
  Future<FirebaseUser> _signin() async{
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: gSA.idToken,
        accessToken: gSA.accessToken
    );


  }

  _login() async{
    try{
      await googleSignIn.signIn();
      setState(() {
        _isLoggedIn = true;
      });
    } catch (err){
      print(err);
    }
  }

  _logout(){
    googleSignIn.signOut();
    setState(() {
      _isLoggedIn = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),

      ),

     body: Center(
       child: RaisedButton(
         child: Text("Login with Google"),
         color: Colors.blue,
         onPressed: () {
           _signin().then((FirebaseUser user) => print(user))
               .catchError((e) => print(e));
           Navigator.push(context, MaterialPageRoute(
             builder: (context){
               return SplashPage();
             }
           ));
         },
       ),

     )
     /* body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

      _isLoggedIn
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(googleSignIn.currentUser.photoUrl, height: 50.0, width: 50.0,),
            Text(googleSignIn.currentUser.displayName),
            OutlineButton( child: Text("Logout"), onPressed: (){
              _logout();
            },)
          ],
        ) :Center(
          child: OutlineButton(
            child: Text("Login with Google"),
            onPressed: () {
              _login();
            },
          ),
        )
          ],
        ),
      ), */
    );
  }


}
