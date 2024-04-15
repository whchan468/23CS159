class Remark {
  int mid;
  String remarks;

  Remark({required this.mid, required this.remarks});

  Map<String, dynamic> toJson() {
    return {
      'mid': mid,
      'remarks': remarks,
    };
  }

  factory Remark.fromJson(Map<String, dynamic> json) {
    return Remark(
      mid: json['mid'],
      remarks: json['remarks'],
    );
  }
}
