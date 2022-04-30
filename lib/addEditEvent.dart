import 'dart:developer';

import 'package:calendar/Classes/calendarAppointment.dart';
import 'package:calendar/Database/database.dart';
import 'package:calendar/calendar.dart';
import 'package:calendar/googleMap.dart';
import 'package:calendar/worker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;
import 'package:calendar/Database/database.dart' as DB;

import 'Database/databaseProvider.dart';

class AddEditEventSection extends StatelessWidget {
  const AddEditEventSection(
      {Key? key, required this.event, required this.isEdit, required this.user})
      : super(key: key);
  final bool isEdit;
  final CalendarAppointment event;
  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit == true ? 'Edit event' : 'Add event')),
      body: AddEditEvent(event: event, isEdit: isEdit, user: user),
    );
  }
}

class AddEditEvent extends StatefulWidget {
  const AddEditEvent(
      {Key? key, required this.event, required this.isEdit, required this.user})
      : super(key: key);

  final bool isEdit;
  final CalendarAppointment event;
  final User user;

  @override
  State<AddEditEvent> createState() => _AddEditEventState();
}

class _AddEditEventState extends State<AddEditEvent> {
  DatabaseProvider dbProvider = DatabaseProvider();

  TextEditingController subjectController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();

  @override
  void initState() {
    if (startDateController.text.isEmpty) {
      subjectController.text = widget.event.subject;
      locationController.text = widget.event.location!;
      startDateController.text =
          DateFormat('yyyy-MM-dd').format(widget.event.startTime);
      startTimeController.text =
          timeOfDayToString(TimeOfDay.fromDateTime(widget.event.startTime));
      endDateController.text =
          DateFormat('yyyy-MM-dd').format(widget.event.endTime);
      endTimeController.text =
          timeOfDayToString(TimeOfDay.fromDateTime(widget.event.endTime));
    }
    for (var reminder in widget.event.reminders) {
      var difference = widget.isEdit
          ? widget.event.startTime.difference(reminder)
          : widget.event.startTime.difference(reminder);

      reminders.add(difference);
    }
    super.initState();
  }

  List<Duration> reminders = [];

