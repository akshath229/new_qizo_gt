import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';

import '../GT_Masters/AppTheam.dart';
import '../GT_Masters/Masters_UI/cuWidgets.dart';
import '../GT_Masters/Models/Items.dart';
import '../itemBill.dart';
import '../models/userdata.dart';
import 'RMS_HomePage.dart';


class Rms_MakeOrder extends StatefulWidget {
  @override
  _Rms_MakeOrderState createState() => _Rms_MakeOrderState();
}

class _Rms_MakeOrderState extends State<Rms_MakeOrder> {
  CUWidgets cw=CUWidgets();
  late SharedPreferences pref;
  dynamic branch;
  late UserData userData;
  dynamic user;
  late int branchId;
  late int userId;
  String branchName = "";
  dynamic userName;
  late String token;

  var ScreenHeight=0.0 ;
  var ScreenWidth=0.0;
  var DeliveryByList=[];
  double TotalNetAmt=0.0;
  var dataForTicket;

  static List<Tabledata> TD = [];
  static List<Rms_MakeOrder_Details> MOD = [];
  static List<ItemGroup> ItmGrp = [];
  static List<ItemList> ItmLst = [];
  dynamic btnItmGrp = [];
  dynamic btnItmLst = [];
  bool grp_Inputbox_Vsbl =
  false; // for hide and show Item Grp Search InputText box
  bool itm_Inputbox_Vsbl =
  false; // for hide and show Item  Search InputText box
  int ItemGrpId = 0;
  bool itmGrpVsbl = false;
  bool itmLstVsbl = false;
  bool Noitem = false;
  bool imageSetting = false;
  bool UomRateSelect = false;
  bool quantitySelect = false;
  dynamic itemname = "";
  dynamic itemTaxInOrEx;
  late List<dynamic> UomData;
  var UomTableData = {};
  dynamic UOM = null;
  late Rms_MakeOrder_Details ItmBLdata;
  dynamic itemQty = 0;
  dynamic itemRate = 0.00;
  dynamic total = 0;
  // dynamic TotalAmt = 0.00;
  int slnum = 0;
  bool listabledataShow = false;
  late Tabledata TDdata;
  var EditId=null;
  late String DeviceId;

  AppTheam theam =AppTheam();
  var KOT_Printer;
  var Counter_Printer;

  var SelectedItemGrp =null;// for change color of selected item grp
  var SelectedItem =null;// for change color of selected item

  TextEditingController MO_TotalAmtController= TextEditingController();
  TextEditingController MO_TokennumController= TextEditingController();
  //TextEditingController DeliveryByController= TextEditingController();
  TextEditingController ItemGrpController = new TextEditingController();
  TextEditingController ItemLstController = new TextEditingController();
  TextEditingController UomRateController = new TextEditingController();
  TextEditingController quantityController = new TextEditingController();
  TextEditingController TablenumController = new TextEditingController();
  TextEditingController OrderumController = new TextEditingController();
  TextEditingController BillNumberController = new TextEditingController();
  TextEditingController ItemNotesController = new TextEditingController();





  bool TablenumValid=false;
  bool OrdernumValid=false;
  bool BillNumberValid=false;
  bool DeliveryBySelect=false;
  dynamic DeliveryBy_Id=null;
  bool itemSelectvalidate = false;
  String ButtonName="Save";

  bool Top_TextBox_Visible=false;

  var ItemNotes_Id;

  // var goods=[
  //   {"itmName":1,"itmName":"uio"},{"itmName":2,"itmName":"uio2"},
  //   {"itmName":1,"itmName":"uio"},{"itmName":2,"itmName":"uio2"},
  //   {"itmName":1,"itmName":"uio"},{"itmName":2,"itmName":"uio2"},
  //   {"itmName":1,"itmName":"uio"},{"itmName":2,"itmName":"uio2"},
  //   {"itmName":1,"itmName":"uio"},{"itmName":2,"itmName":"uio2"},
  //   {"itmName":1,"itmName":"uio"},{"itmName":2,"itmName":"uio2"},
  //   {"itmName":1,"itmName":"uio"},{"itmName":2,"itmName":"uio2"},
  //   {"itmName":1,"itmName":"uio"},{"itmName":2,"itmName":"uio2"},
  //   {"itmName":1,"itmName":"uio"},{"itmName":2,"itmName":"uio2"},
  //   {"itmName":1,"itmName":"uio"},{"itmName":2,"itmName":"uio2"},
  //   {"itmName":1,"itmName":"uio"},{"itmName":2,"itmName":"uio2"},
  //   {"itmName":1,"itmName":"uio"},{"itmName":2,"itmName":"uio2"},
  //   ] ;



