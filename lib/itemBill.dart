import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:new_qizo_gt/urlEnvironment/urlEnvironment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'AQizo_RMS/New_Delivery_App/Del_ItemHome.dart';
import 'models/customersearch.dart';
import 'models/userdata.dart';

class itemBill extends StatefulWidget {
  @override
  _itemBillState createState() => _itemBillState();
}

class _itemBillState extends State<itemBill> {
//-----------------------------------------
  late SharedPreferences pref;
  late ItmBillDetails ItmBLdata;
  late Tabledata TDdata;
  dynamic branch;
  var res;
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
  bool Pay_Typ_Credit_Ph_Valid=false;


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
  TextEditingController Pay_Typ_Tota_Amt_Controller = new TextEditingController();
  TextEditingController OrderumController = new TextEditingController();
  TextEditingController customerController = new TextEditingController();
  TextEditingController Pay_Typ_Credit_Ph_Controller = new TextEditingController();


  int? PaymentTypID=null;
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
  static List<Tabledata> TD =[];
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
        OrderumController.text = "1";
      });
    });
  }

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
    print("in IBSave");
    final url = "${Env.baseUrl}SalesHeaders";
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

    if (TablenumController.text == "") {
      setState(() {
        TablenumValid = true;
      });

      return;
    }
    TablenumValid = false;

    if(TotalAmtController.text !="Amount paid" && TotalAmtController.text !="Credited" ){
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


    print("in Save");
    var req = {
      "voucherNo": Token_Num,
      "voucherDate": dateNow.toString(),
      "ledgerId": customerId,
      "partyName":Customername,
      "TokenNo": 1,
      "paymentType": PaymentTypID,
      "DeliveryType": true,
      "address1": null,
      "address2": null,
      "saleTypeInterState": true,
      "phone": Pay_Typ_Credit_Ph_Controller.text==""?null:Pay_Typ_Credit_Ph_Controller.text,
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

    var res = await http.post(url as Uri,
        headers: {
          'accept': 'application/json',
          'content-type': 'application/json',
          'Authorization': user.user["token"],
          'deviceId': user.deviceId
        },
        body: params);

    print("res.statusCode" + res.statusCode.toString());
    if (res.statusCode == 200 || res.statusCode == 201) {
      setState(() {
        TD.clear();
        IBD.clear();
        TotalAmtController.text = "0.00";
        TablenumController.text = "";
        TokennumController.text = "";
        TotalAmt = "0.00";
        listabledataShow = false;
      });

      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Center(
                    child: Text(
                  "Saved",
                  style: TextStyle(color: Colors.blueAccent),
                )),
              ));
      Timer(Duration(seconds: 2), () {
        print("after 2 seconds");
        Navigator.pop(context);
      });
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Center(
                    child: Text(
                  "Save Failed !",
                  style: TextStyle(color: Colors.brown),
                )),
              ));
    }
  }

  //----------------------------end-----------Savefunction---end-------------------------------------

  //-----------------Show poup for  selected items --------------------------------------
  ListoTable(array) async {
    UomRateController.text = "";
    UomRateSelect = false;
    quantitySelect = false;
    print("in");
    //print(array.toString());
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

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
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
                          child: DataTable(showCheckboxColumn: false,
                            columnSpacing: 3,
                            onSelectAll: (b) {},
                            sortAscending: true,
                            columns: <DataColumn>[
                              DataColumn(
                                label: SingleChildScrollView(physics: NeverScrollableScrollPhysics(),
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
                                onSelectChanged: (a){
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
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 5, right: 5, bottom: 10, top: 8),
                      child: Container(
                        child: Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                              child: Container(
                                color: Colors.blue,
                                width: 300,
                                height: 40,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Add to Cart",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
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
                              }),
                        ),
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

      TotalAmt = TotalAmt.toInt() + amtWithTax.toInt();
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
        gdnId: null,
        taxId: UomTableData['txId'],
        rackId: null,
        addTaxId: null,
        unitId: UomTableData['unitId'],
        nosInUnit: null,
        //ele.Nos_In_Unit,
        barcode: null,
        //
        StockId: 0,
        BatchNo: null,
        ExpiryDate: null,
        Notes: null,
        adlDiscAmount: null,
        adlDiscPercent: null,
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
    if(IBD.length==0) {
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
                  Container(
                      height: 325,
                      width: 400,
                      child: ListView(shrinkWrap: true, children: [
                        Visibility(
                          visible: PaymentPopupVisilbe == true,
                          child: DataTable(showCheckboxColumn: false,
                            headingRowHeight: 0,
                            onSelectAll: (b) {},
                            sortAscending: true,
                            columns: <DataColumn>[
                              DataColumn(
                                label: Text(''),
                              ),
                            ],
                            rows: PayTypData.map(
                              (itemRow) => DataRow(onSelectChanged: (a){
                                setState(() {
                                  print(itemRow);
                                  Pay_Frm_Reset();
                                  PayAmtTypData = itemRow;
                                  PaymentName = itemRow['paymentType'];
                                  PaymentTypID= itemRow['id'];
                                  if (PayAmtTypData["paymentType"]
                                      .contains('and')) {
                                    print("contain");
                                    Pay_Typ_OthAmt_TxtBx_Visible =
                                    true;
                                    Payment_Credit_Visilbe = false;
                                  } else if (PayAmtTypData[
                                  "paymentType"] ==
                                      "Credit") {
                                    Pay_Typ_OthAmt_TxtBx_Visible =
                                    false;
                                    PaymentAmtPopupVisilbe = false;
                                    Payment_Credit_Visilbe = true;
                                  } else {
                                    print(" Not contain");
                                    Pay_Typ_OthAmt_TxtBx_Visible =
                                    false;
                                    Payment_Credit_Visilbe = false;
                                  }
                                });
                              },
                                cells: [
                                  DataCell(
                                    Center(
                                        child: Text('${itemRow['paymentType'].toString()}')),
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
                                        amt3.toString();
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
                                          NetAmt.toString();
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
                                          amt3.toString();
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
                                            NetAmt.toString();
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
                                              amt3.toString();
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
                                                NetAmt.toString();
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
                                              amt3.toString();
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
                                                NetAmt.toString();
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
                                        labelText: "Total",
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            //---------------ok  and Back Buttons-----------------------------
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 10),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.blue, // This is the button color
                                      ),
                                      onPressed: () {
                                        if (Pay_Typ_Cash_Controller.text == "") {
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

                                        if (Pay_Typ_OthAmt_TxtBx_Visible == true &&
                                            Pay_Typ_OthAmt_Controller.text == "") {
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
                                          if (Pay_Typ_Tota_Amt_Controller.text == "0.0") {
                                            setState(() {
                                              print("inn");
                                              TotalAmtController.text = "Amount paid";
                                              Itm_Tbl_DeleteBttn_Visible = false;
                                            });
                                          } else {}
                                        });
                                        PaymentCompleted();
                                      },
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 5),
                                            child: Text(
                                              ("   PAY   "), //OK
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )

                                  ),
                                ),

                                Expanded(child: SizedBox(width:  MediaQuery.of(context).size.width / 4)),

                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, right: 5),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.blue, // This is the button color
                                      ),
                                      onPressed: () {
                                        print(" Back ");
                                        setState(() {
                                          Pay_Frm_Reset();
                                          PaymentAmtPopupVisilbe = false;
                                          PaymentPopupVisilbe = true;
                                          Pay_Typ_OthAmt_TxtBx_Visible = false;
                                        });
                                        PaymentName = "";
                                      },
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 5),
                                            child: Text(
                                              ("BACK"),
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )

                                  ),
                                ),
                              ],
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
                                                      decoration: InputDecoration(
                                                        errorStyle: TextStyle(
                                                            color: Colors.red),
                                                        errorText: customerSelect==true
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
                                                return users.where((user) => user
                                                    .lhName
                                                    .toUpperCase()
                                                    .contains(
                                                        pattern.toUpperCase()));
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
                                              onSuggestionSelected: (suggestion) {
                                                print(suggestion.lhName);
                                                print("selected");

                                                customerController.text =
                                                    suggestion.lhName;
                                                print("close.... $customerId");
                                                customerId = 0;
                                                Customername = suggestion.lhName;
                                                print(suggestion.id);
                                                print(".......customerId");
                                                customerId = suggestion.id;
                                                print(customerId);
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
                                                  ))),
                                    ],
                                  ),


                                  SizedBox(height: 10,
                                  ),


                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller:Pay_Typ_Credit_Ph_Controller ,
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
                                            errorText: Pay_Typ_Credit_Ph_Valid == true
                                                ? "Invalid PH Number"
                                                : null,
                                            isDense: true,
                                            contentPadding: EdgeInsets.fromLTRB(
                                                20.0, 10.0, 20.0, 16.0),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(14.0)),
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
                                    child: Row(
                                      children: [
                                        //------------credit---ok  and Back Buttons-----------------------------
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, left: 10, right: 10),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.blue, // This sets the button color
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    print(customerController.text);
                                                    if (Pay_Typ_Credit_Ph_Controller.text == "") {
                                                      Pay_Typ_Credit_Ph_Valid = true;
                                                    }
                                                    if (customerController.text == "") {
                                                      customerSelect = true;
                                                      return;
                                                    }
                                                    if (customerController.text != "" &&
                                                        Pay_Typ_Credit_Ph_Controller.text != "") {
                                                      TotalAmtController.text = "Credited";
                                                      PaymentCompleted();
                                                    }
                                                  });
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                                  child: Text(
                                                    "   OK   ", // OK
                                                    style: TextStyle(
                                                      fontSize: 20.0,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              )

                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, left: 40, right:40),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.blue, // This sets the button color
                                                ),
                                                onPressed: () {
                                                  print(" Back ");
                                                  setState(() {
                                                    Pay_Frm_Reset();
                                                    PaymentAmtPopupVisilbe = false;
                                                    PaymentPopupVisilbe = true;
                                                    Pay_Typ_OthAmt_TxtBx_Visible = false;
                                                  });
                                                  PaymentName = "";
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                                  child: Text(
                                                    "BACK",
                                                    style: TextStyle(
                                                      fontSize: 20.0,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              )

                                            ),
                                          ],
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
      customerSelect=false;
      Pay_Typ_Credit_Ph_Valid=false;
      Pay_Typ_Credit_Ph_Controller.text="";
      customerController.text="";
      Payment_Credit_Visilbe=false;
    });
  }

