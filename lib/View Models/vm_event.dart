import 'package:flutter/material.dart';
import 'package:medireminder/Models/med_event.dart';
import 'package:medireminder/Services/s_database.dart';

class VMEvent extends ChangeNotifier {
  late List<MedEvent> _eventList;
  late DateTime _day;

  List<MedEvent> get eventList => _eventList;
  DateTime get day => _day;

  setDay(DateTime d) {
    _day = d;
    notifyListeners();
  }

  Future<List<MedEvent>> getSchedule() async {
    List<MedEvent> events = [];
    final scheduleList = await SDataBase.instance.getSchedule();
    for (var schedule in scheduleList) {
      final mname = schedule.mname;
      final dose = schedule.dosage;
      final time = DateTime.fromMillisecondsSinceEpoch(schedule.med_datetime);
      //List list = await SDataBase.instance.getRemarks(schedule.mid);
      //final remarks = list.firstOrNull;
      events.add(MedEvent(title: mname, dose: dose, time: time, remarks: ''));
    }
    return events;
  }

  Future<Map<DateTime, List<MedEvent>>> getEvents() async {
    Map<DateTime, List<MedEvent>> map = {};
    List<MedEvent> events = await getSchedule();
    for (MedEvent event in events) {
      if (map.keys.contains(event.time)) {
        map[event.time]!.add(event);
      } else {
        map[event.time] = [event];
      }
    }
    return map;
  }
}
