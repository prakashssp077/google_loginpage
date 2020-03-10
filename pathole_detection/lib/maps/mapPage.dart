import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pathole_detection/HomeController.dart';
import 'package:pathole_detection/LoginScreen/auth_service.dart';
import 'package:pathole_detection/dotScreen/Constants.dart';
import 'map_utils.dart';

class MapPage extends StatefulWidget {
  @override
  _mapPageState createState() => _mapPageState();
}

class _mapPageState extends State<MapPage> {
  GoogleMapController _mapController;
  Uint8List _carPin;
  Marker _myMarker;

  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(12.8378, 80.1403),
    zoom: 14.4746,
  );


  StreamSubscription<Position> _positionStream;
  Map<MarkerId,Marker> _markers = Map();
  Map<PolylineId,Polyline> _polylines = Map();
  List<LatLng> _myRoute= List();

  Position _lastPosition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadCarPin();
  }

  _loadCarPin() async {
    _carPin = await MapUtils.loadPinFromAsset("assets/car.png",width: 150);

    _startTracking();
  }

  _startTracking(){
    final geolocator = Geolocator();
    final locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 5);
    _positionStream = geolocator.getPositionStream(locationOptions).listen(_onLocationUpdate);
  }

  _onLocationUpdate(Position position){
    if(position != null){
      final myPosition = LatLng(position.latitude,position.longitude);
      _myRoute.add(myPosition);
      final myPolyline = Polyline(polylineId: PolylineId("me"), points: _myRoute, color: Colors.purple,width: 5);

      if(_myMarker == null){
        final markerId = MarkerId("me");
        final bitmap = BitmapDescriptor.fromBytes(_carPin);
        _myMarker = Marker(
            markerId: markerId,
            position: myPosition,
            icon: bitmap,
            rotation: 0,
            anchor: Offset(0.5,0.5)
        );
      }else{
        final rotation = _getMyBearing(_lastPosition, position);
        _myMarker = _myMarker.copyWith(positionParam: myPosition, rotationParam: rotation);
      }
      setState(() {
        _markers[_myMarker.markerId] = _myMarker;
        _polylines[myPolyline.polylineId] = myPolyline;
      });
      _lastPosition = position;
      _move(position);
    }


  }
  double _getMyBearing(Position lastPosition , Position currentPosition){
    final dx = math.cos(math.pi/180*lastPosition.latitude)*(currentPosition.latitude-lastPosition.longitude);
    final dy = currentPosition.latitude - lastPosition.latitude;
    final angle = math.atan2(dy, dx);
    return 90 - angle*180/math.pi;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(_positionStream != null){
      _positionStream.cancel();
      _positionStream = null;
    }

  }

  _move(Position position){
    final cameraUpdate =  CameraUpdate.newLatLng(LatLng(position.latitude,position.longitude));
    _mapController.animateCamera(cameraUpdate);
  }

  _updateMarkerPosition( MarkerId markerId , LatLng p){
    _markers[markerId] = _markers[markerId].copyWith( positionParam: p);

  }
  _onMarkerTap(String id){
    showDialog(context: context,
        builder: (BuildContext context){
          return CupertinoAlertDialog(
            title: Text("Click"),
            content: Text("marker id $id"),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("ok"),
                onPressed: ()=>Navigator.pop(context),
              )

            ],

          );
        });
  }

  _onTap(LatLng p){
    final id = "${_markers.length}";
    final markerId = MarkerId(id);
    final marker = Marker(
        markerId: markerId,
        position: p,
        draggable: true,
        onTap: ()=> _onMarkerTap(id),
        onDragEnd: (np) => _updateMarkerPosition(markerId, np));

    setState(() {
      _markers[markerId] = marker;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Map"),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String choice){
              setState(() async {
                if(choice ==Constants.Signout){
                  try{
                    AuthService auth = Provider.of(context).auth;
                    await auth.signOut();
                    print("sign out!");
                  }catch(e){
                    print(e);
                  }
                }else if(choice == Constants.Profile){
                  print("hello");
                }
              });
            },

            itemBuilder: (BuildContext context){
              return Constants.choices.map((String choice){
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: <Widget>[
            GoogleMap(
              initialCameraPosition: _kGooglePlex,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              compassEnabled: true,
              rotateGesturesEnabled: true,
              scrollGesturesEnabled: true,
              onTap: _onTap,
              trafficEnabled: true,
              markers: Set.of(_markers.values),
              polylines: Set.of(_polylines.values),
              onMapCreated: (GoogleMapController controller){
                _mapController = controller;
              },
            )
          ],
        ),
      ),
    );
  }
}