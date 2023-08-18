import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../GT_Masters/AppTheam.dart';
import '../GT_Masters/Masters_UI/cuWidgets.dart';
import '../GT_Masters/Models/Items.dart';
import '../appbarWidget.dart';
import '../models/customersearch.dart';
import '../models/userdata.dart';
import '../urlEnvironment/urlEnvironment.dart';
import 'GenSett_TabPages/GenSett_Model/GenSettApi_Model.dart';
import 'GenSett_TabPages/GenSett_Model/GenSett_Model_StockTypeStatics.dart';
import 'GenSett_TabPages/GenSett_Model/GennSett_InputBoxController.dart';


class GeneralSettings extends StatefulWidget {
  @override
  _GeneralSettingsState createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {

  late SharedPreferences pref;
  dynamic data;
  dynamic branch;
  var res;
  dynamic user;
  late int branchId;
  late int userId;
  late UserData userData;
  String branchName = "";
  dynamic userName;
  late String token;
  late String DeviceId;
var Gen_Id=null;
  Cnt d=Cnt();

  void initState() {
    setState(() {
      SharedPreferences.getInstance().then((value) {
        pref = value;
        read();
        GetStockTypeStatics();
        GetProductTypeStatics();
        GetSettings();
        getCustomer();
        GetFooterData();
      });
    });
  }
  read() async {
    var v = pref.getString("userData");
    var c = json.decode(v!);
    user = UserData.fromJson(c); // token gets this code user.user["token"]
    setState(() {
      branchId = int.parse(c["BranchId"]);
      token = user.user["token"]; //  passes this user.user["token"]
      pref.setString("customerToken", user.user["token"]);
      branchName = user.branchName;
      userName = user.user["userName"];
      userId = user.user["userId"];
      DeviceId = user.deviceId;
    });
  }
  var CurrentIndex=0;

  AppTheam theam =AppTheam();
  CUWidgets cw=CUWidgets();
  static List<GenSett_Api_Model> _GenSett = [];
var Edit_Id=null;



GetSettings()async{
var res =await  cw.CUget_With_Parm(api:"generalSettings" ,Token: token);
if(res!=false){


  List<dynamic> Json=jsonDecode(res);
  List<GenSett_Api_Model>jsondata =Json.map((Json) => GenSett_Api_Model.fromJson(Json)).toList();

  _GenSett=jsondata;

setState(() {

 _GenSett.forEach((e) {
   print("e.id.toString()");
   print(e.id.toString());
   Gen_Id=e.id;
   Enable_godown=e.enableGdn;
   Payment_Ledger_Posting_while_Content=e.paymentLedgerPost;
   Receipt_Ledger_Posting_while_Content=e.receiptLedgerPost;
   Journal_Ledger_Posting_while_Content=e.journalLedgerPost;
   Negative_sales_allow=e.negativeSalesAllow;
   Batch_Expiry_applicable=e.batchAndExpApplicable;
   Show_stock_in_sales=e.showStockInSales;
   Default_Invoice_Type_BtB_Or_BtC.text=e.defaInvTypeBtBorBtC;
   Sales_Default_Pay_Type_Content=e.defaPayType;
   Enable_master_index_page=e.enableMasterIndexPage;
   Enable_transaction_index_page=e.enableTranIndexPage;
   Id_Item_Default_Stock_Type=e.itemDefaultStockTypeId;
   Id_Item_Default_Product_Type=e.itemDefaultProductTypeId;
   Enable_gross_sales_discount=e.enableSalesDiscount;
   Disable_item_wise_sales_discount=e.enableSalesItemWiseDiscount;
   Sales_thermal_print=e.salesThermalPrint;
   Sales_Direct_Print=e.directPrintFromSales;
   Purchase_Tax_Inclusive=e.purchaseTaxInclusive;
   Sales_TaxInclusive=e.salesTaxInclusive;
   Show_Notes_Purchase_Or_Sales=e.showNotesPurchaseSales;
   Fixed_Discount_In_Sales=e.fixedDiscountInSales;
   Stock_Batch_Base_Sales_Rate=e.stockBatchBaseSalesRateAlso;
   Print_Sales_Man_In_Invoice=e.salesManPrintInInvoice;
   Print_Login_User_In_Invoice=e.loginUserPrintInInvoice;
   Purchase_Edit_After_Stock_Update=e.purchaseEditAfterStockUpdate;
   Item_From_Stock_Table=e.salesItemListFromStockTable;
   Sales_Invoice_Date_Editable=e.salesInvoiceDateEditable;
   Mrp_On_Thermal_Print=e.mrpPrintOnThermal;
   Main_Navbar_Logo_Name.text=e.mainNavbarLogoName;
   Dash_Board_Header_Name.text=e.dashBoardHeaderName;
   Rms_Kot_Printer.text=e.rmsKotPrinter;
   Rms_Counter_Printer.text=e.rmsCounterPrinter;
   Auto_Generate_Batch_In_Purchase=e.autoGenerateBatchInPurchase;
   Bypass_Delivery_Process_In_Rms=e.bypassDeliveryProcessRms;
   Enable_Makeorder_In_Rms=e.enableMakeorderRms;
   Enable_Packing_Slip_In_Sales=e.enablePackingSlipInSales;
   Generate_Barcode_In_Purchase=e.generateBarcodeInPurchase;
   Enable_Barcode_In_Sales=e.enableBarcodeInSales;
   Sales_Printer_Type.text=e.salesPrinterType;
   Update_ItemRate_BasedOn_Purchase=e.updateItemRateBasedOnPurchase;
   Country_Code.text=e.countryCode;
   Country_Name.text=e.countryName;
   Time_Zone_Code.text=e.timeZoneCode;
   Currency_Name.text=e.currencyName;
   Currency_Decimals.text=e.currencyDecimals.toString();
   Currency_Coin_Name.text=e.currencyCoinName;
   Application_TypeController.text=e.applicationType;
   printLedgerBalanceInInvoice=e.printLedgerBalanceInInvoice;





   // =e.journalLedgerPost;


   if(e.paymentLedgerPost=="PaymentOnly"){

   Payment_Ledger_Posting_while.text="Payment Creation";

   }else if(e.paymentLedgerPost=="PaymentAndApprove"){

   Payment_Ledger_Posting_while.text="Payment Approve";

   }else{
   Payment_Ledger_Posting_while.text="Payment Ledger Posting Done";

   }


   if(e.receiptLedgerPost=="ReceiptOnly"){

     Receipt_Ledger_Posting_while.text="Receipt Creation";

   }else{
     Receipt_Ledger_Posting_while.text="Receipt Approve";

   }


   if(e.journalLedgerPost=="JournalOnly"){

     Journal_Ledger_Posting_while.text="Journal Creation";

   }else if(e.journalLedgerPost=="JournalAndApprove"){
     Journal_Ledger_Posting_while.text="Journal Ledger Posting Done";

   }else{

   Journal_Ledger_Posting_while.text="Journal Ledger Posting Done";

   }




   e.defaPayType==0?Sales_Default_Pay_Type.text="Cash":Sales_Default_Pay_Type.text="Credit";

   Item_Default_Stock_Type.text=GetItemStktypName(e.itemDefaultStockTypeId);


   Item_Default_Product_Type.text=GetItemProdTypName(e.itemDefaultStockTypeId);


 });


});


}

}


  GetFooterData()async{
    FooterDataTable.clear();
    var res =await  cw.CUget_With_Parm(api:"SalesInvoiceFooters" ,Token: token);
    if(res!=false){
      setState(() {
        FooterDataTable=json.decode(res);
        print("FooterDataTable");
        print(FooterDataTable);
      });

    }

  }



  GetItemStktypName(id){
    var s;
    final _results = _StkTyp
        .where((product) => product.id.toString() == id.toString());

    print(_results.toString());
    for (StockTypeStatics p in _results) {

      s=p.stockType;
      print(p.stockType);
    }
    return s;
  }




  GetItemProdTypName(id){
    var s;
    final _results = _prodTyp
        .where((product) => product.id.toString() == id.toString());

    print(_results.toString());
    for (ProductType p in _results) {

      s=p.productType;
      print(p.productType);
    }
    return s;
  }








  ///---------------------------General--------------------------------------

  static List<StockTypeStatics> _StkTyp = [];
  static List<Customer> users = [];


  GetStockTypeStatics()async{
// print("in GetArea");
    final _json= await http.get("${Env.baseUrl}MStockTypeStatics" as Uri,
        headers: {
          "Authorization": user.user["token"],
        }
    ) ;

    if(_json.statusCode==200||_json.statusCode==201){


      List<dynamic> Json=jsonDecode(_json.body);
      List<StockTypeStatics>jsondata =Json.map((Json) => StockTypeStatics.fromJson(Json)).toList();

      _StkTyp=jsondata;

    }


  }


  GetProductTypeStatics()async{

    final _json= await http.get("${Env.baseUrl}MProductTypeStatics" as Uri,
        headers: {
          "Authorization": user.user["token"],
        }
    ) ;

    if(_json.statusCode==200||_json.statusCode==201){


      List<dynamic> Json=jsonDecode(_json.body);
      List<ProductType>jsondata =Json.map((Json) => ProductType.fromJson(Json)).toList();

      _prodTyp=jsondata;

    }


  }


  getCustomer() async {
    try {
      final response =
      await http.get("${Env.baseUrl}${Env.CustomerURL}" as Uri, headers: {
        "Authorization": user.user["token"],
      });
      print(response.statusCode);

      if (response.statusCode == 200) {
        print('...................');
        Map<String, dynamic> data = json.decode(response.body);
        print("array is");
        print(data["lst"]); //used  this to autocomplete
        print("........");
        // print(response.statusCode);
        // print(data["lst"]);
         users = (data["lst"] as List)
            .map<Customer>((customer) =>
            Customer.fromJson(Map<String, dynamic>.from(customer)))
            .toList();
//        users=loadUsers(s.toString());
        return users;
      } else {
        print("Error getting users");
      }
    } catch (e) {
      print("Error getting users");
    }
  }


  static List<ProductType> _prodTyp = [];
  TextEditingController Item_Default_Stock_Type = new TextEditingController();
  TextEditingController Item_Default_Product_Type = new TextEditingController();
  TextEditingController customerController = new TextEditingController();

  bool Validation_Item_Default_Stock_Type=false;
  bool Validation_Item_Default_Product_Type=false;

  int? Id_Item_Default_Stock_Type=null;
  int? Id_Item_Default_Product_Type=null;
  int? LedgerId=null;

  bool Enable_master_index_page=false;
  bool Enable_transaction_index_page=false;
  bool Purchase_Tax_Inclusive=false;
  bool Sales_TaxInclusive=false;
  bool Batch_Expiry_applicable=false;
  bool Show_Notes_Purchase_Or_Sales=false;
  bool Enable_godown=false;


  TextEditingController Ledger_Posting_Controller = new TextEditingController();
  var Ledger_Posting_Content=null;
  bool Validation_Ledger_Posting=false;
  var _Ledger_Posting_Daata=[
    {"id":"purchaseDiscountLedgerId","name":"Purchase Discount Ledger"},
    {"id":"purchaseAdjustLedgerId","name":"Purchase Adjust Ledger"},
    {"id":"salesDiscountLedgerId","name":"Sales Discount Ledger"},
    {"id":"salesAdjustLedgerId","name":"Sales Adjust Ledger"},
  ];






  ///-------------------------Purchase-----------------------------------
  bool Purchase_Edit_After_Stock_Update=false;
  bool Generate_Barcode_In_Purchase=false;
  bool Auto_Generate_Batch_In_Purchase=false;
  bool Update_ItemRate_BasedOn_Purchase=false;



  ///-------------------------Sales-----------------------------


  TextEditingController Default_Invoice_Type_BtB_Or_BtC = new TextEditingController();
  var Default_Invoice_Type_BtB_Or_BtC_Content=null;
  bool Validation_Default_Invoice_Type_BtB_Or_BtC=false;
  var _Defult_invo_Btc_Btb=[
    {"id":"BtoB","name":"BtoB"},
    {"id":"BtoC","name":"BtoC"},
  ];


  TextEditingController Sales_Default_Pay_Type = new TextEditingController();
  var Sales_Default_Pay_Type_Content=null;
  bool Validation_Sales_Default_Pay_Type=false;
  var _Sls_Defult_pytyp=[
    {"id":"0","name":"Cash"},
    {"id":"1","name":"Credit"},

  ];




  TextEditingController Sales_Printer_Type = new TextEditingController();
  var Sales_Printer_Type_Content=null;
  bool Validation_Sales_Printer_Type=false;
  var _sls_prnt_typ=[
    {"id":"Vat Tax Invoice","name":"Vat Tax Invoice"},
    {"id":"Vat Simplified","name":"Vat Simplified"},
    {"id":"Vat A4","name":"Vat A4"},
    {"id":"Vat 3 Inch","name":"Vat 3 Inch"},
    {"id":"Vat 2 Inch","name":"Vat 2 Inch"},

  ];



  TextEditingController FooterCaption_Controller = new TextEditingController();
  TextEditingController FooterText_Controller = new TextEditingController();

  TextEditingController FooterAlign_Controller = new TextEditingController();
  var FooterAlign_Controller_Id=null;
  var  _FooterAlign_Data=[
    {"id":"1","name":"Left"},
    {"id":"2","name":"Right"},
    {"id":"3","name":"Center"}, ];
  var FtrdataSlNum=0;

  var FooterDataTable=[];
 var  FooterEditId=null;
  bool FooterCaption_Bold=false;
    bool FooterText_Bold=false;


    AddFooterData()async{


        var Ftrdata = {
          //  "id":FooterEditId,
          "footerCaption": FooterCaption_Controller.text,
          "footerCaptionBold": FooterCaption_Bold,
          "footerText": FooterText_Controller.text,
          "footerTextBold": FooterText_Bold,
          "textAlign": FooterAlign_Controller.text,
        };

       var FtrJson=json.encode(Ftrdata) ;
res=await cw.post(api: "SalesInvoiceFooters",body:FtrJson,deviceId: DeviceId,Token: token );
if(res!=false){
  FooterDataTable.clear();
  print("res");
  print(res);
  setState(() {
    FooterCaption_Controller.text = "";
    FooterCaption_Bold = false;
    FooterText_Controller.text = "";
    FooterText_Bold = false;
    FooterAlign_Controller.text = "";
    FooterAlign_Controller_Id = null;
  });
 GetFooterData();
}

    }

DeleteFooterData(id)async{
  var res=await  cw.delete(api:"SalesInvoiceFooters/$id",deviceId: DeviceId,Token: token );
  if(res!=false){

    GetFooterData();

  }

}


  bool Negative_sales_allow=false;
  bool Show_stock_in_sales=false;
  bool Stock_Batch_Base_Sales_Rate=false;
  bool Item_From_Stock_Table=false;
  bool Enable_gross_sales_discount=false;
  bool Disable_item_wise_sales_discount=false;
  bool Fixed_Discount_In_Sales=false;
  bool Sales_Invoice_Date_Editable=false;
  bool Print_Sales_Man_In_Invoice=false;
  bool Print_Login_User_In_Invoice=false;
  bool Sales_thermal_print=false;
  bool Sales_Direct_Print=false;
  bool Mrp_On_Thermal_Print=false;
  bool Enable_Barcode_In_Sales=false;
  bool Enable_Packing_Slip_In_Sales=false;
  bool printLedgerBalanceInInvoice=false;








  ///-------------------------Account-----------------------------
  TextEditingController Payment_Ledger_Posting_while = new TextEditingController();
  var Payment_Ledger_Posting_while_Content=null;
  bool Validation_Payment_Ledger_Posting_while=false;
 var _PayLgr_pstWhile=[
   {"id":"PaymentOnly","name":"Payment Creation"},
   {"id":"PaymentAndApprove","name":"Payment Approve"},
   {"id":"PaymentApproveAndLP","name":"Payment Ledger Posting Done"},
 ];


 TextEditingController Receipt_Ledger_Posting_while = new TextEditingController();
  var Receipt_Ledger_Posting_while_Content=null;
  bool Validation_Receipt_Ledger_Posting_while=false;
 var _RcptLgr_pstWhile=[
   {"id":"ReceiptOnly","name":"Receipt Creation"},
   {"id":"ReceiptAndApprove","name":"Receipt Approve"},

 ];




 TextEditingController Journal_Ledger_Posting_while = new TextEditingController();
  var Journal_Ledger_Posting_while_Content=null;
  bool Validation_Journal_Ledger_Posting_while=false;
 var _Jrnl_Ldgr_pstWhile=[
   {"id":"JournalOnly","name":"Journal Creation"},
   {"id":"JournalAndApprove","name":"Journal Approve"},
   {"id":"JournalApproveAndLP","name":"Journal Ledger Posting Done"},

 ];


 ///---------------------------------RMS---------------------------------

  TextEditingController Rms_Counter_Printer = new TextEditingController();
  TextEditingController Rms_Kot_Printer = new TextEditingController();

  bool Enable_Makeorder_In_Rms=false;
  bool Bypass_Delivery_Process_In_Rms=false;



///----------------------------------Dash Board--------------------------
  TextEditingController Main_Navbar_Logo_Name = new TextEditingController();
  TextEditingController Dash_Board_Header_Name = new TextEditingController();


  ///----------------------------------Country----------------------------
  var TimeZone=[

    { "name":"Abu Dhabi,Arabian Standard Time"},
    { "name":"Adelaide,Cen. Australia Standard Time"},
    { "name":"Alaska,Alaskan Standard Time"},
    { "name":"Almaty,Central Asia Standard Time"},
    { "name":"American Samoa,UTC-11"},
    { "name":"Amsterdam,W. Europe Standard Time"},
    { "name":"Arizona,US Mountain Standard Time"},
    { "name":"Astana,Bangladesh Standard Time"},
    { "name":"Athens,GTB Standard Time"},
    { "name":"Atlantic Time (Canada),Atlantic Standard Time"},
    { "name":"Auckland,New Zealand Standard Time"},
    { "name":"Azores,Azores Standard Time"},
    { "name":"Baghdad,Arabic Standard Time"},
    { "name":"Baku,Azerbaijan Standard Time"},
    { "name":"Bangkok,SE Asia Standard Time"},
    { "name":"Beijing,China Standard Time"},
    { "name":"Belgrade,Central Europe Standard Time"},
    { "name":"Berlin,W. Europe Standard Time"},
    { "name":"Bern,W. Europe Standard Time"},
    { "name":"Bogota,SA Pacific Standard Time"},
    { "name":"Brasilia,E. South America Standard Time"},
    { "name":"Bratislava,Central Europe Standard Time"},
    { "name":"Brisbane,E. Australia Standard Time"},
    { "name":"Brussels,Romance Standard Time"},
    { "name":"Bucharest,GTB Standard Time"},
    { "name":"Budapest,Central Europe Standard Time"},
    { "name":"Buenos Aires,Argentina Standard Time"},
    { "name":"Cairo,Egypt Standard Time"},
    { "name":"Canberra,AUS Eastern Standard Time"},
    { "name":"Cape Verde Is.,Cape Verde Standard Time"},
    { "name":"Caracas,Venezuela Standard Time"},
    { "name":"Casablanca,Morocco Standard Time"},
    { "name":"Central America,Central America Standard Time"},
    { "name":"Central Time (US & Canada),Central Standard Time"},
    { "name":"Chennai,India Standard Time"},
    { "name":"Chihuahua,Mountain Standard Time (Mexico)"},
    { "name":"Chongqing,China Standard Time"},
    { "name":"Copenhagen,Romance Standard Time"},
    { "name":"Darwin,AUS Central Standard Time"},
    { "name":"Dhaka,Bangladesh Standard Time"},
    { "name":"Dublin,GMT Standard Time"},
    { "name":"Eastern Time (US & Canada),Eastern Standard Time"},
    { "name":"Edinburgh,GMT Standard Time"},
    { "name":"Ekaterinburg,Ekaterinburg Standard Time"},
    { "name":"Fiji,Fiji Standard Time"},
    { "name":"Georgetown,SA Western Standard Time"},
    { "name":"Greenland,Greenland Standard Time"},
    { "name":"Guadalajara,Central Standard Time (Mexico)"},
    { "name":"Guam,West Pacific Standard Time"},
    { "name":"Hanoi,SE Asia Standard Time"},
    { "name":"Harare,South Africa Standard Time"},
    { "name":"Hawaii,Hawaiian Standard Time"},
    { "name":"Helsinki,FLE Standard Time"},
    { "name":"Hobart,Tasmania Standard Time"},
    { "name":"Hong Kong,China Standard Time"},
    { "name":"Indiana (East),US Eastern Standard Time"},
    { "name":"International Date Line West,UTC-11"},
    { "name":"Irkutsk,North Asia East Standard Time"},
    { "name":"Islamabad,Pakistan Standard Time"},
    { "name":"Istanbul,Turkey Standard Time"},
    { "name":"Jakarta,SE Asia Standard Time"},
    { "name":"Jerusalem,Israel Standard Time"},
    { "name":"Kabul,Afghanistan Standard Time"},
    { "name":"Kaliningrad,Kaliningrad Standard Time"},
    { "name":"Kamchatka,Russia Time Zone 11"},
    { "name":"Karachi,Pakistan Standard Time"},
    { "name":"Kathmandu,Nepal Standard Time"},
    { "name":"Kolkata,India Standard Time"},
    { "name":"Krasnoyarsk,North Asia Standard Time"},
    { "name":"Kuala Lumpur,Singapore Standard Time"},
    { "name":"Kuwait,Arab Standard Time"},
    { "name":"Kyiv,FLE Standard Time"},
    { "name":"La Paz,SA Western Standard Time"},
    { "name":"Lima,SA Pacific Standard Time"},
    { "name":"Lisbon,GMT Standard Time"},
    { "name":"Ljubljana,Central Europe Standard Time"},
    { "name":"London,GMT Standard Time"},
    { "name":"Madrid,Romance Standard Time"},
    { "name":"Magadan,Magadan Standard Time"},
    { "name":"Marshall Is.,UTC+12"},
    { "name":"Mazatlan,Mountain Standard Time (Mexico)"},
    { "name":"Melbourne,AUS Eastern Standard Time"},
    { "name":"Mexico City,Central Standard Time (Mexico)"},
    { "name":"Mid-Atlantic,UTC-02"},
    { "name":"Midway Island,UTC-11"},
    { "name":"Minsk,Belarus Standard Time"},
    { "name":"Monrovia,Greenwich Standard Time"},
    { "name":"Monterrey,Central Standard Time (Mexico)"},
    { "name":"Montevideo,Montevideo Standard Time"},
    { "name":"Moscow,Russian Standard Time"},
    { "name":"Mountain Time (US & Canada),Mountain Standard Time"},
    { "name":"Mumbai,India Standard Time"},
    { "name":"Muscat,Arabian Standard Time"},
    { "name":"Nairobi,E. Africa Standard Time"},
    { "name":"New Caledonia,Central Pacific Standard Time"},
    { "name":"New Delhi,India Standard Time"},
    { "name":"Newfoundland,Newfoundland Standard Time"},
    { "name":"Novosibirsk,N. Central Asia Standard Time"},
    { "name":"Nuku'alofa,Tonga Standard Time"},
    { "name":"Osaka,Tokyo Standard Time"},
    { "name":"Pacific Time (US & Canada),Pacific Standard Time"},
    { "name":"Paris,Romance Standard Time"},
    { "name":"Perth,W. Australia Standard Time"},
    { "name":"Port Moresby,West Pacific Standard Time"},
    { "name":"Prague,Central Europe Standard Time"},
    { "name":"Pretoria,South Africa Standard Time"},
    { "name":"Quito,SA Pacific Standard Time"},
    { "name":"Rangoon,Myanmar Standard Time"},
    { "name":"Riga,FLE Standard Time"},
    { "name":"Riyadh,Arab Standard Time"},
    { "name":"Rome,W. Europe Standard Time"},
    { "name":"Samara,Russia Time Zone 3"},
    { "name":"Samoa,Samoa Standard Time"},
    { "name":"Santiago,Pacific SA Standard Time"},
    { "name":"Sapporo,Tokyo Standard Time"},
    { "name":"Sarajevo,Central European Standard Time"},
    { "name":"Saskatchewan,Canada Central Standard Time"},
    { "name":"Seoul,Korea Standard Time"},
    { "name":"Singapore,Singapore Standard Time"},
    { "name":"Skopje,Central European Standard Time"},
    { "name":"Sofia,FLE Standard Time"},
    { "name":"Solomon Is.,Central Pacific Standard Time"},
    { "name":"Srednekolymsk,Russia Time Zone 10"},
    { "name":"Sri Jayawardenepura,Sri Lanka Standard Time"},
    { "name":"St. Petersburg,Russian Standard Time"},
    { "name":"Stockholm,W. Europe Standard Time"},
    { "name":"Sydney,AUS Eastern Standard Time"},
    { "name":"Taipei,Taipei Standard Time"},
    { "name":"Tallinn,FLE Standard Time"},
    { "name":"Tashkent,West Asia Standard Time"},
    { "name":"Tbilisi,Georgian Standard Time"},
    { "name":"Tehran,Iran Standard Time"},
    { "name":"Tijuana,Pacific Standard Time"},
    { "name":"Tokelau Is.,Tonga Standard Time"},
    { "name":"Tokyo,Tokyo Standard Time"},
    { "name":"Ulaanbaatar,Ulaanbaatar Standard Time"},
    { "name":"Urumqi,Central Asia Standard Time"},
    { "name":"UTC,UTC"},
    { "name":"Vienna,W. Europe Standard Time"},
    { "name":"Vilnius,FLE Standard Time"},
    { "name":"Vladivostok,Vladivostok Standard Time"},
    { "name":"Volgograd,Russian Standard Time"},
    { "name":"Warsaw,Central European Standard Time"},
    { "name":"Wellington,New Zealand Standard Time"},
    { "name":"West Central Africa,W. Central Africa Standard Time"},
    { "name":"Yakutsk,Yakutsk Standard Time"},
    { "name":"Yerevan,Caucasus Standard Time"},
    { "name":"Zagreb,Central European Standard Time"}

  ];
  TextEditingController Country_Code = new TextEditingController();
  TextEditingController Country_Name = new TextEditingController();
  TextEditingController Time_Zone_Code = new TextEditingController();
  TextEditingController Currency_Name = new TextEditingController();
  TextEditingController Currency_Decimals = new TextEditingController();
  TextEditingController Currency_Coin_Name = new TextEditingController();



  ///---------------------------System-----------------------------------
  TextEditingController System_passwordController = new TextEditingController();
  bool Validate_System_passwordController=false;
  bool Show_DbUtility=false;

  TextEditingController Application_TypeController = new TextEditingController();
  var Application_Type_Content=null;
  bool Validation_Application_Type=false;
  var _Application_Typee_Data=[
    {"id":"GT","name":" General Trading"},
    {"id":"Event","name":"Event"},
    {"id":"RMS","name":"Restaurant Management System"},
    {"id":"Demo","name":"Demo"},
  ];
  bool Branch_wise_Master_Display=false;
  bool Branch_wise_Employee_Display=false;
  bool Branch_wise_Branch_Display=false;
  bool Branch_wise_Ledger_Display=false;
  bool Application_Tax_Type_GST=false;
  bool Concurrency_Test_Enable=false;
  ///----------------------------End-----------------------------

  Getpage() {

    var Pages = [
      GenSett_Generals(),
      GenSett_Purchase(),
      GenSett_Sales(),
      GenSett_Account(),
      GenSett_RMS(),
      GenSett_Dash_Board(),
      GenSett_Country(),
      GenSett_System(),

    ];
    return Pages;
  }
  var PageLabel=[
       "General",
        "Purchase",
        "Sales",
        "Account",
        "RMS",
        "Dash Board",
        "Country",
        "System"
  ];




  GenSett_Update()async{

    var s={

      "id": Gen_Id,
      "enableGdn": Enable_godown,
      "defaultSearchInSales": "ItemName",
      "paymentLedgerPost": Payment_Ledger_Posting_while_Content,
      "receiptLedgerPost": Receipt_Ledger_Posting_while_Content,
      "journalLedgerPost": Journal_Ledger_Posting_while_Content,
      "negativeSalesAllow": Negative_sales_allow,
      "batchAndExpApplicable": Batch_Expiry_applicable,
      "showStockInSales": Show_stock_in_sales,
      "defaInvTypeBtBorBtC": Default_Invoice_Type_BtB_Or_BtC.text,
      "defaPayType": Sales_Default_Pay_Type.text=="Cash"?0:1,
      "enableMasterIndexPage": Enable_master_index_page,
      "enableTranIndexPage": Enable_transaction_index_page,
      "itemDefaultStockTypeId": Id_Item_Default_Stock_Type,
      "itemDefaultProductTypeId": Id_Item_Default_Product_Type,
      "enableSalesDiscount": Enable_gross_sales_discount,
      "enableSalesItemWiseDiscount": Disable_item_wise_sales_discount,
      "salesThermalPrint": Sales_thermal_print,
      "directPrintFromSales": Sales_Direct_Print,
      "purchaseTaxInclusive": Purchase_Tax_Inclusive,
      "salesTaxInclusive": Sales_TaxInclusive,
      "showNotesPurchaseSales": Show_Notes_Purchase_Or_Sales,
      "thermalPrintLogoHeight": null,
      "thermalPrintLogoWidth": null,
      "fixedDiscountInSales": Fixed_Discount_In_Sales,
      "stockBatchBaseSalesRateAlso": Stock_Batch_Base_Sales_Rate,
      "masterListBranchWise": false,
      "applicationType": "GT",
      "salesManPrintInInvoice": Print_Sales_Man_In_Invoice,
      "loginUserPrintInInvoice": Print_Login_User_In_Invoice,
      "branchWiseEmployList": Branch_wise_Employee_Display,
      "branchWiseCompanyProfileList": Branch_wise_Ledger_Display,
      "branchId": 1,
      "branchWiseLedgerList": false,
      "defaultImagePath": null,
      "purchaseEditAfterStockUpdate": Purchase_Edit_After_Stock_Update,
      "onlineUrlsqrcode": null,
      "rmsBillDispImg": null,
      "salesItemListFromStockTable": Item_From_Stock_Table,
      "salesInvoiceDateEditable": Sales_Invoice_Date_Editable,
      "purchaseDiscountLedgerId": null,
      "purchaseAdjustLedgerId": null,
      "salesDiscountLedgerId": null,
      "salesAdjustLedgerId": null,
      "mrpPrintOnThermal": Mrp_On_Thermal_Print,
      "mainNavbarLogoName": Main_Navbar_Logo_Name.text,
      "dashBoardHeaderName": Dash_Board_Header_Name.text,
      "rmsKotPrinter": Rms_Kot_Printer.text,
      "rmsCounterPrinter": Rms_Counter_Printer.text,
      "autoGenerateBatchInPurchase": Auto_Generate_Batch_In_Purchase,
      "bypassDeliveryProcessRms": Bypass_Delivery_Process_In_Rms,
      "enableMakeorderRms": Enable_Makeorder_In_Rms,
      "enablePackingSlipInSales": Enable_Packing_Slip_In_Sales,
      "generateBarcodeInPurchase": Generate_Barcode_In_Purchase,
      "enableBarcodeInSales": Enable_Barcode_In_Sales,
      "applicationTaxTypeGst": Application_Tax_Type_GST,
      "concurrencyTestEnable": Concurrency_Test_Enable,
      "salesPrinterType": Sales_Printer_Type.text,
      "updateItemRateBasedOnPurchase": Update_ItemRate_BasedOn_Purchase,
      "printQrinSales": null,
      "countryCode":Country_Code.text,
      "countryName":Country_Name.text,
      "timeZoneCode": Time_Zone_Code.text,
      "currencyName": Currency_Name.text,
      "currencyDecimals": Currency_Decimals.text,
      "currencyCoinName": Currency_Coin_Name.text,
      "printLedgerBalanceInInvoice": printLedgerBalanceInInvoice

    };



var finalData=json.encode(s);
    log(finalData.toString());
    // cw.UpdatePopup(context);
    setState(() {
     // CurrentIndex=0;
    });
   var res=await cw.put(api:"generalSettings/$Gen_Id",body: finalData,Token: token,deviceId: DeviceId,);

 if(res!=false){

 cw.UpdatePopup(context);

  // Clear();
 }


  }


///-----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(child:Appbarcustomwidget(uname: userName, branch: branchName, pref: pref, title:PageLabel[CurrentIndex]), preferredSize:Size.fromHeight(80)),
        body:Getpage()[CurrentIndex],
        floatingActionButton:
            ElevatedButton(onPressed:(){
              GenSett_Update();
            } , child: Text("Update")),

        // InkWell(onTap: () async {
        //   GenSett_Update();
        // }, child: Text("Save")
        //
        // ),



        bottomNavigationBar:  GenSett_Bottom_NavBar(),

          ),
    );
  }








  GenSett_Bottom_NavBar() {
    return
      BottomNavigationBar(
          unselectedItemColor: Colors.black,
          selectedItemColor: Colors.teal,
        selectedIconTheme: IconThemeData(size: 30),
          currentIndex: CurrentIndex,
          onTap: (index) {
            setState(() {
              CurrentIndex = index;
            });
          },
          unselectedLabelStyle: TextStyle(color: Colors.black),
          items: [
            BottomNavigationBarItem(label: "General", icon: Icon(Icons.settings,),),
            BottomNavigationBarItem(label: "Purchase", icon: Icon(Icons.add_shopping_cart,),),
            BottomNavigationBarItem(
              label: "Sales", icon: Icon(Icons.shopping_cart_rounded,),),
            BottomNavigationBarItem(
              label: "Accounts", icon: Icon(Icons.account_balance_wallet_sharp,),),
            BottomNavigationBarItem(label: "RMS", icon: Icon(Icons.restaurant_menu,),),
            BottomNavigationBarItem(label: "Dash Board", icon: Icon(Icons.dashboard,),),
            BottomNavigationBarItem(
              label: "Country", icon: Icon(Icons.edit_location),),
            BottomNavigationBarItem(label: "System", icon: Icon(Icons.mobile_friendly,),),


          ]);
  }


















  ///--------------------GenSett_Generals------------------------
  GenSett_Generals(){

   return ListView(
      shrinkWrap: true,
      children: [


        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                        style: TextStyle(),
                        controller: Item_Default_Stock_Type,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(color: Colors.red),
                          errorText: Validation_Item_Default_Stock_Type
                              ? "Please Select Stock Type ?"
                              : null,
//                            errorText: _validateName ? "please enter name" : null,
//                            errorBorder:InputBorder.none ,
                          suffixIcon: IconButton(
                            icon: Icon(Icons.remove_circle),
                            color: Colors.blue,
                            onPressed: () {
                              setState(() {
                                print("cleared");
                                Item_Default_Stock_Type.text = "";
                                Id_Item_Default_Stock_Type = null;

                              });
                            },
                          ),

                          isDense: true,
                          contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          // i need very low size height
                          labelText:
                          'Item Default Stock Type', 
                        )),
                    suggestionsBoxDecoration:
                    SuggestionsBoxDecoration(elevation: 90.0),
                    suggestionsCallback: (pattern) {
                      return _StkTyp.where((user) =>
                          user.stockType.toUpperCase().contains(pattern.toUpperCase()));
                    },
                    itemBuilder: (context, suggestion) {
                      return Card(
                        color:theam.DropDownClr,
                        child: ListTile(
                          // focusColor: Colors.blue,
                          // hoverColor: Colors.red,
                          title: Text(
                            suggestion.stockType,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      print(suggestion.stockType);
                      print("selected");

                      Item_Default_Stock_Type.text = suggestion.stockType;
                      print("close.... ${Id_Item_Default_Stock_Type}");
                      Id_Item_Default_Stock_Type = null;

                      print(suggestion.id);
                      print("....... Id__Item_Default_Stock_Type");
                      Id_Item_Default_Stock_Type = suggestion.id;

                      print(Id_Item_Default_Stock_Type);
                      print("...........");
                    },
                    errorBuilder: (BuildContext context, Object? error) =>
                        Text('$error',
                            style: TextStyle(
                                color: Theme.of(context).errorColor)),
                    transitionBuilder:
                        (context, suggestionsBox, animationController) =>
                        FadeTransition(
                          child: suggestionsBox,
                          opacity: CurvedAnimation(
                              parent: animationController!,
                              curve: Curves.elasticIn),
                        )),
              ),
            ],
          ),
        ),




        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                        style: TextStyle(),
                        controller: Item_Default_Product_Type,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(color: Colors.red),
                          errorText: Validation_Item_Default_Product_Type
                              ? "Please Select Product Type ?"
                              : null,
