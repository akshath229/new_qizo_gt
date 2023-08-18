

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';

import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/customersearch.dart';
import '../models/finishedgoods.dart';
import '../sales.dart';
import 'GetDatas_FromServer.dart';
import 'Local_db_Model/LD_Model_Company.dart';
import 'Local_db_Model/LD_Model_GeneralSettings.dart';
import 'Local_db_Model/LD_Model_Godown.dart';
import 'Local_db_Model/LD_Model_ItemMaster.dart';
import 'Local_db_Model/LD_Model_Sales.dart';
import 'Local_db_Model/LD_model_UnitTyp.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';

import 'Local_db_Model/Ld_Model_LedgerHeades.dart';
import 'Offline_Print.dart';
class Local_Db{


  ///----------------Comon part for- open db/inset data /clear data----------------------------

  static List<Saless> sales = [];

  PrinterNetworkManager _printerManager = PrinterNetworkManager();
  open_Db()async{

    Directory? documentsDirectory = await getExternalStorageDirectory();
    var  path = join(documentsDirectory!.path, "qizo_Gt_LocalDb.db");

    final database = openDatabase(path);
    final db = await database;
    return db;
  }


  LocalDb_InitialFunction() async {


    final Directory? directory = await getExternalStorageDirectory();
    var path=directory?.path;
    print("path");
    print(path);
    var  db =await openDatabase(join(path!,"qizo_Gt_LocalDb.db"),
      onCreate: (db,version) =>_createDb(db),
      version: 1,
    );
    print(db.isOpen);
    var s=await db.getVersion();
    Local_Db().Getall_DataFrom_server();
    print(s.toString());
  }
  static void _createDb(Database db) {
    print("TABLE IF NOT EXISTS");
    db.execute('CREATE TABLE GeneralSettings(Local_id INTEGER PRIMARY KEY, id INTEGER, '
    'enableGdn TEXT, defaultSearchInSales TEXT, paymentLedgerPost TEXT, receiptLedgerPost TEXT, journalLedgerPost TEXT, purchaseTaxInclusive TEXT,'
    'salesTaxInclusive TEXT,showNotesPurchaseSales TEXT,directPrintFromSales TEXT,enableMasterIndexPage TEXT,enableTranIndexPage TEXT, itemDefaultStockTypeId INTEGER,'
    'itemDefaultProductTypeId INTEGER, enableSalesDiscount TEXT, enableSalesItemWiseDiscount TEXT,salesThermalPrint TEXT, defaInvTypeBtBorBtC TEXT,  '
    'defaPayType INTEGER, negativeSalesAllow TEXT, batchAndExpApplicable TEXT,showStockInSales TEXT,thermalPrintLogoHeight INTEGER, thermalPrintLogoWidth INTEGER,  '
    'fixedDiscountInSales TEXT, stockBatchBaseSalesRateAlso TEXT, masterListBranchWise TEXT, applicationType TEXT, salesManPrintInInvoice TEXT,loginUserPrintInInvoice TEXT,   '
    'branchWiseEmployList TEXT,branchWiseCompanyProfileList TEXT,branchId INTEGER,branchWiseLedgerList TEXT, defaultImagePath TEXT, purchaseEditAfterStockUpdate TEXT, '
     'onlineUrlsqrcode TEXT, rmsBillDispImg TEXT, salesItemListFromStockTable TEXT , salesInvoiceDateEditable TEXT, purchaseDiscountLedgerId TEXT, purchaseAdjustLedgerId TEXT, salesDiscountLedgerId TEXT,'
     'salesAdjustLedgerId TEXT, mrpPrintOnThermal TEXT, enableBarcodeInSales TEXT, bypassDeliveryProcessRms TEXT, enableMakeorderRms TEXT, enablePackingSlipInSales TEXT, generateBarcodeInPurchase TEXT,'
    'salesPrinterType TEXT, concurrencyTestEnable TEXT, applicationTaxTypeGst TEXT, mainNavbarLogoName TEXT, dashBoardHeaderName TEXT, rmsKotPrinter TEXT, rmsCounterPrinter TEXT, autoGenerateBatchInPurchase TEXT,'
    'printQrinSales TEXT, showBarcodeInInvoicePrint TEXT, showQrcodeInInvoicePrint TEXT, showPurchaseRateInSales TEXT, compoundingTaxableInvoice TEXT, printLedgerBalanceInInvoice TEXT, '
    'countryCode TEXT, countryName TEXT, timeZoneCode TEXT, currencyName TEXT, currencyDecimals TEXT, currencyCoinName TEXT, updateItemRateBasedOnPurchase TEXT, isComponentTax TEXT,  '
     'showAllTypeItemsInSales TEXT, enableDayClose TEXT, deliveryCharge TEXT, invoicetypeheck TEXT, billCounter TEXT,defalutinvoicetype TEXT, enableLocalPrinter TEXT, printerTypeBlutooth TEXT)');
    db.execute('CREATE TABLE BankDet(Local_id INTEGER PRIMARY KEY, id DOUBLE, lhName TEXT,lhGroupId INTEGER)');
    db.execute('CREATE TABLE GtRelItemUom(Local_id INTEGER PRIMARY KEY, id INTEGER, description TEXT,unitid INTEGER,itemid INTEGER, mrp DOUBLE, srate DOUBLE,prate DOUBLE)');
    db.execute('CREATE TABLE GTUnits(Local_id INTEGER PRIMARY KEY, id INTEGER, description TEXT, nos INTEGER)');
    db.execute('CREATE TABLE MobLedgerheads(Local_id INTEGER PRIMARY KEY, id INTEGER, lhName TEXT, lhGroupId INTEGER)');
    db.execute('CREATE TABLE GodownMaster( Local_id INTEGER PRIMARY KEY, gdnId INTEGER, gdnDescription TEXT, gdnInCharge INTEGER, gdnContactNumber TEXT, gdnAddress TEXT, gdnUserId INTEGER, gdnBranchId INTEGER)');
    db.execute('CREATE TABLE ItemMaster(Local_id INTEGER PRIMARY KEY, id INTEGER, itmName TEXT, itmTaxId INTEGER,'
        'itmUnitId INTEGER, itmHsn TEXT, itmSalesRate DOUBLE, itmMrp DOUBLE, itmPurchaseRate DOUBLE,itmTaxInclusive TEXT,'
        'txPercentage DOUBLE, atPercentage DOUBLE, txCgstPercentage DOUBLE, txSgstPercentage DOUBLE, txIgstpercentage DOUBLE,itmBarCode TEXT)');
    db.execute('CREATE TABLE salesHeader(localSyncId INTEGER PRIMARY KEY ,VoucherNo  INT, VoucherDate  NUMERIC,'
        'OrderHeadId  INT,OrderDate NUMERIC,ExpDate  NUMERIC,LedgerID NUMERIC, PartyName TEXT,'
        'Address1 TEXT,Address2 TEXT,GstNo  TEXT,Phone  TEXT,ShipToName TEXT,ShipToAddress1  TEXT,'
        'ShipToAddress2  TEXT, ShipToPhone TEXT, Narration TEXT,Amount REAL,OtherAmt  REAL,'
        'DiscountAmt  REAL,CreditPeriod  REAL,PaymentCondition REAL,PaymentType  INT,InvoiceType  TEXT,'
        'InvoicePrefix  TEXT,InvoiceSuffix  TEXT,CancelFlg  TEXT,EntryDate  NUMERIC,SlesManID  INT,'
        'BranchUpdated  REAL,UserId INT,BranchId  INT,SaleTypeInterState REAL,cancelRemarks  TEXT,cancelUserId  INT,'
        'adlDiscPercent REAL,adlDiscAmount  REAL,adjustAmount  REAL,salesDetails List, cashReceived  REAL,balanceAmount  REAL,'
        'otherAmountReceived  REAL, tokenNo  REAL,deliveryType  TEXT,deliveryTo  TEXT,orderstatus  TEXT, '
        'orderType  TEXT,Tax_amt REAL, WiFi  TEXT,Round_Off  REAL, dataSync INT, syncServerId INT, Machinecode VARCHAR, SyncVoucherNo INTEGER)');
    db.execute('CREATE TABLE salesDetails(Id	INTEGER PRIMARY KEY, '
        'qty	NUMERIC, rate	NUMERIC,itemId NUMERIC, disPercentage	NUMERIC, itmName TEXT,cgstPercentage	NUMERIC, sgstPercentage	NUMERIC,cessPercentage	NUMERIC,'
        'discountAmount	NUMERIC,cgstAmount	NUMERIC,sgstAmount	NUMERIC,cessAmount	NUMERIC,igstPercentage	NUMERIC,igstAmount	NUMERIC,'
        'taxPercentage	NUMERIC,taxAmount	NUMERIC,taxInclusive	INT,amountBeforeTax	NUMERIC,amountIncludingTax	NUMERIC,netTotal	NUMERIC,'
        'hsncode	TEXT,gdnId	INT,taxId	INT,rackId	INT,addTaxId	INT,unitId	INT,stockId	REAL,batchNo	TEXT,expiryDate	REAL, notes	TEXT,'
        'barcode	TEXT,nosInUnit	NUMERIC,adlDiscPercent	NUMERIC,adlDiscAmount	NUMERIC,itemSlNo	INT,Mrp	NUMERIC,Prate	NUMERIC,salesManIdDet	INT,'
        'SHID INTEGER,'
        'FOREIGN KEY(SHID) REFERENCES salesHeader(localSyncId))'
    );
    db.execute('CREATE TABLE vansalepaymenttypes(Local_id INTEGER PRIMARY KEY, ledgerid INTEGER, SHID INTEGER, Amount VARCHAR, FOREIGN KEY(SHID) REFERENCES salesHeader(localSyncId))');
    db.execute('CREATE TABLE GTCompanyMaster(id INTEGER PRIMARY KEY, companyProfileId INTEGER, companyProfileName TEXT,'
        'companyProfileShortName TEXT, companyProfileMailingName TEXT,companyProfileAddress1 TEXT,'
        'companyProfileAddress2 TEXT, companyProfileAddress3 TEXT,companyProfileGstNo TEXT,'
        ' companyProfilePan TEXT, companyProfileMobile TEXT,companyProfileContact TEXT,companyProfileEmail TEXT,'
        'companyProfileWeb TEXT,companyProfileBankName TEXT,companyProfileAccountNo TEXT,companyProfileBranch TEXT,'
        'companyProfileIfsc TEXT,companyProfileImagePath TEXT,companyProfileIsPrintHead TEXT,companyProfileStateId INTEGER,'
        ' companyProfileLedgerId INTEGER, companyProfilePin TEXT,companyProfileNameLatin TEXT, buildingNo TEXT,'
        ' buildingNoLatin TEXT, streetName TEXT,streetNameLatin TEXT, district TEXT, districtLatin TEXT, city TEXT,'
        'cityLatin TEXT,country TEXT,countryLatin TEXT,pinNo TEXT,pinNoLatin TEXT,companyProfileLedger TEXT,'
        'companyProfileState TEXT)');
  }

