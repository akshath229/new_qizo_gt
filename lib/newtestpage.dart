import 'dart:convert';

//-------------------------------------------Ledger Balance ----------------------------------

//import 'dart:html';
//import 'dart:html';

//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:new_qizo_gt/receiptcollection.dart';
import 'package:new_qizo_gt/sales.dart';
import 'package:new_qizo_gt/salesmanhome.dart';
import 'package:new_qizo_gt/salesorder.dart';
import 'package:new_qizo_gt/salesreturn.dart';
import 'package:new_qizo_gt/shopvisited.dart';
import 'package:new_qizo_gt/urlEnvironment/urlEnvironment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'GT_Masters/AppTheam.dart';
import 'appbarWidget.dart';
import 'documentmovementcreate.dart';
import 'models/customersearch.dart';
import 'models/userdata.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_typeahead/flutter_typeahead.dart';
// ledger balance page
class Newtestpage extends StatefulWidget {
  final passvalue;
  int Shid;

  Newtestpage({this.passvalue, required this.Shid});

  @override
  _NewtestpageState createState() => _NewtestpageState();
}

class _NewtestpageState extends State<Newtestpage>
    with SingleTickerProviderStateMixin {
  late String branchName;
  late SharedPreferences pref;
  dynamic user;
  late String token;
  dynamic userName;
  dynamic userArray;
  dynamic openingAmountBalance = 0.0;
  dynamic dateFrom;
  dynamic dateTO = DateTime.now();
  late int salesLedgerId;
  dynamic custValue;
  bool deliveryDateSelect = false;
  dynamic serverDate;
  List<dynamic> t = [];
  bool showProgress = true;

  String date = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());
  static List<Customer> users = [];

  TextEditingController customerController = new TextEditingController();
  TextEditingController DateControllerF = new TextEditingController();
  TextEditingController DateControllerT = new TextEditingController();

  FocusNode field1FocusNode = FocusNode(); //Create first FocusNode
  FocusNode field2FocusNode = FocusNode(); //Create first FocusNode

  bool customerSelect = false; // validation

