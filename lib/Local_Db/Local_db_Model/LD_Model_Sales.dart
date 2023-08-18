

class LD_Model_Sales {
  LD_Model_Sales({
    required this.voucherDate,
    this.orderHeadId,
    this.orderDate,
    this.expDate,
    this.ledgerId,
    required this.partyName,
    this.address1,
    this.address2,
    this.gstNo,
    this.phone,
    this.shipToName,
    this.shipToAddress1,
    this.shipToAddress2,
    this.shipToPhone,
    required this.narration,
    required this.amount,
    required this.userId,
    required this.branchId,
    required this.otherAmt,
    required this.discountAmt,
    this.creditPeriod,
    required this.paymentCondition,
    required this.paymentType,
    required this.invoiceType,
    this.invoicePrefix,
    this.invoiceSuffix,
    this.cancelFlg,
    this.entryDate,
    this.slesManId,
    required this.branchUpdated,
    this.Machinecode,
    this.SyncVoucherNo,
    required this.saleTypeInterState,
    required this.vansalepaymenttypes,
    required this.salesDetails,
    required this.salesExpense,
  });

  String voucherDate;
  dynamic orderHeadId;
  dynamic orderDate;
  dynamic expDate;
  dynamic ledgerId;
  String partyName;
  dynamic address1;
  dynamic address2;
  dynamic gstNo;
  dynamic phone;
  dynamic shipToName;
  dynamic shipToAddress1;
  dynamic shipToAddress2;
  dynamic shipToPhone;
  String narration;
  double amount;
  int userId;
  int branchId;
  double otherAmt;
  double discountAmt;
  dynamic creditPeriod;
  String paymentCondition;
  int paymentType;
  String invoiceType;
  dynamic invoicePrefix;
  dynamic invoiceSuffix;
  dynamic cancelFlg;
  dynamic entryDate;
  dynamic slesManId;
  bool branchUpdated;
  var Machinecode;
  var SyncVoucherNo;
  bool saleTypeInterState;
  List<Vansale_PaymentTypes> vansalepaymenttypes;
  List<SalesDetail> salesDetails;
  List<dynamic> salesExpense;

  factory LD_Model_Sales.fromJson(Map<String, dynamic> json) => LD_Model_Sales(
    voucherDate: json["voucherDate"],
    orderHeadId: json["orderHeadId"],
    orderDate: json["orderDate"],
    expDate: json["expDate"],
    ledgerId: json["ledgerId"],
    partyName: json["partyName"],
    address1: json["address1"],
    address2: json["address2"],
    gstNo: json["gstNo"],
    phone: json["phone"],
    shipToName: json["shipToName"],
    shipToAddress1: json["shipToAddress1"],
    shipToAddress2: json["shipToAddress2"],
    shipToPhone: json["shipToPhone"],
    narration: json["narration"],
    amount: json["amount"],
    userId: json["userId"],
    branchId: json["branchId"],
    otherAmt: json["otherAmt"],
    discountAmt: json["discountAmt"],
    creditPeriod: json["creditPeriod"],
    paymentCondition: json["paymentCondition"],
    paymentType: json["paymentType"],
    invoiceType: json["invoiceType"],
    invoicePrefix: json["invoicePrefix"],
    invoiceSuffix: json["invoiceSuffix"],
    cancelFlg: json["cancelFlg"],
    entryDate: json["entryDate"],
    slesManId: json["slesManId"],
    Machinecode: json["Machinecode"],
    SyncVoucherNo : json["SyncVoucherNo"],
    branchUpdated: json["branchUpdated"],
    saleTypeInterState: json["saleTypeInterState"],
    vansalepaymenttypes: List<Vansale_PaymentTypes>.from(json["vansalepaymenttypes"].map((x) => Vansale_PaymentTypes.fromJson(x))),
    salesDetails: List<SalesDetail>.from(json["salesDetails"].map((x) => SalesDetail.fromJson(x))), salesExpense: [],
   // salesExpense: List<dynamic>.from(json["salesExpense"].map((x) => x)),
  );



