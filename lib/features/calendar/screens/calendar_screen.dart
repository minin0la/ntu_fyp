import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pet_app/features/calendar/controller/calendar_controller.dart';
import 'package:pet_app/features/pets/controller/pet_controller.dart';
import 'package:pet_app/models/calendar_model.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/utils.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CalendarScreenState();
}

enum CalendarMenu { DeleteCalendar }

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      // Call `setState()` when updating the selected day
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents.value = _getEventsForDay(selectedDay);
        // print(_selectedEvents.value);
      });
    }
  }

  void _showFromTimePicker() async {
    TimeOfDay? selectedFromTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    DateTime? selectedFromDate = await showDatePicker(
      context: context,
      firstDate: kFirstDay,
      lastDate: kLastDay,
      initialDate: DateTime.now(),
    );

    if (selectedFromTime != null) {
      // Handle the selected time, e.g., set it in a variable
      setState(() {
        _selectedFromTime = selectedFromTime;
      });
    }

    if (selectedFromDate != null) {
      // Handle the selected time, e.g., set it in a variable
      setState(() {
        _selectedFromDate = selectedFromDate;
      });
    }
  }

  void _showToTimePicker() async {
    TimeOfDay? selectedToTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    DateTime? selectedToDate = await showDatePicker(
      context: context,
      firstDate: kFirstDay,
      lastDate: kLastDay,
      initialDate: DateTime.now(),
    );

    if (selectedToTime != null) {
      // Handle the selected time, e.g., set it in a variable
      setState(() {
        _selectedToTime = selectedToTime;
      });
    }

    if (selectedToDate != null) {
      // Handle the selected time, e.g., set it in a variable
      setState(() {
        _selectedToDate = selectedToDate;
      });
    }
  }

  void addCalendar() {
    if (_eventController.text.trim().isEmpty ||
        _selectedFromDate == null ||
        _selectedFromTime == null ||
        _selectedToDate == null ||
        _selectedToTime == null ||
        _dropdownValue == null ||
        _petdropdownValue == null) {
      return;
    }
    ref.read(calendarControllerProvider.notifier).addCalendar(
        _eventController.text.trim(),
        DateTime(
          _selectedFromDate!.year,
          _selectedFromDate!.month,
          _selectedFromDate!.day,
          _selectedFromTime!.hour,
          _selectedFromTime!.minute,
        ).toLocal(),
        DateTime(
                _selectedToDate!.year,
                _selectedToDate!.month,
                _selectedToDate!.day,
                _selectedToTime!.hour,
                _selectedToTime!.minute)
            .toLocal(),
        _dropdownValue,
        _petSelecteddropdownValue,
        context);
  }

  List<CalendarModel> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  List<String> items = ['Appointment', 'Vaccination', 'Medicine'];
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  TimeOfDay? _selectedFromTime;
  TimeOfDay? _selectedToTime;
  DateTime? _selectedFromDate;
  DateTime? _selectedToDate;
  String _dropdownValue = "Appointment";
  String _petdropdownValue = '';
  String _petSelecteddropdownValue = '';
  TextEditingController _eventController = TextEditingController();
  List<String> userPetsNames = [];
  Map<DateTime, List<CalendarModel>> events = {};

  late final ValueNotifier<List<CalendarModel>> _selectedEvents;
  @override
  Widget build(BuildContext context) {
    userPetsNames = ref.watch(userPetsNamesProvider).when(
          data: (names) => names.map<String>((String name) {
            // _petdropdownValue = name[0];
            return name;
          }).toList(),
          error: (error, stackTrace) => ["Error"],
          loading: () => ["Loading..."],
        );
    events = ref.watch(userCalendarsListProvider).when(
      data: (calendarList) {
        DateTime selectedDay = _selectedDay!;
        _selectedEvents.value = calendarList[selectedDay] ?? [];
        setState(() {
          events = calendarList;
        });
        return calendarList;
      },
      error: (error, stackTrace) {
        // Handle error, return a default value, or throw an exception if needed.
        return {};
      },
      loading: () {
        // Return a default value or handle loading state.
        return {};
      },
    );
    _petdropdownValue = userPetsNames[0];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      floatingActionButton: FloatingActionButton.extended(
          label: const Text("Add"),
          icon: const Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    scrollable: true,
                    title: const Text("New event"),
                    content: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Title"),
                          TextField(
                            controller: _eventController,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          // Put varible in string

                          Text(_selectedFromDate != null
                              ? 'From: ${DateFormat('dd-MM-yyyy').format(_selectedFromDate!)}'
                              : "From:"),
                          ElevatedButton(
                            onPressed: _showFromTimePicker,
                            child: Text(_selectedFromTime != null
                                ? _selectedFromTime!.format(context)
                                : 'Start Time'),
                          ),
                          Text(_selectedToDate != null
                              ? 'To: ${DateFormat('dd-MM-yyyy').format(_selectedToDate!)}'
                              : "To:"),
                          ElevatedButton(
                            onPressed: _showToTimePicker,
                            child: Text(_selectedToTime != null
                                ? _selectedToTime!.format(context)
                                : 'End Time'),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          const Text("Type:"),
                          DropdownButton<String>(
                            value: _dropdownValue,
                            items: items.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _dropdownValue = newValue!;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          const Text("Pet:"),
                          DropdownButtonFormField<String>(
                            value: _petdropdownValue,
                            items: userPetsNames.map((String e) {
                              return DropdownMenuItem<String>(
                                  value: e, child: Text(e));
                            }).toList(),
                            onChanged: (String? newPetValue) {
                              setState(() {
                                _petSelecteddropdownValue = newPetValue!;
                              });
                            },
                            onSaved: (String? newPetValue) {
                              setState(() {
                                _petdropdownValue = newPetValue!;
                                _petSelecteddropdownValue = newPetValue;
                              });
                            },
                          ),
                          // Create a dropdown menu
                        ],
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Cancel")),
                      ElevatedButton(
                          onPressed: () {
                            // events.addAll({
                            //   _selectedDay!: [
                            //     // CalendarModel(title: _eventController.text)
                            //   ]
                            // });
                            addCalendar();
                            _eventController.text = '';
                            _selectedFromDate = null;
                            _selectedFromTime = null;
                            _selectedToDate = null;
                            _selectedToTime = null;
                            _dropdownValue = "Appointment";
                            _petdropdownValue = userPetsNames[0];
                            _petSelecteddropdownValue = '';
                            _selectedEvents.value =
                                _getEventsForDay(_selectedDay!);
                            // Navigator.of(context).pop();
                          },
                          child: const Text("Submit"))
                    ],
                  );
                });
          }),
      body: Column(
        children: [
          TableCalendar(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              // Use `selectedDayPredicate` to determine which day is currently selected.
              // If this returns true, then `day` will be marked as selected.

              // Using `isSameDay` is recommended to disregard
              // the time-part of compared DateTime objects.
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                // Call `setState()` when updating calendar format
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              // No need to call `setState()` here
              _focusedDay = focusedDay;
            },
            eventLoader: _getEventsForDay,
          ),
          const SizedBox(
            height: 8.0,
          ),
          Expanded(
            child: ValueListenableBuilder<List<CalendarModel>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(),
                          ),
                          child: ListTile(
                              title: Text(
                                  '${value[index].title} (${value[index].appointmentType}) [${value[index].petName}]'),
                              subtitle: Text(
                                  '${DateFormat('dd-MM-yyyy').format(value[index].startDateTime!)} - ${DateFormat('dd-MM-yyyy').format(value[index].endDateTime!)}\n${DateFormat('jm').format(value[index].startDateTime!)} - ${DateFormat('jm').format(value[index].endDateTime!)}'),
                              trailing: PopupMenuButton<CalendarMenu>(
                                  onSelected: (CalendarMenu item) {
                                    if (item == CalendarMenu.DeleteCalendar) {
                                      ref
                                          .read(calendarControllerProvider
                                              .notifier)
                                          .deleteCalendar(
                                              value[index], context);
                                    }
                                  },
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<CalendarMenu>>[
                                        const PopupMenuItem<CalendarMenu>(
                                          value: CalendarMenu.DeleteCalendar,
                                          child: Text('Delete'),
                                        ),
                                      ])));
                    },
                  );
                }),
          )
        ],
      ),
    );
  }
}
