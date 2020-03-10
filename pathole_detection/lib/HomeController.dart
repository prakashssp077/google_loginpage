
import 'package:flutter/material.dart';
import 'package:pathole_detection/LoginScreen/First_view.dart';

import 'LoginScreen/auth_service.dart';
import 'WelcomeScreen.dart';
import 'maps/mapPage.dart';
class HomeController extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final AuthService auth = Provider.of(context).auth;
    return StreamBuilder(
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<String> snapshot){
        if(snapshot.connectionState == ConnectionState.active){
          final bool signedIn = snapshot.hasData;
          return signedIn ? MapPage(): FirstView();
        }
        return CircularProgressIndicator();
      },
    );
  }

}

class Provider extends InheritedWidget{
  final AuthService auth;
  Provider({Key key, Widget child, this.auth}) : super(key:key, child:child);
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }
  static Provider of(BuildContext context) =>(context.inheritFromWidgetOfExactType(Provider) as Provider);

}
