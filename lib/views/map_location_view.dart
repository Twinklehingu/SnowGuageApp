import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapLocationView extends StatefulWidget {
  const MapLocationView({Key? key}) : super(key: key);

  @override
  MapLocationViewState createState() => MapLocationViewState();
}

class MapLocationViewState extends State<MapLocationView> {
  final Completer<GoogleMapController> mapController = Completer();
  static const CameraPosition _position = CameraPosition(
    target: LatLng(46.93526, -121.47456),
    zoom: 14,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _position,
          mapType: MapType.normal,
          myLocationEnabled: true,
          compassEnabled: true,
          onMapCreated: (GoogleMapController controller){
            mapController.complete(controller);
          },
        ),
      ),
    );
  }
}
