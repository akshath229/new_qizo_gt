
import 'dart:async';
import 'dart:convert';

import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:data_tables/data_tables.dart';

import '../GT_Masters/AppTheam.dart';
import '../GT_Masters/Masters_UI/cuWidgets.dart';
import '../models/customersearch.dart';
import '../models/userdata.dart';
import '../urlEnvironment/urlEnvironment.dart';
import 'RMS_HomePage.dart';
import 'RMS_Print/RMS_SimPrint.dart';
class Rms_ItemBill extends StatefulWidget {
  @override
  _Rms_ItemBillState createState() => _Rms_ItemBillState();
}

class _Rms_ItemBillState extends State<Rms_ItemBill> {
//-----------------------------------------
  late SharedPreferences pref;
  late ItmBillDetails ItmBLdata;
  late Tabledata TDdata;
  dynamic branch;
  //var res;
  dynamic user;
  late int branchId;
  late int userId;
  late UserData userData;
  String branchName = "";
  dynamic userName;
  late String token;
  dynamic total = 0;
  int slnum = 0;
  String dateNow = DateFormat("yyyy-MM-dd").format(DateTime.now());
  dynamic TotalAmt = 0.00;
  String PaymentName = ""; //for Add payment type name in heding
//----------------------------------
  dynamic btnItmGrp = [];
  dynamic btnItmLst = [];
  bool grp_Inputbox_Vsbl =
      false; // for hide and show Item Grp Search InputText box
  bool itm_Inputbox_Vsbl =
      false; // for hide and show Item  Search InputText box
  bool listabledataShow = false;
  dynamic itemname = "";
  bool TablenumValid = false;
  bool quantitySelect = false;
  bool PaymentPopupVisilbe = false; // for list payment types
  bool PaymentAmtPopupVisilbe = false; // display selected payment and type amt
  bool Payment_Credit_Visilbe = false; // for payment type credit visiblee
  bool Pay_Typ_OthAmt_Valid = false;
  bool Pay_Typ_Cash_Valid = false;
  bool Pay_Typ_OthAmt_TxtBx_Visible = false; // for other amout text box hide
  bool imageSetting = false; //  image or text display on button
  bool Itm_Tbl_DeleteBttn_Visible = true; // after payment completed button hide
  bool customerSelect = false;
  bool Pay_Typ_Credit_Ph_Valid = false;

  TextEditingController quantityController = new TextEditingController();
  TextEditingController TablenumController = new TextEditingController();
  TextEditingController TokennumController = new TextEditingController();
  TextEditingController ItemGrpController = new TextEditingController();
  TextEditingController ItemLstController = new TextEditingController();
  TextEditingController UomRateController = new TextEditingController();
  TextEditingController TotalAmtController = new TextEditingController();
  TextEditingController Pay_Typ_Cash_Controller = new TextEditingController();
  TextEditingController Pay_Typ_OthAmt_Controller = new TextEditingController();
  TextEditingController RoundOffController = new TextEditingController();
  TextEditingController DisPerController = new TextEditingController();
  TextEditingController DisAmtController = new TextEditingController();
  TextEditingController Pay_Typ_Tota_Amt_Controller =
      new TextEditingController();
  TextEditingController OrderumController = new TextEditingController();
  TextEditingController customerController = new TextEditingController();
  TextEditingController Pay_Typ_Credit_Ph_Controller =new TextEditingController();
  TextEditingController Bill_No_Controller =new TextEditingController();
  TextEditingController ItemNotesController =new TextEditingController();

  var ItemNotes_Id = null;
  int PaymentTypID = 0;
  int customerId = 0;
  bool itemSelectvalidate = false;
  int ItemGrpId = 0;
  bool itmGrpVsbl = false;
  bool itmLstVsbl = false;
  bool Noitem = false;
  bool UomRateSelect = false;
  late List<dynamic> UomData;
  late List<dynamic> PayTypData; // get Paymet type api data
  var PayAmtTypData;
  dynamic UOM = null;
  var UomTableData = {};
  dynamic itemRate = 0.00;
  dynamic itemQty = 0;
  dynamic Token_Num = 0;
  dynamic itemTaxInOrEx;
  static List<Tabledata> TD = [];
  static List<ItmBillDetails> IBD = [];
  static List<ItemGroup> ItmGrp = [];
  static List<ItemList> ItmLst = [];
  static List<Customer> users = [];

  dynamic Customername = '';
  double itemTblHight = 300; // change  List table height

  var Pay_Typ_RoundOff = 0.00; //"
  var Pay_Typ_Disamt = 0.00; // Payment typ Calculatio
  var Pay_Typ_cash = 0.00; //"
  var Pay_Typ_Other_cash = 0.00; //"


var KOT_Printer;
var Counter_Printer;

bool Top_TextBox_Visible=false;
  var EditId;
  String ButtonName="Save";

  AppTheam theam =AppTheam();

  var dataForTicket;

  // ItemAddon AddonItem=ItemAddon();

  var BillingNote;
  // var BillingNote=[
  //   // {"itmName":1,"itmName":"uio"},{"itmName":2,"itmName":"uio2"},
  //   // {"itmName":1,"itmName":"uio"},{"itmName":2,"itmName":"uio2"},
  //   // {"itmName":1,"itmName":"uio"},{"itmName":2,"itmName":"uio2"},
  //   // {"itmName":1,"itmName":"uio"},{"itmName":2,"itmName":"uio2"},
  //   // {"itmName":1,"itmName":"uio"},{"itmName":2,"itmName":"uio2"},
  //   // {"itmName":1,"itmName":"uio"},{"itmName":2,"itmName":"uio2"},
  //   // {"itmName":1,"itmName":"uio"},{"itmName":2,"itmName":"uio2"},
  //   // {"itmName":1,"itmName":"uio"},{"itmName":2,"itmName":"uio2"},
  //   // {"itmName":1,"itmName":"uio"},{"itmName":2,"itmName":"uio2"},
  //   // {"itmName":1,"itmName":"uio"},{"itmName":2,"itmName":"uio2"},
  //   // {"itmName":1,"itmName":"uio"},{"itmName":2,"itmName":"uio2"},
  //   // {"itmName":1,"itmName":"uio"},{"itmName":2,"itmName":"uio2"},
  // ] ;


  void initState() {
    setState(() {
      SharedPreferences.getInstance().then((value) {
        pref = value;
        read();
        getItemGrp();
        quantityController.text = "1";
        TotalAmtController.text = "0.00";
        getTokenNo();
        GetPaymentType();
        TD.clear();
        IBD.clear();
        Get_Setting();
        getCustomer();
        GetBillNum();
        GetBillingNote();
        GeneralSettings();
      });
    });
  }
  CUWidgets cw=CUWidgets();
//------------------for appbar------------
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
    });
  }


  GeneralSettings()async{

    var res=await cw.CUget_With_Parm(api:"GeneralSettings",Token: token);

    if(res!=null){
      var jsonres=json.decode(res);
      print("res");
// print(jsonres[0]["rmsKotPrinter"]) ;
      setState(() {
        if(jsonres[0]["enableMakeorderRms"]==true){
          //KOT_Printer=jsonres[0]["rmsKotPrinter"];
          Counter_Printer=jsonres[0]["rmsCounterPrinter"];
        }

        else{
          KOT_Printer=jsonres[0]["rmsKotPrinter"];
          Counter_Printer=jsonres[0]["rmsCounterPrinter"];
        }


      });

    }
  }





  GetBillingNote()async {
    var res = await cw.CUget_With_Parm(api: "BillingNoteMasters", Token: token);

    if (res != false) {
      var resData = json.decode(res);
      setState(() {
        print("resData");
        print(resData);
        print(resData[0]["notes"]);

        var s=[];
        s=resData;
        final _results = s
              .where((product) => product["isActive"].toString() == "true");

          print(_results.toString());
          // for (FinishedGoods p in _results) {
          //
          //   s=p.itmName;
          //   print(p.itmName);
          // }

        print("_results");
        // print(_results);

        BillingNote=_results;
        print(BillingNote);
      });
    }
  }



  var BillNumber;
  GetBillNum()async{

    var res =await cw.CUget_With_Parm(api: "getsettings/1/gtsales",Token: token);

    if(res!=false){

      var resData=json.decode(res);
      setState(() {
        BillNumber=resData[0]["vocherNo"].toString();
      });


      setState(() {

      });
    }

  }




  //-----Table no-----------------
  getItemIndex(dynamic item) {
    var index = TD.indexOf(item);
    return index + 1;
  }

  removeListElement(sl, totl) {
    print(totl);
    TD.removeWhere((element) => element.ItemSlNo == sl);
    IBD.removeWhere((element) => element.ItemSlNo == sl);
    TotalAmt = TotalAmt - totl;
    TotalAmtController.text = TotalAmt.toStringAsFixed(3);
    if (TD.isEmpty) {
      listabledataShow = false;
      TotalAmt = 0;
      TotalAmtController.text = "0.00";
      slnum = 0;
    }
  }

//----------------------getCustomer-----------------------------------------
  getCustomer() async {
    try {
      final response = await http.get("${Env.baseUrl}MLedgerHeads" as Uri, headers: {
        "Authorization": user.user["token"],
      });
      print(response.statusCode);

      print('...................');
      print(json.decode(response.body));
      var data = json.decode(response.body);

      List<dynamic> t = data['ledgerHeads'];
      List<Customer> p = t.map((t) => Customer.fromJson(t)).toList();
      users = p;
    } catch (e) {
      print("Error getting users $e");
    }
  }

//----------------------Get_Setting--------------------GeneralSettings---------------------

  Get_Setting() async {
    String url = "${Env.baseUrl}GeneralSettings";
    try {
      final res =
          await http.get(url as Uri, headers: {"Authorization": user.user["token"]});
      print("Get_Setting decoded");

      var tagsJson = json.decode(res.body);
      print(tagsJson);
      imageSetting = tagsJson[0]["rmsBillDispImg"];
      print(imageSetting);
    } catch (e) {
      print("error in Get_Setting $e");
    }
  }

  //------------------------------------Get_Setting-----end------------------------------------





