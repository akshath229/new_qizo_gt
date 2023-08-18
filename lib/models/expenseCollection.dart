

class ExpenseCollect {
  int esdSlno;
  String esParticulars;
  double esAmount;
  dynamic esImagePath;

//    "esdSlno": 2,
//    "esParticulars": "water ",
//    "esAmount": 190.00,
//    "esImagePath": null


  ExpenseCollect(
      {required this.esdSlno, required this.esParticulars, required this.esAmount, this.esImagePath});

  Map<String, dynamic> toJson() =>
      Map.from({
        "esdSlno": esdSlno, // double -> String
        "esParticulars": esParticulars,
        "esAmount": esAmount,
        "esImagePath": esImagePath
      });

  factory ExpenseCollect.fromJson(Map<String, dynamic> parsedJson){
    return ExpenseCollect(

      esdSlno: parsedJson["esdSlno"].toInt(),
      esParticulars: parsedJson["esParticulars"].toString(),
      esAmount: parsedJson["esAmount"].toDouble(),
      esImagePath: parsedJson["esImagePath"],

    );
  }

}