//                            errorText: _validateName ? "please enter name" : null,
//                            errorBorder:InputBorder.none ,
                          suffixIcon: IconButton(
                            icon: Icon(Icons.remove_circle),
                            color: Colors.blue,
                            onPressed: () {
                              setState(() {
                                print("cleared");
                                Item_Default_Product_Type.text = "";
                                Id_Item_Default_Product_Type = null;

                              });
                            },
                          ),

                          isDense: true,
                          contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          // i need very low size height
                          labelText:
                          'Item Default Product Type', 
                        )),
                    suggestionsBoxDecoration:
                    SuggestionsBoxDecoration(elevation: 90.0),
                    suggestionsCallback: (pattern) {
                      return _prodTyp.where((user) =>
                          user.productType.toUpperCase().contains(pattern.toUpperCase()));
                    },
                    itemBuilder: (context, suggestion) {
                      return Card(
                        color:theam.DropDownClr,
                        child: ListTile(
                          // focusColor: Colors.blue,
                          // hoverColor: Colors.red,
                          title: Text(
                            suggestion.productType,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      print(suggestion.productType);
                      print("selected");

                      Item_Default_Product_Type.text = suggestion.productType;

                      Id_Item_Default_Product_Type = null;

                      print(suggestion.id);
                      print("....... Id__Item_Default_Product_Type");
                      Id_Item_Default_Product_Type = suggestion.id;

                      print(Id_Item_Default_Product_Type);
                      print("...........");
                    },
                    errorBuilder: (BuildContext context, Object? error) =>
                        Text('$error',
                            style: TextStyle(
                                color: Theme.of(context).errorColor)),
                    transitionBuilder:
                        (context, suggestionsBox, animationController) =>
                        FadeTransition(
                          child: suggestionsBox,
                          opacity: CurvedAnimation(
                              parent: animationController!,
                              curve: Curves.elasticIn),
                        )),
              ),
            ],
          ),
        ),



        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                              style: TextStyle(),
                              controller: Ledger_Posting_Controller,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                errorStyle: TextStyle(color: Colors.red),
                                errorText: Validation_Ledger_Posting
                                    ? "Please Select ?"
                                    : null,
