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
import 'package:new_qizo_gt/salesindex.dart';
import 'package:new_qizo_gt/salesmanhome.dart';
import 'package:new_qizo_gt/shopvisited.dart';
import 'package:new_qizo_gt/urlEnvironment/urlEnvironment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'GT_Masters/AppTheam.dart';
import 'GT_Masters/Masters_UI/cuWidgets.dart';
import 'GT_Masters/Printing/PDF_Printer.dart';
import 'Local_Db/Local_db_Model/Test_offline_Sales.dart';
import 'Purchase.dart';
import 'Purchase_Index.dart';
import 'appbarWidget.dart';
import 'models/customeradditem.dart';
import 'models/customersearch.dart';
import 'models/finishedgoods.dart';
import 'models/paymentcondition.dart';
import 'models/userdata.dart';
import 'models/usersession.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';
// import 'package:esc_pos_printer/esc_pos_printer.dart';

import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'dart:io';

import 'newtestpage.dart';



class PurchaseReturn extends StatefulWidget {

  dynamic itemrowdata=[];
  int passvalue;
  dynamic passname;
  PurchaseReturn({required this.passvalue,this.passname,this.itemrowdata});




  @override
  _PurchaseReturnState createState() => _PurchaseReturnState();

}

class _PurchaseReturnState extends State<PurchaseReturn> {
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
  int TaxId=null;
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
  TextEditingController salesdeliveryController = new TextEditingController();
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
  static List<UnitType> unit = [];
  static List<Godown> Gdwn = [];
  static List<CustomerAdd> customerItemAdd = [];
  static List<Customer> users = [];
  static List<Pur_Rtn_Dtls_Model> PurRtnMdl = [];



  dynamic SalesEditDatas;
  dynamic Vouchnum;
  int itemGdwnId=null;
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
  TextEditingController ImportBillNumController = new TextEditingController();




  GlobalKey<AutoCompleteTextFieldState<Customer>> key =
  new GlobalKey(); //only one autocomplte
  String selectedPerson = "";
  late CustomerAdd customer;
  late Pur_Rtn_Dtls_Model _Pur_rtn_mdl;

  int? salesItemId = null;
  dynamic salesLedgerId = null;
  int? salesPaymentId = null;
  int? paymentType_Id = null;
  var Tax_IdNull=null;
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
  CUWidgets cw=CUWidgets();

  bool loading = true;
  final letters = 'abcdefghijklmnopqrstuvwxyz'.split('');

  var dataForTicket;
  var footerCaptions;
  bool checkboxval = false;
  // PrinterNetworkManager _printerManager = PrinterNetworkManager();
  var Companydata;
  var retunid;
  late bool TaxTypeGst;
  var  paymentType=[{"id":0,"type":"Cash"},{"id":1,"type":"Credit"}];


  FocusNode rateFocus = FocusNode();
  FocusNode qtyFocus = FocusNode();
  FocusNode generalFocus = FocusNode();


  late SharedPreferences pref;

