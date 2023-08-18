class Unit {
  int id;
  String description ;
  dynamic nos;
  dynamic formalName;
  dynamic unitUnder ;
  dynamic isSimple;
  dynamic  groupUnder;



  Unit({
    required this.id,
    required this.description ,
    this.nos,
    this.formalName,
    this.unitUnder ,
    this.isSimple,
    this. groupUnder,
  });

  factory Unit.fromJson(Map<String, dynamic> parsedJson){
    return Unit(
      id: parsedJson["id"].toInt(),
      description:parsedJson["description"].toString(),
      nos: parsedJson["nos"].toString(),
      formalName: parsedJson["formalName"].toString(),
      unitUnder: parsedJson["unitUnder"].toString(),
      isSimple: parsedJson["isSimple"].toString(),
      groupUnder: parsedJson["groupUnder"].toString(),
    );
  }
}

