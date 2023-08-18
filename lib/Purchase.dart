import 'dart:async';

import 'package:android_intent/android_intent.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:new_qizo_gt/sales.dart';
import 'package:new_qizo_gt/salesindex.dart';
import 'package:new_qizo_gt/salesmanhome.dart';
import 'package:new_qizo_gt/shopvisited.dart';
import 'package:new_qizo_gt/urlEnvironment/urlEnvironment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'dart:io';

import 'GT_Masters/AppTheam.dart';
import 'GT_Masters/Masters_UI/cuWidgets.dart';
import 'GT_Masters/Printing/PDF_Printer.dart';
import 'GT_Masters/item_group.dart';
import 'Local_Db/Local_db_Model/Test_offline_Sales.dart';
import 'Purchase_Index.dart';
import 'appbarWidget.dart';
import 'models/customersearch.dart';
import 'models/finishedgoods.dart';
import 'models/paymentcondition.dart';
import 'models/userdata.dart';
import 'models/usersession.dart';
import 'newtestpage.dart';



class Purchase extends StatefulWidget {

  dynamic itemrowdata=[];
  int passvalue;
  dynamic passname;
  Purchase({required this.passvalue,this.passname,this.itemrowdata});




  @override
  _PurchaseState createState() => _PurchaseState();

}

class _PurchaseState extends State<Purchase> {
  double TextBoxHeight=40;
  double TextBoxCurve=10;
  bool ItemsAdd_Widget_Visible=false;
  late AutoCompleteTextField searchTextField;
  late UserData userData;
  late String branchName;
  dynamic userName;
  dynamic password;
  late String token;
  dynamic openingAmountBalance = 0.0;
  double grandTotal = 0;
  dynamic delivery = "";
  double itmtxper=0.0;
  dynamic itmqty = "";
  double cessper=0.0;
  double CgstPer=0.0;
  double SgstPer=0.0;
  double Igstper=0.0;
  int? TaxId=null;
  late bool TaxInOrExc;
  dynamic Hsncode="";
  dynamic btnname="";
  // var formatter = NumberFormat('#,##,000.00');
  var formatter = NumberFormat('#,##,##,##,##0.00');
  late int branchId;
  late int userId;
  dynamic userArray;
  dynamic serverDate;
  late UserSession usr;
  var DateOnlyFormat = new DateFormat('yyy/MM/dd');
  String date = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());
  TextEditingController purchasedeliveryController = new TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  bool autovalidate = false;
  List<dynamic> batchdata = [];
  List<dynamic> multibatchdata = [];
  dynamic user;
  bool boxvisible=true;
  AppTheam theam =AppTheam();

  static List<FinishedGoods> goods = [];
  static List<PaymentCondition> payment = [];
  static List<UnitType> unit =[];
  static List<Godown> Gdwn = [];
  dynamic purchaseEditDatas;
  dynamic Vouchnum;
  int? itemGdwnId=null;
  late double Srate;
  dynamic Edate;
  dynamic batchnum;
  dynamic nosunt;
  dynamic Brcode;
  dynamic StkId;
  BluetoothManager bluetoothManager = BluetoothManager.instance;
  PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
  List<PrinterBluetooth> _devices = [];
  var  _devicesMsg="";
  late int customerSelectedId;
  late String customerSelectedEmail;
  late String customerSelectedName;

  TextEditingController controller = new TextEditingController();
  FocusNode field1FocusNode = FocusNode(); //Create first FocusNode

  late String selectedLetter;
  TextEditingController customerController = new TextEditingController();
  TextEditingController godownController = new TextEditingController();
  TextEditingController goodsController = new TextEditingController();
  TextEditingController quantityController = new TextEditingController();
  TextEditingController rateController = new TextEditingController();
  TextEditingController generalRemarksController = new TextEditingController();
  TextEditingController paymentController = new TextEditingController();
  TextEditingController UnitController = new TextEditingController();
  TextEditingController paymentTypeController = new TextEditingController();
  TextEditingController InvNoController = new TextEditingController();

  GlobalKey<AutoCompleteTextFieldState<Customer>> key =
  new GlobalKey(); //only one autocomplte
  String selectedPerson = "";
  late CustomerAdd customer;
  late purModel _pur;
  late purchaseedit slse;
  int? purchaseItemId = null;
  int? purchaseLedgerId = null;
  int? purchasePaymentId = null;
  int? paymentType_Id = null;

  int? unitId=null;
  dynamic deliveryDate;
  bool GSTtyp=false;// for check the GST type is IGST or SGST
//   validation variables
  bool customerSelect = false;
  bool GodownSelect = false;
  bool itemSelect = false;
  bool paymentSelect = false;
  bool unitSelect = false;
  bool deliveryDateSelect = false;
  bool rateSelect = false;
  bool quantitySelect = false;
  bool paymentTypeSelect = false;
  int slnum=0;

  static List<purchaseedit> purchaseedt = [];
  static List<purModel> purchase = [];
  static List<CustomerAdd> customerItemAdd = [];
  static List<Customer> users = [];
  bool loading = true;
  final letters = 'abcdefghijklmnopqrstuvwxyz'.split('');

  var dataForTicket;
  var footerCaptions;
  bool checkboxval = false;
  // PrinterNetworkManager _printerManager = PrinterNetworkManager();
  var Companydata;
  var retunid;

  var  paymentType=[{"id":0,"type":"Cash"},{"id":1,"type":"Credit"}];


  FocusNode rateFocus = FocusNode();
  FocusNode qtyFocus = FocusNode();
  FocusNode generalFocus = FocusNode();
  bool ShowAllItem=false;
  bool Save_pending=false;

  late SharedPreferences pref;

  dynamic slsname;

  CUWidgets cw = CUWidgets();
var Tax_IdNull=null;
  ///------------multiple item select-------------------
  var SelectedRowData=[];
  var SelectedRowDataSAmple=[];
  TextEditingController QtyController = new TextEditingController();
  var Net_VAt=0.0;
  var Net_Amt_Befor_Tax=0.0;

  ///-------------------------------
  late bool TaxTypeGst;

//  get Token
  read() async {
    var v = pref.getString("userData");
    print("USER DATA: $v");
    var c = json.decode(v!);

    user = UserData.fromJson(c); // token gets this code user.user["token"]

    setState(() {
      branchId =int.parse(c["BranchId"]) ;
      print("user data......${branchId.toString()}..........");
      print(user.user["token"]);
      token = user.user["token"]; //  passes this user.user["token"]
      pref.setString("customerToken", user.user["token"]);
      branchName = user.branchName;
      password = user.password;
      userName = user.user["userName"];
      print("123.....");
      print(branchName);
      print(userName);
      userId=user.user["userId"];
      GetCompantPro(branchId);
    });
  }




//--------------Get Tx Type-----------------------
  GetTax() async {
    var jsonres = await cw.CUget_With_Parm(
        api: "MTaxes", Token: token);

    if (jsonres != false) {
      var res = jsonDecode(jsonres);
      //   print(" Taxes= $res");

      List<dynamic> data = res["taxList"];
      print(" Taxas are");
      print(data[0]["txId"]);
      Tax_IdNull=data[0]["txId"];
    }
  }



  GeneralSettings()async{


    final res =
    await http.get("${Env.baseUrl}generalSettings" as Uri, headers: {
      "Authorization": user.user["token"],
    });

    if(res.statusCode<210) {
      print(res);
      var GenSettingsData = json.decode(res.body);
      print(GenSettingsData[0]["applicationTaxTypeGst"]);
      setState(() {
        TaxTypeGst=GenSettingsData[0]["applicationTaxTypeGst"];

        print("TaxType");
        print(TaxTypeGst);

      });
    }
  }



  // get customer selectapi
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
        userArray = data["lst"];
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

  //get customer ledger balance
  getCustomerLedgerBalance(int accountId) async {
    try {
      final response = await http.get("${Env.baseUrl}getsettings" as Uri,
          headers: {"accept": "application/json"});
      print(response.statusCode);

      if (response.statusCode == 200) {
        print('...................');

        // print(response.body);

        List<dynamic> list = json.decode(response.body);
        print(list[0]["workingDate"] +
            "....................." +
            list[0]["workingTime"]);
        setState(() {
          serverDate = list[0]["workingDate"];
        });
        var formatter =
        new DateFormat('MM-dd-yyyy'); // this dd-MM-yyyy format i want

        String formattedDate = formatter
            .format(DateTime.parse(list[0]["workingDate"].substring(0, 10)));
        print(formattedDate);

        getLedger(accountId, formattedDate);
      } else {
        print("Error getting users");
      }
    } catch (e) {
      print("Error getting users" +e.toString());
    }
    print("customer Id is");
    print(accountId);
  }

  getLedger(dynamic acId, dynamic date) async {
    print(acId);
    print("the given date is");
    print(date);
    var url = "${Env.baseUrl}TaccLedgers/$acId/$date";
    print("url:" + url);
    try {
      final response = await http.get(url as Uri, headers: {
        "Authorization": user.user["token"],
      });
//      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.body);
        var e = json.decode(response.body);
        print(e["openingAmount"]);
        setState(() {
          if (e["openingAmount"] > 0.0) {
            openingAmountBalance = e["openingAmount"];
          } else {
            print("opening amount is zero");
          }
        });
      }
    } catch (e) {
      print("error" + e);
    }
  }


  // get itemselectapi
  getFinishedGoods() async {
    String url = "${Env.baseUrl}GtItemMasters/1/1";
    try {
      final res =
      await http.get(url as Uri, headers: {"Authorization": user.user["token"]});

      print("goods Condition");
      if(res.statusCode==200) {
        //print(res.body);
        print("json decoded");

        var tagsJson = json.decode(res.body);
        print(tagsJson);
        List<dynamic> t = json.decode(res.body);
        List<FinishedGoods> p = t
            .map((t) => FinishedGoods.fromJson(t))
            .toList();

        //print(p);
        goods = p;
      }
    } catch (e) {print("error on getFinishedGoods : $e");}
  }

  // get finished goods
//  getFinishedGoods() async {
//    String url = "${Env.baseUrl}MItemMasters/0/2";
//    try {
//      final res =
//          await http.get(url, headers: {"Authorization": user.user["token"]});
//
//      print("finshed goods");
//      print(res.body);
//
//      print("json decoded");
//
//      var tagsJson = json.decode(res.body);
//      print(tagsJson);
//      List<dynamic> t = json.decode(res.body);
//      List<FinishedGoods> g = t.map((t) => FinishedGoods.fromJson(t)).toList();
//
//      print(g);
//      goods = g;
//    } catch (e) {}
//  }

  // get payment Condition
  getPaymentCondition() async {
    String url = "${Env.baseUrl}Mconditions";
    try {
      final res =
      await http.get(url, headers: {"Authorization": user.user["token"]});

      print("payment Condition");
      if(res.statusCode==200) {
        print(res.body);
        print("json decoded");

        var tagsJson = json.decode(res.body);
        print(tagsJson);
        List<dynamic> t = json.decode(res.body);
        List<PaymentCondition> p =
        t.map((t) => PaymentCondition.fromJson(t)).toList();

        print("ppp $p");
        payment = p;
      }
    } catch (e) {print("error on getPaymentCondition: $e");}
  }



  GetUnit() async {
    String url = "${Env.baseUrl}GtUnits";
    try {
      final res =
      await http.get(url, headers: {"Authorization": user.user["token"]});
      print("Units");
      if(res.statusCode==200) {
        List <dynamic> tagsJson = json.decode(res.body)['gtunit'];
        List<UnitType> ut = tagsJson.map((tagsJson) =>
            UnitType.fromJson(tagsJson)).toList();
        print("uuuu : $ut");
        unit = ut;
      }
    } catch (e) {
      print("error on  unit= $e");
    }
  }



  GetGodown()async{
    String url = "${Env.baseUrl}Mgodowns";
    try {
      final res =
      await http.get(url as Uri, headers: {"Authorization": user.user["token"]});
      print("Units");
      if(res.statusCode==200) {
        List <dynamic> tagsJson = json.decode(res.body)['mGodown'];
        List<Godown> gd = tagsJson.map((tagsJson) =>
            Godown.fromJson(tagsJson)).toList();
        print("Godwon : $gd");
        Gdwn = gd;

        if(Gdwn.length==1){
          godownController.text =tagsJson[0]["gdnDescription"];
          itemGdwnId=tagsJson[0]["gdnId"];
        }
      }
    } catch (e) {
      print("error on  unit= $e");
    }

  }




//for test ..........
//   purchaseSave() async {
//
//     print("purchase length");
//
//     print(branchId);
//     print(userId);
//
//
//   }
  //.........................



  VlidationBeforeSave() async {

    int TblDatalength=0;
    if(btnname=="Save"){
      TblDatalength=purchase.length;
    }else{
      TblDatalength=purchaseedt.length;
    }

    if(TblDatalength < 1){

      showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Center(
                  child: Text(
                    "Please Add Item...",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
//              content: Text("user data:   " + user.user["token"]),
              ));
      return;
    }

    if(paymentType_Id!=null) {
      setState(() {
        paymentTypeSelect=false;
      });
      if (paymentType_Id.toString() == "1") {

        if (purchaseLedgerId == null || customerController.text == "") {
          setState(() {
            print("purchaseLedgerId $purchaseLedgerId");
            customerSelect = true;
            return;
          });
        } else {
          setState(()  {
            customerSelect = false;
            slsname=customerController.text;
          });
          purchaseSave();
        }
      } else {
        setState(()  {
          customerSelect = false;
          slsname=customerController.text;
        });
        print("juio");
        purchaseSave();

      }
    }
    else{

      setState(() {
        paymentTypeSelect=true;
      });
    }

  }