//----------------------get token no---------------gtsalestoken------------------------------------------

  getTokenNo() async {
    String url = "${Env.baseUrl}getsettings/1/gtsalestoken";
    try {
      final res =
          await http.get(url as Uri, headers: {"Authorization": user.user["token"]});

      // print("json decoded");
      var tagsJson = json.decode(res.body);

      setState(() {
        print("token no");
        // print(tagsJson[0]["vocherNo"].toString());
        Token_Num = tagsJson[0]["vocherNo"];
        TokennumController.text = Token_Num.toString();
      });
    } catch (e) {
      print(e);
    }
  }





  //-------------------------------------Savefunction------------------------------------------

  IBSave(Detailsdta) async {
    var res;
    print("in IBSave");
   // final url = "${Env.baseUrl}SalesHeaders";
    if (Detailsdta.length == 0) {
      showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(actions: [
                Container(
                  height: 50,
                  width: 300,
                  child: Center(
                      child: Text("Please add items..!",
                          style: TextStyle(color: Colors.red, fontSize: 20))),
                )
              ]);
            });
          });
      return;
    }

    // if (TablenumController.text == "") {
    //   setState(() {
    //     TablenumValid = true;
    //   });
    //
    //   return;
    // }
    // TablenumValid = false;

    if (TotalAmtController.text != "Amount paid" &&
        TotalAmtController.text != "Credited") {
      showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(actions: [
                Container(
                  height: 50,
                  width: 300,
                  child: Center(
                      child: Text("Amount Not Payed",
                          style: TextStyle(color: Colors.red, fontSize: 20))),
                )
              ]);
            });
          });
      return;
    }



    if(ButtonName=="Save"){

      print("in Save");
      var req = {
        // "id":EditId,
        // ButtonName=="Save"?"":"id":EditId,
        "voucherNo":null,
        "voucherDate": dateNow.toString(),
        "ledgerId": customerId,
        "partyName": Customername,
        "DeliveryTo":TablenumController.text,// "Table " + TablenumController.text,
        "TokenNo": Token_Num,
        "paymentType": PaymentTypID,
        "DeliveryType": true,
        "address1": null,
        "Orderstatus": "deliverypending",
        "OrderType": "waiter",
        "orderHeadId":OrderumController.text,
        "address2": null,
        "saleTypeInterState": true,
        "phone": Pay_Typ_Credit_Ph_Controller.text == ""
            ? null
            : Pay_Typ_Credit_Ph_Controller.text,
        "shipToName": null,
        "shipToAddress1": null,
        "shipToAddress2": null,
        "shipToPhone": null,
        "narration": null,
        "amount": TotalAmt,
        "discountAmt": Pay_Typ_Disamt,
        "balanceAmount": TotalAmt,
        "cashReceived": Pay_Typ_cash,
        "adjustAmount": Pay_Typ_RoundOff,
        "paymentCondition": null,
        "slesManId": null,
        "branchUpdated": false,
        "userId": userId,
        "branchId": branchId,
        "otherAmt": Pay_Typ_Other_cash,
        "invoiceType": null,
        "invoicePrefix": null,
        "invoiceSuffix": null,
        "cancelFlg": null,
        "entryDate": "",
        "gstNo": null,
        "orderDate": null,
        "expDate": null,
        "creditPeriod": null,
        "adlDiscAmount": null,
        "adlDiscPercent": null,
        "otherAmountReceived": null,
        "salesDetails": IBD,
        "salesExpense": null
      };

      var params = json.encode(req);
      print("params");
      print(params);
      print("IBD");
      print(json.encode(IBD));



      print("save ${Env.baseUrl}SalesHeaders");

      res = await http.post("${Env.baseUrl}SalesHeaders" as Uri,
          headers: {
            'accept': 'application/json',
            'content-type': 'application/json',
            'Authorization': user.user["token"],
            'deviceId': user.deviceId
          },
          body: params);
    }

    else
      {

        var Editreq = {
          "id":EditId,
          // ButtonName=="Save"?"":"id":EditId,
          "voucherNo": EditId,
          "voucherDate": dateNow.toString(),
          "ledgerId": customerId,
          "partyName": Customername,
          "DeliveryTo":TablenumController.text,
          "TokenNo": Token_Num,
          "paymentType": PaymentTypID,
          "DeliveryType": true,
          "address1": null,
          "Orderstatus": "deliverypending",
          "OrderType": "waiter",
          "address2": null,
          "saleTypeInterState": true,
          "phone": Pay_Typ_Credit_Ph_Controller.text == ""
              ? null
              : Pay_Typ_Credit_Ph_Controller.text,
          "shipToName": null,
          "shipToAddress1": null,
          "shipToAddress2": null,
          "shipToPhone": null,
          "narration": null,
          "amount": TotalAmt,
          "discountAmt": Pay_Typ_Disamt,
          "balanceAmount": TotalAmt,
          "cashReceived": Pay_Typ_cash,
          "adjustAmount": Pay_Typ_RoundOff,
          "paymentCondition": null,
          "slesManId": null,
          "branchUpdated": false,
          "userId": userId,
          "branchId": branchId,
          "otherAmt": Pay_Typ_Other_cash,
          "invoiceType": null,
          "invoicePrefix": null,
          "invoiceSuffix": null,
          "cancelFlg": null,
          "entryDate": "",
          "gstNo": null,
          "orderDate": null,
          "expDate": null,
          "creditPeriod": null,
          "adlDiscAmount": null,
          "adlDiscPercent": null,
          "otherAmountReceived": null,
          "salesDetails": IBD,
          "salesExpense": []
        };
        var Editparams = json.encode(Editreq);

        print("Edit params");
        print(Editparams);
        print("Edit det");
        print(json.encode(IBD));

        print("edit ${Env.baseUrl}SalesHeaders/$EditId");
        res = await http.put("${Env.baseUrl}SalesHeaders/$EditId" as Uri,
            headers: {
              'accept': 'application/json',
              'content-type': 'application/json',
              'Authorization': user.user["token"],
              'deviceId': user.deviceId
            },
            body: Editparams);



      }


    print("res.data " + res.body);

    print("res.statusCode " + res.statusCode.toString());

    if (res.statusCode == 200 || res.statusCode == 201 || res.statusCode == 204) {
      setState(() {
        TD.clear();
        IBD.clear();
        TotalAmtController.text = "0.00";
        TablenumController.text = "";
        TokennumController.text = "";
        TotalAmt = 0.00;
        listabledataShow = false;
        getTokenNo();
        GetBillNum();
        EditId=null;
        dataForTicket=json.decode(res.body);
      });

      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Center(
                    child: Text(
                  "Success",
                  style: TextStyle(color: Colors.blueAccent),
                )),
              ));
      Timer(Duration(seconds: 2), () {
        print("after 2 seconds");
          //Navigator.pop(context);
        Timer(Duration(milliseconds: 10), () async{
          await wifiprinting(KOT_Printer);
          // blutoothprinting();
        });

        Timer(Duration(milliseconds: 20), () async{
          await wifiprinting(Counter_Printer);
          // blutoothprinting();
        });


        Timer(Duration(milliseconds: 100), () async{
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //     builder: (context) =>
          //     RMS_SimPrint(Page_Type:false,Parm_Id:dataForTicket["id"]))
          // );
          SimpPrint.IntialFunctions(Parm_Id: dataForTicket["id"],CntPrint: Counter_Printer,Kot: KOT_Printer);
        });

      });
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Center(
                    child: Text(
                  "Failed !",
                  style: TextStyle(color: Colors.brown),
                )),
              ));

      TotalAmtController.text = TotalAmt.toString();
      TotalAmt = TotalAmt;
    }
  }

  //----------------------------end-----------Savefunction---end-------------------------------------


  Rms_SimPrint SimpPrint=Rms_SimPrint();




  //-----------------Show poup for  selected items --------------------------------------
  ListoTable(array) async {
    UomRateController.text = "";
    UomRateSelect = false;
    quantitySelect = false;
    print("in");
    print(array.toString());
    dynamic Did = (array["id"]).toString();
    int itemid = int.parse(Did);
    itemname = array["itmName"];
    // itemRate = array["rate"];
    // quantityController.text = "";
    // quantitySelect = false;
    itemTaxInOrEx = array["itmTaxInclusive"];
    String url = "${Env.baseUrl}gtitemmasters/$itemid/-1";
    try {
      final res =
          await http.get(url as Uri, headers: {"Authorization": user.user["token"]});

      //  print(" Item UOM");
      // print(res.body);

      //  print("json decoded");

      var tagsJson = json.decode(res.body);
      UomData = tagsJson;
      // print(tagsJson.length);
    } catch (e) {
      print("error on ListoTable : $e");
    }


//
// if(MediaQuery.of(context).size.width > 500){
//
//   var s=await AddonItem.initialFuntion(context, UomData, itemname,array["itmImage"]);
//
//
//
//   print("oipoii[");
//   print("s");
//   print(s);
//
//   if(s!=null){
//     print(s[0]["Qty"].toString());
//     print(s[0]["data"]);
//
//     quantityController.text=s[0]["Qty"].toString();
//     UomTableData= s[0]["data"];
//     bindToTable();
//
//
//   }
//   else
//   {print("item Not Selected");}
//
//
// }else
   // {


      showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              //backgroundColor: Colors.pink.shade100,
              actions: [
                Column(
                  children: [
                    SingleChildScrollView(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          UomData.length == 0
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  child: Text(
                                    "UOM Not Found..!",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 20,
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  child: Text(
                                    itemname,
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                          SizedBox(
                            height: 5,
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 225,
                      width: 350,
                      child: ListView(shrinkWrap: true, children: [
                        Visibility(
                          visible: UomData.length > 0,
                          child: DataTable(
                            showCheckboxColumn: false,
                            columnSpacing: 3,
                            onSelectAll: (b) {},
                            sortAscending: true,
                            columns: <DataColumn>[
                              DataColumn(
                                label: SingleChildScrollView(
                                    physics: NeverScrollableScrollPhysics(),
                                    child: Text('UOM')),
                              ),
                              DataColumn(
                                label: Text('Rate'),
                              ),
                              // DataColumn(
                              //   label: Text(''),
                              // ),
                              // DataColumn(
                              //   label: Text(''),
                              // ),
                            ],
                            rows: UomData.map(
                              (itemRow) => DataRow(
                                onSelectChanged: (a) {
                                  print(itemRow);
                                  UomRateController.text =
                                      itemRow['mrp'] == null
                                          ? "0.00"
                                          : itemRow['mrp'].toString();

                                  setState(() {
                                    UomRateSelect = false;
                                    UomTableData = itemRow;
                                    UOM = itemRow['description'];
                                    print("UOM =: $UOM");
                                  });
                                },
                                cells: [
                                  DataCell(
                                    Text(
                                        '${itemRow['description'].toString()}'),
                                    showEditIcon: false,
                                    placeholder: false,
                                  ),
                                  DataCell(
                                    Text(
                                        '${itemRow['mrp'] == null ? "0.00" : itemRow['mrp'].toString()}'),
                                    showEditIcon: false,
                                    placeholder: false,
                                  ),
                                  // DataCell(
                                  //   GestureDetector(
                                  //       onTap: () {
                                  //         print(itemRow);
                                  //         UomRateController.text =
                                  //             itemRow['mrp'] == null
                                  //                 ? "0.00"
                                  //                 : itemRow['mrp'].toString();
                                  //
                                  //         setState(() {
                                  //           UomRateSelect = false;
                                  //           UomTableData = itemRow;
                                  //           UOM = itemRow['description'];
                                  //           print("UOM =: $UOM");
                                  //           print(getUOMIndex(itemRow));
                                  //         });
                                  //
                                  //         // id: 21
                                  //         // AddtoTable(itemRow);
                                  //         //
                                  //         // Navigator.pop(context);
                                  //       },
                                  //       child: Icon(Icons.done_outline_rounded)),
                                  // ),
                                  // DataCell(
                                  //   Visibility(
                                  //       visible: false,
                                  //       child:
                                  //           Text(getUOMIndex(itemRow).toString())),
                                  //   showEditIcon: false,
                                  //   placeholder: false,
                                  // ),
                                ],
                              ),
                            ).toList(),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            height: 50,
                            child: TextFormField(
                              controller: quantityController,
                              enabled: true,
                              validator: (v) {
                                if (v!.isEmpty) return "Required";
                                return null;
                              },
                              cursorColor: Colors.black,
                              scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r"^\d+\.?\d{0,2}")),
                              ],
                              decoration: InputDecoration(
                                errorStyle: TextStyle(color: Colors.red),
                                errorText:
                                    quantitySelect ? "Invalid Qty" : null,
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 16.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14.0)),

                                // curve brackets object
//                    hintText: "Quantity",
                                hintStyle: TextStyle(
                                    color: Colors.black, fontSize: 15),

                                labelText: "Quantity",
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 150,
                            height: 50,
                            child: TextFormField(
                              readOnly: true,
                              controller: UomRateController,
                              enabled: false,
                              // validator: (v) {
                              //   if (v.isEmpty) return "Required";
                              //   return null;
                              // },

                              cursorColor: Colors.black,
                              // scrollPadding: EdgeInsets.fromLTRB(40, 50, 20, 0),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r"^\d+\.?\d{0,2}")),
                              ],
                              decoration: InputDecoration(
                                errorStyle: TextStyle(color: Colors.red),
                                errorText:
                                    UomRateSelect ? "Invalid Rate" : null,
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 16.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14.0)),

                                // curve brackets object
//                    hintText: "Quantity",
                                hintStyle: TextStyle(
                                    color: Colors.black, fontSize: 15),

                                labelText: "Rate",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),




                    SizedBox(width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Expanded(
                            child: TypeAheadField(
                                suggestionsBoxVerticalOffset: 50,

                                direction:AxisDirection.up,
                                textFieldConfiguration: TextFieldConfiguration(
                                    style: TextStyle(),
                                    controller: ItemNotesController,
                                    decoration: InputDecoration(
                                      errorStyle: TextStyle(color: Colors.red),
                                      // errorText: itemSelect
                                      //     ? "Please Select product Item ?"
                                      //     : null,
                                      suffixIcon: IconButton(
                                        icon: Icon(Icons.remove_circle),
                                        color: Colors.blue,
                                        onPressed: () {
                                          setState(() {
                                            print("cleared");
                                            ItemNotesController.text = "";
                                            ItemNotes_Id = null;

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
                                      'Item search', // i need to decrease height
                                    )),
                                suggestionsBoxDecoration:
                                SuggestionsBoxDecoration(elevation: 90.0),
                                suggestionsCallback: (pattern) {
                                  return BillingNote.where((user) =>
                                      user["notes"].toString().trim().toLowerCase().contains(pattern.trim().toLowerCase()));
                                },
                                itemBuilder: (context, suggestion) {
                                  return Card(
                                    color: Colors.blue,
                                    // shadowColor: Colors.blue,
                                    child: ListTile(
                                      tileColor: theam.DropDownClr,
                                      title: Text(
                                        suggestion["notes"],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  );
                                },
                                onSuggestionSelected: (suggestion) {
                                  print(suggestion["notes"]);
                                  print("selected");
                                  ItemNotesController.text=suggestion["notes"];
                                  //  print(salesItemId);
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
                              icon: Icon(Icons.add_shopping_cart,size: 35,color: Colors.teal,),

                              onPressed:(){
                                if (UOM == null || UOM == "null") {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return StatefulBuilder(
                                            builder: (context, setState) {
                                              return AlertDialog(actions: [
                                                Container(
                                                  height: 30,
                                                  width: 300,
                                                  child: Center(
                                                      child: Text(
                                                        "UOM is Undefined..!",
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 20),
                                                      )),
                                                )
                                              ]);
                                            });
                                      });
                                  return;
                                }
                                print("in test");
                                if (UomRateController.text == "" ||
                                    UomRateController.text == "0.00") {
                                  setState(() {
                                    UomRateSelect = true;
                                    return;
                                  });
                                } else {
                                  setState(() {
                                    UomRateSelect = false;
                                    print(UomTableData);
                                    ItemLstController.text = "";
                                    ItemGrpController.text = "";
                                    bindToTable();
                                    Navigator.pop(context);
                                  });
                                }
                              })
                        ],
                      ),
                    )
                  ],
                ),
              ],
            );
          },
        );
      },
    );

// }
  }

//---------------------------------end poup---------------------------------------------




  //---------------------------------Data Bind To Table------------------------------------------------------------
  bindToTable() {
    try {
      var amtWithTax;
      double taxamt;
      var amtWithOutTax;
      itemQty = double.parse(quantityController.text);
      itemRate = (UomTableData['mrp'].toDouble());
      total = (itemRate * itemQty);

      if (itemTaxInOrEx == true) {
        print("inclusive");
        amtWithTax = itemRate * itemQty;
        taxamt = (total / 100) * UomTableData['txPercentage'].toDouble();
        amtWithOutTax =
            total - ((total / 100) * UomTableData['txPercentage'].toDouble());
      } else {
        print("exclusive");
        taxamt = (total / 100) * UomTableData['txPercentage'].toDouble();
        amtWithTax = taxamt + total;
        amtWithOutTax = total;
      }
      print(TotalAmt.runtimeType);
      print(amtWithTax.runtimeType);
      print(amtWithTax);

      TotalAmt = TotalAmt.toDouble() + amtWithTax.toDouble();
      slnum = ++slnum;
      TotalAmtController.text = TotalAmt.toStringAsFixed(3);

      listabledataShow = true;
      ItmBLdata = ItmBillDetails(
        ItemSlNo: slnum,
        itemId: UomTableData['itemid'],
        qty: itemQty,
        rate: itemRate,
        disPercentage: null,
        cgstPercentage: UomTableData['txCgstPercentage'],
        sgstPercentage: UomTableData['txSgstPercentage'],
        cessPercentage: null,
        discountAmount: 0,
        cgstAmount: UomTableData['txCgstPercentage'] == null
            ? "0"
            : (total / 100) * UomTableData['txCgstPercentage'],
        sgstAmount: UomTableData['txSgstPercentage'] == null
            ? "0"
            : (total / 100) * UomTableData['txSgstPercentage'],
        cessAmount: 0,
        igstPercentage: UomTableData['txIgstpercentage'],
        igstAmount: UomTableData['txIgstpercentage'] == null
            ? "0"
            : (total / 100) * UomTableData['txIgstpercentage'],
        taxPercentage: UomTableData['txPercentage'],
        taxAmount: taxamt,
        taxInclusive: itemTaxInOrEx,
        amountBeforeTax: amtWithOutTax,
        amountIncludingTax: amtWithTax,
        //ele.Tax_Amt + ele.Gross_Amt,
        netTotal: TotalAmt,
        hsncode: null,
        gdnId: 0,
        taxId: UomTableData['txId'],
        rackId: 0,
        addTaxId: 0,
        unitId: UomTableData['unitId'],
        nosInUnit: 0,
        //ele.Nos_In_Unit,
        barcode: null,
        //
        StockId: 0,
        BatchNo: null,
        ExpiryDate: null,
        Notes: ItemNotesController.text,
        adlDiscAmount: null,
        adlDiscPercent: null,
          shid: EditId
      );
      setState(() {
        IBD.add(ItmBLdata);
        print(jsonEncode(IBD));
      });

      TDdata = Tabledata(
        id: UomTableData['itemid'],
        ItemSlNo: slnum,
        Name: UomTableData['itmName'],
        Qty: itemQty,
        rate: itemRate,
        Total: itemRate * itemQty,
        UOM: UomTableData['description'],
        AmtWithTax: amtWithTax,
      );
      setState(() {
        TD.add(TDdata);
        print(jsonEncode(TD));
        listabledataShow = true;
      });
    } catch (e) {
      print("error on Bind to table $e");
    }
  }

  //---------------------------------END  Data Bind To Table------------------------------------------------------------






  // -------------------------get itemGrp
  getItemGrp() async {
    print(" Item Grp");
    String url = "${Env.baseUrl}Gtitemgroups";
    try {
      final res =
          await http.get(url as Uri, headers: {"Authorization": user.user["token"]});

      // print(" Item Grp");
      // print(res.body);

      //print("json decoded");

      var tagsJson = json.decode(res.body);

      setState(() {
        List<dynamic> t = tagsJson['gtItemGroup'];
        List<ItemGroup> p = t.map((t) => ItemGroup.fromJson(t)).toList();
        btnItmGrp = tagsJson['gtItemGroup'];
        if (btnItmGrp != null) {
          itmGrpVsbl = true;
        } else {
          itmGrpVsbl = false;
        }

        // print("sssss"+(btn1[0]['igDescription']).toString());
        ItmGrp = p;
      });
    } catch (e) {
      print(e);
    }
  }

//---------------------Get item------------------------------------
  getItem(id) async {
    print("getItem : " + id.toString());

    String url = "${Env.baseUrl}gtitemmasters/$id/0";
    try {
      final res =
          await http.get(url as Uri, headers: {"Authorization": user.user["token"]});

      print(" Item list");
      print(res.body);

      print("json decoded");

      var tagsJson = json.decode(res.body);

      setState(() {
        List<dynamic> t = tagsJson;
        List<ItemList> p = t.map((t) => ItemList.fromJson(t)).toList();
        btnItmLst = tagsJson;
        ItmLst = p;

        if (btnItmLst.isEmpty) {
          itmLstVsbl = false;
          Noitem = true;
        } else {
          itmLstVsbl = true;
          Noitem = false;
        }
      });
    } catch (e) {
      print(e);
    }
  }

  //-------------------------GEt--Payment Type--------------------------------------------
  GetPaymentType() async {
    String url = "${Env.baseUrl}GeneralSettings/1/paymenttype";
    try {
      final res =
          await http.get(url as Uri, headers: {"Authorization": user.user["token"]});

      print("PaymentType");
      print(res.body);

      print("json decoded");

      var tagsJson = json.decode(res.body);
      PayTypData = tagsJson;
    } catch (e) {
      print("error on PaymentType $e");
    }
  }

//-------------------------Get--Payment Type--- End-----------------------------------------

  //-------------------------Set--Payment Type----------poup----------------------------------

  SetPaymentType() {
    if (IBD.length == 0) {
      showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(actions: [
                Container(
                  height: 50,
                  width: 300,
                  child: Center(
                      child: Text("Please add items..!",
                          style: TextStyle(color: Colors.red, fontSize: 20))),
                )
              ]);
            });
          });
      return;
    } else
      // (TablenumController.text == "") {
    //   setState(() {
    //     TablenumValid = true;
    //     showDialog(
    //         context: context,
    //         builder: (context) {
    //           return StatefulBuilder(builder: (context, setState) {
    //             return AlertDialog(actions: [
    //               Container(
    //                 height: 50,
    //                 width: 300,
    //                 child: Center(
    //                     child: Text("Invalid Table No..!",
    //                         style: TextStyle(color: Colors.red, fontSize: 20))),
    //               )
    //             ]);
    //           });
    //         });
    //   });
    //
    //   return;
    // }
    // setState(() {
    //   TablenumValid = false;
    // });

    if (PayTypData.length > 0) {
      PaymentPopupVisilbe = true;
    } else {
      PaymentPopupVisilbe = false;
    }

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(actions: [
              Column(
                children: [
                  SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Text("Payment Type",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Text("  $PaymentName",
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 20,
                              )),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      "Net Amount : Rs " +  TotalAmtController.text,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  Container(
                      height: 325,
                      width: 400,
                      child: ListView(shrinkWrap: true, children: [
                        Visibility(
                          visible: PaymentPopupVisilbe == true,
                          child: DataTable(
                            showCheckboxColumn: false,
                            headingRowHeight: 0,
                            onSelectAll: (b) {},
                            sortAscending: true,
                            columns: <DataColumn>[
                              DataColumn(
                                label: Text(''),
                              ),
                            ],
                            rows: PayTypData.map(
                              (itemRow) => DataRow(
                                onSelectChanged: (a) {
                                  setState(() {
                                    print(itemRow);
                                    Pay_Frm_Reset();
                                    PayAmtTypData = itemRow;
                                    PaymentName = itemRow['paymentType'];
                                    PaymentTypID = itemRow['id'];
                                    if (PayAmtTypData["paymentType"]
                                        .contains('and')) {
                                      print("contain");
                                      Pay_Typ_OthAmt_TxtBx_Visible = true;
                                      Payment_Credit_Visilbe = false;
                                    } else if (PayAmtTypData["paymentType"] ==
                                        "Credit") {
                                      Pay_Typ_OthAmt_TxtBx_Visible = false;
                                      PaymentAmtPopupVisilbe = false;
                                      Payment_Credit_Visilbe = true;
                                    } else {
                                      print(" Not contain");
                                      Pay_Typ_OthAmt_TxtBx_Visible = false;
                                      Payment_Credit_Visilbe = false;
                                    }
                                  });
                                },
                                cells: [
                                  DataCell(
                                    Center(
                                        child: Text(
                                            '${itemRow['paymentType'].toString()}')),
                                    showEditIcon: false,
                                    placeholder: false,
                                  ),
                                ],
                              ),
                            ).toList(),
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),

                        // Patment tyep select  amt  typing---------------------------------------

                        Visibility(
                          visible: PaymentAmtPopupVisilbe == true,
                          child: Column(children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                onChanged: (a) {
                                  print(a.toString());
                                  if (Pay_Typ_Cash_Controller.text == "") {
                                    var TotAmt = TotalAmtController.text;
                                    var amt1 = (double.parse(TotAmt)) -
                                        ((Pay_Typ_Disamt));
                                    var amt2 = amt1 - Pay_Typ_RoundOff;
                                    var amt3 = amt2 - Pay_Typ_Other_cash;
                                    Pay_Typ_Tota_Amt_Controller.text =
                                        amt3.toStringAsFixed(3);
                                    Pay_Typ_cash = 0.00;
                                    return;
                                  } else {
                                    setState(() {
                                      Pay_Typ_cash = (double.parse(
                                          Pay_Typ_Cash_Controller.text));
                                      var TotAmt = TotalAmtController.text;

                                      print("Pay_Typ_cash");
                                      // print(Pay_Typ_cash);
                                      // print(Pay_Typ_Disamt);
                                      // print(Pay_Typ_RoundOff);

                                      var amt1 = (double.parse(TotAmt)) -
                                          ((Pay_Typ_cash));
                                      var amt2 = amt1 - Pay_Typ_Disamt;
                                      var amt3 = amt2 - Pay_Typ_RoundOff;
                                      var amt = amt3 - Pay_Typ_Other_cash;
                                      var NetAmt = amt;
                                      // print(amt1);
                                      // print(amt2);
                                      // print(amt3);

                                      Pay_Typ_Tota_Amt_Controller.text =
                                          NetAmt.toStringAsFixed(3);
                                    });
                                  }
                                },
                                controller: Pay_Typ_Cash_Controller,
                                enabled: true,
                                validator: (v) {
                                  if (v!.isEmpty) return "Required";
                                  return null;
                                },
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r"^\d+\.?\d{0,2}")),
                                ],
                                keyboardType: TextInputType.number,
                                cursorColor: Colors.black,
                                scrollPadding:
                                    EdgeInsets.fromLTRB(0, 20, 20, 0),
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(color: Colors.red),
                                  errorText: Pay_Typ_Cash_Valid == true
                                      ? "Add Amount"
                                      : null,
                                  isDense: true,
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 10.0, 20.0, 16.0),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(14.0)),
                                  hintStyle: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                  labelText: "Cash",
                                ),
                              ),
                            ),

                            //------------------Other amt Txt Bx------------------
                            Visibility(
                              visible: Pay_Typ_OthAmt_TxtBx_Visible == true,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, bottom: 10, left: 5, right: 5),
                                child: TextFormField(
                                  onChanged: (a) {
                                    print(a.toString());
                                    if (Pay_Typ_OthAmt_Controller.text == "") {
                                      var TotAmt = TotalAmtController.text;
                                      var amt1 = (double.parse(TotAmt)) -
                                          ((Pay_Typ_Disamt));
                                      var amt2 = amt1 - Pay_Typ_RoundOff;
                                      var amt3 = amt2 - Pay_Typ_cash;
                                      Pay_Typ_Tota_Amt_Controller.text =
                                          amt3.toStringAsFixed(3);
                                      Pay_Typ_cash = 0.00;
                                      return;
                                    } else {
                                      setState(() {
                                        Pay_Typ_Other_cash = (double.parse(
                                            Pay_Typ_OthAmt_Controller.text));
                                        var TotAmt = TotalAmtController.text;

                                        print("Pay_Typ_Other_cash");
                                        // print(Pay_Typ_cash);
                                        // print(Pay_Typ_Disamt);
                                        // print(Pay_Typ_RoundOff);

                                        var amt1 = (double.parse(TotAmt)) -
                                            ((Pay_Typ_cash));
                                        var amt2 = amt1 - Pay_Typ_Disamt;
                                        var amt3 = amt2 - Pay_Typ_RoundOff;
                                        var amt = amt3 - Pay_Typ_Other_cash;
                                        var NetAmt = amt;
                                        // print(amt1);
                                        // print(amt2);
                                        // print(amt3);

                                        Pay_Typ_Tota_Amt_Controller.text =
                                            NetAmt.toStringAsFixed(3);
                                      });
                                    }
                                  },
                                  controller: Pay_Typ_OthAmt_Controller,
                                  enabled: true,
                                  validator: (v) {
                                    if (v!.isEmpty) return "Required";
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r"^\d+\.?\d{0,2}")),
                                  ],
                                  cursorColor: Colors.black,
                                  scrollPadding:
                                      EdgeInsets.fromLTRB(0, 20, 20, 0),
                                  decoration: InputDecoration(
                                    errorStyle: TextStyle(color: Colors.red),
                                    errorText: Pay_Typ_OthAmt_Valid == true
                                        ? "Invalid"
                                        : null,
                                    isDense: true,
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 10.0, 20.0, 16.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(14.0)),
                                    hintStyle: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                    labelText: "Other Amounts",
                                  ),
                                ),
                              ),
                            ),

                            //---------------Discount % And amt----------------------------
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, bottom: 10, right: 10, top: 10),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3.5,
                                    child: TextFormField(
                                      onChanged: (a) {
                                        if (a == "") {
                                          DisAmtController.text = "";
                                          var TotAmt = TotalAmtController.text;
                                          var amt1 = (double.parse(TotAmt)) -
                                              ((Pay_Typ_cash));
                                          var amt2 = amt1 - Pay_Typ_RoundOff;
                                          var amt3 = amt2 - Pay_Typ_Other_cash;
                                          Pay_Typ_Tota_Amt_Controller.text =
                                              amt3.toStringAsFixed(3);
                                          Pay_Typ_Disamt = 0.00;
                                          return;
                                        } else {
                                          setState(() {
                                            var TotAmt =
                                                TotalAmtController.text;
                                            Pay_Typ_Disamt =
                                                (double.parse(TotAmt) / 100) *
                                                    (double.parse(a));
                                            DisAmtController.text =
                                                Pay_Typ_Disamt.toString();
                                            print("Pay_Typ_Disamt");
                                            // print(Pay_Typ_cash);
                                            // print(Pay_Typ_Disamt);
                                            // print(Pay_Typ_RoundOff);

                                            var amt1 = (double.parse(TotAmt)) -
                                                ((Pay_Typ_cash));
                                            var amt2 = amt1 - Pay_Typ_Disamt;
                                            var amt3 = amt2 - Pay_Typ_RoundOff;
                                            var amt = amt3 - Pay_Typ_Other_cash;
                                            var NetAmt = amt;
                                            // print(amt1);
                                            // print(amt2);
                                            // print(amt3);

                                            Pay_Typ_Tota_Amt_Controller.text =
                                                NetAmt.toStringAsFixed(3);
                                          });
                                        }

                                        if (Pay_Typ_Cash_Controller.text !=
                                            "") {
                                          Pay_Typ_Cash_Valid = false;
                                        }

                                        if (Pay_Typ_OthAmt_Controller.text !=
                                            "") {
                                          Pay_Typ_OthAmt_Valid = false;
                                        }
                                      },
                                      controller: DisPerController,
                                      validator: (v) {
                                        if (v!.isEmpty) return "Required";
                                        return null;
                                      },
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r"^\d+\.?\d{0,2}")),
                                      ],
                                      cursorColor: Colors.black,
                                      scrollPadding:
                                          EdgeInsets.fromLTRB(0, 20, 20, 0),
                                      decoration: InputDecoration(
                                        errorStyle:
                                            TextStyle(color: Colors.red),
                                        isDense: true,
                                        contentPadding: EdgeInsets.fromLTRB(
                                            20.0, 10.0, 20.0, 16.0),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(14.0)),
                                        hintStyle: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                        labelText: "Disc %",
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, bottom: 10, right: 10, top: 10),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: TextFormField(
                                      controller: DisAmtController,
                                      readOnly: true,
                                      enabled: false,
                                      validator: (v) {
                                        if (v!.isEmpty) return "Required";
                                        return null;
                                      },
                                      cursorColor: Colors.black,
                                      scrollPadding:
                                          EdgeInsets.fromLTRB(0, 20, 20, 0),
                                      decoration: InputDecoration(
                                        errorStyle:
                                            TextStyle(color: Colors.red),
                                        isDense: true,
                                        contentPadding: EdgeInsets.fromLTRB(
                                            20.0, 10.0, 20.0, 16.0),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(14.0)),
                                        hintStyle: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                        labelText: "Amount",
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            //---------------Round off and Total-----------------------------
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, bottom: 10, right: 10, top: 10),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3.5,
                                    child: TextFormField(
                                      onChanged: (a) {
                                        if (a == "") {
                                          var TotAmt = TotalAmtController.text;
                                          var amt1 = (double.parse(TotAmt)) -
                                              ((Pay_Typ_cash));
                                          var amt2 = amt1 - Pay_Typ_Disamt;
                                          var amt3 = amt2 - Pay_Typ_Other_cash;
                                          Pay_Typ_Tota_Amt_Controller.text =
                                              amt3.toStringAsFixed(3);
                                          RoundOffController.text = "";
                                          Pay_Typ_RoundOff = 0.00;
                                          return;
                                        } else {
                                          print("aa =$a");
                                          setState(() {
                                            var TotAmt =
                                                TotalAmtController.text;
                                            Pay_Typ_RoundOff =
                                                (double.parse(a));

                                            var amt1 = (double.parse(TotAmt)) -
                                                ((Pay_Typ_cash));
                                            var amt2 = amt1 - Pay_Typ_Disamt;
                                            var amt3 = amt2 - Pay_Typ_RoundOff;
                                            var amt = amt3 - Pay_Typ_Other_cash;
                                            var NetAmt = amt;
                                            // print(amt1);
                                            // print(amt2);
                                            // print(amt3);

                                            print("Pay_Typ_RoundOff");
                                            // print(Pay_Typ_cash);
                                            // print(Pay_Typ_Disamt);
                                            // print(Pay_Typ_RoundOff);
                                            Pay_Typ_Tota_Amt_Controller.text =
                                                NetAmt.toStringAsFixed(3);
                                          });
                                        }
                                      },
                                      onTap: () {
                                        if (Pay_Typ_Cash_Controller.text !=
                                            "") {
                                          Pay_Typ_Cash_Valid = false;
                                        }

                                        if (Pay_Typ_OthAmt_Controller.text !=
                                            "") {
                                          Pay_Typ_OthAmt_Valid = false;
                                        }
                                      },
                                      controller: RoundOffController,
                                      validator: (v) {
                                        if (v!.isEmpty) return "Required";
                                        return null;
                                      },
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r"^\d+\.?\d{0,2}")),
                                      ],
                                      cursorColor: Colors.black,
                                      scrollPadding:
                                          EdgeInsets.fromLTRB(0, 20, 20, 0),
                                      decoration: InputDecoration(
                                        errorStyle:
                                            TextStyle(color: Colors.red),
                                        isDense: true,
                                        contentPadding: EdgeInsets.fromLTRB(
                                            20.0, 10.0, 20.0, 16.0),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(14.0)),
                                        hintStyle: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                        labelText: "Round Off",
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, bottom: 10, right: 10, top: 10),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: TextFormField(
                                      controller: Pay_Typ_Tota_Amt_Controller,
                                      readOnly: true,
                                      enabled: false,
                                      validator: (v) {
                                        if (v!.isEmpty) return "Required";
                                        return null;
                                      },
                                      cursorColor: Colors.black,
                                      scrollPadding:
                                          EdgeInsets.fromLTRB(0, 20, 20, 0),
                                      decoration: InputDecoration(
                                        errorStyle:
                                            TextStyle(color: Colors.red),
                                        isDense: true,
                                        contentPadding: EdgeInsets.fromLTRB(
                                            20.0, 10.0, 20.0, 16.0),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(14.0)),
                                        hintStyle: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                        labelText: "Balance",
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            //---------------ok  and Back Buttons-----------------------------
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 10),
                                    child: ElevatedButton(

                                      // color: Colors.blue,
                                      onPressed: () async {
                                        if (Pay_Typ_Cash_Controller.text ==
                                            "") {
                                          setState(() {
                                            Pay_Typ_Cash_Valid = true;
                                            return;
                                          });
                                        } else {
                                          setState(() {
                                            Pay_Typ_Cash_Valid = false;
                                            return;
                                          });
                                        }

                                        if (Pay_Typ_OthAmt_TxtBx_Visible ==
                                                true &&
                                            Pay_Typ_OthAmt_Controller.text ==
                                                "") {
                                          setState(() {
                                            Pay_Typ_OthAmt_Valid = true;
                                            return;
                                          });
                                        } else {
                                          setState(() {
                                            Pay_Typ_OthAmt_Valid = false;
                                            return;
                                          });
                                        }

                                        setState(() {
                                          if (Pay_Typ_Tota_Amt_Controller
                                                  .text ==
                                              "0.000") {
                                            setState(() {
                                               print("inn");
                                              TotalAmtController.text =
                                                  "Amount paid";
                                              Itm_Tbl_DeleteBttn_Visible =
                                                  false;
                                            });
                                          } else {}
                                        });
                                        var k = await PaymentCompleted();
                                        if (k == true) {
                                          Navigator.pop(context);
                                          IBSave(IBD);
                                        }
                                      },
                                      child: Text(
                                        (ButtonName), //OK
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, right: 10),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        print("  Back  ");
                                        setState(() {
                                          Pay_Frm_Reset();
                                          PaymentAmtPopupVisilbe = false;
                                          PaymentPopupVisilbe = true;
                                          Pay_Typ_OthAmt_TxtBx_Visible =
                                              false;
                                        });
                                        PaymentName = "";
                                      },
                                      child: Stack(
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 5,
                                                  top: 5,
                                                  bottom: 5,
                                                  right: 5),
                                              child: Text(
                                                ("BACK"),
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.white,
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ]),
                        ),

                        //-------------------Payment typ credit-----------------------------------

                        Visibility(
                            visible: Payment_Credit_Visilbe == true,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 60),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          child: TypeAheadField(
                                              textFieldConfiguration:
                                                  TextFieldConfiguration(
                                                      style: TextStyle(),
                                                      controller:
                                                          customerController,
                                                      decoration:
                                                          InputDecoration(
                                                        errorStyle: TextStyle(
                                                            color: Colors.red),
                                                        errorText: customerSelect ==
                                                                true
                                                            ? "Please Select Customer ?"
                                                            : null,
//                            errorText: _validateName ? "please enter name" : null,
//                            errorBorder:InputBorder.none ,
                                                        suffixIcon: IconButton(
                                                          icon: Icon(Icons
                                                              .remove_circle),
                                                          color: Colors.blue,
                                                          onPressed: () {
                                                            setState(() {
                                                              print("cleared");
                                                              customerController
                                                                  .text = "";
                                                              customerId = 0;
                                                            });
                                                          },
                                                        ),

                                                        isDense: true,
                                                        contentPadding:
                                                            EdgeInsets.fromLTRB(
                                                                20.0,
                                                                10.0,
                                                                20.0,
                                                                10.0),
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        14.0)),
                                                        // i need very low size height
                                                        labelText:
                                                            'customer search', // i need to decrease height
                                                      )),
                                              suggestionsBoxDecoration:
                                                  SuggestionsBoxDecoration(
                                                      elevation: 90.0),
                                              suggestionsCallback: (pattern) {
                                                return users.where((user) =>
                                                    user.lhName
                                                        .toUpperCase()
                                                        .contains(pattern
                                                            .toUpperCase()));
                                              },
                                              itemBuilder:
                                                  (context, suggestion) {
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
                                                    // focusColor: Colors.blue,
                                                    // hoverColor: Colors.red,
                                                    title: Text(
                                                      suggestion.lhName,
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                );
                                              },
                                              onSuggestionSelected:
                                                  (suggestion) {
                                                print(suggestion.lhName);
                                                print("selected");

                                                customerController.text =
                                                    suggestion.lhName;
                                                print("close.... $customerId");
                                                customerId = 0;
                                                Customername =
                                                    suggestion.lhName;
                                                print(suggestion.id);
                                                print(".......customerId");
                                                customerId = suggestion.id;
                                                print(customerId);
                                                print("...........");
                                              },
                                              errorBuilder: (BuildContext
                                                          context,
                                                      Object? error) =>
                                                  Text('$error',
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .errorColor)),
                                              transitionBuilder: (context,
                                                      suggestionsBox,
                                                      animationController) =>
                                                  FadeTransition(
                                                    child: suggestionsBox,
                                                    opacity: CurvedAnimation(
                                                        parent:
                                                            animationController!,
                                                        curve:
                                                            Curves.elasticIn),
                                                  ))),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller:
                                              Pay_Typ_Credit_Ph_Controller,
                                          enabled: true,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r"^\d+\.?\d{0,2}")),
                                          ],
                                          keyboardType: TextInputType.number,
                                          cursorColor: Colors.black,
                                          scrollPadding:
                                              EdgeInsets.fromLTRB(0, 20, 20, 0),
                                          decoration: InputDecoration(
                                            errorStyle:
                                                TextStyle(color: Colors.red),
                                            errorText:
                                                Pay_Typ_Credit_Ph_Valid == true
                                                    ? "Invalid PH Number"
                                                    : null,
                                            isDense: true,
                                            contentPadding: EdgeInsets.fromLTRB(
                                                20.0, 10.0, 20.0, 16.0),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        14.0)),
                                            hintStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15),
                                            labelText: "PH Number",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        //------------credit---ok  and Back Buttons-----------------------------
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              setState(() {
                                                print(customerController.text);
                                                if (Pay_Typ_Credit_Ph_Controller
                                                        .text ==
                                                    "") {
                                                  Pay_Typ_Credit_Ph_Valid =
                                                      true;
                                                }
                                                if (customerController.text ==
                                                    "") {
                                                  customerSelect = true;
                                                  return;
                                                }
                                              });
                                              if (customerController.text !=
                                                      "" &&
                                                  Pay_Typ_Credit_Ph_Controller
                                                          .text !=
                                                      "") {
                                                TotalAmtController.text =
                                                    "Credited";

                                                var k =
                                                    await PaymentCompleted();
                                                if (k == true) {
                                                  Navigator.pop(context);
                                                  IBSave(IBD);
                                                }
                                              }
                                            },
                                            child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5,
                                                    top: 5,
                                                    bottom: 5,
                                                    right: 5),
                                                child: Text(
                                                  (ButtonName), //OK
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.white,
                                                  ),
                                                )),
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(

                                            onPressed: () {
                                              print(" Back ");
                                              setState(() {
                                                Pay_Frm_Reset();

                                                PaymentAmtPopupVisilbe = false;
                                                PaymentPopupVisilbe = true;
                                                Pay_Typ_OthAmt_TxtBx_Visible =
                                                    false;
                                              });
                                              PaymentName = "";
                                            },
                                            child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5,
                                                    top: 5,
                                                    bottom: 5,
                                                    right: 5),
                                                child: Text(
                                                  ("BACK"),
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.white,
                                                  ),
                                                )),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ))
                      ])),
                ],
              ),
            ]);
          });
        });
  }

