import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';

class SearchAddress extends StatefulWidget {
  static const kInitialPosition = LatLng(-33.8567844, 151.213108);

  @override
  _SearchAddressState createState() => _SearchAddressState();
}

class _SearchAddressState extends State<SearchAddress> {
  PickResult? selectedPlace;

  String apiKey = "AIzaSyCwQNv0PBrZp9-gXQ6HhX9O6Lpe-0ajbTw";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Map Place Picker Demo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: const Text("Load Google Map"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return PlacePicker(
                        apiKey: apiKey,
                        initialPosition: SearchAddress.kInitialPosition,
                        useCurrentLocation: true,
                        selectInitialPosition: true,
                        //usePlaceDetailSearch: true,
                        onPlacePicked: (result) {
                          selectedPlace = result;
                          Navigator.of(context).pop();
                          setState(() {});
                        },
                        //forceSearchOnZoomChanged: true,
                        //automaticallyImplyAppBarLeading: false,
                        //autocompleteLanguage: "ko",
                        //region: 'au',
                        //selectInitialPosition: true,
                        // selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {
                        //   print("state: $state, isSearchBarFocused: $isSearchBarFocused");
                        //   return isSearchBarFocused
                        //       ? Container()
                        //       : FloatingCard(
                        //           bottomPosition: 0.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                        //           leftPosition: 0.0,
                        //           rightPosition: 0.0,
                        //           width: 500,
                        //           borderRadius: BorderRadius.circular(12.0),
                        //           child: state == SearchingState.Searching
                        //               ? Center(child: CircularProgressIndicator())
                        //               : RaisedButton(
                        //                   child: Text("Pick Here"),
                        //                   onPressed: () {
                        //                     // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
                        //                     //            this will override default 'Select here' Button.
                        //                     print("do something with [selectedPlace] data");
                        //                     Navigator.of(context).pop();
                        //                   },
                        //                 ),
                        //         );
                        // },
                        // pinBuilder: (context, state) {
                        //   if (state == PinState.Idle) {
                        //     return Icon(Icons.favorite_border);
                        //   } else {
                        //     return Icon(Icons.favorite);
                        //   }
                        // },
                      );
                    },
                  ),
                );
              },
            ),
            selectedPlace == null
                ? Container()
                : Text(selectedPlace?.formattedAddress ?? ""),
          ],
        ),
      ),
    );
  }
}
