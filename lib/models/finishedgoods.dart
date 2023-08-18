

class FinishedGoods {
  FinishedGoods({
    this.id,
    required this.itmName,
    this.itmProductTypeId,
    required this.productType,
    this.itmGrpId,
    this.igDescription,
    this.itmBrandId,
    this.brndDescription,
    this.itmCode,
    this.itmRoq,
    this.itmRol,
    this.itmMinQty,
    this.itmMaxQty,
    this.itmWarrantyInMonths,
    this.itmModel,
    this.itmUnitId,
    required this.description,
    this.nos,
    this.itmMfrId,
    this.mfrDescription,
    this.itmStkTypeId,
    required this.stockType,
    required this.itmBarCode,
    this.itmDescription,
    this.itmSpecification,
    required this.itmHsn,
    this.itmMonthlyTarget,
    required this.itmIsTaxAplicable,
    required this.itmPrintCaption,
    required this.itmTaxInclusive,
    required this.txTypDescription,
    required this.itmTaxId,
    required this.txDescription,
    required this.txPercentage,
    required this.txCgstPercentage,
    required this.txSgstPercentage,
    required this.txIgstpercentage,
    this.atId,
    this.unitId,
    this.atDescription,
    required this.atPercentage,
    this.salesRtnAccId,
    this.txPurchaseAccId,
    this.txSaleseAccId,
    this.txPurchaseRtnAccId,
    this.itmImage,
    this.itmUserId,
    this.itmBranchId,
    this.itmPurchaseRate,
    this.itmSalesRate,
    this.itmMrp,
    this.itmPurchaseTaxId,
    this.purchaseTaxPercentage,
    this.purchaseAddnlTaxPercentage,
    this.purchaseTaxCgsPercentage,
    this.purchaseTaxSgsPercentage,
    this.purchaseTaxIgsPercentage,
    required this.itmPurchaseTaxInclusive,
    this.itmArabicName,
    this.itmDisplayOrder,
    this.itmBatchEnabled,
    this.itmExpirtyEnabled,
  });

  dynamic id;
  String itmName;
  dynamic itmProductTypeId;
  String productType;
  dynamic itmGrpId;
  dynamic igDescription;
  dynamic itmBrandId;
  dynamic brndDescription;
  dynamic itmCode;
  dynamic itmRoq;
  dynamic itmRol;
  dynamic itmMinQty;
  dynamic itmMaxQty;
  dynamic itmWarrantyInMonths;
  dynamic itmModel;
  dynamic itmUnitId;
  String description;
  dynamic nos;
  dynamic itmMfrId;
  dynamic mfrDescription;
  dynamic itmStkTypeId;
  String stockType;
  String itmBarCode;
  dynamic itmDescription;
  dynamic itmSpecification;
  String itmHsn;
  dynamic itmMonthlyTarget;
  bool itmIsTaxAplicable;
  String itmPrintCaption;
  bool itmTaxInclusive;
  String txTypDescription;
  int itmTaxId;
  String txDescription;
  double txPercentage;
  double txCgstPercentage;
  double txSgstPercentage;
  double txIgstpercentage;
  dynamic atId;
  dynamic unitId;
  dynamic atDescription;
  double  atPercentage;
  dynamic salesRtnAccId;
  dynamic txPurchaseAccId;
  dynamic txSaleseAccId;
  dynamic txPurchaseRtnAccId;
  dynamic itmImage;
  dynamic itmUserId;
  dynamic itmBranchId;
  dynamic itmPurchaseRate;
  dynamic itmSalesRate;
  dynamic itmMrp;
  dynamic itmPurchaseTaxId;
  dynamic purchaseTaxPercentage;
  dynamic purchaseAddnlTaxPercentage;
  dynamic purchaseTaxCgsPercentage;
  dynamic purchaseTaxSgsPercentage;
  dynamic purchaseTaxIgsPercentage;
  bool itmPurchaseTaxInclusive;
  dynamic itmArabicName;
  dynamic itmDisplayOrder;
  dynamic itmBatchEnabled;
  dynamic itmExpirtyEnabled;