//-------------------------Set--Payment Type--- End-----------------------------------------

//------------------------ Paymet Form Rest-------------
  Pay_Frm_Reset() {
    setState(() {
      PaymentPopupVisilbe = false;
      PaymentAmtPopupVisilbe = true;
      Pay_Typ_Cash_Valid = false;
      Pay_Typ_OthAmt_Valid = false;
      Pay_Typ_Cash_Controller.text = "";
      Pay_Typ_OthAmt_Controller.text = "";
      DisPerController.text = "";
      DisAmtController.text = "";
      Pay_Typ_Tota_Amt_Controller.text = TotalAmtController.text;
      Pay_Typ_cash = 0.00;
      Pay_Typ_Disamt = 0.00;
      Pay_Typ_RoundOff = 0.00;
      Pay_Typ_Other_cash = 0.00;
      Pay_Typ_OthAmt_Controller.text = "";
      RoundOffController.text = "";
      customerSelect = false;
      Pay_Typ_Credit_Ph_Valid = false;
      Pay_Typ_Credit_Ph_Controller.text = "";
      customerController.text = "";
      Payment_Credit_Visilbe = false;
    });
  }

//------------------------  Payment Completed-------------
  PaymentCompleted() {
    if (Pay_Typ_Tota_Amt_Controller.text == "0.000" &&
        Pay_Typ_OthAmt_TxtBx_Visible == false) {
      print("On Cash");
      // print("Pay_Typ_Cash_Controller.text");
      // print(Pay_Typ_Cash_Controller.text);

      // print("Pay_Typ_OthAmt_Controller.text");
      // print(Pay_Typ_OthAmt_Controller.text);

      // print("DisPerController.text");
      // print(DisPerController.text);

      // print(" DisAmtController ");
      // print(DisAmtController.text);

      print("Pay_Typ_cash  ");
      print(Pay_Typ_cash.toString());

      print(" Pay_Typ_Disamt ");
      print(Pay_Typ_Disamt.toString());

      print(" Pay_Typ_RoundOff ");
      print(Pay_Typ_RoundOff.toString());

      print(" Pay_Typ_Other_cash ");
      print(Pay_Typ_Other_cash.toString());
      Pay_Typ_Other_cash = 0.00;
      Customername = "xx";
      customerId = 0;

      // print(" Pay_Typ_OthAmt_Controller ");
      // print(Pay_Typ_OthAmt_Controller.text);

      // print(" RoundOffController ");
      // print(RoundOffController.text);

      // print(" Pay_Typ_Credit_Ph_Controller ");
      // print(Pay_Typ_Credit_Ph_Controller.text);

      // print("customerController  ");
      // print(customerController.text);

      return true;
    } else if (Pay_Typ_Tota_Amt_Controller.text == "0.000" &&
        Pay_Typ_OthAmt_TxtBx_Visible == true &&
        Pay_Typ_OthAmt_Controller.text != "") {
      print("On Cash And other Amount");
      Customername = "xx";
      customerId = 0;
      return true;
    } else if (Pay_Typ_OthAmt_TxtBx_Visible == false &&
        Payment_Credit_Visilbe == true) {
      print("On Credit");
      Pay_Typ_cash = 0;
      Pay_Typ_Disamt = 0;
      Pay_Typ_RoundOff = 0;
      Pay_Typ_Other_cash = 0;
      return true;
    }

    print(" exit PaymentCompleted not satisfy");
  }

  //------------------------PaymentCompleted-------------



  //----------------------------- GetExisting_data_Of_Tablenum--adn Ordernum-----------------------------
  TabelNumDatapopup({required String type,@required controller,required bool validation}){


    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context)
        {
          return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title:Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Expanded(child: Text('Customer Order Delivery')),

                    IconButton(icon: Icon(Icons.close,size: 30,), onPressed: (){ Navigator.pop(context);},color: Colors.red,)

                  ],),
                  actions: [
                    SizedBox(
                        width: 300,
                        child: Row(children: [
                          Expanded(child: cw.CUButton(name: "OK",H: 40,color: Colors.green,W: 60,function: (){
                            if(controller.text==""){
                              setState((){
                                validation=true;
                              });
                              return;
                            }
                            else{
                              setState((){
                                validation=false;
                              });

                            }
                            GetTabelNumData(type);
                            Navigator.pop(context);
                          })),
                          Spacer(),
                          Expanded(child: cw.CUButton(name: "CLEAR",H: 40,color: Colors.deepPurpleAccent,W: 60,function: (){
                            setState(() {
                              controller.text="";
                            });
                          }))
                        ],)) ],
                  content:SizedBox(height: 100,
                    width: 300,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: controller,
                          enabled: true,
                          validator: (v) {
                            if (v!.isEmpty) return "Required";
                            return null;
                          },
                          cursorColor: Colors.black,
                          scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                          inputFormatters: <TextInputFormatter>[],
                          decoration: InputDecoration(
                              errorStyle: TextStyle(color: Colors.red),
                              errorText:
                              validation == true ? "Invalid" : null,
                              isDense: true,
                              contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14.0)),
                              hintStyle: TextStyle(
                                  color: Colors.black, fontSize: 15),
                              labelText: type,
                              labelStyle: TextStyle(fontSize: 13)
                          ),
                        ),
                      ),
                    ),) ,
                );
              });
        });
  }




  GetTabelNumData(txtbox)async{
    print(txtbox.toString());
    var res;
    print(TablenumController.text);


    if(txtbox=="Order No"){
      var Ordernum=OrderumController.text;
      res=await cw.CUget_With_Parm(api:"Soheader/$Ordernum/orderno",Token: token);
    }
    else if(txtbox=="Table No"){
      var Tablenum=TablenumController.text;
      res=await cw.CUget_With_Parm(api:"Soheader/$Tablenum/tableno",Token: token);
    }
    else{
      var Bill_No=Bill_No_Controller.text;
      res=await cw.CUget_With_Parm(api:"SalesHeaders/$Bill_No/billcopy",Token: token);

      }

    if(res!=false){
      setState(() {
        IBD.clear();
        TD.clear();
        TotalAmtController.text = "";
            TotalAmt=0.0;

      });
      var TextBoxget=json.decode(res);
print("get datas");
print(TextBoxget.toString());

      if(txtbox=="Bill No"){
        print("on Bill No:     "+TextBoxget.toString());
        print("on Bill No:     "+TextBoxget['salesHeader'][0]['id'].toString());
        setState(() {
          EditId=TextBoxget['salesHeader'][0]['id'];
          PaymentTypID=TextBoxget['salesHeader'][0]['paymentType'];
           Token_Num=TextBoxget['salesHeader'][0]['tokenNo'].toString();
          Customername=TextBoxget['salesHeader'][0]['partyName'].toString();
         // customerId=TextBoxget['salesHeader'][0]['voucherNo'];
         // OrderumController.text=TextBoxget['salesHeader'][0]['voucherNo'].toString();
          TokennumController.text=TextBoxget['salesHeader'][0]['tokenNo'].toString();
          TablenumController.text=TextBoxget['salesHeader'][0]['deliveryTo'].toString();
          // EditId=TextBoxget['id'];
          ButtonName="Update";
          // print("------------------------------------");
          // print("EditId");
          // print(EditId);
          // print("PaymentTypID");
          // print(PaymentTypID);
          // print("Token_Num");
          // print(Token_Num);
          // print("Customername");
          // print(Customername);
          TabelNumDataBinding(TextBoxget['salesDetails'],txtbox);
        });
      }
      else if(TextBoxget['data']['isSale']==null||TextBoxget['data']['isSale']==false)
        {
        EditId=null;
        print("TextBoxget: "+TextBoxget.toString());
        TabelNumDataBinding(TextBoxget['data']['sodetailed'],txtbox);
        setState(() {
         OrderumController.text=TextBoxget['data']['voucherNo'].toString();
          TokennumController.text=TextBoxget['data']['tokenNo'].toString();
          TablenumController.text=TextBoxget['data']['deliveryTo'].toString();
        });

      }
      else{
        cw.MessagePopup(context, "Bill Already Generated", Colors.red.shade300);
        listabledataShow=false;
        }
    }
    else{
      TotalAmt=0.0;
      IBD.clear();
      TD.clear();
      listabledataShow=false;
       TotalAmtController.text=TotalAmt.toString();
      getTokenNo();
      //GetOrderNum();
      ButtonName="Save";
    }

  }




  TabelNumDataBinding(a,typ){
    print("aaaaa");
    print(EditId.toString());

    for(int i=0;i<a.length;i++){

     // print(a[i]['itemName']);


      ItmBLdata = ItmBillDetails(

        ItemSlNo:i,
        itemId: a[i]['itemId'],
        qty: a[i]['qty'],
        rate: a[i]['rate'],
        disPercentage: a[i]['disPercentage'],
        cgstPercentage: a[i]['cgstPercentage'],
        sgstPercentage: a[i]['sgstPercentage'],
        cessPercentage: a[i]['cessPercentage'],
        discountAmount: a[i]['discountAmount'],
        cgstAmount: a[i]['CgstPercentage'] == null
            ? "0"
            : (total / 100) * a[i]['CgstPercentage'],
        sgstAmount: a[i]['SgstPercentage'] == null
            ? "0"
            : (total / 100) * a[i]['SgstPercentage'],
        cessAmount: 0,
        igstPercentage: a[i]['Igstpercentage'],
        igstAmount: a[i]['Igstpercentage'] == null
            ? "0"
            : (total / 100) * UomTableData['Igstpercentage'],
        taxPercentage: a[i]['txPercentage'],
        taxAmount: a[i]['taxAmount'],
        taxInclusive: a[i]['taxInclusive'],
        amountBeforeTax: a[i]['amountBeforeTax'],
        amountIncludingTax: a[i]['amountIncludingTax'],
        netTotal: a[i]['netTotal'],
        hsncode: a[i]['hsncode'],
        gdnId:0,// a[i]['itemid'],
        taxId: a[i]['taxId'],
        rackId:0,// a[i]['itemid'],
        addTaxId: a[i]['addTaxId'],
        unitId: a[i]['unitId'],
        nosInUnit:0,// a[i]['itemid'],
        //ele.Nos_In_Unit,
        barcode:null,// a[i]['itemid'],
        //
        StockId: a[i]['stockId'],
        BatchNo:null,// a[i]['unitId'],
        ExpiryDate:null, //a[i]['unitId'],
        Notes: a[i]['note'],
        adlDiscAmount: a[i]['adlDiscAmount'],
        adlDiscPercent: a[i]['adlDiscPercent'],
         shid: EditId
      );
      setState(() {
         IBD.add(ItmBLdata);
      });
      print("-----------------------------------");
      print(json.encode(IBD));

        TDdata = Tabledata(



          id: a[i]['itemid'],
          ItemSlNo: i,
          Name:typ=="Bill No"?a[i]['itmName']:a[i]['itemName'],
          // Name: a[i]['itemName'],
          Qty: a[i]['qty'],
          rate: a[i]['rate'],
          Total: a[i]['netTotal'],
          UOM:typ=="Bill No"?a[i]['uom']:a[i]['description'],
          //UOM: a[i]['description'],
           AmtWithTax:a[i]['amountIncludingTax'],
        );
        setState(() {
          TD.add(TDdata);
        });

// print("-----------------------------------");
//   print(json.encode(ItmBLdata));

      TotalAmt=a[i]['amountIncludingTax']+TotalAmt;
      setState(() {

       TotalAmtController.text=TotalAmt.toString();
      });
      slnum=i;
    }
    listabledataShow = true;
  }







  ///-----------------------------------------------------All functions End---------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width > 500
        ? SafeArea(
            child: Scaffold(
                //-----------------bottomNavigationBar -----Save And Pay buttons------------------------

                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(145.0),
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Container(
                        height: 80,
                        decoration: BoxDecoration(
                            gradient: new LinearGradient(
                                colors: [Color(0xFFE7E9EE), Color(0xFF328BF6)],
                                begin: FractionalOffset.centerLeft,
                                end: FractionalOffset.centerRight,
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp)),
                        width: double.maxFinite,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            //  bottom: 1,
                              right: 10,
                              left: 10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      Widget noButton = TextButton(
                                        child: Text("No"),
                                        onPressed: () {
                                          setState(() {
                                            print("No...");
                                            Navigator.of(context,
                                                rootNavigator: true)
                                                .pop();
                                            // Navigator.pop(
                                            //     context); // this is proper..it will only pop the dialog which is again a screen
                                          });
                                        },
                                      );

                                      Widget yesButton = TextButton(
                                        child: Text("Yes"),
                                        onPressed: () {
                                          setState(() {
                                            print("yes...");
                                            pref.remove('userData');
                                            Navigator.of(context,
                                                rootNavigator: true)
                                                .pop();
                                            // Navigator.pop(context); //okk
//                              Navigator.pop(context);
                                            Navigator.pushReplacementNamed(
                                                context, "/logout");

//                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()),);
                                          });
                                        },
                                      );
                                      showDialog(
                                          context: context,
                                          builder: (c) => AlertDialog(
                                              content: Text(
                                                  "Do you really want to logout?"),
                                              actions: [yesButton, noButton]));
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      // fit: StackFit.expand,
                                      children: [
                                        Center(
                                          child: Container(
                                            height: 60,
                                            width: 60,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(40.0),
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/icon1.jpg"),
                                                    fit: BoxFit.fill)),
                                            margin: new EdgeInsets.only(
                                                left: 0.0,
                                                top: 5.0,
                                                right: 0.0,
                                                bottom: 0.0),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Center(
                                                child: Text(
                                                  "",
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.red),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    print("hi");
                                  },
                                  child: Container(
                                      margin: EdgeInsets.only(top: 10, bottom: 15),
                                      child: Column(children: [
                                        SizedBox(
                                          height: 7,
                                        ),
                                        Expanded(
                                          child: Text(
                                            // "Shop Visited",
                                            "Item Bill",
                                            style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 7),
                                            child: Text(
                                              "${branchName.toString()}",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ])),
                                ),
                                Spacer(),

                                GestureDetector(
                                  onTap: () {
                                    Widget noButton = TextButton(
                                      child: Text("No"),
                                      onPressed: () {
                                        setState(() {
                                          print("No...");
                                          Navigator.of(context, rootNavigator: true)
                                              .pop();
                                          // Navigator.pop(
                                          //     context); // this is proper..it will only pop the dialog which is again a screen
                                        });
                                      },
                                    );

                                    Widget yesButton = TextButton(
                                      child: Text("Yes"),
                                      onPressed: () {
                                        setState(() {
                                          print("yes...");
                                          pref.remove('userData');
                                          Navigator.of(context, rootNavigator: true)
                                              .pop();
                                          // Navigator.pop(context); //okk
//                              Navigator.pop(context);
                                          Navigator.pushReplacementNamed(
                                              context, "/logout");

//                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()),);
                                        });
                                      },
                                    );
                                    showDialog(
                                        context: context,
                                        builder: (c) => AlertDialog(
                                            content: Text(
                                                "Do you really want to logout?"),
                                            actions: [yesButton, noButton]));
                                  },
                                  child: Container(
                                    margin: new EdgeInsets.only(
                                        left: 0.0,
                                        top: 25.0,
                                        right: 0.0,
                                        bottom: 0.0),
                                    child: Text(
                                      "${userName.toString()}",
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.white),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(top: 25),
                                  child: GestureDetector(
                                      onTap: () {
                                        TabelNumDatapopup(type: "Bill No", controller: Bill_No_Controller, validation: false);
                                      },
                                      child: Column(
                                        children: [
                                          Text(BillNumber??"",style: TextStyle(color: Colors.black),),
                                          Icon(
                                            Icons.article_outlined,
                                            color: Colors.white,
                                            size: 25,
                                          ),
                                        ],
                                      )),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(top: 25,left: 10),
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Rms_Homes(),
                                            ));
                                      },
                                      child: Icon(
                                        Icons.home,
                                        color: Colors.white,
                                        size: 27,
                                      )),
                                ),
                              ]),
                        ),
                      ),

                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          //----------------------table num-----------------------------
                          SizedBox(
                            width: 4,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: TablenumController,
                              onTap: (){
                                TabelNumDatapopup(controller:TablenumController,type:"Table No",validation:TablenumValid);
                              },
                              enabled: true,
                              validator: (v) {
                                if (v!.isEmpty) return "Required";
                                return null;
                              },
                              cursorColor: Colors.black,
                              scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                              inputFormatters: <TextInputFormatter>[],
                              decoration: InputDecoration(
                                errorStyle: TextStyle(color: Colors.red,),
                                errorText: TablenumValid == true ? "Invalid" : null,

                                isDense: true,
                                contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14.0)),
                                hintStyle:
                                TextStyle(color: Colors.black, fontSize: 15),
                                labelText: "Table No",
                              ),
                            ),
                          ),

                          //----------------------Token num-----------------------------
                          SizedBox(
                            width: 6,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: TokennumController,
                              readOnly: true,
                              enabled: false,
                              validator: (v) {
                                if (v!.isEmpty) return "Required";
                                return null;
                              },
                              cursorColor: Colors.black,
                              scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                              decoration: InputDecoration(
                                errorStyle: TextStyle(color: Colors.red),
                                //  errorText:TokennumController  ? "Invalid" : null,
//                    suffixIcon: Icon(
//                      Icons.calendar_today,
//                      color: Colors.blue,
//                      size: 24,
//                    ),
                                isDense: true,

                                contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14.0)),
                                hintStyle:
                                TextStyle(color: Colors.black, fontSize: 15),
                                labelText: "Token No",
                              ),
                            ),
                          ),

                          //----------------------Order num-----------------------------
                          SizedBox(
                            width: 6,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: OrderumController,
                              onTap: (){

                                TabelNumDatapopup(controller:OrderumController,type:"Order No",validation:false);
                              },
                              validator: (v) {
                                if (v!.isEmpty) return "Required";
                                return null;
                              },
                              cursorColor: Colors.black,
                              scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                              decoration: InputDecoration(
                                errorStyle: TextStyle(color: Colors.red),
                                isDense: true,
                                contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14.0)),
                                hintStyle:
                                TextStyle(color: Colors.black, fontSize: 15),
                                labelText: "Order No",
                              ),
                            ),
                          ),

                          SizedBox(
                            width: 4,
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                bottomNavigationBar:  Container(
                  color: Color(0xFFFDF4F4),
                  child: Row(
                    children: [
                      // Expanded(
                      //   child: Padding(
                      //     padding:
                      //     const EdgeInsets.only(left: 10, bottom: 2, top: 5),
                      //     child: RaisedButton(
                      //       color: Colors.blue,
                      //       onPressed: () {
                      //         print("onSave");
                      //         print(jsonEncode(IBD));
                      //         IBSave(IBD);
                      //       },
                      //       child: Stack(
                      //         children: [
                      //           Padding(
                      //               padding: EdgeInsets.only(
                      //                   left: 5, top: 5, bottom: 2, right: 5),
                      //               child: Text(
                      //                 ("Saves"),
                      //                 style: TextStyle(
                      //                   fontSize: 20.0,
                      //                   color: Colors.white,
                      //                 ),
                      //               )),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Expanded(
                        child: Padding(
                          padding:
                          const EdgeInsets.only(left: 10, bottom: 2, top: 5),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // This is for the text color
                            ),
                            onPressed: () {
                              print("Payment Type");
                              PaymentName = "";
                              SetPaymentType();
                              PaymentAmtPopupVisilbe = false;
                              Pay_Typ_Cash_Valid = false;
                            },
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                (ButtonName),
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )

                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, bottom: 5, right: 5, top: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: TextFormField(
                              controller: TotalAmtController,
                              readOnly: true,
                              enabled: false,
                              validator: (v) {
                                if (v!.isEmpty) return "Required";
                                return null;
                              },
                              cursorColor: Colors.black,
                              scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                errorStyle: TextStyle(color: Colors.red),
                                //  errorText:TokennumController  ? "Invalid" : null,
//                    suffixIcon: Icon(
//                      Icons.calendar_today,
//                      color: Colors.blue,
//                      size: 24,
//                    ),
                                isDense: true,

                                contentPadding:
                                EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 16.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14.0)),
                                hintStyle:
                                TextStyle(color: Colors.black, fontSize: 15),
                                labelText: "Total",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),




                body: ListView(
                    shrinkWrap: true,
                    //physics: NeverScrollableScrollPhysics(),
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Column(
                                children: [
                                  Row(children: [
                                    SizedBox(
                                      height: 50,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, left: 10),
                                        child: GestureDetector(
                                          onTap: () {
                                            print("uikuy");
                                            //print(MediaQuery.of(context).size.width.toString());
                                            // wifiprinting();
                                          },
                                          child: Text(
                                            "Item Group",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TypeAheadField(
                                          textFieldConfiguration:
                                              TextFieldConfiguration(
                                                  style: TextStyle(),
                                                  controller: ItemGrpController,
                                                  decoration: InputDecoration(
                                                    errorStyle: TextStyle(
                                                        color: Colors.red),
                                                    errorText: itemSelectvalidate
                                                        ? "Please Select Item  Group?"
                                                        : null,
//                            errorText: _validateName ? "please enter name" : null,
//                            errorBorder:InputBorder.none ,
                                                    suffixIcon: IconButton(
                                                      icon: Icon(
                                                          Icons.remove_circle),
                                                      color: Colors.blue,
                                                      onPressed: () {
                                                        setState(() {
                                                          print("cleared");
                                                          ItemGrpController
                                                              .text = "";
                                                          ItemGrpId = 0;
                                                          itmLstVsbl = false;
                                                        });
                                                      },
                                                    ),

                                                    isDense: true,
                                                    contentPadding:
                                                        EdgeInsets.fromLTRB(
                                                            20.0,
                                                            10.0,
                                                            20.0,
                                                            10.0),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    14.0)),
                                                    labelText:
                                                        'Item Group search',
                                                  )),
                                          suggestionsBoxDecoration:
                                              SuggestionsBoxDecoration(
                                                  elevation: 0.0),
                                          suggestionsCallback: (pattern) {
                                            return ItmGrp.where((user) =>
                                                user.igDescription.contains(
                                                    pattern.toUpperCase()));
                                          },
                                          itemBuilder: (context, suggestion) {
                                            return Card(
                                              margin: EdgeInsets.only(
                                                  top: 2, right: 2, left: 2),
                                              color: Colors.blue,
                                              child: ListTile(
                                                // focusColor: Colors.blue,
                                                // hoverColor: Colors.red,
                                                title: Text(
                                                  suggestion.igDescription,
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            );
                                          },
                                          onSuggestionSelected: (suggestion) {
                                            print(suggestion.igDescription);
                                            print("selected");
                                            setState(() {
                                              getItem(suggestion.id);
                                              ItemGrpController.text =
                                                  (suggestion.igDescription)
                                                      .toString();
                                              ItemLstController.text = "";
                                            });

                                            print("...........");
                                          },
                                          errorBuilder: (BuildContext context,
                                                  Object? error) =>
                                              Text('$error',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .errorColor)),
                                          transitionBuilder: (context,
                                                  suggestionsBox,
                                                  animationController) =>
                                              FadeTransition(
                                                child: suggestionsBox,
                                                opacity: CurvedAnimation(
                                                    parent: animationController!,
                                                    curve: Curves.elasticIn),
                                              )),
                                    )),
                                  ]),

                                  Visibility(
                                    visible: itmGrpVsbl == true,
                                    // visible:ItmGrp.length>0 ,
                                    child: Container(
                                      height: 250,
                                      child: imageSetting == false
                                          ?
                                          //----------------------Condition for button or image----------------------------

//  for text.....................

                                          GridView.builder(
                                            physics: ScrollPhysics(),
                                            itemCount: ItmGrp.length,
                                            shrinkWrap: true,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 3,
                                                    mainAxisExtent: 50),
                                            itemBuilder: (c, i) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(
                                                        8.0),
                                                child: ElevatedButton(
                                                  style: ButtonStyle(
                                                    backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 175, 211, 246)),
                                                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // This is for the text color
                                                    splashFactory: InkRipple.splashFactory, // This will give the splash effect similar to RaisedButton
                                                    overlayColor: MaterialStateProperty.resolveWith<Color>(
                                                          (Set<MaterialState> states) {
                                                        if (states.contains(MaterialState.hovered))
                                                          return Colors.black; // Hover color
                                                        if (states.contains(MaterialState.pressed))
                                                          return Colors.blueAccent; // Splash color
                                                        return null; // Default, no color
                                                      },
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    // if(TablenumController.text==""){
                                                    //   setState(() {
                                                    //     TablenumValid=true;
                                                    //   });
                                                    //
                                                    // }else {
                                                    print("index 1:  " + (btnItmGrp[i]["igDescription"]).toString());
                                                    setState(() {
                                                      TablenumValid = false;
                                                      getItem((btnItmGrp[i]["id"]));
                                                      ItemLstController.text = "";
                                                      ItemGrpController.text = (btnItmGrp[i]["igDescription"]).toString();
                                                    });
                                                    // }
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.all(5.0),
                                                    child: Text(
                                                      (btnItmGrp[i]["igDescription"]).toString(),
                                                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                                                    ),
                                                  ),
                                                )

                                              );
                                            },
                                          )
                                          :

//  ---for image............
                                          GridView.builder(
                                              physics: ScrollPhysics(),
                                              itemCount: ItmGrp.length,
                                              shrinkWrap: true,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 3,
                                                      mainAxisExtent: 80),
                                              itemBuilder: (c, i) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 255, 255, 255)),
                                                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // If you have text colors set to white
                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(30),
                                                        ),
                                                      ),
                                                      overlayColor: MaterialStateProperty.resolveWith<Color>(
                                                            (Set<MaterialState> states) {
                                                          if (states.contains(MaterialState.hovered))
                                                            return Colors.black; // Hover color
                                                          if (states.contains(MaterialState.pressed))
                                                            return Colors.blueAccent; // Splash color
                                                          return null; // Default, no color
                                                        },
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      print("index 2:  " + (btnItmGrp[i]["igDescription"]).toString());
                                                      setState(() {
                                                        getItem((btnItmGrp[i]["id"]));
                                                        ItemLstController.text = "";
                                                        ItemGrpController.text = (btnItmGrp[i]["igDescription"]).toString();
                                                      });
                                                    },
                                                    child: Image.network(
                                                      (btnItmGrp[i]["igDiplayImagepath"] == null
                                                          ? "https://st4.depositphotos.com/14953852/24787/v/600/depositphotos_247872612-stock-illustration-no-image-available-icon-vector.jpg"
                                                          : (btnItmGrp[i]["igDiplayImagepath"])),
                                                    ),
                                                  )

                                                );
                                              },
                                            ),
                                    ),
                                  ),

                                  //-------------------------------------Item Grp End-------------------------------------------

                                  Visibility(
                                    visible: itmLstVsbl == true,
                                    child: Divider(
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),

                                  //------------------------------------Fot Item---------------------------------------------------------
                                  Visibility(
                                    visible: itmLstVsbl == true,
                                    child: Row(children: [
                                      SizedBox(
                                        height: 50,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, left: 10, right: 70),
                                          child: Text(
                                            "Item",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TypeAheadField(
                                            textFieldConfiguration:
                                                TextFieldConfiguration(
                                                    style: TextStyle(),
                                                    controller:
                                                        ItemLstController,
                                                    decoration: InputDecoration(
                                                      errorStyle: TextStyle(
                                                          color: Colors.red),
                                                      errorText: itemSelectvalidate
                                                          ? "Please Select Item ?"
                                                          : null,
//                            errorText: _validateName ? "please enter name" : null,
//                            errorBorder:InputBorder.none ,
                                                      suffixIcon: IconButton(
                                                        icon: Icon(Icons
                                                            .remove_circle),
                                                        color: Colors.blue,
                                                        onPressed: () {
                                                          setState(() {
                                                            print("cleared");
                                                            ItemLstController
                                                                .text = "";
                                                            ItemGrpId = 0;
                                                            quantityController
                                                                .text = "1";
                                                          });
                                                        },
                                                      ),

                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.fromLTRB(
                                                              20.0,
                                                              10.0,
                                                              20.0,
                                                              10.0),
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      14.0)),
                                                      labelText: 'Item search',
                                                    )),
                                            suggestionsBoxDecoration:
                                                SuggestionsBoxDecoration(
                                                    elevation: 90.0),
                                            suggestionsCallback: (pattern) {
                                              return ItmLst.where((user) =>
                                                  user.itmName.contains(
                                                      pattern.toUpperCase()));
                                            },
                                            itemBuilder: (context, suggestion) {
                                              return Card(
                                                margin: EdgeInsets.only(
                                                    top: 2, right: 2, left: 2),
                                                color: Colors.blue,
                                                child: ListTile(
                                                  // focusColor: Colors.blue,
                                                  // hoverColor: Colors.red,
                                                  title: Text(
                                                    suggestion.itmName,
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              );
                                            },
                                            onSuggestionSelected: (suggestion) {
                                              print(suggestion.itmName);
                                              print("selected");
                                              print(json
                                                  .encode(suggestion)
                                                  .toString());

                                              var itm_data =
                                                  jsonEncode(suggestion);
                                              setState(() {
                                                ItemLstController.text =
                                                    (suggestion.itmName)
                                                        .toString();
                                                ListoTable(
                                                    jsonDecode(itm_data));
                                              });

                                              print("...........");
                                            },
                                            errorBuilder: (BuildContext context,
                                                    Object? error) =>
                                                Text('$error',
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .errorColor)),
                                            transitionBuilder: (context,
                                                    suggestionsBox,
                                                    animationController) =>
                                                FadeTransition(
                                                  child: suggestionsBox,
                                                  opacity: CurvedAnimation(
                                                      parent:
                                                          animationController!,
                                                      curve: Curves.elasticIn),
                                                )),
                                      )),
                                    ]), // headig of item grp
                                  ),

                                  Visibility(
                                    visible: itmLstVsbl == true,
                                    child: Container(
                                      height: 250,
                                      child: imageSetting == false
                                          ?
                                          //------------------------img or text----------------------------------

                                          GridView.builder(
                                              physics: ScrollPhysics(),
                                              itemCount: ItmLst.length,
                                              shrinkWrap: true,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                mainAxisExtent: 50,
                                              ),
                                              itemBuilder: (c, i) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor: MaterialStateProperty.all<Color>(
                                                          Color.fromARGB(255, 175, 211, 246)),
                                                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                      overlayColor: MaterialStateProperty.resolveWith<Color>(
                                                            (Set<MaterialState> states) {
                                                          if (states.contains(MaterialState.hovered))
                                                            return Colors.black; // Hover color
                                                          if (states.contains(MaterialState.pressed))
                                                            return Colors.blueAccent; // Splash color
                                                          return null; // Default, no color
                                                        },
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      print("index 3:  " + (btnItmLst[i]["itmName"]).toString());

                                                      setState(() {
                                                        ItemLstController.text = (btnItmLst[i]["itmName"]).toString();
                                                        ListoTable(btnItmLst[i]);
                                                        quantityController.text = "1";
                                                        setState(() {
                                                          print("opop");
                                                          1 == 1 ? itemTblHight = 300 : itemTblHight = null;
                                                        });
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding: EdgeInsets.all(5.0),
                                                      child: Text(
                                                        (btnItmLst[i]["itmName"].toString()),
                                                        style: TextStyle(
                                                          fontSize: 20.0,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  )

                                                );
                                              },
                                            )
                                          :
//...............img...............
                                          GridView.builder(
                                              physics: ScrollPhysics(),
                                              itemCount: ItmLst.length,
                                              shrinkWrap: true,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 3,
                                                      mainAxisExtent: 70),
                                              itemBuilder: (c, i) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor: MaterialStateProperty.all<Color>(
                                                          Color.fromARGB(255, 255, 255, 255)),
                                                      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                                      elevation: MaterialStateProperty.all<double>(7),
                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(30),
                                                        ),
                                                      ),
                                                      overlayColor: MaterialStateProperty.resolveWith<Color>(
                                                            (Set<MaterialState> states) {
                                                          if (states.contains(MaterialState.hovered))
                                                            return Colors.black;
                                                          if (states.contains(MaterialState.pressed))
                                                            return Colors.blueAccent;
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      print("index 4:  " + (btnItmLst[i]["itmName"]).toString());
                                                      setState(() {
                                                        ItemLstController.text = (btnItmLst[i]["itmName"]).toString();
                                                        ListoTable(btnItmLst[i]);
                                                      });
                                                    },
                                                    child: Image.network(
                                                      (btnItmLst[i]["itmImage"] == null || btnItmLst[i]["itmImage"] == "")
                                                          ? "https://st4.depositphotos.com/14953852/24787/v/600/depositphotos_247872612-stock-illustration-no-image-available-icon-vector.jpg"
                                                          : (btnItmLst[i]["itmImage"]),
                                                    ),
                                                  )

                                                );
                                              },
                                            ),
                                    ),
                                  ),
                                  //items button list

                                  Visibility(
                                      visible: Noitem == true,
                                      child: Center(
                                          child: Text(
                                        "Item Not Found..!",
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 20),
                                      ))),

                                  Divider(
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),




                            SizedBox(
                              width: 8,
                            ),






                            Expanded(
                              child: Column(children: [
                                Visibility(
                                  visible: listabledataShow,
                                  child: Row(
                                    children: [
                                      // SizedBox(
                                      //   width: 10,
                                      // ),
                                      Container(
                                        height: 440,
                                        width:
                                            (MediaQuery.of(context).size.width /
                                                    2) -
                                                20,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            physics: ScrollPhysics(),
                                            child: DataTable(
                                              columnSpacing: 50,
                                              onSelectAll: (b) {},
                                              sortAscending: true,
                                              columns: <DataColumn>[
                                                DataColumn(
                                                  label: Text('NO'),
                                                ),
                                                DataColumn(
                                                  label: Text('Name'),
                                                ),
                                                DataColumn(
                                                  label: Text('UOM'),
                                                ),
                                                DataColumn(
                                                  label: Text('QTY'),
                                                ),
                                                DataColumn(
                                                  label: Text('Rate'),
                                                ),
                                                DataColumn(
                                                  label: Text('Total'),
                                                ),
                                                DataColumn(
                                                  label: Text(''),
                                                ),
                                              ],
                                              rows: TD
                                                  .map(
                                                    (itemRow) => DataRow(
                                                      cells: [
                                                        DataCell(
                                                          Visibility(
                                                              visible: true,
                                                              child: Text(
                                                                  getItemIndex(
                                                                          itemRow)
                                                                      .toString())),
                                                          showEditIcon: false,
                                                          placeholder: false,
                                                        ),
                                                        DataCell(

                                                          Text(itemRow.Name
                                                              .toString()),
                                                          showEditIcon: false,
                                                          placeholder: false,
                                                        ),
                                                        DataCell(
                                                          Text(itemRow.UOM
                                                              .toString()),
                                                          showEditIcon: false,
                                                          placeholder: false,
                                                        ),
                                                        DataCell(
                                                          Text(itemRow.Qty
                                                              .toString()),
                                                          showEditIcon: false,
                                                          placeholder: false,
                                                        ),
                                                        DataCell(
                                                          Text((itemRow.rate)
                                                              .toString()),
                                                          showEditIcon: false,
                                                          placeholder: false,
                                                        ),
                                                        DataCell(
                                                          Text((itemRow
                                                                      .Total) !=
                                                                  null
                                                              ? itemRow.Total
                                                                  .toString()
                                                              : 0.0.toString()),
                                                          showEditIcon: false,
                                                          placeholder: false,
                                                        ),
                                                        DataCell(
                                                          InkWell(
                                                            splashColor:
                                                                Colors.green,
                                                            // splash color
                                                            onTap: () {
                                                              setState(() {
                                                                removeListElement(
                                                                    itemRow
                                                                        .ItemSlNo,
                                                                    itemRow
                                                                        .AmtWithTax);
                                                              });
                                                            },
                                                            // button pressed
                                                            child: Icon(
                                                                Icons.delete),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                  .toList(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //--------------------Table End--------------------------------

                                SizedBox(
                                  height: 0,
                                ),
                                Visibility(
                                  visible: listabledataShow == false,
                                  child: Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              2,
                                      child: Center(
                                          child: Text(
                                        "Item Not Fount",
                                        style: TextStyle(color: Colors.red),
                                      ))),
                                )
                              ]),
                            ),




                          ]),


                      ///-----------Table Nested row ----------------------







                    ]),

            ))





        : SafeArea(
            child: Scaffold(

                //-----------------bottomNavigationBar -----Safve And Pay buttons------------------------

            appBar: PreferredSize(
              preferredSize: Size.fromHeight(90.0),
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Container(
                    height: 80,
                    color: Colors.teal,
                    // decoration: BoxDecoration(
                    //     gradient: new LinearGradient(
                    //         colors: [Color(0xFFE7E9EE), Color(0xFF328BF6)],
                    //         begin: FractionalOffset.centerLeft,
                    //         end: FractionalOffset.centerRight,
                    //         stops: [0.0, 1.0],
                    //         tileMode: TileMode.clamp)
                    // ),
                    width: double.maxFinite,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          //  bottom: 1,
                          right: 10,
                          left: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Widget noButton = TextButton(
                                    child: Text("No"),
                                    onPressed: () {
                                      setState(() {
                                        print("No...");
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                        // Navigator.pop(
                                        //     context); // this is proper..it will only pop the dialog which is again a screen
                                      });
                                    },
                                  );

                                  Widget yesButton = TextButton(
                                    child: Text("Yes"),
                                    onPressed: () {
                                      setState(() {
                                        print("yes...");
                                        pref.remove('userData');
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                        // Navigator.pop(context); //okk
//                              Navigator.pop(context);
                                        Navigator.pushReplacementNamed(
                                            context, "/logout");

//                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()),);
                                      });
                                    },
                                  );
                                  showDialog(
                                      context: context,
                                      builder: (c) => AlertDialog(
                                          content: Text(
                                              "Do you really want to logout?"),
                                          actions: [yesButton, noButton]));
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  // fit: StackFit.expand,
                                  children: [
                                    Center(
                                      child: Container(
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(40.0),
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/icon1.jpg"),
                                                fit: BoxFit.fill)),
                                        margin: new EdgeInsets.only(
                                            left: 0.0,
                                            top: 5.0,
                                            right: 0.0,
                                            bottom: 0.0),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Center(
                                            child: Text(
                                              "",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.red),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                print("hi");
                              },
                              child: Container(
                                  margin: EdgeInsets.only(top: 10, bottom: 15),
                                  child: Column(children: [
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Expanded(
                                      child: Text(
                                        // "Shop Visited",
                                        "Item Bill",
                                        style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 7),
                                        child: Text(
                                          "${branchName.toString()}",
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ])),
                            ),
                            Spacer(),

                            GestureDetector(
                              onTap: () {
                                Widget noButton = TextButton(
                                  child: Text("No"),
                                  onPressed: () {
                                    setState(() {
                                      print("No...");
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                      // Navigator.pop(
                                      //     context); // this is proper..it will only pop the dialog which is again a screen
                                    });
                                  },
                                );

                                Widget yesButton = TextButton(
                                  child: Text("Yes"),
                                  onPressed: () {
                                    setState(() {
                                      print("yes...");
                                      pref.remove('userData');
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                      // Navigator.pop(context); //okk
//                              Navigator.pop(context);
                                      Navigator.pushReplacementNamed(
                                          context, "/logout");

//                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()),);
                                    });
                                  },
                                );
                                showDialog(
                                    context: context,
                                    builder: (c) => AlertDialog(
                                        content: Text(
                                            "Do you really want to logout?"),
                                        actions: [yesButton, noButton]));
                              },
                              child: Container(
                                margin: new EdgeInsets.only(
                                    left: 0.0,
                                    top: 25.0,
                                    right: 0.0,
                                    bottom: 0.0),
                                child: Text(
                                  "${userName.toString()}",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: GestureDetector(
                                  onTap: () {
                            TabelNumDatapopup(type: "Bill No", controller: Bill_No_Controller, validation: false);
                                  },
                                  child: Column(
                                    children: [
                                      Text(BillNumber??"",style: TextStyle(color: Colors.black),),
                                      Icon(
                                        Icons.article_outlined,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ],
                                  )),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 25,left: 10),
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Rms_Homes(),
                                        ));
                                  },
                                  child: Icon(
                                    Icons.home,
                                    color: Colors.white,
                                    size: 27,
                                  )),
                            ),
                          ]),
                    ),
                  ),



                ],
              ),
            ),



            body:ListView(shrinkWrap: true, physics: ScrollPhysics(), children: [
              //--------------------------------For Item Grp----Mobile view-------------------------------------

              Visibility(
                visible:Top_TextBox_Visible,
                child: Row(
                  children: [
                    //----------------------table num-----------------------------

                    Expanded(
                      child: TextFormField(
                        controller: TablenumController,
                        onTap: (){
                          TabelNumDatapopup(controller:TablenumController,type:"Table No",validation:TablenumValid);
                        },
                        enabled: true,
                        validator: (v) {
                          if (v!.isEmpty) return "Required";
                          return null;
                        },
                        cursorColor: Colors.black,
                        scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                        inputFormatters: <TextInputFormatter>[],
                        decoration: InputDecoration(
                          errorStyle: TextStyle(color: Colors.red,),
                          errorText: TablenumValid == true ? "Invalid" : null,

                          isDense: true,
                          contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.0)),
                          hintStyle:
                          TextStyle(color: Colors.black, fontSize: 15),
                          labelText: "Table No",
                        ),
                      ),
                    ),

                    //----------------------Token num-----------------------------
                    SizedBox(
                      width: 6,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: TokennumController,
                        readOnly: true,
                        enabled: false,
                        validator: (v) {
                          if (v!.isEmpty) return "Required";
                          return null;
                        },
                        cursorColor: Colors.black,
                        scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                        decoration: InputDecoration(
                          errorStyle: TextStyle(color: Colors.red),
                          //  errorText:TokennumController  ? "Invalid" : null,
//                    suffixIcon: Icon(
//                      Icons.calendar_today,
//                      color: Colors.blue,
//                      size: 24,
//                    ),
                          isDense: true,

                          contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.0)),
                          hintStyle:
                          TextStyle(color: Colors.black, fontSize: 15),
                          labelText: "Token No",
                        ),
                      ),
                    ),

                    //----------------------Order num-----------------------------
                    SizedBox(
                      width: 6,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: OrderumController,
                        onTap: (){

                          TabelNumDatapopup(controller:OrderumController,type:"Order No",validation:false);
                        },
                        validator: (v) {
                          if (v!.isEmpty) return "Required";
                          return null;
                        },
                        cursorColor: Colors.black,
                        scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                        decoration: InputDecoration(
                          errorStyle: TextStyle(color: Colors.red),
                          isDense: true,
                          contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.0)),
                          hintStyle:
                          TextStyle(color: Colors.black, fontSize: 15),
                          labelText: "Order No",
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 4,
                    ),
                  ],
                ),
              ),




              Row(children: [

                Padding(
                  padding: const EdgeInsets.only(top: 2, left: 10, right: 5),
                  child: Text(
                    "Item Group",
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                GestureDetector(
                  child: Icon(Icons.search),
                  onTap: () {
                    setState(() {
                      grp_Inputbox_Vsbl = !grp_Inputbox_Vsbl;
                    });
                  },
                ),






                Visibility(
                    visible: grp_Inputbox_Vsbl==false,

                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: InkWell(
                        child:Top_TextBox_Visible==true? Icon(Icons.arrow_upward): Icon(Icons.arrow_downward),
                        onTap: (){
                          setState(() {
                            Top_TextBox_Visible=!Top_TextBox_Visible;
                          });

                        },),
                    )),




                Visibility(
                  visible: grp_Inputbox_Vsbl == true,
                  child: Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Container(
                      height: 45,
                      child: TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                              style: TextStyle(),
                              controller: ItemGrpController,
                              decoration: InputDecoration(
                                errorStyle: TextStyle(color: Colors.red),
                                errorText: itemSelectvalidate
                                    ? "Please Select Item  Group?"
                                    : null,
//                            errorText: _validateName ? "please enter name" : null,
//                            errorBorder:InputBorder.none ,
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.remove_circle),
                                  color: Colors.blue,
                                  onPressed: () {
                                    setState(() {
                                      print("cleared");
                                      ItemGrpController.text = "";
                                      ItemGrpId = 0;
                                      itmLstVsbl = false;
                                    });
                                  },
                                ),

                                isDense: true,
                                contentPadding: EdgeInsets.only(left: 20),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14.0)),
                                labelText: 'Item Group search',
                              )),
                          suggestionsBoxDecoration:
                              SuggestionsBoxDecoration(elevation: 90.0),
                          suggestionsCallback: (pattern) {
                            return ItmGrp.where((user) => user.igDescription
                                .contains(pattern.toUpperCase()));
                          },
                          itemBuilder: (context, suggestion) {
                            return Card(
                              margin:
                                  EdgeInsets.only(top: 2, right: 2, left: 2),
                              color: Colors.blue,
                              child: ListTile(
                                // focusColor: Colors.blue,
                                // hoverColor: Colors.red,
                                title: Text(
                                  suggestion.igDescription,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            print(suggestion.igDescription);
                            print("selected");
                            setState(() {
                              getItem(suggestion.id);
                              ItemGrpController.text =
                                  (suggestion.igDescription).toString();
                              ItemLstController.text = "";
                            });

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
                  )),
                ),
              ]),
              // headig of item grp

              Visibility(
                visible: itmGrpVsbl == true,
                // visible:ItmGrp.length>0 ,
                child: Container(
                  color: Colors.transparent,
                  height: 130,
                  child:
                  // imageSetting == false
                  //     ?
                      //----------------------Condition for button or image--------Mobile view----------------------

//  for text...............--Mobile view......

                      Scrollbar(
                          thickness: 5,
                          child: GridView.builder(
                            physics: ScrollPhysics(),
                            itemCount: ItmGrp.length,
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3, mainAxisExtent: 40),
                            itemBuilder: (c, i) {
                              return Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(
                                        Color.fromARGB(255, 175, 211, 246)),
                                    foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                    overlayColor: MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                        if (states.contains(MaterialState.hovered))
                                          return Colors.black;
                                        if (states.contains(MaterialState.pressed))
                                          return Colors.blueAccent;
                                        return null;
                                      },
                                    ),
                                  ),
                                  onPressed: () {
                                    print("index 5:  " + (btnItmGrp[i]["igDescription"]).toString());
                                    setState(() {
                                      getItem((btnItmGrp[i]["id"]));
                                      ItemLstController.text = "";
                                      ItemGrpController.text = (btnItmGrp[i]["igDescription"]).toString();
                                    });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(1),
                                    child: Text(
                                      (btnItmGrp[i]["igDescription"].toString()),
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )

                              );
                            },
                          ),
                        ),
                   //   :