//                            errorText: _validateName ? "please enter name" : null,
//                            errorBorder:InputBorder.none ,
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.remove_circle),
                                  color: Colors.blue,
                                  onPressed: () {
                                    setState(() {
                                      print("cleared");
                                      Ledger_Posting_Controller.text = "";
                                      Ledger_Posting_Content = null;

                                    });
                                  },
                                ),

                                isDense: true,
                                contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                // i need very low size height
                                labelText:
                                'Ledger Posting',
                              )),
                          suggestionsBoxDecoration:
                          SuggestionsBoxDecoration(elevation: 90.0),
                          suggestionsCallback: (pattern) {
                            return _Ledger_Posting_Daata.where((user) =>
                                user["name"]!.toUpperCase().contains(pattern.toUpperCase()));
                          },
                          itemBuilder: (context, suggestion) {
                            return Card(
                              color:theam.DropDownClr,
                              child: ListTile(
                                // focusColor: Colors.blue,
                                // hoverColor: Colors.red,
                                title: Text(
                                  suggestion["name"]!,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            print(suggestion["name"]);
                            print("selected");

                            Ledger_Posting_Controller.text = suggestion["name"]!;
                            print("close.... ${Ledger_Posting_Content}");
                            Ledger_Posting_Content = null;

                            print(suggestion["id"]);
                            print("....... Ledger_Posting_Content");
                            Ledger_Posting_Content = suggestion["id"];

                            print(Ledger_Posting_Content);
                            print("...........");
                          },
                          errorBuilder: (BuildContext context, Object? error) =>
                              Text('$error',
                                  style: TextStyle(
                                      color: Theme.of(context).errorColor)),
                          transitionBuilder:
                              (context, suggestionsBox, animationController) =>
                              FadeTransition(
                                child: suggestionsBox,
                                opacity: CurvedAnimation(
                                    parent: animationController!,
                                    curve: Curves.elasticIn),
                              )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),


        Row(
          children: [
            SizedBox(width: 10),
            Expanded(
              child:  TypeAheadField(
                  hideOnEmpty: true,
                  textFieldConfiguration: TextFieldConfiguration(
                      style: TextStyle(),
                      controller: customerController,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.red),
                        // errorText: customerSelect
                        //     ? "Please Select Customer ?"
                        //     : null,
//                            errorText: _validateName ? "please enter name" : null,
//                            errorBorder:InputBorder.none ,
                        suffixIcon: IconButton(
                          icon: Icon(Icons.remove_circle),
                          color: Colors.blue,
                          onPressed: () {
                            setState(() {
                              print("cleared");
                              customerController.text = "";

                            });
                          },
                        ),

                        isDense: true,
                        contentPadding:
                        EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        // i need very low size height
                        labelText:
                        'supplier search', // i need to decrease height
                      )),
                  suggestionsBoxDecoration:
                  SuggestionsBoxDecoration(elevation: 90.0),
                  suggestionsCallback: (pattern) {
                    return users.where((user) =>
                        user.lhName.toUpperCase().contains(pattern.toUpperCase()));
                  },
                  itemBuilder: (context, suggestion) {
                    return Card(
                      color: Colors.blue,
                      child: ListTile(
                        tileColor: theam.DropDownClr,
                        title: Text(
                          suggestion.lhName,
                          style: TextStyle(color: Colors.white
                          ),
                        ),
                      ),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    print(suggestion.lhName);
                    print("selected");

                    customerController.text = suggestion.lhName;
                    print(suggestion.id);
                    print(".......purchase Ledger id");
                    LedgerId = suggestion.id;

                    print(LedgerId);
                    print("...........");
                  },
                  errorBuilder: (BuildContext context, Object? error) =>
                      Text('$error',
                          style: TextStyle(
                              color: Theme.of(context).errorColor)),
                  transitionBuilder:
                      (context, suggestionsBox, animationController) =>
                      FadeTransition(
                        child: suggestionsBox,
                        opacity: CurvedAnimation(
                            parent: animationController!,
                            curve: Curves.elasticIn),
                      )),
            ),
            SizedBox(width: 10),

            SizedBox(height: 40,width: 60,
              child: cw.CUButton(color: Colors.blue,function:() {
                setState(() {
                  customerController.text="";
                  Ledger_Posting_Controller.text="";
                });
              },name: "Add"),
            ),

            SizedBox(width: 10),
          ],
        ),



        Row(
          children: [
            Checkbox(

              value: Enable_master_index_page??false,
              onChanged: (bool? value) {
                setState(() {
                  Enable_master_index_page=!Enable_master_index_page;
                });
              },
            ),
            Text("Enable master index page"),






          ],
        ),




        Row(
          children: [
            Checkbox(

              value: Enable_transaction_index_page??false,
              onChanged: (bool? value) {
                setState(() {
                  Enable_transaction_index_page=!Enable_transaction_index_page;
                });
              },
            ),
            Text("Enable transaction index page"),






          ],
        ),



        Row(
          children: [
            Checkbox(

              value: Purchase_Tax_Inclusive??false,
              onChanged: (bool? value) {
                setState(() {
                  Purchase_Tax_Inclusive=!Purchase_Tax_Inclusive;
                });
              },
            ),
            Text("Purchase Tax Inclusive"),






          ],
        ),


        Row(
          children: [
            Checkbox(

              value: Sales_TaxInclusive??false,
              onChanged: (bool? value) {
                setState(() {
                  Sales_TaxInclusive=!Sales_TaxInclusive;
                });
              },
            ),
            Text("Sales TaxInclusive"),

          ],
        ),






        Row(
          children: [
            Checkbox(

              value: Batch_Expiry_applicable??false,
              onChanged: (bool? value) {
                setState(() {
                  Batch_Expiry_applicable=!Batch_Expiry_applicable;
                });
              },
            ),
            Text("Batch & Expiry applicable"),
          ],
        ),






        Row(
          children: [
            Checkbox(

              value: Show_Notes_Purchase_Or_Sales??false,
              onChanged: (bool? value) {
                setState(() {
                  Show_Notes_Purchase_Or_Sales=!Show_Notes_Purchase_Or_Sales;
                });
              },
            ),
            Text("Show Notes Purchase/Sales"),

          ],
        ),


        Row(
          children: [
            Checkbox(

              value: Enable_godown??false,
              onChanged: (bool? value) {
                setState(() {
                  Enable_godown=!Enable_godown;
                  print(Enable_godown);
                });
              },
            ),
            Text("Enable godown"),






          ],
        ),




      ],);
  }




  ///--------------------------GenSett_Purchase---------------------------------
  GenSett_Purchase(){
    return  Column(children: [
      Row(children: [
        Checkbox(

          value: Purchase_Edit_After_Stock_Update??false,
          onChanged: (bool? value) {
            setState(() {
              Purchase_Edit_After_Stock_Update=!Purchase_Edit_After_Stock_Update;
            });
          },
        ),
        Text("Purchase Edit After Stock Update"),
      ],),



      Row(children: [
        Checkbox(

          value: Generate_Barcode_In_Purchase??false,
          onChanged: (bool? value) {
            setState(() {
              Generate_Barcode_In_Purchase=!Generate_Barcode_In_Purchase;
            });
          },
        ),
        Text("Generate Barcode In Purchase"),
      ],),



      Row(children: [
        Checkbox(

          value: Auto_Generate_Batch_In_Purchase??false,
          onChanged: (bool? value) {
            setState(() {
              Auto_Generate_Batch_In_Purchase=!Auto_Generate_Batch_In_Purchase;
            });
          },
        ),
        Text("Auto Generate Batch In Purchase"),
      ],),



      Row(children: [
        Checkbox(

          value: Update_ItemRate_BasedOn_Purchase??false,
          onChanged: (bool? value) {
            setState(() {
              Update_ItemRate_BasedOn_Purchase=!Update_ItemRate_BasedOn_Purchase;
            });
          },
        ),
        Text("Update ItemRate BasedOn Purchase"),
      ],),

    ],);


  }

  ///-------------------------------Sales---------------------------------------

  GenSett_Sales(){


    return ListView(
        shrinkWrap: true,
        children:[

      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                      style: TextStyle(),
                      controller: Default_Invoice_Type_BtB_Or_BtC,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.red),
                        errorText: Validation_Default_Invoice_Type_BtB_Or_BtC
                            ? "Please Select ?"
                            : null,
//                            errorText: _validateName ? "please enter name" : null,
//                            errorBorder:InputBorder.none ,
                        suffixIcon: IconButton(
                          icon: Icon(Icons.remove_circle),
                          color: Colors.blue,
                          onPressed: () {
                            setState(() {
                              print("cleared");
                              Default_Invoice_Type_BtB_Or_BtC.text = "";
                              Default_Invoice_Type_BtB_Or_BtC_Content = null;

                            });
                          },
                        ),

                        isDense: true,
                        contentPadding:
                        EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        // i need very low size height
                        labelText:
                        'Default Invoice Type BtB Or BtC', 
                      )),
                  suggestionsBoxDecoration:
                  SuggestionsBoxDecoration(elevation: 90.0),
                  suggestionsCallback: (pattern) {
                    return _Defult_invo_Btc_Btb.where((user) =>
                        user["name"]!.toUpperCase().contains(pattern.toUpperCase()));
                  },
                  itemBuilder: (context, suggestion) {
                    return Card(
                      color:theam.DropDownClr,
                      child: ListTile(
                        // focusColor: Colors.blue,
                        // hoverColor: Colors.red,
                        title: Text(
                          suggestion["name"]!,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    print(suggestion["name"]);
                    print("selected");

                    Default_Invoice_Type_BtB_Or_BtC.text = suggestion["name"]!;
                    print("close.... ${Default_Invoice_Type_BtB_Or_BtC_Content}");
                    Default_Invoice_Type_BtB_Or_BtC_Content = null;

                    print(suggestion["id"]);
                    print("....... Id__Item_Default_Stock_Type");
                    Default_Invoice_Type_BtB_Or_BtC_Content = suggestion["id"];

                    print(Default_Invoice_Type_BtB_Or_BtC_Content);
                    print("...........");
                  },
                  errorBuilder: (BuildContext context, Object? error) =>
                      Text('$error',
                          style: TextStyle(
                              color: Theme.of(context).errorColor)),
                  transitionBuilder:
                      (context, suggestionsBox, animationController) =>
                      FadeTransition(
                        child: suggestionsBox,
                        opacity: CurvedAnimation(
                            parent: animationController!,
                            curve: Curves.elasticIn),
                      )),
            ),
          ],
        ),
      ),


      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                      style: TextStyle(),
                      controller: Sales_Default_Pay_Type,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.red),
                        errorText: Validation_Sales_Default_Pay_Type
                            ? "Please Select ?"
                            : null,
