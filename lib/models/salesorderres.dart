// [{id: 61, sohOrderNo: 48, sohOrderDate: 2020-08-28T00:00:00,
// sohFromLedgerId: 73.0, sohFromLedgerName: 3GMOBILE WORLD KASARAGOD
//  , sohToLedgerId: 5.0, sohToLedgerName: MPS, sohSalesManId: 1,
// sohSalesManName: Employee, sohDelDate: 2020-08-28T20:13:34.833,
// sohPayContitionId: 1, conDescription: General Conditon, sohOtherCharges: 0.0,
// sohRemarks: hi, sohEntryDate: 2020-08-28T20:14:43.487, sohSaleType: 0,
// sohSalesManagerApprovedId: null, sohSalesManagerApprovedName: null,
// sohSalesManagerApprovedDate: null, sohSalesManagerApprovedRemarks: null,
// sohAccManagerApprovedId: null, sohAccManagerApprovedName: null,
// sohAccManagerApprovedDate: null, sohAccManagerApprovedRemarks: null,
// sohStatus: null, sohUserId: 6, sohBranchId: 2}
//
// ]







class SalesOrderRes {
  int id;
  int sohOrderNo;
  dynamic sohOrderDate;
  dynamic sohFromLedgerId;
  dynamic sohFromLedgerName;
  dynamic sohToLedgerId;
  dynamic sohToLedgerName;
  dynamic sohSalesManId;
  dynamic sohSalesManName;
  dynamic sohDelDate;
  dynamic sohPayContitionId;
  dynamic conDescription;
  dynamic sohOtherCharges;
  dynamic sohRemarks;
  dynamic sohEntryDate;
  dynamic sohSaleType;
  // Null sohSalesManagerApprovedId;
  // Null sohSalesManagerApprovedName;
  // Null sohSalesManagerApprovedDate;
  // Null sohSalesManagerApprovedRemarks;
  // Null sohAccManagerApprovedId;
  // Null sohAccManagerApprovedName;
  // Null sohAccManagerApprovedDate;
  // Null sohAccManagerApprovedRemarks;
  // Null sohStatus;
  dynamic sohUserId;
  dynamic sohBranchId;


  SalesOrderRes({
    required this.id,
    required this.sohOrderNo,
    this.sohOrderDate,
    this.sohFromLedgerId,
    this.sohFromLedgerName,
    this.sohToLedgerId,
    this.sohToLedgerName,
    this.sohSalesManId,
    this.sohSalesManName,
    this.sohDelDate,
    this.sohPayContitionId,
    this.conDescription,
    this.sohOtherCharges,
    this.sohRemarks,
    this.sohEntryDate,
    this.sohSaleType,
    // this.sohSalesManagerApprovedId,
    // this.sohSalesManagerApprovedName,
    // this.sohSalesManagerApprovedDate,
    // this.sohSalesManagerApprovedRemarks,
    // this.sohAccManagerApprovedId,
    // this.sohAccManagerApprovedName,
    // this.sohAccManagerApprovedDate,
    // this.sohAccManagerApprovedRemarks,
    // this.sohStatus,
    this.sohUserId,
    this.sohBranchId
  });

  factory SalesOrderRes.fromJson(Map<String, dynamic> parsedJson){
    return SalesOrderRes(
        id:parsedJson["id"].toInt(),
        sohOrderNo: parsedJson["sohOrderNo"].toInt(),
        sohOrderDate:parsedJson["sohOrderDate"],
        sohFromLedgerId: parsedJson["sohFromLedgerId"],
        sohFromLedgerName:parsedJson["sohFromLedgerName"],
        sohToLedgerId: parsedJson["sohToLedgerId"],
        sohToLedgerName:parsedJson["sohToLedgerName"],
        sohSalesManId: parsedJson["sohSalesManId"],
      sohSalesManName:parsedJson["sohSalesManName"],
      sohDelDate: parsedJson["sohDelDate"],
      sohPayContitionId:parsedJson["sohPayContitionId"],
      conDescription: parsedJson["conDescription"],
      sohOtherCharges:parsedJson["sohOtherCharges"],
      sohRemarks: parsedJson["sohRemarks"],
      sohEntryDate:parsedJson["sohEntryDate"],
      sohSaleType: parsedJson["sohSaleType"],
      sohUserId:parsedJson["sohUserId"],
      sohBranchId: parsedJson["sohBranchId"],

    );
  }
}