  Inser_Server_data({required String TableName,data})async{
    var db=await open_Db();
    var clr=await ClearTable(TableName);

    var res= await db.insert(
      '$TableName',
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.rollback,
    );


    // if(TableName=="ItemMaster"){
    //   print("---data---");
    //   print(res.toString());
    //
    // }

  }



  ClearTable(tbl_name)async{

    Database db=await open_Db();
    try {
      var res = await db.rawQuery('delete from $tbl_name');
    }catch(e){
      print("Error on ClearTable $e");
    }
  }




  DropTable()async{
    var db=await open_Db();
    await _dropDbtbl(db);
  }
  static void _dropDbtbl(Database db) {
    db.execute('DROP TABLE IF EXISTS GTUnits');
    db.execute('DROP TABLE IF EXISTS MobLedgerheads');
    db.execute('DROP TABLE IF EXISTS GodownMaster');
    db.execute('DROP TABLE IF EXISTS ItemMaster');
    db.execute('DROP TABLE IF EXISTS salesHeader');
    db.execute('DROP TABLE IF EXISTS salesDetails');
    db.execute('DROP TABLE IF EXISTS GTCompanyMaster');
  }




  UpdateTodb() async{
    var db=await open_Db();
    //_createDb(db);
    _updateDb(db);
  }

