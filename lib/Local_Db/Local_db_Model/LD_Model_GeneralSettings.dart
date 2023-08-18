
class LD_Model_Generalset {
  LD_Model_Generalset({
     required this.id,
    required this.enableGdn,
    required this.defaultSearchInSales,
    required this.paymentLedgerPost,
    required this.receiptLedgerPost,
    required this.journalLedgerPost,
    this.purchaseTaxInclusive,
    this.salesTaxInclusive,
    this.showNotesPurchaseSales,
    this.directPrintFromSales,
    this.enableMasterIndexPage,
    this.enableTranIndexPage,
    required this.itemDefaultStockTypeId,
    required this.itemDefaultProductTypeId,
    this.enableSalesDiscount,
    this.enableSalesItemWiseDiscount,
    this.salesThermalPrint,
    required this.defaInvTypeBtBorBtC,
    required this.defaPayType,
    this.negativeSalesAllow,
    this.batchAndExpApplicable,
    this.showStockInSales,
    required this. thermalPrintLogoHeight,
    required this.  thermalPrintLogoWidth,
    this. fixedDiscountInSales,
    this.stockBatchBaseSalesRateAlso,
    this.masterListBranchWise,
    required this.applicationType,
    this.salesManPrintInInvoice,
    this. loginUserPrintInInvoice,
    this.branchWiseEmployList,
    this.branchWiseCompanyProfileList,
    required this.branchId,
    this.branchWiseLedgerList,
    this.defaultImagePath,
    this.purchaseEditAfterStockUpdate,
    this.onlineUrlsqrcode,
    this.rmsBillDispImg,
    this.salesItemListFromStockTable,
    this.salesInvoiceDateEditable,
    this.purchaseDiscountLedgerId,
    this. purchaseAdjustLedgerId,
    this.salesDiscountLedgerId,
    this.salesAdjustLedgerId,
    this.mrpPrintOnThermal,
    this.enableBarcodeInSales,
    this. bypassDeliveryProcessRms,
    this.enableMakeorderRms,
    this.enablePackingSlipInSales,
    this.generateBarcodeInPurchase,
    required this.salesPrinterType,
    this.concurrencyTestEnable,
    this.applicationTaxTypeGst,
    required this.mainNavbarLogoName,
    required this.dashBoardHeaderName,
    this.rmsKotPrinter,
    this.rmsCounterPrinter,
    this.autoGenerateBatchInPurchase,
    this.printQrinSales,
    this.showBarcodeInInvoicePrint,
    this.showQrcodeInInvoicePrint,
    this.showPurchaseRateInSales,
    this.compoundingTaxableInvoice,
    this.printLedgerBalanceInInvoice,
    this.countryCode,
    this.countryName,
    this.timeZoneCode,
    this.currencyName,
    this.currencyDecimals,
    this.currencyCoinName,
    this.updateItemRateBasedOnPurchase,
    this.isComponentTax,
    this.showAllTypeItemsInSales,
    this.enableDayClose,
    this.deliveryCharge,
    this.invoicetypeheck,
    this.billCounter,
    this.defalutinvoicetype,
    this.enableLocalPrinter,
    this.printerTypeBlutooth,
  });

   int id;
   String enableGdn;
   String defaultSearchInSales;
   String paymentLedgerPost;
   String receiptLedgerPost;
   String journalLedgerPost;
  dynamic purchaseTaxInclusive;
  dynamic salesTaxInclusive;
  dynamic showNotesPurchaseSales;
  dynamic directPrintFromSales;
  dynamic enableMasterIndexPage;
  dynamic enableTranIndexPage;
  int itemDefaultStockTypeId;
  int itemDefaultProductTypeId;
  dynamic enableSalesDiscount;
  dynamic enableSalesItemWiseDiscount;
  dynamic salesThermalPrint;
  String defaInvTypeBtBorBtC;
  int defaPayType;
  dynamic negativeSalesAllow;
  dynamic batchAndExpApplicable;
  dynamic showStockInSales;
  int thermalPrintLogoHeight;
  int thermalPrintLogoWidth;
  dynamic fixedDiscountInSales;
  dynamic stockBatchBaseSalesRateAlso;
  dynamic masterListBranchWise;
  String applicationType;
  dynamic salesManPrintInInvoice;
  dynamic loginUserPrintInInvoice;
  dynamic branchWiseEmployList;
  dynamic branchWiseCompanyProfileList;
  int branchId;
  dynamic branchWiseLedgerList;
  dynamic defaultImagePath;
  dynamic purchaseEditAfterStockUpdate;
  dynamic onlineUrlsqrcode;
  dynamic rmsBillDispImg;
  dynamic salesItemListFromStockTable;
  dynamic salesInvoiceDateEditable;
  dynamic purchaseDiscountLedgerId;
  dynamic purchaseAdjustLedgerId;
  dynamic salesDiscountLedgerId;
  dynamic salesAdjustLedgerId;
  dynamic mrpPrintOnThermal;
  dynamic enableBarcodeInSales;
  dynamic bypassDeliveryProcessRms;
  dynamic enableMakeorderRms;
  dynamic enablePackingSlipInSales;
  dynamic generateBarcodeInPurchase;
  String salesPrinterType;
  dynamic concurrencyTestEnable;
  dynamic applicationTaxTypeGst;
  String mainNavbarLogoName;
  String dashBoardHeaderName;
  dynamic rmsKotPrinter;
  dynamic rmsCounterPrinter;
  dynamic autoGenerateBatchInPurchase;
  dynamic printQrinSales;
  dynamic showBarcodeInInvoicePrint;
  dynamic showQrcodeInInvoicePrint;
  dynamic showPurchaseRateInSales;
  dynamic compoundingTaxableInvoice;
  dynamic printLedgerBalanceInInvoice;
  dynamic countryCode;
  dynamic countryName;
  dynamic timeZoneCode;
  dynamic currencyName;
  dynamic currencyDecimals;
  dynamic currencyCoinName;
  dynamic updateItemRateBasedOnPurchase;
  dynamic isComponentTax;
  dynamic showAllTypeItemsInSales;
  dynamic enableDayClose;
  dynamic deliveryCharge;
  dynamic invoicetypeheck;
  dynamic billCounter;
  dynamic defalutinvoicetype;
  dynamic enableLocalPrinter;
  dynamic printerTypeBlutooth;