AppTheam theam = AppTheam();

  void fub() {
    print("first data");
  }

  getItemIndex(dynamic item) {
    var index = t.indexOf(item);
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

  // get customer account
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
        print(response.statusCode);
        print(data["lst"]);
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
      print(response.statusCode);
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
      print("error" + e.toString());
    }
    savedata();
  }

  void initState() {
    // print (widget.passvalue+dateTO.toString());
    if (widget.passvalue != "null") {
      print("value= " + widget.passvalue);
      customerController.text = widget.passvalue;
      custValue  = widget.passvalue;
      // getLedger(widget.Shid,DateFormat("MM-dd-yyyy").format(dateTO));
    }
    print("else");

    DateControllerT.text = DateFormat("MM-dd-yyyy").format(dateTO);
    DateControllerF.text = DateFormat("MM-01-yyyy").format(dateTO);

    print("url: ${Env.baseUrl}");
    print("......");
    //  customerController.text = "";
    //   goodsController.text = "";
    SharedPreferences.getInstance().then((value) {
      pref = value;
      read();
      getCustomer();
      // getFinishedGoods();
      savedata();
    });
    super.initState();
    // customerController.addListener(customerLedgerIdListener);
    // goodsController.addListener(itemIdListener);
  }

  Widget buttonAdd() {
    return Container(
      child: FloatingActionButton(
        onPressed: () {},
        tooltip: "Add",
        child: Icon(Icons.add),
      ),
    );
  }

  //get customer ledger balance
  getCustomerLedgerBalance(int accountId) async {
    salesLedgerId = accountId;
    try {
      final response = await http.get("${Env.baseUrl}getsettings" as Uri,
          headers: {"accept": "application/json"});
      print(response.statusCode);

      if (response.statusCode == 200) {
        print('...................');

        print(response.body);

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
      print("Error getting users" + e.toString());
    }
    print("customer Id is");
    print(accountId);
  }

  savedata() async {
    dynamic passid = widget.Shid;

    dynamic dateFrom = DateControllerF.text.toString();
    dynamic dateTO = DateControllerT.text.toString();

    if (dateFrom == null || dateTO == null) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Please Select Customer!!"),
//           content: Text("user data:   " + user.user["token"]),
              ));
    }

    if (passid == null || salesLedgerId != null) {
      print("------1st if---pass id is null =" + passid.toString());

      print("org");
      //  var ndf = DateFormat("MM-d-yyyy").format(dateFrom);
      //  var ndt = DateFormat("MM-d-yyyy").format(dateTO);

      print("function in");
      print("sales Item Id$salesLedgerId");
      print("Date From =" + dateFrom.toString());
      print("Date To =" + dateTO.toString());

      final url = "${Env.baseUrl}LedgerStatment";
      print("url==$url");
      var req = {
        "ledgerId": salesLedgerId,
        "dateFrom": dateFrom,
        "dateTo": dateTO
      };
      print("req==  $req");
//        return;
      var params = json.encode(req);
      print("Json==  $params");
      var res = await http.post(url as Uri,
          headers: {
            'accept': 'application/json',
            'content-type': 'application/json',
            'Authorization': user.user["token"],
            'deviceId': user.deviceId
          },
          body: params);

      print(res.statusCode);
      if (res.statusCode == 200 || res.statusCode == 201 && salesLedgerId > 0) {
        print("ord data=" + res.body);
        var tagsJson = jsonDecode(res.body)['details']['data'];
        print("rsult1==$tagsJson");

        // dynamic data1=tagsJson["'Dr'"].toString();
        //  print("data1 = $data1");
        setState(() {
          t = tagsJson as List;
          t.forEach(print);
          print("tt= $t");

          showProgress = false;
        });
      } else {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Please Select Customer!!"),
//           content: Text("user data:   " + user.user["token"]),
                ));
      }
    } else {
      salesLedgerId = passid;
      //  var ndf = DateFormat("MM-d-yyyy").format(dateFrom);
      // var ndt = DateFormat("MM-d-yyyy").format(dateTO);

      print("function in");
      print("sales Item Id$salesLedgerId");
      print("Date From =" + dateFrom.toString());
      print("Date To =" + dateTO.toString());

      final url = "${Env.baseUrl}LedgerStatment";
      print("url==$url");
      var req = {
        "ledgerId": salesLedgerId,
        "dateFrom": dateFrom,
        "dateTo": dateTO
      };
      print("req==  $req");
//        return;
      var params = json.encode(req);
      print("Json==  $params");
      var res = await http.post(url as Uri,
          headers: {
            'accept': 'application/json',
            'content-type': 'application/json',
            'Authorization': user.user["token"],
            'deviceId': user.deviceId
          },
          body: params);

      print(res.statusCode);
      if (res.statusCode == 200 || res.statusCode == 201 && salesLedgerId > 0) {
        print("ord data=" + res.body);
        var tagsJson = jsonDecode(res.body)['details']['data'];
        print("rsult1==$tagsJson");

        setState(() {
          t = tagsJson as List;
          t.forEach(print);
          print("tt= $t");

          showProgress = false;
        });
      } else {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Please Select Customer!!"),
                ));
      }
    }
  }

  Future<bool> _onBackPressed() {
    Navigator.pop(context);

    // Assuming you want to prevent the default behavior after your logic
    return Future.value(false);
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
          child:  Appbarcustomwidget(uname: userName, branch: branchName, pref: pref, title:"Ledger Balance")
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
                                  salesLedgerId = 0;
                                  openingAmountBalance = 0;
                                });
                              },
                            ),

                            isDense: true,
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.0)),
                            // i need very low size height
                            labelText:
                                'customer search', // i need to decrease height
                          )),
                      suggestionsBoxDecoration:
                          SuggestionsBoxDecoration(elevation: 90.0),
                      suggestionsCallback: (pattern) {
                        return users.where((user) => user.lhName
                            .toUpperCase()
                            .contains(pattern.toUpperCase()));
                      },
                      itemBuilder: (context, suggestion) {
                        return Card(
                          color: theam.DropDownClr,
                          // shadowColor: Colors.blue,
                          child: ListTile(
                            // focusColor: Colors.blue,
                            // hoverColor: Colors.red,
                            title: Text(
                              suggestion.lhName,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        );
                      },
                      onSuggestionSelected: (suggestion) {
                        print(suggestion.lhName);
                        print("selected");

                        customerController.text = suggestion.lhName;
                        print("close.... $salesLedgerId");
                        salesLedgerId = 0;
                        custValue = suggestion.lhName;
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
                              ))),
              SizedBox(
                width: 10,
              )
            ],
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

          SizedBox(
            height: 10,
          ),