//  purchase save function ------------------------------------------------------

  purchaseSave() async {


    if(widget.passvalue==0 ||widget.passvalue==null ||(widget.itemrowdata).containsKey('ledgerName')) {

      //  var exDate=DateTime.now();
      setState(() {

        if(godownController.text=="")
        {
          print("Godown not selected");
          GodownSelect=true;
        }
        else
        { print("on"); GodownSelect=false;}


        // if (purchaseLedgerId == 0 || customerController.text == "") {
        //   setState(() {
        //     customerSelect = true;
        //     return;
        //   });
        //
        // } else
        // {
        //   customerSelect = false;
        // }


      });




      final url = "${Env.baseUrl}PurchaseHeaders";
      // print("purchase length");
      // print(purchase.length);
      // print(purchase);
      // print("list length");
      // print(customerItemAdd.length);
      delivery = "";
      delivery = purchasedeliveryController.text.toString();
      var remarks = generalRemarksController.text.toString();
      // print("purchase ledger Id");
      // print(purchaseLedgerId);
      // print("purchase Item Id");
      // print(purchaseItemId);
      // print("purchase payment Id");
      // print(purchasePaymentId);
      // print("server date");
      // print(serverDate);
      // print("delivery date");
      // print(deliveryDate);
      // print("remarks");
      if(widget.itemrowdata !=null){ //add godown id for sals order converted data
        print("Datas from purchase order");
        for(int i=0;i<purchase.length;i++)
        {
          if(purchase[i].godownId==null ||purchase[i].godownId==0){
            print("gdnId is null");
            purchase[i].godownId=itemGdwnId;
          }
        }

      }


      // var param = json.encode(purchase);
      // print("itms are : $param");

      // print("purchases : $purchase");
      if ( deliveryDateSelect || paymentSelect
          || customerItemAdd.length <= 0 || purchase.length <= 0 ||godownController.text==""||customerController.text==""||paymentTypeController.text.toString()=="null") {
        showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(
                  title: Text(
                    "Please Check the fields",
                    style: TextStyle(color: Colors.red),
                  ),
//              content: Text("user data:   " + user.user["token"]),
                ));
        return;
      } else {

        // var  exDate =DateTime.parse(serverDate);
        // var param = json.encode(purchase);
        // print("Validation Complited itms are : $param");
        var reqsave = {
        "voucherDate":DateOnlyFormat.format(DateTime.now()),
        "adjust": null,
        "orderNo": null,
        "poHeaderId": null,
        "invNo":InvNoController.text,
        "invDate":DateOnlyFormat.format(DateTime.now()),
        "deliveryDate":DateOnlyFormat.format(DateTime.now()),
        "ledgerId":purchaseLedgerId,
        "ledger":null,
        "partyName":slsname,
        "address1": null,
        "address2": null,
        "gstNo":null,
        "phone": null,
        "vehicle": null,
        "type":true,
        "paymentType":paymentType_Id,
        "discount": null,
        "narration": null,
        "netAmount":grandTotal,
        "userId":userId,
        "branchId":branchId,
        "cancelflg": null,
        "cancelRemarks": null,
        "purchaseDetailed": [

        for(int i = 0; i < purchase.length; i++)
        {
        "itemId" : purchase[i].itemId,
        "godownId" : purchase[i].godownId,
        "batch" : purchase[i].batch,
        "expDate" : purchase[i].expDate,
        "customColumn1" : purchase[i].customColumn1,
        "customColumn2" : purchase[i].customColumn2,
        "notes" : purchase[i].notes,
        "qty" : purchase[i].qty,
        "rate" : purchase[i].rate,
        "mrp" : purchase[i].mrp,
        "salesRate" : purchase[i].salesRate,
        "purchaseRate" : purchase[i].purchaseRate,
        "discountAmt" : purchase[i].discountAmt,
        "cgstPer" : purchase[i].cgstPer,
        "sgstPer" : purchase[i].sgstPer,
        "igstPer" : purchase[i].igstPer,
        "cessPer" : purchase[i].cessPer,
        "cgStAmt" : purchase[i].cgStAmt,
        "sgstAmt" : purchase[i].sgstAmt,
        "igstAmt" : purchase[i].igstAmt,
        "gross" : purchase[i].gross,
        "Total_amt" : purchase[i].Total_amt,
        "barcode" : purchase[i].barcode,
        "unitId" : purchase[i].unitId,
        "cessAmt" : purchase[i].cessAmt,
        "taxId" : purchase[i].taxId??Tax_IdNull,
        "taxInclusive" : purchase[i].taxInclusive,
        "taxAmount" : purchase[i].taxAmount,
        "amountBeforeTax" : purchase[i].amountBeforeTax,
        "amountIncludingTax" : purchase[i].amountIncludingTax,
        "netTotal" : purchase[i].amountIncludingTax,
        "godown": null,
        "item": null,
        "tax": null,
        "unit": null,
        "itemSlNo" : i
         }],
          "purchaseExpense": [],
          "stockUpdate": true
        };
         print("req $reqsave");
        // print( reqsave.runtimeType);


        var params = json.encode(reqsave);
        print(params);

        setState(() {
          Save_pending=true;
        });


        var res = await http.post(url,
            headers: {
              'accept': 'application/json',
              'content-type': 'application/json',
              'Authorization': user.user["token"],
              'deviceId': user.deviceId
            },
            body: params);

        print("purchaseSave : " + res.statusCode.toString());
        if (res.statusCode == 200 ||res.statusCode == 201) {

          print("401 : " + res.body.toString());
          try {
            String ms = "Out Of Stock";
            var c = json.decode(res.body);
            // var msg = c['outOfStockList']["data"].toString();
            // print("return" + msg);
            // print(msg.length);
            if (json.decode(res.body).containsKey('outOfStockList'))
              // if (msg.length >0)
                {
              print("exist");
              // ms = msg;
              showDialog(
                  context: context,
                  builder: (context) =>
                      AlertDialog(
                        title: Text(ms),
                      ));
              setState(() {
                Save_pending=false;
              });
            } else {

              retunid = await jsonDecode(res.body);
              // GetdataPrint(retunid['id']);
              setState((){
                Resetfunction();
                customerItemAdd.clear();
                purchase.clear();
                customerController.text = "";
                purchasedeliveryController.text = "";
                generalRemarksController.text = "";
                paymentController.text = "";

                purchaseLedgerId = null;
                purchaseItemId = null;
                purchasePaymentId = null;
                grandTotal = 0;
              });

              showDialog(
                  context: context,
                  builder: (context) =>
                      AlertDialog(
                        title: Text("Saved"),
                      ));
              rateSelect = false;
              quantitySelect = false;
              Timer(Duration(microseconds: 10,), () {
                print("Yeah, this line is printed after 2 seconds");

                // GetdataPrint(retunid['id']);
                // var  _url ='http://gterpdemo.qizo.in/#/GtMobliepurchasePrint?Sid=${retunid['id']}&uBr=$branchId&uNm=$userName&uP=$password';
                // UrlLaunch(_url);
                //  PdfPrint(retunid['id']);
                // Navigator.pop(context);
              });
            }
          }
          catch (e) {
            print("error in update $e");
          }
        }
      }





      //update part----------------------------------------editsave editpart-----------------------------------------
    }

    else{

      print("on else part");
      int Edi_id =widget.passvalue;
      final Edit_url = "${Env.baseUrl}PurchaseHeaders/$Edi_id";
      print("id=   $Edi_id");
      //print(purchaseedt.length);
      // print("purchaseedt");
      // print(purchaseedt);
      //print("list length");
      //print(customerItemAdd.length);
      delivery = "";
      delivery = purchasedeliveryController.text.toString();
      var remarks = generalRemarksController.text.toString();

      // print("purchaseEditDatas");
      // print(purchaseEditDatas);
      // print(purchaseEditDatas["listHeader"][0]["deliveryDate"]);
      //print("purchase Item Id");
      //print(purchaseItemId);
      //print("purchase payment Id");
      //print(purchasePaymentId);
      //print("server date");
      //print(serverDate);
      //print("delivery date");
      //print(deliveryDate);
      // print("remarks");
      // print(purchaseEditDatas);
      // var param = json.encode(purchaseedt);
      // print("aaaapurchase : $param");

      var req = {
        "id":Edi_id,
        "voucherNo":Vouchnum,
        "address1":purchaseEditDatas["listHeader"][0]["address1"],
        "address2":purchaseEditDatas["listHeader"][0]["address2"],
        "adjust":purchaseEditDatas["listHeader"][0]["adjust"],
        "branchId":branchId,
        "cancelRemarks":purchaseEditDatas["listHeader"][0]["cancelRemarks"],
        "deliveryDate":DateOnlyFormat.format(DateTime.now()),
        "discount":purchaseEditDatas["listHeader"][0]["discount"],
        "gstNo":purchaseEditDatas["listHeader"][0]["gstNo"],
        "invDate":DateOnlyFormat.format(DateTime.now()),
        "invNo":purchaseEditDatas["listHeader"][0]["invNo"],
        //"ledgerId":purchaseEditDatas["listHeader"][0]["ledgerId"].toString(),
        "narration":purchaseEditDatas["listHeader"][0]["narration"],
        "netAmount":grandTotal,
        "orderNo":purchaseEditDatas["listHeader"][0]["orderNo"],
        "partyName":slsname,
        "paymentType":paymentType_Id,
        "phone":purchaseEditDatas["listHeader"][0]["phone"],
        "poHeaderId":purchaseEditDatas["listHeader"][0]["poHeaderId"],
        "stockUpdate":purchaseEditDatas["listHeader"][0]["stockUpdate"],
        "type":purchaseEditDatas["listHeader"][0]["type"],
        "userId":userId,
        "vehicle":purchaseEditDatas["listHeader"][0]["vehicle"],
        "voucherDate":DateOnlyFormat.format(DateTime.now()),
        "purchaseDetailed": [

          for(int i = 0; i < purchaseedt.length; i++){
            "purchaseHeaderId":purchaseedt[i].purchaseHeaderId,
            "itemId"  : purchaseedt[i].itemId,
            "itmCode"  : purchaseedt[i].itmCode,
            "itmName"  : purchaseedt[i].itmName,
            "barcode"  : purchaseedt[i].barcode,
            "batch"  : purchaseedt[i].batch,
            "expDate"  : purchaseedt[i].expDate,
            "customColumn1"  : purchaseedt[i].customColumn1,
            "customColumn2"  : purchaseedt[i].customColumn2,
            "qty"  : purchaseedt[i].qty,
            "rate"  : purchaseedt[i].rate,
            "mrp"  : purchaseedt[i].mrp,
            "discountAmt"  : purchaseedt[i].discountAmt,
            "notes"  : purchaseedt[i].notes,
            "cgstPer"  : purchaseedt[i].cgstPer,
            "sgstPer"  : purchaseedt[i].sgstPer,
            "igstPer"  : purchaseedt[i].igstPer,
            "cessPer"  : purchaseedt[i].cessPer,
            "cgStAmt"  : purchaseedt[i].cgStAmt,
            "sgstAmt"  : purchaseedt[i].sgstAmt,
            "igstAmt"  : purchaseedt[i].igstAmt,
            "cessAmt"  : purchaseedt[i].cessAmt,
            "taxId"  : purchaseedt[i].taxId??Tax_IdNull,
            "txPercentage"  : purchaseedt[i].txPercentage,
            "taxInclusive"  : purchaseedt[i].taxInclusive,
            "amountBeforeTax"  : purchaseedt[i].amountBeforeTax,
            "amountIncludingTax"  : purchaseedt[i].amountIncludingTax,
            "netTotal"  : purchaseedt[i].amountIncludingTax,
            "taxAmount"  : purchaseedt[i].taxAmount,
            "unitId"  : purchaseedt[i].unitId,
            "nosInUnit"  : purchaseedt[i].nosInUnit,
            "godownId"  : purchaseedt[i].godownId,
            "gdnDescription"  : purchaseedt[i].gdnDescription,
            "purchaseRate"  :  purchaseedt[i].Total_amt,
            "salesRate"  : purchaseedt[i].salesRate,
            "itemSlNo"  : 1,
            "gtStockId"  : purchaseedt[i].gtStockId,
            "Total_amt"  : purchaseedt[i].Total_amt,
            "gross" : purchaseedt[i].Total_amt
          }
        ],
      };


      print("purchaseedt");
      print(json.encode(req["purchaseDetailed"]));

      var params = json.encode(req);
      print("final data");
      debugPrint(params);




      setState(() {
        if (purchaseLedgerId == null || customerController.text == "") {
          customerSelect = true;
        } else {
          customerSelect = false;
        }
        if (delivery != "") {
          deliveryDateSelect = false;

          return;
        } else {
          deliveryDateSelect = true;
        }
      });
      setState(() {

      });
      if (customerSelect || deliveryDateSelect || paymentSelect
          || customerItemAdd.length <= 0 ||purchaseedt.length <=0) {


        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                "Please Check the fields",
                style: TextStyle(color: Colors.red),
              ),
//              content: Text("user data:   " + user.user["token"]),
            ));
      } else {
        var params = json.encode(req);
        print("final data");
        debugPrint(params);
        // return;
        var res = await http.put(Edit_url as Uri,
            headers: {
              'accept': 'application/json',
              'content-type': 'application/json',
              'Authorization': user.user["token"],
              'deviceId': user.deviceId
            },
            body: params);
        //  print("saveddd");
        print("purchaseHeaders of edit : "+res.statusCode.toString());
// testing------
        if (res.statusCode == 204) {

          showDialog(
              context: context,
              builder: (context) =>
                  AlertDialog(
                    title: Text("Purchase Updated"),
                  ));
          rateSelect = false;
          quantitySelect = false;


          setState(() {
            Resetfunction();
            customerItemAdd.clear();
            purchase.clear();
            purchaseedt.clear();
            customerController.text = "";
            purchasedeliveryController.text = "";
            generalRemarksController.text = "";
            paymentController.text = "";
            purchaseLedgerId=null;
            purchaseItemId =null;
            purchasePaymentId =null;
            grandTotal = 0;
            Resetfunction();
            var  _url ='http://gterpdemo.qizo.in/#/GtMobliepurchasePrint?Sid=${widget.passvalue}&uBr=$branchId&uNm=$userName&uP=$password';
            //UrlLaunch(_url);

          });
          Timer(Duration(seconds:1), () {
            print("this line is printed after 2 seconds");
            // Navigator.pop(context);
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => purchaseindex()));
            //   PdfPrint(widget.passvalue);
          });
        }
        //--------------------






        if (res.statusCode == 200 ||
            res.statusCode == 201 &&
                customerItemAdd.length > 0 &&
                purchaseedt.length > 0 &&
                purchaseLedgerId > 0 ) {
          // print("401 : " + res.body.toString());
          try {
            String ms = "Out Of Stock";
            var c = json.decode(res.body);
            // var msg = c['outOfStockList']["data"].toString();
            // print("return" + msg);
            // print(msg.length);
            if (json.decode(res.body).containsKey('outOfStockList'))
              // if (msg.length >0)
                {
              print("exist");
              // ms = msg;
              showDialog(
                  context: context,
                  builder: (context) =>
                      AlertDialog(
                        title: Text(ms),
                      ));
            } else {
              setState(() {
                customerItemAdd.clear();
                purchase.clear();
                purchaseedt.clear();
                customerController.text = "";
                purchasedeliveryController.text = "";
                generalRemarksController.text = "";
                paymentController.text = "";
                purchaseLedgerId =null;
                purchaseItemId =null;
                purchasePaymentId=null;
                grandTotal = 0;
                Resetfunction();
              });

              showDialog(
                  context: context,
                  builder: (context) =>
                      AlertDialog(
                        title: Text("Purchase Updated"),
                      ));
              rateSelect = false;
              quantitySelect = false;
              Timer(Duration(seconds: 2), () {
                print("Yeah, this line is printed after 2 seconds");

                Navigator.pop(context);
              });
            }
          }
          catch(e){print("error in update $e");}
        }
      }
    }
  }




  @override
  void initState() {
    if(widget.passname.toString()!= "null") {
      //   print("value rctptclln= " + widget.passvalue.toString());
      customerController.text = widget.passname;
      purchaseLedgerId = widget.passvalue;
      getCustomerLedgerBalance(purchaseLedgerId!);
      slsname=widget.passname;
      purchasedeliveryController.text=widget.itemrowdata['voucherDate'];
    }


    //  print("......");
    goodsController.text = "";
    SharedPreferences.getInstance().then((value) {
      pref = value;
      read();
      getCustomer();
      getFinishedGoods();
      getPaymentCondition();
      GetUnit();
      GetGodown();
      GetTax();
      GeneralSettings();
      purchasedeliveryController.text=DateFormat("dd-MM-yyyy").format(DateTime.now());
      //testing----------------------------------------------
      if(widget.itemrowdata ==null)//for  purchase create
          {
        print("itemrowdata...null");
        btnname="Save";
        getCustomerLedgerBalance(0);
        //printer function...
      }
      // else if((widget.itemrowdata).containsKey('ledgerName')) //from purchase order
      //     {
      //   // databindingSoh( widget.itemrowdata["id"]);
      //   // btnname="Save";
      //   // print("from  purchase Header //purchase oreder");
      //   // //printer function...
      // }
      else
      {
        print("itemrowdata...have it"+  widget.itemrowdata["id"].toString()); // from purchase list
        databinding( widget.itemrowdata["id"]);
        btnname="Update";
      }

      //-------------------------------------------
      footerdata();
      Priter_Initial_Part();
    });
//    getUsers();
    super.initState();
    customerController.addListener(customerLedgerIdListener);
    goodsController.addListener(itemIdListener);
    paymentController.addListener(paymentIdListener);
    UnitController.addListener(unitIdListener);
  }






  getItemIndex(dynamic item) {
    var index = customerItemAdd.indexOf(item);
    return index + 1;
  }

  customerLedgerIdListener() {
    setState(() {
      purchaseLedgerId ==null;
      openingAmountBalance = 0;
      print(customerController.text);
      print("item");
    });
  }

  itemIdListener() {
    setState(() {
      print("Item    .....................");
      //purchaseItemId = 0;
      print(goodsController.text);
    });
  }

  paymentIdListener() {
    print("payment");
    purchasePaymentId == null;

    print(paymentController.text);
  }

  unitIdListener() {
    print("Unit");
    unitId == null;
    print(UnitController.text);
  }

  validationQuantity() {
    if (quantityController.text == "") {
      quantitySelect = true;
      validationRate();
    } else {
      quantitySelect = false;
      validationRate();
    }
  }

  validationRate() {
    if (rateController.text == "" ||rateController.text == "0.0" ) {
      rateSelect = true;
      validationUnit();
    } else {
      rateSelect = false;
      validationUnit();
    }
  }

  validationUnit() {
    if ( unitId ==null) {
      unitSelect = true;

    } else {
      unitSelect = false;
    }
  }


