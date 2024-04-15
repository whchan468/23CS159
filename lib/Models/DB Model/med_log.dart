class MedLog {
  int mid;
  int take_time;
  int exp_time;
  bool snoozed;

  MedLog(
      {required this.mid,
      required this.take_time,
      required this.exp_time,
      required this.snoozed});

  Map<String, dynamic> toJson() {
    return {
      'mid': mid,
      'take_time': take_time,
      'exp_time': exp_time,
      'snoozed': snoozed,
    };
  }

  factory MedLog.fromJson(Map<String, dynamic> json) {
    return MedLog(
      mid: json['mid'],
      take_time: json['take_time'],
      exp_time: json['exp_time'],
      snoozed: json['snoozed'],
    );
  }
}
