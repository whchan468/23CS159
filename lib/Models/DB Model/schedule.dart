class Schedule {
  int mid;
  String mname;
  int med_datetime;
  int dosage;

  Schedule(
      {required this.mid,
      required this.mname,
      required this.med_datetime,
      required this.dosage});

  Map<String, dynamic> toJson() {
    return {
      'mid': mid,
      'mname': mname,
      'med_datetime': med_datetime,
      'dosage': dosage,
    };
  }

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      mid: json['mid'] as int,
      mname: json['mname'],
      med_datetime: json['med_datetime'],
      dosage: json['dosage'],
    );
  }
}