// add customer item----------------------------------------------------

  addCustomerItem() {

    print("add...... ");
    print(customerItemAdd.length.toString());
    setState(() {
      if (purchaseItemId == null || goodsController.text == "") {
        itemSelect = true;
        validationQuantity();
//      validationRate();
      } else {
        itemSelect = false;
        validationQuantity();
//      validationRate();
      }
    });

    if (rateController.text == "" || unitId == null || rateController.text == "null"||
        quantityController.text == "" ||
        purchaseItemId == null ||rateController.text == "0.0") {
      print("check fields");
      print(purchaseItemId);
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("check fields"),
//              content: Text("user data:   " + user.user["token"]),
          ));
      return;
    }
    var amount = double.parse(quantityController.text) *
        double.parse(rateController.text);
    print(goodsController.text);
    dynamic itmName=goodsController.text;
    dynamic  aftertax=0;
    dynamic  befortax=0;
    var igst=0.00;

    setState(() {
      var rate= double.parse(rateController.text);
      // grandTotal = grandTotal + amount; // calc with out tax
      //  dynamic  aftertax=rate+((rate/100)*(itmtxper+cessper));

      // double cgst=double.parse(((rate/100)*CgstPer).toStringAsFixed(2));
      // double sgst=double.parse(((rate/100)*SgstPer).toStringAsFixed(2));
      dynamic Igst=double.parse(((rate/100)*Igstper).toStringAsFixed(2));

      print("amount  $amount");


      /// calc with tax
      //    var totligst=igst*double.parse(quantityController.text);
      //  var totlcgst=cgst*double.parse(quantityController.text);
      // var totlsgst=sgst*double.parse(quantityController.text);
      //    var taxOneItm =((rate/100)*(itmtxper+cessper));
      //  var  ToatalTax=taxOneItm*double.parse(quantityController.text);
      //    print("grandTotal before $grandTotal");
      //   grandTotal = grandTotal + ToatalTax + amount + totlcgst +totlsgst +totligst;
      //      aftertax=ToatalTax + amount + totlcgst +totlsgst +totligst;
      //    print("grandTotal after $grandTotal");
      ///--------test calc with tax----------------



      var taxOneItm;
      var taxAmtOfCgst;
      var taxAmtOfSgst;
      var  ToatalTax;


      if(TaxInOrExc==true){

        //var WithOutTaxamt=((itmtxper+100)/100);
        // print("gjgik");
        // print(WithOutTaxamt.toString());
        // taxOneItm=rate/WithOutTaxamt;
        // taxAmtOfCgst=(WithOutTaxamt/2);
        // taxAmtOfSgst=(WithOutTaxamt/2);
        // ToatalTax =taxOneItm*double.parse(quantityController.text);
        //befortax=taxOneItm*double.parse(quantityController.text);
       print("inclusive");
        var WithOutTaxamt=((itmtxper+100)/100);
        taxAmtOfCgst=(WithOutTaxamt/2);
        taxAmtOfSgst=(WithOutTaxamt/2);

        taxOneItm=(rate/100)*itmtxper;
        grandTotal = grandTotal + amount;
        aftertax= amount;
        befortax=amount-(taxOneItm*double.parse(quantityController.text));


      }
      else{
        print("Exclusive");
        taxOneItm =((rate/100)*(itmtxper+cessper));
        taxAmtOfCgst=(taxOneItm/2);
        taxAmtOfSgst=(taxOneItm/2);
        ToatalTax =taxOneItm*double.parse(quantityController.text);
        grandTotal = grandTotal + ToatalTax + amount;
        aftertax=ToatalTax + amount;
        befortax=amount;
      }


      if(GSTtyp==true){
        igst= Igst*double.parse(quantityController.text);
        taxAmtOfCgst=0;
        taxAmtOfSgst=0;
      }

      if(TaxTypeGst==false){

        igst=0;
        taxAmtOfCgst=0;
        taxAmtOfSgst=0;

      }

     Net_VAt=Net_VAt+(aftertax-befortax);
     Net_Amt_Befor_Tax=Net_Amt_Befor_Tax+befortax;
      // print("Final................");
      // print(taxOneItm.toString());
      // print("CGST = "+taxAmtOfCgst.toString());
      // print(aftertax.toString());
      // print("igst = "+igst.toString());
      print("Final................");
      print((customerItemAdd.length + 1).toString());
      print(itmName.toString());
      ++slnum;
      if(widget.passvalue==null|| widget.passvalue==0  ||(widget.itemrowdata).containsKey('ledgerName'))
      {
        print("on save part item add");

        _pur = purModel(
            itmName:itmName,
            Total_amt:grandTotal,
            amountBeforeTax:befortax,
            amountIncludingTax:aftertax,
            barcode:Brcode,
            batch:null,
            cessAmt:0,
            cessPer:0,
            cgStAmt:taxAmtOfCgst,
            cgstPer:SgstPer,
            customColumn1:null,
            customColumn2:null,
            discountAmt:0,
            expDate:Edate,
            godownId:itemGdwnId,
            gross:aftertax,
            igstAmt:igst,
            igstPer:Igstper,
            itemId:purchaseItemId,
            itemSlNo:customerItemAdd,
            mrp:aftertax,
            netTotal:aftertax,
            nosInUnit:nosunt,
            notes:null,
            purchaseRate:aftertax,
            qty:double.parse(quantityController.text),
            rate:double.parse(rateController.text),
            salesRate:double.parse(rateController.text),
            sgstAmt:taxAmtOfSgst,
            sgstPer:SgstPer,
            taxAmount:((double.parse(rateController.text))/100)*(itmtxper),
            taxId:TaxId,
            taxInclusive:false,
            unitId:unitId
        );

        purchase.add(_pur);
        print(".............");
        print(_pur.itemId);
        print(_pur.qty);
        print(_pur.rate);
        print(purchase);
        // var param = json.encode(purchase);
        // print("purchase : $param");
        print("............");



      }
      else
      {
        print("on edit part8888 ");

        print("add.656565656..... ");
        print(customerItemAdd.length.toString());
// var slnum=customerItemAdd.length++;
        var SLnum=0;
        print("add.000000000000000.... ");
        print(customerItemAdd.length.toString());
        slse = purchaseedit(
            purchaseHeaderId:widget.passvalue,
            itmName:itmName,
            Total_amt:grandTotal,
            amountBeforeTax:befortax,
            amountIncludingTax:aftertax,
            barcode:Brcode,
            batch:null,
            cessAmt:0,
            cessPer:0,
            cgStAmt:taxAmtOfCgst,
            cgstPer:SgstPer,
            customColumn1:null,
            customColumn2:null,
            discountAmt:0,
            expDate:Edate,
            godownId:itemGdwnId,
            gross:aftertax,
            igstAmt:igst,
            igstPer:Igstper,
            itemId:purchaseItemId,
            itemSlNo:SLnum,
            mrp:aftertax,
            netTotal:aftertax,
            nosInUnit:nosunt,
            notes:null,
            purchaseRate:aftertax,
            qty:double.parse(quantityController.text),
            rate:double.parse(rateController.text),
            salesRate:double.parse(rateController.text),
            sgstAmt:taxAmtOfSgst,
            sgstPer:SgstPer,
            taxAmount:((double.parse(rateController.text))/100)*(itmtxper),
            taxId:TaxId,
            taxInclusive:false,
            unitId:unitId
        );
        print("add.tertrtertr..... ");
        print(customerItemAdd.length.toString());
        purchaseedt.add(slse);
        print(".............");
        print(slse.itemId);
        print(slse.qty);
        print(slse.rate);
        print(slse);
        // var param = json.encode(slse);
        // print("slse : $param");
        print("............");
        print("add.568678768768..... ");
        print(customerItemAdd.length.toString());
        SLnum++;
      }
    });


    customer = CustomerAdd(
      id: purchaseItemId,
      slNo: customerItemAdd.length + 1,
      item: goodsController.text,
      quantity: double.parse(quantityController.text),
      rate: double.parse(rateController.text),
      txper:itmtxper,
      cess:cessper,
      NetAmt:aftertax,
      amount: amount,
      StkId:StkId,
      txAmt: (aftertax-befortax),
    );


    print("add.66666..... ");
    print(customerItemAdd.length.toString());
    print(customer.item);
    setState(() {
      customerItemAdd.add(customer);
      ItemsAdd_Widget_Visible=false;
    });
    print(customerItemAdd);
    goodsController.text = "";
    quantityController.text = "";
    rateController.text = "";
    UnitController.text="";
    unitId=null;
  }

  // remove customer items
  removeListElement(int id, int sl, double netamount,double taxAmt) {
    print("on delete");
    if(netamount==null){
      netamount=0.00;
    }
    print("sl num = $sl");

    ///----test calc
    setState(() {
      grandTotal=  (grandTotal-netamount);
      Net_VAt=Net_VAt-taxAmt;
      Net_Amt_Befor_Tax=Net_Amt_Befor_Tax-(netamount-taxAmt);
      print(netamount);
    });
    ///----test calc
    customerItemAdd.removeWhere((element) => element.slNo == sl && element.id==id );
    purchase.removeWhere((element) => element.itemSlNo == sl && element.itemId==id );
    purchaseedt.removeWhere((element) => element.itemSlNo == sl && element.itemId==id);

    // grandTotal = grandTotal - amount;
    setState(() {

      print("end deleted");
      print(grandTotal);
      print("purchase.length= "+purchase.length.toString());
      print("purchaseedt.length= "+purchaseedt.length.toString());
      if(purchase.length==0 && purchaseedt.length==0){
        grandTotal=0;
      }
      // slnum=slnum-1;
    });


  }


  Future<bool> _onBackPressed() {
    // Navigator.pop(context,purchaseLedgerId);
    Navigator.pop(context);
    customerItemAdd=[];
    Resetfunction();

    // You're handling the back button press, so you don't want the system to do anything further.
    return Future.value(false);
  }



  //testing --------------------



  //getbatch no----------itembatchcheck------------------
  getbatch(id)async
  {
    String url = "${Env.baseUrl}GtStocks/$id/1/";
    try {
      final res =
      await http.get(url as Uri, headers: {"Authorization": user.user["token"]});
      print("batch data GtStocks/$id/1/");
      // print(res);
      var tagsJson = json.decode(res.body);

      batchdata = tagsJson['stockBatch'] as List;
      batchdata.forEach(print);
      print("batchdata length");
      print(batchdata.length);
      print(batchdata);



      if (batchdata.length >1) {
        boxvisible =true;

        showDialog(
            context: context,
            builder: (context) =>
                Visibility(
                  visible:boxvisible,
                  child: AlertDialog(
                    actions: [
                      Container(
                        height: 300,
                        width: 350,
                        child: Row(
//            verticalDirection: VerticalDirection.down,
//            crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            // SizedBox(
                            //   width: 60,
                            // ),

                            Expanded(
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
                                          label: Text('Name'),
                                        ),
                                        DataColumn(
                                          label: Text('Rate'),
                                        ),
                                        DataColumn(
                                          label: Text('Expiry Date'),
                                        ),
                                        DataColumn(
                                          label: Text('Batch No'),
                                        ),
                                        // DataColumn(
                                        //   label: Text('Amount'),
                                        // ),
                                        // DataColumn(
                                        //   label: Text('Add'),
                                        // ),
                                      ],
                                      rows: batchdata
                                          .map(
                                            (itemRow) => DataRow(
                                          onSelectChanged: (a){
                                            print(itemRow['id']);
                                            // id: 21
                                            multibatchitembinding(itemRow);

                                            Navigator.pop(context);
                                          },
                                          cells: [
                                            DataCell(
                                              Container(width: 150,
                                                child: Text(
                                                    '${itemRow['itmName'].toString()}(${itemRow['gdnDescription'].toString()})'),
                                              ),
                                              showEditIcon: false,
                                              placeholder: false,
                                            ),
                                            DataCell(
                                              Text(
                                                  '${itemRow['srate'].toString()=="null"?"-":itemRow['srate'].toString()}'),
                                              showEditIcon: false,
                                              placeholder: false,
                                            ),
                                            DataCell(
                                              GestureDetector(
                                                onTap: () {},
                                                child:
                                                //Text( '${DateFormat("dd-MM-yyyy").format(DateTime.parse(itemRow['expiryDate']))}'),
                                                Text((itemRow['expiryDate'])==null?"-:-:-":(DateFormat("dd-MM-yyyy").format(DateTime.parse(itemRow['expiryDate'])))),
                                              ),
                                              showEditIcon: false,
                                              placeholder: false,
                                            ),
                                            DataCell(
                                              GestureDetector(
                                                onTap: () {},
                                                child: Text('${itemRow['batchNo']??"-"}'),

                                              ),
                                              showEditIcon: false,
                                              placeholder: false,
                                            ),
                                            // DataCell(
                                            //   GestureDetector(
                                            //       onTap: () {
                                            //
                                            //       },
                                            //       child: Icon(Icons.add_circle_outline_sharp)),
                                            // ),
                                          ],
                                        ),
                                      )
                                          .toList(),
                                    ),
                                  ),
                                )),
                            SizedBox(
                              width: 3,
                            )
                          ],
                        ),
                      )
                    ],
//              content: Text("user data:   " + user.user["token"]),
                  ),
                ));
      }

      else if(batchdata.length ==0){

        print("with one data") ;
        print(batchdata[0]["itmName"]) ;

        dynamic j=[];
        j={
          "id":batchdata[0]["id"],
          "itemId":id,
          "expiryDate":batchdata[0]["expiryDate"],
          "srate":batchdata[0]["srate"],
          "batchNo":batchdata[0]["batchNo"],
          "nos":batchdata[0]["nos"],
          "barcode":batchdata[0]["barcode"],
          "godownId":batchdata[0]["godownId"]
        };
        print(j);
        multibatchitembinding(j);



        // showDialog(
        //   barrierDismissible: false,
        //   context: context,
        //   builder: (context) =>
        //       AlertDialog(
        //         actions: [
        //           Container(
        //               height: 60,
        //               width: 350,
        //               child:  Center(
        //                   child: Text("Stock Not Available...!",style:TextStyle(color: Colors.redAccent,fontSize: 20),)
        //               )),
        //
        //         ],
        //       ),
        // );
        // Timer(Duration(seconds: 1), () {
        //   Navigator.pop(context);
        // });
      }

      else{
        print("with one data") ;
        print(batchdata[0]["itmName"]) ;

        dynamic j=[];
        j={
          "id":batchdata[0]["id"],
          "itemId":id,
          "expiryDate":batchdata[0]["expiryDate"],
          "srate":batchdata[0]["srate"],
          "batchNo":batchdata[0]["batchNo"],
          "nos":batchdata[0]["nos"],
          "barcode":batchdata[0]["barcode"],
          "godownId":batchdata[0]["godownId"]
        };
        print(j);
        multibatchitembinding(j);
      }


    } catch (e) {
      print("error on  batch = $e");
    }

  }