  dynamic slsname;
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
      final response = await http.get("${Env.baseUrl}getsettings",
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
      final response = await http.get(url, headers: {
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



  //--------------Get Inv no-----------------------
  var VchNum=null;

  GetVchnum()async {
    try {
      final response =
      await http.get("${Env.baseUrl}getSettings/1/gtpurchasertn" as Uri, headers: {
        "Authorization": user.user["token"],
      });
      print(response.statusCode);

      if (response.statusCode == 200) {
        print("VchNum");
        var resdata = json.decode(response.body);
        print("VchNum is");
        print(resdata.toString()); //used  this to autocomplete
        VchNum=resdata[0]["vocherNo"];
      }
    } catch (e) {
      print("error on  GetVchnum $e");
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


  getPaymentCondition() async {
    String url = "${Env.baseUrl}Mconditions";
    try {
      final res =
      await http.get(url as Uri, headers: {"Authorization": user.user["token"]});

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
      await http.get(url as Uri, headers: {"Authorization": user.user["token"]});
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


  ///------------multiple item select-------------------
  var SelectedRowData=[];
  var SelectedRowDataSAmple=[];
  TextEditingController QtyController = new TextEditingController();
  bool ShowAllItem=false;
  var Net_VAt=0.0;
  var Net_Amt_Befor_Tax=0.0;
  ///-------------------------------

//for test ..........
//   PurchaseRtnSave() async {
//
//     print("sales length");
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
      TblDatalength=PurRtnMdl.length;
    }else{
      TblDatalength=SalesEditDatas.length;
    }
    if(TblDatalength< 1){

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

        if (salesLedgerId == null || customerController.text == "") {
          setState(() {
            print("salesLedgerId $salesLedgerId");
            customerSelect = true;
            return;
          });
        } else {
          setState(()  {
            customerSelect = false;
            slsname=customerController.text;
          });
          PurchaseRtnSave();
        }
      } else {
        setState(()  {
          customerSelect = false;
          slsname=customerController.text;
        });
        print("juio");
        PurchaseRtnSave();

      }
    }
    else{

      setState(() {
        paymentTypeSelect=true;
      });
    }

  }


//  sales save function ------------------------------------------------------

  PurchaseRtnSave() async {
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


        // if (salesLedgerId == 0 || customerController.text == "") {
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




      final url = "${Env.baseUrl}PurchaseRtnHeaders";
      // print("sales length");
      // print(sales.length);
      // print(sales);
      // print("list length");
      // print(customerItemAdd.length);
      delivery = "";
      delivery = salesdeliveryController.text.toString();
      var remarks = generalRemarksController.text.toString();
      // print("sales ledger Id");
      // print(salesLedgerId);
      // print("sales Item Id");
      // print(salesItemId);
      // print("sales payment Id");
      // print(salesPaymentId);
      // print("server date");
      // print(serverDate);
      // print("delivery date");
      // print(deliveryDate);
      // print("remarks");
      if(widget.itemrowdata !=null){ //add godown id for sals order converted data
        print("Datas from sales order");
        for(int i=0;i<PurRtnMdl.length;i++)
        {
          if(PurRtnMdl[i].godownId==null ||PurRtnMdl[i].godownId==0){
            print("gdnId is null");
            PurRtnMdl[i].godownId=itemGdwnId;
          }
        }

      }


      var param = json.encode(PurRtnMdl);
      print("itms are : $param");

      // print("Saless : $sales");
      if ( deliveryDateSelect || paymentSelect
          || customerItemAdd.length <= 0 || PurRtnMdl.length <= 0 ||godownController.text==""||customerController.text==""||paymentTypeController.text.toString()=="null") {
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

        var  exDate =DateTime.parse(serverDate);
        var param = json.encode(PurRtnMdl);
        print("Validation Complited itms are : $param");
        var req = {

          "voucherDate": serverDate,
          "invNo":InvNoController.text,
          "invDate":serverDate,
          "ledgerId":salesLedgerId,
          "adjust": null,
          "narration": null,
          "discount": null,
          "type": true,
          "vehicle": null,
          "netAmount":grandTotal,
          "userId": userId,
          "branchId": branchId,
          "cancelflg": null,
          "cancelRemarks": null,
          "purchaseHeaderId": null,
          "againstInvoice": "true",
          "paymentType":paymentType_Id,
          "ledger": null,
          "purchaseHeader": null,
          "purchaseVoucherNo": null,
          "lhName": customerController.text,
          "partyName": customerController.text,
          "voucherNo": VchNum,
          "purchaseRtnDetailed":[
            for(int i = 0; i < PurRtnMdl.length; i++)
              {
                "itemId": PurRtnMdl[i].itemId,
                "godownId": itemGdwnId,
                "batch": null,
                "expDate": null,
                "customColumn1": null,
                "customColumn2": null,
                "notes": null,
                "qty":PurRtnMdl[i].qty,
                "rate":PurRtnMdl[i].rate,
                "mrp":PurRtnMdl[i].amountIncludingTax,
                "salesRate":PurRtnMdl[i].amountIncludingTax,
                "purchaseRate":PurRtnMdl[i].amountIncludingTax,
                "discountAmt": 0,
                "cgstPer":PurRtnMdl[i].cgstPer,
                "sgstPer":PurRtnMdl[i].sgstPer,
                "igstPer":PurRtnMdl[i].igstPer,
                "cgStAmt":PurRtnMdl[i].cgStAmt,
                "sgstAmt":PurRtnMdl[i].sgstAmt,
                "igstAmt":PurRtnMdl[i].igstAmt,
                "gross":PurRtnMdl[i].amountIncludingTax,
                "Total_amt":PurRtnMdl[i].amountIncludingTax,
                "barcode":null,
                "unitId":PurRtnMdl[i].unitId,
                "taxId":PurRtnMdl[i].taxId,
                "taxInclusive": true,
                "amountBeforeTax":PurRtnMdl[i].amountBeforeTax,
                "amountIncludingTax":PurRtnMdl[i].amountIncludingTax,
                "netTotal":PurRtnMdl[i].amountIncludingTax,
                "itemSlNo":i

              }
          ],
          "listPurchaseExpense": []
        };
        print("req $req");


        var params = json.encode(req);
        //  print(params.toString());
        print("iouioiououi");
        debugPrint(params);


        var res = await http.post(url as Uri,
            headers: {
              'accept': 'application/json',
              'content-type': 'application/json',
              'Authorization': user.user["token"],
              'deviceId': user.deviceId
            },
            body: params);

        print("PurchaseRtnSave : " + res.statusCode.toString());
        print("PurchaseRtnSave : " + res.body.toString());
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
            } else {

              retunid = await jsonDecode(res.body);
              // GetdataPrint(retunid['id']);
              setState((){
                Resetfunction();
                customerItemAdd.clear();
                PurRtnMdl.clear();
                customerController.text = "";
                salesdeliveryController.text = "";
                generalRemarksController.text = "";
                paymentController.text = "";

                salesLedgerId = null;
                salesItemId = null;
                salesPaymentId = null;
                grandTotal = 0;
              });

              showDialog(
                  context: context,
                  builder: (context) =>
                      AlertDialog(
                        title: Center(child: Text("Success")),
                      ));
              rateSelect = false;
              quantitySelect = false;
              Timer(Duration(milliseconds: 500,), () {
                print("Yeah, this line is printed after 2 seconds");
                salesdeliveryController.text=DateFormat("dd-MM-yyyy").format(DateTime.now());
                // GetdataPrint(retunid['id']);
                //  var  _url ='http://gterpdemo.qizo.in/#/GtMoblieSalesPrint?Sid=${retunid['id']}&uBr=$branchId&uNm=$userName&uP=$password';
                // UrlLaunch(_url);
                // PdfPrint(retunid['id']);
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
      int id =widget.passvalue;
      final url = "${Env.baseUrl}PurchaseRtnHeaders/$id";
      print("id=   $id");
      //print(salesedt.length);
      //print(salesedt);
      //print("list length");
      //print(customerItemAdd.length);
      delivery = "";
      delivery = salesdeliveryController.text.toString();
      var remarks = generalRemarksController.text.toString();

      //print("sales ledger Id");
      //print(salesLedgerId);
      //print("sales Item Id");
      //print(salesItemId);
      //print("sales payment Id");
      //print(salesPaymentId);
      //print("server date");
      //print(serverDate);
      //print("delivery date");
      //print(deliveryDate);
      // print("remarks");
      // print(SalesEditDatas);
      //  var param = json.encode(salesedt);
      // print("aaaasales : $param");

      var req = {
        "id":widget.passvalue,
        "voucherNo": SalesEditDatas["listHeader"][0]["voucherNo"],                            //on edit
        "voucherDate":DateOnlyFormat.format(DateTime.now()), //serverDate.toString(),
        "orderHeadId": null,
        "orderDate": null,
        "expDate": SalesEditDatas["listHeader"][0]["expDate"].toString(),
        //"ledgerId":SalesEditDatas["listHeader"][0]["ledgerId"].toString(),//salesLedgerId
        "partyName": slsname,
        "address1": null,
        "address2": null,
        "gstNo": null,
        "phone": null,
        "shipToName": null,
        "shipToAddress1": null,
        "shipToAddress2": null,
        "shipToPhone": null,
        "narration": remarks,
        "amount": grandTotal,
        "userId":  userId,
        "branchId": branchId,
        "otherAmt": 0.00,
        "discountAmt": 0.00,
        "creditPeriod": null,
        "paymentCondition": "",
        "paymentType": 0,
        "invoiceType": "BtoB",
        "invoicePrefix": null,
        "invoiceSuffix": null,
        "cancelFlg": null,
        "entryDate":null,// serverDate.toString(),
        "slesManId": null,
        "branchUpdated":false,
        "saleTypeInterState":false,
        //
        "adjustAmount":0.0,
        "adlDiscAmount":0.0,
        "adlDiscPercent":0.0,
        "balanceAmount":0.0,
        "cashReceived":0.0,
        "otherAmountReceived":0.0,
        "listDetails": PurRtnMdl,
        "salesExpense": []
      };

      print(req);
      print(jsonEncode(PurRtnMdl).toString());
      // return;

      setState(() {
        if (salesLedgerId == null || customerController.text == "") {
          customerSelect = true;
        } else {
          customerSelect = false;
        }

        // if (salesPaymentId == 0 || paymentController.text == "") {
        //   paymentSelect = true;
        // } else {
        //   paymentSelect = false;
        // }
        if (delivery != "") {
          deliveryDateSelect = false;

          return;
        } else {
          deliveryDateSelect = true;
        }
      });
      // print("Saless : $sales");

      setState(() {

      });
      if (customerSelect || deliveryDateSelect || paymentSelect
          || customerItemAdd.length <= 0 ||PurRtnMdl.length <=0) {


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
        var res = await http.put(url as Uri,
            headers: {
              'accept': 'application/json',
              'content-type': 'application/json',
              'Authorization': user.user["token"],
              'deviceId': user.deviceId
            },
            body: params);
        //  print("saveddd");
        print("PurchaseRtnHeaders of edit : "+res.statusCode.toString());
// testing------
        if (res.statusCode == 204) {

          showDialog(
              context: context,
              builder: (context) =>
                  AlertDialog(
                    title: Text("Sales Updated"),
                  ));
          rateSelect = false;
          quantitySelect = false;


          setState(() {
            Resetfunction();
            customerItemAdd.clear();
            PurRtnMdl.clear();
            customerController.text = "";
            salesdeliveryController.text = "";
            generalRemarksController.text = "";
            paymentController.text = "";
            salesLedgerId=null;
            salesItemId =null;
            salesPaymentId =null;
            grandTotal = 0;
            Resetfunction();
            var  _url ='http://gterpdemo.qizo.in/#/GtMoblieSalesPrint?Sid=${widget.passvalue}&uBr=$branchId&uNm=$userName&uP=$password';
            //UrlLaunch(_url);

          });
          Timer(Duration(seconds:1), () {
            print("this line is printed after 2 seconds");
            // Navigator.pop(context);
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => salesindex()));
            PdfPrint(widget.passvalue);
          });
        }
        //--------------------






        if (res.statusCode == 200 ||
            res.statusCode == 201 &&
                customerItemAdd.length > 0 &&
                PurRtnMdl.length > 0 &&
                salesLedgerId > 0 ) {
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
                PurRtnMdl.clear();
                customerController.text = "";
                salesdeliveryController.text = "";
                generalRemarksController.text = "";
                paymentController.text = "";
                salesLedgerId =null;
                salesItemId =null;
                salesPaymentId=null;
                grandTotal = 0;
                Resetfunction();
              });

              showDialog(
                  context: context,
                  builder: (context) =>
                      AlertDialog(
                        title: Text("Sales Updated"),
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
      salesLedgerId = widget.passvalue;
      getCustomerLedgerBalance(salesLedgerId);
      slsname=widget.passname;
      salesdeliveryController.text=widget.itemrowdata['voucherDate'];
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
      GetVchnum();
      GeneralSettings();
      salesdeliveryController.text=DateFormat("dd-MM-yyyy").format(DateTime.now());

      // if(widget.itemrowdata ==null)//for  sales create
      //     {
      print("itemrowdata...null");
      btnname="Save";
      getCustomerLedgerBalance(0);
      //printer function...
      // }
      // else
      // {
      //   print("itemrowdata...have it"+  widget.itemrowdata["id"].toString()); // from sales list
      //   databinding( widget.itemrowdata["id"]);
      //   btnname="Update";
      // }

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
      salesLedgerId ==null;
      openingAmountBalance = 0;
      print(customerController.text);
      print("item");
    });
  }

  itemIdListener() {
    setState(() {
      print("Item    .....................");
      //salesItemId = 0;
      print(goodsController.text);
    });
  }

  paymentIdListener() {
    print("payment");
    salesPaymentId == null;

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
    setState(() {
      if (salesItemId == null || goodsController.text == "") {
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
        salesItemId == null ||rateController.text == "0.0") {
      print("check fields");
      print(salesItemId);
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
    // print(amount);
    // print(customerItemAdd.length);
    print(goodsController.text);
    dynamic itmName=goodsController.text;
    // print(quantityController.text);
    // print(rateController.text);
//    _markers.add(Marker(
//        markerId: MarkerId("Marker id"),
//    position: latLng,
//    infoWindow: InfoWindow(
//    title: 'Your Location',
//    snippet: 'More info',
//    ),
    dynamic  aftertax=0;
    dynamic  befortax=0;
    var igst=0.00;



    setState(() {
      var rate= double.parse(rateController.text);
      dynamic Igst=double.parse(((rate/100)*Igstper).toStringAsFixed(2));
      print("amount  $amount");

      ///--------test calc with tax----------------



      var taxOneItm;
      var taxAmtOfCgst;
      var taxAmtOfSgst;
      var  ToatalTax;


      if(TaxInOrExc==true){
        var WithOutTaxamt=((itmtxper+100)/100);
        taxOneItm=rate/WithOutTaxamt;
        taxAmtOfCgst=(WithOutTaxamt/2);
        taxAmtOfSgst=(WithOutTaxamt/2);
        aftertax= amount;
        befortax=taxOneItm*double.parse(quantityController.text);
        grandTotal = grandTotal + aftertax;
      }
      else{

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

        igst=0.0;
        taxAmtOfCgst=0.0;
        taxAmtOfSgst=0.0;

      }


      Net_VAt=Net_VAt+(aftertax-befortax);
      print("aftertax".toString());
      print(aftertax.toString());
      print(befortax.toString());
      print(Net_VAt.toString());
      print((aftertax-befortax).toString());





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


      _Pur_rtn_mdl = Pur_Rtn_Dtls_Model(
        itmName:itmName,
       // itemSlNo:customerItemAdd.length + 1,//slnum,

        itemId:salesItemId,
        qty:double.parse(quantityController.text),
        rate:double.parse(rateController.text),
        //disPercentage:0,
        cgstPer:CgstPer,
        sgstPer:SgstPer,
        cessPer:0,
        discountAmt:0,
        cgStAmt: taxAmtOfCgst,
        sgstAmt:taxAmtOfSgst,
        cessAmt:0,
        igstPer:Igstper,
        igstAmt:igst,
        txPercentage:itmtxper,
        taxAmount:(aftertax-befortax),
        // taxAmount:(((double.parse(rateController.text))/100)*(itmtxper))*double.parse(quantityController.text),
        taxInclusive:false,
        amountBeforeTax:befortax,
        amountIncludingTax:aftertax,
        netTotal:aftertax,
       // hsncode:Hsncode??"",
        godownId:itemGdwnId,//1
        taxId:TaxId??Tax_IdNull,
       // rackId:null,
       // addTaxId:TaxId??Tax_IdNull,
        unitId:unitId,
        nosInUnit:unitId,
        barcode:Brcode,
        // stockId:StkId,
        batch:batchnum,
        expDate:Edate,
        notes:null,
      );

      PurRtnMdl.add(_Pur_rtn_mdl);
      print(".............");
      print(_Pur_rtn_mdl.itemId);
      print(_Pur_rtn_mdl.qty);
      print(_Pur_rtn_mdl.rate);
      print(PurRtnMdl);
      var param = json.encode(PurRtnMdl);
      print("sales : $param");
      print("............");


    });


    customer = CustomerAdd(
        id: salesItemId,
        slNo: customerItemAdd.length + 1,
        item: goodsController.text,
        quantity: double.parse(quantityController.text),
        rate: double.parse(rateController.text),
        txper:itmtxper,
        cess:cessper,
        NetAmt:aftertax,
        amount: amount,
        StkId:StkId,
        txAmt:aftertax-befortax
    );

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
    print("on delete$sl");
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
    // customerItemAdd.removeWhere((element) => element.slNo == sl && element.id==id );
    // PurRtnMdl.removeWhere((element) => element.itemSlNo == sl && element.itemId==id );

    customerItemAdd.removeWhere((element) =>  element.slNo == sl && element.id==id );
    PurRtnMdl.removeWhere((element) => element.itemId==id );

    // grandTotal = grandTotal - amount;
    setState(() {
      //
      // double taxamt=0.0;
      // taxamt= amount+((amount/100)*(itmtxper+cessper));
      // grandTotal=  (grandTotal-taxamt);
      //

      // grandTotal=  (grandTotal-amount); //with out tax

      print("end deleted");
      print(grandTotal);
      print("sales.length= "+PurRtnMdl.length.toString());

      if(PurRtnMdl.length==0){
        grandTotal=0;
        Net_Amt_Befor_Tax=0.0;
        Net_VAt=0;
      }
      // slnum=slnum-1;
    });


  }

  Future<bool> _onBackPressed() {
    // Navigator.pop(context,salesLedgerId);
    Navigator.pop(context);
    customerItemAdd=[];
    Resetfunction();

    // Return a Future containing false so that the back press is intercepted
    // and the system doesn't do anything further
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
                                          label: Text('Qty'),
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
                                              Text(
                                                  '${itemRow['qty'].toString()}'),
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


        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) =>
              AlertDialog(
                actions: [
                  Container(
                      height: 60,
                      width: 350,
                      child:  Center(
                          child: Text("Stock Not Available...!",style:TextStyle(color: Colors.redAccent,fontSize: 20),)
                      )),

                ],
              ),
        );
        Timer(Duration(seconds: 1), () {
          Navigator.pop(context);
        });
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
    salesItemId =id;
    itemGdwnId=rowdata['godownId'].toString()=="null"?itemGdwnId:rowdata['godownId'];
    print(id.toString());
    String url = "${Env.baseUrl}GtItemMasters/$salesItemId";
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

      print("close.... $salesItemId");



      // salesItemId = tagsJson["id"];
      goodsController.text = tagsJson["itmName"];


      // print("nnnnn $salesItemId");
      // print("nnnnn "+goodsController.text);


      (tagsJson["txPercentage"] == null ||tagsJson["txPercentage"] == "null") ? itmtxper=0.0:itmtxper =tagsJson["txPercentage"];
      (tagsJson["atPercentage"] == null ||tagsJson["atPercentage"] == "null") ? cessper=0.0:cessper =tagsJson["atPercentage"];
      (tagsJson["description"] == null ||tagsJson["description"] == "null") ?  UnitController.text="": UnitController.text =tagsJson["description"];
      (tagsJson["itmUnitId"] == null ||tagsJson["itmUnitId"] == "null") ? unitId=null: unitId =tagsJson["itmUnitId"];
      (tagsJson["itmHsn"] == null ||tagsJson["itmHsn"]  == "null") ?  Hsncode ="": Hsncode =tagsJson["itmHsn"];
      (tagsJson["txCgstPercentage"] == null ||tagsJson["txCgstPercentage"] == "null") ?  CgstPer =0: CgstPer =tagsJson["txCgstPercentage"];
      (tagsJson["txSgstPercentage"] == null ||tagsJson["txSgstPercentage"] == "null") ?  SgstPer =0: SgstPer =tagsJson["txSgstPercentage"];
      (tagsJson["txIgstpercentage"] == null ||tagsJson["txIgstpercentage"] == "null") ?  Igstper =0: Igstper =tagsJson["txIgstpercentage"];
      (tagsJson["itmTaxId"] == null ||tagsJson["itmTaxId"]  == "null") ?  TaxId=null: TaxId =tagsJson["itmTaxId"];
      TaxInOrExc=tagsJson["itmTaxInclusive"];


      // (tagsJson["itmSalesRate"] == null ||tagsJson["itmSalesRate"]  == "null") ? rateController.text="": Srate =tagsJson["itmSalesRate"];
      //rateController.text=Srate.toString();
      //Srate=rowdata['itmSalesRate'];
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
    PurRtnMdl.clear();
    customerController.text = "";
    //salesdeliveryController.text = "";
    generalRemarksController.text = "";
    paymentController.text = "";
    grandTotal = 0;
    salesPaymentId = null;
    salesItemId = null;
    salesLedgerId = null;
    UnitController.text="";
    unitId=null;
    unitSelect=false;
    quantityController.text="";
    goodsController.text="";
    slnum=0;
    rateController.text="";
    paymentTypeController.text="";
    paymentType_Id=null;
    paymentTypeSelect=false;
    godownController.text="";
    itemGdwnId=null;
    Net_Amt_Befor_Tax=0.0;
    Net_VAt=0.0;
    GetVchnum();
    GetGodown();
    salesdeliveryController.text=DateFormat("dd-MM-yyyy").format(DateTime.now());

  }


//-------------------------------------------------------
  itemReEditing(CustomerAdd items)async{
    setState(() {
      ItemsAdd_Widget_Visible=true;
    });
    try{
      dynamic itemdata=[];
      itemdata={
        "id":items.id,
        "itemId":items.id,
        "expiryDate":null,
        "srate":items.rate,
        "batchNo":null,
        "nos":null,
        "barcode":null,
        "godownId":itemGdwnId
      };
      print(itemdata);
      multibatchitembinding(itemdata);
      // removeListElement(items.id,
      //     items.slNo, items.NetAmt);

    }catch(e)
    {print("error on itemReEditing $e");}

    quantityController.text=items.quantity.toString();

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
      final jsonres =
      await http.get((Env.baseUrl+"GtitemMasters/1/${result.rawContent}/barcode") as Uri, headers: {"Authorization": user.user["token"]});
      print("batch data");
      print(jsonres.statusCode);
      var tagsJson = jsonDecode(jsonres.body);
      print(tagsJson);
      print(tagsJson["result"][0]["id"]);

      print(result.formatNote);
      setState(() {
        getbatch(tagsJson["result"][0]["id"]);
        quantityController.text="1";
        // goodsController.text=result.rawContent.toString();
        FocusScope.of(context).requestFocus(rateFocus);

      });
    }
    catch(e) {  print("Error on qr_Barcode_Readfunction $e");}

  }





  ///-----------------------multiple item Select--------------------------------

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
                                    0.0:itemRow.itmPurchaseRate.toString()}'),
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
    print("SelectedRows");
    print(data.itmUnitId);
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
    print("ItemPushToArray");
    print(data.itmUnitId.toString());

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
      "unitId":data.itmUnitId,
      "itmUnitId":data.itmUnitId,
      "txCgstPercentage":data.txCgstPercentage,
      "txSgstPercentage":data.txSgstPercentage,
      "txIgstpercentage" :data.txIgstpercentage,
      "itmTaxId" :data.itmTaxId,
      "itmSalesRate" :data.itmSalesRate,
      "itmStkTypeId":data.itmStkTypeId
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
      itmtxper=SelectedRowDataSAmple[i]["txPercentage"]??0.0;
      TaxInOrExc=SelectedRowDataSAmple[i]["itmTaxInclusive"]??false;
      rate= SelectedRowDataSAmple[i]["itmPurchaseRate"]??0.0;
      var Qty= double.parse(SelectedRowDataSAmple[i]["qty"]??0);
      amount=rate*Qty;
      if(TaxInOrExc==true){

        var WithOutTaxamt=((SelectedRowDataSAmple[i]["txPercentage"]+100)/100);
        taxOneItm=rate/WithOutTaxamt;
        taxAmtOfCgst=(WithOutTaxamt/2);
        taxAmtOfSgst=(WithOutTaxamt/2);
        aftertax= amount;
        befortax=taxOneItm*Qty;
        grandTotal = grandTotal + aftertax;

      }
      else{

        taxOneItm =((rate/100)*(SelectedRowDataSAmple[i]["txPercentage"]??0.0));
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

        igst=0.0;
        taxAmtOfCgst=0.0;
        taxAmtOfSgst=0.0;

      }


      _Pur_rtn_mdl = Pur_Rtn_Dtls_Model(
        itmName: SelectedRowDataSAmple[i]["itmName"],
        // Total_amt:grandTotal,
        amountBeforeTax:befortax,
        amountIncludingTax:aftertax,
        barcode:Brcode,
        //batch:null,
        cessAmt:0,
        cessPer:0,
        cgStAmt:taxAmtOfCgst,
        cgstPer:SgstPer,
       // discountAmount:0,
        expDate:Edate,
        godownId:itemGdwnId,
        igstAmt:igst,
        igstPer:Igstper,
        itemId:SelectedRowDataSAmple[i]["id"],
        //itemSlNo:i,
        netTotal:aftertax,
        nosInUnit:nosunt,
        notes:null,
        //purchaseRate:aftertax,
        qty:Qty,
        rate:rate,
        sgstAmt:taxAmtOfSgst,
         sgstPer:SgstPer,
        taxAmount:aftertax-befortax,
        taxId:SelectedRowDataSAmple[i]["itmTaxId"],
        taxInclusive:false,
        unitId:SelectedRowDataSAmple[i]["unitId"],
      //  addTaxId:SelectedRowDataSAmple[i]["itmTaxId"],
        txPercentage:SelectedRowDataSAmple[i]["txPercentage"],
      //  stockId:SelectedRowDataSAmple[i]["itmStkTypeId"],
      );

      PurRtnMdl.add(_Pur_rtn_mdl);
      print("............");





      customer = CustomerAdd(
          id: SelectedRowDataSAmple[i]["id"],
          slNo: i,
          item: SelectedRowDataSAmple[i]["itmName"],
          quantity:  double.parse(SelectedRowDataSAmple[i]["qty"]),
          rate:  SelectedRowDataSAmple[i]["itmPurchaseRate"],
          txper: SelectedRowDataSAmple[i]["txPercentage"],
          cess: null,
          NetAmt: aftertax,
          amount:amount ,
          StkId: SelectedRowDataSAmple[i]["itmStkTypeId"],
          txAmt:aftertax-befortax
      );

      customerItemAdd.add(customer);
    }
    print(customer);

    //var bindData=[];
    print(customerItemAdd.length);
    setState(() {
      ItemsAdd_Widget_Visible=false;
    });
  }



  ImportRtnData(id)async{
    Resetfunction();
    print("sales for print : $id");
    try {
      final tagsJson =
      await http.get("${Env.baseUrl}PurchaseHeaders/$id" as Uri, headers: {
        //Soheader //PurchaseRtnHeaders
        "Authorization": user.user["token"],
      });

      if(tagsJson.statusCode<210){
        var resData=json.decode(tagsJson.body);
        if(resData["listHeader"].toString()=="[]"){
          print("null");
          cw.MessagePopup(context,"Data Not Available", Colors.lightBlue);

        }else{
          print("not null");
          databinding(resData);
        }

      }
      else{
        cw.MessagePopup(context, "Enter Valid Bill Number", Colors.red.shade400);
      }


    }catch(e){

      print("error on ImportRtnData : $e");
    }
  }





  databinding(tagsJson) async{
    print(tagsJson);
    try {
      SalesEditDatas=tagsJson;
      (tagsJson["listHeader"][0]["narration"] == null)? generalRemarksController.text="":generalRemarksController.text=tagsJson["listHeader"][0]["narration"];
      customerController.text=tagsJson["listHeader"][0]["lhName"];
      salesLedgerId=tagsJson["listHeader"][0]["ledgerId"];

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
        paymentType_Id=tagsJson["listHeader"][0]["paymentType"];
        paymentTypeController.text=tagsJson["listHeader"][0]["paymentType"].toString()=="0"?
        "Cash":"Credit";
      });
      salesdeliveryController.text=bindDt;
      deliveryDate=bindDt;
      Vouchnum=tagsJson["listHeader"][0]["voucherNo"];
      List <dynamic> binditm =tagsJson["listDetails"]as List;
      print("binditm");
      print(binditm);
      for(int i=0;i<binditm.length;i++)
      {
        Net_VAt=Net_VAt+(binditm[i]["taxAmount"]);
        Net_Amt_Befor_Tax=Net_Amt_Befor_Tax+binditm[i]["amountBeforeTax"];
        print(binditm[i]["itmName"]);
        customer = CustomerAdd(
            id: binditm[i]["itemId"],
            slNo: customerItemAdd.length + 1,
            item: binditm[i]["itmName"],
            quantity:binditm[i]["qty"],
            rate: binditm[i]["rate"],
            txper: binditm[i]["taxPercentage"],
            amount: (binditm[i]["rate"])* (binditm[i]["qty"]),
            StkId:binditm[i]["stockId"],
            NetAmt: (binditm[i]["amountIncludingTax"]),
            txAmt:(binditm[i]["taxAmount"]??0.0)
        );

        setState(() {
          ++slnum;
          grandTotal=tagsJson["listHeader"][0]["netAmount"];
          _Pur_rtn_mdl = Pur_Rtn_Dtls_Model(
             // itemSlNo :slnum,
              itmName:binditm[i]["itmName"],
              itemId: binditm[i]["itemId"],
              qty: binditm[i]["qty"],
              rate:binditm[i]["rate"],
              //disPercentage: binditm[i]["disPercentage"]== null?0:binditm[i]["disPercentage"],
              cgstPer:binditm[i]["cgstPercentage"]== null?0:binditm[i]["cgstPercentage"],
              sgstPer: binditm[i]["sgstPercentage"],
              cessPer: binditm[i]["cessPercentage"],
              discountAmt: binditm[i]["discountAmount"],
              cgStAmt:binditm[i]["cgstAmount"],
              sgstAmt:binditm[i]["sgstAmount"],
              cessAmt: binditm[i]["cessAmount"],
              igstPer: binditm[i]["igstPercentage"],
              igstAmt: binditm[i]["igstAmount"],
              txPercentage:itmtxper == null?0:itmtxper,
              taxAmount: (binditm[i]["taxAmount"]??0.0),
              taxInclusive :false,
              amountBeforeTax: ( binditm[i]["rate"])* (binditm[i]["qty"]),
              amountIncludingTax: binditm[i]["amountIncludingTax"],
              //( binditm[i]["rate"])* (binditm[i]["qty"])+ ((binditm[i]["rate"]/100)*binditm[i]["taxPercentage"]),
              netTotal:binditm[i]["amountIncludingTax"],
              godownId:binditm[i]["gdnId"],
              taxId:binditm[i]["taxId"],
              // rackId:binditm[i]["rackId"],
              // addTaxId: binditm[i]["taxId"],
              unitId: binditm[i]["unitId"],
              nosInUnit: binditm[i]["unitId"],
              barcode: binditm[i]["barcode"],
              // stockId: binditm[i]["stockId"],
              batch: binditm[i]["batchNo"],
              expDate: binditm[i]["expiryDate"],
              notes:binditm[i]["Notes"],
              // hsncode:binditm[i]["hsncode"],
              // adlDiscAmount:binditm[i]["adlDiscAmount"],
              // adlDiscPercent:binditm[i]["adlDiscPercent"]
          );
          var parampars = json.encode(_Pur_rtn_mdl);
          PurRtnMdl.add(_Pur_rtn_mdl);
        });

        setState(() {
          // print("gggggg"+json.encode(_Sls_rtn_mdl));
          customerItemAdd.add(customer);

        });
      }

    }catch(e){ print("databinding1 error $e");}
  }


