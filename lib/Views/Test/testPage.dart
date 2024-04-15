import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:medireminder/Models/DB%20Model/med_info.dart';
import 'package:medireminder/Models/DB%20Model/schedule.dart';
import 'package:medireminder/Services/s_database.dart';
import 'package:medireminder/Services/s_text_extract.dart';
import 'package:file_picker/file_picker.dart';
import 'package:medireminder/service_locator.dart';
import 'package:sqflite/sqflite.dart';

class TestPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TestPageState();
}

class TestPageState extends State<TestPage> {
  late List<MedInfo> medinfo;
  late List<Schedule> schedule;
  late int mid;
  late bool isLoading;
  FilePickerResult? result;

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  Future refreshData() async {
    setState(() {
      isLoading = true;
    });
    medinfo = await SDataBase.instance.getMedInfo();
    schedule = await SDataBase.instance.getSchedule();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: isLoading
                ? CircularProgressIndicator()
                : medinfo.isEmpty
                    ? Text('no data')
                    : datalist(),
          ),
          ElevatedButton(
              onPressed: () async {
                MedInfo entry = MedInfo(
                  mname: 'test1',
                  dosage: 1,
                  freq: 1,
                  times: 1,
                  sdate: 1,
                  edate: 1,
                );
                await SDataBase.instance.addToMedInfo(entry);
                refreshData();
              },
              child: Text('add medinfo')),
          ElevatedButton(
              onPressed: () async {
                Schedule entry = Schedule(
                  mid: 1,
                  mname: 'test1',
                  med_datetime: 1,
                  dosage: 1,
                );
                await SDataBase.instance.addToSchedule(entry);
                refreshData();
              },
              child: Text('add schedule')),
          ElevatedButton(
              onPressed: () async {
                await SDataBase.instance.deleteMedInfo(null);
                refreshData();
              },
              child: Text('delete medinfo')),
          ElevatedButton(
              onPressed: () async {
                await SDataBase.instance.deleteSchedule(null);
                refreshData();
              },
              child: Text('delete schedule')),
          Center(
            child: isLoading
                ? CircularProgressIndicator()
                : medinfo.isEmpty
                    ? Text('no data')
                    : schlist(),
          ),
        ],
      ),
    );
  }

  Widget datalist() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: medinfo.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(
              "${medinfo[index].mid}, ${medinfo[index].mname}, ${medinfo[index].freq}, ${medinfo[index].dosage},"),
        );
      },
    );
  }

  Widget schlist() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: schedule.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(
              "${schedule[index].mid}, ${schedule[index].mname}, ${schedule[index].med_datetime}, ${medinfo[index].dosage},"),
        );
      },
    );
  }
}