//multiple batch item binding-----
  multibatchitembinding(rowdata)async {
    print(rowdata);
    print("888888 data bind");
    Edate=rowdata['expiryDate'];
    Srate=rowdata['srate']??0.00;
    batchnum=rowdata['batchNo'];
    nosunt=rowdata['nos'];
    Brcode=rowdata['barcode'];
    StkId=rowdata['id'];
    rateController.text=Srate.toString();
    int id=rowdata['itemId'];
    purchaseItemId =id;
    itemGdwnId=rowdata['godownId'];
    print(id.toString());
    String url = "${Env.baseUrl}GtItemMasters/$purchaseItemId";
    try {
      final res =
      await http.get(url as Uri, headers: {"Authorization": user.user["token"]});
      print("batch data");
      print(res.statusCode);
      var tagsJson = jsonDecode(res.body)["result"][0];


      // print("555555");
      print(tagsJson);
      print(tagsJson['description']);

      //goodsController.text =name;

      print("close.... $purchaseItemId");



      // purchaseItemId = tagsJson["id"];
      goodsController.text = tagsJson["itmName"];


      // print("nnnnn $purchaseItemId");
      // print("nnnnn "+goodsController.text);

if(unitId==null){
  (tagsJson["itmUnitId"] == null ||tagsJson["itmUnitId"] == "null") ? unitId=null: unitId =tagsJson["itmUnitId"];

}
      (tagsJson["txPercentage"] == null ||tagsJson["txPercentage"] == "null") ? itmtxper=0.0:itmtxper =tagsJson["txPercentage"];
      (tagsJson["atPercentage"] == null ||tagsJson["atPercentage"] == "null") ? cessper=0.0:cessper =tagsJson["atPercentage"];
      (tagsJson["description"] == null ||tagsJson["description"] == "null") ?  UnitController.text="": UnitController.text =tagsJson["description"];
      (tagsJson["itmHsn"] == null ||tagsJson["itmHsn"]  == "null") ?  Hsncode ="": Hsncode =tagsJson["itmHsn"];
      (tagsJson["txCgstPercentage"] == null ||tagsJson["txCgstPercentage"] == "null") ?  CgstPer =0: CgstPer =tagsJson["txCgstPercentage"];
      (tagsJson["txSgstPercentage"] == null ||tagsJson["txSgstPercentage"] == "null") ?  SgstPer =0: SgstPer =tagsJson["txSgstPercentage"];
      (tagsJson["txIgstpercentage"] == null ||tagsJson["txIgstpercentage"] == "null") ?  Igstper =0: Igstper =tagsJson["txIgstpercentage"];
      (tagsJson["itmTaxId"] == null ||tagsJson["itmTaxId"]  == "null") ?  TaxId=null: TaxId =tagsJson["itmTaxId"];
     // TaxInOrExc=tagsJson["itmTaxInclusive"];
      TaxInOrExc=tagsJson["itmPurchaseTaxInclusive"];


      // (tagsJson["itmpurchaseRate"] == null ||tagsJson["itmpurchaseRate"]  == "null") ? rateController.text="": Srate =tagsJson["itmpurchaseRate"];
      //rateController.text=Srate.toString();
      //Srate=rowdata['itmpurchaseRate'];
      print("11111111$SgstPer");
      print(tagsJson["description"]);
      print  ("11111$Hsncode");
    }
    catch (e) {
      print("error on  batch = $e");
    }
  }

  //----------------------------


  Resetfunction(){
    GodownSelect=false;
    ItemsAdd_Widget_Visible=false;
    customerSelect = false;
    deliveryDateSelect = false;
    rateSelect = false;
    quantitySelect = false;
    itemSelect = false;
    paymentSelect = false;
    customerItemAdd.clear();
    purchase.clear();
    customerController.text = "";
    purchasedeliveryController.text = "";
    generalRemarksController.text = "";
    paymentController.text = "";
    grandTotal = 0;
    purchasePaymentId = null;
    purchaseItemId = null;
    purchaseLedgerId = null;
    UnitController.text="";
    unitId=null;
    unitSelect=false;
    quantityController.text="";
    goodsController.text="";
    slnum=0;
    purchaseedt.clear();
    rateController.text="";
    paymentTypeController.text="";
    paymentType_Id=null;
    paymentTypeSelect=false;
    godownController.text="";
    itemGdwnId=null;
    btnname="Save";
    Net_Amt_Befor_Tax=0.0;
    Net_VAt=0.0;
    InvNoController.text="";
    GetGodown();
    purchasedeliveryController.text=DateFormat("dd-MM-yyyy").format(DateTime.now());
    Save_pending=false;
  }



//-------------------------------------------------------
  itemReEditing(items)async{

    print(items.StkId);
    var itmStkid=items.StkId;
    try {
      final res =
      await http.get((Env.baseUrl+"GtStocks/$itmStkid") as Uri, headers: {"Authorization": user.user["token"]});


      var tagsJson = json.decode(res.body);
      print(tagsJson.toString());
      print(tagsJson["expiryDate"].toString());
      dynamic itemdata=[];
      itemdata={
        "id":itmStkid,
        "itemId":items.id,
        "expiryDate":tagsJson["expiryDate"],
        "srate":tagsJson["srate"],
        "batchNo":tagsJson["batchNo"],
        "nos":null,
        "barcode":tagsJson["barcode"],
        "godownId":tagsJson["godownId"]
      };
      print(itemdata);
      multibatchitembinding(itemdata);
      // removeListElement(items.id,
      //     items.slNo, items.NetAmt);

    }catch(e)
    {print("error on itemReEditing $e");}
    // GtStocks/$id/1/"
    // getbatch(items.StkId);
    quantityController.text=items.quantity.toString();
    // rateController.text=items.rate.toString();

    // id: purchaseItemId,
    // slNo: customerItemAdd.length + 1,
    // item: goodsController.text,
    // quantity: double.parse(quantityController.text),
    // rate: double.parse(rateController.text),
    // txper:itmtxper,
    // cess



  }
//-------------------------------------------------------

//--------------------------Barcode Reader----------------------

  void qr_Barcode_Readfunction() async {
    try {
      print("in qr_Barcode_Readfunction ");
      var result = await BarcodeScanner.scan();
      // print("type");
      // print(result.type);
      // print("rawContent");
      // print(result.rawContent);
      // print("format");
      // print(result.format);
      // print("formatNote");
      // print(result.formatNote);

      print(result.formatNote);
      final jsonres =
      await http.get((Env.baseUrl+"GtitemMasters/1/${result.rawContent}/barcode") as Uri, headers: {"Authorization": user.user["token"]});
      print("batch data");
      print(jsonres.statusCode);
      var tagsJson = jsonDecode(jsonres.body);
      print(tagsJson);
      print(tagsJson["result"][0]["id"]);

      setState(() {
        quantityController.text="1";
        goodsController.text=tagsJson["result"][0]["itmName"];
        FocusScope.of(context).requestFocus(rateFocus);
        dynamic j=[];
        j={
          "id":tagsJson["result"][0]["itmStkTypeId"],
          "itemId":tagsJson["result"][0]["id"],
          "expiryDate":null,
          "srate":tagsJson["result"][0]["itmpurchaseRate"],
          "batchNo":null,
          "nos":null,
          "barcode":tagsJson["result"][0]["itmBarCode"],
          "godownId":itemGdwnId
        };
        print(j);
        multibatchitembinding(j);
      });
    }
    catch(e) {  print("Error on qr_Barcode_Readfunction $e");}

  }


///--------------------Multiple Item-- popup----------------------------------

  ShowAllItemPopup(Itemdata){
    showDialog(
        context: context,
        builder: (context) =>   AlertDialog(
          shape:RoundedRectangleBorder(
            side: BorderSide(color:  Colors.blueAccent, width: 1),
            borderRadius: BorderRadius.circular(20),
          ),

          //  content: Itm_Slct_All_Popup(data: Itemdata,),
          actions: [
            // listreturn= Itm_Slct_All_Popup(data: Itemdata,)
            Column(
              children: [
                Container(color: Colors.white,
                  height: MediaQuery.of(context).size.width/1.2,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columnSpacing: 14,
                        onSelectAll: (b) { },
                        sortAscending: true,
                        columns: <DataColumn>[
                          DataColumn(
                            label: Text('Name'),
                          ),
                          // DataColumn(
                          //   label: Text('Qty'),
                          // ),
                          DataColumn(
                            label: Text('Rate'),
                          ),
                        ],
                        rows:goods
                            .map(
                              (itemRow)=>

                              DataRow(
                                selected:SelectedRowData.contains(itemRow),
                                color:MaterialStateColor.resolveWith(
                                      (states) {

                                    if (SelectedRowData.contains(itemRow)) {
                                      return Colors.teal;
                                    } else {
                                      return Colors.white;
                                    }
                                    setState(() {  });
                                  },

                                ),

                                onSelectChanged: (bool? selected) {
                                  // print(itemRow.index);
                                  SelectedRows(selected!, itemRow);
                                },

                                cells: [
                                  DataCell(
                                    Container(
                                      width: 150,
                                      child: Text('${itemRow.itmName.toString()}'),
                                    ),
                                    showEditIcon: false,
                                    placeholder: false,
                                  ),
                                  DataCell(
                                    Text('${itemRow.itmPurchaseRate.toString()=="null"?
                                    0.0:itemRow.itmPurchaseRate.toString()
                                    }'),
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
                Container(height: 50,width: MediaQuery.of(context).size.width,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left:2,right: 2),
                          child: ElevatedButton(
                              style:ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.green.shade700), ) ,
                              onPressed: (){
                                if(SelectedRowData.length<1){

                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) =>   AlertDialog(
                                        shape:RoundedRectangleBorder(
                                          side: BorderSide(color:  Colors.red, width: 2),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        title: Center(child: Text("Add Item...!")),));


                                  Timer(Duration(milliseconds:1200),() {
                                    Navigator.of(context, rootNavigator: true).pop();
                                  });

                                }else{
                                  Navigator.pop(context, SelectedRowData) ;
                                  MultipleItemAddtoTable();
                                }
                              },

                              child: Text("Add to Cart")),
                        ),
                      ),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left:2,right: 2),
                          child: ElevatedButton(
                              style:ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo), ) ,
                              onPressed: (){
                                Navigator.of(context, rootNavigator: true).pop();
                              },
                              child: Text("Cancel")),
                        ),
                      ),

                      Container(height: 30,width: 30,
                          decoration: BoxDecoration(color: Colors.teal,
                              borderRadius: BorderRadius.circular(20)),
                          child:Center(child: Text(SelectedRowData.length.toString())))
                    ],
                  ),)
              ],
            )
          ],
        ));

  }



  SelectedRows(bool stsus,FinishedGoods data)async{
    print(stsus);
    if (stsus) {



      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return  AlertDialog(
                shape:RoundedRectangleBorder(
                  side: BorderSide(color:  Colors.blueAccent, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Center(child: Text(data.itmName)),
                content:   Container(
                  width: 100,
                  height: 30,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          autofocus: true,
                          controller:QtyController,
                          onFieldSubmitted: (val)  {
                            print('onSubmited $val');
                          },
                          // focusNode: generalFocus,
                          enabled: true,
                          validator: (v) {
                            if (v!.isEmpty) return "Required";
                            return null;
                          },
//
//                  focusNode: field1FocusNode,
                          cursorColor: Colors.black,

                          scrollPadding:
                          EdgeInsets.fromLTRB(0, 20, 20, 0),
                          keyboardType: TextInputType.text,

                          decoration: InputDecoration(
//                    suffixIcon: Icon(
//                      Icons.calendar_today,
//                      color: Colors.blue,
//                      size: 24,
//                    ),
                            isDense: true,
                            contentPadding: EdgeInsets.all(8),
                            // border: OutlineInputBorder(
                            //     borderRadius: BorderRadius.circular(10)),
                            // curve brackets object
                            hintText: "Quantity",
                            hintStyle: TextStyle(
                                color: Colors.black, fontSize: 15),
                          ),
                        ),
                      ),
                      SizedBox(width: 5,),
                      ElevatedButton(onPressed: (){
                        setState(() {
                          Navigator.of(context, rootNavigator: true).pop();
                          ItemPushToArray(data,QtyController.text);
                        });
                      }, child: Text("OK"))
                    ],
                  ),
                ),


              );
            },
          );
        },
      );





    }

    else {





      setState(() {
        Navigator.of(context).pop();
        SelectedRowData.remove(data);
        SelectedRowDataSAmple.removeWhere((element) => element["id"] == data.id);

        ShowAllItemPopup(goods);
      });



    }











  }


  ItemPushToArray(FinishedGoods data,qty){


    var json={
      "id" :data.id,
      "itmTaxInclusive":data.itmTaxInclusive,
      "itmName" :data.itmName,
      "qty":qty,
      "itmImage" :data.itmImage,
      "itmUserId" :data.itmUserId,
      "itmBranchId":data.itmBranchId,
      "txPercentage" :data.txPercentage,
      "atPercentage" :data.atPercentage,
      "description" :data.description,
      "itmHsn" :data.itmHsn,
      "unitId":data.unitId,
      "itmUnitId":data.itmUnitId,
      "txCgstPercentage":data.txCgstPercentage,
      "txSgstPercentage":data.txSgstPercentage,
      "txIgstpercentage" :data.txIgstpercentage,
      "itmTaxId" :data.itmTaxId,
      "itmSalesRate" :data.itmSalesRate,
      "itmStkTypeId":data.itmStkTypeId,
      "itmpurchaseRate":data.itmPurchaseRate
    };


    SelectedRowData.add(data);
    SelectedRowDataSAmple.add(json);
    setState(() {
      QtyController.text="";
    });
  }



  MultipleItemAddtoTable (){

    print(SelectedRowData.length.toString());


    print("SelectedRowDataSAmple");
    print(SelectedRowDataSAmple.length.toString());
    print(json.encode(SelectedRowDataSAmple).toString());


    var amount;
    dynamic itmName=goodsController.text;
    dynamic  aftertax=0;
    dynamic  befortax=0;
    var igst=0.00;
    var rate;
    //  dynamic Igst=double.parse(((rate/100)*Igstper).toStringAsFixed(2))
    var taxOneItm;
    var taxAmtOfCgst;
    var taxAmtOfSgst;
    var  ToatalTax;





    for(int i=0;i<SelectedRowDataSAmple.length;i++){
     // TaxInOrExc=SelectedRowDataSAmple[i]["itmTaxInclusive"]??false;
      TaxInOrExc=SelectedRowDataSAmple[i]["itmPurchaseTaxInclusive"]??false;
      itmtxper=SelectedRowDataSAmple[i]["txPercentage"]??0.0;
      rate= SelectedRowDataSAmple[i]["itmpurchaseRate"]??0.0;
      var Qty= double.parse(SelectedRowDataSAmple[i]["qty"]);
      amount=rate*Qty;
      if(TaxInOrExc==true){

        // var WithOutTaxamt=((SelectedRowDataSAmple[i]["txPercentage"]+100)/100);
        // taxOneItm=rate/WithOutTaxamt;
        // taxAmtOfCgst=(WithOutTaxamt/2);
        // taxAmtOfSgst=(WithOutTaxamt/2);
        // aftertax= amount;
        // befortax=taxOneItm*Qty;
        // grandTotal = grandTotal + aftertax;

        var WithOutTaxamt=((itmtxper+100)/100);
        taxAmtOfCgst=(WithOutTaxamt/2);
        taxAmtOfSgst=(WithOutTaxamt/2);

        taxOneItm=(rate/100)*itmtxper;
        grandTotal = grandTotal + amount;
        aftertax= amount;
        befortax=amount-(taxOneItm*Qty);

      }
      else{

        taxOneItm =((rate/100)*(SelectedRowDataSAmple[i]["txPercentage"]??0));
        taxAmtOfCgst=(taxOneItm/2);
        taxAmtOfSgst=(taxOneItm/2);
        ToatalTax =taxOneItm*Qty;
        grandTotal = grandTotal + ToatalTax + amount;
        aftertax=ToatalTax + amount;
        befortax=amount;
      }

      Net_VAt=Net_VAt+(aftertax-befortax);
      Net_Amt_Befor_Tax=Net_Amt_Befor_Tax+befortax;
      // if(GSTtyp==true){
      //   igst= Igst*double.parse(quantityController.text);
      //   taxAmtOfCgst=0;
      //   taxAmtOfSgst=0;
      // }
      if(TaxTypeGst==false){

        igst=0;
        taxAmtOfCgst=0;
        taxAmtOfSgst=0;

      }

      if(widget.passvalue==null|| widget.passvalue==0  ||(widget.itemrowdata).containsKey('ledgerName')) {
        print("on save part item add");
        _pur = purModel(
          itmName: SelectedRowDataSAmple[i]["itmName"],
          Total_amt: grandTotal,
          amountBeforeTax: befortax,
          amountIncludingTax: aftertax,
          barcode: Brcode,
          batch: null,
          cessAmt: 0,
          cessPer: 0,
          cgStAmt: taxAmtOfCgst,
          cgstPer: SgstPer,
          customColumn1: null,
          customColumn2: null,
          discountAmt: 0,
          expDate: Edate,
          godownId: itemGdwnId,
          gross: aftertax,
          igstAmt: igst,
          igstPer: Igstper,
          itemId: SelectedRowDataSAmple[i]["id"],
          itemSlNo: i,
          mrp: aftertax,
          netTotal: aftertax,
          nosInUnit: nosunt,
          notes: null,
          purchaseRate: aftertax,
          qty: Qty,
          rate: rate,
          salesRate: rate,
          sgstAmt: taxAmtOfSgst,
          sgstPer: SgstPer,
          taxAmount: aftertax - befortax,
          taxId: SelectedRowDataSAmple[i]["itmTaxId"],
          taxInclusive: false,
          unitId: SelectedRowDataSAmple[i]["unitId"],
        );
        purchase.add(_pur);
        print("............");
      }
      else{
      var edit_pur = purchaseedit(
            purchaseHeaderId:widget.passvalue,
          itmName: SelectedRowDataSAmple[i]["itmName"],
          Total_amt: grandTotal,
          amountBeforeTax: befortax,
          amountIncludingTax: aftertax,
          barcode: Brcode,
          batch: null,
          cessAmt: 0,
          cessPer: 0,
          cgStAmt: taxAmtOfCgst,
          cgstPer: SgstPer,
          customColumn1: null,
          customColumn2: null,
          discountAmt: 0,
          expDate: Edate,
          godownId: itemGdwnId,
          gross: aftertax,
          igstAmt: igst,
          igstPer: Igstper,
          itemId: SelectedRowDataSAmple[i]["id"],
          itemSlNo: i,
          mrp: aftertax,
          netTotal: aftertax,
          nosInUnit: nosunt,
          notes: null,
          purchaseRate: aftertax,
          qty: Qty,
          rate: rate,
          salesRate: rate,
          sgstAmt: taxAmtOfSgst,
          sgstPer: SgstPer,
          taxAmount: aftertax - befortax,
          taxId: SelectedRowDataSAmple[i]["itmTaxId"],
          taxInclusive: false,
          unitId: SelectedRowDataSAmple[i]["unitId"],
        );
        purchaseedt.add(edit_pur);
      }




      customer = CustomerAdd(
        id: SelectedRowDataSAmple[i]["id"],
        slNo: i,
        item: SelectedRowDataSAmple[i]["itmName"],
        quantity:  double.parse(SelectedRowDataSAmple[i]["qty"]),
        rate:  SelectedRowDataSAmple[i]["itmpurchaseRate"],
        txper: SelectedRowDataSAmple[i]["txPercentage"],
        cess: null,
        NetAmt: aftertax,
        amount:amount ,
        StkId: SelectedRowDataSAmple[i]["itmStkTypeId"],
        txAmt:( aftertax - befortax),
      );

      customerItemAdd.add(customer);
    }
    print(customer);

    //var bindData=[];
    print(customerItemAdd.length);
    setState(() {

    });
  }

  ///------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