//  ---for image....Item Grp....--Mobile view............................................
//                       GridView.builder(
//                           physics: ScrollPhysics(),
//                           itemCount: ItmGrp.length,
//                           shrinkWrap: true,
//                           gridDelegate:
//                               SliverGridDelegateWithFixedCrossAxisCount(
//                                   crossAxisCount: 4, mainAxisExtent: 80),
//                           itemBuilder: (c, i) {
//                             return Padding(
//                               padding: const EdgeInsets.all(5.0),
//                               child: RaisedButton(
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10)),
//                                 splashColor: Colors.blueAccent,
//                                 hoverColor: Colors.black,
//                                 color: Color.fromARGB(255, 255, 255, 255),
//                                 onPressed: () {
//                                   print("index :  " +
//                                       (btnItmGrp[i]["igDescription"])
//                                           .toString());
//                                   setState(() {
//                                     getItem((btnItmGrp[i]["id"]));
//                                     ItemLstController.text = "";
//                                     ItemGrpController.text = (btnItmGrp[i]
//                                             ["igDescription"])
//                                         .toString();
//                                   });
//                                 },
//                                 child: Image.network((btnItmGrp[i]
//                                             ["igDiplayImagepath"]) ==
//                                         null
//                                     ? "https://st4.depositphotos.com/14953852/24787/v/600/depositphotos_247872612-stock-illustration-no-image-available-icon-vector.jpg"
//                                     //"http://erptest.qizo.in/assets/gtItmMstr/gtItmMstrimg_6.jpg"
//                                     : (btnItmGrp[i]["igDiplayImagepath"])),
//                               ),
//                             );
//                           },
//                         ),
                ),
              ),

              //-------------------------------------Item Grp End----------Mobile view-----------------------------------

              Visibility(
                visible: itmLstVsbl == true,
                child: Divider(
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 1,
              ),

              //------------------------------------Fot Item------------Mobile view-----------------------------------------------
              Visibility(
                visible: itmLstVsbl == true,
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 10, right: 5),
                    child: Text(
                      "Item",
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        itm_Inputbox_Vsbl = !itm_Inputbox_Vsbl;
                      });
                    },
                    child: Icon(Icons.search_outlined),
                  ),
                  SizedBox(
                    width: 35,
                  ),
                  Visibility(
                    visible: itm_Inputbox_Vsbl == true,
                    child: Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 45,
                        child: TypeAheadField(
                            textFieldConfiguration: TextFieldConfiguration(
                                style: TextStyle(),
                                controller: ItemLstController,
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(color: Colors.red),
                                  errorText: itemSelectvalidate
                                      ? "Please Select Item ?"
                                      : null,
//                            errorText: _validateName ? "please enter name" : null,
//                            errorBorder:InputBorder.none ,
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.remove_circle),
                                    color: Colors.blue,
                                    onPressed: () {
                                      setState(() {
                                        print("cleared");
                                        ItemLstController.text = "";
                                        ItemGrpId = 0;
                                        quantityController.text = "1";
                                      });
                                    },
                                  ),

                                  isDense: true,
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 10.0, 20.0, 10.0),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(14.0)),
                                  labelText: 'Item search',
                                )),
                            suggestionsBoxDecoration:
                                SuggestionsBoxDecoration(elevation: 90.0),
                            suggestionsCallback: (pattern) {
                              return ItmLst.where((user) =>
                                  user.itmName.contains(pattern.toUpperCase()));
                            },
                            itemBuilder: (context, suggestion) {
                              return Card(
                                margin:
                                    EdgeInsets.only(top: 2, right: 2, left: 2),
                                color: Colors.blue,
                                child: ListTile(
                                  // focusColor: Colors.blue,
                                  // hoverColor: Colors.red,
                                  title: Text(
                                    suggestion.itmName,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              );
                            },
                            onSuggestionSelected: (suggestion) {
                              print(suggestion.itmName);
                              print("selected");
                              print(json.encode(suggestion).toString());

                              var itm_data = jsonEncode(suggestion);
                              setState(() {
                                ItemLstController.text =
                                    (suggestion.itmName).toString();
                                ListoTable(jsonDecode(itm_data));
                              });

                              print("...........");
                            },
                            errorBuilder:
                                (BuildContext context, Object? error) => Text(
                                    '$error',
                                    style: TextStyle(
                                        color: Theme.of(context).errorColor)),
                            transitionBuilder: (context, suggestionsBox,
                                    animationController) =>
                                FadeTransition(
                                  child: suggestionsBox,
                                  opacity: CurvedAnimation(
                                      parent: animationController!,
                                      curve: Curves.elasticIn),
                                )),
                      ),
                    )),
                  ),
                ]), // headig of item grp
              ),

              Visibility(
                visible: itmLstVsbl == true,
                child: Container(
                  height: 210,
                  child: imageSetting == false
                      ?
                      //------------------------img or text--------------Mobile view----------------------

                      GridView.builder(
                          physics: ScrollPhysics(),
                          itemCount: ItmLst.length,
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisExtent: 45,
                          ),
                          itemBuilder: (c, i) {
                            return Padding(
                              padding: const EdgeInsets.all(2),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                      Color.fromARGB(255, 175, 211, 246)),
                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.black), // For the text color
                                  overlayColor: MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                      if (states.contains(MaterialState.hovered))
                                        return Colors.black; // Hover color
                                      if (states.contains(MaterialState.pressed))
                                        return Colors.blueAccent; // Splash color
                                      return null; // Default, no color
                                    },
                                  ),
                                ),
                                onPressed: () {
                                  // if (TablenumController.text == "") {
                                  //   setState(() {
                                  //     TablenumValid = true;
                                  //   });
                                  // } else {
                                  print("index 6:  " + (btnItmLst[i]["itmName"]).toString());

                                  setState(() {
                                    TablenumValid = false;
                                    ItemLstController.text = (btnItmLst[i]["itmName"]).toString();
                                    ListoTable(btnItmLst[i]);
                                    quantityController.text = "1";
                                    setState(() {
                                      print("opop");
                                      1 == 1 ? itemTblHight = 300 : itemTblHight = null;
                                    });
                                  });
                                  // }
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(1),
                                  child: Text(
                                    (btnItmLst[i]["itmName"].toString()),
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),

                            );
                          },
                        )
                      :
