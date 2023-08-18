class Customer {
  int id;
  String lhName;
  String lhGroupId;


  Customer({required this.id,required this.lhName,required this.lhGroupId});

  factory Customer.fromJson(Map<String, dynamic> parsedJson){
    return Customer(
      id: parsedJson["id"].toInt(),
      lhName:parsedJson["lhName"].toString(),
      lhGroupId: parsedJson["lhGroupId"].toString(),
     );
  }
}