  void initState() {
    setState(() {
      SharedPreferences.getInstance().then((value) {
        pref = value;
        read();
        InitialFunctions();
      });
    });
  }





  var BillingNote;
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







//-----------------------GeneralSettings----------------------------------------

  GeneralSettings()async{

    var res=await cw.CUget_With_Parm(api:"GeneralSettings",Token: token);

    if(res!=false){
      print("res") ;
      print(res.toString()) ;
      var jsonres=json.decode(res);

// print(jsonres[0]["rmsKotPrinter"]) ;
      setState(() {
        KOT_Printer=jsonres[0]["rmsKotPrinter"];
        Counter_Printer=jsonres[0]["rmsCounterPrinter"];
        imageSetting=jsonres[0]["rmsBillDispImg"];
      });

    }
  }

  //---------------------Get item------------------------------------
  getItem(id) async {
    try {
      var res=await cw.CUget_With_Parm(Token:token,api: "gtitemmasters/$id/0" );
      if(res!=false){
        var tagsJson = json.decode(res);
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

      }

    } catch (e) {
      print(e);
    }
  }


  // -------------------------get itemGrp------------------------
  getItemGrp() async {
    print(" Item Grp");

    var res= await cw.CUget_With_Parm(api:"Gtitemgroups",Token: token );
    if(res!=false) {
      var tagsJson = json.decode(res);
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
    }

  }







