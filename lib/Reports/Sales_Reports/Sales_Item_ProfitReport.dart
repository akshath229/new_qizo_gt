import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../GT_Masters/AppTheam.dart';
import '../../GT_Masters/Masters_UI/cuWidgets.dart';
import '../../GT_Masters/Printing/Dynamic_PDF_Print.dart';
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
class Sales_Item_Profit_Report extends StatefulWidget {

  @override
  _Sales_Item_Profit_Report createState() => _Sales_Item_Profit_Report();
}

class _Sales_Item_Profit_Report extends State<Sales_Item_Profit_Report>
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
  var Sales_Item_Profit_Report_Data=[];
  var Item_Id=null;

  TextEditingController DateFromController = new TextEditingController();
  TextEditingController DateToController = new TextEditingController();
  TextEditingController goodsController = new TextEditingController();



  AppTheam theam = AppTheam();
  CUWidgets cw=CUWidgets();
  static List<FinishedGoods> goods =[];




  getItemIndex(dynamic item) {
    var index = Sales_Item_Profit_Report_Data.indexOf(item);
    return index + 1;
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

  var Table_Heading=[];

  GetSales_Item_Profit_Report()async{
    Table_Heading=[];
    var parm={
      "dateFrom":DateFromController.text,
      "dateTo":DateToController.text,
      "itemId":Item_Id??0
    };



    var jsonParse=json.encode(parm);
    print(jsonParse);
    try {
      final res =await cw.post(api:"GtStock/3",Token:token,body:jsonParse,deviceId:user.deviceId);
      print(res);
      if(res!=false) {
        setState(() {
          print(res);
          var c = json.decode(res);
          Sales_Item_Profit_Report_Data=c["details"]["data"];



          Sales_Item_Profit_Report_Data[0].keys.forEach((key){
            print(key);
            Table_Heading.add(key);
          });
        });
      }
      else{
        setState(() {
          Sales_Item_Profit_Report_Data.clear();
        });
      }
    } catch (e) {
      print("error on $e");
    }

  }



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


  Clear(){

    setState(() {
      Sales_Item_Profit_Report_Data=[];
      DateFromController.text = date;
      DateToController.text = date;
      goodsController.text="";
      Item_Id=null;
    });

  }


  void initState() {
    SharedPreferences.getInstance().then((value) {
      pref = value;
      read();
      DateFromController.text=date;
      DateToController.text=date;
      getFinishedGoods();
    });
    super.initState();
  }

  Future<bool> _onBackPressed() {
    Navigator.pop(context);
    return Future.value(true);
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
            child:  Appbarcustomwidget(uname: userName, branch: branchName, pref: pref, title:"Item Profit Report")
        ),
        body: ListView(children: <Widget>[


          SizedBox(
            height: 10,
          ),

          Row(
            children: [
              SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  style: TextStyle(fontSize: 15),
                  showCursor: true,
                  controller: DateFromController,
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
                        firstDate:DateTime(1900),// now.subtract(Duration(days: 1)),
                        lastDate: DateTime(2080),
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData.light(),
                            child: child!,
                          );
                        });

                    // if (date != null) {
                    //   print(date);
                    //   if (date.day < DateTime.now().day) {
                    //     print("invalid date select");
                    //
                    //     DateFromController.text = "";
                    //     return;
                    //   } else {
                    var d = DateFormat("yyyy-MM-d").format(date!);
                    DateFromController.text = d;
                    //   }
                    // }
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
                    hintText: "From Date:dd/mm/yy",
                    hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                    labelText: "From Date",
                  ),
                ),
              ),

              SizedBox(width: 10),
            ],
          ),

          SizedBox(
            height: 10,
          ),

          Row(
            children: [
              SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  style: TextStyle(fontSize: 15),
                  showCursor: true,
                  controller: DateToController,
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
                        firstDate:DateTime(1999),// now.subtract(Duration(days: 1)),
                        lastDate: DateTime(2080),
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData.light(),
                            child: child!,
                          );
                        });

                    // if (date != null) {
                    //   print(date);
                    //   if (date.day < DateTime.now().day) {
                    //     print("invalid date select");
                    //
                    //     DateToController.text = "";
                    //     return;
                    //   } else {
                    var d = DateFormat("yyyy-MM-d").format(date!);
                    DateToController.text = d;
                    //   }
                    // }
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
                    hintText: "Date To:dd/mm/yy",
                    hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                    labelText: "Date To",
                  ),
                ),
              ),

              SizedBox(width: 10),
            ],
          ),

          SizedBox(
            height: 10,
          ),

          Row(
            children: [
              SizedBox(width: 10),
              Expanded(
                  child: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                          style: TextStyle(),
                          controller: goodsController,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(color: Colors.red),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.remove_circle),
                              color: Colors.blue,
                              onPressed: () {
                                setState(() {
                                  print("cleared");
                                  goodsController.text = "";
                                  Item_Id = null;

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
                        print(Item_Id);
                        print("...........");
                        setState(() {
                          goodsController.text=suggestion.itmName;
                          Item_Id=suggestion.id;
                        });

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

              SizedBox(width: 10),
            ],
          ),



          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green.shade700)),
                      onPressed: (){
                        GetSales_Item_Profit_Report();
                      }, child:Text("Show",style: TextStyle(fontSize: 25))),
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
                    visible:Sales_Item_Profit_Report_Data.length>0 ,
                    child:IconButton(icon: Icon(Icons.print), onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Dynamic_Pdf_Print(
                                Parm_Id: 29,
                                Details_Data: Sales_Item_Profit_Report_Data,
                                title:"SALES ITEM PROFIT REPORT" ,

                              )));
                    }))

              ],
            ),
          ),