  static void _updateDb(Database db) {
    print("update TABLE ");

    db.execute('CREATE TABLE GTCompanyMaster(id INTEGER PRIMARY KEY, companyProfileId INTEGER, companyProfileName TEXT,'
        'companyProfileShortName TEXT, companyProfileMailingName TEXT,companyProfileAddress1 TEXT,'
        'companyProfileAddress2 TEXT, companyProfileAddress3 TEXT,companyProfileGstNo TEXT,'
        ' companyProfilePan TEXT, companyProfileMobile TEXT,companyProfileContact TEXT,companyProfileEmail TEXT,'
        'companyProfileWeb TEXT,companyProfileBankName TEXT,companyProfileAccountNo TEXT,companyProfileBranch TEXT,'
        'companyProfileIfsc TEXT,companyProfileImagePath TEXT,companyProfileIsPrintHead TEXT,companyProfileStateId INTEGER,'
        ' companyProfileLedgerId INTEGER, companyProfilePin TEXT,companyProfileNameLatin TEXT, buildingNo TEXT,'
        ' buildingNoLatin TEXT, streetName TEXT,streetNameLatin TEXT, district TEXT, districtLatin TEXT, city TEXT,'
        'cityLatin TEXT,country TEXT,countryLatin TEXT,pinNo TEXT,pinNoLatin TEXT,companyProfileLedger TEXT,'
        'companyProfileState TEXT)');
  }


//----------Get data from server Db and inset in to Local db--------------------------------------
  Getall_DataFrom_server(){
    try {
      print("Getall_DataFrom_server");
      UnitTable_Post();
      UnitTables_Post();
      Ledgerheads_Post();
      Godown_Post();
      Items_Post();
      Compan_Post();
      GeneralSettings_Post();

    }catch(e){
      print("catch the data get from server " + e.toString());
    }
  }


  UnitTables_Post()async{

    var data;
    List<UnitTypes> res= await GetData_FromServer().GetUnit_Servers();
    if(res!=null) {
      res.forEach((element) {
        data = LD_Model_UnitTyps(
          id: element.id,
          unitId: element.unitId,
          // description: element.description,
          itemid: element.itemid,
          mrp: element.mrp,
          srate: element.srate,
          prate: element.prate,
        );
        Inser_Server_data(TableName: "GtRelItemUom", data: data);
      });


      return;
      // await Insertdata(data);

    }
  }

  UnitTable_Post()async{

    var data;
    List<UnitType> res= await GetData_FromServer().GetUnit_Server();
    if(res!=null) {
      res.forEach((element) {
        data = LD_Model_UnitTyp(
          id: element.id,
          description: element.description,
          nos: element.nos,
        );
        Inser_Server_data(TableName: "GTUnits", data: data);
      });


      return;
      // await Insertdata(data);

    }
  }

  Ledgerheads_Post()async {
    var data;
    List<Customer> res = await GetData_FromServer().GetLedgerHeads_Server();

    if (res != null) {
      res.forEach((element) {
        data = LD_Model_LedgerHeads(
          id: element.id,
          lhName: element.lhName,
          lhGroupId: element.lhGroupId,
        );
        Inser_Server_data(TableName: "MobLedgerheads", data: data);
      });
      return;
      // await Insertdata(data);
    }
  }