//      key: scaffoldKey,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(190.0),
            child:  Appbarcustomwidget(uname: userName, branch: branchName, pref: pref, title:"Purchase")
        ),
        body: ListView(
          children: <Widget>[
            SizedBox(height: 10),




            SizedBox(height:GodownSelect==true?60: TextBoxHeight,
              child: Row(
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
                              errorText: customerSelect
                                  ? "Please Select Customer ?"
                                  : null,
//                            errorText: _validateName ? "please enter name" : null,
//                            errorBorder:InputBorder.none ,
                              suffixIcon: IconButton(
                                icon: Icon(Icons.remove_circle),
                                color: Colors.blue,
                                onPressed: () {
                                  setState(() {
                                    print("cleared");
                                    customerController.text = "";
                                    purchaseLedgerId = null;
                                    openingAmountBalance = 0;
                                  });
                                },
                              ),

                              isDense: true,
                              contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(TextBoxCurve)),
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
                          print("close.... $purchaseLedgerId");
                          slsname = suggestion.lhName;
                          print(suggestion.id);
                          print(".......purchase Ledger id");
                          purchaseLedgerId = suggestion.id;
                          if (suggestion.id != null) {
                            getCustomerLedgerBalance(suggestion.id);
                          }
                          print(purchaseLedgerId);
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
                ],
              ),
            ),


            Visibility(
              visible: openingAmountBalance > 0,
              child: SizedBox(
                height: 15,
              ),
            ),
            Visibility(
              visible: openingAmountBalance > 0,
              child: Row(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(width: 30),
                  Expanded(
                    child: Text(
                      "Current Balance:  " + openingAmountBalance.toString(),
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Visibility(
              visible: openingAmountBalance > 0,
              child: SizedBox(
                height: 9,
              ),
            ),

            SizedBox(height:GodownSelect==true?60: TextBoxHeight,
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      style: TextStyle(fontSize: 15),
                      showCursor: true,
                      controller: purchasedeliveryController,
                      enabled: true,
                      validator: (v) {
                        if (v.isEmpty) return "Required";
                        return null;
                      },
//
                      // will disable paste operation
                      focusNode: field1FocusNode,
                      cursorColor: Colors.black,

                      scrollPadding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                      keyboardType: TextInputType.datetime,
                      readOnly: true,

                      onTap: () async {
                        final DateTime now = DateTime.now();
                        DateTime? date = await showDatePicker(
                            context: context,
                            initialDatePickerMode: DatePickerMode.day,
                            initialDate: now,
                            firstDate: now.subtract(Duration(days: 1)),
                            lastDate: DateTime(2080),
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: ThemeData.light(),
                                child: child!,
                              );
                            });

                        if (date != null) {
                          print(date);
                          if (date.day < DateTime.now().day) {
                            print("invalid date select");

                            purchasedeliveryController.text = "";
                            return;
                          } else {
                            deliveryDate = date;
                            var d = DateFormat("yyyy-MM-d").format(date);
                            purchasedeliveryController.text = d;
                          }
                        }
                      },

                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.red),
                        errorText: deliveryDateSelect ? "invalid date " : null,
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          color: Colors.blue,
                          size: 24,
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(TextBoxCurve)),
                        // curve brackets object
                        hintText: "Invoice Date:dd/mm/yy",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                        labelText: "Invoice Date",
                      ),
                    ),
                  ),

                  SizedBox(width: 10),
                  Expanded(
                      child: TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                              style: TextStyle(),
                              controller: godownController,
                              decoration: InputDecoration(
                                errorStyle: TextStyle(color: Colors.red),
                                errorText: GodownSelect
                                    ? "Please Select Godown ?"
                                    : null,
//                            errorText: _validateName ? "please enter name" : null,
//                            errorBorder:InputBorder.none ,
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.remove_circle),
                                  color: Colors.blue,
                                  onPressed: () {
                                    setState(() {
                                      print("cleared");
                                      godownController.text = "";
                                      itemGdwnId = null;
                                    });
                                  },
                                ),

                                isDense: true,
                                contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(TextBoxCurve)),
                                // i need very low size height
                                labelText:
                                'Godown search', // i need to decrease height
                              )),
                          suggestionsBoxDecoration:
                          SuggestionsBoxDecoration(elevation: 90.0),
                          suggestionsCallback: (pattern) {
                            return Gdwn.where((gwn) =>
                                gwn.gdnDescription.toUpperCase().contains(pattern.toUpperCase()));
                          },
                          itemBuilder: (context, suggestion) {
                            return Card(
                              color: Colors.blue,
                              // shadowColor: Colors.blue,
                              // So you upgraded flutter recently?
                              // i upgarded more times
                              // flutter cleaned
                              // get pubed
                              // outdated more times..try
                              // but now result to bad...
                              child: ListTile(
                                tileColor: theam.DropDownClr,
                                title: Text(
                                  suggestion.gdnDescription,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            print(suggestion.gdnDescription);
                            print("selected");
                            print(suggestion.gdnId);
                            godownController.text = suggestion.gdnDescription;
                            itemGdwnId=suggestion.gdnId;
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
                              ))),
                  SizedBox(width: 10),
                ],
              ),
            ),




            SizedBox(
              width: 10,
            ),

            AddItemWidgets(context,ItemsAdd_Widget_Visible),


            ///-----------------------Payment Condition---------------------------------
            SizedBox(height:5),
            SizedBox(height:paymentTypeSelect==true?60: TextBoxHeight,
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                      child: TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                              style: TextStyle(),
                              controller: paymentTypeController,
                              decoration: InputDecoration(
                                errorStyle: TextStyle(color: Colors.red),
                                errorText: paymentTypeSelect
                                    ? "Invalid Payment Typ"
                                    : null,
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.remove_circle),
                                  color: Colors.blue,
                                  onPressed: () {
                                    setState(() {
                                      print("cleared");
                                      paymentTypeController.text = "";
                                      paymentType_Id=null;
                                    });
                                  },
                                ),

                                isDense: true,
                                contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(TextBoxCurve)),
                                // i need very low size height
                                labelText:
                                'Payment Type', // i need to decrease height
                              )),
                          suggestionsBoxDecoration:
                          SuggestionsBoxDecoration(elevation: 90.0),
                          suggestionsCallback: (pattern) {
//                        print(payment);
                            return paymentType
//                            .where((user) => goods.itmName == pattern);
                                .where((us) => us['type'].toString().contains(pattern));
                          },
                          itemBuilder: (context, suggestion) {
                            return Card(
                              color: Colors.blue,
                              // shadowColor: Colors.blue,
                              child: ListTile(
                                tileColor: theam.DropDownClr,
                                title: Text(
                                  (suggestion["type"]as String),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            print(suggestion["type"],);
                            print("Item selected");

                            paymentTypeController.text = (suggestion["type"]as String);

                            print(suggestion['id']);
                            print("....... paymentType_Id id");
                            paymentType_Id = suggestion["id"];

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
                              ))),
//              SizedBox(height: 10),
                  SizedBox(
                    width: 1,
                  ),
                  Visibility(visible:!ItemsAdd_Widget_Visible,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10,right: 10),
                      child:   ElevatedButton(style: ButtonStyle( backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),),
                          onPressed: (){
                            if(itemGdwnId ==null){
                              setState(() {
                                GodownSelect=true;
                              });

                              return;

                            }
                            if(ShowAllItem==false){
                              setState(() {
                                GodownSelect=false;
                                ItemsAdd_Widget_Visible=!ItemsAdd_Widget_Visible;
                              });
                            }else{
                              print("uiopupu");
                              SelectedRowDataSAmple=[];
                              SelectedRowData=[];
                              ShowAllItemPopup(goods);
                            }

                          }, child:Text("Add Items",style: TextStyle(fontSize: 14),)),
                    ),
                  ),
                  Visibility(visible:!ItemsAdd_Widget_Visible,
                    child: Stack(
                      children: [

                        Positioned(left: 13,
                            child: Text(" All",style: TextStyle(fontSize: 12),)),

                        Checkbox(
                          value:ShowAllItem,
                          onChanged: (bool? value) {
                            setState(() {
                              ShowAllItem = !ShowAllItem;

                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox( width: 5,),
                  //Checkbox
                ],
              ),
            ),



//             Row(
//               children: [
//                 SizedBox(width: 10),
//                 Expanded(
//                     child: TypeAheadField(
//                         textFieldConfiguration: TextFieldConfiguration(
//                             style: TextStyle(),
//                             controller: paymentController,
//                             decoration: InputDecoration(
//                               errorStyle: TextStyle(color: Colors.red),
//                               errorText: paymentSelect
//                                   ? "Invalid Payment Selected"
//                                   : null,
//                               suffixIcon: IconButton(
//                                 icon: Icon(Icons.remove_circle),
//                                 color: Colors.blue,
//                                 onPressed: () {
//                                   setState(() {
//                                     print("cleared");
//                                     paymentController.text = "";
//                                     purchasePaymentId = 0;
//                                   });
//                                 },
//                               ),
//
//                               isDense: true,
//                               contentPadding:
//                               EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(TextBoxCurve)),
//                               // i need very low size height
//                               labelText:
//                               'Payment Condition', // i need to decrease height
//                             )),
//                         suggestionsBoxDecoration:
//                         SuggestionsBoxDecoration(elevation: 90.0),
//                         suggestionsCallback: (pattern) {
// //                        print(payment);
//                           return payment
// //                            .where((user) => goods.itmName == pattern);
//                               .where((us) => us.conDescription.contains(pattern));
//                         },
//                         itemBuilder: (context, suggestion) {
//                           return Card(
//                             color: Colors.blue,
//                             // shadowColor: Colors.blue,
//                             child: ListTile(
//                               tileColor: theam.DropDownClr,
//                               title: Text(
//                                 suggestion.conDescription,
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           );
//                         },
//                         onSuggestionSelected: (suggestion) {
//                           print(suggestion.conDescription);
//                           print("Item selected");
//
//                           paymentController.text = suggestion.conDescription;
//                           print("close.... $purchasePaymentId");
//                           purchasePaymentId = 0;
//
//                           print(suggestion.id);
//                           print(".......purchase Item id");
//                           purchasePaymentId = suggestion.id;
//                           print(purchasePaymentId);
//                           print("...........");
//                         },
//                         errorBuilder: (BuildContext context, Object error) =>
//                             Text('$error',
//                                 style: TextStyle(
//                                     color: Theme.of(context).errorColor)),
//                         transitionBuilder:
//                             (context, suggestionsBox, animationController) =>
//                             FadeTransition(
//                               child: suggestionsBox,
//                               opacity: CurvedAnimation(
//                                   parent: animationController,
//                                   curve: Curves.elasticIn),
//                             ))),
// //              SizedBox(height: 10),
//                 SizedBox(
//                   width: 10,
//                 )
//               ],
//             ),
            SizedBox(
              height: 5,
            ),
            SizedBox(height: TextBoxHeight,
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: generalRemarksController,
                      focusNode: generalFocus,
                      enabled: true,
                      validator: (v) {
                        if (v!.isEmpty) return "Required";
                        return null;
                      },
//
//                  focusNode: field1FocusNode,
                      cursorColor: Colors.black,

                      scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                      keyboardType: TextInputType.text,

                      decoration: InputDecoration(
//                    suffixIcon: Icon(
//                      Icons.calendar_today,
//                      color: Colors.blue,
//                      size: 24,
//                    ),
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 16.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(TextBoxCurve)),
                        // curve brackets object
//                    hintText: "Quantity",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                        labelText: "General Remarks",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: cw.CUTestbox(label:"Inv.No",controllerName: InvNoController)),
                  SizedBox(
                    width: 10,
                  ),


                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(mainAxisAlignment:MainAxisAlignment.center ,
              children: [
                // SizedBox(
                //   width: 10,
                // ),
                Visibility(
                  visible: Save_pending==false,
                  child: GestureDetector(
                      onTap: () {
                        print("Save");
                        //purchaseSave();
                        VlidationBeforeSave();
                      },
                      child:Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:theam.saveBtn_Clr,
                        ),
                        width: 100,
                        height: 40,
                        child: Center(
                          child: Text(
                            btnname,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )

                  ),
                ),

                SizedBox(width:MediaQuery.of(context).size.width  *0.44),
                GestureDetector(
                    onTap: () {
                      print("Reset");
                      setState(() {
                        Resetfunction();
                      });
                    },
                    child:Container(alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.indigo,
                      ),
                      width: 100,
                      height: 40,
                      child: Center(
                        child: Text(
                          "Reset",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )

                ),
                // Padding(
                //   padding: EdgeInsets.only(left: 164.0, right: 0.0),
                //   child: RaisedButton(
                //     textColor: Colors.white,
                //     color: Colors.lightBlueAccent,
                //     child: Text("Reset"),
                //     onPressed: () {
                //       setState(() {
                //         customerSelect = false;
                //         deliveryDateSelect = false;
                //         rateSelect = false;
                //         quantitySelect = false;
                //         itemSelect = false;
                //         paymentSelect = false;
                //         customerItemAdd.clear();
                //         purchase.clear();
                //         customerController.text = "";
                //         purchasedeliveryController.text = "";
                //         generalRemarksController.text = "";
                //         paymentController.text = "";
                //         grandTotal = 0;
                //         purchasePaymentId = 0;
                //         purchaseItemId = 0;
                //         purchaseLedgerId = 0;
                //       });
                //     },
                //     shape: new RoundedRectangleBorder(
                //       borderRadius: new BorderRadius.circular(TextBoxCurve),
                //     ),
                //   ),
                // ),
              ],
            ),

            //-----test-------
            // GestureDetector(child: Text("rtrtzxrtrtrt",style: TextStyle(color: Colors.red),),
            //   onTap: (){
            //    // GetdataPrint(352);
            //     GetGodown();
            //   },),



            SizedBox(
              height: 0,
              // width: 30,
            ),
            Visibility(
              visible: customerItemAdd.length > 0,
              child: Row(
                //verticalDirection: VerticalDirection.down,
                //crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // SizedBox(
                  //   width: 1,
                  // ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 10,
                        dataRowHeight: 38,
                        onSelectAll: (b) {},
                        sortAscending: true,
                        showCheckboxColumn: false,
                        columns: <DataColumn>[
                          DataColumn(
                            label: Text('No',textAlign: TextAlign.left,),
                          ),
                          DataColumn(
                            label: Text('Item'),
                          ),
                          DataColumn(
                            label: Text('QTY'),
                          ),
                          DataColumn(
                            label: Text('Rate'),
                          ),
                          DataColumn(
                            label: Text('Tax %'),
                          ),
                          DataColumn(
                            label: Text('Tax Amt'),
                          ),
                          DataColumn(
                            label: Text('Amount'),
                          ),
                          DataColumn(
                            label: Text(''),
                          ),
                        ],
                        rows: customerItemAdd
                            .map(
                              (itemRow) => DataRow(
                                onSelectChanged: (a){
                            print(itemRow.item);
                            showDialog(
                                context: context,
                                builder: (c) => AlertDialog(
                                    title: Text("Are you sure to delete? ",textAlign: TextAlign.center,),
                                    content:Text("${itemRow.item}",textAlign: TextAlign.center,style:TextStyle(color: Colors.teal,fontSize: 25,fontWeight: FontWeight.bold)),
                                    actions: [
                                      TextButton(
                                        child: Text("No",style: TextStyle(color: Colors.black),),
                                        onPressed: () {
                                          setState(() {
                                            print("No...");
                                            Navigator.pop(
                                                context); // this is proper..it will only pop the dialog which is again a screen
                                          });
                                        },
                                      ),
                                      TextButton(
                                        child: Text("Yes",style: TextStyle(color: Colors.red)),
                                        onPressed: () {
                                          setState(() {
                                            print("Yes");
                                            removeListElement(itemRow.id,
                                                itemRow.slNo, itemRow.NetAmt,itemRow.txAmt);
                                            Navigator.pop(
                                                context);
                                          });
                                        },
                                      )
                                    ]));
                          },
                            cells: [
                              DataCell(
                                Text(getItemIndex(itemRow).toString()),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Text(itemRow.item.toString()),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Align(alignment: Alignment.centerRight,child: Text(itemRow.quantity.toString())),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Align(alignment: Alignment.centerRight,child: Text(itemRow.rate.toString()=="null"?"0.0":itemRow.rate.toString())),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Align(alignment: Alignment.centerRight,
                                  child: Text((itemRow.txper)!=null?itemRow.txper.toString():0.0
                                      .toString()),
                                ),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Align(alignment: Alignment.centerRight,
                                  child: Text((itemRow.txAmt)!=null?itemRow.txAmt.toStringAsFixed(2):0.0
                                  //((itemRow['amount']!=null))?formatter.format((itemRow['amount'])):"0.0"
                                      .toString()),
                                ),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Align(alignment: Alignment.centerRight,child: Text(formatter.format(itemRow.NetAmt).toString())),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                IconButton(icon: Icon(Icons.delete),
                                  color: Colors.red,
                                  onPressed: () {
                                    setState(() {
                                      removeListElement(itemRow.id,
                                          itemRow.slNo, itemRow.NetAmt,itemRow.txAmt);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                            .toList(),
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   width: 40,
                  // )
                ],
              ),
            ),


            Visibility(
                visible:grandTotal > 0,
                child: Divider(color: Colors.black,)),
            Visibility(
              visible: grandTotal > 0,
              child: Row(mainAxisAlignment:MainAxisAlignment.end,
                children: [
                Column(children: [
                  Text('Total Amt : ',
                    style: TextStyle(fontSize: 20,color: Colors.black,)),
                  Text('Total Vat  : ',
                      style: TextStyle(fontSize: 20,color: Colors.black,)),
                  Text('Net Amt   : ',
                      style: TextStyle(fontSize: 20,color: Colors.black,)),

                ],),

                Column(crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                  Text(Net_Amt_Befor_Tax.toStringAsFixed(2),
                      style: TextStyle(fontSize: 20,color: Colors.black,),textAlign: TextAlign.right),
                  Text(Net_VAt.toStringAsFixed(2),
                      style: TextStyle(fontSize: 20,color: Colors.black,),textAlign: TextAlign.right),
                  Text(formatter.format(grandTotal),
                      style: TextStyle(fontSize: 20,color: Colors.black,),textAlign: TextAlign.right),

                ],),
                  SizedBox(width: MediaQuery.of(context).size.width/4,)
              ],)
            ),



            WillPopScope(

              onWillPop: _onBackPressed,
              child: Text(""),
            ),
            // SizedBox(height:500),
            //  SizedBox(height: MediaQuery.of(context).viewInsets.top),
            // SizedBox(height:  MediaQuery.of(context).size.width*1),

          ],
        ),


        // resizeToAvoidBottomInset: false,


        bottomSheet: Visibility(
          visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
          child: Container(color: Colors.white.withOpacity(0.9),
            child: Padding(
              padding: const EdgeInsets.only(left: 15,bottom: 15),
              child: FloatingActionButton(

                  backgroundColor: Colors.blue,
                  hoverColor: Colors.red,  elevation: 5,

                  child: Icon(Icons.home_filled),
                  onPressed: (){
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder:(context) =>
                            SalesManHome()), (route) => false);
                    customerItemAdd=[];
                  }),

            ),
          ),
        ),
        floatingActionButton:Visibility(
          visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
          child: SpeedDial(
              animatedIcon:AnimatedIcons.menu_arrow,
              overlayColor: Colors.blue,
              children: [
                SpeedDialChild(
                    child: Icon(Icons.shopping_cart),
                    backgroundColor: Colors.blue,
                    label: "Sales",
                    onTap:(){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>Newsalespage(
                                passvalue: null,
                                passname: null.toString(),
                              )));
                    } ),
                SpeedDialChild(
                    child: Icon(Icons.description_outlined),
                    backgroundColor: Colors.blue,
                    label: "Sales Index",
                    onTap:(){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>salesindex()));
                    } ),
                SpeedDialChild(
                    child: Icon(Icons.description_outlined),
                    backgroundColor: Colors.blue,
                    label: "Purchase Index",
                    onTap:(){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>Purchase_Index()));
                    } ),
                SpeedDialChild(
                    child: Icon(Icons.request_quote_outlined),
                    backgroundColor: Colors.blue,
                    label: "Ledger Balance",
                    onTap:(){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Newtestpage(passvalue:slsname.toString(),Shid:null)),  );
                    } ),
                SpeedDialChild(
                    child: Icon(Icons.remove_red_eye_outlined),
                    backgroundColor: Colors.blue,
                    label: "Shop Visited",
                    onTap:(){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => shopvisited(passvalue:null,passname:null.toString(),)));
                    } ),
              ]),
        ),

      ),
    );
  }
  ///----------------------------------ItemsAdd part ----------------------------------------

  Visibility AddItemWidgets(BuildContext context,bool visibility) {
    return Visibility( visible: visibility,
      child: Padding(
        padding: const EdgeInsets.only(left: 10,right: 10,top: 3),
        child: Container(decoration: BoxDecoration(borderRadius:BorderRadius.circular(10),color: Colors.blueGrey.shade50),
          child: Column(children: [
            SizedBox(
              height: 6,
            ),
            SizedBox(height: itemSelect==true?60: TextBoxHeight,
              child: Row(
                children: [
                  SizedBox(width: 2),

                  Stack(
                    children: [

                      Positioned(left: 13,
                          child: Text("IGST",style: TextStyle(fontSize: 12),)),

                      Checkbox(
                        value: this.GSTtyp,
                        onChanged: (bool? value) {
                          setState(() {
                            this.GSTtyp = value!;

                            print("GSTtyp $value");
                          });
                        },
                      ),
                    ],
                  ), //Checkbox

                  Expanded(
                      child: TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                              style: TextStyle(),
                              controller: goodsController,
                              decoration: InputDecoration(
                                errorStyle: TextStyle(color: Colors.red),
                                errorText: itemSelect
                                    ? "Please Select product Item ?"
                                    : null,
//                            errorText: _validateName ? "please enter name" : null,
//                            errorBorder:InputBorder.none ,
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.remove_circle),
                                  color: Colors.blue,
                                  onPressed: () {
                                    setState(() {
                                      print("cleared");
                                      goodsController.text = "";
                                      purchaseItemId = null;
                                      openingAmountBalance = 0;
                                      rateController.text="";
                                    });
                                  },
                                ),
                                prefixIcon:  IconButton(icon: Icon(Icons.qr_code,color: Colors.black,), onPressed: (){

                                  qr_Barcode_Readfunction();
                                }),
                                isDense: true,
                                contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(TextBoxCurve)),
                                // i need very low size height
                                labelText:
                                'Item search', // i need to decrease height
                              )),
                          suggestionsBoxDecoration:
                          SuggestionsBoxDecoration(elevation: 90.0),
                          suggestionsCallback: (pattern) {
                            return goods.where((user) =>
                                user.itmName.trim().toLowerCase().contains(pattern.trim().toLowerCase()));
                          },
                          itemBuilder: (context, suggestion) {
                            return Card(
                              color: Colors.blue,
                              // shadowColor: Colors.blue,
                              child: ListTile(
                                tileColor: theam.DropDownClr,
                                title: Text(
                                  suggestion.itmName,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            print(suggestion.itmName);
                            print("selected");
                            setState(() {
                              // getbatch(suggestion.id);///  data get with batch

                              dynamic j=[];
                              j={
                                "id":suggestion.id,
                                "itemId":suggestion.id,
                                "expiryDate":null,
                                "srate":suggestion.itmPurchaseRate,
                                "batchNo":null,
                                "nos":null,
                                "barcode":null,
                                "godownId":itemGdwnId
                              };
                              print(j);
                              multibatchitembinding(j);



                            });


                            print(purchaseItemId);
                            print("...........");

                            //  print(".........$cessper..");
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
                              ))),
                  SizedBox(
                    width: 10,
                    height: 5,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 6,
            ),
            SizedBox(height:quantitySelect==true?60: TextBoxHeight,
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: quantityController,
                      onEditingComplete: (){
                        qtyFocus.unfocus();
                        FocusScope.of(context).requestFocus(rateFocus);
                      },
                      focusNode: qtyFocus,
                      enabled: true,
                      validator: (v) {
                        if (v!.isEmpty) return "Required";
                        return null;
                      },
//
                      // will disable paste operation
//                  focusNode: field1FocusNode,
                      cursorColor: Colors.black,

                      scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}")),
                      ],
                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.red),
                        errorText: quantitySelect ? "Invalid Qty" : null,
//                    suffixIcon: Icon(
//                      Icons.calendar_today,
//                      color: Colors.blue,
//                      size: 24,
//                    ),
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 16.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(TextBoxCurve)),

                        // curve brackets object
//                    hintText: "Quantity",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                        labelText: "Quantity",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
//----------------unit-------------------
                  Expanded(
                      child: TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                            controller:UnitController ,
                            style: TextStyle(),
                            decoration: InputDecoration(
                              errorStyle: TextStyle(color: Colors.red),
                              errorText: unitSelect
                                  ? "Invalid Unit Selected"
                                  : null,
                              suffixIcon: IconButton(
                                icon: Icon(Icons.remove_circle),
                                color: Colors.blue,
                                onPressed: () {
                                  setState(() {
                                    print("cleared");
                                    UnitController.text = "";
                                    //  purchasePaymentId = 0;
                                  });
                                },
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 5.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(TextBoxCurve)),

                              hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                              labelText: "Unit",
                            ),
                          ),

                          suggestionsBoxDecoration:
                          SuggestionsBoxDecoration(elevation: 90.0),
                          suggestionsCallback: (pattern) {
//                        print(payment);
                            return unit.where((unt) => unt.description.contains(pattern));
                          },
                          itemBuilder: (context, suggestion) {
                            return Card(
                              color: Colors.blue,
                              child: ListTile(
                                tileColor: theam.DropDownClr,
                                title: Text(
                                  suggestion.description,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            print(suggestion.description);
                            print("Unit selected");

                            UnitController.text = suggestion.description;
                            print("close.... $unitId");
                            unitId = null;

                            print(suggestion.id);
                            print(".......Unit id");
                            unitId = suggestion.id;
                            print(unitId);
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
                              ))),
                  //----------------unit-------------------


                  SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: rateController,
                      focusNode: rateFocus,
                      onEditingComplete: (){
                        rateFocus.unfocus();
                        FocusScope.of(context).requestFocus(generalFocus);
                      },
                      enabled: true,
                      validator: (v) {
                        if (v!.isEmpty) return "Required";
                        return null;
                      },
//
                      cursorColor: Colors.black,

                      scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                      keyboardType: TextInputType.number,

                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}")),
                      ],
                      decoration: InputDecoration(

//                    suffixIcon: Icon(
//                      Icons.calendar_today,
//                      color: Colors.blue,
//                      size: 24,
//                    ),
                        errorStyle: TextStyle(color: Colors.red),
                        errorText: rateSelect ? "Invalid Rate" : null,
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 18.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(TextBoxCurve)),
                        // curve brackets object
//                    hintText: "Quantity",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                        labelText: "Rate",
                      ),
                    ),
                  ),
                  SizedBox(width: 4),
                  SizedBox.fromSize(
                    size: Size(45, 45), // button width and height
                    child: ClipOval(
                      child: Material(
                        color: Colors.lightBlueAccent, // button color
                        child: InkWell(
                          splashColor: Colors.green, // splash color
                          onTap: addCustomerItem,
//                      onPressed: ,
                          // button pressed
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              ), // icon
//                          Text("Call"), // text
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 6,
            ),

          ],),
        ),
      ),
    );
  }

  ///------------------------------------------------------------------------




  Future<Null> refreshList() async {

    await Future.delayed(Duration(seconds: 1));

    setState(() {

    });
    return null;
  }

  databinding(id) async{
    setState(() {
      Net_VAt=0.0;
      Net_Amt_Befor_Tax=0.0;
      grandTotal=0.0;
    });
    print("databinding purchase : $id");
    double amount =0.0;
    try {
      final bindata =
      await http.get("${Env.baseUrl}purchaseHeaders/$id" as Uri, headers: { //Soheader //purchaseHeaders
        "Authorization": user.user["token"],
      });
      print("databinding purchase edit"+bindata.body);
      print(bindata.statusCode);

      var tagsJson = jsonDecode(bindata.body);

      purchaseEditDatas=tagsJson;

      // print("databinding decoded  "+(tagsJson["purchaseHeader"][0]["voucherDate"]).toString());

      (tagsJson["listHeader"][0]["narration"] == null)? generalRemarksController.text="":generalRemarksController.text=tagsJson["purchaseHeader"][0]["narration"];
      var bindDt="-:-:-";
      print(tagsJson["listHeader"][0]["voucherDate"]);
      var vchDate =tagsJson["listHeader"][0]["voucherDate"];
      if(vchDate!=null)
      {

        var prsDt = DateTime.tryParse(
            tagsJson["listHeader"][0]["voucherDate"]);
        bindDt = DateFormat("d-MM-yyyy").format(prsDt!);
      }


      setState(() {
        grandTotal=tagsJson["listHeader"][0]["netAmount"]??0.0;
        paymentType_Id=tagsJson["listHeader"][0]["paymentType"];
        paymentTypeController.text=tagsJson["listHeader"][0]["paymentType"].toString()=="0"?
        "Cash":"Credit";
      });
      purchasedeliveryController.text=bindDt;
      deliveryDate=bindDt;
      Vouchnum=tagsJson["listHeader"][0]["voucherNo"];
     InvNoController.text=tagsJson["listHeader"][0]["invNo"];
      print("-----------");
      print(tagsJson["listDetails"]);

      List <dynamic> binditm =tagsJson["listDetails"]as List;
      print("binditm");
      print(binditm);
      for(int i=0;i<binditm.length;i++)
      {
        print(binditm[i]["itmName"]);
       Net_VAt=Net_VAt+(binditm[i]["taxAmount"]);
        Net_Amt_Befor_Tax=Net_Amt_Befor_Tax+binditm[i]["amountBeforeTax"];
        customer = CustomerAdd(
            id: binditm[i]["itemId"],
            slNo:slnum,
            item: binditm[i]["itmName"],
            quantity:binditm[i]["qty"],
            rate: binditm[i]["rate"],
            txper: binditm[i]["txPercentage"],
            amount: (binditm[i]["rate"])* (binditm[i]["qty"]),
            StkId:binditm[i]["stockId"],
            NetAmt: (binditm[i]["amountIncludingTax"]),
            txAmt: (binditm[i]["rate"]/100)*(binditm[i]["txPercentage"])*binditm[i]["qty"],
        );

        setState(() {

          print(".....slse.....");
          //  grandTotal=grandTotal+( binditm[i]["rate"])* (binditm[i]["qty"]); // with out tax
         // grandTotal=grandTotal+(binditm[i]["amountIncludingTax"]); // with  tax
        //  grandTotal=Net_Amt_Befor_Tax+Net_VAt;
          slse = purchaseedit(
            itmName:binditm[i]["itmName"],
            Total_amt:binditm[i]["amountIncludingTax"],
            itmCode:binditm[i]["itmCode"],
            salesRate:binditm[i]["salesRate"],
            mrp:binditm[i]["mrp"],
            itemSlNo :slnum,
            purchaseHeaderId :widget.passvalue,
            itemId: binditm[i]["itemId"],
            qty: binditm[i]["qty"],
            rate:binditm[i]["rate"],
            // di: binditm[i]["disPercentage"]== null?0:binditm[i]["disPercentage"],
            cgstPer:binditm[i]["cgstPer"]== null?0:binditm[i]["cgstPer"],
            sgstPer: binditm[i]["sgstPer"],
            cessPer: binditm[i]["cessPer"],
            discountAmt: binditm[i]["discountAmt"],
            cgStAmt: binditm[i]["cgStAmt"],
            sgstAmt: binditm[i]["sgstAmt"],
            cessAmt: binditm[i]["cessAmt"],
            igstPer: binditm[i]["igstPer"],
            igstAmt: binditm[i]["igstAmt"],
            txPercentage:itmtxper == null?0:itmtxper,
            taxAmount: (binditm[i]["rate"]/100)*(binditm[i]["txPercentage"]),
            taxInclusive :false,
            amountBeforeTax: ( binditm[i]["rate"])* (binditm[i]["qty"]),
            amountIncludingTax: binditm[i]["amountIncludingTax"],
            //( binditm[i]["rate"])* (binditm[i]["qty"])+ ((binditm[i]["rate"]/100)*binditm[i]["taxPercentage"]),
            netTotal:binditm[i]["amountIncludingTax"],
            godownId:binditm[i]["godownId"],
            taxId:binditm[i]["taxId"],
            // ra:binditm[i]["rackId"],
            // addTaxId: binditm[i]["taxId"],
            unitId: binditm[i]["unitId"],
            nosInUnit: binditm[i]["nosInUnit"],
            barcode: binditm[i]["barcode"],
            gtStockId: binditm[i]["gtStockId"],
            batch: binditm[i]["batch"],
            expDate: binditm[i]["expDate"],
            notes:binditm[i]["notes"],
            // hsncode:binditm[i]["hsncode"],
            // adlDiscAmount:binditm[i]["adlDiscAmount"],
          );
          // print("fff"+slse.rate.toString());

          // var parampars = json.encode(slse);
          purchaseedt.add(slse);
          customerItemAdd.add(customer);
          print("gggggg${customerItemAdd.length.toString()}");
          slnum++;
        });
      }

    }catch(e){ print("databinding1 error $e");}
  }




  //for binde data from Soh -------------------------sohdata--------------------------------------------


