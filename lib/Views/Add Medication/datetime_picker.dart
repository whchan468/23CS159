import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medireminder/View%20Models/vm_save_record.dart';
import 'package:medireminder/service_locator.dart';

class DateTimePicker extends StatefulWidget {
  const DateTimePicker({super.key});

  @override
  State<StatefulWidget> createState() => DateTimePickerState();
}

class DateTimePickerState extends State<DateTimePicker> {
  final vmSaveRecord = serviceLocator.get<VMSaveRecord>();
  final f = DateFormat('dd/MM/yyyy HH:mm');
  DateTime _dateTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          final date = await pickDate();
          if (date != null) {
            final time = await pickTime();
            if (time != null) {
              setState(() {
                _dateTime = DateTime(
                    date.year, date.month, date.day, time.hour, time.minute);
                vmSaveRecord.setValue(sdate: _dateTime);
              });
            }
          }
        },
        child: Text(f.format(_dateTime)));
  }

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2024),
      lastDate: DateTime(2100));

  Future<TimeOfDay?> pickTime() => showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_dateTime),
      );
}