  Godown_Post()async{

    var data;
    List<Godown> res= await GetData_FromServer().Get_Godowm_Server();
    if (res != null) {
      res.forEach((element) {
        data = LD_Model_Godown(
          gdnId: element.gdnId,
          gdnDescription: element.gdnDescription,
        );
        Inser_Server_data(TableName: "GodownMaster", data: data);
      });


      return;
      // await Insertdata(data);
    }

  }

  Items_Post()async{
    List<FinishedGoods> res= await GetData_FromServer().GetItemMaster_Server();
    if (res != null) {
      res.forEach((element) {
        LD_Model_ItemMaster data = LD_Model_ItemMaster(
            id: element.id,
            itmName: element.itmName,
            itmTaxInclusive: element.itmTaxInclusive,
            itmTaxId: element.itmTaxId,
            itmUnitId: element.itmUnitId,
            itmHsn: element.itmHsn,
            txPercentage: element.txPercentage,
            txCgstPercentage: element.txCgstPercentage,
            txSgstPercentage: element.txSgstPercentage,
            txIgstpercentage: element.txIgstpercentage,
            atPercentage: element.atPercentage,
            itmPurchaseRate: element.itmPurchaseRate,
            itmSalesRate: element.itmSalesRate,
            itmMrp: element.itmMrp,
            itmBarCode: element.itmBarCode
        );
        Inser_Server_data(TableName: "ItemMaster", data: data);
      });
    }

  }

  GeneralSettings_Post() async{
    var data;
    List<LD_Model_Generalset> res= await GetData_FromServer().Get_GeneralData_Server();
    if (res != null) {
      res.forEach((element) {
        data = LD_Model_Generalset(
          id: element.id,
          enableGdn: element.enableGdn,
          defaultSearchInSales: element.defaultSearchInSales,
          paymentLedgerPost: element.paymentLedgerPost,
          receiptLedgerPost: element.receiptLedgerPost,
          journalLedgerPost: element.journalLedgerPost,
          purchaseTaxInclusive: element.purchaseTaxInclusive,
          salesTaxInclusive: element.salesTaxInclusive,
          showNotesPurchaseSales: element.showNotesPurchaseSales,
          directPrintFromSales: element.directPrintFromSales,
          enableMasterIndexPage: element.enableMasterIndexPage,
          enableTranIndexPage: element.enableTranIndexPage,
          itemDefaultStockTypeId: element.itemDefaultStockTypeId,
          itemDefaultProductTypeId: element.itemDefaultProductTypeId,
          enableSalesDiscount: element.enableSalesDiscount,
          enableSalesItemWiseDiscount: element.enableSalesItemWiseDiscount,
          salesThermalPrint: element.salesThermalPrint,
          defaInvTypeBtBorBtC: element.defaInvTypeBtBorBtC,
          defaPayType: element.defaPayType,
          negativeSalesAllow: element.negativeSalesAllow,
          batchAndExpApplicable: element.batchAndExpApplicable,
          showStockInSales: element.showStockInSales,
          thermalPrintLogoHeight: element.thermalPrintLogoHeight,
          thermalPrintLogoWidth:element.thermalPrintLogoWidth,
          fixedDiscountInSales: element.fixedDiscountInSales,
          stockBatchBaseSalesRateAlso: element.stockBatchBaseSalesRateAlso,
          masterListBranchWise: element.masterListBranchWise,
          applicationType: element.applicationType,
          salesManPrintInInvoice: element.salesManPrintInInvoice,
          loginUserPrintInInvoice: element.loginUserPrintInInvoice,
          branchWiseEmployList: element.branchWiseEmployList,
          branchWiseCompanyProfileList: element.branchWiseCompanyProfileList,
          branchId: element.branchId,
          branchWiseLedgerList: element.branchWiseLedgerList,
          defaultImagePath: element.defaultImagePath,
          purchaseEditAfterStockUpdate: element.purchaseEditAfterStockUpdate,
          onlineUrlsqrcode: element.onlineUrlsqrcode,
          rmsBillDispImg: element.rmsBillDispImg,
          salesItemListFromStockTable: element.salesItemListFromStockTable,
          salesInvoiceDateEditable: element.salesInvoiceDateEditable,
          purchaseDiscountLedgerId: element.purchaseDiscountLedgerId,
          purchaseAdjustLedgerId: element.purchaseAdjustLedgerId,
          salesDiscountLedgerId: element.salesDiscountLedgerId,
          salesAdjustLedgerId: element.salesAdjustLedgerId,
          mrpPrintOnThermal: element.mrpPrintOnThermal,
          enableBarcodeInSales: element.enableBarcodeInSales,
          bypassDeliveryProcessRms: element.bypassDeliveryProcessRms,
          enableMakeorderRms: element.enableMakeorderRms,
          enablePackingSlipInSales: element.enablePackingSlipInSales,
          generateBarcodeInPurchase: element.generateBarcodeInPurchase,
          salesPrinterType: element.salesPrinterType,
          concurrencyTestEnable: element.concurrencyTestEnable,
          applicationTaxTypeGst: element.applicationTaxTypeGst,
          mainNavbarLogoName: element.mainNavbarLogoName,
          dashBoardHeaderName: element.dashBoardHeaderName,
          rmsKotPrinter: element.rmsKotPrinter,
          rmsCounterPrinter: element.rmsCounterPrinter,
          autoGenerateBatchInPurchase: element.autoGenerateBatchInPurchase,
          printQrinSales: element.printQrinSales,
          showBarcodeInInvoicePrint: element.showBarcodeInInvoicePrint,
          showQrcodeInInvoicePrint: element.showQrcodeInInvoicePrint,
          showPurchaseRateInSales: element.showPurchaseRateInSales,
          compoundingTaxableInvoice: element.compoundingTaxableInvoice,
          printLedgerBalanceInInvoice: element.printLedgerBalanceInInvoice,
          countryCode: element.countryCode,
          countryName: element.countryName,
          timeZoneCode: element.timeZoneCode,
          currencyName: element.currencyName,
          currencyDecimals: element.currencyDecimals,
          currencyCoinName: element.currencyCoinName,
          updateItemRateBasedOnPurchase: element.updateItemRateBasedOnPurchase,
          isComponentTax: element.isComponentTax,
          showAllTypeItemsInSales: element.showAllTypeItemsInSales,
          enableDayClose: element.enableDayClose,
          deliveryCharge: element.deliveryCharge,
          invoicetypeheck: element.invoicetypeheck,
          billCounter: element.billCounter,
          defalutinvoicetype: element.defalutinvoicetype,
          enableLocalPrinter: element.enableLocalPrinter,
          printerTypeBlutooth: element.printerTypeBlutooth,
        );
        Inser_Server_data(TableName: "GeneralSettings", data: data);
      });


      return;
      // await Insertdata(data);
    }
    
    
    
  }