  ///-------------------------------------------------------------------------------



  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
//      key: scaffoldKey,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(190.0),
            child:  Appbarcustomwidget(uname: userName, branch: branchName, pref: pref, title:"Purchase Return")
        ),
        body: ListView(
          children: <Widget>[
            SizedBox(height: 10),


            SizedBox(height:TextBoxHeight,
              child: Row(
                children: [
                  SizedBox(width: 10),

                  Expanded(
                    child: TypeAheadField(
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
                                    salesLedgerId = null;
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
                              'customer search', // i need to decrease height
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
                          print("close.... $salesLedgerId");
                          slsname = suggestion.lhName;
                          print(suggestion.id);
                          print(".......sales Ledger id");
                          salesLedgerId = suggestion.id;
                          if (suggestion.id != null) {
                            getCustomerLedgerBalance(suggestion.id);
                          }
                          print(salesLedgerId);
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

                  IconButton(
                      icon: Icon(Icons.arrow_circle_down_sharp,size: 28,),
                      onPressed: () {
                        ImportBillNumController.text="";

                        showDialog(
                            context: context,
                            builder: (c) => AlertDialog(

                                content:cw.CUTestbox(label: "Bill Num",controllerName: ImportBillNumController,),
                                actions: [
                                  TextButton(
                                    child: Text("OK",style: TextStyle(color:theam.saveBtn_Clr),),
                                    onPressed: () {
                                      setState(() {
                                        ImportRtnData(ImportBillNumController.text.trim());
                                        Navigator.pop(
                                            context); // this is proper..it will only pop the dialog which is again a screen
                                      });
                                    },
                                  ),
                                  TextButton(
                                    child: Text("Cancel",style: TextStyle(color: Colors.red)),
                                    onPressed: () {
                                      setState(() {
                                        print("Yes");
                                        Navigator.pop( context);
                                      });
                                    },
                                  )
                                ]));


                      }),
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
                      controller: salesdeliveryController,
                      enabled: false,
                      validator: (v) {
                        if (v!.isEmpty) return "Required";
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
                          deliveryDate = date;
                          var d = DateFormat("d-MM-yyyy").format(date);
                          salesdeliveryController.text = d;
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
                        hintText: "Inv: Date:dd/mm/yy",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                        labelText: "Inv: Date",
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
                            print(".......${itemGdwnId.toString()}....");
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
                                 ( suggestion["type"]as String),
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
                            paymentType_Id = suggestion["id"] as int?;


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
                          onPressed: () {
                            if (itemGdwnId == null) {
                              setState(() {
                                GodownSelect = true;
                              });

                              return;
                            }
                            if (ShowAllItem == false) {
                              setState(() {
                                GodownSelect = false;
                                ItemsAdd_Widget_Visible =
                                !ItemsAdd_Widget_Visible;
                              });
                            }

                            else {
                              setState(() {
                                print("uiopupu");
                                SelectedRowDataSAmple = [];
                                SelectedRowData = [];
                                ShowAllItemPopup(goods);
                                ItemsAdd_Widget_Visible =
                                !ItemsAdd_Widget_Visible;
                                GodownSelect = false;
                              });
                            }
                          }, child:Text("ADD ITEMS",style: TextStyle(fontSize: 17),)),
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
//                                     salesPaymentId = 0;
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
//                           print("close.... $salesPaymentId");
//                           salesPaymentId = 0;
//
//                           print(suggestion.id);
//                           print(".......sales Item id");
//                           salesPaymentId = suggestion.id;
//                           print(salesPaymentId);
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
                    child: TextFormField(

                      controller:InvNoController,
                      cursorColor: Colors.black,
                      scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                      decoration: InputDecoration(

                        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 16.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(TextBoxCurve)),
                        // curve brackets object
//                    hintText: "Quantity",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                        labelText: "Inv.No",
                      ),
                    ),
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
                GestureDetector(
                    onTap: () {
                      print("Save");
                      //PurchaseRtnSave();
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
                //         sales.clear();
                //         customerController.text = "";
                //         salesdeliveryController.text = "";
                //         generalRemarksController.text = "";
                //         paymentController.text = "";
                //         grandTotal = 0;
                //         salesPaymentId = 0;
                //         salesItemId = 0;
                //         salesLedgerId = 0;
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
                                      title: Text("${itemRow.item}",textAlign: TextAlign.center,style:TextStyle(color: Colors.teal,fontSize: 25,fontWeight: FontWeight.bold)),
                                      content:Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(icon: Icon(Icons.edit,size: 30,color: Colors.indigoAccent,), onPressed: (){
                                            itemReEditing(itemRow);
                                            removeListElement(itemRow.id,
                                                itemRow.slNo, itemRow.NetAmt,itemRow.txAmt);

                                            Navigator.pop(
                                                context);
                                          },),

                                          IconButton(icon: Icon(Icons.delete,size: 30,), onPressed: (){
                                            removeListElement(itemRow.id,
                                                itemRow.slNo, itemRow.NetAmt,itemRow.txAmt);
                                            Navigator.pop(
                                                context);
                                          }),

                                          IconButton(icon: Icon(Icons.cancel_outlined,size: 30,color: Colors.red,), onPressed: (){
                                            Navigator.pop(
                                                context);
                                          }),

                                        ],)
                                    // actions: [
                                    //   FlatButton(
                                    //     child: Text("No",style: TextStyle(color: Colors.black),),
                                    //     onPressed: () {
                                    //       setState(() {
                                    //         print("No...");
                                    //         Navigator.pop(
                                    //             context); // this is proper..it will only pop the dialog which is again a screen
                                    //       });
                                    //     },
                                    //   ),
                                    //   FlatButton(
                                    //     child: Text("Yes",style: TextStyle(color: Colors.red)),
                                    //     onPressed: () {
                                    //       setState(() {
                                    //         print("Yes");
                                    //         removeListElement(itemRow.id,
                                    //             itemRow.slNo, itemRow.NetAmt,itemRow.txAmt);
                                    //         Navigator.pop(
                                    //             context);
                                    //       });
                                    //     },
                                    //   )
                                    // ]
                                  ));

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
                                Align(alignment: Alignment.centerRight,child: Text((itemRow.rate??0.0).toString())),
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
                        Text(
                          /// formatter.format(grandTotal),
                            formatter.format(Net_Amt_Befor_Tax+Net_VAt),
                            style: TextStyle(fontSize: 20,color: Colors.black,),textAlign: TextAlign.right),

                      ],),
                    SizedBox(width: MediaQuery.of(context).size.width/4,)
                  ],)
