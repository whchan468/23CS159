class MedInfo {
  int? mid;
  String mname;
  int freq;
  int times;
  int dosage;
  int sdate;
  int edate;

  MedInfo({
    mid,
    required this.mname,
    required this.freq,
    required this.times,
    required this.dosage,
    required this.sdate,
    required this.edate,
  });

  MedInfo copy({
    int? mid,
    String? mname,
    int? freq,
    int? times,
    int? dosage,
    int? sdate,
    int? edate,
  }) =>
      MedInfo(
        mid: mid ?? this.mid,
        mname: mname ?? this.mname,
        freq: freq ?? this.freq,
        times: times ?? this.times,
        dosage: dosage ?? this.dosage,
        sdate: sdate ?? this.sdate,
        edate: edate ?? this.edate,
      );

  Map<String, dynamic> toJson() {
    return {
      'mid': mid,
      'mname': mname,
      'freq': freq,
      'times': times,
      'dosage': dosage,
      'sdate': sdate,
      'edate': edate,
    };
  }

  factory MedInfo.fromJson(Map<String, dynamic> json) {
    return MedInfo(
        mid: json['mid'] as int,
        mname: json['mname'],
        freq: json['freq'],
        times: json['times'],
        dosage: json['dosage'],
        sdate: json['sdate'],
        edate: json['edate']);
  }
}