  Compan_Post()async{

    var data;
    List<LD_Model_Company> res= await GetData_FromServer().Get_CompanyData_Server();
    if (res != null) {
      res.forEach((element) {
        data = LD_Model_Company(
          companyProfileId: element.companyProfileId,
          companyProfileName: element.companyProfileName,
          companyProfileShortName: element.companyProfileShortName,
          companyProfileMailingName: element.companyProfileMailingName,
          companyProfileAddress1: element.companyProfileAddress1,
          companyProfileAddress2: element.companyProfileAddress2,
          companyProfileAddress3: element.companyProfileAddress3,
          companyProfileGstNo: element.companyProfileGstNo,
          companyProfilePan: element.companyProfilePan,
          companyProfileMobile: element.companyProfileMobile,
          companyProfileContact: element.companyProfileContact,
          companyProfileEmail: element.companyProfileEmail,
          companyProfileWeb: element.companyProfileWeb,
          companyProfileBankName: element.companyProfileBankName,
          companyProfileAccountNo: element.companyProfileAccountNo,
          companyProfileBranch: element.companyProfileBranch,
          companyProfileIfsc: element.companyProfileIfsc,
          companyProfileImagePath: element.companyProfileImagePath,
          companyProfileIsPrintHead: element.companyProfileIsPrintHead,
          companyProfileStateId: element.companyProfileStateId,
          companyProfileLedgerId: element.companyProfileLedgerId,
          companyProfilePin: element.companyProfilePin,
          companyProfileNameLatin: element.companyProfileNameLatin,
          buildingNo: element.buildingNo,
          buildingNoLatin: element.buildingNoLatin,
          streetName: element.streetName,
          streetNameLatin: element.streetNameLatin,
          district: element.district,
          districtLatin: element.districtLatin,
          city: element.city,
          cityLatin: element.cityLatin,
          country: element.country,
          countryLatin: element.countryLatin,
          pinNo: element.pinNo,
          pinNoLatin: element.pinNoLatin,
          companyProfileLedger: element.companyProfileLedger,
          companyProfileState: element.companyProfileState,
        );
        Inser_Server_data(TableName: "GTCompanyMaster", data: data);
      });


      return;
      // await Insertdata(data);
    }

  }



//------------Get datas---From Local-------------------------


  GetUnitDatas()async{

    var db=await open_Db();
    // Get a reference to the database.
    // Query the table for all The Dogs.
    final   maps = await db.rawQuery('select GtRelItemUom.unitid,GtRelItemUom.srate,GTUnits.description,GtRelItemUom.itemid from GtRelItemUom inner join GTUnits on GTUnits.id=GtRelItemUom.unitid');
    print("maps GTUnfffits");
    print(maps);
    print(maps as List);

    // List <dynamic> tagsJson = json.decode(maps);
    List <dynamic> tagsJson =maps as List;
    List<LD_Model_UnitTyps> ut = tagsJson.map((tagsJson) =>
        LD_Model_UnitTyps.fromJson(tagsJson)).toList();
    print("uuuuxx : $ut");
// unit = ut;

    return  ut;


  }
  GetUnitDatasRel(id)async{

    var db=await open_Db();
    // Get a reference to the database.
    // Query the table for all The Dogs.
    print("maps GTUnighdts" + id.toString());
    final   maps = await db.rawQuery('select GtRelItemUom.unitid,GtRelItemUom.srate,GTUnits.description,GtRelItemUom.itemid from GtRelItemUom inner join GTUnits on GTUnits.id=GtRelItemUom.unitid where GtRelItemUom.itemid= $id');
    print(maps);
    print(maps as List);

    // List <dynamic> tagsJson = json.decode(maps);
    List <dynamic> tagsJson =maps as List;
    List<LD_Model_UnitTyps> ut = tagsJson.map((tagsJson) =>
        LD_Model_UnitTyps.fromJson(tagsJson)).toList();
    print("uuuughhg : $ut");
// unit = ut;

    return  ut;


  }