//...............img........Itm...--Mobile view....
                      GridView.builder(
                          physics: ScrollPhysics(),
                          itemCount: ItmLst.length,
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4, mainAxisExtent: 70),
                          itemBuilder: (c, i) {
                            return Padding(
                              padding: const EdgeInsets.all(3.0),
                              child:ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                      Color.fromARGB(255, 255, 255, 255)),
                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                  elevation: MaterialStateProperty.all<double>(7),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  overlayColor: MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                      if (states.contains(MaterialState.hovered))
                                        return Colors.black;
                                      if (states.contains(MaterialState.pressed))
                                        return Colors.blueAccent;
                                      return null;
                                    },
                                  ),
                                ),
                                onPressed: () {
                                  // if(TablenumController.text==""){
                                  //   setState(() {
                                  //     TablenumValid=true;
                                  //   });
                                  // }else {
                                  print("index 7:  " + (btnItmLst[i]["itmName"]).toString());
                                  setState(() {
                                    TablenumValid = false;
                                    ItemLstController.text = (btnItmLst[i]["itmName"]).toString();
                                    ListoTable(btnItmLst[i]);
                                  });
                                  // }
                                },
                                child: Image.network(
                                  (btnItmLst[i]["itmImage"] == null || btnItmLst[i]["itmImage"] == "")
                                      ? "http://erptest.qizo.in/assets/gtItmMstr/gtItmMstrimg_1180.jpg"
                                      : (btnItmLst[i]["itmImage"]),
                                ),
                              ),

                            );
                          },
                        ),
                ),
              ),
              //items button list

              Visibility(
                  visible: Noitem == true,
                  child: Center(
                      child: Text(
                    "Item Not Found..!",
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  ))),

              Divider(
                color: Colors.black,
              ),
              //-------------------------------------item End-----------Mobile view------------------------------------------------

              //---------------------------Table Strt----------------Mobile view-------

              Visibility(
                visible: listabledataShow,
                child: Row(
                  children: [
                    // SizedBox(
                    //   width: 10,
                    // ),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: itemTblHight),
                      child: Container(
                        // height: null,
                        width: MediaQuery.of(context).size.width / 1,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            physics: ScrollPhysics(),
                            child: DataTable(
                              dataRowHeight: 40,
                              showCheckboxColumn: false,
                              decoration: BoxDecoration(
                                  border: Border(
                                bottom: Divider.createBorderSide(context,
                                    width: 1.0),
                              )),
                              columnSpacing: 16,
                              onSelectAll: (b) {},
                              sortAscending: true,
                              columns: <DataColumn>[
                                DataColumn(
                                  label: Text('NO'),
                                ),
                                DataColumn(
                                  label: Text('Name'),
                                ),
                                DataColumn(
                                  label: Text('UOM'),
                                ),
                                DataColumn(
                                  label: Text('QTY'),
                                ),
                                DataColumn(
                                  label: Text('Rate'),
                                ),
                                DataColumn(
                                  label: Text('Total'),
                                ), DataColumn(
                                  label: Text('Net Amt'),
                                ),
                                DataColumn(
                                  label: Text(''),
                                ),
                              ],
                              rows: TD
                                  .map(
                                    (itemRow) => DataRow(
                                      // onSelectChanged: (a) {
                                      //   showDialog(
                                      //       context: context,
                                      //       builder: (c) => AlertDialog(
                                      //               content: Container(height: 40,
                                      //                 child: Column(
                                      //                   children: [
                                      //                     Expanded(
                                      //                       child: Text(
                                      //                           "Do you want to Delete?",style: TextStyle(color: Colors.red),),
                                      //                     ),
                                      //                     Expanded(
                                      //                       child: Text(
                                      //                         itemRow.Name),
                                      //                     ),
                                      //                    ],
                                      //                 ),
                                      //               ),
                                      //               actions: [
                                      //                 FlatButton(
                                      //                   child: Text("Yes"),
                                      //                   onPressed: () {
                                      //                     Navigator.of(context,rootNavigator:true).pop();
                                      //                     setState(() {
                                      //                       removeListElement(
                                      //                           itemRow.ItemSlNo,
                                      //                           itemRow.AmtWithTax);
                                      //                     });
                                      //                   },
                                      //                 ),
                                      //
                                      //                 FlatButton(
                                      //                     child: Text("No"),
                                      //                     onPressed: () {
                                      //                       // Navigator.pop(context,false);
                                      //                       Navigator.of(context,rootNavigator:true).pop();
                                      //                     })
                                      //
                                      //               ]));
                                      // },
                                      cells: [
                                        DataCell(
                                          Visibility(
                                              visible: true,
                                              child: Text(getItemIndex(itemRow)
                                                  .toString())),
                                          showEditIcon: false,
                                          placeholder: false,
                                        ),
                                        DataCell(
                                          GestureDetector(child:Text(itemRow.Name.toString()),
                                          onLongPress: (){
                                            showDialog(
                                                context: context,
                                                builder: (c) => AlertDialog(
                                                    content: Container(height: 40,
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              "Do you want to Delete?",style: TextStyle(color: Colors.red),),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                                itemRow.Name),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        child: Text("Yes"),
                                                        onPressed: () {
                                                          Navigator.of(context,rootNavigator:true).pop();
                                                          setState(() {
                                                            removeListElement(
                                                                itemRow.ItemSlNo,
                                                                itemRow.AmtWithTax);
                                                          });
                                                        },
                                                      ),

                                                      TextButton(
                                                          child: Text("No"),
                                                          onPressed: () {
                                                            // Navigator.pop(context,false);
                                                            Navigator.of(context,rootNavigator:true).pop();
                                                          })

                                                    ]));

                                          },),
                                          showEditIcon: false,
                                          placeholder: false,
                                        ),
                                        DataCell(
                                          Text(itemRow.UOM.toString()),
                                          showEditIcon: false,
                                          placeholder: false,
                                        ),
                                        DataCell(
                                          Text(itemRow.Qty.toString()),
                                          showEditIcon: false,
                                          placeholder: false,
                                        ),
                                        DataCell(
                                          Text((itemRow.rate).toString()),
                                          showEditIcon: false,
                                          placeholder: false,
                                        ),
                                        DataCell(
                                          Text((itemRow.Total) != null
                                              ? itemRow.Total.toString()
                                              : 0.0.toString()),
                                          showEditIcon: false,
                                          placeholder: false ,
                                        ),DataCell(
                                          Text((itemRow.AmtWithTax) != null
                                              ? itemRow.AmtWithTax.toString()
                                              : 0.0.toString()),
                                          showEditIcon: false,
                                          placeholder: false,
                                        ),
                                        DataCell(
                                          InkWell(
                                            splashColor: Colors.green,
                                            // splash color
                                            onTap: () {
                                              setState(() {
                                                removeListElement(
                                                    itemRow.ItemSlNo,
                                                    itemRow.AmtWithTax);
                                              });
                                            },
                                            // button pressed
                                            child: Icon(Icons.delete),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //--------------------Table End--------------------------------

              SizedBox(
                height: 20,
              ),
            ]),



              bottomNavigationBar:  Container(
                color: Color(0xFFFDF4F4),
                child: Row(
                  children: [
                    // Expanded(
                    //   child: Padding(
                    //     padding:
                    //     const EdgeInsets.only(left: 10, bottom: 2, top: 5),
                    //     child: RaisedButton(
                    //       color: Colors.blue,
                    //       onPressed: () {
                    //         print("onSave");
                    //         print(jsonEncode(IBD));
                    //         IBSave(IBD);
                    //       },
                    //       child: Stack(
                    //         children: [
                    //           Padding(
                    //               padding: EdgeInsets.only(
                    //                   left: 5, top: 5, bottom: 2, right: 5),
                    //               child: Text(
                    //                 ("Saves"),
                    //                 style: TextStyle(
                    //                   fontSize: 20.0,
                    //                   color: Colors.white,
                    //                 ),
                    //               )),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      child: Padding(
                        padding:
                        const EdgeInsets.only(left: 10, bottom: 2, top: 5),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          ),
                          onPressed: () {
                            print("Payment Type");
                            PaymentName = "";
                            SetPaymentType();
                            PaymentAmtPopupVisilbe = false;
                            Pay_Typ_Cash_Valid = false;
                          },
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              (ButtonName),
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )

                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10, bottom: 5, right: 5, top: 10),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: TextFormField(
                            controller: TotalAmtController,
                            readOnly: true,
                            enabled: false,
                            validator: (v) {
                              if (v!.isEmpty) return "Required";
                              return null;
                            },
                            cursorColor: Colors.black,
                            scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              errorStyle: TextStyle(color: Colors.red),
                              //  errorText:TokennumController  ? "Invalid" : null,
//                    suffixIcon: Icon(
//                      Icons.calendar_today,
//                      color: Colors.blue,
//                      size: 24,
//                    ),
                              isDense: true,

                              contentPadding:
                              EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 16.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14.0)),
                              hintStyle:
                              TextStyle(color: Colors.black, fontSize: 15),
                              labelText: "Total",
                            ),
                          ),
                        ),
                      ),
                    ),

                   /// ------
                    IconButton(icon: Icon(Icons.add_sharp), onPressed:(){
                      dataForTicket={
    "salesHeader": [
    {
    "id": 54,
    "voucherNo": 54,
    "voucherDate": "2022-02-14T00:00:00",
    "orderHeadId": null,
    "orderDate": null,
    "orderNo": null,
    "expDate": null,
    "ledgerId": null,
    "lhName": null,
    "lhContactNo": null,
    "lhGstno": null,
    "partyName": "xx",
    "address1": null,
    "address2": null,
    "msStateCode": null,
    "msName": null,
    "gstNo": null,
    "phone": null,
    "shipToName": null,
    "shipToAddress1": null,
    "shipToAddress2": null,
    "shipToPhone": null,
    "narration": null,
    "amount": 10.0000,
    "taxAmt": null,
    "roundOff": null,
    "otherAmt": 0.0000,
    "discountAmt": 0.0000,
    "creditPeriod": null,
    "paymentCondition": null,
    "paymentType": 0,
    "invoiceType": null,
    "invoicePrefix": null,
    "invoiceSuffix": null,
    "cancelFlg": null,
    "entryDate": "2022-02-14T16:39:05.07",
    "slesManId": null,
    "emEmployeeName": null,
    "branchUpdated": false,
    "userId": 17,
    "branchId": 12,
    "saleTypeInterState": true,
    "adlDiscPercent": null,
    "adlDiscAmount": null,
    "cashReceived": 10.0000,
    "balanceAmount": 10.0000,
    "adjustAmount": 0.0000,
    "otherAmountReceived": null,
    "deliveryType": "true",
    "deliveryTo": "",
    "tokenNo": 5
    }
    ],
    "salesDetails": [
    {
    "id": 160,
    "shid": 54,
    "itemId": 45,
    "itmName": "Code Red + Blueberry",
    "itmArabicName": "اختبار",
    "itmCode": "156",
    "itmBatchEnabled": null,
    "itmExpirtyEnabled": null,
    "qty": 1.00,
    "rate": 10.0000,
    "mrp": null,
    "prate": null,
    "disPercentage": null,
    "cgstPercentage": null,
    "sgstPercentage": null,
    "cessPercentage": null,
    "discountAmount": 0.0000,
    "cgstAmount": 0.0000,
    "sgstAmount": 0.0000,
    "cessAmount": 0.0000,
    "igstPercentage": null,
    "igstAmount": 0.0000,
    "taxPercentage": 15.0000,
    "taxAmount": 1.5000,
    "taxInclusive": true,
    "amountBeforeTax": 8.5000,
    "amountIncludingTax": 10.0000,
    "netTotal": 10.0000,
    "hsncode": null,
    "gdnId": null,
    "taxId": 1,
    "txDescription": "VAT 15  %",
    "rackId": null,
    "addTaxId": null,
    "unitId": 3,
    "uom": "LRG",
    "uomArabic": null,
    "barcode": null,
    "nosInUnit": null,
    "stockId": 0,
    "batchNo": null,
    "expiryDate": null,
    "notes": "",
    "itmIsTaxAplicable": true,
    "itemSlNo": 2,
    "adlDiscAmount": null,
    "adlDiscPercent": null,
    "salesManIdDet": null,
    "igKotPrinter": "\\\\fruit-nectar2\\Kitchen"
    }
    ],
    "salesExpense": []
    };

                      _ticket(PaperSize.mm80);

                    })
                  ],
                ),
              ),

          ));
  }











  ///----------------------print part-----------------------

  //----------printing ticket generate--------------------------
  PrinterNetworkManager _printerManager = PrinterNetworkManager();
  Future<Ticket> _ticket(PaperSize paper) async {
    print('in print Ticket');
    final ticket = Ticket(paper);
    List<dynamic> DetailPart = dataForTicket["salesDetails"] as List;

    print("dataForTicket");
    print(dataForTicket.toString());
    print("DetailPart");
    print(DetailPart.toString());

    dynamic VchNo = (dataForTicket["voucherNo"]) == null
        ? "00": (dataForTicket["voucherNo"]).toString();

    // dynamic date = (DateFormat("dd/MM/yyy hh:mm:ss a").format(DateTime.now()).toString());


    dynamic partyName=(dataForTicket["partyName"]) == null ||
        (dataForTicket["partyName"])== ""
        ? ""
        : (dataForTicket["partyName"]).toString();



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
        // text:(Companydata["companyProfileAddress1"]).toString(),
          text:("Order Slip"),
          width: 10,
          styles:PosStyles(bold: false,
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,)),
      PosColumn(text: ' ', width: 1)
    ]);


