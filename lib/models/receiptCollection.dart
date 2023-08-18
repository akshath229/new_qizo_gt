class ReceiptCollection {

  late double rdAmount;
  late String rdRemarks;
  dynamic rdImgPath;
  dynamic rdtransactionType;

  ReceiptCollection({required this.rdAmount,required this.rdRemarks,this.rdImgPath,
  this.rdtransactionType});

  Map<String, dynamic> toJson()=>Map.from({
    "rdAmount": rdAmount, // double -> String
    "rdRemarks": rdRemarks,
    "rdImgPath": rdImgPath,
    "rdtransactionType":rdtransactionType
  });

  factory ReceiptCollection.fromJson(Map<String, dynamic> parsedJson){
    return ReceiptCollection(

      rdAmount: parsedJson["rdAmount"].toDouble(), // String -> double
      rdRemarks:parsedJson["rdRemarks"].toString(),
      rdImgPath:parsedJson["rdImgPath"],
      rdtransactionType: parsedJson['rdtransactionType']

    );
  }
}