  GetUnitData()async{

    var db=await open_Db();
    // Get a reference to the database.


    // Query the table for all The Dogs.
    final   maps = await db.query('GTUnits');
    print("maps GTUnits");
    print(maps);
    print(maps as List);

    // List <dynamic> tagsJson = json.decode(maps);
    List <dynamic> tagsJson =maps as List;
    List<LD_Model_UnitTyp> ut = tagsJson.map((tagsJson) =>
        LD_Model_UnitTyp.fromJson(tagsJson)).toList();
    print("uuuu : $ut");
// unit = ut;

    return  ut;


  }

  GetGodownData()async{

    var db=await open_Db();
    // Get a reference to the database.


    // Query the table for all The Dogs.
    final   maps = await db.query('GodownMaster');
    print("maps GodownMaster");
    print(maps);
    print(maps as List);

    // List <dynamic> tagsJson = json.decode(maps);
    List <dynamic> tagsJson =maps as List;
    List<LD_Model_Godown> data = tagsJson.map((tagsJson) =>
        LD_Model_Godown.fromJson(tagsJson)).toList();

// unit = ut;

    return  data;


  }


  ///............................statrt..................................................



  GetUpdateData(Id) async {
    var db = await open_Db();
    print("Get_Data_ForPrint" + Id.toString());


    final List<Map<String, dynamic>> mapsHeader = await db.rawQuery("SELECT * FROM salesHeader where localSyncId= $Id");
    final List<Map<String, dynamic>> mapsDetails = await db.rawQuery(
        'SELECT qty, rate,itemId, disPercentage,itmName,cgstPercentage, sgstPercentage, cessPercentage, discountAmount,'
            'cgstAmount,  sgstAmount,cessAmount,igstPercentage, igstAmount, taxPercentage, taxAmount, taxInclusive, amountBeforeTax,'
            'amountIncludingTax, netTotal, hsncode, gdnId, taxId, rackId, addTaxId, unitId, stockId, batchNo, expiryDate, notes,  barcode,'
            'nosInUnit, adlDiscPercent, adlDiscAmount, itemSlNo, Mrp, Prate, salesManIdDet FROM salesDetails where SHID=$Id');
    final List<Map<String, dynamic>> mapvansalepaymenttypes = await db.rawQuery("SELECT ledgerid, Amount FROM vansalepaymenttypes where SHID= $Id");
    print("mapsHeader");
    print("mapsDetails");
    print(mapsHeader);



    print(mapsDetails);
    print("the servseradsef " + mapsHeader[0]["syncServerId"].toString());
    if(mapsHeader[0]["syncServerId"] != null){
      print("its all right " );
    }

    else {
      var reqest = {
        "voucherDate": mapsHeader[0]["VoucherDate"],
        //serverDate.toString(),
        "orderHeadId": null,
        "orderDate": null,
        "expDate": null,
        "ledgerId": mapsHeader[0]["LedgerID"],
        "partyName": mapsHeader[0]["PartyName"],
        "address1": null,
        "address2": null,
        "gstNo": null,
        "phone": null,
        "shipToName": null,
        "shipToAddress1": null,
        "shipToAddress2": null,
        "shipToPhone": null,
        "narration": mapsHeader[0]["Narration"],
        "amount": mapsHeader[0]["Amount"], // (grandTotal-DiscountAmount),
        "userId": mapsHeader[0]["UserId"],
        "branchId": mapsHeader[0]["BranchId"],
        "otherAmt": 0.00,
        "discountAmt": 0.00,
        "creditPeriod": null,
        "paymentCondition": mapsHeader[0]["PaymentCondition"],
        "paymentType": mapsHeader[0]["PaymentType"],
        "invoiceType": "BtoB",
        "invoicePrefix": null,
        "invoiceSuffix": null,
        "cancelFlg": null,
        "entryDate": null,
        "slesManId": null,
        "branchUpdated": false,
        "saleTypeInterState": false,
        "Machinecode": mapsHeader[0]["Machinecode"],
        "SyncVoucherNo": 0,
        "vansalepaymenttypes": mapvansalepaymenttypes,
        "salesDetails": mapsDetails,
        "salesExpense": []
      };

      print("the request is" + reqest.toString());
      if (mapsHeader.isNotEmpty) {
        return reqest;
      }
    }




  }


  ///.................................stop................................................
  GetItemMasterData()async{

    var db=await open_Db();

    final   maps = await db.query('ItemMaster');
    print("maps ItemMaster");
    print(maps);
    print(maps as List);

    // List <dynamic> tagsJson = json.decode(maps);
    List <dynamic> tagsJson =maps as List;
    List<LD_Model_ItemMaster> data = tagsJson.map((tagsJson) =>
        LD_Model_ItemMaster.fromJson(tagsJson)).toList();

// unit = ut;

    return  data;


  }

  GetLedgerMasterData()async{

    var db=await open_Db();

    final   maps = await db.query('MobLedgerheads');
    print("maps MobLedgerheads");
    print(maps);
    print(maps as List);

    // List <dynamic> tagsJson = json.decode(maps);
    List <dynamic> tagsJson =maps as List;
    List<LD_Model_LedgerHeads> data = tagsJson.map((tagsJson) =>
        LD_Model_LedgerHeads.fromJson(tagsJson)).toList();



// unit = ut;

    return  data;


  }

