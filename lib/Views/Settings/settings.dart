import 'package:flutter/material.dart';
import 'package:medireminder/Widget/time_picker.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<StatefulWidget> createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const Center(
                  child: Text(
                "Settings",
                style: TextStyle(fontSize: 30),
              )),

              const SizedBox(
                height: 20,
              ),

              //    Wake Up Time
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(5)),
                child: ListTile(
                  leading: const Text(
                    "Wake Up Time: ",
                    style: TextStyle(fontSize: 17),
                  ),
                  trailing: TimePicker(keyname: 'wtime'),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              //    Breakfast Time
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(5)),
                child: ListTile(
                  leading: const Text(
                    "Breakfast Time: ",
                    style: TextStyle(fontSize: 17),
                  ),
                  trailing: TimePicker(keyname: 'mtime0'),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              //    Lunch Time

              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(5)),
                child: ListTile(
                  leading: const Text(
                    "Lunch Time: ",
                    style: TextStyle(fontSize: 17),
                  ),
                  trailing: TimePicker(keyname: 'mtime1'),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              //    Dinner Time

              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(5)),
                child: ListTile(
                  leading: const Text(
                    "Dinner Time: ",
                    style: TextStyle(fontSize: 17),
                  ),
                  trailing: TimePicker(keyname: 'mtime2'),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              //    Bed Time
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(5)),
                child: ListTile(
                  leading: const Text(
                    "Bed Time: ",
                    style: TextStyle(fontSize: 17),
                  ),
                  trailing: TimePicker(keyname: 'btime'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
