

class ReceiptAdd {
  dynamic slNo;
  double receivedAmount;
  String remarks;
  dynamic image;
  dynamic rdtransactionType;



  ReceiptAdd({this.slNo,required this.receivedAmount,required this.remarks,this.image,this.rdtransactionType});

  factory ReceiptAdd.fromJson(Map<String, dynamic> parsedJson){
    return ReceiptAdd(

        slNo: parsedJson["slNo"],
        receivedAmount:parsedJson["receivedAmount"].toDouble(),
        remarks: parsedJson["remarks"].toString(),
        image:parsedJson["image"],
      rdtransactionType: parsedJson['rdtransactionType']

    );
  }
}