//---data binding old for purchaseorder-----

//   databindingSoh(id) async{
//     print("databinding : $id");
//     double amount =0.0;
//     var igst=0.00;
//     var aftertax;
//     try {
//       final bindata =
//       await http.get("${Env.baseUrl}Soheader/$id/3", headers: {
//         "Authorization": user.user["token"],
//       });
//       print("databinding  "+bindata.body);
//       print(bindata.statusCode);
//       var tagsJson = json.decode(bindata.body);
//
//
//       print("databinding decoded  "+tagsJson["data"]["voucherDate"]);
//
//       generalRemarksController.text=tagsJson["data"]["narration"];
//
//       var prsDt= DateTime.tryParse(tagsJson["data"]["voucherDate"]);
//       var bindDt= DateFormat("d-MM-yyyy").format(prsDt);
//       purchasedeliveryController.text=bindDt;
//       deliveryDate=bindDt;
//       List <dynamic> binditm =tagsJson["data"]["sodetailed"]as List;
//       for(int i=0;i<binditm.length;i++)
//       {
//         print("Soh detail data");
//         print(binditm[i]["itemName"]);
//         print(binditm.length);
//         print(binditm[i]["rate"]);
//         /// tax calc...........
//         var rate=(binditm[i]["rate"]);
//         amount=((binditm[i]["rate"]))*((binditm[i]["qty"]));
//         //  double cgst=double.parse(((rate/100)*(binditm[i]["txCgstPercentage"])).toStringAsFixed(2));
//         //  double sgst=double.parse(((rate/100)*(binditm[i]["txSgstPercentage"])).toStringAsFixed(2));
//         dynamic Igst=double.parse(((rate/100)*(binditm[i]["txIgstpercentage"])).toStringAsFixed(2));
//         //  amount=((binditm[i]["rate"]))*((binditm[i]["qty"]));
//         //  print("amount  $amount");
//         //
//         //  var totligst=igst*(binditm[i]["qty"]);
//         //  var totlcgst=cgst*(binditm[i]["qty"]);
//         //  var totlsgst=sgst*(binditm[i]["qty"]);
//         //  var taxOneItm =((rate/100)*(binditm[i]["txPercentage"]));
//         //  var  ToatalTax=taxOneItm*(binditm[i]["qty"]);
//         //  print("grandTotal before $grandTotal");
//         //  grandTotal = grandTotal + ToatalTax + amount + totlcgst +totlsgst +totligst;
//         // var aftertax=ToatalTax + amount + totlcgst +totlsgst +totligst;
//         //  print("grandTotal after $grandTotal");
//
//         var taxOneItm =((rate/100)*(itmtxper));
//         var taxAmtOfCgst;
//         var taxAmtOfSgst;
//         var  ToatalTax;
//         dynamic  befortax=0;
//
//         if(binditm[i]["itmTaxInclusive"]==true){
//
//           var WithOutTaxamt=(((binditm[i]["txPercentage"])+100)/100);
//           print("WithOutTaxamt in inclusive of edit bind");
//           print(WithOutTaxamt.toString());
//           taxOneItm=rate/WithOutTaxamt;
//           taxAmtOfCgst=(WithOutTaxamt/2);
//           taxAmtOfSgst=(WithOutTaxamt/2);
//           // ToatalTax =taxOneItm*double.parse(quantityController.text);
//           grandTotal = grandTotal + amount;
//           aftertax= amount;
//           befortax=taxOneItm*(binditm[i]["qty"]);
//         }
//         else {
//
//           taxOneItm =((rate/100)*(binditm[i]["txPercentage"]));
//           taxAmtOfCgst=(taxOneItm/2);
//           taxAmtOfSgst=(taxOneItm/2);
//           ToatalTax =taxOneItm*(binditm[i]["qty"]);
//           grandTotal = grandTotal + ToatalTax + amount;
//           aftertax=ToatalTax + amount;
//           befortax=amount;
//
//         }
//
//
//         if(GSTtyp==true){
//           igst= Igst*double.parse(quantityController.text);
//           taxAmtOfCgst=0;
//           taxAmtOfSgst=0;
//         }
//         /// tax calc...........
//
//
//
//         customer = CustomerAdd(
//             id: binditm[i]["itemId"],
//             slNo: customerItemAdd.length + 1,
//             item: binditm[i]["itemName"],
//             quantity:binditm[i]["qty"],
//             rate: binditm[i]["rate"],
//             txper: binditm[i]["txPercentage"],
//             // cess:cessper,
//             amount: (binditm[i]["rate"])* (binditm[i]["qty"]),
//             StkId:binditm[i]["stockId"],
//             NetAmt: aftertax
//         );
//
//         setState(() {
//           ++slnum;
//           // grandTotal=grandTotal+( binditm[i]["rate"])* (binditm[i]["qty"]) + ((binditm[i]["rate"]/100)*binditm[i]["txPercentage"]);
//           // grandTotal=grandTotal+( binditm[i]["rate"])* (binditm[i]["qty"]);
//
//           _pur = purModel(
//             ItemSlNo :slnum,
//             shid:widget.passvalue,
//             itmName: binditm[i]["itemName"],
//             itemId: binditm[i]["itemId"],
//             qty: binditm[i]["qty"],
//             rate:binditm[i]["rate"],
//             disPercentage: 0,
//             cgstPercentage: (binditm[i]["txCgstPercentage"]),
//             sgstPercentage: (binditm[i]["txSgstPercentage"]),
//             cessPercentage: 0,
//             discountAmount:  0,
//             cgstAmount:  taxAmtOfCgst,
//             sgstAmount: taxAmtOfSgst,
//             cessAmount: 0,
//             igstPercentage:(binditm[i]["txIgstpercentage"]),
//             igstAmount:  igst,
//             taxPercentage:itmtxper == null?0:itmtxper,
//             taxAmount: (binditm[i]["rate"]/100)*(binditm[i]["txPercentage"]),
//             taxInclusive :false,
//             amountBeforeTax:befortax, //( binditm[i]["rate"])* (binditm[i]["qty"]),
//             amountIncludingTax:aftertax,//( binditm[i]["rate"])* (binditm[i]["qty"])+ ((binditm[i]["rate"]/100)*binditm[i]["txPercentage"]),
//             netTotal:grandTotal,
//             gdnId:binditm[i]["gdnId"],//1
//             taxId:binditm[i]["itmTaxId"],
//             rackId: null,
//             addTaxId: binditm[i]["itmTaxId"],
//             unitId: binditm[i]["unitId"],
//             nosInUnit: 6,
//             barcode:  null,
//             StockId: binditm[i]["stockId"],
//             BatchNo:null,// binditm[i]["batchNo"],
//             ExpiryDate:null,// binditm[i]["expiryDate"],
//             Notes:null,
//             hsncode:null,//binditm[i]["hsncode"],
//             // adlDiscAmount:0,
//             // adlDiscPercent:0
//           );
//
//
//           print("1111111");
//           // print("Sohdata"+_pur.rate.toString());
//           print(_pur);
//           var parampars = json.encode(_pur);
//           print("databindingSoh purchase parampars : $parampars");
//           purchase.add(_pur);
//         });
//         print("Soh dara rate"+ binditm[i]["rate"].toString());
//         setState(() {
//           customerItemAdd.add(customer);
// //
// //        // grandTotal=grandTotal+( binditm[i]["rate"])* (binditm[i]["qty"]);
//           // grandTotal=grandTotal+( binditm[i]["rate"])* (binditm[i]["qty"]) + ((binditm[i]["rate"]/100)*binditm[i]["txPercentage"]);
//
//
//         });
//       }
//     }catch(e){ print("databinding1 Soh1 error $e");}
//   }