  factory FinishedGoods.fromJson(Map<String, dynamic> json) => FinishedGoods(
    id: json["id"],
    itmName: json["itmName"],
    itmProductTypeId: json["itmProductTypeId"],
    productType: json["productType"],
    itmGrpId: json["itmGrpId"],
    igDescription: json["igDescription"],
    itmBrandId: json["itmBrandId"],
    brndDescription: json["brndDescription"],
    itmCode: json["itmCode"],
    itmRoq: json["itmRoq"],
    itmRol: json["itmRol"],
    itmMinQty: json["itmMinQty"],
    itmMaxQty: json["itmMaxQty"],
    itmWarrantyInMonths: json["itmWarrantyInMonths"],
    itmModel: json["itmModel"],
    itmUnitId: json["itmUnitId"],
    description: json["description"],
    nos: json["nos"],
    itmMfrId: json["itmMfrId"],
    mfrDescription: json["mfrDescription"],
    itmStkTypeId: json["itmStkTypeId"],
    stockType: json["stockType"],
    itmBarCode: json["itmBarCode"],
    itmDescription: json["itmDescription"],
    itmSpecification: json["itmSpecification"],
    itmHsn: json["itmHsn"],
    itmMonthlyTarget: json["itmMonthlyTarget"],
    itmIsTaxAplicable: json["itmIsTaxAplicable"],
    itmPrintCaption: json["itmPrintCaption"],
    itmTaxInclusive: json["itmTaxInclusive"],
    txTypDescription: json["txTypDescription"],
    itmTaxId: json["itmTaxId"],
    txDescription: json["txDescription"],
    txPercentage: json["txPercentage"],
    txCgstPercentage: json["txCgstPercentage"],
    txSgstPercentage: json["txSgstPercentage"],
    txIgstpercentage: json["txIgstpercentage"],
    atId: json["atId"],
    unitId: json["unitId"],
    atDescription: json["atDescription"],
    atPercentage: json["atPercentage"],
    salesRtnAccId: json["salesRtnAccId"],
    txPurchaseAccId: json["txPurchaseAccId"],
    txSaleseAccId: json["txSaleseAccId"],
    txPurchaseRtnAccId: json["txPurchaseRtnAccId"],
    itmImage: json["itmImage"],
    itmUserId: json["itmUserId"],
    itmBranchId: json["itmBranchId"],
    itmPurchaseRate: json["itmPurchaseRate"],
    itmSalesRate: json["itmSalesRate"],
    itmMrp: json["itmMrp"],
    itmPurchaseTaxId: json["itmPurchaseTaxId"],
    purchaseTaxPercentage: json["purchaseTaxPercentage"],
    purchaseAddnlTaxPercentage: json["purchaseAddnlTaxPercentage"],
    purchaseTaxCgsPercentage: json["purchaseTaxCGSPercentage"],
    purchaseTaxSgsPercentage: json["purchaseTaxSGSPercentage"],
    purchaseTaxIgsPercentage: json["purchaseTaxIGSPercentage"],
    itmPurchaseTaxInclusive: json["itmPurchaseTaxInclusive"],
    itmArabicName: json["itmArabicName"],
    itmDisplayOrder: json["itmDisplayOrder"],
    itmBatchEnabled: json["itmBatchEnabled"],
    itmExpirtyEnabled: json["itmExpirtyEnabled"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "itmName": itmName,
    "itmProductTypeId": itmProductTypeId,
    "productType": productType,
    "itmGrpId": itmGrpId,
    "igDescription": igDescription,
    "itmBrandId": itmBrandId,
    "brndDescription": brndDescription,
    "itmCode": itmCode,
    "itmRoq": itmRoq,
    "itmRol": itmRol,
    "itmMinQty": itmMinQty,
    "itmMaxQty": itmMaxQty,
    "itmWarrantyInMonths": itmWarrantyInMonths,
    "itmModel": itmModel,
    "itmUnitId": itmUnitId,
    "description": description,
    "nos": nos,
    "itmMfrId": itmMfrId,
    "mfrDescription": mfrDescription,
    "itmStkTypeId": itmStkTypeId,
    "stockType": stockType,
    "itmBarCode": itmBarCode,
    "itmDescription": itmDescription,
    "itmSpecification": itmSpecification,
    "itmHsn": itmHsn,
    "itmMonthlyTarget": itmMonthlyTarget,
    "itmIsTaxAplicable": itmIsTaxAplicable,
    "itmPrintCaption": itmPrintCaption,
    "itmTaxInclusive": itmTaxInclusive,
    "txTypDescription": txTypDescription,
    "itmTaxId": itmTaxId,
    "txDescription": txDescription,
    "txPercentage": txPercentage,
    "txCgstPercentage": txCgstPercentage,
    "txSgstPercentage": txSgstPercentage,
    "txIgstpercentage": txIgstpercentage,
    "atId": atId,
    "unitId": unitId,
    "atDescription": atDescription,
    "atPercentage": atPercentage,
    "salesRtnAccId": salesRtnAccId,
    "txPurchaseAccId": txPurchaseAccId,
    "txSaleseAccId": txSaleseAccId,
    "txPurchaseRtnAccId": txPurchaseRtnAccId,
    "itmImage": itmImage,
    "itmUserId": itmUserId,
    "itmBranchId": itmBranchId,
    "itmPurchaseRate": itmPurchaseRate,
    "itmSalesRate": itmSalesRate,
    "itmMrp": itmMrp,
    "itmPurchaseTaxId": itmPurchaseTaxId,
    "purchaseTaxPercentage": purchaseTaxPercentage,
    "purchaseAddnlTaxPercentage": purchaseAddnlTaxPercentage,
    "purchaseTaxCGSPercentage": purchaseTaxCgsPercentage,
    "purchaseTaxSGSPercentage": purchaseTaxSgsPercentage,
    "purchaseTaxIGSPercentage": purchaseTaxIgsPercentage,
    "itmPurchaseTaxInclusive": itmPurchaseTaxInclusive,
    "itmArabicName": itmArabicName,
    "itmDisplayOrder": itmDisplayOrder,
    "itmBatchEnabled": itmBatchEnabled,
    "itmExpirtyEnabled": itmExpirtyEnabled,
  };
}




// class FinishedGoods {
//   int id;
//   String itmName;
//   dynamic itmImage;
//   int itmUserId;
//   int itmBranchId;
//   double txPercentage;
//   double atPercentage;
//   String description;
//
//   String itmHsn;
//   int unitId ;
//   int itmUnitId;
//   double txCgstPercentage;
//   double txSgstPercentage;
//   double txIgstpercentage;
//   int itmTaxId;
//   dynamic itmSalesRate;
//
//   FinishedGoods(
//       {this.id, this.itmName, this.itmImage, this.itmUserId, this.itmBranchId,this.txPercentage,this.atPercentage,
//         this.description,this.itmHsn,this.unitId,this.itmUnitId,this.txCgstPercentage,this.txSgstPercentage,this.txIgstpercentage,this.itmTaxId,this.itmSalesRate});
//
//   FinishedGoods.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     itmName = json['itmName'];
//     itmImage = json['itmImage'];
//     itmUserId = json['itmUserId'];
//     itmBranchId = json['itmBranchId'];
//     txPercentage = json['txPercentage'];
//     atPercentage = json['atPercentage'];
//     description = json['description'];
//
//     itmHsn = json['itmHsn'];
//     unitId = json['unitId'];
//     itmUnitId = json['itmUnitId'];
//
//     txCgstPercentage = json['txCgstPercentage'];
//     txSgstPercentage = json['txSgstPercentage'];
//     txIgstpercentage = json['txIgstpercentage'];
//     itmTaxId = json['itmTaxId'];
//     itmSalesRate = json['itmSalesRate'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['itmName'] = this.itmName;
//     data['itmImage'] = this.itmImage;
//     data['itmUserId'] = this.itmUserId;
//     data['itmBranchId'] = this.itmBranchId;
//     data['txPercentage'] = this.txPercentage;
//     data['atPercentage'] = this.atPercentage;
//     data['description'] = this.description;
//
//     data['itmHsn'] = this.itmHsn;
//     data['unitId'] = this.unitId;
//     data['itmUnitId'] = this.itmUnitId;
//
//     data['txCgstPercentage'] = this.txCgstPercentage;
//     data['txSgstPercentage '] = this.txSgstPercentage;
//     data['txIgstpercentage'] = this. txIgstpercentage;
//     data['itmTaxId'] = this.itmTaxId;
//     data['itmSalesRate'] = this.itmSalesRate;
//
//     return data;
//   }
// }