  GetCompanyMasterData()async{

    var db=await open_Db();

    final   maps = await db.query('GTCompanyMaster');
    print("maps GTCompanyMaster");
    print(maps);
    print(maps as List);

    // List <dynamic> tagsJson = json.decode(maps);
    List <dynamic> tagsJson =maps as List;
    List<LD_Model_Company> data = tagsJson.map((tagsJson) =>
        LD_Model_Company.fromJson(tagsJson)).toList();

// unit = ut;

    return  data;


  }

//-----------------------------Manual select Query---------------------------

  Get_Selected_ItemData(id)async{

    var db=await open_Db();

    final List<Map<String, dynamic>> maps = await db.rawQuery("SELECT  * FROM ItemMaster  where id =$id");

    print("----- Get_Selected_ItemData-----");
    print(maps);

    return maps;


  }

  Get_Data_ForPrint(id)async{
    var db=await open_Db();
    print("Get_Data_ForPrint");
    print(id.toString());
    final List<Map<String, dynamic>> mapsHeader = await db.rawQuery("SELECT * FROM salesHeader where localSyncId=$id");
    final List<Map<String, dynamic>> mapsDetails = await db.rawQuery("SELECT * FROM salesDetails where SHID=$id");
    final List<Map<String, dynamic>> mapsAmounts = await db.rawQuery("SELECT * FROM vansalepaymenttypes where SHID=$id");

    print("mapsHeader");
    print("mapsDetails");
    print(mapsHeader);
    print(mapsDetails);
    if(mapsHeader.isNotEmpty) {
      //var _tagsJson = mapsHeader;
      // List<LD_Model_Sales> data = _tagsJson.map((tagsJson) =>
      //     LD_Model_Sales.fromJson(tagsJson)).toList();

      //  var _tagsJsonDtls = mapsDetails;

      // List<SalesDetail> dataDtls = _tagsJsonDtls.map((tagsJson) =>
      //     SalesDetail.fromJson(tagsJson)).toList();

      return [{"salesHeader": mapsHeader, "vansalepaymenttypes":mapsAmounts, "salesDetails":mapsDetails}];
    }

    // print("salesHeader");
    // log(mapsHeader.toString());
    // print("salesDetails");
    // log(mapsDetails.toString());
    // print("----- Get_Selected_ItemData-----");


  }



//--------------------Sales Post-----------------

  PostToSales(List<LD_Model_Sales> Sales_data)async{

    Sales_data.forEach((element)  {
      var  data =  LD_Model_Sales(
        voucherDate: element.voucherDate,
        orderHeadId: element.orderHeadId,
        orderDate: element.orderDate,
        expDate: element.expDate,
        ledgerId: element.ledgerId,
        partyName: element.partyName,
        address1: element.address1,
        address2: element.address2,
        gstNo: element.gstNo,
        phone: element.phone,
        shipToName: element.shipToName,
        shipToAddress1: element.shipToAddress1,
        shipToAddress2: element.shipToAddress2,
        shipToPhone: element.shipToPhone,
        narration: element.narration,
        amount: element.amount,
        userId: element.userId,
        branchId: element.branchId,
        otherAmt: element.otherAmt,
        discountAmt: element.discountAmt,
        creditPeriod: element.creditPeriod,
        paymentCondition: element.paymentCondition,
        paymentType: element.paymentType,
        invoiceType: element.invoiceType,
        invoicePrefix: element.invoicePrefix,
        invoiceSuffix: element.invoiceSuffix,
        cancelFlg: element.cancelFlg,
        entryDate: element.entryDate,
        slesManId: element.slesManId,
        branchUpdated: element.branchUpdated,
        saleTypeInterState: element.saleTypeInterState,
        Machinecode:element.Machinecode,
        vansalepaymenttypes:element.vansalepaymenttypes,
        salesDetails:element.salesDetails,
        //salesDetails: List<SalesDetail>.from(element.salesDetails.map((x) => SalesDetail.fromJson(x))),
        // salesExpense: List<dynamic>.from(element.salesExpense.map((x) => x)),
      );
      Insert_Sales_data(TableName:"salesHeader",data:data);

    }

    );

  }



  PostToSales_vansalepayment(List<Vansale_PaymentTypes> data,var Shid) async {

    // Database db=await open_Db();
    // final List<Map<String, dynamic>> count =
    //     await db.rawQuery( "INSERT INTO vansalepaymenttypes(ledgerid, SHID , Amount) VALUES (${element.ledgerid}, $Shid, ${element.Amount})");

    data.forEach((element)  {
      var datas = Vansale_PaymentTypes(
        ledgerid: element.ledgerid,
        SHID: Shid,
        Amount: element.Amount,

      );
      InsertInto_vansalespaymenttypes(TableName: "vansalepaymenttypes", datas: datas,header_id:Shid);
    });

  }


  InsertInto_vansalespaymenttypes({TableName,datas,header_id})async {

    print("there is inside sirta" + TableName.toString() + " " + datas.toString() + header_id.toString());


    Database db = await open_Db();


    var  res_id= await db.insert(
      '$TableName',
      datas.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );



    return res_id;
  }




