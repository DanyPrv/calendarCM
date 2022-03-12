import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

class EventViewSection extends StatelessWidget {
  const EventViewSection({Key? key, required this.event}) : super(key: key);

  final Appointment event;
  static const String _title = 'Event view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(_title)),
      body: EventView(event: event),
    );
  }
}

class EventView extends StatefulWidget {
  const EventView({Key? key, required this.event}) : super(key: key);
  final Appointment event;
  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  static const _initialCameraPosition =
      CameraPosition(target: LatLng(37.773972, -122.431297), zoom: 11.5);
  final Set<Marker> markers = {};
  static const LatLng showLocation = LatLng(37.773972, -122.431297);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(30),
        child: ListView(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 6, right: 20),
                  child: CustomPaint(
                    size: const Size(10, 10),
                    painter: CirclePainter(color: widget.event.color),
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.event.subject,
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 35),
              child: Row(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(
                      Icons.access_time,
                      color: Colors.green,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Starts on:',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      DateFormat('dd/MM/yyyy')
                              .format(widget.event.startTime)
                              .toString() +
                          ' at ' +
                          DateFormat('hh:mm a')
                              .format(widget.event.startTime)
                              .toString(),
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 17),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(
                      Icons.access_time,
                      color: Colors.red,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Ends on:',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      DateFormat('dd/MM/yyyy')
                              .format(widget.event.endTime)
                              .toString() +
                          ' at ' +
                          DateFormat('hh:mm a')
                              .format(widget.event.endTime)
                              .toString(),
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 17),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: const <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Icon(
                              Icons.location_city,
                              color: Colors.amber,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Location:',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                        height: 300,
                        child: Scaffold(
                          body: GoogleMap(
                            initialCameraPosition: _initialCameraPosition,
                            zoomControlsEnabled: false,
                            zoomGesturesEnabled: true,
                            markers: getmarkers(),
                          ),
                        )),
                  ],
                )),
          ],
        ));
  }

  Set<Marker> getmarkers() {
    //markers to place on map
    setState(() {
      markers.add(Marker(
        //add first marker
        markerId: MarkerId(showLocation.toString()),
        position: showLocation, //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: widget.event.location,
          // snippet: 'My Custom Subtitle',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));
    });

    return markers;
  }
}

class CirclePainter extends CustomPainter {
  const CirclePainter({required this.color});
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = 15;

    Offset center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, 10, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