  @override
  void dispose() {
    subjectController.dispose();
    locationController.dispose();
    startDateController.dispose();
    startTimeController.dispose();
    endDateController.dispose();
    endTimeController.dispose();
    reminders.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  child: TextField(
                    controller: startDateController,
                    onTap: () {
                      showDatePicker(
                              context: context,
                              initialDate:
                                  DateTime.parse(startDateController.text),
                              firstDate: DateTime(2013),
                              lastDate: DateTime(2033),
                              initialEntryMode:
                                  DatePickerEntryMode.calendarOnly)
                          .then((value) => setState(() {
                                startDateController.text =
                                    DateFormat('yyyy-MM-dd').format(value!);
                              }));
                    },
                    decoration: const InputDecoration(labelText: 'Enter date'),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: startTimeController,
                    onTap: () {
                      showTimePicker(
                              context: context,
                              initialTime:
                                  stringToTimeOfDay(startTimeController.text))
                          .then((value) => setState(() {
                                if (value != null) {
                                  startTimeController.text =
                                      timeOfDayToString(value);
                                } else {
                                  startTimeController.text = '';
                                }
                              }));
                    },
                    decoration: const InputDecoration(labelText: 'Enter time'),
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
                  child: TextField(
                    controller: endDateController,
                    onTap: () {
                      showDatePicker(
                              context: context,
                              initialDate:
                                  DateTime.parse(endDateController.text),
                              firstDate: DateTime(2013),
                              lastDate: DateTime(2033),
                              initialEntryMode:
                                  DatePickerEntryMode.calendarOnly)
                          .then((value) => setState(() {
                                endDateController.text =
                                    DateFormat('yyyy-MM-dd').format(value!);
                              }));
                    },
                    decoration: const InputDecoration(labelText: 'Enter date'),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: endTimeController,
                    onTap: () {
                      showTimePicker(
                              context: context,
                              initialTime:
                                  stringToTimeOfDay(endTimeController.text))
                          .then((value) => setState(() {
                                if (value != null) {
                                  endTimeController.text =
                                      timeOfDayToString(value);
                                } else {
                                  endTimeController.text = '';
                                }
                              }));
                    },
                    decoration: const InputDecoration(labelText: 'Enter time'),
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
                        onPressed: () async {
                          final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const GoogleMapSection()));
                          locationController.text = result;
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
                  height: (25.0 * (reminders.length - 1) != 0 &&
                          25.0 * (reminders.length - 1) >= 0
                      ? 25.0 * (reminders.length - 1) > 150
                          ? 150.0
                          : 30.0 * (reminders.length - 1)
                      : 25.0),
                  child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      itemCount: reminders.length,
                      itemBuilder: (BuildContext context, int index) {
                        var text = '';
                        if (reminders[index].inDays != 0) {
                          text = reminders[index].inDays.toString() +
                              ' ' +
                              (reminders[index].inDays > 1 ? 'days' : 'day') +
                              ' before';
                        } else if (reminders[index].inHours != 0) {
                          text = reminders[index].inHours.toString() +
                              ' ' +
                              (reminders[index].inHours > 1
                                  ? 'hours'
                                  : 'hour') +
                              ' before';
                        } else if (reminders[index].inMinutes != 0) {
                          text = reminders[index].inMinutes.toString() +
                              ' ' +
                              (reminders[index].inMinutes > 1
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
                        var optionValue = getReminderOptionValues();
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return _MyDialog(
                                onSelectedOptionChanged: (value) {
                                  reminders.clear();
                                  setState(() {
                                    reminders.addAll(value);
                                  });
                                },
                                optionValues: optionValue,
                              );
                            });
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
                  onPressed: () async {
                    String subject = subjectController.text;

                    TimeOfDay startTime =
                        stringToTimeOfDay(startTimeController.text);
                    DateTime startDate =
                        DateTime.parse(startDateController.text).add(Duration(
                            hours: startTime.hour, minutes: startTime.minute));

                    TimeOfDay endTime =
                        stringToTimeOfDay(endTimeController.text);
                    DateTime endDate = DateTime.parse(endDateController.text)
                        .add(Duration(
                            hours: endTime.hour, minutes: endTime.minute));

                    String location = locationController.text;

                    if (!widget.isEdit) {
                      //   //create action
                      final entity = AppointmentsCompanion(
                          subject: drift.Value(subject),
                          startTime: drift.Value(startDate),
                          endTime: drift.Value(endDate),
                          location: drift.Value(location),
                          userId: drift.Value(widget.user.id));

                      final result = await dbProvider
                          .getDatabase()
                          .insertAppointment(entity);

                      if (reminders.isNotEmpty) {
                        for (var reminder in reminders) {
                          var reminderTime = startDate.subtract(reminder);
                          final reminderEntity = RemindersCompanion(
                            appointmentId: drift.Value(result),
                            reminderTime: drift.Value(reminderTime),
                            eventStartDate: drift.Value(startDate),
                          );
                          String notificationMessage =
                              'You have the following event in ' +
                                  startDate
                                      .difference(
                                          reminderEntity.reminderTime.value)
                                      .inMinutes
                                      .toString() +
                                  ' minutes: ' +
                                  entity.subject.value;

                          final reminderRes = await dbProvider
                              .getDatabase()
                              .insertReminder(reminderEntity);
                          if (reminderRes != -1) {
                            await createNotification(notificationMessage,
                                reminderEntity.reminderTime.value);
                          }
                        }
                      }
                    } else {
                      //edit action
                      var appReminders = await dbProvider
                          .getDatabase()
                          .getRemindersByAppointmentId(
                              widget.event.appointmentId);
                      for (DB.Reminder reminder in appReminders) {
                        dbProvider.getDatabase().deleteReminders(reminder.id);
                      }
                      final entity = AppointmentsCompanion(
                          id: drift.Value(widget.event.appointmentId),
                          subject: drift.Value(subject),
                          startTime: drift.Value(startDate),
                          endTime: drift.Value(endDate),
                          location: drift.Value(location),
                          userId: drift.Value(widget.user.id));

                      await dbProvider.getDatabase().updateAppointment(entity);

                      if (reminders.isNotEmpty) {
                        for (var reminder in reminders) {
                          var reminderTime = startDate.subtract(reminder);
                          final reminderEntity = RemindersCompanion(
                            appointmentId:
                                drift.Value(widget.event.appointmentId),
                            reminderTime: drift.Value(reminderTime),
                            eventStartDate: drift.Value(startDate),
                          );
                          String notificationMessage =
                              'You have the following event in ' +
                                  startDate
                                      .difference(
                                          reminderEntity.reminderTime.value)
                                      .inMinutes
                                      .toString() +
                                  ' minutes: ' +
                                  entity.subject.value;

                          final reminderRes = await dbProvider
                              .getDatabase()
                              .insertReminder(reminderEntity);
                          if (reminderRes != -1) {
                            await createNotification(notificationMessage,
                                reminderEntity.reminderTime.value);
                          }
                        }
                      }
                    }

                    // var snackBar =
                    //     const SnackBar(content: Text('Event edited'));
                    // ScaffoldMessenger.of(context).showSnackBar(snackBar);

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CalendarSection(
                                  title: 'Calendar',
                                  user: widget.user,
                                )),
                        (route) => false);
                  },
                )),
          ],
        ));
  }

  TimeOfDay stringToTimeOfDay(String input) {
    List<String> data = input.split(':');
    if (data.length != 2) {
      return const TimeOfDay(hour: 0, minute: 0);
    }
    return TimeOfDay(hour: int.parse(data[0]), minute: int.parse(data[1]));
  }

  String timeOfDayToString(TimeOfDay input) {
    return (input.hour < 10 ? '0' : '') +
        input.hour.toString() +
        ':' +
        (input.minute < 10 ? '0' : '') +
        input.minute.toString();
  }

  List<Duration> getReminderOptionValues() {
    return [
      const Duration(minutes: 10),
      const Duration(hours: 2),
      const Duration(days: 1)
    ];
  }
}