// ticket.text("اختبار",styles: );

    //
    // ticket.row([
    //   PosColumn(text: ' ', width: 1),
    //   PosColumn(
    //       text: (Companydata["companyProfileAddress2"]).toString(),
    //       width: 10,
    //       styles:PosStyles(bold: false,
    //         align: PosAlign.center,
    //         height: PosTextSize.size1,
    //         width: PosTextSize.size1,
    //       )),
    //   PosColumn(text: ' ', width: 1)
    // ]);
    //
    // ticket.row([
    //   PosColumn(text: ' ', width: 1),
    //   PosColumn(
    //       text:  (Companydata["companyProfileAddress3"]).toString(),
    //       width: 10,
    //       styles:PosStyles(bold: false,
    //         align: PosAlign.center,
    //         height: PosTextSize.size1,
    //         width: PosTextSize.size1,
    //       )),
    //   PosColumn(text: ' ', width: 1)
    // ]);
    //
    //
    //
    // ticket.row([
    //   PosColumn(text: ' ', width: 1),
    //   PosColumn(
    //       text:(Companydata["companyProfileMobile"]).toString(),
    //       width: 10,
    //       styles:PosStyles(bold: false,
    //         align: PosAlign.center,
    //         height: PosTextSize.size1,
    //         width: PosTextSize.size1,
    //       )),
    //   PosColumn(text: ' ', width: 1)
    // ]);
    //
    //
    //
    //
    // ticket.row([
    //   PosColumn(text: ' ', width: 1),
    //   PosColumn(
    //       text:  (Companydata["companyProfileEmail"]).toString(),
    //       width: 10,
    //       styles:PosStyles(bold: false,underline: true,
    //         align: PosAlign.center,
    //         height: PosTextSize.size1,
    //         width: PosTextSize.size1,
    //       )),
    //   PosColumn(text: ' ', width: 1)
    // ]);
    //
    //
    //
    //
    //
    // ticket.text('GSTIN: ' +
    //     ( Companydata["companyProfileGstNo"]).toString()+' ',
    //     styles: PosStyles(bold: false,
    //       align: PosAlign.center,
    //       height: PosTextSize.size1,
    //       width: PosTextSize.size1,
    //     ));
    //
    //
    // ticket.text('Token NO : ' + VchNo.toString(),
    //     styles: PosStyles(bold: true, width: PosTextSize.size1));
    // //ticket.emptyLines(1);
    // ticket.text('Date : $date');

    //---------------------------------------------------------
    if(partyName !="")
    {
      //ticket.emptyLines(1);
      ticket.text('Name : $partyName');
    }
    if((dataForTicket["gstNo"]) !=null)
    {
      // ticket.emptyLines(1);
      ticket.text('GST No :' +((dataForTicket["gstNo"])));
    }
    //---------------------------------------------------------

    ticket.hr(ch: '_');
    ticket.row([
      PosColumn(
        text:'No',
        styles: PosStyles(align: PosAlign.left ),
        width:1,
      ),
      PosColumn(
        text:'Item',
        styles: PosStyles(bold: true,align: PosAlign.center),
        width: 2,
      ),
      PosColumn(text: 'Rate', width: 3,styles:PosStyles(align: PosAlign.right)),
      PosColumn(text: 'Qty', width: 2,styles: PosStyles(align: PosAlign.right ),),
      // PosColumn(text: 'Tax', width: 2,styles: PosStyles(align: PosAlign.center ),),
      PosColumn(text: ' Amonunt', width: 4,styles: PosStyles(align: PosAlign.center ),),
    ]);
    ticket
        .hr(); // for dot line or set ticket.hr(ch: 'charecter', linesAfter: 1);
    var snlnum=0;
    dynamic total = 0.000;
    for (var i = 0; i < DetailPart.length; i++) {
      total = DetailPart[i]["amountIncludingTax"] ??0+ total;
     // ticket.emptyLines(1);
      snlnum=snlnum+1;
      ticket.row([
        PosColumn(text: (snlnum.toString()),width: 1,styles: PosStyles(
            fontType: PosFontType.fontB,align: PosAlign.left
        )),

        PosColumn(text: (DetailPart[i]["item"]??""),
            width: 3,styles:
            PosStyles( fontType: PosFontType.fontB,align: PosAlign.left )),

      // for space

        PosColumn(
            text: (((DetailPart[i]["rate"])).toStringAsFixed(2)).toString(),
            width: 3,
            styles: PosStyles(
                fontType: PosFontType.fontB,align: PosAlign.right
            )),
        PosColumn(
            text: (' '+((DetailPart[i]["qty"])).toStringAsFixed(0)).toString(),styles:PosStyles(align: PosAlign.right ),
            width: 2),
        // PosColumn(
        //     text: (' ' + ((DetailPart[i]["taxAmount"])).toStringAsFixed(2))
        //         .toString(),styles:PosStyles(align: PosAlign.right ),
        //     width: 2),
        PosColumn(
            text: ((DetailPart[i] ["amountIncludingTax"])).toStringAsFixed(2)
            ,styles:PosStyles(align:PosAlign.center ),
            width:3),
      ]);
    }


    ticket.hr(ch:"=");
    ticket.row([
      PosColumn(
          text: 'Total',
          width: 4,
          styles: PosStyles(
            bold: true,align:PosAlign.left,
          )),
      PosColumn(
          text:'Rs '+(total.toStringAsFixed(2)).toString(),
          width: 7,
          styles: PosStyles(bold: true,align: PosAlign.center,)),
      PosColumn(
        text:' ',
        width: 1,),
    ]);
    ticket.hr(
        ch: '_');

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
    print("Finish");
    ticket.cut();
    return ticket;
  }
  //..................................................
  wifiprinting(printerName) async {
    // try {

      print("in print in 123");

      _printerManager.selectPrinter(printerName);

      // _printerManager.selectPrinter('192.168.0.100');

      final res =
      await _printerManager.printTicket(await _ticket(PaperSize.mm80));
      print("out print in");
    // } catch (e) {
    //   print("error on print $e");
    // }
  }

