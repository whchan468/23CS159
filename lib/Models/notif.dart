class Notif {
  String name;
  DateTime dateTime;
  int dosage;
  String remarks;
  int mid;
  bool snoozed;

  Notif(
      {required this.name,
      required this.dateTime,
      required this.dosage,
      required this.remarks,
      required this.mid,
      this.snoozed = false});
}
