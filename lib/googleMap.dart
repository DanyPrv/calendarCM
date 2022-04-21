import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class GoogleMapSection extends StatelessWidget {
  GoogleMapSection({Key? key}) : super(key: key);

  static const _initialCameraPosition = LatLng(20.5937, 78.9629);
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? _controller;
  Position? currentPosition;
  var geoLocator = Geolocator();

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

  static const String _title = 'Map';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text(_title)),
        floatingActionButton:
            ElevatedButton(onPressed: () {}, child: const Text('Add location')),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: GoogleMap(
          initialCameraPosition:
              const CameraPosition(target: _initialCameraPosition, zoom: 11.5),
          onMapCreated: (GoogleMapController _cntlr) {
            _controllerGoogleMap.complete(_cntlr);
            _controller = _cntlr;
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
        ));
  }
}
