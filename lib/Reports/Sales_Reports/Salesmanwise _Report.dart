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
import '../../models/userdata.dart';
import '../../receiptcollection.dart';
import '../../sales.dart';
import '../../salesmanhome.dart';
import '../../salesorder.dart';
import '../../salesreturn.dart';
import '../../shopvisited.dart';
// ledger balance page
class Salesmanwise_Report extends StatefulWidget {

  @override
  _Salesmanwise_Report createState() => _Salesmanwise_Report();
}

class _Salesmanwise_Report extends State<Salesmanwise_Report>
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
  var Salesmanwise_Report_Data=[];


  TextEditingController DateFromController = new TextEditingController();
  TextEditingController DateToController = new TextEditingController();

  AppTheam theam = AppTheam();
  CUWidgets cw=CUWidgets();

  getItemIndex(dynamic item) {
    var index = Salesmanwise_Report_Data.indexOf(item);
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



  GetPurchaseRpt()async{
    var parm={
      "dateFrom":DateFromController.text,
      "dateTo":DateToController.text,
      "trnHeadId":0
    };



    var jsonParse=json.encode(parm);
    print(jsonParse);
    try {
      final res =await cw.post(api:"GtSales/5",Token:token,body:jsonParse,deviceId:user.deviceId);
      print(res);
      if(res!=false) {
        setState(() {
          print(res);
          var c = json.decode(res);
          Salesmanwise_Report_Data=c["details"]["data"];
        });

      }
      else{
        setState(() {
          Salesmanwise_Report_Data.clear();
        });
      }
    } catch (e) {
      print("error on $e");
    }

  }


  Clear(){

    setState(() {
      Salesmanwise_Report_Data=[];
      DateFromController.text = date;
      DateToController.text = date;
    });

  }


  void initState() {
    SharedPreferences.getInstance().then((value) {
      pref = value;
      read();
      DateFromController.text=date;
      DateToController.text=date;
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
            child:  Appbarcustomwidget(uname: userName, branch: branchName, pref: pref, title:"Salesmanwise Report")
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



          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green.shade700)),
                      onPressed: (){
                        GetPurchaseRpt();
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
                    visible:Salesmanwise_Report_Data.length>0 ,
                    child:IconButton(icon: Icon(Icons.print), onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Dynamic_Pdf_Print(
                                Parm_Id: 29,
                                Details_Data: Salesmanwise_Report_Data,
                                title:"SALESMANWISE REPORT" ,

                              )));
                    }))


              ],
            ),
          ),




// ----------------------table------------------

          Container(
            child: Salesmanwise_Report_Data.length > 0
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
                              label: Text('Invoice No'),
                            ),
                            DataColumn(
                              label: Text('Date'),
                            ),
                            DataColumn(
                              label: Text('Customer'),
                            ),
                            DataColumn(
                              label: Text('GstNo'),
                            ),
                          ],
                          rows: Salesmanwise_Report_Data
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
                                  Text(
                                      itemRow['Invoice No'].toString()),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(itemRow['Date']
                                      .toString()),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),

                                DataCell(
                                  Container(
                                    alignment:
                                    Alignment.centerLeft,
                                    child: Text(
                                        itemRow['Customer'].toString()),
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Container(
                                    alignment:
                                    Alignment.centerLeft,
                                    child: Text(
                                        itemRow['GstNo'].toString()),
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


