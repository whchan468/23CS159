// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:medireminder/Services/s_storage.dart';
import 'package:intl/intl.dart';

class TimePicker extends StatefulWidget {
  String keyname;
  @override
  TimePicker({super.key, required this.keyname});

  @override
  State<StatefulWidget> createState() => TimePickerState();
}

class TimePickerState extends State<TimePicker> {
  DateTime _dateTime = DateTime.now();
  late final SStorage sStorage;
  final f = DateFormat('HH:mm');
  @override
  void initState() {
    super.initState();
  }

  Future<DateTime> loadData() async {
    sStorage = SStorage.getInstance();
    _dateTime = await sStorage.getTime(widget.keyname);
    return _dateTime;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: loadData(),
        builder: (context, snapshot) {
          return FittedBox(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                    onPressed: () async {
                      final time = await pickTime();
                      if (time != null) {
                        setState(() {
                          _dateTime =
                              DateTime(2000, 1, 1, time.hour, time.minute);
                          insertTime(_dateTime);
                        });
                      }
                    },
                    child: Text(f.format(_dateTime)))),
          );
        });
  }

  insertTime(DateTime d) {
    sStorage.insertTime(widget.keyname, d);
  }

  Future<TimeOfDay?> pickTime() => showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_dateTime),
      );
}
