
//
// "": 31,
// "": 2.0,
// "relSalesLoadingBarcodeDetails": [
// {
// "SlbBarcode":"BC101"
// },
// {
// "SlbBarcode":"BC102"
// }
// ]

class SalesLoadingViewPostData {
  dynamic tldItemId;
  dynamic tldQty;
  // dynamic SlbBarcode;
  List<RelSalesLoadingBarcodeDetails> relSalesLoadingBarcodeDetails = [];


  SalesLoadingViewPostData({this.tldItemId, this.tldQty,required this.relSalesLoadingBarcodeDetails});

  SalesLoadingViewPostData.fromJson(Map<String, dynamic> json) {
    tldItemId = json['tldItemId'];
    tldQty = json['tldQty'];
    relSalesLoadingBarcodeDetails = json['relSalesLoadingBarcodeDetails'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tldItemId'] = this.tldItemId;
    data['tldQty'] = this.tldQty;
    data['relSalesLoadingBarcodeDetails'] = this.relSalesLoadingBarcodeDetails;
    return data;
  }
}


class RelSalesLoadingBarcodeDetails {
  late String slbBarcode;
  late int SlbLoadingDetailsId;

  RelSalesLoadingBarcodeDetails({required this.slbBarcode,
  required this.SlbLoadingDetailsId});


  RelSalesLoadingBarcodeDetails.fromJson(Map<String, dynamic> json) {
    slbBarcode = json['tldItemId'];
    SlbLoadingDetailsId = json['SlbLoadingDetailsId'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slbBarcode'] = this.slbBarcode;
    data['SlbLoadingDetailsId'] = this.SlbLoadingDetailsId;
    return data;
  }

}








