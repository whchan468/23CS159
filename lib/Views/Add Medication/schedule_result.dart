import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medireminder/Models/notif.dart';
import 'package:medireminder/View%20Models/vm_save_record.dart';
import 'package:medireminder/service_locator.dart';

class ScheduleResult extends StatefulWidget {
  const ScheduleResult({super.key});

  @override
  State<StatefulWidget> createState() => ScheduleResultState();
}

class ScheduleResultState extends State<ScheduleResult> {
  final vmSaveRecord = serviceLocator.get<VMSaveRecord>();
  late final Future<List<Notif>> _future;
  final f = DateFormat('dd/MM/yyyy HH:mm');
  @override
  void initState() {
    _future = vmSaveRecord.addRecord();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Column(
        children: [
          //    Test Text
          // Text(
          //     '${vmSaveRecord.mname}, ${vmSaveRecord.freq}, ${vmSaveRecord.times}, ${vmSaveRecord.dosage}, ${vmSaveRecord.duration}, ${vmSaveRecord.sdate}, ${vmSaveRecord.remark}'),
          const Center(
              child: Text(
            "Generated Schedule",
            style: TextStyle(fontSize: 30),
          )),
          FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                // loading screen
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                );
              }
              return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.builder(
                      //scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount:
                          snapshot.data != null ? snapshot.data!.length : 0,
                      itemBuilder: (context, index) {
                        if (snapshot.data != null) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ListTile(
                                minVerticalPadding: 15,
                                tileColor:
                                    const Color.fromARGB(255, 91, 106, 192),
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                title: Text(snapshot.data![index].name),
                                subtitle: Text(
                                    '${snapshot.data![index].dosage} dose     ${snapshot.data![index].remarks}'),
                                trailing: Text(
                                    f.format(snapshot.data![index].dateTime),
                                    style: const TextStyle(fontSize: 17))),
                          );
                        } else {
                          return const Center(
                              child: Text('No schedule created',
                                  style: TextStyle(fontSize: 20)));
                        }
                      }));
            },
          ),

          ElevatedButton(
              onPressed: () async {
                await vmSaveRecord.addschedule();
                await vmSaveRecord.confirmSchedule();
                await showDialog(
                    context: context,
                    builder: (BuildContext context) => Dialog(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Create Success',
                                    style: TextStyle(fontSize: 17)),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Close',
                                        style: TextStyle(fontSize: 15)))
                              ],
                            ),
                          ),
                        ));
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Create Notifcation',
                  style: TextStyle(fontSize: 17))),
        ],
      ),
    )));
  }

  deleteSchedule(int index) {}
}