//----------------------------------------------------------
//--------------------Print part-------------------------------------------

  GetdataPrint(id) async {
    print("purchase for print : $id");
    double amount = 0.0;
    try {
      final tagsJson =
      await http.get("${Env.baseUrl}purchaseHeaders/$id" as Uri, headers: {
        //Soheader //purchaseHeaders
        "Authorization": user.user["token"],
      });
      dataForTicket = await jsonDecode(tagsJson.body);
      // print("purchase for print");
      print(dataForTicket);

      Timer(Duration(milliseconds: 1), () async{
        // await wifiprinting();
        blutoothprinting();
        // _ticket(PaperSize.mm58);
      });

    } catch (e) {
      print('error on databinding $e');
    }
  }



  footerdata() async {
    try {
      print("footer data decoded  ");
      final tagsJson =
      await http.get("${Env.baseUrl}purchaseInvoiceFooters/" as Uri, headers: {
        "Authorization": user.user["token"],
      });

      setState(() {
        footerCaptions = jsonDecode(tagsJson.body);
        print( "on footerCaptions :" +footerCaptions.toString());
        // wifiprinting();
      });

    } catch (e) {
      print(e);
    }
  }

  GetCompantPro(id)async{
    print("GetCompantPro");
    print(id.toString());
    try {
      final tagsJson =
      await http.get("${Env.baseUrl}MCompanyProfiles/$id" as Uri, headers: {
        //Soheader //purchaseHeaders
        "Authorization": user.user["token"],
      });
      if(tagsJson.statusCode==200) {
        Companydata = jsonDecode(tagsJson.body);
      }
      // print( "on GetCompantPro :" +Companydata.toString());
    }
    catch(e){
      print("error on GetCompantPro : $e");
    }
  }