//------------------------  Payment Completed-------------
  PaymentCompleted() {
    if (Pay_Typ_Tota_Amt_Controller.text == "0.0" &&
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
      Pay_Typ_Other_cash=0.00;
      Customername="xx";
      customerId=null;

      // print(" Pay_Typ_OthAmt_Controller ");
      // print(Pay_Typ_OthAmt_Controller.text);

      // print(" RoundOffController ");
      // print(RoundOffController.text);

      // print(" Pay_Typ_Credit_Ph_Controller ");
      // print(Pay_Typ_Credit_Ph_Controller.text);

      // print("customerController  ");
      // print(customerController.text);


      Navigator.pop(context);
    }



    else if (Pay_Typ_Tota_Amt_Controller.text == "0.0" &&
        Pay_Typ_OthAmt_TxtBx_Visible == true &&
        Pay_Typ_OthAmt_Controller.text != "") {
      print("On Cash And other Amount");
      Customername="xx";
      customerId=null;
      Navigator.pop(context);
    }




    else if(Pay_Typ_OthAmt_TxtBx_Visible  == false && Payment_Credit_Visilbe==true)
      {
        print("On Credit");
        Pay_Typ_cash=0;
        Pay_Typ_Disamt=0;
        Pay_Typ_RoundOff=0;
        Pay_Typ_Other_cash=0;
        Navigator.pop(context);
      }




    print("exit");
  }

  //------------------------PaymentCompleted-------------

