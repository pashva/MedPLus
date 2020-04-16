import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  List<Marker> myG = [];
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: GoogleMap(
        markers: Set.from(myG),
    mapType: MapType.normal,
    initialCameraPosition: _kGooglePlex,
    
    onMapCreated: (GoogleMapController controller) {
      _controller.complete(controller);
    },
        ),
        floatingActionButton: FloatingActionButton.extended(
    onPressed: _goToTheLake,
    label: Text('DeliveryBoy Location'),
    icon: Icon(Icons.details),
        ),
      );
  }

  Future<void> _goToTheLake() async {
    List<Marker> allmarkers = [];
    DocumentSnapshot doc=await Firestore.instance.collection("Location").document("delLoc").get();
    allmarkers.add(Marker(
      
      markerId: MarkerId("mymarkrt"),
      draggable: false,
      position: LatLng(doc["latitude"], doc["longitude"]),));
      setState(() {
        myG=allmarkers;
        
      });
    
     final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(doc["latitude"], doc["longitude"]),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}