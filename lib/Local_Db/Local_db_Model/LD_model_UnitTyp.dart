
class LD_Model_UnitTyp {
  LD_Model_UnitTyp({
    required this.id,
    required this.Local_id,
    this.description,
    this.nos,
  });

  int id;
  int Local_id;
  dynamic description;
  dynamic nos;

  factory LD_Model_UnitTyp.fromJson(Map<String, dynamic> json) => LD_Model_UnitTyp(
    id: json["id"],
    Local_id: json["Local_id"],
    description: json["description"],
    nos: json["nos"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "Local_id": Local_id,
    "description": description,
    "nos": nos,
  };

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'Local_id' : Local_id,
      'description' : description,
      'nos' : nos,
    };
  }

}


class LD_Model_UnitTyps {
  LD_Model_UnitTyps({
    required this.id,
    required this.unitId,
    required this.itemid,
    required this.mrp,
    required this.srate,
    required this.prate,
    this.description
  });
  int id;
  int unitId;
  int itemid;
  double mrp;
  double srate;
  double prate;
  dynamic description;

  factory LD_Model_UnitTyps.fromJson(Map<String, dynamic> json) => LD_Model_UnitTyps(
    id: json["id"],
    unitId: json["unitId"],
    itemid: json["itemid"],
    mrp: json["mrp"],
    srate: json["srate"],
    prate: json["prate"],
    description: json["description"],
  );



  Map<String, dynamic> toJson() => {
    "id": id,
    "unitId": unitId,
    "itemid": itemid,
    "mrp" : mrp,
    "srate": srate,
    "prate": prate,
    "description": description
  };

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "unitid": unitId,
      "itemid": itemid,
      "mrp" : mrp,
      "srate": srate,
      "prate": prate,
      "description": description

    };
  }

}