  factory LD_Model_Generalset.fromJson(Map<String, dynamic> json) => LD_Model_Generalset(
    id: json["id"],
    enableGdn: json["enableGdn"].toString(),
    defaultSearchInSales: json["defaultSearchInSales"].toString(),
    paymentLedgerPost: json["paymentLedgerPost"].toString(),
    receiptLedgerPost: json["receiptLedgerPost"].toString(),
    journalLedgerPost: json["journalLedgerPost"].toString(),
    purchaseTaxInclusive: json["purchaseTaxInclusive"].toString(),
   salesTaxInclusive: json["salesTaxInclusive"].toString(),
    showNotesPurchaseSales: json["showNotesPurchaseSales"].toString(),
    directPrintFromSales: json["directPrintFromSales"].toString(),
    enableMasterIndexPage: json["enableMasterIndexPage"].toString(),
     enableTranIndexPage: json["enableTranIndexPage"].toString(),
     itemDefaultStockTypeId: json["itemDefaultStockTypeId"],
     itemDefaultProductTypeId: json["itemDefaultProductTypeId"],
    enableSalesDiscount: json["enableSalesDiscount"].toString(),
    enableSalesItemWiseDiscount: json["enableSalesItemWiseDiscount"].toString(),
     salesThermalPrint: json["salesThermalPrint"].toString(),
     defaInvTypeBtBorBtC: json["defaInvTypeBtBorBtC"].toString(),
     defaPayType: json["defaPayType"],
     negativeSalesAllow: json["negativeSalesAllow"].toString(),
    batchAndExpApplicable: json["batchAndExpApplicable"].toString(),
     showStockInSales: json["showStockInSales"].toString(),
     thermalPrintLogoHeight: json["thermalPrintLogoHeight"],
     thermalPrintLogoWidth: json["thermalPrintLogoWidth"],
     fixedDiscountInSales: json["fixedDiscountInSales"].toString(),
     stockBatchBaseSalesRateAlso: json["stockBatchBaseSalesRateAlso"].toString(),
     masterListBranchWise: json["masterListBranchWise"].toString(),
     applicationType: json["applicationType"].toString(),
     salesManPrintInInvoice: json["salesManPrintInInvoice"].toString(),
     loginUserPrintInInvoice: json["loginUserPrintInInvoice"].toString(),
     branchWiseEmployList: json["branchWiseEmployList"].toString(),
     branchWiseCompanyProfileList: json["branchWiseCompanyProfileList"].toString(),
     branchId: json["branchId"],
     branchWiseLedgerList: json["branchWiseLedgerList"].toString(),
     defaultImagePath: json["defaultImagePath"].toString(),
    purchaseEditAfterStockUpdate: json["purchaseEditAfterStockUpdate"].toString(),
     onlineUrlsqrcode: json["onlineUrlsqrcode"].toString(),
     rmsBillDispImg: json["rmsBillDispImg"].toString(),
    salesItemListFromStockTable: json["salesItemListFromStockTable"].toString(),
    salesInvoiceDateEditable: json["salesInvoiceDateEditable"].toString(),
     purchaseDiscountLedgerId: json["purchaseDiscountLedgerId"].toString(),
     purchaseAdjustLedgerId: json["purchaseAdjustLedgerId"].toString(),
     salesDiscountLedgerId: json["salesDiscountLedgerId"].toString(),
     salesAdjustLedgerId: json["salesAdjustLedgerId"].toString(),
     mrpPrintOnThermal: json["mrpPrintOnThermal"].toString(),
     enableBarcodeInSales: json["enableBarcodeInSales"].toString(),
     bypassDeliveryProcessRms: json["bypassDeliveryProcessRms"].toString(),
     enableMakeorderRms: json["enableMakeorderRms"].toString(),
     enablePackingSlipInSales: json["enablePackingSlipInSales"].toString(),
     generateBarcodeInPurchase: json["generateBarcodeInPurchase"].toString(),
     salesPrinterType: json["salesPrinterType"].toString(),
     concurrencyTestEnable: json["concurrencyTestEnable"].toString(),
     applicationTaxTypeGst: json["applicationTaxTypeGst"].toString(),
     mainNavbarLogoName: json["mainNavbarLogoName"].toString(),
     dashBoardHeaderName: json["dashBoardHeaderName"].toString(),
     rmsKotPrinter: json["rmsKotPrinter"].toString(),
     rmsCounterPrinter: json["rmsCounterPrinter"].toString(),
     autoGenerateBatchInPurchase: json["autoGenerateBatchInPurchase"].toString(),
     printQrinSales: json["printQrinSales"].toString(),
     showBarcodeInInvoicePrint: json["showBarcodeInInvoicePrint"].toString(),
     showQrcodeInInvoicePrint: json["showQrcodeInInvoicePrint"].toString(),
     showPurchaseRateInSales: json["showPurchaseRateInSales"].toString(),
     compoundingTaxableInvoice: json["compoundingTaxableInvoice"].toString(),
     printLedgerBalanceInInvoice: json["printLedgerBalanceInInvoice"].toString(),
     countryCode: json["countryCode"].toString(),
     countryName: json["countryName"].toString(),
     timeZoneCode: json["timeZoneCode"].toString(),
     currencyName: json["currencyName"].toString(),
     currencyDecimals: json["currencyDecimals"].toString(),
     currencyCoinName: json["currencyCoinName"].toString(),
     updateItemRateBasedOnPurchase: json["updateItemRateBasedOnPurchase"].toString(),
     isComponentTax: json["isComponentTax"].toString(),
     showAllTypeItemsInSales: json["showAllTypeItemsInSales"].toString(),
     enableDayClose: json["enableDayClose"].toString(),
     deliveryCharge: json["deliveryCharge"].toString(),
     invoicetypeheck: json["invoicetypeheck"].toString(),
     billCounter: json["billCounter"].toString(),
     defalutinvoicetype: json["defalutinvoicetype"].toString(),
     enableLocalPrinter: json["enableLocalPrinter"].toString(),
     printerTypeBlutooth: json["printerTypeBlutooth"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "enableGdn": enableGdn,
    "defaultSearchInSales": defaultSearchInSales,
    "paymentLedgerPost": paymentLedgerPost,
    "receiptLedgerPost": receiptLedgerPost,
    "journalLedgerPost": journalLedgerPost,
    "purchaseTaxInclusive": purchaseTaxInclusive,
    "salesTaxInclusive": salesTaxInclusive,
    "showNotesPurchaseSales": showNotesPurchaseSales,
    "directPrintFromSales": directPrintFromSales,
    "enableMasterIndexPage": enableMasterIndexPage,
    "enableTranIndexPage": enableTranIndexPage,
    "itemDefaultStockTypeId": itemDefaultStockTypeId,
    "itemDefaultProductTypeId": itemDefaultProductTypeId,
    "enableSalesDiscount": enableSalesDiscount,
    "enableSalesItemWiseDiscount": enableSalesItemWiseDiscount,
    "salesThermalPrint": salesThermalPrint,
    "defaInvTypeBtBorBtC": defaInvTypeBtBorBtC,
    "defaPayType": defaPayType,
    "negativeSalesAllow": negativeSalesAllow,
    "batchAndExpApplicable": batchAndExpApplicable,
    "showStockInSales": showStockInSales,
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
    "enableBarcodeInSales": enableBarcodeInSales,
    "bypassDeliveryProcessRms": bypassDeliveryProcessRms,
    "enableMakeorderRms": enableMakeorderRms,
    "enablePackingSlipInSales": enablePackingSlipInSales,
    "generateBarcodeInPurchase": generateBarcodeInPurchase,
    "salesPrinterType": salesPrinterType,
    "concurrencyTestEnable": concurrencyTestEnable,
    "applicationTaxTypeGst": applicationTaxTypeGst,
    "mainNavbarLogoName": mainNavbarLogoName,
    "dashBoardHeaderName": dashBoardHeaderName,
    "rmsKotPrinter": rmsKotPrinter,
    "rmsCounterPrinter": rmsCounterPrinter,
    "autoGenerateBatchInPurchase": autoGenerateBatchInPurchase,
    "printQrinSales": printQrinSales,
    "showBarcodeInInvoicePrint": showBarcodeInInvoicePrint,
    "showQrcodeInInvoicePrint": showQrcodeInInvoicePrint,
    "showPurchaseRateInSales": showPurchaseRateInSales,
    "compoundingTaxableInvoice": compoundingTaxableInvoice,
    "printLedgerBalanceInInvoice": printLedgerBalanceInInvoice,
    "countryCode": countryCode,
    "countryName": countryName,
    "timeZoneCode": timeZoneCode,
    "currencyName": currencyName,
    "currencyDecimals": currencyDecimals,
    "currencyCoinName": currencyCoinName,
    "updateItemRateBasedOnPurchase": updateItemRateBasedOnPurchase,
    "isComponentTax": isComponentTax,
    "showAllTypeItemsInSales": showAllTypeItemsInSales,
    "enableDayClose": enableDayClose,
    "deliveryCharge": deliveryCharge,
    "invoicetypeheck": invoicetypeheck,
    "billCounter": billCounter,
    "defalutinvoicetype": defalutinvoicetype,
    "enableLocalPrinter": enableLocalPrinter,
    "printerTypeBlutooth": printerTypeBlutooth
  };




  Map<String, dynamic> toMap() => {
    "id": id,
    "enableGdn": enableGdn,
    "defaultSearchInSales": defaultSearchInSales,
    "paymentLedgerPost": paymentLedgerPost,
    "receiptLedgerPost": receiptLedgerPost,
    "journalLedgerPost": journalLedgerPost,
    "purchaseTaxInclusive": purchaseTaxInclusive,
    "salesTaxInclusive": salesTaxInclusive,
    "showNotesPurchaseSales": showNotesPurchaseSales,
    "directPrintFromSales": directPrintFromSales,
    "enableMasterIndexPage": enableMasterIndexPage,
    "enableTranIndexPage": enableTranIndexPage,
    "itemDefaultStockTypeId": itemDefaultStockTypeId,
    "itemDefaultProductTypeId": itemDefaultProductTypeId,
    "enableSalesDiscount": enableSalesDiscount,
    "enableSalesItemWiseDiscount": enableSalesItemWiseDiscount,
    "salesThermalPrint": salesThermalPrint,
    "defaInvTypeBtBorBtC": defaInvTypeBtBorBtC,
    "defaPayType": defaPayType,
    "negativeSalesAllow": negativeSalesAllow,
    "batchAndExpApplicable": batchAndExpApplicable,
    "showStockInSales": showStockInSales,
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
    "enableBarcodeInSales": enableBarcodeInSales,
    "bypassDeliveryProcessRms": bypassDeliveryProcessRms,
    "enableMakeorderRms": enableMakeorderRms,
    "enablePackingSlipInSales": enablePackingSlipInSales,
    "generateBarcodeInPurchase": generateBarcodeInPurchase,
    "salesPrinterType": salesPrinterType,
    "concurrencyTestEnable": concurrencyTestEnable,
    "applicationTaxTypeGst": applicationTaxTypeGst,
    "mainNavbarLogoName": mainNavbarLogoName,
    "dashBoardHeaderName": dashBoardHeaderName,
    "rmsKotPrinter": rmsKotPrinter,
    "rmsCounterPrinter": rmsCounterPrinter,
    "autoGenerateBatchInPurchase": autoGenerateBatchInPurchase,
    "printQrinSales": printQrinSales,
    "showBarcodeInInvoicePrint": showBarcodeInInvoicePrint,
    "showQrcodeInInvoicePrint": showQrcodeInInvoicePrint,
    "showPurchaseRateInSales": showPurchaseRateInSales,
    "compoundingTaxableInvoice": compoundingTaxableInvoice,
    "printLedgerBalanceInInvoice": printLedgerBalanceInInvoice,
    "countryCode": countryCode,
    "countryName": countryName,
    "timeZoneCode": timeZoneCode,
    "currencyName": currencyName,
    "currencyDecimals": currencyDecimals,
    "currencyCoinName": currencyCoinName,
    "updateItemRateBasedOnPurchase": updateItemRateBasedOnPurchase,
    "isComponentTax": isComponentTax,
    "showAllTypeItemsInSales": showAllTypeItemsInSales,
    "enableDayClose": enableDayClose,
    "deliveryCharge": deliveryCharge,
    "invoicetypeheck": invoicetypeheck,
    "billCounter": billCounter,
    "defalutinvoicetype": defalutinvoicetype,
    "enableLocalPrinter": enableLocalPrinter,
    "printerTypeBlutooth": printerTypeBlutooth
  };
}