//         Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     width: 90,
//                   ),
//                   Expanded(
//                     child: TextField(
//                       readOnly: true,
//                       controller: controller,
//                       style: TextStyle(
//                           color: Colors.lightBlue,
// //                      fontFamily: Font.AvenirLTProMedium.value,
//                           fontSize: 17),
//                       decoration: InputDecoration(
//                         border: InputBorder.none,
//                         // hintText: 'Total Amount : $grandTotal',
//                         hintText: 'Total Amt : '+formatter.format(grandTotal),
//                         hintStyle:  TextStyle(
//                           fontSize: 20,
//                           color: Colors.black,
//                           backgroundColor: Colors.white10,
// //                          fontFamily: Font.AvenirLTProBook.value)
//                         )
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
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
                    child: Icon(Icons.add_business),
                    backgroundColor: Colors.blue,
                    label: "Purchase",
                    onTap:(){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>Purchase(
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
                            builder: (context) => Newtestpage(passvalue:slsname.toString(),Shid:salesLedgerId)),  );
                    } ),
                SpeedDialChild(
                    child: Icon(Icons.remove_red_eye_outlined),
                    backgroundColor: Colors.blue,
                    label: "Shop Visited",
                    onTap:(){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => shopvisited(passvalue:salesLedgerId,passname:slsname.toString(),)));
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
                                      salesItemId = null;
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
                              //  getbatch(suggestion.id);
                              var j={
                                "id":suggestion.id,
                                "itemId":suggestion.id,
                                "expiryDate":null,
                                "srate":suggestion.itmPurchaseRate,
                                "batchNo":null,
                                "nos":null,
                                "barcode":suggestion.itmBarCode,
                                "godownId":itemGdwnId
                              };
                              multibatchitembinding(j);
                            });


                            print(salesItemId);
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
                                    //  salesPaymentId = 0;
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