//                            errorText: _validateName ? "please enter name" : null,
//                            errorBorder:InputBorder.none ,
                        suffixIcon: IconButton(
                          icon: Icon(Icons.remove_circle),
                          color: Colors.blue,
                          onPressed: () {
                            setState(() {
                              print("cleared");
                              Sales_Default_Pay_Type.text = "";
                              Sales_Default_Pay_Type_Content = null;

                            });
                          },
                        ),

                        isDense: true,
                        contentPadding:
                        EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        // i need very low size height
                        labelText:
                        'Sales Default Pay Type', 
                      )),
                  suggestionsBoxDecoration:
                  SuggestionsBoxDecoration(elevation: 90.0),
                  suggestionsCallback: (pattern) {
                    return _Sls_Defult_pytyp.where((user) =>
                        user["name"]!.toUpperCase().contains(pattern.toUpperCase()));
                  },
                  itemBuilder: (context, suggestion) {
                    return Card(
                      color:theam.DropDownClr,
                      child: ListTile(
                        // focusColor: Colors.blue,
                        // hoverColor: Colors.red,
                        title: Text(
                          suggestion["name"]!,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    print(suggestion["name"]);
                    print("selected");

                    Sales_Default_Pay_Type.text = suggestion["name"]!;
                    print("close.... ${Sales_Default_Pay_Type_Content}");
                    Sales_Default_Pay_Type_Content = null;

                    print(suggestion["id"]);
                    print("....... Id__Item_Default_Stock_Type");
                    Sales_Default_Pay_Type_Content = suggestion["id"];

                    print(Sales_Default_Pay_Type_Content);
                    print("...........");
                  },
                  errorBuilder: (BuildContext context, Object? error) =>
                      Text('$error',
                          style: TextStyle(
                              color: Theme.of(context).errorColor)),
                  transitionBuilder:
                      (context, suggestionsBox, animationController) =>
                      FadeTransition(
                        child: suggestionsBox,
                        opacity: CurvedAnimation(
                            parent: animationController!,
                            curve: Curves.elasticIn),
                      )),
            ),
          ],
        ),
      ),



      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                      style: TextStyle(),
                      controller: Sales_Printer_Type,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.red),
                        errorText: Validation_Sales_Printer_Type
                            ? "Please Select ?"
                            : null,
