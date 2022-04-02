import 'package:calendar/Classes/calendarAppointment.dart';
import 'package:calendar/calendar.dart';
import 'package:calendar/googleMap.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddEditEventSection extends StatelessWidget {
  const AddEditEventSection(
      {Key? key, required this.event, required this.isEdit})
      : super(key: key);
  final bool isEdit;
  final CalendarAppointment event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit == true ? 'Edit event' : 'Add event')),
      body: AddEditEvent(
        event: event,
        isEdit: isEdit,
      ),
    );
  }
}

class AddEditEvent extends StatefulWidget {
  const AddEditEvent({Key? key, required this.event, required this.isEdit})
      : super(key: key);

  final bool isEdit;
  final CalendarAppointment event;
  @override
  State<AddEditEvent> createState() => _AddEditEventState();
}

class _AddEditEventState extends State<AddEditEvent> {
  TextEditingController subjectController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  DateTime initialDate = DateTime.now();
  TimeOfDay initialTime = TimeOfDay.now();
  DateTime? startDate;
  TimeOfDay? startTime;
  DateTime? endDate;
  TimeOfDay? endTime;

  List<DateTime> reminders = [];

  @override
  Widget build(BuildContext context) {
    subjectController.text = widget.event.subject;
    locationController.text = widget.event.location!;
    reminders = widget.event.reminders;
    initialTime = TimeOfDay.fromDateTime(widget.event.startTime);
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: const Text(
                  'Subject:',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: subjectController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter subject...'),
              ),
            ),
            Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: const Text(
                  'Start date:',
                  style: TextStyle(fontSize: 20),
                )),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      showDatePicker(
                              context: context,
                              initialDate: widget.event.startTime,
                              firstDate: DateTime(2013),
                              lastDate: DateTime(2033),
                              initialEntryMode:
                                  DatePickerEntryMode.calendarOnly)
                          .then((value) => setState(() {
                                startDate = value;
                              }));
                    },
                    child: Text(
                      DateFormat('dd/MM/yyyy')
                          .format(widget.event.startTime)
                          .toString(),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      showTimePicker(
                          context: context, initialTime: initialTime);
                    },
                    child: Text(
                      DateFormat('hh:mm a')
                          .format(widget.event.startTime)
                          .toString(),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                )
              ],
            ),
            Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: const Text(
                  'End date:',
                  style: TextStyle(fontSize: 20),
                )),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      showDatePicker(
                              context: context,
                              initialDate: widget.event.endTime,
                              firstDate: DateTime(2013),
                              lastDate: DateTime(2033),
                              initialEntryMode:
                                  DatePickerEntryMode.calendarOnly)
                          .then((value) => setState(() {
                                endDate = value;
                              }));
                    },
                    child: Text(
                      DateFormat('dd/MM/yyyy')
                          .format(widget.event.endTime)
                          .toString(),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      showTimePicker(
                          context: context, initialTime: initialTime);
                    },
                    child: Text(
                      DateFormat('hh:mm a')
                          .format(widget.event.endTime)
                          .toString(),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                )
              ],
            ),
            Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: const Text(
                  'Location:',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    IconButton(
                        color: Colors.green,
                        padding: const EdgeInsets.only(right: 4),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const GoogleMapSection()));
                        },
                        icon: const Icon(Icons.add_location_alt_outlined)),
                    Expanded(
                      child: TextField(
                        controller: locationController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter location...'),
                      ),
                    )
                  ],
                )),
            Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: const Text(
                  'Reminders:',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: SizedBox(
                  height: 25.0 * (reminders.length - 1) != 0
                      ? 25.0 * (reminders.length - 1) > 150
                          ? 150.0
                          : 30.0 * (reminders.length - 1)
                      : 25.0,
                  child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      itemCount: reminders.length,
                      itemBuilder: (BuildContext context, int index) {
                        // inspect(reminders);
                        var difference =
                            reminders[index].difference(widget.event.startTime);

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
                )),
            Container(
                alignment: Alignment.topLeft,
                child: FittedBox(
                  child: TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      onPressed: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             const RemindersDialogSection()));
                        Navigator.of(context).restorablePush(_dialogBuilder);
                      },
                      child: Row(children: const <Widget>[
                        Icon(Icons.add),
                        Text(
                          'Add reminder',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ])),
                )),
            Container(
                height: 100,
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                child: ElevatedButton(
                  child: Text(
                      widget.isEdit == true ? 'Save changes' : 'Create event'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CalendarSection(
                                title: 'Calendar',
                                username: '',
                              )),
                    );
                  },
                )),
          ],
        ));
  }

  static Route<Object?> _dialogBuilder(
      BuildContext context, Object? arguments) {
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) => Dialog(
          child: SizedBox(
        height: 170,
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Row(
                children: [
                  Checkbox(
                    value: true,
                    onChanged: (bool? value) {},
                  ),
                  const Text('10 minutes before')
                ],
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  Checkbox(
                    value: false,
                    onChanged: (bool? value) {},
                  ),
                  const Text('2 hours before')
                ],
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  Checkbox(
                    value: false,
                    onChanged: (bool? value) {},
                  ),
                  const Text('1 day before')
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