  Insert_Sales_data({required String TableName,required LD_Model_Sales data})async{

    print("the datas areeee" + data.vansalepaymenttypes.toString());
    print("cgcggcgcg" + data.salesDetails.toString());
    print("cgcggcgcg" + data.voucherDate.toString());

    var db=await open_Db();

    var Shid =  await db.insert(
      '$TableName',
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("the shipid iss" + Shid.toString());

    await PostToSales_SalesDetails(data.salesDetails,Shid);
    await PostToSales_vansalepayment(data.vansalepaymenttypes, Shid);

  }

  PostToSales_SalesDetails(List<SalesDetail> data,var Shid) {


    data.forEach((element)  {
      var data = SalesDetail(
        itmName: element.itmName,
        SHID: Shid,
        itemSlNo: element.itemSlNo,
        itemId: element.itemId,
        qty: element.qty,
        rate: element.rate,
        disPercentage: element.disPercentage,
        cgstPercentage: element.cgstPercentage,
        sgstPercentage: element.sgstPercentage,
        cessPercentage: element.cessPercentage,
        discountAmount: element.discountAmount,
        cgstAmount: element.cgstAmount,
        sgstAmount: element.sgstAmount,
        cessAmount: element.cessAmount,
        igstPercentage: element.igstPercentage,
        igstAmount: element.igstAmount,
        taxPercentage: element.taxPercentage,
        taxAmount: element.taxAmount,
        taxInclusive: element.taxInclusive,
        amountBeforeTax: element.amountBeforeTax,
        amountIncludingTax: element.amountIncludingTax,
        netTotal: element.netTotal,
        hsncode: element.hsncode,
        gdnId: element.gdnId,
        taxId: element.taxId,
        rackId: element.rackId,
        addTaxId: element.addTaxId,
        unitId: element.unitId,
        nosInUnit: element.nosInUnit,
        barcode: element.barcode,
        stockId: element.stockId,
        batchNo: element.batchNo,
        expiryDate: element.expiryDate,
        notes: element.notes,
      );
      InsertInto_SlsDetils(TableName: "salesDetails", data: data,header_id:Shid);
    });

  }



  InsertInto_SlsDetils({TableName,data,header_id})async {
    Database db = await open_Db();

    var  res_id= await db.insert(
      '$TableName',
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    if(res_id!=null){

      // var res= await Local_Db().Get_Data_ForPrint(header_id);


      try {
        var res= await Local_Db().Get_Data_ForPrint(header_id);
        print(" print in");
        _printerManager.selectPrinter('192.168.0.100');
        print("192.168.0.100");
        // _printerManager.selectPrinter(null);
        final resprinter =
        await _printerManager.printTicket(await Offline_Print().Printerticket(dataForTicket:res[0]));
        print(" print in");
      } catch (e) {
        print("error on print $e");
      }


    }else{
      print("Error while posting") ;
    }


    return res_id;
  }


  LocalView(Id) async {

    final db = await open_Db();

    print("Get_Data_ForPrint" + Id.toString());


    final List<Map<String, dynamic>> mapsHeader = await db.rawQuery("SELECT * FROM salesHeader where localSyncId= $Id");
    final List<Map<String, dynamic>> mapsDetails = await db.rawQuery(
        'SELECT qty, rate,itemId, disPercentage,itmName,cgstPercentage, sgstPercentage, cessPercentage, discountAmount,'
            'cgstAmount,  sgstAmount,cessAmount,igstPercentage, igstAmount, taxPercentage, taxAmount, taxInclusive, amountBeforeTax,'
            'amountIncludingTax, netTotal, hsncode, gdnId, taxId, rackId, addTaxId, unitId, stockId, batchNo, expiryDate, notes,  barcode,'
            'nosInUnit, adlDiscPercent, adlDiscAmount, itemSlNo, Mrp, Prate, salesManIdDet FROM salesDetails where SHID=$Id');
    print("mapsHeader");
    print(mapsHeader);
    print("mapsDetails");
    print(mapsDetails);
    print("the servseradsef " + mapsHeader[0]["syncServerId"].toString());
    return mapsHeader;
  }

  ///-----------------------------------------------------------------------------

  Test()async{

    //Database db=await open_Db();


    Database db=await open_Db();
//var res=await  db.rawQuery('PRAGMA table_info(salesDetails);');
//var res=await  db.rawQuery('DELETE FROM salesHeader');
    var res=await  db.rawQuery('select * from GTCompanyMaster  ');
// var res=await  db.rawQuery("DROP TABLE IF EXISTS GTCompanyMaster ");
    print("qizo_Gt_LocalDb.db");
    print("uiouiouioi");
    print("result is " + res.toString());
    return log(res.toString());

  }


  TestGetData()async{
    var db=await open_Db();

    final List<Map<String, dynamic>> mapsHeader = await db.rawQuery("SELECT * FROM salesHeader");
    final List<Map<String, dynamic>> mapsDetails = await db.rawQuery("SELECT * FROM salesDetails");


    if(mapsHeader.isNotEmpty) {
      var _tagsJson = mapsHeader;
      List<LD_Model_Sales> data = _tagsJson.map((tagsJson) =>
          LD_Model_Sales.fromJson(tagsJson)).toList();

      var _tagsJsonDtls = mapsDetails;

      List<SalesDetail> dataDtls = _tagsJsonDtls.map((tagsJson) =>
          SalesDetail.fromJson(tagsJson)).toList();

      return [{"salesHeader": mapsHeader,"salesDetails":mapsDetails}];
    }

  }

}