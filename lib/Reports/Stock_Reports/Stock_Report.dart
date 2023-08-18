





import 'dart:convert';
import 'dart:ui';



import 'package:flutter/material.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../GT_Masters/AppTheam.dart';
import '../../GT_Masters/Masters_UI/cuWidgets.dart';
import '../../GT_Masters/Printing/Dynamic_PDF_Print.dart';
import '../../Local_Db/Local_db_Model/Test_offline_Sales.dart'as offline;
import '../../appbarWidget.dart';
import '../../models/finishedgoods.dart';
import '../../models/userdata.dart';
import '../../receiptcollection.dart';
import '../../sales.dart';
import '../../salesmanhome.dart';
import '../../salesorder.dart';
import '../../salesreturn.dart';
import '../../shopvisited.dart';
import '../../urlEnvironment/urlEnvironment.dart';
// ledger balance page
class Stock_Report extends StatefulWidget {

  @override
  _Stock_Report createState() => _Stock_Report();
}

class _Stock_Report extends State<Stock_Report>
    with SingleTickerProviderStateMixin {
  late String branchName;
  late SharedPreferences pref;
  dynamic user;
  late String token;
  dynamic userName;
  dynamic dateFrom;
  dynamic dateTO = DateTime.now();
  late int salesLedgerId;
  dynamic custValue;
  bool deliveryDateSelect = false;
  dynamic serverDate;


  double TextBoxCurve=10;
  String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
var GdwnId=null;
var ItemId=null;
var ItemTypId=2;


var StockData=[];
var ItemwiseTransaction=[];
  static List<Godown> Gdwn = [];
  static List<FinishedGoods> goods = [];




  TextEditingController GodownController = new TextEditingController();
  TextEditingController DateController = new TextEditingController();
  TextEditingController goodsController = new TextEditingController();
  TextEditingController ItemTypeController = new TextEditingController();

  AppTheam theam = AppTheam();
  CUWidgets cw=CUWidgets();


  String dropdownvalue = 'Apple';
  List<dynamic> items =  [
    {'typeId':1,'Name':'Spare',},
    {'typeId':2,'Name':'Finished',}
  ];




  getItemIndex(dynamic item) {
    var index = StockData.indexOf(item);
    return index + 1;
  }

  void initState() {
    SharedPreferences.getInstance().then((value) {
      pref = value;
      read();
      DateController.text=date;
      GetGodown();
      getFinishedGoods();
      ItemTypeController.text="Finished";
      ItemTypId=2;
      //  getStock();
    });
    super.initState();
  }



  CheckVAlidation(){
    setState(() {
      StockData.clear();
    });

    print("ItemId");
    print(ItemId.toString());
ItemId==null?getStock():getStockWithItem();
  }


  //  get Token
  read() async {
    print("pass data");

    var v = pref.getString("userData");
    print("USER DATA: $v");
    var c = json.decode(v!);

    user = UserData.fromJson(c); // token gets this code user.user["token"]

    setState(() {
      print("user data................");
      print(user.user["token"]);
      token = user.user["token"]; //  passes this user.user["token"]
      pref.setString("customerToken", user.user["token"]);
      branchName = user.branchName;
      userName = user.user["userName"];
      print(".....");
      print(branchName);
      print(userName);
    });
  }


  GetGodown()async{
    String url = "${Env.baseUrl}Mgodowns";
    try {
      final res =
      await http.get(url as Uri, headers: {"Authorization": user.user["token"]});
      if(res.statusCode==200) {
        List <dynamic> tagsJson = json.decode(res.body)['mGodown'];
        List<Godown> gd = tagsJson.map((tagsJson) =>
            Godown.fromJson(tagsJson)).toList();
        print("Godwon : $gd");
        Gdwn = gd;
          // GodownController.text =tagsJson[0]["gdnDescription"];
          // print(tagsJson[0]["gdnDetagsJsonscription"].toString());

      }
    } catch (e) {
      print("error on  unit= $e");
    }

  }


  getStock() async {
print("uikuyo");
var date=DateController.text;
    try {

      var parsData={

          "crntStatus": ItemTypId,
          "dateFrom":  date,
          "godownId": GdwnId??0
      };
var jsonParse=json.encode(parsData);
      print(jsonParse);
      var jsonres = await cw.post(api:"GTStock/1", Token: token,body:jsonParse);
      if (jsonres != false) {
        var res = jsonDecode(jsonres);
       //  print("ItemList = $res");
        setState(() {
          StockData=res["details"]["data"];
         print(StockData);
         print(StockData.length.toString());
        });
// return usersFiltered;
      }
    } catch (e) {
      print("error" + e.toString());
    }

  }


  getStockWithItem() async {
    print("getStockWithItem");
    var date=DateController.text;
    try {

      var parsData={

        "crntStatus": ItemTypId,
        "dateFrom":  date,
        "godownId": GdwnId??0,
        "itemid":ItemId
      };
      var jsonParse=json.encode(parsData);
      var jsonres = await cw.post(api:"GTStock/$ItemId/2", Token: token,body:jsonParse);
print(jsonParse.toString());
      if (jsonres != false) {
        var res = jsonDecode(jsonres);
        //  print("ItemList = $res");
        setState(() {
          StockData=res["details"]["data"];
          print(StockData);
          print(StockData.length.toString());
        });
// return usersFiltered;
      }
    } catch (e) {
      print("error" + e.toString());
    }

  }

  // get item.................
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

  Future<bool> _onBackPressed() {
    Navigator.pop(context);
    return Future.value(true);
  }


  Clear(){

  setState(() {
     GodownController.text="";
     goodsController.text="";
     ItemTypeController.text="Finished";
      GdwnId=null;
      ItemId=null;
      ItemTypId=2;
     StockData.clear();
  });

  }







var ItemTransactionTable_Heading=[];
  GetItemTransactionReport(id,name)async{
    print("GetItemTransactionReport");
    var date=DateController.text;
    var Keys=[];
    try {

      var parsData={

        "crntStatus": ItemTypId,
        "dateFrom":  date,
        "godownId": GdwnId??0,
        "itemId":id
      };
      var jsonParse=json.encode(parsData);
      var jsonres = await cw.post(api:"GTStock/2", Token: token,body:jsonParse);

      if (jsonres != false) {
        var res = jsonDecode(jsonres);
        //  print("ItemList = $res");
        setState(() {
          ItemTransactionTable_Heading=[];
          ItemwiseTransaction=res["details"]["data"];
          print(ItemwiseTransaction);
          print(ItemwiseTransaction.length.toString());
          ItemwiseTransaction[0].keys.forEach((key){
            print(key);
             Keys.add(key);
            return key;
          });
         Keys.remove("Id");
         print(Keys);
          ItemTransactionTable_Heading=Keys;
          ShowItemTransaction(name);
        });
// return usersFiltered;
      }
    } catch (e) {
      print("error" + e.toString());
    }

  }





  ShowItemTransaction(itemname){

    var TotalStock_in=0.0;
    var TotalStock_out=0.0;
    var Current_Stock=0.0;

    for(int i=0;i<ItemwiseTransaction.length;i++){

      TotalStock_in=TotalStock_in+ItemwiseTransaction[i]["Stk.IN"];
      TotalStock_out=TotalStock_out+ItemwiseTransaction[i]["Stk.Out"];

    }
    Current_Stock=TotalStock_in-TotalStock_out;
    showDialog(
        context: context,
        builder: (context) =>   AlertDialog(
        shape:RoundedRectangleBorder(
        side: BorderSide(color:  Colors.teal, width: 1),
    borderRadius: BorderRadius.circular(20),
    ),
title:Row(
  children: [
    Expanded(child: Text("Item wise Transaction Report ($itemname)")),
    IconButton(icon: Icon(Icons.close,color: Colors.red,), onPressed:(){
      Navigator.of(context,rootNavigator: true).pop();
    }),
  ],
),
    //  content: Itm_Slct_All_Popup(data: Itemdata,),
    actions: [

        Container(
          height:MediaQuery.of(context).size.height/2,
          width:MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
                child: DataTable(
                columnSpacing: 17,
                onSelectAll: (b) {},
                sortAscending: true,
                columns:ItemTransactionTable_Heading.map<DataColumn>((e) {
                  var columnName = e;
                  return DataColumn(
                      label: Text(columnName));
                }).toList(),

                rows:ItemwiseTransaction.map((e) {
                  return DataRow(
                    cells:ItemTransactionTable_Heading.map((headingdata) {
                      String jsonTex =headingdata;
                      return DataCell(
                          Text(e["$jsonTex"].toString()==null?"--":e["$jsonTex"].toString())
                      );
                    }).toList(),
                  );
                }).toList(),


          ),
              ),
            ),
        ),

    SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        height: 35,
        width:MediaQuery.of(context).size.width,
        child: Row(children: [
       SizedBox(width: 5,),
          Text("Stk In: "),
          Text(TotalStock_in.toString()+"      ", style: TextStyle(fontWeight: FontWeight.bold),),


          Text("Stk Out : "),
          Text(TotalStock_out.toString()+"      ", style: TextStyle(fontWeight: FontWeight.bold),),


          Text("Current Stk : "),
          Text(Current_Stock.toString(), style: TextStyle(fontWeight: FontWeight.bold),),
          SizedBox(width: 5,),
        ],),
      ),
    )

    ]));


  }





  // -------------------------All functions End------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