  Map<String, dynamic> toJson() => {
    "voucherDate": voucherDate,
    "orderHeadId": orderHeadId,
    "orderDate": orderDate,
    "expDate": expDate,
    "ledgerId": ledgerId,
    "partyName": partyName,
    "address1": address1,
    "address2": address2,
    "gstNo": gstNo,
    "phone": phone,
    "shipToName": shipToName,
    "shipToAddress1": shipToAddress1,
    "shipToAddress2": shipToAddress2,
    "shipToPhone": shipToPhone,
    "narration": narration,
    "amount": amount,
    "userId": userId,
    "branchId": branchId,
    "otherAmt": otherAmt,
    "discountAmt": discountAmt,
    "creditPeriod": creditPeriod,
    "paymentCondition": paymentCondition,
    "paymentType": paymentType,
    "invoiceType": invoiceType,
    "invoicePrefix": invoicePrefix,
    "invoiceSuffix": invoiceSuffix,
    "cancelFlg": cancelFlg,
    "entryDate": entryDate,
    "slesManId": slesManId,
    "branchUpdated": branchUpdated,
    "saleTypeInterState": saleTypeInterState,
    "Machinecode": Machinecode,
    "SyncVoucherNo": SyncVoucherNo,
    "vansalepaymenttypes": List<dynamic>.from(vansalepaymenttypes.map((x) => x.toJson())),
    "salesDetails": List<dynamic>.from(salesDetails.map((x) => x.toJson())),
    "salesExpense": List<dynamic>.from(salesExpense.map((x) => x)),
  };



  Map<String, dynamic> toMap() {
    return {
      "voucherDate": voucherDate,
      "orderHeadId": orderHeadId,
      "orderDate": orderDate,
      "expDate": expDate,
      "ledgerId": ledgerId,
      "partyName": partyName,
      "address1": address1,
      "address2": address2,
      "gstNo": gstNo,
      "phone": phone,
      "shipToName": shipToName,
      "shipToAddress1": shipToAddress1,
      "shipToAddress2": shipToAddress2,
      "shipToPhone": shipToPhone,
      "narration": narration,
      "amount": amount,
      "userId": userId,
      "branchId": branchId,
      "otherAmt": otherAmt,
      "discountAmt": discountAmt,
      "creditPeriod": creditPeriod,
      "paymentCondition": paymentCondition,
      "paymentType": paymentType,
      "invoiceType": invoiceType,
      "invoicePrefix": invoicePrefix,
      "invoiceSuffix": invoiceSuffix,
      "cancelFlg": cancelFlg,
      "entryDate": entryDate,
      "slesManId": slesManId,
      "branchUpdated": branchUpdated,
      "Machinecode":Machinecode,
      "SyncVoucherNo": SyncVoucherNo,
      "saleTypeInterState": saleTypeInterState,
      //"salesDetails": List<dynamic>.from(salesDetails.map((x) => x.toJson())),
     // "salesExpense": List<dynamic>.from(salesExpense.map((x) => x)),
    };
  }

}






// ignore: camel_case_types
class Vansale_PaymentTypes {
  Vansale_PaymentTypes({
    required this.ledgerid,
    required this.SHID,
    this.Amount,

  });

  int ledgerid;
  dynamic Amount;
  int SHID;


  factory Vansale_PaymentTypes.fromJson(Map<String, dynamic> json) => Vansale_PaymentTypes(
    ledgerid: json["ledgerid"],
    SHID: json["SHID"],
    Amount: json["Amount"],

  );

  Map<String, dynamic> toJson() => {
    "ledgerid": ledgerid,
    "SHID": SHID,
    "Amount": Amount,

  };


  Map<String, dynamic> toMap() {
    return {
      "ledgerid": ledgerid,
      "SHID": SHID,
      "Amount": Amount,
    };
  }


}






///........................................................................................
class SalesDetail {
  SalesDetail({
    required this.itmName,
    required this.SHID,
    required this.itemSlNo,
    required this.itemId,
    this.qty,
    this.rate,
    this.disPercentage,
    this.cgstPercentage,
    this.sgstPercentage,
    this.cessPercentage,
    this.discountAmount,
    this.cgstAmount,
    this.sgstAmount,
    this.cessAmount,
    this.igstPercentage,
    this.igstAmount,
    this.taxPercentage,
    this.taxAmount,
    required this.taxInclusive,
    this.amountBeforeTax,
    this.amountIncludingTax,
    this.netTotal,
    required this.hsncode,
    required this.gdnId,
    required this.taxId,
    this.rackId,
    required this.addTaxId,
    required this.unitId,
    this.nosInUnit,
    this.barcode,
    required this.stockId,
    this.batchNo,
    this.expiryDate,
    this.notes,
  });

  String itmName;
  int itemSlNo;
  int SHID;
  int itemId;
  dynamic qty;
  dynamic rate;
  dynamic disPercentage;
  dynamic cgstPercentage;
  dynamic sgstPercentage;
  dynamic cessPercentage;
  dynamic discountAmount;
  dynamic cgstAmount;
  dynamic sgstAmount;
  dynamic cessAmount;
  dynamic igstPercentage;
  dynamic igstAmount;
  dynamic taxPercentage;
  dynamic taxAmount;
  bool taxInclusive;
  dynamic amountBeforeTax;
  dynamic amountIncludingTax;
  dynamic netTotal;
  String hsncode;
  int gdnId;
  int taxId;
  dynamic rackId;
  int addTaxId;
  int unitId;
  dynamic nosInUnit;
  dynamic barcode;
  int stockId;
  dynamic batchNo;
  dynamic expiryDate;
  dynamic notes;