//----------------------Print part End-----------------------------------------






}







class Tabledata {
  late int id;
  dynamic ItemSlNo;
  dynamic Name;
  dynamic rate;
  dynamic Total;
  dynamic Qty;
  dynamic UOM;
  dynamic AmtWithTax;

  Tabledata(
      {required this.id,
      this.Name,
      this.rate,
      this.Total,
      this.Qty,
      this.ItemSlNo,
      this.UOM,
      this.AmtWithTax});

  Tabledata.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    Name = json['Name'];
    rate = json['rate'];
    Total = json['Total'];
    Qty = json['Qty'];
    ItemSlNo = json['ItemSlNo'];
    UOM = json['UOM'];
    AmtWithTax = json['AmtWithTax'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Name'] = this.Name;
    data['rate'] = this.rate;
    data['Total'] = this.Total;
    data['Qty'] = this.Qty;
    data['ItemSlNo'] = this.ItemSlNo;
    data['UOM'] = this.UOM;
    data['AmtWithTax'] = this.AmtWithTax;

    return data;
  }
}

class ItemGroup {
  late int id;
  late String igDescription;
  dynamic igDiplayImagepath;

  ItemGroup({required this.id, required this.igDescription, this.igDiplayImagepath});

  ItemGroup.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    igDescription = json['igDescription'];
    igDiplayImagepath = json['igDiplayImagepath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['igDescription'] = this.igDescription;
    data['igDiplayImagepath'] = this.igDiplayImagepath;

    return data;
  }
}

