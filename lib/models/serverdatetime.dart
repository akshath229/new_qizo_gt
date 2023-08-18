class ServerDate {
  late String workingDate;
  late String workingTime;

  ServerDate({required this.workingDate, required this.workingTime});

  ServerDate.fromJson(Map<String, dynamic> json) {
    workingDate = json['workingDate'];
    workingTime = json['workingTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['workingDate'] = this.workingDate;
    data['workingTime'] = this.workingTime;
    return data;
  }
}