  factory SalesDetail.fromJson(Map<String, dynamic> json) => SalesDetail(
    itmName: json["itmName"],
    SHID: json["SHID"],
    itemSlNo: json["ItemSlNo"],
    itemId: json["itemId"],
    qty: json["qty"],
    rate: json["rate"],
    disPercentage: json["disPercentage"],
    cgstPercentage: json["cgstPercentage"].toDouble(),
    sgstPercentage: json["sgstPercentage"].toDouble(),
    cessPercentage: json["cessPercentage"],
    discountAmount: json["discountAmount"],
    cgstAmount: json["cgstAmount"].toDouble(),
    sgstAmount: json["sgstAmount"].toDouble(),
    cessAmount: json["cessAmount"],
    igstPercentage: json["igstPercentage"],
    igstAmount: json["igstAmount"],
    taxPercentage: json["taxPercentage"],
    taxAmount: json["taxAmount"],
    taxInclusive: json["taxInclusive"]==0?false:true,
    amountBeforeTax: json["amountBeforeTax"],
    amountIncludingTax: json["amountIncludingTax"],
    netTotal: json["netTotal"],
    hsncode: json["hsncode"],
    gdnId: json["gdnId"],
    taxId: json["taxId"],
    rackId: json["rackId"],
    addTaxId: json["addTaxId"],
    unitId: json["unitId"],
    nosInUnit: json["nosInUnit"],
    barcode: json["barcode"],
    stockId: json["StockId"],
    batchNo: json["BatchNo"],
    expiryDate: json["ExpiryDate"],
    notes: json["Notes"],
  );

  Map<String, dynamic> toJson() => {
    "itmName": itmName,
    "SHID": SHID,
    "ItemSlNo": itemSlNo,
    "itemId": itemId,
    "qty": qty,
    "rate": rate,
    "disPercentage": disPercentage,
    "cgstPercentage": cgstPercentage,
    "sgstPercentage": sgstPercentage,
    "cessPercentage": cessPercentage,
    "discountAmount": discountAmount,
    "cgstAmount": cgstAmount,
    "sgstAmount": sgstAmount,
    "cessAmount": cessAmount,
    "igstPercentage": igstPercentage,
    "igstAmount": igstAmount,
    "taxPercentage": taxPercentage,
    "taxAmount": taxAmount,
    "taxInclusive": taxInclusive,
    "amountBeforeTax": amountBeforeTax,
    "amountIncludingTax": amountIncludingTax,
    "netTotal": netTotal,
    "hsncode": hsncode,
    "gdnId": gdnId,
    "taxId": taxId,
    "rackId": rackId,
    "addTaxId": addTaxId,
    "unitId": unitId,
    "nosInUnit": nosInUnit,
    "barcode": barcode,
    "StockId": stockId,
    "BatchNo": batchNo,
    "ExpiryDate": expiryDate,
    "Notes": notes,
  };


  Map<String, dynamic> toMap() {
    return {
      "itmName": itmName,
      "SHID": SHID,
      "ItemSlNo": itemSlNo,
      "itemId": itemId,
      "qty": qty,
      "rate": rate,
      "disPercentage": disPercentage,
      "cgstPercentage": cgstPercentage,
      "sgstPercentage": sgstPercentage,
      "cessPercentage": cessPercentage,
      "discountAmount": discountAmount,
      "cgstAmount": cgstAmount,
      "sgstAmount": sgstAmount,
      "cessAmount": cessAmount,
      "igstPercentage": igstPercentage,
      "igstAmount": igstAmount,
      "taxPercentage": taxPercentage,
      "taxAmount": taxAmount,
      "taxInclusive": taxInclusive,
      "amountBeforeTax": amountBeforeTax,
      "amountIncludingTax": amountIncludingTax,
      "netTotal": netTotal,
      "hsncode": hsncode,
      "gdnId": gdnId,
      "taxId": taxId,
      "rackId": rackId,
      "addTaxId": addTaxId,
      "unitId": unitId,
      "nosInUnit": nosInUnit,
      "barcode": barcode,
      "StockId": stockId,
      "BatchNo": batchNo,
      "ExpiryDate": expiryDate,
      "Notes": notes,
    };
  }


}

