
class LedgerHeads {
  LedgerHeads({
    this.id,
    required this.lhName,
    this.lhAliasName,
    required this.lhGroupId,
    required this.lhType,
    this.lhPricingLevelId,
    this.lhMaintainBillByBill,
    this.lhCreditPeriod,
    required this.lhMailingName,
    required this.lhMailingAddress1,
    required this.lhMailingAddress2,
    required this.lhMailingAddress3,
    required this.lhStateId,
    required this.lhState,
    required this.districtId,
    this.districtName,
    required this.lhAreaId,
    required this.areaName,
    this.lhLocationId,
    this.locationName,
    this.lhRouteId,
    this.rtName,
    required this.lhPincode,
    required this.lhPanNo,
    this.lhGstno,
    this.lhOpeningBalance,
    required this.lhOpeningType,
    required this.lhContactPerson,
    required this.lhContactNo,
    required this.lhEmail,
    this.lhBankName,
    this.lhAccountNo,
    this.lhBankBranch,
    this.lhIfscCode,
    required this.lhUserId,
    required this.lhBranchId,
    required this.lhGroup,
    this.lhPricingLevel,
    this.lhRemarks,
  });

  dynamic id;
  String lhName;
  dynamic lhAliasName;
  int lhGroupId;
  String lhType;
  dynamic lhPricingLevelId;
  dynamic lhMaintainBillByBill;
  dynamic lhCreditPeriod;
  String lhMailingName;
  String lhMailingAddress1;
  String lhMailingAddress2;
  String lhMailingAddress3;
  int lhStateId;
  String lhState;
  int districtId;
  dynamic districtName;
  int lhAreaId;
  String areaName;
  dynamic lhLocationId;
  dynamic locationName;
  dynamic lhRouteId;
  dynamic rtName;
  String lhPincode;
  String lhPanNo;
  dynamic lhGstno;
  dynamic lhOpeningBalance;
  String lhOpeningType;
  String lhContactPerson;
  String lhContactNo;
  String lhEmail;
  dynamic lhBankName;
  dynamic lhAccountNo;
  dynamic lhBankBranch;
  dynamic lhIfscCode;
  int lhUserId;
  int lhBranchId;
  String lhGroup;
  dynamic lhPricingLevel;
  dynamic lhRemarks;

  factory LedgerHeads.fromJson(Map<String, dynamic> json) => LedgerHeads(
    id: json["id"],
    lhName: json["lhName"],
    lhAliasName: json["lhAliasName"],
    lhGroupId: json["lhGroupId"],
    lhType: json["lhType"],
    lhPricingLevelId: json["lhPricingLevelId"],
    lhMaintainBillByBill: json["lhMaintainBillByBill"],
    lhCreditPeriod: json["lhCreditPeriod"],
    lhMailingName: json["lhMailingName"],
    lhMailingAddress1: json["lhMailingAddress1"],
    lhMailingAddress2: json["lhMailingAddress2"],
    lhMailingAddress3: json["lhMailingAddress3"],
    lhStateId: json["lhStateId"],
    lhState: json["lhState"],
    districtId: json["districtId"],
    districtName: json["districtName"],
    lhAreaId: json["lhAreaId"],
    areaName: json["areaName"],
    lhLocationId: json["lhLocationId"],
    locationName: json["locationName"],
    lhRouteId: json["lhRouteId"],
    rtName: json["rtName"],
    lhPincode: json["lhPincode"],
    lhPanNo: json["lhPanNo"],
    lhGstno: json["lhGstno"],
    lhOpeningBalance: json["lhOpeningBalance"],
    lhOpeningType: json["lhOpeningType"],
    lhContactPerson: json["lhContactPerson"],
    lhContactNo: json["lhContactNo"],
    lhEmail: json["lhEmail"],
    lhBankName: json["lhBankName"],
    lhAccountNo: json["lhAccountNo"],
    lhBankBranch: json["lhBankBranch"],
    lhIfscCode: json["lhIfscCode"],
    lhUserId: json["lhUserId"],
    lhBranchId: json["lhBranchId"],
    lhGroup: json["lhGroup"],
    lhPricingLevel: json["lhPricingLevel"],
    lhRemarks: json["lhRemarks"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "lhName": lhName,
    "lhAliasName": lhAliasName,
    "lhGroupId": lhGroupId,
    "lhType": lhType,
    "lhPricingLevelId": lhPricingLevelId,
    "lhMaintainBillByBill": lhMaintainBillByBill,
    "lhCreditPeriod": lhCreditPeriod,
    "lhMailingName": lhMailingName,
    "lhMailingAddress1": lhMailingAddress1,
    "lhMailingAddress2": lhMailingAddress2,
    "lhMailingAddress3": lhMailingAddress3,
    "lhStateId": lhStateId,
    "lhState": lhState,
    "districtId": districtId,
    "districtName": districtName,
    "lhAreaId": lhAreaId,
    "areaName": areaName,
    "lhLocationId": lhLocationId,
    "locationName": locationName,
    "lhRouteId": lhRouteId,
    "rtName": rtName,
    "lhPincode": lhPincode,
    "lhPanNo": lhPanNo,
    "lhGstno": lhGstno,
    "lhOpeningBalance": lhOpeningBalance,
    "lhOpeningType": lhOpeningType,
    "lhContactPerson": lhContactPerson,
    "lhContactNo": lhContactNo,
    "lhEmail": lhEmail,
    "lhBankName": lhBankName,
    "lhAccountNo": lhAccountNo,
    "lhBankBranch": lhBankBranch,
    "lhIfscCode": lhIfscCode,
    "lhUserId": lhUserId,
    "lhBranchId": lhBranchId,
    "lhGroup": lhGroup,
    "lhPricingLevel": lhPricingLevel,
    "lhRemarks": lhRemarks,
  };
}
