import 'dart:core';

class MedForm {
  String? name;
  int? freq;
  int? times;
  DateTime? sdate;
  DateTime? edate;
  int? dosage;
  List<String?> remark;

  MedForm({
    this.name = "",
    this.freq = 0,
    this.times = 0,
    this.dosage = 0,
    this.sdate = null,
    this.edate = null,
    this.remark = const [],
  });

  // @override
  // String toString() {
  //   return name! + "\n" + freq.toString() + "\n" + dosage.toString() + "\n";
  // }
}