class ItemList {
  late int id;
  late String itmName;
  dynamic itmImage;
  bool itmTaxInclusive;

  ItemList({required this.id, required this.itmName, this.itmImage, required this.itmTaxInclusive});

  ItemList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itmName = json['itmName'];
    itmImage = json['itmImage'];
    itmTaxInclusive = json['itmTaxInclusive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['itmName'] = this.itmName;
    data['itmImage'] = this.itmImage;
    data['itmTaxInclusive'] = this.itmTaxInclusive;

    return data;
  }
}

class ItmBillDetails {
  dynamic ItemSlNo;
  late int itemId;
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
  dynamic taxInclusive;
  dynamic amountBeforeTax;
  dynamic amountIncludingTax;
  dynamic netTotal;
  dynamic hsncode;
  late int gdnId;
  late int taxId;
  late int rackId;
  late int addTaxId;
  late int unitId;
  late int nosInUnit;
  dynamic barcode;
  dynamic StockId;
  dynamic BatchNo;
  dynamic ExpiryDate;
  dynamic Notes;
  dynamic adlDiscAmount;
  dynamic adlDiscPercent;
  dynamic shid;


  ItmBillDetails(
      {this.ItemSlNo,
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
      this.taxInclusive,
      this.amountBeforeTax,
      this.amountIncludingTax,
      this.netTotal,
      this.hsncode,
      required this.gdnId,
      required this.taxId,
      required this.rackId,
      required this.addTaxId,
      required this.unitId,
      required this.nosInUnit,
      this.barcode,
      this.StockId,
      this.BatchNo,
      this.ExpiryDate,
      this.Notes,
      this.adlDiscAmount,
      this.adlDiscPercent,
      this.shid
      });

  ItmBillDetails.fromJson(Map<String, dynamic> json) {
    ItemSlNo = json['ItemSlNo'];
    itemId = json['itemId'];
    qty = json['qty'];
    rate = json['rate'];
    disPercentage = json['disPercentage'];
    cgstPercentage = json['cgstPercentage'];
    sgstPercentage = json['sgstPercentage'];
    cessPercentage = json['cessPercentage'];
    discountAmount = json['discountAmount'];
    cgstAmount = json['cgstAmount'];
    sgstAmount = json['sgstAmount'];
    cessAmount = json['cessAmount'];
    igstPercentage = json['igstPercentage'];
    igstAmount = json['igstAmount'];
    taxPercentage = json['taxPercentage'];
    taxAmount = json['taxAmount'];
    taxInclusive = json['taxInclusive'];
    amountBeforeTax = json['amountBeforeTax'];
    amountIncludingTax = json['amountIncludingTax'];
    netTotal = json['netTotal'];
    hsncode = json['hsncode'];
    gdnId = json['gdnId'];
    taxId = json['taxId'];
    rackId = json['rackId'];
    addTaxId = json['addTaxId'];
    unitId = json['unitId'];
    nosInUnit = json['nosInUnit'];
    barcode = json['barcode'];
    StockId = json['StockId'];
    BatchNo = json['BatchNo'];
    ExpiryDate = json['ExpiryDate'];
    Notes = json['Notes'];
    adlDiscAmount = json['adlDiscAmount'];
    adlDiscPercent = json['adlDiscPercent'];
     shid = json['shid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ItemSlNo'] = this.ItemSlNo;
    data['itemId'] = this.itemId;
    data['qty'] = this.qty;
    data['rate'] = this.rate;
    data['disPercentage'] = this.disPercentage;
    data['cgstPercentage'] = this.cgstPercentage;
    data['sgstPercentage'] = this.sgstPercentage;
    data['cessPercentage'] = this.cessPercentage;
    data['discountAmount'] = this.discountAmount;
    data['cgstAmount'] = this.cgstAmount;
    data['sgstAmount'] = this.sgstAmount;
    data['cessAmount'] = this.cessAmount;
    data['igstPercentage'] = this.igstPercentage;
    data['igstAmount'] = this.igstAmount;
    data['taxPercentage'] = this.taxPercentage;
    data['taxAmount'] = this.taxAmount;
    data['taxInclusive'] = this.taxInclusive;
    data['amountBeforeTax'] = this.amountBeforeTax;
    data['amountIncludingTax'] = this.amountIncludingTax;
    data['netTotal'] = this.netTotal;
    data['hsncode'] = this.hsncode;
    data['gdnId'] = this.gdnId;
    data['taxId'] = this.taxId;
    data['rackId'] = this.rackId;
    data['addTaxId'] = this.addTaxId;
    data['unitId'] = this.unitId;
    data['nosInUnit'] = this.nosInUnit;
    data['barcode'] = this.barcode;
    data['StockId'] = this.StockId;
    data['BatchNo'] = this.BatchNo;
    data['ExpiryDate'] = this.ExpiryDate;
    data['Notes'] = this.Notes;
    data['adlDiscAmount'] = this.adlDiscAmount;
    data['adlDiscPercent'] = this.adlDiscPercent;
     data['shid'] = this.shid;
    return data;
  }
}