//                            errorText: _validateName ? "please enter name" : null,
//                            errorBorder:InputBorder.none ,
                        suffixIcon: IconButton(
                          icon: Icon(Icons.remove_circle),
                          color: Colors.blue,
                          onPressed: () {
                            setState(() {
                              print("cleared");
                              Sales_Printer_Type.text = "";
                              Sales_Printer_Type_Content = null;

                            });
                          },
                        ),

                        isDense: true,
                        contentPadding:
                        EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        // i need very low size height
                        labelText:
                        'Sales Printer Type', 
                      )),
                  suggestionsBoxDecoration:
                  SuggestionsBoxDecoration(elevation: 90.0),
                  suggestionsCallback: (pattern) {
                    return _sls_prnt_typ.where((user) =>
                        user["name"]!.toUpperCase().contains(pattern.toUpperCase()));
                  },
                  itemBuilder: (context, suggestion) {
                    return Card(
                      color:theam.DropDownClr,
                      child: ListTile(
                        // focusColor: Colors.blue,
                        // hoverColor: Colors.red,
                        title: Text(
                          suggestion["name"]!,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    print(suggestion["name"]);
                    print("selected");

                    Sales_Printer_Type.text = suggestion["name"]!;
                    print("close.... ${Sales_Printer_Type_Content}");
                    Sales_Printer_Type_Content = null;

                    print(suggestion["id"]);
                    print("....... Id__Item_Default_Stock_Type");
                    Sales_Printer_Type_Content = suggestion["id"];

                    print(Sales_Printer_Type_Content);
                    print("...........");
                  },
                  errorBuilder: (BuildContext context, Object? error) =>
                      Text('$error',
                          style: TextStyle(
                              color: Theme.of(context).errorColor)),
                  transitionBuilder:
                      (context, suggestionsBox, animationController) =>
                      FadeTransition(
                        child: suggestionsBox,
                        opacity: CurvedAnimation(
                            parent: animationController!,
                            curve: Curves.elasticIn),
                      )),
            ),
          ],
        ),
      ),


      Row(children: [
        Checkbox(

          value: Negative_sales_allow??false,
          onChanged: (bool? value) {
            setState(() {
              Negative_sales_allow=!Negative_sales_allow;
            });
          },
        ),
        Text("Negative sales allow"),
      ],),



      Row(children: [
        Checkbox(

          value: Show_stock_in_sales??false,
          onChanged: (bool? value) {
            setState(() {
              Show_stock_in_sales=!Show_stock_in_sales;
            });
          },
        ),
        Text("Show stock in sales"),
      ],),






      Row(children: [
        Checkbox(

          value: Stock_Batch_Base_Sales_Rate??false,
          onChanged: (bool? value) {
            setState(() {
              Stock_Batch_Base_Sales_Rate=!Stock_Batch_Base_Sales_Rate;
            });
          },
        ),
        Text("Stock Batch Base Sales Rate"),
      ],),






      Row(children: [
        Checkbox(

          value: Item_From_Stock_Table??false,
          onChanged: (bool? value) {
            setState(() {
              Item_From_Stock_Table=!Item_From_Stock_Table;
            });
          },
        ),
        Text("Item From Stock Table"),
      ],),






      Row(children: [
        Checkbox(

          value: Enable_gross_sales_discount??false,
          onChanged: (bool? value) {
            setState(() {
              Enable_gross_sales_discount=!Enable_gross_sales_discount;
            });
          },
        ),
        Text("Enable gross sales discount"),
      ],),






      Row(children: [
        Checkbox(

          value: Disable_item_wise_sales_discount??false,
          onChanged: (bool? value) {
            setState(() {
              Disable_item_wise_sales_discount=!Disable_item_wise_sales_discount;
            });
          },
        ),
        Text("Disable item wise sales discount"),
      ],),





      Row(children: [
        Checkbox(

          value: Fixed_Discount_In_Sales??false,
          onChanged: (bool? value) {
            setState(() {
              Fixed_Discount_In_Sales=!Fixed_Discount_In_Sales;
            });
          },
        ),
        Text("Fixed Discount In Sales"),
      ],),





      Row(children: [
        Checkbox(

          value: Sales_Invoice_Date_Editable??false,
          onChanged: (bool? value) {
            setState(() {
              Sales_Invoice_Date_Editable=!Sales_Invoice_Date_Editable;
            });
          },
        ),
        Text("Sales Invoice Date Editable"),
      ],),





      Row(children: [
        Checkbox(

          value: Print_Sales_Man_In_Invoice??false,
          onChanged: (bool? value) {
            setState(() {
              Print_Sales_Man_In_Invoice=!Print_Sales_Man_In_Invoice;
            });
          },
        ),
        Text("Print Sales Man In Invoice"),
      ],),







      Row(children: [
        Checkbox(

          value: Print_Login_User_In_Invoice??false,
          onChanged: (bool? value) {
            setState(() {
              Print_Login_User_In_Invoice=!Print_Login_User_In_Invoice;
            });
          },
        ),
        Text("Print Login User In Invoice"),
      ],),





      Row(children: [
        Checkbox(

          value: Sales_thermal_print??false,
          onChanged: (bool? value) {
            setState(() {
              Sales_thermal_print=!Sales_thermal_print;
            });
          },
        ),
        Text("Sales thermal print"),
      ],),





      Row(children: [
        Checkbox(

          value: Sales_Direct_Print??false,
          onChanged: (bool? value) {
            setState(() {
              Sales_Direct_Print=!Sales_Direct_Print;
            });
          },
        ),
        Text("Sales Direct Print"),
      ],),






      Row(children: [
        Checkbox(

          value: Mrp_On_Thermal_Print??false,
          onChanged: (bool? value) {
            setState(() {
              Mrp_On_Thermal_Print=!Mrp_On_Thermal_Print;
            });
          },
        ),
        Text("Mrp On Thermal Print"),
      ],),







      Row(children: [
        Checkbox(

          value: Enable_Barcode_In_Sales??false,
          onChanged: (bool? value) {
            setState(() {
              Enable_Barcode_In_Sales=!Enable_Barcode_In_Sales;
            });
          },
        ),
        Text("Enable Barcode In Sales"),
      ],),






      Row(children: [
        Checkbox(

          value: Enable_Packing_Slip_In_Sales??false,
          onChanged: (bool? value) {
            setState(() {
              Enable_Packing_Slip_In_Sales=!Enable_Packing_Slip_In_Sales;
            });
          },
        ),
        Text("Enable Packing Slip In Sales"),
      ],),





          Row(children: [
            Checkbox(

              value: printLedgerBalanceInInvoice??false,
              onChanged: (bool? value) {
                setState(() {
                  printLedgerBalanceInInvoice=!printLedgerBalanceInInvoice;
                });
              },
            ),
            Text("Print Ledger Balance In Invoice"),
          ],),








          Padding(
            padding: const EdgeInsets.all(8.0),
            child:Row(
              children: [
                Expanded(child: cw.CUTestbox(label: "Footer Caption",controllerName: FooterCaption_Controller)),
                Checkbox(

                  value:FooterCaption_Bold,
                  onChanged: (bool? value) {
                    setState(() {
                      FooterCaption_Bold=!FooterCaption_Bold;
                    });
                  },
                ),
                Text("Bold"),

              ],
            ),
          ),


          Padding(
            padding: const EdgeInsets.all(8.0),
            child:Row(
              children: [
                Expanded(child: cw.CUTestbox(label: "Footer Text",controllerName: FooterText_Controller)),

                Checkbox(

                  value:FooterText_Bold,
                  onChanged: (bool? value) {
                    setState(() {
                      FooterText_Bold=!FooterText_Bold;
                    });
                  },
                ),
                Text("Bold"),





              ],
            ),
          ),


          Padding(
            padding: const EdgeInsets.all(8.0),
            child:Row(
              children: [

                Expanded(
                  child: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                          style: TextStyle(),
                          controller: FooterAlign_Controller,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(color: Colors.red),
                            // errorText: Validation_Sales_Printer_Type
                            //     ? "Please Select ?"
                            //     : null,
//                            errorText: _validateName ? "please enter name" : null,
//                            errorBorder:InputBorder.none ,
                            suffixIcon: IconButton(
                              icon: Icon(Icons.remove_circle),
                              color: Colors.blue,
                              onPressed: () {
                                setState(() {
                                  print("cleared");
                                  FooterAlign_Controller.text = "";
                                  FooterAlign_Controller_Id= null;

                                });
                              },
                            ),

                            isDense: true,
                            contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            // i need very low size height
                            labelText:
                            'Align',
                          )),
                      suggestionsBoxDecoration:
                      SuggestionsBoxDecoration(elevation: 90.0),
                      suggestionsCallback: (pattern) {
                        return _FooterAlign_Data.where((user) =>
                            user["name"]!.toUpperCase().contains(pattern.toUpperCase()));
                      },
                      itemBuilder: (context, suggestion) {
                        return Card(
                          color:theam.DropDownClr,
                          child: ListTile(
                            // focusColor: Colors.blue,
                            // hoverColor: Colors.red,
                            title: Text(
                              suggestion["name"]!,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                      onSuggestionSelected: (suggestion) {
                        print(suggestion["name"]);
                        print("selected");

                        FooterAlign_Controller.text = suggestion["name"]!;
                        print("close.... ${FooterAlign_Controller_Id}");
                        FooterAlign_Controller_Id = null;

                        print(suggestion["id"]);
                        print("....... Id__Item_Default_Stock_Type");
                        FooterAlign_Controller_Id = suggestion["id"];

                        print(FooterAlign_Controller_Id);
                        print("...........");
                      },
                      errorBuilder: (BuildContext context, Object? error) =>
                          Text('$error',
                              style: TextStyle(
                                  color: Theme.of(context).errorColor)),
                      transitionBuilder:
                          (context, suggestionsBox, animationController) =>
                          FadeTransition(
                            child: suggestionsBox,
                            opacity: CurvedAnimation(
                                parent: animationController!,
                                curve: Curves.elasticIn),
                          )),
                ),

                SizedBox(width: 13,),
                ElevatedButton(onPressed: (){

                  if(FooterCaption_Controller.text==""){

                    return;
                  }
                  else {
                    AddFooterData();
                    // var Ftrdata = {
                    //   "Slnum":FtrdataSlNum++,
                    //   "footerCaption": FooterCaption_Controller.text,
                    //   "footercaptionbold": FooterCaption_Bold,
                    //   "footertext": FooterText_Controller.text,
                    //   "footertextbold": FooterText_Bold,
                    //   "footeralign": FooterAlign_Controller.text,
                    //   "footeralign_id": FooterAlign_Controller_Id,
                    // };
                    //
                    // FooterDataTable.add(Ftrdata);
                    // setState(() {
                    //   FooterCaption_Controller.text = "";
                    //   FooterCaption_Bold = false;
                    //   FooterText_Controller.text = "";
                    //   FooterText_Bold = false;
                    //   FooterAlign_Controller.text = "";
                    //   FooterAlign_Controller_Id = null;
                    // });
                  }
                }, child: Text("Add"),)

              ],
            ),
          ),



          Visibility(
            visible: FooterDataTable.isNotEmpty,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(showCheckboxColumn: false,
                  columnSpacing: 17,
                  onSelectAll: (b) {},
                  sortAscending: true,
                  columns: <DataColumn>[
                    DataColumn(
                      label: Text('Footer Caption'),
                    ),
                    DataColumn(
                      label: Text('Bold'),
                    ),
                    DataColumn(
                      label: Text('Footer Text'),
                    ),
                    DataColumn(
                      label: Text('Bold'),
                    ),
                    DataColumn(
                      label: Text('Align'),
                    ) ,

                    DataColumn(
                      label: Text(''),
                    ),

                  ],
                  rows: FooterDataTable
                      .map(
                        (itemRow) => DataRow(
                      cells: [
                        DataCell(
                          Text(
                              '${itemRow['footerCaption'].toString()=="null"?"-":itemRow['footerCaption'].toString()}'),
                          showEditIcon: false,
                          placeholder: false,
                        ),

                        DataCell(
                          Text(
                              '${itemRow['footerCaptionBold'].toString()=="null"?"-":itemRow['footerCaptionBold'].toString()}'),
                          showEditIcon: false,
                          placeholder: false,
                        ),



                        DataCell(
                          Text(
                              '${itemRow['footerText'].toString()=="null"?"-":itemRow['footerText'].toString()}'),
                          showEditIcon: false,
                          placeholder: false,
                        ),


                        DataCell(
                          Text(
                              '${itemRow['footerTextBold'].toString()=="null"?"-":itemRow['footerTextBold'].toString()}'),
                          showEditIcon: false,
                          placeholder: false,
                        ),

                        DataCell(
                          Text(
                              '${itemRow['textAlign'].toString()=="null"?"-":itemRow['textAlign'].toString()}'),
                          showEditIcon: false,
                          placeholder: false,
                        ),

                        DataCell(
                          IconButton(icon: Icon(Icons.delete), onPressed: (){
                            print("gjugy");
                            print(itemRow["id"]);
                            DeleteFooterData(itemRow["id"]);
                            setState(() {

                            });
                          }),
                          showEditIcon: false,
                          placeholder: false,
                        ),






                      ],
                    ),
                  )
                      .toList(),
                ),
              ),
            ),
          ),