// ----------------------table------------------

          Container(
            child: Sales_Item_Profit_Report_Data.length > 0
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
                              columns:Table_Heading.map<DataColumn>((e) {
                                var columnName = e;
                                return DataColumn(
                                    label: Text(columnName));
                              }).toList(),
                              //       :
                              // DataColumn(
                              //     label: Text("columnName")),



                              rows:Sales_Item_Profit_Report_Data.map((e) {
                                return DataRow(
                                  cells:Table_Heading.map((headingdata) {
                                    String jsonTex =headingdata;
                                    return DataCell(
                                        Container(
                                            alignment:e["$jsonTex"].toString().contains(".")?Alignment.centerRight:Alignment.centerLeft,
                                            child: Text(e["$jsonTex"].toString()==null?"--":e["$jsonTex"].toString()))
                                    );
                                  }).toList(),
                                );
                              }).toList(),


                            )))),

                // Expanded(
                //     child: SingleChildScrollView(
                //       scrollDirection: Axis.horizontal,
                //       child: SingleChildScrollView(
                //         scrollDirection: Axis.vertical,
                //         child: DataTable(
                //           columnSpacing: 17,
                //           onSelectAll: (b) {},
                //           sortAscending: true,
                //           columns: <DataColumn>[
                //             DataColumn(
                //               label: Text('#'),
                //             ),
                //             DataColumn(
                //               label: Text('Invoice No'),
                //             ),
                //             DataColumn(
                //               label: Text('Date'),
                //             ),
                //             DataColumn(
                //               label: Text('Customer'),
                //             ),
                //             DataColumn(
                //               label: Text('GstNo'),
                //             ),
                //           ],
                //           rows: Sales_Item_Profit_Report_Data
                //               .map(
                //                 (itemRow) => DataRow(
                //               cells: [
                //                 DataCell(
                //                   Text(getItemIndex(itemRow)
                //                       .toString()),
                //                   showEditIcon: false,
                //                   placeholder: false,
                //                 ),
                //                 DataCell(
                //                   Text(
                //                       itemRow['Invoice No'].toString()),
                //                   showEditIcon: false,
                //                   placeholder: false,
                //                 ),
                //                 DataCell(
                //                   Text(itemRow['Date']
                //                       .toString()),
                //                   showEditIcon: false,
                //                   placeholder: false,
                //                 ),
                //
                //                 DataCell(
                //                   Container(
                //                     alignment:
                //                     Alignment.centerLeft,
                //                     child: Text(
                //                         itemRow['Customer'].toString()),
                //                   ),
                //                   showEditIcon: false,
                //                   placeholder: false,
                //                 ),
                //                 DataCell(
                //                   Container(
                //                     alignment:
                //                     Alignment.centerLeft,
                //                     child: Text(
                //                         itemRow['GstNo'].toString()),
                //                   ),
                //                   showEditIcon: false,
                //                   placeholder: false,
                //                 ),
                //               ],
                //             ),
                //           )
                //               .toList(),
                //         ),
                //       ),
                //     )),
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





class Payment_Type {
  Payment_Type({
    required this.id,
    required this.paymentType,
    required this.isActive,

  });

  int id;
  String paymentType;
  bool isActive;


  factory Payment_Type.fromJson(Map<String, dynamic> json) => Payment_Type(
    id: json["id"],
    paymentType: json["paymentType"],
    isActive: json["isActive"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "paymentType": paymentType,
    "isActive": isActive,
  };
}