  InitialFunctions(){
    GetTokenNo();
    GetDeliveryBy();
    getItemGrp();
    GetOrderNum();
    TD.clear();
    MOD.clear();
    GeneralSettings();
    SelectedItemGrp =null;
    SelectedItem =null;
    GetBillingNote();
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
      DeviceId = user.deviceId;
    });
  }




  //------------------------Get Token number---------------

  GetTokenNo()async{
    var res =await cw.CUget_With_Parm(api: "getsettings/1/gtsalesordertoken",Token: token);

    if(res!=false){
      // print("success GetToken");
      // print(res.toString());
      var tokendata=json.decode(res);
      // print(tokendata[0]["vocherNo"].toString());
      setState(() {
        MO_TokennumController.text=tokendata[0]["vocherNo"].toString();
      });
    }


  }



  //------------------------Get  DeliveryBy---------------

  GetDeliveryBy()async{
    var res =await cw.CUget_With_Parm(api: "MemployeeMasters/9/2",Token: token);

    if(res!=false){
      // print("success GetDeliveryBy");
      // print(res.toString());
      var resData=json.decode(res);
      DeliveryByList=resData["employeeMaster"];
      // print(DeliveryByList[0]["emEmployeeName"].toString());
      // setState(() {
      //
      // });
    }


  }


  //------------------------Get  GetOrderNum---------------

  GetOrderNum()async{

    var res =await cw.CUget_With_Parm(api: "getsettings/1/soheader",Token: token);

    if(res!=false){
      // print("success GetDeliveryBy");
      // print(res.toString());
      var resData=json.decode(res);
      OrderumController.text=resData[0]["vocherNo"].toString();
      // print(DeliveryByList[0]["emEmployeeName"].toString());
      setState(() {

      });
    }

  }




  //-----------------Show poup for  selected items --------------------------------------
  ListoTable(array) async {
    UomRateController.text = "";
    UomRateSelect = false;
    quantitySelect = false;
    print("in");

    dynamic Did = (array["id"]).toString();
    int itemid = int.parse(Did);
    itemname = array["itmName"];
    itemTaxInOrEx = array["itmTaxInclusive"];
    try {

      var result=await cw.CUget_With_Parm(Token: token,api:'gtitemmasters/$itemid/-1');
      //  print(" Item UOM");
      // print(res.body);

      //  print("json decoded");

      var tagsJson = json.decode(result);
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
                      padding: const EdgeInsets.only(top: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 130,
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
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
                                  print(suggestion["notes"] );
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
                              icon: Icon(Icons.add_shopping_cart,size: 35,color: Colors.teal,), onPressed:(){
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
  }








  //---------------------------------Data Bind To Table------------------------------------------------------------
  bindToTable() {
    //TotalNetAmt=0.0;
    if(quantityController.text=="")
    {
      quantityController.text="1";
    }
    // try {
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
    // print(TotalAmt.runtimeType);
    print(amtWithTax);
    // print(TotalAmt.toString());
    TotalNetAmt = amtWithTax+TotalNetAmt;
    print("TotalNetAmt");
    print(TotalNetAmt.toString());
    // TotalAmt = TotalAmt.toInt() + amtWithTax.toInt();
    // TotalNetAmt = (TotalAmt.toDouble());

    slnum = ++slnum;
    listabledataShow = true;
    ItmBLdata = Rms_MakeOrder_Details(
        ItemSlNo:slnum,
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
        netTotal:amtWithTax, //TotalAmt,
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
        poid: EditId
    );
    setState(() {
      MOD.add(ItmBLdata);
      print(jsonEncode(MOD));
    });

    TDdata = Tabledata(
      id: UomTableData['itemid'],
      ItemSlNo:slnum,
      Name: UomTableData['itmName'],
      Qty: itemQty,
      rate: itemRate,
      Total: itemRate * itemQty,
      UOM: UomTableData['description'],
      AmtWithTax: amtWithTax,
    );
    setState(() {
      MO_TotalAmtController.text=TotalNetAmt.toStringAsFixed(3);
      TD.add(TDdata);
      print(jsonEncode(TD));
      listabledataShow = true;
    });
    // } catch (e) {
    //   print("error on Bind to table $e");
    // }
  }

  //---------------------------------END  Data Bind To Table------------------------------------------------------------



  //-----Table no-----------------
  getItemIndex(dynamic item) {
    var index = TD.indexOf(item);
    return index + 1;
  }


  //----------------------------- GetExisting_data_Of_Tablenum--adn Ordernum-----------------------------
  TabelNumDatapopup(String type,controller,bool validation){


    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context)
        {
          return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title:Row(children: [
                    Text('Customer Order Delivery'),
                    Spacer(),
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
                              validation=false;
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
    else{
      var Tablenum=TablenumController.text;
      res=await cw.CUget_With_Parm(api:"Soheader/$Tablenum/tableno",Token: token);
    }

    if(res!=false){
      setState(() {
        MOD.clear();
        TD.clear();
        TotalNetAmt=0.0;
      });
      // print(res.toString());
      // print("res.toString()");
      var TextBoxget=json.decode(res);
      print("TextBodget: "+TextBoxget.toString());
      // print(TextBodget['data']['voucherNo']);
      TabelNumDataBinding(TextBoxget['data']['sodetailed']);
      setState(() {
        OrderumController.text=TextBoxget['data']['voucherNo'].toString();
        MO_TokennumController.text=TextBoxget['data']['tokenNo'].toString();
        TablenumController.text=TextBoxget['data']['deliveryTo'].toString();
        EditId=TextBoxget['data']['id'];
        ButtonName="Update";
      });
    }
    else{
      TotalNetAmt=0.0;
      MOD.clear();
      TD.clear();
      listabledataShow=false;
      //TotalAmt =TotalNetAmt;
      MO_TotalAmtController.text=TotalNetAmt.toStringAsFixed(3);
      GetTokenNo();
      GetOrderNum();
      ButtonName="Save";
    }

  }




  TabelNumDataBinding(a){
    print(a);

    for(int i=0;i<a.length;i++){

      print(a[i]['itemName']);


      ItmBLdata = Rms_MakeOrder_Details(

        ItemSlNo: i,
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
        poid: a[i]['poid'],

      );
      setState(() {
        MOD.add(ItmBLdata);
      });



      TDdata = Tabledata(
        id:  a[i]['itemId'],
        ItemSlNo: i,
        Name: a[i]['itemName'],
        Qty: a[i]['qty'],
        rate:a[i]['rate'],
        // Total: a[i]['netTotal'],
        Total:(a[i]['qty']*a[i]['rate']),
        UOM:a[i]['description'],
        AmtWithTax: a[i]['amountIncludingTax'],
        // AmtWithTax: amtWithTax,
      );
      setState(() {
        TD.add(TDdata);

      });
// print("-----------------------------------");
//   print(json.encode(ItmBLdata));

      TotalNetAmt=a[i]['amountIncludingTax']+TotalNetAmt;
      setState(() {
        //TotalAmt =TotalNetAmt;
        MO_TotalAmtController.text=TotalNetAmt.toStringAsFixed(3);

      });
      slnum=i;
    }
    listabledataShow = true;
  }




  //-------------------------------validation------------------------

  Validation(){
    // if(TablenumController.text==""){
    //   setState(() {
    //     print(TablenumController.text);
    //     TablenumValid=true;
    //     return;
    //   });
    // }

    //else
      if(TD.isEmpty) {
      showDialog(context: context, builder:(c){
        return AlertDialog(
          title: Center(child: Text("ADD ITEMS",style: TextStyle(color: Colors.red),)),
        );

      });


    }



    else{
      setState(() {
        TablenumValid=false;
      });
      Rms_MakeOrderSave();
    }
  }







//-----------------------------Save---------------------------
  Rms_MakeOrderSave()async{


    print(json.encode(MOD).toString());

    if(ButtonName=="Save"){
      print("On save") ;


      var SaveData= {
        // "id":EditId,
        "voucherNo":OrderumController.text,
        "address1": null,
        "address2": null,
        "amount": MO_TotalAmtController.text,
        "cancelFlg": null,
        "cancelRemarks": null,
        "deliveryTo": TablenumController.text,
        "deliveryType": true,
        "discountAmt": 0,
        "entryDate": "",
        "expDate": null,
        "gstNo": null,
        "isSale": null,
        "ledger": null,
        "ledgerId": null,
        "narration": null,
        "orderHeadId": null,
        "orderstatus": "deliverypending",
        "partyName": null,
        "phone": null,
        //"salesHeader": [],
        "shipToAddress1": null,
        "shipToAddress2": null,
        "shipToName": null,
        "shipToPhone": null,
        "slesMan": null,
        "slesManId": null,
        "sodetailed":MOD,
        "tokenNo": MO_TokennumController.text,
        "voucherDate": "2021-11-10"
      };

      var parm=json.encode(SaveData);
      print("data");
      print(parm.toString());


      var res=await cw.post(api:"Soheader",body: parm,deviceId:DeviceId,Token: token );

      if(res!=false){
        print(res.toString());
        print("success");
        var result= json.decode(res);
//  cw.SavePopup(context);
        InitialFunctions();
        setState(() {
          TablenumController.text="";
          MOD.clear();
          TD.clear();
          MO_TotalAmtController.text="";
          listabledataShow=false;
          Timer(Duration(seconds: 2), (){
            PrintGetData(result["id"]);
          });

        });

      }
      else
      {
        print("Error on save") ;
        cw.FailePopup(context);


      }
    }else//............Edit part ...................
        {
      print("On Edit") ;
      print(EditId.toString()) ;
      var EditData= {
        "id":EditId,
        "voucherNo":OrderumController.text,
        "address1": null,
        "address2": null,
        "amount": MO_TotalAmtController.text,
        "cancelFlg": null,
        "cancelRemarks": null,
        "deliveryTo": TablenumController.text,
        "deliveryType": true,
        "discountAmt": 0,
        "entryDate": "",
        "expDate": null,
        "gstNo": null,
        "isSale": null,
        "ledger": null,
        "ledgerId": null,
        "narration": null,
        "orderHeadId": null,
        "orderstatus": "deliverypending",
        "partyName": null,
        "phone": null,
        //"salesHeader": [],
        "shipToAddress1": null,
        "shipToAddress2": null,
        "shipToName": null,
        "shipToPhone": null,
        "slesMan": null,
        "slesManId": null,
        "sodetailed":MOD,
        "tokenNo": MO_TokennumController.text,
        "voucherDate": "2021-11-10",
        "branchId":branchId,
        "userId":userId
      };

      var Editparm=json.encode(EditData);
      print("data");
      print(Editparm.toString());
      var res=await cw.put(api:"Soheader/$EditId",body: Editparm,deviceId:DeviceId,Token: token);

      if(res!=false){
        print(res.toString());
        print("success");
        cw.UpdatePopup(context);
        InitialFunctions();
        setState(() {
          TablenumController.text="";
          MOD.clear();
          TD.clear();
          MO_TotalAmtController.text="";
          listabledataShow=false;
        });

      }
    }
  }








//---------------------------Printpopup------------------------------------------
  Printpopup(){
    print("Printpopup");

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context)
        {
          return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title:Row(children: [
                    Expanded(
                      child: TextFormField(
                        controller: BillNumberController,
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
                          BillNumberValid == true ? "Invalid" : null,
                          isDense: true,
                          contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.0)),
                          hintStyle: TextStyle(
                              color: Colors.black, fontSize: 15),
                          labelText: "Bill Number",
                          labelStyle: TextStyle(fontSize: 13),
                        ),
                      ),
                    ),

                    SizedBox(width: 5,),
                    cw.CUButton(name: "Print",H: 40,color: Colors.green,W: 80,function: (){
                      if(BillNumberController.text==""){

                        setState((){
                          BillNumberValid=true;
                        });
                      }
                      else{
                        Navigator.of(context).pop();
                        PrintGetData(BillNumberController.text);
                        LoadingIcon(true);
                      }

                    })

                  ],),
                  actions: [
                    SizedBox(
                        width: 300,
                        child: Row(children: [

                          Expanded(child: cw.CUButton(name: "CLEAR",H: 40,color: Colors.deepPurpleAccent,W: 100,function: (){
                            setState((){
                              BillNumberController.text="";
                              BillNumberValid=false;
                            });
                          })),
                          Spacer(),

                          Expanded(child: cw.CUButton(name: "Cancel",H: 40,color: Colors.red,W: 100,function: ()
                          {
                            setState((){
                              BillNumberValid=false;
                              BillNumberController.text="";
                            });
                            Navigator.of(context).pop();
                          })),


                        ],)) ],

                );
              });
        });



  }

  PrintGetData(a)async{

    print("PrintGetData  $a");
    var res=await cw.CUget_With_Parm(api:"Soheader/$a/billcopy",Token: token);
    if(res!=false){
      //print(res.toString());

      dataForTicket = await jsonDecode(res)['data'];

      //print(dataForTicket);

      Timer(Duration(milliseconds: 10), () async{
        await wifiprinting(KOT_Printer);
        // blutoothprinting();
      });

      Timer(Duration(milliseconds: 20), () async{
        await wifiprinting(Counter_Printer);
        // blutoothprinting();
      });






      Timer(Duration(seconds: 2),() {
        //Navigator.of(context, rootNavigator: true).pop();
        cw.MessagePopup(context, "Success...",Colors.green);
        BillNumberController.text="";
      });

    }
    else{
      Timer(Duration(seconds: 2),() {
        // Navigator.of(context, rootNavigator: true).pop();
        cw.MessagePopup(context, "Invalid Bill Number..!",Colors.red);
      });
      Timer(Duration(milliseconds:2500 ),() {
        Printpopup();
      });

    }
  }