//----------printing ticket generate--------------------------

  Future<Ticket> _ticket(PaperSize paper) async {
    // final ticket = Ticket(paper);
    print('in');
    final ticket = Ticket(paper);

    List<dynamic> slsDet = dataForTicket["listDetails"] as List;
    dynamic VchNo = (dataForTicket["purchaseHeader"][0]["voucherNo"]) == null
        ? "00"
        : (dataForTicket["purchaseHeader"][0]["voucherNo"]).toString();
// dynamic date=(dataForTicket["purchaseHeader"][0]["voucherDate"])==null?"-:-:-": DateFormat("yyyy-MM-dd hh:mm:ss").format((dataForTicket["purchaseHeader"][0]["voucherDate"]));
    dynamic date = (DateFormat("dd/MM/yyy hh:mm:ss a").format(DateTime.now()).toString());
    dynamic partyName=(dataForTicket["purchaseHeader"][0]["partyName"]) == null ||
        (dataForTicket["purchaseHeader"][0]["partyName"])== ""
        ? ""
        : (dataForTicket["purchaseHeader"][0]["partyName"]).toString();



    ticket.row([
      PosColumn(text: ' ', width: 1),
      PosColumn(
          text:branchName.toString(),
          width: 10,
          styles: PosStyles(bold: true,
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
      PosColumn(text: ' ', width: 1)
    ]);




    ticket.row([
      PosColumn(text: ' ', width: 1),
      PosColumn(
          text:(Companydata["companyProfileAddress1"]).toString(),
          width: 10,
          styles:PosStyles(bold: false,
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,)),
      PosColumn(text: ' ', width: 1)
    ]);



    ticket.row([
      PosColumn(text: ' ', width: 1),
      PosColumn(
          text: (Companydata["companyProfileAddress2"]).toString(),
          width: 10,
          styles:PosStyles(bold: false,
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(text: ' ', width: 1)
    ]);

    ticket.row([
      PosColumn(text: ' ', width: 1),
      PosColumn(
          text:  (Companydata["companyProfileAddress3"]).toString(),
          width: 10,
          styles:PosStyles(bold: false,
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(text: ' ', width: 1)
    ]);



    ticket.row([
      PosColumn(text: ' ', width: 1),
      PosColumn(
          text:(Companydata["companyProfileMobile"]).toString(),
          width: 10,
          styles:PosStyles(bold: false,
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(text: ' ', width: 1)
    ]);




    ticket.row([
      PosColumn(text: ' ', width: 1),
      PosColumn(
          text:  (Companydata["companyProfileEmail"]).toString(),
          width: 10,
          styles:PosStyles(bold: false,underline: true,
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(text: ' ', width: 1)
    ]);





    ticket.text('GSTIN: ' +
        ( Companydata["companyProfileGstNo"]).toString()+' ',
        styles: PosStyles(bold: false,
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ));


    ticket.text('Inv.NO : ' + VchNo.toString(),
        styles: PosStyles(bold: true, width: PosTextSize.size1));
    //ticket.emptyLines(1);
    ticket.text('Date : $date');

    //---------------------------------------------------------
    if(partyName !="")
    {
      //ticket.emptyLines(1);
      ticket.text('Name : $partyName');
    }
    if((dataForTicket["purchaseHeader"][0]["gstNo"]) !=null)
    {
      // ticket.emptyLines(1);
      ticket.text('GST No :' +((dataForTicket["purchaseHeader"][0]["gstNo"])));
    }
    //---------------------------------------------------------

    ticket.hr(ch: '_');
    ticket.row([
      PosColumn(
        text:'No',
        styles: PosStyles(align: PosAlign.left),
        width:1,
      ),
      PosColumn(
        text:'Item',
        styles: PosStyles(bold: true,align: PosAlign.center),
        width: 2,
      ),
      PosColumn(text: 'Qt', width: 1,styles: PosStyles(align: PosAlign.right ),),
      PosColumn(text: 'Rate', width: 3,styles:PosStyles(align: PosAlign.center)),
      PosColumn(text: 'Tax', width: 2,styles: PosStyles(align: PosAlign.center ),),
      PosColumn(text: ' Amonunt', width: 3,styles: PosStyles(align: PosAlign.center ),),
    ]);
    ticket
        .hr(); // for dot line or set ticket.hr(ch: 'charecter', linesAfter: 1);
    var snlnum=0;
    dynamic total = 0.000;
    for (var i = 0; i < slsDet.length; i++) {
      total = slsDet[i]["amountIncludingTax"] + total;
      // ticket.emptyLines(1);
      snlnum=snlnum+1;
      ticket.row([
        PosColumn(text: (snlnum.toString()),width: 1,styles: PosStyles(
            align: PosAlign.left
        )),

        PosColumn(text: (slsDet[i]["itmName"]),
            width: 11,styles:
            PosStyles(align: PosAlign.left )),] );

      // for space
      ticket.row([
        PosColumn(
          text: (''),
          width: 1,
        ),
        PosColumn(
            text: (' '+((slsDet[i]["qty"])).toStringAsFixed(0)).toString(),styles:PosStyles(align: PosAlign.right ),
            width: 2),
        PosColumn(
            text: (((slsDet[i]["rate"])).toStringAsFixed(2)).toString(),
            width: 3,
            styles: PosStyles(
                align: PosAlign.right
            )),

        PosColumn(
            text: (' ' + ((slsDet[i]["taxPercentage"])).toStringAsFixed(2))
                .toString(),styles:PosStyles(align: PosAlign.right ),
            width: 2),
        PosColumn(
            text: ((slsDet[i] ["amountIncludingTax"])).toStringAsFixed(2)
            ,styles:PosStyles(align:PosAlign.right ),
            width:4),
      ]);
    }


    ticket.hr(ch:"=",len: 32);
    ticket.row([
      PosColumn(
          text: 'Total',
          width: 4,
          styles: PosStyles(
            bold: true,align:PosAlign.left,
          )),
      PosColumn(
          text:'Rs '+(total.toStringAsFixed(2)).toString(),
          width: 8,
          styles: PosStyles(bold: true,align: PosAlign.right,)),
    ]);
    ticket.hr(
        ch: '_',len: 32 );

    // ticket.row([
    //   PosColumn(text: ' ', width: 1),
    //   PosColumn(
    //       text: footerCaptions[0]['footerCaption'],
    //       width: 10,
    //       styles: PosStyles(align: PosAlign.center)),
    //   PosColumn(text: ' ', width: 1)
    // ]);
    //
    // ticket.row([
    //   PosColumn(text: '  ', width: 1),
    //   PosColumn(
    //       text: footerCaptions[0]['footerText'],
    //       width: 10,
    //       styles: PosStyles(align: PosAlign.center)),
    //   PosColumn(text: '  ', width: 1)
    // ]);

    ticket.feed(1);
    ticket.text('Thank You...Visit again !!',
        styles: PosStyles(align: PosAlign.center, bold: true));

    ticket.cut();
    return ticket;
  }
// //..................................................
//
//   wifiprinting() async {
//     try {
//       print(" print in");
//      _printerManager.selectPrinter('192.168.0.100');
//      //_printerManager.selectPrinter(null);
//       final res =
//       await _printerManager.printTicket(await _ticket(PaperSize.mm80));
//       print(" print in");
//     } catch (e) {
//       print("error on print $e");
//     }
//   }



  Priter_Initial_Part(){
    if (Platform.isAndroid) {
      bluetoothManager.state.listen((val) {
        print('state = $val');
        if (!mounted) return;
        if (val == 12) {
          print('on');
          searchPrinter();
        } else if (val == 10) {
          print('off');
          setState(() => _devicesMsg = 'Bluetooth Disconnect!');
          blutoothEnable();
        }
      });
    } else {
      searchPrinter();
    }


  }

  void searchPrinter() {
    try {
      _printerManager.startScan(Duration(seconds: 2));
      _printerManager.scanResults.listen((val) {
        if (!mounted) return;
        setState(() =>_devices = val);
        if (_devices.isEmpty) setState(() => _devicesMsg = 'No Devices');
      });
    }
    catch(e){print("result for scan print $e");}
  }

  blutoothprinting(){
    print(" on blutoothprinting");
    for(int i=0;i<_devices.length;i++){
      if(_devices[i].address=="00:11:22:33:44:55"){
        print("find _devices");
        print(_devices.length.toString());
        print(_devices[i].address);
        print(_devices[i].name);
        print(i.toString());
        _startPrint(_devices[i]);
        // dispose();
        break;
      }
    }

    print("not find _devices");

  }

  Future<void> _startPrint(PrinterBluetooth printer) async {
    _printerManager.selectPrinter(printer);
    final result = await _printerManager.printTicket(await _ticket(PaperSize.mm58));
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(result.msg),
      ),
    );
  }


/*Show dialog if blutooth not enabled and open settings blutooth*/
  Future blutoothEnable() async {
    if (Theme.of(context).platform == TargetPlatform.android) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Blutooth is Off ?",
                style: TextStyle(color: Colors.red),
              ),
              content:
              const Text('Please make sure you enabled Blutooth for Printing'),
              actions: <Widget>[

                SizedBox(width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      TextButton(
                          child: Text('Cancel',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      Spacer(),
                      TextButton(
                          child: Text('Enable',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                          onPressed: () {
                            final AndroidIntent intent = AndroidIntent(
                                action:
                                'android.settings.BLUETOOTH_SETTINGS');
                            intent.launch();
                            Navigator.of(context, rootNavigator: true).pop();
                            // _gpsService();
                          }),
                    ],
                  ),
                )
              ],
            );
          });
    }
  }

  ///-----------------URL Print--------------------------------------
  UrlLaunch(url)async{
    //  var  _url ='http://gterpdemo.qizo.in/#/GtMobliepurchasePrint?Sid=1&uBr=$branchId&uNm=$userName&uP=$password';
    print("yuyuiyi");
    print(url);
    if (!await launch(url)) throw 'Could not launch $url';
  }




  ///---------------------------PDF Print--------------------------------------

  PdfPrint(id){

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Pdf_Print(Parm_Id: id,)));

  }

//----------------------Print part End-----------------------------------------






}









// class  UnitType {
//   // "id": 2,
//   // "description": "Box 10s",
//   // "nos": 10.0,
//   // "formalName": "Box 10",
//   // "unitUnder": 1,
//   // "isSimple": true,
//   // "groupUnder": "Number"
//
//   int id;
//   dynamic description;
//   double nos;
//   dynamic formalName;
//   int unitUnder;
//   bool isSimple;
//   dynamic groupUnder;
//
//
//
//   UnitType(
//       {
//         this.id,
//         this.description,
//         this.nos,
//         this.formalName,
//         this.unitUnder,
//         this.isSimple,
//         this.groupUnder,
//       });
//
//   UnitType.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     description = json['description'];
//     nos = json['nos'];
//     formalName = json['formalName'];
//     unitUnder = json['unitUnder'];
//     isSimple = json['isSimple'];
//     groupUnder = json['groupUnder'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['description'] = this.description;
//     data['nos'] = this.nos;
//     data['formalName'] = this.formalName;
//     data['unitUnder'] = this.unitUnder;
//     data['isSimple'] = this.isSimple;
//     data['groupUnder'] = this.groupUnder;
//
//     return data;
//   }
// }








//-------------for sale edit-----------------------

class purchaseedit {
  int purchaseHeaderId;
  dynamic itemId;
  String itmCode;
  String itmName;
  String barcode;
  String batch;
  dynamic expDate;
  dynamic customColumn1;
  dynamic customColumn2;
  dynamic qty;
  dynamic rate;
  dynamic mrp;
  dynamic discountAmt;
  dynamic notes;
  dynamic cgstPer;
  dynamic sgstPer;
  dynamic igstPer;
  dynamic cessPer;
  dynamic cgStAmt;
  dynamic sgstAmt;
  dynamic igstAmt;
  dynamic cessAmt;
  dynamic taxId;
  dynamic txPercentage;
  bool taxInclusive;
  dynamic amountBeforeTax;
  dynamic amountIncludingTax;
  dynamic netTotal;
  dynamic taxAmount;
  dynamic unitId;
  dynamic nosInUnit;
  dynamic godownId;
  String gdnDescription;
  dynamic purchaseRate;
  dynamic salesRate;
  dynamic itemSlNo;
  dynamic gtStockId;
  dynamic Total_amt;
  dynamic gross;

  purchaseedit({
    required this.purchaseHeaderId,
    this.itemId,
    required this.itmCode,
    required this.itmName,
    required this.barcode,
    required this.batch,
    this.expDate,
    this.customColumn1,
    this.customColumn2,
    this.qty,
    this.rate,
    this.mrp,
    this.discountAmt,
    this.notes,
    this.cgstPer,
    this.sgstPer,
    this.igstPer,
    this.cessPer,
    this.cgStAmt,
    this.sgstAmt,
    this.igstAmt,
    this.cessAmt,
    this.taxId,
    this.txPercentage,
    required this.taxInclusive,
    this.amountBeforeTax,
    this.amountIncludingTax,
    this.netTotal,
    this.taxAmount,
    this.unitId,
    this.nosInUnit,
    this.godownId,
    required this.gdnDescription,
    this.purchaseRate,
    this.salesRate,
    this.itemSlNo,
    this.gtStockId,
    this.Total_amt,
    this.gross,
  });



  purchaseedit.fromJson(Map<String, dynamic> json) {
    purchaseHeaderId = json['purchaseHeaderId'];
    itemId = json["itemId"];
    itmCode = json["itmCode"];
    itmName = json["itmName"];
    barcode = json["barcode"];
    batch = json["batch"];
    expDate = json["expDate"];
    customColumn1 = json["customColumn1"];
    customColumn2 = json["customColumn2"];
    qty = json["qty"];
    rate = json["rate"];
    mrp = json["mrp"];
    discountAmt = json["discountAmt"];
    notes = json["notes"];
    cgstPer = json["cgstPer"];
    sgstPer = json["sgstPer"];
    igstPer = json["igstPer"];
    cessPer = json["cessPer"];
    cgStAmt = json["cgStAmt"];
    sgstAmt = json["sgstAmt"];
    igstAmt = json["igstAmt"];
    cessAmt = json["cessAmt"];
    taxId = json["taxId"];
    txPercentage = json["txPercentage"];
    taxInclusive = json["taxInclusive"];
    amountBeforeTax = json["amountBeforeTax"];
    amountIncludingTax = json["amountIncludingTax"];
    netTotal = json["netTotal"];
    taxAmount = json["taxAmount"];
    unitId = json["unitId"];
    nosInUnit = json["nosInUnit"];
    godownId = json["godownId"];
    gdnDescription = json["gdnDescription"];
    purchaseRate = json["purchaseRate"];
    salesRate = json["salesRate"];
    itemSlNo = json["itemSlNo"];
    gtStockId = json["gtStockId"];
    Total_amt = json["Total_amt"];
    gross = json["gross"];

  }

}


//-------------for Gown----------------------
// class  Godown{
//
//   int gdnId;
//   dynamic gdnDescription;
//
//
//
//   Godown( {this.gdnId, this.gdnDescription, });
//   Godown.fromJson(Map<String, dynamic> json) {
//     gdnId = json['gdnId'];
//     gdnDescription = json['gdnDescription'];
//
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['gdnId'] = this.gdnId;
//     data['gdnDescription'] = this.gdnDescription;
//     return data;
//   }
// }
//--------------------------------------------------






class purModel {
  dynamic itemId;
  String itmCode;
  String itmName;
  String barcode;
  String batch;
  dynamic expDate;
  dynamic customColumn1;
  dynamic customColumn2;
  dynamic qty;
  dynamic rate;
  dynamic mrp;
  dynamic discountAmt;
  dynamic notes;
  dynamic cgstPer;
  dynamic sgstPer;
  dynamic igstPer;
  dynamic cessPer;
  dynamic cgStAmt;
  dynamic sgstAmt;
  dynamic igstAmt;
  dynamic cessAmt;
  dynamic taxId;
  dynamic txPercentage;
  bool taxInclusive;
  dynamic amountBeforeTax;
  dynamic amountIncludingTax;
  dynamic netTotal;
  dynamic taxAmount;
  dynamic unitId;
  dynamic nosInUnit;
  dynamic godownId;
  String gdnDescription;
  dynamic purchaseRate;
  dynamic salesRate;
  dynamic itemSlNo;
  dynamic gtStockId;
  dynamic Total_amt;
  dynamic gross;
  purModel({
    this.itemId,
    required this.itmCode,
    required this.itmName,
    required this.barcode,
    required this.batch,
    this.expDate,
    this.customColumn1,
    this.customColumn2,
    this.qty,
    this.rate,
    this.mrp,
    this.discountAmt,
    this.notes,
    this.cgstPer,
    this.sgstPer,
    this.igstPer,
    this.cessPer,
    this.cgStAmt,
    this.sgstAmt,
    this.igstAmt,
    this.cessAmt,
    this.taxId,
    this.txPercentage,
    required this.taxInclusive,
    this.amountBeforeTax,
    this.amountIncludingTax,
    this.netTotal,
    this.taxAmount,
    this.unitId,
    this.nosInUnit,
    this.godownId,
    required this.gdnDescription,
    this.purchaseRate,
    this.salesRate,
    this.itemSlNo,
    this.gtStockId,
    this.Total_amt,
    this.gross,
  });



  purModel.fromJson(Map<String, dynamic> json) {
    itemId = json["itemId"];
    itmCode = json["itmCode"];
    itmName = json["itmName"];
    barcode = json["barcode"];
    batch = json["batch"];
    expDate = json["expDate"];
    customColumn1 = json["customColumn1"];
    customColumn2 = json["customColumn2"];
    qty = json["qty"];
    rate = json["rate"];
    mrp = json["mrp"];
    discountAmt = json["discountAmt"];
    notes = json["notes"];
    cgstPer = json["cgstPer"];
    sgstPer = json["sgstPer"];
    igstPer = json["igstPer"];
    cessPer = json["cessPer"];
    cgStAmt = json["cgStAmt"];
    sgstAmt = json["sgstAmt"];
    igstAmt = json["igstAmt"];
    cessAmt = json["cessAmt"];
    taxId = json["taxId"];
    txPercentage = json["txPercentage"];
    taxInclusive = json["taxInclusive"];
    amountBeforeTax = json["amountBeforeTax"];
    amountIncludingTax = json["amountIncludingTax"];
    netTotal = json["netTotal"];
    taxAmount = json["taxAmount"];
    unitId = json["unitId"];
    nosInUnit = json["nosInUnit"];
    godownId = json["godownId"];
    gdnDescription = json["gdnDescription"];
    purchaseRate = json["purchaseRate"];
    salesRate = json["salesRate"];
    itemSlNo = json["itemSlNo"];
    gtStockId = json["gtStockId"];
    Total_amt = json["Total_amt"];
    gross = json["gross"];

  }

// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = new Map<String, dynamic>();
//   data['itmName'] = this.itmName;
//   data['ItemSlNo'] = this.ItemSlNo;
//   // data['shid'] = this.shid;
//   data['itemId'] = this.itemId;
//   data['qty'] = this.qty;
//   data['rate'] = this.rate;
//   data['disPercentage'] = this.disPercentage;
//   data['cgstPercentage'] = this.cgstPercentage;
//   data['sgstPercentage'] = this.sgstPercentage;
//   data['cessPercentage'] = this.cessPercentage;
//   data['discountAmount'] = this.discountAmount;
//   data['cgstAmount'] = this.cgstAmount;
//   data['sgstAmount'] = this.sgstAmount;
//   data['cessAmount'] = this.cessAmount;
//   data['igstPercentage'] = this.igstPercentage;
//   data['igstAmount'] = this.igstAmount;
//   data['taxPercentage'] = this.taxPercentage;
//   data['taxAmount'] = this.taxAmount;
//   data['taxInclusive'] = this.taxInclusive;
//   data['amountBeforeTax'] = this.amountBeforeTax;
//   data['amountIncludingTax'] = this.amountIncludingTax;
//   data['netTotal'] = this.netTotal;
//   data['hsncode'] = this.hsncode;
//   data['gdnId'] = this.gdnId;
//   data['taxId'] = this.taxId;
//   data['rackId'] = this.rackId;
//   data['addTaxId'] = this.addTaxId;
//   data['unitId'] = this.unitId;
//   data['nosInUnit'] = this.nosInUnit;
//   data['barcode'] = this.barcode;
//   data['StockId'] = this.StockId;
//   data['BatchNo'] = this.BatchNo;
//   data['ExpiryDate'] = this.ExpiryDate;
//   data['Notes'] = this.Notes;
//   return data;
// }
}