//    key: scaffoldKey,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(190.0),
            child:  Appbarcustomwidget(uname: userName, branch: branchName, pref: pref, title:"Stock Report")
        ),
        body: ListView(children: <Widget>[


          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [

                Expanded(
                    child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                            style: TextStyle(),
                            controller: GodownController,
                            decoration: InputDecoration(
                              errorStyle: TextStyle(color: Colors.red),

//                            errorText: _validateName ? "please enter name" : null,
//                            errorBorder:InputBorder.none ,
                              suffixIcon: IconButton(
                                icon: Icon(Icons.remove_circle),
                                color: Colors.blue,
                                onPressed: () {
                                  setState(() {
                                    print("cleared");
                                    GodownController.text = "";
                                    GdwnId = null;
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
                          GodownController.text = suggestion.gdnDescription;
                          GdwnId=suggestion.gdnId;

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
                ),

                Expanded(
                    child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                            style: TextStyle(),
                            controller: goodsController,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(Icons.remove_circle),
                                color: Colors.blue,
                                onPressed: () {
                                  setState(() {
                                    print("cleared");
                                    goodsController.text = "";
                                    ItemId=null;
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
                          print(ItemId);
                          print("....ItemId.......");
                          goodsController.text =suggestion.itmName;
                          ItemId=suggestion.id;
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


              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 8,bottom: 8,right: 8),
            child: Row(
              children: [

                Expanded(
                  child: TextFormField(
                    style: TextStyle(fontSize: 15),
                    showCursor: true,
                    controller: DateController,
                    enabled: true,
                    validator: (v) {
                      if (v!.isEmpty) return "Required";
                      return null;
                    },
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

                          DateController.text = "";
                          return;
                        } else {
                          var d = DateFormat("yyyy-MM-d").format(date);
                          DateController.text = d;
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
                      hintText: "Date:dd/mm/yy",
                      hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                      labelText: "Date",
                    ),
                  ),
                ),


                SizedBox(
                  width: 10,
                ),



                Expanded(
                    child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                            style: TextStyle(),
                            controller: ItemTypeController,
                            decoration: InputDecoration(
                              errorStyle: TextStyle(color: Colors.red),

//                            errorText: _validateName ? "please enter name" : null,
//                            errorBorder:InputBorder.none ,
                              suffixIcon: IconButton(
                                icon: Icon(Icons.remove_circle),
                                color: Colors.blue,
                                onPressed: () {
                                  setState(() {
                                    print("cleared");
                                    ItemTypeController.text = "";
                                    ItemTypId!=null;
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
                              'Item Type', // i need to decrease height
                            )),
                        suggestionsBoxDecoration:
                        SuggestionsBoxDecoration(elevation: 90.0),
                        suggestionsCallback: (pattern) {
                          return items.where((gwn) =>
                              gwn["Name"].toUpperCase().contains(pattern.toUpperCase()));
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
                                suggestion["Name"],
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          print(suggestion["Name"]);
                          print("selected");
                          print(suggestion["Name"]);
                          ItemTypeController.text = suggestion["Name"];
                          ItemTypId=suggestion["id"];

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




              ],
            ),
          ),


          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green.shade700)),
                      onPressed: () {
                        CheckVAlidation();
                      },
                      child: Text("Show",
                      style: TextStyle(fontSize: 25),)),
                ),

                SizedBox(width: 5,),

                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.indigo)),
                      onPressed: () {
                       Clear();
                      },
                      child: Text("Clear",
                        style: TextStyle(fontSize: 25),)),
                ),

                Visibility(
                  visible:StockData.length>0 ,
                    child:IconButton(icon: Icon(Icons.print), onPressed: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Dynamic_Pdf_Print(
                                        Parm_Id: 29,
                                        Details_Data: StockData,
                                        title:"STOCK REPORT" ,

                                      )));
                        }))
              ],
            ),
          ),