//-----------------------------------------------
  LoadingIcon(bool visibility){

    showDialog(
        useSafeArea: true,
        // barrierColor: Colors.transparent,
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  backgroundColor: Colors.transparent,elevation: 0,
                  shape:RoundedRectangleBorder(
                    // side: BorderSide(color:  Colors.white10, width: 0),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  title: Visibility(
                    visible: visibility,
                    child: Center(
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Text("Printing...   ",
                            // style: TextStyle(color: Color(0xFF0B3AE7)),
                          ),
                          SizedBox(width: 30,height: 30,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color> (Color(
                                    0xFF0B3AE7)),)),
                        ],
                      ),
                    ),),
                );
              });
        });

  }




  removeListElement(slnum,id,amt){




    setState(() {


      TD.removeWhere((e) =>e.ItemSlNo==slnum&&e.id==id);
      MOD.removeWhere((e) =>e.ItemSlNo==slnum&&e.itemId==id);
      TotalNetAmt=TotalNetAmt-amt;
// TotalAmt=TotalAmt-amt;
      MO_TotalAmtController.text=TotalNetAmt.toStringAsFixed(3);
      if(TotalNetAmt<=0||TD.isEmpty){
        MO_TotalAmtController.text="0.00";
        listabledataShow=false;
        TotalNetAmt=0.0;
        // TotalAmt=0.0;
      }
      print("TotalAmt");
      print("-----------------------------------------");
// print(TotalAmt);
    });
  }



  ///--------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    ScreenHeight= MediaQuery.of(context).size.height;
    ScreenWidth= MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(


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
                                    print("No...");
                                    Navigator.of(context,
                                        rootNavigator: true)
                                        .pop();
                                    // Navigator.pop(
                                    //     context); // this is proper..it will only pop the dialog which is again a screen
                                  },
                                );

                                Widget yesButton = TextButton(
                                  child: Text("Yes"),
                                  onPressed: () {
                                    setState(() {
                                      print("yes...");
                                      pref.remove('userData');
                                      // Navigator.pop(context); //okk
                                      Navigator.of(context,
                                          rootNavigator: true)
                                          .pop();
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
                          Expanded(
                            child: GestureDetector(
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
                                        "Make Order",
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
                          ),
                          Container(
                            margin: new EdgeInsets.only(
                                left: 0.0,
                                top: 25.0,
                                right: 0.0,
                                bottom: 0.0),
                            child: Text(
                              "${userName.toString()}",
                              style: TextStyle(textBaseline: TextBaseline.ideographic,
                                  fontSize: 13, color: Colors.white),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 5,top: 25),
                            child: GestureDetector(
                                onTap: () {
                                  Printpopup();
                                },
                                child: Icon(
                                  Icons.print,
                                  color: Colors.white,
                                  // size: 30,
                                )),
                          ),


                          Padding(
                            padding: const EdgeInsets.only(left: 10,top: 25),
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








          body:ScreenWidth>500?
          ///--------------------Tab_View-------------------------------------------

          Row(children: [
            SizedBox(width: ScreenWidth/2,
              child: ListView(children: [
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
                        SelectedItemGrp =null;
                        SelectedItem =null;
                      });
                    },
                  ),
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
                    child: imageSetting == false
                        ?
                    //----------------------Condition for button or image--------Tab_View----------------------

//  for text...............--Tab_View ......

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
                              style: ElevatedButton.styleFrom(
                                splashFactory: InkSplash.splashFactory,
                                onSurface: Colors.blueAccent,
                                primary: SelectedItemGrp == i
                                    ? Colors.blueAccent.shade700
                                    : Color.fromARGB(255, 175, 211, 246), // background color
                              ),
                              onPressed: () {
                                if (TablenumController.text == "") {
                                  setState(() {
                                    TablenumValid = true;
                                    itmLstVsbl = false;
                                  });
                                } else {
                                  print("index :  " + (btnItmGrp[i]["igDescription"]).toString());
                                  setState(() {
                                    TablenumValid = false;
                                    getItem((btnItmGrp[i]["id"]));
                                    ItemLstController.text = "";
                                    ItemGrpController.text = (btnItmGrp[i]["igDescription"]).toString();
                                    SelectedItemGrp = i;
                                  });
                                }
                              },
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(1),
                                    child: Text(
                                      (btnItmGrp[i]["igDescription"]).toString(),
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: SelectedItemGrp == i ? Colors.white : Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            )

                          );
                        },
                      ),
                    )
                        :

//  ---for image....Item Grp....-Tab_View...
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
                              primary: Color.fromARGB(255, 255, 255, 255), // background color
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              onSurface: Colors.blueAccent, // equivalent to splashColor in RaisedButton
                              onPrimary: Colors.black, // text color
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

                //-------------------------------------Item Grp End----------Tab_View----------------------------------

                Visibility(
                  visible: itmLstVsbl == true,
                  child: Divider(
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 1,
                ),


                //------------------------------------Fot Item------------Tab_View---------------------------------------------
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
                          SelectedItemGrp =null;
                          SelectedItem =null;
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
                                      // ListoTable(jsonDecode(itm_data));
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
                    height: 142,
                    child: imageSetting == false
                        ?
                    //------------------------img or text--------------Tab view----------------------

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
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue, // background color
                            ),
                            onPressed: () {
                              print("zzzz");
                              Validation();
                            },
                            child: Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    ButtonName,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )

                        );
                      },
                    )
                        :