SizedBox(height: 60)




        ]) ;





  }






    ///-------------------------- GenSett_Account---------------------------------
  GenSett_Account(){


   return Column(children:[

     Padding(
       padding: const EdgeInsets.all(8.0),
       child: Row(
         children: [
           Expanded(
             child: TypeAheadField(
                 textFieldConfiguration: TextFieldConfiguration(
                     style: TextStyle(),
                     controller: Payment_Ledger_Posting_while,
                     textInputAction: TextInputAction.next,
                     decoration: InputDecoration(
                       errorStyle: TextStyle(color: Colors.red),
                       errorText: Validation_Payment_Ledger_Posting_while
                           ? "Please Select ?"
                           : null,
//                            errorText: _validateName ? "please enter name" : null,
//                            errorBorder:InputBorder.none ,
                       suffixIcon: IconButton(
                         icon: Icon(Icons.remove_circle),
                         color: Colors.blue,
                         onPressed: () {
                           setState(() {
                             print("cleared");
                             Payment_Ledger_Posting_while.text = "";
                             Payment_Ledger_Posting_while_Content = null;

                           });
                         },
                       ),

                       isDense: true,
                       contentPadding:
                       EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                       border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(10.0)),
                       // i need very low size height
                       labelText:
                       'Payment Ledger Posting while', 
                     )),
                 suggestionsBoxDecoration:
                 SuggestionsBoxDecoration(elevation: 90.0),
                 suggestionsCallback: (pattern) {
                   return _PayLgr_pstWhile.where((user) =>
                       user["name"]!.toUpperCase().contains(pattern.toUpperCase()));
                 },
                 itemBuilder: (context, suggestion) {
                   return Card(
                     color:theam.DropDownClr,
                     child: ListTile(
                       // focusColor: Colors.blue,
                       // hoverColor: Colors.red,
                       title: Text(
                         suggestion["name"]!,
                         style: TextStyle(color: Colors.white),
                       ),
                     ),
                   );
                 },
                 onSuggestionSelected: (suggestion) {
                   print(suggestion["name"]);
                   print("selected");

                   Payment_Ledger_Posting_while.text = suggestion["name"]!;
                   print("close.... ${Payment_Ledger_Posting_while_Content}");
                   Payment_Ledger_Posting_while_Content = null;

                   print(suggestion["id"]);
                   print("....... Id__Item_Default_Stock_Type");
                   Payment_Ledger_Posting_while_Content = suggestion["id"];

                   print(Payment_Ledger_Posting_while_Content);
                   print("...........");
                 },
                 errorBuilder: (BuildContext context, Object? error) =>
                     Text('$error',
                         style: TextStyle(
                             color: Theme.of(context).errorColor)),
                 transitionBuilder:
                     (context, suggestionsBox, animationController) =>
                     FadeTransition(
                       child: suggestionsBox,
                       opacity: CurvedAnimation(
                           parent: animationController!,
                           curve: Curves.elasticIn),
                     )),
           ),
         ],
       ),
     ),


     Padding(
       padding: const EdgeInsets.all(8.0),
       child: Row(
         children: [
           Expanded(
             child: TypeAheadField(
                 textFieldConfiguration: TextFieldConfiguration(
                     style: TextStyle(),
                     controller: Receipt_Ledger_Posting_while,
                     textInputAction: TextInputAction.next,
                     decoration: InputDecoration(
                       errorStyle: TextStyle(color: Colors.red),
                       errorText: Validation_Receipt_Ledger_Posting_while
                           ? "Please Select ?"
                           : null,
//                            errorText: _validateName ? "please enter name" : null,
//                            errorBorder:InputBorder.none ,
                       suffixIcon: IconButton(
                         icon: Icon(Icons.remove_circle),
                         color: Colors.blue,
                         onPressed: () {
                           setState(() {
                             print("cleared");
                             Receipt_Ledger_Posting_while.text = "";
                             Receipt_Ledger_Posting_while_Content = null;

                           });
                         },
                       ),

                       isDense: true,
                       contentPadding:
                       EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                       border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(10.0)),
                       // i need very low size height
                       labelText:
                       'Receipt Ledger Posting while', 
                     )),
                 suggestionsBoxDecoration:
                 SuggestionsBoxDecoration(elevation: 90.0),
                 suggestionsCallback: (pattern) {
                   return _RcptLgr_pstWhile.where((user) =>
                       user["name"]!.toUpperCase().contains(pattern.toUpperCase()));
                 },
                 itemBuilder: (context, suggestion) {
                   return Card(
                     color:theam.DropDownClr,
                     child: ListTile(
                       // focusColor: Colors.blue,
                       // hoverColor: Colors.red,
                       title: Text(
                         suggestion["name"]!,
                         style: TextStyle(color: Colors.white),
                       ),
                     ),
                   );
                 },
                 onSuggestionSelected: (suggestion) {
                   print(suggestion["name"]);
                   print("selected");

                   Receipt_Ledger_Posting_while.text = suggestion["name"]!;
                   print("close.... ${Receipt_Ledger_Posting_while_Content}");
                   Receipt_Ledger_Posting_while_Content = null;

                   print(suggestion["id"]);
                   print("....... Id__Item_Default_Stock_Type");
                   Receipt_Ledger_Posting_while_Content = suggestion["id"];

                   print(Receipt_Ledger_Posting_while_Content);
                   print("...........");
                 },
                 errorBuilder: (BuildContext context, Object? error) =>
                     Text('$error',
                         style: TextStyle(
                             color: Theme.of(context).errorColor)),
                 transitionBuilder:
                     (context, suggestionsBox, animationController) =>
                     FadeTransition(
                       child: suggestionsBox,
                       opacity: CurvedAnimation(
                           parent: animationController!,
                           curve: Curves.elasticIn),
                     )),
           ),
         ],
       ),
     ),






     Padding(
       padding: const EdgeInsets.all(8.0),
       child: Row(
         children: [
           Expanded(
             child: TypeAheadField(
                 textFieldConfiguration: TextFieldConfiguration(
                     style: TextStyle(),
                     controller: Journal_Ledger_Posting_while,
                     textInputAction: TextInputAction.next,
                     decoration: InputDecoration(
                       errorStyle: TextStyle(color: Colors.red),
                       errorText: Validation_Journal_Ledger_Posting_while
                           ? "Please Select ?"
                           : null,
//                            errorText: _validateName ? "please enter name" : null,
//                            errorBorder:InputBorder.none ,
                       suffixIcon: IconButton(
                         icon: Icon(Icons.remove_circle),
                         color: Colors.blue,
                         onPressed: () {
                           setState(() {
                             print("cleared");
                             Journal_Ledger_Posting_while.text = "";
                             Journal_Ledger_Posting_while_Content = null;

                           });
                         },
                       ),

                       isDense: true,
                       contentPadding:
                       EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                       border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(10.0)),
                       // i need very low size height
                       labelText:
                       'Journal Ledger Posting while', 
                     )),
                 suggestionsBoxDecoration:
                 SuggestionsBoxDecoration(elevation: 90.0),
                 suggestionsCallback: (pattern) {
                   return _Jrnl_Ldgr_pstWhile.where((user) =>
                       user["name"]!.toUpperCase().contains(pattern.toUpperCase()));
                 },
                 itemBuilder: (context, suggestion) {
                   return Card(
                     color:theam.DropDownClr,
                     child: ListTile(
                       // focusColor: Colors.blue,
                       // hoverColor: Colors.red,
                       title: Text(
                         suggestion["name"]!,
                         style: TextStyle(color: Colors.white),
                       ),
                     ),
                   );
                 },
                 onSuggestionSelected: (suggestion) {
                   print(suggestion["name"]);
                   print("selected");

                   Journal_Ledger_Posting_while.text = suggestion["name"]!;
                   print("close.... ${Journal_Ledger_Posting_while_Content}");
                   Journal_Ledger_Posting_while_Content = null;

                   print(suggestion["id"]);
                   print("....... Id__Item_Default_Stock_Type");
                   Journal_Ledger_Posting_while_Content = suggestion["id"];

                   print(Journal_Ledger_Posting_while_Content);
                   print("...........");
                 },
                 errorBuilder: (BuildContext context, Object? error) =>
                     Text('$error',
                         style: TextStyle(
                             color: Theme.of(context).errorColor)),
                 transitionBuilder:
                     (context, suggestionsBox, animationController) =>
                     FadeTransition(
                       child: suggestionsBox,
                       opacity: CurvedAnimation(
                           parent: animationController!,
                           curve: Curves.elasticIn),
                     )),
           ),
         ],
       ),
     ),


   ]) ;





  }






    ///-------------------------- GenSett_RMS---------------------------------
  GenSett_RMS(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [


        SizedBox(height: 10,),
        cw.CUTestbox(
            controllerName: Rms_Counter_Printer,
            label: "Rms Counter Printer"

        ),

        SizedBox(height: 10,),

        cw.CUTestbox(
            controllerName: Rms_Kot_Printer,
            label: "Rms Kot Printer"

        ),



        Row(children: [
          Checkbox(

            value: Enable_Makeorder_In_Rms??false,
            onChanged: (bool? value) {
              setState(() {
                Enable_Makeorder_In_Rms=!Enable_Makeorder_In_Rms;
              });
            },
          ),
          Text("Enable Makeorder In Rms"),
        ],),



        Row(children: [
          Checkbox(

            value:Bypass_Delivery_Process_In_Rms??false,
            onChanged: (bool? value) {
              setState(() {
                Bypass_Delivery_Process_In_Rms=!Bypass_Delivery_Process_In_Rms;
              });
            },
          ),
          Text("Bypass Delivery Process In Rms"),
        ],),


      ],),
    );
  }






    ///-------------------------- GenSett_Dash_Board---------------------------------
  GenSett_Dash_Board(){
  return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [


        SizedBox(height: 10,),
        cw.CUTestbox(
            controllerName: Main_Navbar_Logo_Name,
            label: "Main Navbar Logo Name"

        ),

        SizedBox(height: 10,),

        cw.CUTestbox(
            controllerName: Dash_Board_Header_Name,
            label: "Dash Board Header Name"

        ),



      ],),
    );
  }




     ///-------------------------- GenSett_Country---------------------------------
  GenSett_Country(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [


        SizedBox(height: 10,),
        cw.CUTestbox(
            controllerName:Country_Code,
            label: "Country Code"

        ),

        SizedBox(height: 10,),

        cw.CUTestbox(
            controllerName: Country_Name,
            label: "Country Name"

        ),


        SizedBox(height: 10,),


        Row(
          children: [
            Expanded(
              child: TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller:Time_Zone_Code ,
                    style: TextStyle(),
                    decoration: InputDecoration(
                      errorStyle: TextStyle(color: Colors.red),
                      isDense: true,
                      //  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 5.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),

                      hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                      labelText: "Time Zone Code",
                    ),
                  ),

                  suggestionsBoxDecoration:
                  SuggestionsBoxDecoration(elevation: 90.0),
                  suggestionsCallback: (pattern) {
//                        print(payment);
                    return TimeZone.where((unt) => unt["name"]!.contains(pattern));
                  },
                  itemBuilder: (context, suggestion) {
                    return Card(
                      color: Colors.blue,
                      child: ListTile(
                        tileColor: theam.DropDownClr,
                        title: Text(
                          suggestion["name"]!,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    print(suggestion["name"]);
                    print("Unit selected");
                    Time_Zone_Code.text = suggestion["name"]!;

                  },
                  errorBuilder: (BuildContext context, Object? error) =>
                      Text('$error',
                          style: TextStyle(
                              color: Theme.of(context).errorColor)),
                  transitionBuilder:
                      (context, suggestionsBox, animationController) =>
                      FadeTransition(
                        child: suggestionsBox,
                        opacity: CurvedAnimation(
                            parent: animationController!,
                            curve: Curves.elasticIn),
                      )),
            ),
          ],
        ),


        SizedBox(height: 10,),

        cw.CUTestbox(
            controllerName: Currency_Name,
            label: "Currency Name"

        ),




        SizedBox(height: 10,),

        cw.CUTestbox(
          controllerName: Currency_Decimals,
          label: "Currency Decimals",
          TextInputFormatter:  <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}")),
          ],
          TextInputType: TextInputType.number,
        ),


        SizedBox(height: 10,),

        cw.CUTestbox(
            controllerName: Currency_Coin_Name,
            label: "Currency Coin Name"

        ),



      ],),
    );
  }




   ///-------------------------- GenSett_System---------------------------------
  GenSett_System(){
    return ListView(shrinkWrap: true,
      children: [

      Container(
        height: 60,
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: TextFormField(
          obscureText: true,
         onChanged: (a){
            if(a=="nopasswordset"){
              setState(() {
                Show_DbUtility=true;
              });
            }
            else {
              setState(() {
                Show_DbUtility = false;
              });
            }
         },
          controller: System_passwordController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Password',
            errorStyle: TextStyle(
              color: Colors.brown,
              fontSize: 15.0,
            ),
            errorText:
            Validate_System_passwordController ? 'Invalid Password!' : null,
          ),
        ),
      ),


      Visibility(
        visible: Show_DbUtility==true,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(children: [
              Row(mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                children: [


                  ElevatedButton(onPressed: (){}, child: Text("Reset Transaction"),style: ButtonStyle(
                    backgroundColor:  MaterialStateProperty.all(Colors.red),
                  ),) ,


                  ElevatedButton(onPressed: (){}, child: Text("Reset Transaction"),style: ButtonStyle(
                    backgroundColor:  MaterialStateProperty.all(Colors.red),
                  ),)

//
                ],
              ),


              Row(mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                children: [


                  ElevatedButton(onPressed: (){}, child: Text("Backup DB"),style: ButtonStyle(
                    backgroundColor:  MaterialStateProperty.all(Colors.green),
                  ),) ,


                  ElevatedButton(onPressed: (){}, child: Text("Create Company"),style: ButtonStyle(
                    backgroundColor:  MaterialStateProperty.all(Colors.green),
                  ),)



                ,  ElevatedButton(onPressed: (){}, child: Text("Do Patch"),style: ButtonStyle(
                    backgroundColor:  MaterialStateProperty.all(Colors.red),
                  ),)


//
                ],
              ),




              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                              style: TextStyle(),
                              controller: Application_TypeController,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                errorStyle: TextStyle(color: Colors.red),
                                errorText: Validation_Application_Type
                                    ? "Please Select ?"
                                    : null,
//                            errorText: _validateName ? "please enter name" : null,
//                            errorBorder:InputBorder.none ,
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.remove_circle),
                                  color: Colors.blue,
                                  onPressed: () {
                                    setState(() {
                                      print("cleared");
                                      Application_TypeController.text = "";
                                      Application_Type_Content = null;

                                    });
                                  },
                                ),

                                isDense: true,
                                contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                // i need very low size height
                                labelText:
                                'Payment Ledger Posting while',
                              )),
                          suggestionsBoxDecoration:
                          SuggestionsBoxDecoration(elevation: 90.0),
                          suggestionsCallback: (pattern) {
                            return _Application_Typee_Data.where((user) =>
                                user["name"]!.toUpperCase().contains(pattern.toUpperCase()));
                          },
                          itemBuilder: (context, suggestion) {
                            return Card(
                              color:theam.DropDownClr,
                              child: ListTile(
                                // focusColor: Colors.blue,
                                // hoverColor: Colors.red,
                                title: Text(
                                  suggestion["name"]!,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            print(suggestion["name"]);
                            print("selected");

                            Application_TypeController.text = suggestion["name"]!;
                            print("close.... ${Application_Type_Content}");
                            Application_Type_Content = null;

                            print(suggestion["id"]);
                            print("....... Id__Item_Default_Stock_Type");
                            Application_Type_Content = suggestion["id"];

                            print(Application_Type_Content);
                            print("...........");
                          },
                          errorBuilder: (BuildContext context, Object? error) =>
                              Text('$error',
                                  style: TextStyle(
                                      color: Theme.of(context).errorColor)),
                          transitionBuilder:
                              (context, suggestionsBox, animationController) =>
                              FadeTransition(
                                child: suggestionsBox,
                                opacity: CurvedAnimation(
                                    parent: animationController!,
                                    curve: Curves.elasticIn),
                              )),
                    ),
                  ],
                ),
              ),


              Row(children: [
                Checkbox(

                  value:Branch_wise_Master_Display??false,
                  onChanged: (bool? value) {
                    setState(() {
                      Branch_wise_Master_Display=!Branch_wise_Master_Display;
                    });
                  },
                ),
                Text("Branch wise Master Display"),
              ],),


              Row(children: [
                Checkbox(

                  value:Branch_wise_Employee_Display??false,
                  onChanged: (bool? value) {
                    setState(() {
                      Branch_wise_Employee_Display=!Branch_wise_Employee_Display;
                    });
                  },
                ),
                Text("Branch wise Employee Display"),
              ],),



              Row(children: [
                Checkbox(

                  value:Branch_wise_Branch_Display??false,
                  onChanged: (bool? value) {
                    setState(() {
                      Branch_wise_Branch_Display=!Branch_wise_Branch_Display;
                    });
                  },
                ),
                Text("Branch wise Branch Display"),
              ],),



              Row(children: [
                Checkbox(

                  value:Branch_wise_Ledger_Display??false,
                  onChanged: (bool? value) {
                    setState(() {
                      Branch_wise_Ledger_Display=!Branch_wise_Ledger_Display;
                    });
                  },
                ),
                Text("Branch wise Ledger Display"),
              ],),


              Row(children: [
                Checkbox(

                  value:Application_Tax_Type_GST??false,
                  onChanged: (bool? value) {
                    setState(() {
                      Application_Tax_Type_GST=!Application_Tax_Type_GST;
                    });
                  },
                ),
                Text("Application Tax Type GST"),
              ],),


              Row(children: [
                Checkbox(

                  value:Concurrency_Test_Enable??false,
                  onChanged: (bool? value) {
                    setState(() {
                      Concurrency_Test_Enable=!Concurrency_Test_Enable;
                    });
                  },
                ),
                Text("Concurrency Test Enable"),
              ],),


            ],),
          ))

    ],);
  }










}


