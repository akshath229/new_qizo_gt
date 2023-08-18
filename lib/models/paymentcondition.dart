class PaymentCondition {
  late int id;
  late String conDescription;
  late int conUserId;
  late int conBaranchId;
//  List<Null> tsalesOrderHeader;

  PaymentCondition(
      {required this.id,
        required this.conDescription,
        required this.conUserId,
        required this.conBaranchId,
//        this.tsalesOrderHeader
      });

  PaymentCondition.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    conDescription = json['conDescription'];
    conUserId = json['conUserId'];
    conBaranchId = json['conBaranchId'];
//    if (json['tsalesOrderHeader'] != null) {
//      tsalesOrderHeader = new List<Null>();
//      json['tsalesOrderHeader'].forEach((v) {
//        tsalesOrderHeader.add(new Null.fromJson(v));
//      });
//    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['conDescription'] = this.conDescription;
    data['conUserId'] = this.conUserId;
    data['conBaranchId'] = this.conBaranchId;
//    if (this.tsalesOrderHeader != null) {
//      data['tsalesOrderHeader'] =
//          this.tsalesOrderHeader.map((v) => v.toJson()).toList();
//    }
    return data;
  }
}
