class ExpenseAdd {
  int esdSlno;
  String esParticulars;
  double esAmount;
  dynamic esImagePath;


  ExpenseAdd({required this.esdSlno,required this.esParticulars,required this.esAmount,this.esImagePath});


  factory ExpenseAdd.fromJson(Map<String, dynamic> parsedJson){
    return ExpenseAdd(

      esdSlno: parsedJson["esdSlno"].toInt(),
      esParticulars:parsedJson["esParticulars"].toString(),
      esAmount: parsedJson["esAmount"].toDouble(),
      esImagePath:parsedJson["esImagePath"],

    );
  }
}

