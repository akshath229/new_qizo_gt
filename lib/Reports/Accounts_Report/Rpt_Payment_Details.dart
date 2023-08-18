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
class Payment_Details_Report extends StatefulWidget {

  @override
  _Payment_Details_Report createState() => _Payment_Details_Report();
}

class _Payment_Details_Report extends State<Payment_Details_Report>
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
  var showCancel_Id=null;
  var StockData=[];
  var showCancel_Typ=[
    {"id":0,"name":"All"},
    {"id":1,"name":"Cancelled"},
    {"id":2,"name":"Not Cancelled"}];


  TextEditingController PaymentTypController = new TextEditingController();
  TextEditingController DateFromController = new TextEditingController();
  TextEditingController DateToController = new TextEditingController();

  AppTheam theam = AppTheam();
  CUWidgets cw=CUWidgets();

  getItemIndex(dynamic item) {
    var index = StockData.indexOf(item);
    return index + 1;
  }
  void initState() {
    SharedPreferences.getInstance().then((value) {
      pref = value;
      read();
      DateFromController.text=date;
      DateToController.text=date;

      //  getStock();
    });
    super.initState();
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



  GetSalesRpt()async{
    var parm={
      "dateFrom":DateFromController.text,
      "dateTo":DateToController.text,
      "ledgerId": 0,
      "showCancel":showCancel_Id??0,
    };
    print(parm);
    var jsonParse=json.encode(parm);

    try {
      final res =await cw.post(api:"Payment",body: jsonParse,Token: token);
      if(res!=false) {
        setState(() {
          print(res);
          var c = json.decode(res);
          StockData=c["details"]["data"];
        });

      }
      else{
        setState(() {
          StockData.clear();
        });
      }
    } catch (e) {
      print("error on  unit= $e");
    }

  }









  Clear(){

    setState(() {
      showCancel_Id=null;
      StockData=[];

      PaymentTypController.text = "";
      DateFromController.text=date;
      DateToController.text=date;
    });
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
            child:  Appbarcustomwidget(uname: userName, branch: branchName, pref: pref, title:"Payment Details")
        ),
        body: ListView(children: <Widget>[

          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(width: 10),
              Expanded(
                  child: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                          style: TextStyle(),
                          controller: PaymentTypController,
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
                                  PaymentTypController.text = "";
                                  showCancel_Id = null;
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
                            'Select', // i need to decrease height
                          )),
                      suggestionsBoxDecoration:
                      SuggestionsBoxDecoration(elevation: 90.0),
                      suggestionsCallback: (pattern) {
                        return showCancel_Typ.where((ptyp) =>
                            ptyp["name"].toString().toUpperCase().contains(pattern.toUpperCase()));
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
                              suggestion["name"] as String,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                      onSuggestionSelected: (suggestion) {
                        print(suggestion["name"]);
                        print("selected");
                        print(suggestion["id"]);
                        PaymentTypController.text = suggestion["name"] as String;
                        showCancel_Id=suggestion["id"];

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
              )
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
                        firstDate:DateTime(1900), //now.subtract(Duration(days: 1)),
                        lastDate: DateTime(2080),
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData.light(),
                            child: child!,
                          );
                        });

                    // if (date != null) {
                    //   print(date);
                    // if (date.day < DateTime.now().day) {
                    //   print("invalid date select");
                    //
                    //   DateToController.text = "";
                    //   return;
                    // } else {
                    var d = DateFormat("yyyy-MM-d").format(date!);
                    DateToController.text = d;
                  },
                  // }
                  // },
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
                        GetSalesRpt();
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
                    visible:StockData.length>0 ,
                    child:IconButton(icon: Icon(Icons.print), onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Dynamic_Pdf_Print(
                                Parm_Id: 29,
                                Details_Data: StockData,
                                title:"PAYMENT REPORT" ,

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
                              label: Text('Voucher'),
                            ),
                            DataColumn(
                              label: Text('Date'),
                            ),
                            DataColumn(
                              label: Text('Cash / Bank'),
                            ),
                            DataColumn(
                              label: Text('Amount'),
                            ),
                            DataColumn(
                              label: Text('Approved'),
                            ),
                            DataColumn(
                              label: Text('Apr.Date'),
                            ),
                            DataColumn(
                              label: Text('Posted'),
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
                                  Text(
                                      itemRow['Voucher'].toString()),
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
                                    Alignment.centerRight,
                                    child: Text(
                                        itemRow['Cash / Bank'].toString()),
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Container(
                                    alignment:
                                    Alignment.centerRight,
                                    child: Text(
                                        itemRow['Amount']==null?"0":itemRow['Amount'].toStringAsFixed(2)),
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),


                                DataCell(
                                  Container(
                                    alignment:
                                    Alignment.centerRight,
                                    child: Text(
                                        itemRow['Approved']??""),
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),



                                DataCell(
                                  Container(
                                    alignment:
                                    Alignment.centerRight,
                                    child: Text(
                                        itemRow['Apr.Date']),
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),


                                DataCell(
                                  Container(
                                    alignment:
                                    Alignment.centerRight,
                                    child: Text(
                                        itemRow['Posted']??""),
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