// ----------------------table------------------

         Container(
            child: StockData.length > 0
                ? Row(
//            verticalDirection: VerticalDirection.down,
//            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          columnSpacing: 17,
                          onSelectAll: (b) {},
                          sortAscending: true,
                          columns: <DataColumn>[
                            DataColumn(
                              label: Text('#'),
                            ),
                            DataColumn(
                              label: Text('Item Name'),
                            ),
                            DataColumn(
                              label: Text('Barcode'),
                            ),
                            DataColumn(
                              label: Text('Unit'),
                            ),
                            DataColumn(
                              label: Text('Qty'),
                            ),
                            DataColumn(
                              label: Text('P.Rate'),
                            ),
                            DataColumn(
                              label: Text('Total'),
                            ),
                            DataColumn(
                              label: Text('P.Tax'),
                            ),
                            DataColumn(
                              label: Text('Amt With Tax'),
                            ),
                            DataColumn(
                              label: Text('S.Rate'),
                            ),
                            DataColumn(
                              label: Text('MRP'),
                            ),
                          ],
                          rows: StockData
                              .map(
                                (itemRow) => DataRow(
                              cells: [
                                DataCell(
                                  Text(getItemIndex(itemRow)
                                      .toString()),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  InkWell(
                                    onTap: (){
                                      print(itemRow['Id'].toString());
                                      GetItemTransactionReport(itemRow['Id'],itemRow['Item Name']);
                                    },
                                    child: Text(
                                        itemRow['Item Name'].toString(), style: TextStyle(
                                      color: Colors.indigo
                                    ),),
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(itemRow['Barcode']
                                      .toString()),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),

                                DataCell(
                                  Container(
                                    alignment:
                                    Alignment.centerRight,
                                    child: Text(
                                        itemRow['Unit'].toString()),
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Container(
                                    alignment:
                                    Alignment.centerRight,
                                    child: Text(
                                        itemRow['Qty'].toStringAsFixed(2)),
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),


                                DataCell(
                                  Container(
                                    alignment:
                                    Alignment.centerRight,
                                    child: Text(
                                        itemRow['P.Rate'].toStringAsFixed(3)),
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Container(
                                    alignment:
                                    Alignment.centerRight,
                                    child: Text(
                                        ((itemRow['P.Rate']??0.0)*(itemRow['Qty']??0.0)).toStringAsFixed(3)),
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),

                                DataCell(
                                  Container(
                                    alignment:
                                    Alignment.centerRight,
                                    child: Text(
                                        itemRow['PTax'].toStringAsFixed(3)),
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),



                                DataCell(
                                  Container(
                                    alignment:
                                    Alignment.centerRight,
                                    child: Text(
                                        (
                                            ((itemRow['P.Rate']??0.0)*(itemRow['Qty']??0.0))+
                                            (((itemRow['P.Rate']??0.0)/100)*(itemRow['PTax']??0.0))*(itemRow['Qty']??0.0)
                                        )
                                            .toStringAsFixed(3)),
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),


                                DataCell(
                                  Container(
                                    alignment:
                                    Alignment.centerRight,
                                    child: Text(
                                        itemRow['S.Rate'].toStringAsFixed(3)),
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),


                                DataCell(
                                  Container(
                                    alignment:
                                    Alignment.centerRight,
                                    child: Text(
                                        itemRow['MRP'].toStringAsFixed(3)),
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                              ],
                            ),
                          )
                              .toList(),
                        ),
                      ),
                    )),
                SizedBox(
                  width: 10,
                )
              ],
            )
                : Container(
              height: 400,
              child: Center(child: Text("No Data Found")),
            ),
          ),

          WillPopScope(
            onWillPop: _onBackPressed,
            child: Text(""),
          ),

//---------------------------------------------------------
//-------------------------table ead------------------
        ]),







        bottomSheet: Padding(
          padding: const EdgeInsets.only(left: 15,bottom: 15),
          child: FloatingActionButton(

              backgroundColor: Colors.blue,
              hoverColor: Colors.red,  elevation: 5,

              child: Icon(Icons.home_filled),


              onPressed: (){
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder:(context) =>
                        SalesManHome()), (route) => false);
              }),

        ),

        floatingActionButton:SpeedDial(
          animatedIcon:AnimatedIcons.menu_arrow,overlayColor: Colors.blue,
          children: [

            SpeedDialChild(
                child: Icon(Icons.add_shopping_cart_sharp),
                backgroundColor: Colors.blue,
                label: "Sales",
                onTap:(){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>Newsalespage(passvalue:salesLedgerId,passname:custValue.toString(),)));
                } ),

            SpeedDialChild(
                child: Icon(Icons.remove_shopping_cart_rounded),
                backgroundColor: Colors.blue,
                label: "Sales Return",
                onTap:(){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SalesReturn(passvalue:salesLedgerId,passname:custValue.toString(),)));
                } ),



            SpeedDialChild(
                child: Icon(Icons.description_outlined),
                backgroundColor: Colors.blue,
                label: "Receipt Collection",
                onTap:(){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>ReceiptCollections(passvalue:salesLedgerId.hashCode,passname:custValue.toString(),)));
                } ),

            SpeedDialChild(
                child: Icon(Icons.shopping_cart),
                backgroundColor: Colors.blue,
                label: "Sales Order",
                onTap:(){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>SalesOrder(passvalue:salesLedgerId,passname: custValue.toString(),)));
                } ),

            SpeedDialChild(
                child: Icon(Icons.remove_red_eye_outlined),
                backgroundColor: Colors.blue,
                label: "Shop Visited",
                onTap:(){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => shopvisited(passvalue:salesLedgerId,passname:custValue.toString(),)));
                } ),

          ],
        ),
      ),


    );
  }
}


