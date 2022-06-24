import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_map_demo/view/constant.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationGoogle extends StatefulWidget {
  const LocationGoogle({Key? key}) : super(key: key);

  @override
  State<LocationGoogle> createState() => _LocationGoogleState();
}

class _LocationGoogleState extends State<LocationGoogle> {
  final Completer<GoogleMapController> controller = Completer();
  static LatLng sourceLocation = LatLng(21.2202099, 72.8769573);
  static LatLng destinationLocation = LatLng(21.2315245, 72.8397845);
  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocationData;

  void currentLocation() async {
    Location location = Location();
    location.getLocation().then((location) {
      currentLocationData = location;
    });
    GoogleMapController googleMapController = await controller.future;

    location.onLocationChanged.listen((newloc) {
      currentLocationData = newloc;

      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(newloc.latitude!, newloc.longitude!), zoom: 13.5),
        ),
      );
      setState(() {});
    });
  }

  void getPolylinePoint() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        apiKey,
        PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
        PointLatLng(
            destinationLocation.latitude, destinationLocation.longitude));
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      setState(() {});
    }
  }

  @override
  void initState() {
    currentLocation();
    getPolylinePoint();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentLocationData == null
          ? const Center(child: Text("Loading"))
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(currentLocationData!.latitude!,
                      currentLocationData!.longitude!),
                  zoom: 13.5),
              polylines: {
                Polyline(
                    polylineId: PolylineId("route"),
                    points: polylineCoordinates,
                    color: Colors.red,
                    width: 6)
              },
              markers: {
                Marker(
                    markerId: MarkerId("currentLocation"),
                    position: LatLng(currentLocationData!.latitude!,
                        currentLocationData!.longitude!)),
                Marker(markerId: MarkerId("source"), position: sourceLocation),
                Marker(
                    markerId: MarkerId("destination"),
                    position: destinationLocation),
              },
              onMapCreated: (mapController) {
                controller.complete(mapController);
              },
            ),
    );
  }
}