//-----------------------------------------------------All functions End---------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width > 500
        ?
    SafeArea(
        child: Scaffold(
          //-----------------bottomNavigationBar -----Safve And Pay buttons------------------------

            appBar: PreferredSize(
              preferredSize: Size.fromHeight(160.0),
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
//                    SizedBox(width: 10,),

                            // GestureDetector(
                            //     onTap: () {
                            //       print("hi");
                            //     },
                            //     child: Container(
                            //       margin: new EdgeInsets.only(
                            //           left: 0.0, top: 25.0, right: 0.0, bottom: 0.0),
                            //       child: Text(
                            //         "${branchName.toString()}",
                            //         style: TextStyle(fontSize: 13, color: Colors.white),
                            //       ),
                            //     )),

                            GestureDetector(
                                onTap: () {
                                  print("hi");
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

                            GestureDetector(
                              onTap: () {
                                print("hi");
                              },
                              child: Container(
                                  margin:
                                  EdgeInsets.only(top: 10, bottom: 15),
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
                                        padding:
                                        const EdgeInsets.only(top: 7),
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
                            GestureDetector(
                              onTap: () {
                                Widget noButton = TextButton(
                                  child: Text("No"),
                                  onPressed: () {
                                    setState(() {
                                      print("No...");
                                      Navigator.pop(
                                          context); // this is proper..it will only pop the dialog which is again a screen
                                    });
                                  },
                                );

                                Widget yesButton = TextButton(
                                  child: Text("Yes"),
                                  onPressed: () {
                                    setState(() {
                                      print("yes...");
                                      pref.remove('userData');
                                      Navigator.pop(context); //okk
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
                            )
                          ]),
                    ),
                  ),
                  SizedBox(
                    height: 20,
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
                            TablenumValid == true ? "Invalid" : null,
                            isDense: true,
                            contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.0)),
                            hintStyle: TextStyle(
                                color: Colors.black, fontSize: 15),
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
                            hintStyle: TextStyle(
                                color: Colors.black, fontSize: 15),
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
                            isDense: true,
                            contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.0)),
                            hintStyle: TextStyle(
                                color: Colors.black, fontSize: 15),
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
            bottomNavigationBar: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                ),
                Container(
                  width: (MediaQuery.of(context).size.width / 2) - 30,
                  color: Color(0xFFFDF4F4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, bottom: 2, top: 5),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,  // button color
                            ),
                            onPressed: () {
                              print("Save");
                              print(jsonEncode(IBD));
                              IBSave(IBD);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(left: 5, top: 5, bottom: 2, right: 5),
                              child: Text(
                                "Save",
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
                              left: 10, bottom: 2, top: 5),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,  // button color
                            ),
                            onPressed: () {
                              print("Payment Type");
                              PaymentName = "";
                              SetPaymentType();
                              PaymentAmtPopupVisilbe = false;
                              Pay_Typ_Cash_Valid = false;
                            },
                            child: Padding(
                              padding: EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 5),
                              child: Text(
                                "Pay By",
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
                              scrollPadding:
                              EdgeInsets.fromLTRB(0, 20, 20, 0),
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

                                contentPadding: EdgeInsets.fromLTRB(
                                    10.0, 10.0, 10.0, 16.0),

                                border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(14.0)),

                                hintStyle: TextStyle(
                                    color: Colors.black, fontSize: 15),

                                labelText: "Total",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            body: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
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
                                  height: 150,
                                  child: imageSetting == false
                                      ?
                                  //----------------------Condition for button or image----------------------------

//  for text.....................

                                  Scrollbar(
                                    thickness: 5,
                                    child: GridView.builder(
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
                                            style: ElevatedButton.styleFrom(
                                              primary: Color.fromARGB(255, 175, 211, 246),
                                              onPrimary: Colors.white,
                                              shadowColor: Colors.blueAccent,
                                              elevation: 2,
                                            ),
                                            onPressed: () {
                                              print("index :  " + (btnItmGrp[i]["igDescription"]).toString());
                                              setState(() {
                                                getItem((btnItmGrp[i]["id"]));
                                                ItemLstController.text = "";
                                                ItemGrpController.text = (btnItmGrp[i]["igDescription"]).toString();
                                              });
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: Text(
                                                (btnItmGrp[i]["igDescription"]).toString(),
                                                style: TextStyle(fontSize: 20.0),
                                              ),
                                            ),
                                          )

                                        );
                                      },
                                    ),
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
                                          style: ElevatedButton.styleFrom(
                                            primary: Color.fromARGB(255, 255, 255, 255),  // button color
                                            onSurface: Colors.blueAccent,  // replaces splashColor
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                          ),
                                          onPressed: () {
                                            print("index : " + (btnItmGrp[i]["igDescription"]).toString());
                                            setState(() {
                                              getItem((btnItmGrp[i]["id"]));
                                              ItemLstController.text = "";
                                              ItemGrpController.text = (btnItmGrp[i]["igDescription"]).toString();
                                            });
                                          },
                                          child: Image.network(
                                            (btnItmGrp[i]["igDiplayImagepath"] == null)
                                                ? "https://st4.depositphotos.com/14953852/24787/v/600/depositphotos_247872612-stock-illustration-no-image-available-icon-vector.jpg"
                                                : (btnItmGrp[i]["igDiplayImagepath"]),
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
                                  height: 150,
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
                                          style: ElevatedButton.styleFrom(
                                            primary: Color.fromARGB(255, 175, 211, 246),  // button color
                                            onSurface: Colors.blueAccent,  // splash color
                                            // There's no direct hoverColor in ElevatedButton
                                          ),
                                          onPressed: () {
                                            print("index : " + (btnItmLst[i]["itmName"]).toString());
                                            setState(() {
                                              ItemLstController.text = (btnItmLst[i]["itmName"]).toString();
                                              ListoTable(btnItmLst[i]);
                                              quantityController.text = "1";
                                              print("opop");
                                              1 == 1 ? itemTblHight = 300 : itemTblHight = null;
                                            });
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 5),
                                            child: Text(
                                              btnItmLst[i]["itmName"].toString(),
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
                                          style: ElevatedButton.styleFrom(
                                            elevation: 7,
                                            primary: Color.fromARGB(255, 255, 255, 255), // Button color
                                            onPrimary: Colors.white, // Text color
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            shadowColor: Colors.blueAccent,
                                          ),
                                          onPressed: () {
                                            print("index :  " + (btnItmLst[i]["itmName"]).toString());
                                            setState(() {
                                              ItemLstController.text = (btnItmLst[i]["itmName"]).toString();
                                              ListoTable(btnItmLst[i]);
                                            });
                                          },
                                          child: Stack(
                                            children: [
                                              Image.network(
                                                btnItmLst[i]["itmImage"] == null || btnItmLst[i]["itmImage"] == ""
                                                    ? "http://erptest.qizo.in/assets/gtItmMstr/gtItmMstrimg_1180.jpg"
                                                    : btnItmLst[i]["itmImage"],
                                              ),
                                            ],
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
                        )
                      ]),
                ])))


        :

    SafeArea(
        child: Scaffold(
          bottomNavigationBar:
          //-----------------bottomNavigationBar -----Safve And Pay buttons------------------------
          Container(
            color: Color(0xFFFDF4F4),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                    const EdgeInsets.only(left: 10, bottom: 2, top: 5),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue, // button color
                      ),
                      onPressed: () {
                        print("Save");
                        print(jsonEncode(IBD));
                        IBSave(IBD);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 5, top: 5, bottom: 2, right: 5),
                        child: Text(
                          "Save",
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
                    padding:
                    const EdgeInsets.only(left: 10, bottom: 2, top: 5),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue, // button color
                      ),
                      onPressed: () {
                        print("Payment Type");
                        PaymentName = "";
                        SetPaymentType();
                        PaymentAmtPopupVisilbe = false;
                        Pay_Typ_Cash_Valid = false;
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 5),
                        child: Text(
                          "Pay By",
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
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(160.0),
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
//                    SizedBox(width: 10,),

                          // GestureDetector(
                          //     onTap: () {
                          //       print("hi");
                          //     },
                          //     child: Container(
                          //       margin: new EdgeInsets.only(
                          //           left: 0.0, top: 25.0, right: 0.0, bottom: 0.0),
                          //       child: Text(
                          //         "${branchName.toString()}",
                          //         style: TextStyle(fontSize: 13, color: Colors.white),
                          //       ),
                          //     )),

                          GestureDetector(
                              onTap: () {
                                print("hi");
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
                          GestureDetector(
                            onTap: () {
                              Widget noButton = TextButton(
                                child: Text("No"),
                                onPressed: () {
                                  setState(() {
                                    print("No...");
                                    Navigator.pop(
                                        context); // this is proper..it will only pop the dialog which is again a screen
                                  });
                                },
                              );

                              Widget yesButton = TextButton(
                                child: Text("Yes"),
                                onPressed: () {
                                  setState(() {
                                    print("yes...");
                                    pref.remove('userData');
                                    Navigator.pop(context); //okk
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
                          )
                        ]),
                  ),
                ),
                SizedBox(
                  height: 20,
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
          body:
          ListView(shrinkWrap: true, physics: ScrollPhysics(), children: [
            //--------------------------------For Item Grp-----------------------------------------
            Row(children: [
              SizedBox(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10),
                  child: GestureDetector(
                    onTap: () {
                      print("uikuy");
                      //  print(MediaQuery.of(context).size.width.toString());
                    },
                    child: Text(
                      "Item Group",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
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
                              contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14.0)),
                              labelText: 'Item Group search',
                            )),
                        suggestionsBoxDecoration:
                        SuggestionsBoxDecoration(elevation: 90.0),
                        suggestionsCallback: (pattern) {
                          return ItmGrp.where((user) =>
                              user.igDescription.contains(pattern.toUpperCase()));
                        },
                        itemBuilder: (context, suggestion) {
                          return Card(
                            margin: EdgeInsets.only(top: 2, right: 2, left: 2),
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
                  )),
            ]),
            // headig of item grp

            Visibility(
              visible: itmGrpVsbl == true,
              // visible:ItmGrp.length>0 ,
              child: Container(
                height: 150,
                child: imageSetting == false
                    ?
                //----------------------Condition for button or image----------------------------

//  for text.....................

                Scrollbar(
                  thickness: 5,
                  child: GridView.builder(
                    physics: ScrollPhysics(),
                    itemCount: ItmGrp.length,
                    shrinkWrap: true,
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, mainAxisExtent: 50),
                    itemBuilder: (c, i) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 175, 211, 246),
                            onPrimary: Colors.white,
                            shadowColor: Colors.blueAccent,
                            elevation: 2,
                          ),
                          onPressed: () {
                            print("index :  " + (btnItmGrp[i]["igDescription"]).toString());
                            setState(() {
                              getItem((btnItmGrp[i]["id"]));
                              ItemLstController.text = "";
                              ItemGrpController.text = (btnItmGrp[i]["igDescription"]).toString();
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              (btnItmGrp[i]["igDescription"]).toString(),
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                        )

                      );
                    },
                  ),
                )
                    :

//  ---for image............
                GridView.builder(
                  physics: ScrollPhysics(),
                  itemCount: ItmGrp.length,
                  shrinkWrap: true,
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, mainAxisExtent: 80),
                  itemBuilder: (c, i) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 255, 255, 255),
                          onPrimary: Colors.white,
                          shadowColor: Colors.blueAccent,
                          elevation: 7,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          print("index :  " + (btnItmGrp[i]["igDescription"]).toString());
                          setState(() {
                            getItem((btnItmGrp[i]["id"]));
                            ItemLstController.text = "";
                            ItemGrpController.text = (btnItmGrp[i]["igDescription"]).toString();
                          });
                        },
                        child: Image.network(
                          (btnItmGrp[i]["igDiplayImagepath"]) == null
                              ? "https://st4.depositphotos.com/14953852/24787/v/600/depositphotos_247872612-stock-illustration-no-image-available-icon-vector.jpg"
                              : (btnItmGrp[i]["igDiplayImagepath"]),
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
                    padding:
                    const EdgeInsets.only(top: 10, left: 10, right: 70),
                    child: Text(
                      "Item",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  ),
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
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
                                contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14.0)),
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
                              margin: EdgeInsets.only(top: 2, right: 2, left: 2),
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
                    )),
              ]), // headig of item grp
            ),

            Visibility(
              visible: itmLstVsbl == true,
              child: Container(
                height: 150,
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
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 175, 211, 246), // Button color
                          onPrimary: Colors.white, // Text color
                          shadowColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(),
                        ),
                        onPressed: () {
                          print("index :  " + (btnItmLst[i]["itmName"]).toString());
                          setState(() {
                            ItemLstController.text = (btnItmLst[i]["itmName"]).toString();
                            ListoTable(btnItmLst[i]);
                            quantityController.text = "1";
                            print("opop");
                            1 == 1 ? itemTblHight = 300 : itemTblHight = null;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            (btnItmLst[i]["itmName"].toString()),
                            style: TextStyle(
                              fontSize: 20.0,
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
                      crossAxisCount: 3, mainAxisExtent: 70),
                  itemBuilder: (c, i) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 255, 255, 255),
                          onPrimary: Colors.white,
                          shadowColor: Colors.blueAccent,
                          elevation: 7,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          print("index :  " + (btnItmLst[i]["itmName"]).toString());
                          setState(() {
                            ItemLstController.text = (btnItmLst[i]["itmName"]).toString();
                            ListoTable(btnItmLst[i]);
                          });
                        },
                        child: Stack(
                          children: [
                            Image.network(
                              (btnItmLst[i]["itmImage"]) == null || (btnItmLst[i]["itmImage"]) == ""
                                  ? "http://erptest.qizo.in/assets/gtItmMstr/gtItmMstrimg_1180.jpg"
                                  : (btnItmLst[i]["itmImage"]),
                            ),
                          ],
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
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ))),

            Divider(
              color: Colors.black,
            ),
            //-------------------------------------item End---------------------------------------------------------

            //---------------------------Table Strt---------------------

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
                            decoration: BoxDecoration(
                                border: Border(
                                  bottom: Divider.createBorderSide(context,
                                      width: 1.0),
                                )),
                            columnSpacing: 20,
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
                                        child: Text(getItemIndex(itemRow)
                                            .toString())),
                                    showEditIcon: false,
                                    placeholder: false,
                                  ),
                                  DataCell(
                                    Text(itemRow.Name.toString()),
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
        ));

  }
}

class Tabledata {
  int id;
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
  int id;
  String igDescription;
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