class _MyDialog extends StatefulWidget {
  const _MyDialog({
    required this.onSelectedOptionChanged,
    required this.optionValues,
  });

  final ValueChanged<List<Duration>> onSelectedOptionChanged;
  final List<Duration> optionValues;

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<_MyDialog> {
  List<bool?> _tempSelectedOptions = [false, false, false];
  final List<Duration> _tempOptionValues = [];
  @override
  void initState() {
    // _tempSelectedOptions = widget.selectedCities;
    // _tempOptionValues=widget.optionValues;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: SizedBox(
      height: 170,
      child: ListView(
        children: <Widget>[
          ListTile(
            title: Row(
              children: [
                Checkbox(
                  value: _tempSelectedOptions[0],
                  onChanged: (bool? value) {
                    changeOptions(value, 0);
                  },
                ),
                const Text('10 minutes before')
              ],
            ),
          ),
          ListTile(
            title: Row(
              children: [
                Checkbox(
                  value: _tempSelectedOptions[1],
                  onChanged: (bool? value) {
                    changeOptions(value, 1);
                  },
                ),
                const Text('2 hours before')
              ],
            ),
          ),
          ListTile(
            title: Row(
              children: [
                Checkbox(
                  value: _tempSelectedOptions[2],
                  onChanged: (bool? value) {
                    changeOptions(value, 2);
                  },
                ),
                const Text('1 day before')
              ],
            ),
          )
        ],
      ),
    ));
  }

  void changeOptions(bool? value, optionNumber) {
    if (value == true) {
      _tempOptionValues.add(widget.optionValues[optionNumber]);
    } else {
      _tempOptionValues.remove(widget.optionValues[optionNumber]);
    }
    widget.onSelectedOptionChanged(_tempOptionValues);
    var _newState = _tempSelectedOptions;
    _newState[optionNumber] = value;
    setState(() {
      _tempSelectedOptions = _newState;
    });
  }
}
