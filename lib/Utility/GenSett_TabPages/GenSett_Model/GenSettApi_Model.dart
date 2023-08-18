// To parse this JSON data, do
//
//     final GenSett_Api_Model = GenSett_Api_ModelFromJson(jsonString);

import 'dart:convert';

List<GenSett_Api_Model> GenSett_Api_ModelFromJson(String str) => List<GenSett_Api_Model>.from(json.decode(str).map((x) => GenSett_Api_Model.fromJson(x)));

String GenSett_Api_ModelToJson(List<GenSett_Api_Model> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GenSett_Api_Model {
  GenSett_Api_Model({
    required this.id,
    required this.enableGdn,
    required this.defaultSearchInSales,
    required this.paymentLedgerPost,
    required this.receiptLedgerPost,
    required this.journalLedgerPost,
    required this.negativeSalesAllow,
    required this.batchAndExpApplicable,
    required this.showStockInSales,
    required this.defaInvTypeBtBorBtC,
    required this.defaPayType,
    required this.enableMasterIndexPage,
    required this.enableTranIndexPage,
    required this.itemDefaultStockTypeId,
    required this.itemDefaultProductTypeId,
    required this.enableSalesDiscount,
    required this.enableSalesItemWiseDiscount,
    required this.salesThermalPrint,
    required this.directPrintFromSales,
    required this.purchaseTaxInclusive,
    required this.salesTaxInclusive,
    required this.showNotesPurchaseSales,
    this.thermalPrintLogoHeight,
    this.thermalPrintLogoWidth,
    required this.fixedDiscountInSales,
    required this.stockBatchBaseSalesRateAlso,
    required this.masterListBranchWise,
    required this.applicationType,
    required this.salesManPrintInInvoice,
    required this.loginUserPrintInInvoice,
    required this.branchWiseEmployList,
    required this.branchWiseCompanyProfileList,
    required this.branchId,
    required this.branchWiseLedgerList,
    this.defaultImagePath,
    required this.purchaseEditAfterStockUpdate,
    this.onlineUrlsqrcode,
    this.rmsBillDispImg,
    required this.salesItemListFromStockTable,
    required this.salesInvoiceDateEditable,
    this.purchaseDiscountLedgerId,
    this.purchaseAdjustLedgerId,
    this.salesDiscountLedgerId,
    this.salesAdjustLedgerId,
    this.mrpPrintOnThermal,
    required this.mainNavbarLogoName,
    required this.dashBoardHeaderName,
    this.rmsKotPrinter,
    this.rmsCounterPrinter,
    this.autoGenerateBatchInPurchase,
    this.bypassDeliveryProcessRms,
    this.enableMakeorderRms,
    this.enablePackingSlipInSales,
    this.generateBarcodeInPurchase,
    required this.enableBarcodeInSales,
    required this.applicationTaxTypeGst,
    this.concurrencyTestEnable,
    required this.salesPrinterType,
    this.updateItemRateBasedOnPurchase,
    this.printQrinSales,
    required this.countryCode,
    required this.countryName,
    required this.timeZoneCode,
    required this.currencyName,
    required this.currencyDecimals,
    required this.currencyCoinName,
    required this.printLedgerBalanceInInvoice,
  });

  int id;
  bool enableGdn;
  String defaultSearchInSales;
  String paymentLedgerPost;
  String receiptLedgerPost;
  String journalLedgerPost;
  bool negativeSalesAllow;
  bool batchAndExpApplicable;
  bool showStockInSales;
  String defaInvTypeBtBorBtC;
  int defaPayType;
  bool enableMasterIndexPage;
  bool enableTranIndexPage;
  int itemDefaultStockTypeId;
  int itemDefaultProductTypeId;
  bool enableSalesDiscount;
  bool enableSalesItemWiseDiscount;
  bool salesThermalPrint;
  bool directPrintFromSales;
  bool purchaseTaxInclusive;
  bool salesTaxInclusive;
  bool showNotesPurchaseSales;
  dynamic thermalPrintLogoHeight;
  dynamic thermalPrintLogoWidth;
  bool fixedDiscountInSales;
  bool stockBatchBaseSalesRateAlso;
  bool masterListBranchWise;
  String applicationType;
  bool salesManPrintInInvoice;
  bool loginUserPrintInInvoice;
  bool branchWiseEmployList;
  bool branchWiseCompanyProfileList;
  int branchId;
  bool branchWiseLedgerList;
  dynamic defaultImagePath;
  bool purchaseEditAfterStockUpdate;
  dynamic onlineUrlsqrcode;
  dynamic rmsBillDispImg;
  bool salesItemListFromStockTable;
  bool salesInvoiceDateEditable;
  dynamic purchaseDiscountLedgerId;
  dynamic purchaseAdjustLedgerId;
  dynamic salesDiscountLedgerId;
  dynamic salesAdjustLedgerId;
  dynamic mrpPrintOnThermal;
  String mainNavbarLogoName;
  String dashBoardHeaderName;
  dynamic rmsKotPrinter;
  dynamic rmsCounterPrinter;
  dynamic autoGenerateBatchInPurchase;
  dynamic bypassDeliveryProcessRms;
  dynamic enableMakeorderRms;
  dynamic enablePackingSlipInSales;
  dynamic generateBarcodeInPurchase;
  bool enableBarcodeInSales;
  bool applicationTaxTypeGst;
  dynamic concurrencyTestEnable;
  String salesPrinterType;
  dynamic updateItemRateBasedOnPurchase;
  dynamic printQrinSales;
  String countryCode;
  String countryName;
  String timeZoneCode;
  String currencyName;
  int currencyDecimals;
  String currencyCoinName;
  bool printLedgerBalanceInInvoice;

  factory GenSett_Api_Model.fromJson(Map<String, dynamic> json) => GenSett_Api_Model(
    id: json["id"],
    enableGdn: json["enableGdn"],
    defaultSearchInSales: json["defaultSearchInSales"],
    paymentLedgerPost: json["paymentLedgerPost"],
    receiptLedgerPost: json["receiptLedgerPost"],
    journalLedgerPost: json["journalLedgerPost"],
    negativeSalesAllow: json["negativeSalesAllow"],
    batchAndExpApplicable: json["batchAndExpApplicable"],
    showStockInSales: json["showStockInSales"],
    defaInvTypeBtBorBtC: json["defaInvTypeBtBorBtC"],
    defaPayType: json["defaPayType"],
    enableMasterIndexPage: json["enableMasterIndexPage"],
    enableTranIndexPage: json["enableTranIndexPage"],
    itemDefaultStockTypeId: json["itemDefaultStockTypeId"],
    itemDefaultProductTypeId: json["itemDefaultProductTypeId"],
    enableSalesDiscount: json["enableSalesDiscount"],
    enableSalesItemWiseDiscount: json["enableSalesItemWiseDiscount"],
    salesThermalPrint: json["salesThermalPrint"],
    directPrintFromSales: json["directPrintFromSales"],
    purchaseTaxInclusive: json["purchaseTaxInclusive"],
    salesTaxInclusive: json["salesTaxInclusive"],
    showNotesPurchaseSales: json["showNotesPurchaseSales"],
    thermalPrintLogoHeight: json["thermalPrintLogoHeight"],
    thermalPrintLogoWidth: json["thermalPrintLogoWidth"],
    fixedDiscountInSales: json["fixedDiscountInSales"],
    stockBatchBaseSalesRateAlso: json["stockBatchBaseSalesRateAlso"],
    masterListBranchWise: json["masterListBranchWise"],
    applicationType: json["applicationType"],
    salesManPrintInInvoice: json["salesManPrintInInvoice"],
    loginUserPrintInInvoice: json["loginUserPrintInInvoice"],
    branchWiseEmployList: json["branchWiseEmployList"],
    branchWiseCompanyProfileList: json["branchWiseCompanyProfileList"],
    branchId: json["branchId"],
    branchWiseLedgerList: json["branchWiseLedgerList"],
    defaultImagePath: json["defaultImagePath"],
    purchaseEditAfterStockUpdate: json["purchaseEditAfterStockUpdate"],
    onlineUrlsqrcode: json["onlineUrlsqrcode"],
    rmsBillDispImg: json["rmsBillDispImg"],
    salesItemListFromStockTable: json["salesItemListFromStockTable"],
    salesInvoiceDateEditable: json["salesInvoiceDateEditable"],
    purchaseDiscountLedgerId: json["purchaseDiscountLedgerId"],
    purchaseAdjustLedgerId: json["purchaseAdjustLedgerId"],
    salesDiscountLedgerId: json["salesDiscountLedgerId"],
    salesAdjustLedgerId: json["salesAdjustLedgerId"],
    mrpPrintOnThermal: json["mrpPrintOnThermal"],
    mainNavbarLogoName: json["mainNavbarLogoName"],
    dashBoardHeaderName: json["dashBoardHeaderName"],
    rmsKotPrinter: json["rmsKotPrinter"],
    rmsCounterPrinter: json["rmsCounterPrinter"],
    autoGenerateBatchInPurchase: json["autoGenerateBatchInPurchase"],
    bypassDeliveryProcessRms: json["bypassDeliveryProcessRms"],
    enableMakeorderRms: json["enableMakeorderRms"],
    enablePackingSlipInSales: json["enablePackingSlipInSales"],
    generateBarcodeInPurchase: json["generateBarcodeInPurchase"],
    enableBarcodeInSales: json["enableBarcodeInSales"],
    applicationTaxTypeGst: json["applicationTaxTypeGst"],
    concurrencyTestEnable: json["concurrencyTestEnable"],
    salesPrinterType: json["salesPrinterType"],
    updateItemRateBasedOnPurchase: json["updateItemRateBasedOnPurchase"],
    printQrinSales: json["printQrinSales"],
    countryCode: json["countryCode"],
    countryName: json["countryName"],
    timeZoneCode: json["timeZoneCode"],
    currencyName: json["currencyName"],
    currencyDecimals: json["currencyDecimals"],
    currencyCoinName: json["currencyCoinName"],
    printLedgerBalanceInInvoice: json["printLedgerBalanceInInvoice"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "enableGdn": enableGdn,
    "defaultSearchInSales": defaultSearchInSales,
    "paymentLedgerPost": paymentLedgerPost,
    "receiptLedgerPost": receiptLedgerPost,
    "journalLedgerPost": journalLedgerPost,
    "negativeSalesAllow": negativeSalesAllow,
    "batchAndExpApplicable": batchAndExpApplicable,
    "showStockInSales": showStockInSales,
    "defaInvTypeBtBorBtC": defaInvTypeBtBorBtC,
    "defaPayType": defaPayType,
    "enableMasterIndexPage": enableMasterIndexPage,
    "enableTranIndexPage": enableTranIndexPage,
    "itemDefaultStockTypeId": itemDefaultStockTypeId,
    "itemDefaultProductTypeId": itemDefaultProductTypeId,
    "enableSalesDiscount": enableSalesDiscount,
    "enableSalesItemWiseDiscount": enableSalesItemWiseDiscount,
    "salesThermalPrint": salesThermalPrint,
    "directPrintFromSales": directPrintFromSales,
    "purchaseTaxInclusive": purchaseTaxInclusive,
    "salesTaxInclusive": salesTaxInclusive,
    "showNotesPurchaseSales": showNotesPurchaseSales,
    "thermalPrintLogoHeight": thermalPrintLogoHeight,
    "thermalPrintLogoWidth": thermalPrintLogoWidth,
    "fixedDiscountInSales": fixedDiscountInSales,
    "stockBatchBaseSalesRateAlso": stockBatchBaseSalesRateAlso,
    "masterListBranchWise": masterListBranchWise,
    "applicationType": applicationType,
    "salesManPrintInInvoice": salesManPrintInInvoice,
    "loginUserPrintInInvoice": loginUserPrintInInvoice,
    "branchWiseEmployList": branchWiseEmployList,
    "branchWiseCompanyProfileList": branchWiseCompanyProfileList,
    "branchId": branchId,
    "branchWiseLedgerList": branchWiseLedgerList,
    "defaultImagePath": defaultImagePath,
    "purchaseEditAfterStockUpdate": purchaseEditAfterStockUpdate,
    "onlineUrlsqrcode": onlineUrlsqrcode,
    "rmsBillDispImg": rmsBillDispImg,
    "salesItemListFromStockTable": salesItemListFromStockTable,
    "salesInvoiceDateEditable": salesInvoiceDateEditable,
    "purchaseDiscountLedgerId": purchaseDiscountLedgerId,
    "purchaseAdjustLedgerId": purchaseAdjustLedgerId,
    "salesDiscountLedgerId": salesDiscountLedgerId,
    "salesAdjustLedgerId": salesAdjustLedgerId,
    "mrpPrintOnThermal": mrpPrintOnThermal,
    "mainNavbarLogoName": mainNavbarLogoName,
    "dashBoardHeaderName": dashBoardHeaderName,
    "rmsKotPrinter": rmsKotPrinter,
    "rmsCounterPrinter": rmsCounterPrinter,
    "autoGenerateBatchInPurchase": autoGenerateBatchInPurchase,
    "bypassDeliveryProcessRms": bypassDeliveryProcessRms,
    "enableMakeorderRms": enableMakeorderRms,
    "enablePackingSlipInSales": enablePackingSlipInSales,
    "generateBarcodeInPurchase": generateBarcodeInPurchase,
    "enableBarcodeInSales": enableBarcodeInSales,
    "applicationTaxTypeGst": applicationTaxTypeGst,
    "concurrencyTestEnable": concurrencyTestEnable,
    "salesPrinterType": salesPrinterType,
    "updateItemRateBasedOnPurchase": updateItemRateBasedOnPurchase,
    "printQrinSales": printQrinSales,
    "countryCode": countryCode,
    "countryName": countryName,
    "timeZoneCode": timeZoneCode,
    "currencyName": currencyName,
    "currencyDecimals": currencyDecimals,
    "currencyCoinName": currencyCoinName,
    "printLedgerBalanceInInvoice": printLedgerBalanceInInvoice,
  };
}
