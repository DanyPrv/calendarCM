import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class GoogleMapSection extends StatefulWidget {
  const GoogleMapSection({Key? key}) : super(key: key);
  @override
  State<GoogleMapSection> createState() => _GoogleMapSectionState();
}

class _GoogleMapSectionState extends State<GoogleMapSection> {
  static const _initialCameraPosition = LatLng(20.5937, 78.9629);
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? _controller;
  Position? currentPosition;
  var geoLocator = Geolocator();
  final Set<Marker> markers = {};

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    currentPosition = position;
    _controller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 11.5),
      ),
    );
  }

  void _addMarker(LatLng coordinates) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        coordinates.latitude, coordinates.longitude);
    Placemark address = placemarks.first;
    String addressInfo = address.thoroughfare! +
        " " +
        address.subThoroughfare! +
        " " +
        address.locality! +
        " " +
        address.subLocality!;

    setState(() {
      markers.clear();
      markers.add(Marker(
        //add first marker
        markerId: MarkerId(coordinates.toString()),
        position: coordinates, //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: addressInfo,
          // snippet: 'My Custom Subtitle',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));
    });
  }

  static const String _title = 'Map';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text(_title)),
        floatingActionButton: ElevatedButton(
            onPressed: () async {
              var result;
              if (markers.isEmpty) {
                Position position = await Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.best);
                List<Placemark> placemarks = await placemarkFromCoordinates(
                    position.latitude, position.longitude);
                Placemark address = placemarks.first;
                String addressInfo = address.thoroughfare! +
                    " " +
                    address.subThoroughfare! +
                    " " +
                    address.locality! +
                    " " +
                    address.subLocality!;
                result = addressInfo;
              } else {
                result = markers.first.infoWindow.title;
              }

              Navigator.pop(context, result);
            },
            child: const Text('Add location')),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: GoogleMap(
          initialCameraPosition:
              const CameraPosition(target: _initialCameraPosition, zoom: 11.5),
          onMapCreated: (GoogleMapController _cntlr) {
            _controllerGoogleMap.complete(_cntlr);
            _controller = _cntlr;
            locatePosition();
          },
          onLongPress: (latlang) {
            _addMarker(
                latlang); //we will call this function when pressed on the map
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          markers: markers,
        ));
  }
}
