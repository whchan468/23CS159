import 'package:flutter/material.dart';
import 'package:medireminder/Models/DB%20Model/med_info.dart';
import 'package:medireminder/Models/DB%20Model/remark.dart';
import 'package:medireminder/Models/DB%20Model/schedule.dart';
import 'package:medireminder/Models/notif.dart';
import 'package:medireminder/Services/s_database.dart';
import 'package:medireminder/Services/s_notification.dart';
import 'package:medireminder/Services/s_scheduler.dart';
import 'package:medireminder/Services/s_storage.dart';

class VMSaveRecord extends ChangeNotifier {
  String? _mname;
  int? _freq;
  int? _times;
  int? _dosage;
  DateTime? _sdate;
  DateTime? _edate;
  int? _duration;
  List<String> _remark = [];
  List<Schedule> _scheduleList = [];
  List<Notif> _notifList = [];

  String? get mname => _mname;
  int? get freq => _freq;
  int? get times => _times;
  int? get dosage => _dosage;
  DateTime? get sdate => _sdate;
  DateTime? get edate => _edate;
  int? get duration => _duration;
  List<String> get remark => _remark;

  setValue({
    String? mname,
    int? freq,
    int? times,
    int? dosage,
    DateTime? sdate,
    DateTime? edate,
    int? duration,
    List<String>? remark,
  }) {
    mname != null ? _mname = mname : {};
    freq != null ? _freq = freq : {};
    times != null ? _times = times : {};
    dosage != null ? _dosage = dosage : {};
    sdate != null ? _sdate = sdate : {};
    edate != null ? _edate = edate : {};
    duration != null ? _duration = duration : {};
    remark != null ? _remark = remark : {};
  }

  Future<List<Notif>> addRecord() async {
    if (_duration != null && _sdate != null) {
      _edate = _sdate!.add(Duration(days: _duration!));
    }
    int sdate = _sdate!.millisecondsSinceEpoch;
    int edate = _edate!.millisecondsSinceEpoch;

    //    add medinfo table entry
    await addMedInfoEntry(MedInfo(
        mname: _mname!,
        freq: _freq!,
        times: _times!,
        dosage: _dosage!,
        sdate: sdate,
        edate: edate));

    //    get mid from medinfo
    var mid = await SDataBase().getmid(_mname!);
    //  var mid = 1;

    //    add remarks table entries

    if (remark.isNotEmpty) {
      for (var r in _remark) {
        if (r.isNotEmpty) {
          await addRemarksEntry(Remark(mid: mid, remarks: r));
        }
      }
    }

    //    get meal time, wakeup time and bed time from storage
    final sStorage = SStorage.getInstance();
    final List<DateTime> mealTime = [];
    final wtime = await sStorage.getTime('wtime');
    final btime = await sStorage.getTime('btime');
    for (int i = 0; i < 3; i++) {
      mealTime.add(await sStorage.getTime('mtime$i'));
    }

    //    Medication Scheduling using SScheduler
    List<DateTime> scheduleList = SScheduler.scheduleTask(
        _freq!, _times!, _sdate!, _edate!, wtime, btime, mealTime, _remark);

    List<Notif> notifList = [];
    List<Schedule> slist = [];
    for (DateTime schedule in scheduleList) {
      //    create and schedule reminder notifications accordingly
      Notif n = Notif(
          name: _mname!,
          dateTime: schedule,
          dosage: _dosage!,
          remarks: _remark.isNotEmpty ? _remark.first : '',
          mid: mid);
      notifList.add(n);

      //    create schedule entries and add them to schedule table
      Schedule s = Schedule(
          mid: mid,
          mname: _mname!,
          med_datetime: schedule.millisecondsSinceEpoch,
          dosage: _dosage!);
      slist.add(s);
    }
    _scheduleList = slist;
    setNotif(notifList);

    return notifList;
  }

  void setNotif(List<Notif> n) {
    _notifList = n;
    notifyListeners();
  }

  Future<void> confirmSchedule() async {
    for (Notif n in _notifList) {
      await createReminder(n);
    }
  }

  Future<void> addMedInfoEntry(MedInfo entry) async {
    await SDataBase().addToMedInfo(entry);
  }

  Future<void> addRemarksEntry(Remark entry) async {
    await SDataBase().addToRemarks(entry);
  }

  Future<List<MedInfo>> getMedInfo() async {
    var medList = await SDataBase().getMedInfo();
    return medList;
  }

  Future<void> addschedule() async {
    for (var s in _scheduleList) {
      await SDataBase().addToSchedule(s);
    }
  }

  Future<void> createReminder(Notif n) async {
    await SNotification.createScheduleNotification(n);
  }
}
