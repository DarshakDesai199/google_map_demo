import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class View extends StatefulWidget {
  const View({Key? key}) : super(key: key);

  @override
  State<View> createState() => _ViewState();
}

class _ViewState extends State<View> {
  GoogleMapController? _controller;
  final CameraPosition _cameraPosition =
      const CameraPosition(target: LatLng(21.2159019, 72.8864846));
  final List<Marker> markers = [];
  addMarker(cordianate) {
    int id = Random().nextInt(100);
    setState(
      () {
        markers.add(
          Marker(
            position: cordianate,
            markerId: MarkerId(
              id.toString(),
            ),
          ),
        );
      },
    );
  }

  Positioned? currentPositioned;

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPositioned = position as Positioned?;

    LatLng latLng = LatLng(position.latitude, position.longitude);
    var cameraPosition = CameraPosition(target: latLng, zoom: 14);
    _controller!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  void initState() {
    locatePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          onPressed: () {
            _controller!.animateCamera(CameraUpdate.zoomOut());
          },
          child: const Icon(Icons.zoom_out),
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: _cameraPosition,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: true,
        mapType: MapType.normal,
        onMapCreated: (con) {
          setState(() {
            _controller = con;
          });
        },
        markers: markers.toSet(),
        onTap: (cordinate) {
          _controller!.animateCamera(CameraUpdate.newLatLng(cordinate));
          addMarker(cordinate);
        },
      ),
    );
  }
}