// -------------------------------------------
          Row(children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Flexible(
              child: TextFormField(
                style: TextStyle(fontSize: 15),
                showCursor: true,
                controller: DateControllerF,
                enabled: true,
                validator: (v) {
                  if (v!.isEmpty) return "Required";
                  return null;
                },
//
                // will disable paste operation
                focusNode: field1FocusNode,
                cursorColor: Colors.black,

                scrollPadding: EdgeInsets.fromLTRB(0, 5, 5, 0),
                keyboardType: TextInputType.datetime,
                readOnly: true,

                onTap: () async {
                  final DateTime now = DateTime.now();
                  DateTime? date = await showDatePicker(
                      context: context,
                      initialDatePickerMode: DatePickerMode.day,
                      initialDate: now,
                      firstDate: DateTime(1980),
                      lastDate: DateTime(2080),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light(),
                          child: child!,
                        );
                      });

                  if (date != null) {
                    print("Date=$date");
                    // if (date.day < DateTime.now().day) {
                    //   print("invalid date select");
                    //
                    //   DateControllerF.text = "";
                    //   return;
                    // } else {
                    dateFrom = date;
                    var d = DateFormat("MM-dd-yyyy").format(date);
                    DateControllerF.text = d;
                    savedata();
                    // }
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
                  contentPadding: EdgeInsets.fromLTRB(30.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.0)),
                  // curve brackets object
                  hintText: "From:",
                  hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                  labelText: "From",
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: TextFormField(
                style: TextStyle(fontSize: 15),
                showCursor: true,
                controller: DateControllerT,
                enabled: true,
                validator: (v) {
                  if (v!.isEmpty) return "Required";
                  return null;
                },
//
//
                // will disable paste operation
                focusNode: field2FocusNode,
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
                      firstDate: DateTime(1980),
                      lastDate: DateTime(2080),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light(),
                          child: child!,
                        );
                      });

                  if (date != null) {
                    print("Date TO=$date");
                    // if (date.day < DateTime.now().day) {
                    //   print("invalid date select");
                    //
                    //   DateControllerT.text = "";
                    //   return;
                    // } else {
                    dateTO = date;
                    var dt = DateFormat("MM-dd-yyyy").format(date);
                    DateControllerT.text = dt;
                    savedata();
                    // }
                  }
                },
                decoration: InputDecoration(
                  // errorStyle: TextStyle(color: Colors.red),
                  // errorText: deliveryDateSelect ? "invalid date " : null,
                  suffixIcon: Icon(
                    Icons.calendar_today,
                    color: Colors.blue,
                    size: 24,
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.fromLTRB(30.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.0)),
                  // curve brackets object
                  hintText: "To",
                  hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                  labelText: "To",
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ]),

          SizedBox(
            height: 10,
          ),

//
// Flexible(child: RaisedButton(
//
//     textColor: Colors.white,
//     color: Colors.lightBlueAccent,
//     child: Text("Ok"),
//     onPressed: savedata,
//     shape: new RoundedRectangleBorder(
//     borderRadius: new BorderRadius.circular(17.0),
//
//     ),
//     ),)
//
//    ] ),

          Row(children: [
            SizedBox(
              width: 40,
              height: 30,
            ),

            //  SizedBox(
            //     width:MediaQuery.of(context).size.width*(0.80),
            //  height:40 ,
            // child:
            //  RaisedButton(
            //  //  padding: EdgeInsets.(10),
            //    textColor: Colors.white,
            //    color: Colors.lightBlueAccent,
            //    child: Text("Show Leadger"),
            //    onPressed: savedata,
            //    padding: EdgeInsets.all(10),
            //    shape: new RoundedRectangleBorder(
            //      borderRadius: new BorderRadius.circular(14.0),
            //    )
            //    ),
            //  ),
          ]),

// ---------------------------------------------------------

// ----------------------table------------------

          showProgress
              ? Container(
                  height: 500,
                  width: 350,
                  child: Center(
                      //  child: CircularProgressIndicator(),
                      ),
                )
              : Container(
                  child: t.length > 0
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
                                      label: Text('Acc:Type'),
                                    ),
                                    DataColumn(
                                      label: Text('V:No'),
                                    ),
                                    DataColumn(
                                      label: Text('Dr'),
                                    ),
                                    DataColumn(
                                      label: Text('Cr'),
                                    ),
                                    // DataColumn(
                                    //   label: Text('Move'),
                                    // ),
                                    // DataColumn(
                                    //   label: Text(' '),
                                    // ),
                                  ],
                                  rows: t
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
                                                  itemRow['AcType'].toString()),
                                              showEditIcon: false,
                                              placeholder: false,
                                            ),
                                            DataCell(
                                              Text(itemRow['VoucherNo']
                                                  .toString()),
                                              showEditIcon: false,
                                              placeholder: false,
                                            ),

                                            DataCell(
                                              Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                    itemRow['Dr'].toString()),
                                              ),
                                              showEditIcon: false,
                                              placeholder: false,
                                            ),
                                            DataCell(
                                              Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                    itemRow['Cr'].toString()),
                                              ),
                                              showEditIcon: false,
                                              placeholder: false,
                                            ),
                                            // DataCell(
                                            //   Center(
                                            //     child: GestureDetector(
                                            //         onTap: () {
                                            //           print(
                                            //               itemRow['id']);
                                            //           Navigator.push(
                                            //               context,
                                            //               MaterialPageRoute(
                                            //                   builder: (context) =>
                                            //                       DocumentMovementCreate(
                                            //                           itemRow)));
                                            //         },
                                            //         child: Icon(Icons
                                            //             .navigate_next)),
                                            //   ),
                                            //    ),
                                            // ),
                                            // DataCell(
                                            //   FlatButton(
                                            //     padding:
                                            //     const EdgeInsets.fromLTRB(
                                            //         0, 0, 0, 0),
                                            //     child: Icon(Icons.delete),
                                            //     onPressed: () {
                                            //       setState(() {
                                            //         removeListElement(
                                            //           itemRow['id'],
                                            //         );
                                            //       });
                                            //     },
                                            //   ),
                                            // ),
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
