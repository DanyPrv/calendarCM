import 'package:calendar/Database/database.dart' as DB;
import 'package:calendar/Database/database.dart';
import 'package:calendar/addEditEvent.dart';
import 'package:calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'Classes/calendarAppointment.dart';
import 'Database/databaseProvider.dart';

class EventViewSection extends StatelessWidget {
  EventViewSection({Key? key, required this.event, required this.user})
      : super(key: key);

  DatabaseProvider dbProvider = DatabaseProvider();
  final CalendarAppointment event;
  static const String _title = 'Event view';
  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddEditEventSection(
                            event: event,
                            isEdit: true,
                            user: user,
                          )));
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final _db = dbProvider.getDatabase();
              var appReminders =
                  await _db.getRemindersByAppointmentId(event.appointmentId);
              for (DB.Reminder reminder in appReminders) {
                _db.deleteReminders(reminder.id);
              }
              dbProvider
                  .getDatabase()
                  .deleteAppointment(event.appointmentId)
                  .then((value) => {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Deleted'))),
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CalendarSection(
                                      title: 'Calendar',
                                      user: user,
                                    )),
                            (route) => false),
                      });
            },
          ),
        ],
      ),
      body: EventView(event: event),
    );
  }
}

class EventView extends StatefulWidget {
  const EventView({Key? key, required this.event}) : super(key: key);
  final CalendarAppointment event;
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
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ],
            ),
            Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(top: 25, bottom: 7),
                child: const Text(
                  'Start date:',
                  style: TextStyle(fontSize: 20),
                )),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    DateFormat('dd/MM/yyyy')
                        .format(widget.event.startTime)
                        .toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                Expanded(
                  child: Text(
                    DateFormat('hh:mm a')
                        .format(widget.event.startTime)
                        .toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                )
              ],
            ),
            Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(top: 15, bottom: 7),
                child: const Text(
                  'End date:',
                  style: TextStyle(fontSize: 20),
                )),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    DateFormat('dd/MM/yyyy')
                        .format(widget.event.endTime)
                        .toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                Expanded(
                  child: Text(
                    DateFormat('hh:mm a')
                        .format(widget.event.endTime)
                        .toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                )
              ],
            ),
            Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Column(
                  children: <Widget>[
                    Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.only(bottom: 10),
                        child: const Text(
                          'Location:',
                          style: TextStyle(fontSize: 20),
                        )),
                    SizedBox(
                        height: 250,
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
            Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Column(
                  children: <Widget>[
                    Container(
                        alignment: Alignment.topLeft,
                        child: const Text(
                          'Reminders:',
                          style: TextStyle(fontSize: 20),
                        )),
                    SizedBox(
                      height: 130,
                      child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          itemCount: widget.event.reminders.length,
                          itemBuilder: (BuildContext context, int index) {
                            var difference = widget.event.startTime
                                .difference(widget.event.reminders[index]);

                            var text = '';
                            if (difference.inDays != 0) {
                              text = difference.inDays.toString() +
                                  ' ' +
                                  (difference.inDays > 1 ? 'days' : 'day') +
                                  ' before';
                            } else if (difference.inHours != 0) {
                              text = difference.inHours.toString() +
                                  ' ' +
                                  (difference.inHours > 1 ? 'hours' : 'hour') +
                                  ' before';
                            } else if (difference.inMinutes != 0) {
                              text = difference.inMinutes.toString() +
                                  ' ' +
                                  (difference.inMinutes > 1
                                      ? 'minutes'
                                      : 'minute') +
                                  ' before';
                            }

                            return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 35),
                                child: Text(
                                  text,
                                  style: const TextStyle(fontSize: 17),
                                ));
                          }),
                    )
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
