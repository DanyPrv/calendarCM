import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapSection extends StatelessWidget {
  const GoogleMapSection({Key? key}) : super(key: key);

  static const String _title = 'Map';
  static const _initialCameraPosition =
      CameraPosition(target: LatLng(37.773972, -122.431297), zoom: 11.5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text(_title)),
        floatingActionButton:
            ElevatedButton(onPressed: () {}, child: const Text('Add location')),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: const GoogleMap(initialCameraPosition: _initialCameraPosition));
  }
}
