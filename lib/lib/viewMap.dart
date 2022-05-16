import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'location.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

double? latitude;
double? longitude;

class _MyHomePageState extends State<MyHomePage> {
  GoogleMapController? _controller;
  CameraPosition? _initialPosition;

  Future getLocation() async {
    LocationData _locationData = LocationData();

    await _locationData.getCurrentLocation();

    latitude = _locationData.latitude;
    longitude = _locationData.longitude;

    print(" latitude ===========$latitude");
    print(" longitude ===========$longitude");

    _initialPosition = CameraPosition(target: LatLng(latitude!, longitude!));

    addMarker(LatLng(latitude!, longitude!));
  }

  final List<Marker> markers = [];

  addMarker(cordinate) {
    int id = Random().nextInt(100);
    markers.clear();
    setState(() {
      markers
          .add(Marker(position: cordinate, markerId: MarkerId(id.toString())));
    });
  }

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _initialPosition!,
        mapType: MapType.normal,
        onMapCreated: (controller) {
          setState(() {
            _controller = controller;
          });
          _controller!.animateCamera(CameraUpdate.zoomTo(20.00));
        },
        markers: markers.toSet(),
        onTap: (cordinate) {
          _controller!.animateCamera(CameraUpdate.newLatLng(cordinate));

          addMarker(cordinate);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller!.animateCamera(CameraUpdate.zoomOut());
        },
        child: const Icon(Icons.zoom_out),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class LocationData {
  double? latitude;
  double? longitude;

  Future<void> getCurrentLocation() async {
    try {
      print('called');
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      print('ERROR ============$e');
    }
  }
}