//--------------------Print part-------------------------------------------

  GetdataPrint(id) async {
    print("sales for print : $id");
    double amount = 0.0;
    try {
      final tagsJson =
      await http.get("${Env.baseUrl}PurchaseRtnHeaders/$id" as Uri, headers: {
        //Soheader //PurchaseRtnHeaders
        "Authorization": user.user["token"],
      });
      dataForTicket = await jsonDecode(tagsJson.body);
      // print("sales for print");
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
      await http.get("${Env.baseUrl}SalesInvoiceFooters/" as Uri, headers: {
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
        //Soheader //PurchaseRtnHeaders
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
    // final result = await _printerManager.printTicket(await _ticket(PaperSize.mm58));
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


class Pur_Rtn_Dtls_Model {
  Pur_Rtn_Dtls_Model({
    // this.id,
    // this.purchaseRtnHeaderId,
    required this.itemId,
    this.itmCode,
    required this.itmName,
    required this.barcode,
    this.batch,
    this.expDate,
    this.customColumn1,
    this.customColumn2,
    this.qty,
    required this.rate,
    required this.discountAmt,
    this.notes,
    required this.cgstPer,
    required this.sgstPer,
    required this.igstPer,
    required this.cessPer,
    required this.cgStAmt,
    required this.sgstAmt,
    required this.igstAmt,
    required this.cessAmt,
    required this.taxId,
    required this.txPercentage,
    required this.taxInclusive,
    required this.unitId,
    required this.nosInUnit,
    required this.amountBeforeTax,
    required this.amountIncludingTax,
    required this.taxAmount,
    required this.netTotal,
    required this.godownId,
    required this.gdnDescription,
  });

  // int id;
  // int purchaseRtnHeaderId;
  int itemId;
  dynamic itmCode;
  String itmName;
  String barcode;
  dynamic batch;
  dynamic expDate;
  dynamic customColumn1;
  dynamic customColumn2;
  dynamic qty;
  double rate;
  int discountAmt;
  dynamic notes;
  double cgstPer;
  double sgstPer;
  double igstPer;
  double cessPer;
  double cgStAmt;
  double sgstAmt;
  double igstAmt;
  double cessAmt;
  int taxId;
  double txPercentage;
  bool taxInclusive;
  int unitId;
  int nosInUnit;
  double amountBeforeTax;
  double amountIncludingTax;
  double taxAmount;
  double netTotal;
  int godownId;
  String gdnDescription;

  factory Pur_Rtn_Dtls_Model.fromJson(Map<String, dynamic> json) => Pur_Rtn_Dtls_Model(
    // id: json["id"],
    // purchaseRtnHeaderId: json["purchaseRtnHeaderId"],
    itemId: json["itemId"],
    itmCode: json["itmCode"],
    itmName: json["itmName"],
    barcode: json["barcode"],
    batch: json["batch"],
    expDate: json["expDate"],
    customColumn1: json["customColumn1"],
    customColumn2: json["customColumn2"],
    qty: json["qty"],
    rate: json["rate"],
    discountAmt: json["discountAmt"],
    notes: json["notes"],
    cgstPer: json["cgstPer"],
    sgstPer: json["sgstPer"],
    igstPer: json["igstPer"],
    cessPer: json["cessPer"],
    cgStAmt: json["cgStAmt"],
    sgstAmt: json["sgstAmt"],
    igstAmt: json["igstAmt"],
    cessAmt: json["cessAmt"],
    taxId: json["taxId"],
    txPercentage: json["txPercentage"],
    taxInclusive: json["taxInclusive"],
    unitId: json["unitId"],
    nosInUnit: json["nosInUnit"],
    amountBeforeTax: json["amountBeforeTax"],
    amountIncludingTax: json["amountIncludingTax"],
    taxAmount: json["taxAmount"],
    netTotal: json["netTotal"],
    godownId: json["godownId"],
    gdnDescription: json["gdnDescription"],
  );

  Map<String, dynamic> toJson() => {
    // "id": id,
    // "purchaseRtnHeaderId": purchaseRtnHeaderId,
    "itemId": itemId,
    "itmCode": itmCode,
    "itmName": itmName,
    "barcode": barcode,
    "batch": batch,
    "expDate": expDate,
    "customColumn1": customColumn1,
    "customColumn2": customColumn2,
    "qty": qty,
    "rate": rate,
    "discountAmt": discountAmt,
    "notes": notes,
    "cgstPer": cgstPer,
    "sgstPer": sgstPer,
    "igstPer": igstPer,
    "cessPer": cessPer,
    "cgStAmt": cgStAmt,
    "sgstAmt": sgstAmt,
    "igstAmt": igstAmt,
    "cessAmt": cessAmt,
    "taxId": taxId,
    "txPercentage": txPercentage,
    "taxInclusive": taxInclusive,
    "unitId": unitId,
    "nosInUnit": nosInUnit,
    "amountBeforeTax": amountBeforeTax,
    "amountIncludingTax": amountIncludingTax,
    "taxAmount": taxAmount,
    "netTotal": netTotal,
    "godownId": godownId,
    "gdnDescription": gdnDescription,
  };
}

















