import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget{
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String myText = null;

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

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    print("signed in " +user.displayName);
    return user;
  }

  void _signOut(){
    googleSignIn.signOut();
    print("user signed out");
  }

  void _add(){
    Map<String, String> data = <String , String>{
      "name": "prakash",
      "college": "licet"
    };
    documentReference.setData(data).whenComplete((){
      print("document added");
    }).catchError((e) => print(e));
  }
  void _update(){
    Map<String, String> data = <String , String>{
      "name": "prakash updated",
      "college": "licet updated"
    };
    documentReference.updateData(data).whenComplete((){
      print("document updated");
    }).catchError((e) => print(e));
  }
  void _fetch(){
    documentReference.get().then((datasnapshot){
      if(datasnapshot.exists){
        setState(() {
          myText = datasnapshot.data['name'];
        });
      }
    });
  }
  void _detete(){
    documentReference.delete().whenComplete((){
      print("Deleted Successfully");
      setState(() {

      });
    }).catchError((e) => print(e));
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            RaisedButton(
              onPressed:(){
                _signin().then((FirebaseUser user) => print(user))
                    .catchError((e) => print(e));
              },
              child: Text("sign in"),
              color: Colors.green,
            ),
            SizedBox(height: 10,),
            RaisedButton(
              onPressed:(){
                  _signOut();
              },
              child: Text("sign out"),
              color: Colors.red,
            ),
            SizedBox(height: 10,),
            RaisedButton(
              onPressed: _add,
              child: Text("Add"),
              color: Colors.red,
            ),
            SizedBox(height: 10,),
            RaisedButton(
              onPressed: _update,
              child: Text("update"),
              color: Colors.red,
            ),
            SizedBox(height: 10,),
            RaisedButton(
              onPressed: _detete,
              child: Text("Delete"),
              color: Colors.red,
            ),
            SizedBox(height: 10,),
            RaisedButton(
              onPressed: _fetch,
              child: Text("Fetch"),
              color: Colors.red,
            ),
            SizedBox(height: 10,),
            myText == null ? Container(): Text(myText,style: TextStyle(fontSize: 20.0),)
          ],
        ),
      ),
    );
  }
}
