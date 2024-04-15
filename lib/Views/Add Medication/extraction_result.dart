import 'dart:async';

import 'package:flutter/material.dart';
import 'package:medireminder/Models/med_form.dart';
import 'package:medireminder/View%20Models/vm_add_med.dart';
import 'package:medireminder/View%20Models/vm_save_record.dart';
import 'package:medireminder/Views/Add%20Medication/datetime_picker.dart';
import 'package:medireminder/Views/Add%20Medication/schedule_result.dart';
import 'package:medireminder/service_locator.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class ExtractionResult extends StatefulWidget {
  const ExtractionResult({super.key});

  @override
  State<StatefulWidget> createState() => ExtractionResultState();
}

class ExtractionResultState extends State<ExtractionResult> {
  final formKey = GlobalKey<FormState>();
  final vmAddMed = serviceLocator.get<VMAddMed>();
  final vmSaveRecord = serviceLocator.get<VMSaveRecord>();
  late Future<MedForm?> _future;
  String _name = "";
  String _freq = "";
  String _times = "";
  String _dosage = "";
  String _duration = "";
  List<String> _remark = [];

  @override
  void initState() {
    super.initState();
    _future = vmAddMed.extractText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
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
                child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        //    Image
                        // if (vmAddMed.imageFile != null)
                        //   Image.file(
                        //     File(vmAddMed.imageFile!.path),
                        //     width: 150,
                        //     height: 200,
                        //   ),

                        // const SizedBox(
                        //   height: 20,
                        // ),

                        // Testing Preview
                        //Text("${vmAddMed.resultText}"),
                        // Text("${vmAddMed.translatedText}"),
                        // Text("${vmAddMed.medForm.name}"),
                        const SizedBox(
                          height: 20,
                        ),
                        //    Name
                        TextFormField(
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Name",
                          ),
                          initialValue: snapshot.data?.name ?? "",
                          onSaved: (newValue) {
                            setState(() {
                              _name = newValue!;
                            });
                          },
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        //    Frequency and Times
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Frequency (hours)",
                          ),
                          initialValue: snapshot.data?.freq.toString() ?? "",
                          onSaved: (newValue) {
                            setState(() {
                              _freq = newValue!;
                            });
                          },
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Times per Day",
                          ),
                          initialValue: snapshot.data?.times.toString() ?? "",
                          onSaved: (newValue) {
                            setState(() {
                              _times = newValue!;
                            });
                          },
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        //    Dosage
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Dosage",
                          ),
                          initialValue: snapshot.data?.dosage.toString() ?? "",
                          onSaved: (newValue) {
                            setState(() {
                              _dosage = newValue!;
                            });
                          },
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        //    Duration (Days)
                        TextFormField(
                          keyboardType: TextInputType.datetime,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Duration (Days)",
                          ),
                          initialValue: "",
                          onSaved: (newValue) {
                            setState(() {
                              _duration = newValue!;
                            });
                          },
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(width: 1),
                              borderRadius: BorderRadius.circular(5)),
                          child: ListTile(
                            leading: const Text(
                              "Start Date and Time: ",
                              style: TextStyle(fontSize: 17),
                            ),
                            trailing: DateTimePicker(),
                          ),
                        ),

                        Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data != null
                                ? snapshot.data!.remark.length
                                : 0,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: TextFormField(
                                  keyboardType: TextInputType.name,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Remarks",
                                  ),
                                  initialValue:
                                      snapshot.data?.remark[index] ?? "",
                                  onSaved: (newValue) {
                                    setState(() {
                                      if (!_remark.contains(newValue))
                                        _remark.add(newValue!);
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),

                        //    Submit Button
                        ElevatedButton(
                            onPressed: () {
                              formKey.currentState!.save();
                              if (_name.isNotEmpty) {
                                vmSaveRecord.setValue(mname: _name);
                              }
                              if (_freq.isNotEmpty) {
                                vmSaveRecord.setValue(freq: int.parse(_freq));
                              }
                              if (_times.isNotEmpty) {
                                vmSaveRecord.setValue(times: int.parse(_times));
                              }
                              if (_dosage.isNotEmpty) {
                                vmSaveRecord.setValue(
                                    dosage: int.parse(_dosage));
                              }
                              if (_duration.isNotEmpty) {
                                vmSaveRecord.setValue(
                                    duration: int.parse(_duration));
                              }
                              if (_remark.isNotEmpty) {
                                vmSaveRecord.setValue(remark: _remark);
                              }
                              if (vmSaveRecord.sdate == null) {
                                vmSaveRecord.setValue(sdate: DateTime.now());
                              }

                              PersistentNavBarNavigator.pushNewScreen(context,
                                  screen: ScheduleResult());
                            },
                            child: const Text("Confirm and Submit")),
                      ],
                    )),
              );
            }),
      ),
    );
  }
}