//...............img........Itm...--Tab view....
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
                              elevation: 7,
                              primary: Color.fromARGB(255, 255, 255, 255), // background color
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              onSurface: Colors.blueAccent, // equivalent to splashColor in RaisedButton
                              onPrimary: Colors.black, // text color
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








              ],),),



//-------------------------data table--------------------------------------
            Expanded(
              child: Visibility(
                  visible: listabledataShow,
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
                          ),
                          DataColumn(
                            label: Text('Net Total'),
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
                                                        itemRow.id,
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
                                placeholder: false,
                              ), DataCell(
                                Text((itemRow.AmtWithTax) != null
                                    ? itemRow.AmtWithTax.toString()
                                    : 0.0.toString()),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                IconButton(icon: Icon(Icons.delete),onPressed: (){
                                  showDialog(
                                      context: context,
                                      builder: (c) => AlertDialog(
                                          content: Container(
                                            height: 40,
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "Do you want to Delete?",
                                                    style: TextStyle(
                                                        color:
                                                        Colors.red),
                                                  ),
                                                ),
                                                Expanded(
                                                  child:
                                                  Text(itemRow.Name),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              child: Text("Yes"),
                                              onPressed: () {
                                                Navigator.of(context,
                                                    rootNavigator:
                                                    true)
                                                    .pop();
                                                setState(() {
                                                  removeListElement(
                                                      itemRow.ItemSlNo,
                                                      itemRow.id,
                                                      itemRow.AmtWithTax);
                                                });
                                              },
                                            ),
                                            TextButton(
                                                child: Text("No"),
                                                onPressed: () {
                                                  // Navigator.pop(context,false);
                                                  Navigator.of(context,
                                                      rootNavigator:
                                                      true)
                                                      .pop();
                                                })
                                          ]));
                                },),
                              ),
                            ],
                          ),
                        )
                            .toList(),
                      ),
                    ),
                  )),
            ),


          ],)



              :


          ///--------------------Mob_View-------------------------------------------
          ListView(
            shrinkWrap: true,
            // physics: NeverScrollableScrollPhysics(),
            physics: ScrollPhysics(),
            children: [



              Visibility(
                visible: Top_TextBox_Visible,
                child: Row(
                  children: [

                    //----------------------Order num-----------------------------
                    SizedBox(
                      width: 6,
                    ),
                    Expanded(
                      child: TextFormField(
                        onTap: (){

                          TabelNumDatapopup("Order No",OrderumController,OrdernumValid);

                        },
                        controller: OrderumController,
                        // readOnly: true,
                        // enabled: false,
                        validator: (v) {
                          if (v!.isEmpty) return "Required";
                          return null;
                        },
                        cursorColor: Colors.black,
                        scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                        decoration: InputDecoration(
                            errorStyle: TextStyle(color: Colors.red),
                            errorText:
                            OrdernumValid == true ? "Invalid" : null,
                            isDense: true,
                            contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.0)),
                            labelText: "Order No",
                            labelStyle: TextStyle(fontSize: 13)
                        ),
                      ),
                    ),

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
                        onTap:() {

                          TabelNumDatapopup("Table No",TablenumController,TablenumValid);

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
                            labelStyle: TextStyle(fontSize: 13)
                        ),
                      ),
                    ),

                    //----------------------Token num-----------------------------
                    SizedBox(
                      width: 6,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: MO_TokennumController,
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
                            labelStyle: TextStyle(fontSize: 13)
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
                      SelectedItemGrp =null;
                      SelectedItem =null;
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
                            style: ElevatedButton.styleFrom(
                              primary: SelectedItem == i
                                  ? Colors.indigo
                                  : Color.fromARGB(255, 175, 211, 246), // background color
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              onSurface: Colors.blueAccent, // equivalent to splashColor in RaisedButton
                              onPrimary: SelectedItem == i ? Colors.white : Colors.black, // text color
                            ),
                            onPressed: () {
                              print("index :  " + (btnItmLst[i]["itmName"]).toString());
                              setState(() {
                                ItemLstController.text = (btnItmLst[i]["itmName"]).toString();
                                ListoTable(btnItmLst[i]);
                                quantityController.text = "1";
                                SelectedItem = i;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.all(1),
                              child: Text(
                                (btnItmLst[i]["itmName"].toString()),
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: SelectedItem == i ? Colors.white : Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )

                        );
                      },
                    ),
                  )
                    //  :

//  ---for image....Item Grp....--Mobile view....
//                   GridView.builder(
//                     physics: ScrollPhysics(),
//                     itemCount: ItmGrp.length,
//                     shrinkWrap: true,
//                     gridDelegate:
//                     SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 4, mainAxisExtent: 80),
//                     itemBuilder: (c, i) {
//                       return Padding(
//                         padding: const EdgeInsets.all(5.0),
//                         child: RaisedButton(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10)),
//                           splashColor: Colors.blueAccent,
//                           hoverColor: Colors.black,
//                           color: Color.fromARGB(255, 255, 255, 255),
//                           onPressed: () {
//                             print("index :  " +
//                                 (btnItmGrp[i]["igDescription"])
//                                     .toString());
//                             setState(() {
//                               getItem((btnItmGrp[i]["id"]));
//                               ItemLstController.text = "";
//                               ItemGrpController.text = (btnItmGrp[i]
//                               ["igDescription"])
//                                   .toString();
//                             });
//                           },
//                           child: Image.network((btnItmGrp[i]
//                           ["igDiplayImagepath"]) ==
//                               null
//                               ? "https://st4.depositphotos.com/14953852/24787/v/600/depositphotos_247872612-stock-illustration-no-image-available-icon-vector.jpg"
//                           //"http://erptest.qizo.in/assets/gtItmMstr/gtItmMstrimg_6.jpg"
//                               : (btnItmGrp[i]["igDiplayImagepath"])),
//                         ),
//                       );
//                     },
//                   ),
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
                        SelectedItemGrp =null;
                        SelectedItem =null;
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
                                    // ListoTable(jsonDecode(itm_data));
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
                          style: ElevatedButton.styleFrom(
                            primary: SelectedItem == i
                                ? Colors.indigo
                                : Color.fromARGB(255, 175, 211, 246), // background color
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            onSurface: Colors.blueAccent, // equivalent to splashColor in RaisedButton
                            onPrimary: SelectedItem == i ? Colors.white : Colors.black, // text color
                          ),
                          onPressed: () {
                            print("index :  " + (btnItmLst[i]["itmName"]).toString());
                            setState(() {
                              ItemLstController.text = (btnItmLst[i]["itmName"]).toString();
                              ListoTable(btnItmLst[i]);
                              quantityController.text = "1";
                              SelectedItem = i;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.all(1),
                            child: Text(
                              (btnItmLst[i]["itmName"].toString()),
                              style: TextStyle(
                                fontSize: 16.0,
                                color: SelectedItem == i ? Colors.white : Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )

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
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 255, 255, 255), // background color
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 7,
                            onSurface: Colors.blueAccent, // equivalent to splashColor in RaisedButton
                            onPrimary: Colors.black, // text color for hover
                          ),
                          onPressed: () {
                            print("index :  " + (btnItmLst[i]["itmName"]).toString());
                            setState(() {
                              ItemLstController.text = (btnItmLst[i]["itmName"]).toString();
                              ListoTable(btnItmLst[i]);
                            });
                          },
                          child: Image.network(
                            (btnItmLst[i]["itmImage"]) == null || (btnItmLst[i]["itmImage"]) == ""
                                ? "http://erptest.qizo.in/assets/gtItmMstr/gtItmMstrimg_1180.jpg"
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
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      ))),

              Divider(
                color: Colors.black,
              ),





//-------------------------data table--------------------------------------
              Visibility(
                visible: listabledataShow,
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
                        ),
                        DataColumn(
                          label: Text('Net Total'),
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
                                                      itemRow.id,
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
                              placeholder: false,
                            ), DataCell(
                              Text((itemRow.AmtWithTax) != null
                                  ? itemRow.AmtWithTax.toString()
                                  : 0.0.toString()),
                              showEditIcon: false,
                              placeholder: false,
                            ),
                            DataCell(
                              IconButton(icon: Icon(Icons.delete),onPressed: (){
                                showDialog(
                                    context: context,
                                    builder: (c) => AlertDialog(
                                        content: Container(
                                          height: 40,
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Do you want to Delete?",
                                                  style: TextStyle(
                                                      color:
                                                      Colors.red),
                                                ),
                                              ),
                                              Expanded(
                                                child:
                                                Text(itemRow.Name),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Text("Yes"),
                                            onPressed: () {
                                              Navigator.of(context,
                                                  rootNavigator:
                                                  true)
                                                  .pop();
                                              setState(() {
                                                removeListElement(
                                                    itemRow.ItemSlNo,
                                                    itemRow.id,
                                                    itemRow.AmtWithTax);
                                              });
                                            },
                                          ),
                                          TextButton(
                                              child: Text("No"),
                                              onPressed: () {
                                                // Navigator.pop(context,false);
                                                Navigator.of(context,
                                                    rootNavigator:
                                                    true)
                                                    .pop();
                                              })
                                        ]));
                              },),
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







          //-----------------bottomNavigationBar -----Save And Pay buttons------------------------
          bottomNavigationBar: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, bottom: 2, top: 5),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue, // background color
                    ),
                    onPressed: () {
                      print("zzzz");
                      Validation();
                    },
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            ButtonName,
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, bottom: 5, right: 5, top: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: TextFormField(
                      controller: MO_TotalAmtController,
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

        ));
  }





  ///----------------------print part-----------------------

  //----------printing ticket generate--------------------------
  PrinterNetworkManager _printerManager = PrinterNetworkManager();
  Future<Ticket> _ticket(PaperSize paper) async {
    print('in print Ticket');
    final ticket = Ticket(paper);
    List<dynamic> DetailPart = dataForTicket["sodetailed"] as List;

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
      total = DetailPart[i]["amountIncludingTax"] + total;
      //ticket.emptyLines(1);
      snlnum=snlnum+1;
      ticket.row([
        PosColumn(text: (snlnum.toString()),width: 1,styles: PosStyles(
            fontType: PosFontType.fontB,align: PosAlign.left
        )),

        PosColumn(text: (DetailPart[i]["itemName"]),
            width: 3,styles:
            PosStyles( fontType: PosFontType.fontB,align: PosAlign.left )),


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
      ch: '_',);

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

    var   barData=[0,0,0,0,0,0,0];
    print("barData");
    print(barData);
    ticket.barcode(Barcode.code39(barData),);


    ticket.feed(1);
    ticket.text('Thank You...Visit again !!',
        styles: PosStyles(align: PosAlign.center, bold: true));
    print("Finish");
    ticket.cut();
    return ticket;
  }
  //..................................................
  wifiprinting(printerName) async {
    try {

      print("in print in 123");
      print(printerName);

      _printerManager.selectPrinter(printerName);

      // _printerManager.selectPrinter('192.168.0.100');

      final res =
      await _printerManager.printTicket(await _ticket(PaperSize.mm80));
      print("out print in");
    } catch (e) {
      print("error on print $e");
    }
  }

//----------------------Print part End-----------------------------------------

}













class Rms_MakeOrder_Details {
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
  dynamic poid;


  Rms_MakeOrder_Details(
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
        this.poid
      });

  Rms_MakeOrder_Details.fromJson(Map<String, dynamic> json) {
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
    poid = json['poid'];
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
    data['poid'] = this.poid;
    return data;
  }
}