import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:new_qizo_gt/urlEnvironment/urlEnvironment.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import 'package:shared_preferences/shared_preferences.dart';
//import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';

import 'package:http/http.dart' as http;

import 'documentmovementindex.dart';
import 'models/userdata.dart';

class DocumentMovementCreate extends StatefulWidget {
  dynamic data;

  // dynamic status;
  DocumentMovementCreate(this.data);

  @override
  _DocumentMovementCreateState createState() => _DocumentMovementCreateState();
}

class _DocumentMovementCreateState extends State<DocumentMovementCreate> {
  late SharedPreferences pref;
  dynamic branchName;
  dynamic userName;
  dynamic user;
  dynamic apiRes;
  dynamic documentHandedOverTo="";
  dynamic documentEntryDate="";
  dynamic documentFrom = "";
  bool handOverToSelect = false;
  bool handOverFromSelect = false;
  dynamic pro;
  bool checkedValue = false;
  bool documentSelect = false;
  bool toEmployeeSelect = false;
  bool remarksSelect = false;
  TextEditingController customerController = new TextEditingController();
  TextEditingController documentNameController = new TextEditingController();
  TextEditingController toEmployeeController = new TextEditingController();
  TextEditingController handedOverToController = new TextEditingController();
  TextEditingController generalRemarksController = new TextEditingController();
  TextEditingController collectedForController = new TextEditingController();
  dynamic prs;
  List<dynamic> documentList = [];

  @override
  void initState() {
    // customerController.text = "";
//  goodsController.text = "";
    SharedPreferences.getInstance().then((value) {
      pref = value;
      read();
      print("document Id:${this.widget.data}");

      print("document Id:${this.widget.data['id'].toString()}");
      // getEmployee();
      // getCustomer();
      getVoucherNumber();
      // empCustLabel = "From Employee";
    });
    // token get fun  this

    // auto compelete fun
//    getUsers();
    super.initState();
    // customerController.addListener(customerLedgerIdListener);
  }

//get token
  read() async {
//    SharedPreferences pref = await SharedPreferences.getInstance();
    var v = pref.getString("userData");
    print("USER DATA: $v");
    var c = json.decode(v!);
    user = UserData.fromJson(
        c); // token gets this code user.user["token"] okk??? user res

    setState(() {
      print("user data................");
      print(user.user["token"]);
      pref.setString("customerToken", user.user["token"]);
      branchName = user.branchName;
      userName = user.user["userName"];
      print(".....");
      print(branchName);
      print(userName);
    });
//    getCustomer();
//    showDialog(
//        context: context,
//        builder: (context) => AlertDialog(
//              title: Text("data:   " + user.branchName),
//              content: Text("user data:   " + user.user["token"]),
//            ));
  }

  getVoucherNumber() async {
    var res = await http.get(
        "${Env.baseUrl}TDocumentHandlingdetails/${this.widget.data['id'].toString()}/1" as Uri,
        headers: {"Authorization": user.user['token']});
    print(res.statusCode);
    print(res.body);
    var v = json.decode(res.body);
    print(v[0]['ddHandedOverFrom']);
    setState(() {
      documentList = v as List;
      documentList.forEach(print);
      print("last index");
      print(documentList[documentList.length-1]['ddHandedOverTo']);
      print("last index");

      apiRes = v;
      documentFrom = v[0]['ddHandedOverFrom'];
      documentHandedOverTo=v[0]['ddHandedOverTo'];
      documentEntryDate=this.widget.data['dhEntryDate'];
      this.toEmployeeController.text = this.widget.data['dhCollectedFor'];
      this.documentNameController.text = this.widget.data['dhDocumentName'];
      this.collectedForController.text = documentList[documentList.length-1]['ddHandedOverTo'];
    });
  }
  getTime(dynamic date){
    // var formatter =
    // new DateFormat('HH:mm');
    var  dateFormate = DateFormat("dd-MM-yyyy").format(DateTime.parse(date));

    // String formattedDates = formatter
    //     .format(DateTime.parse(date));
    var formattedTime=  DateFormat.jm().format(DateTime.parse(date));
    //
    // print(formattedTime);
    var formattedDates= DateFormat('MMM dd , yyyy').format(DateTime.parse(date));
    // print(formattedDate);
    return  "${formattedDates.toString()}"+" - "+formattedTime;

  }


  getItemIndex(dynamic item) {
    var index = documentList.indexOf(item);
    return index + 1;
  }

  addMovement() async {
    setState(() {
      if (handedOverToController.text == "") {
        handOverToSelect = true;
      } else {
        handOverToSelect = false;
      }
    });
    if (handOverToSelect) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(
                  "Check Fields....",
                  style: TextStyle(color: Colors.red),
                ),
//              content: Text("$customerName"),
              ));
    } else {
      prs = new ProgressDialog(
        context,
        type: ProgressDialogType.normal,
        isDismissible: true,
        showLogs: true,
      );
      prs.style(
        message: "Updating ...", //
//      progress: 0.0,
//      maxProgress: 100.0,
      );

      prs.show();
      if (checkedValue) {
        print('put ..method');
        var req = {
          "id": this.widget.data['id'],
          "dhVoucherNo": this.widget.data['dhVoucherNo'],
          "dhEntryDate": this.widget.data['dhEntryDate'],
          "dhDocumentName": this.widget.data['dhDocumentName'],
          "dhRemarks": this.widget.data['dhRemarks'],
          "dhCollectedFrom": this.widget.data['dhCollectedFrom'],
          "dhCollectedFor": this.widget.data['dhCollectedFor'],
          "dhImage": this.widget.data['dhImage'],
          "dhClosedStatus": checkedValue,
          "dhUsreId": this.widget.data['dhUsreId'],
          "dhBranchId": this.widget.data['dhBranchId'],
        };

        var params = json.encode(req);
        print(params);

        var res = await http.put(
            '${Env.baseUrl}TDocumentHandlingHeaders/'
            '${this.widget.data['id'].toString()}' as Uri,
            headers: {
              'accept': 'application/json',
              'content-type': 'application/json',
              'Authorization': user.user['token'],
              'deviceId': user.deviceId
            },
            body: params);
        print(res.body);

        print(res.statusCode);
        setState(() {
          if (res.statusCode == 200 ||
              res.statusCode == 204 ||
              res.statusCode == 201) {
            prs.hide();
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DocumentMovementIndex()));
          }
        });
      } else {
        print("post...method");
        var req = {
          "ddDate": apiRes[0]['ddDate'],
          "ddHandedOverFrom": apiRes[0]['ddHandedOverTo'],
          "ddHandedOverTo": handedOverToController.text,
          "ddHeaderId": apiRes[0]['ddHeaderId'],
          "ddRemarks": apiRes[0]['ddRemarks'],
        };
        var params = json.encode(req);
        print(params);
        var res = await http.post('${Env.baseUrl}TDocumentHandlingdetails' as Uri,
            headers: {
              'accept': 'application/json',
              'content-type': 'application/json',
              'Authorization': user.user['token'],
              'deviceId': user.deviceId
            },
            body: params);
        print(res.statusCode);
        print(res.body);
        setState(() {
          if (res.statusCode == 200 ||
              res.statusCode == 201 ||
              res.statusCode == 204) {
            prs.hide();

            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DocumentMovementIndex()));
          }
        });
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(190.0),
          child: Container(
            height: 60,
            color: Colors.blue,
            width: double.maxFinite,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
//                    SizedBox(width: 10,),

                    GestureDetector(
                        onTap: () {
                          print("hi");
                        },
                        child: Container(
                          margin: new EdgeInsets.only(
                              left: 0.0, top: 25.0, right: 0.0, bottom: 0.0),
                          child: Text(
                            "${branchName.toString()}",
                            style: TextStyle(fontSize: 13, color: Colors.white),
                          ),
                        )),
                    GestureDetector(
                      onTap: () {
                        print("hi");
                      },
                      child: Text(
                        "Document Movement",
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      ),
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
                                content: Text("Do you really want to logout?"),
                                actions: [yesButton, noButton]));
                      },
                      child: Container(
                        margin: new EdgeInsets.only(
                            left: 0.0, top: 25.0, right: 0.0, bottom: 0.0),
                        child: Text(
                          "${userName.toString()}",
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                      ),
                    )
                  ]),
            ),
          ),
        ),
        body: ListView(
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    controller: documentNameController,
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
                      errorStyle: TextStyle(color: Colors.red),
                      errorText:
                          documentSelect ? "Please add Document ?" : null,
//                    suffixIcon: Icon(
//                      Icons.calendar_today,
//                      color: Colors.blue,
//                      size: 24,
//                    ),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 16.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0)),
                      // curve brackets object
//                    hintText: "Quantity",
                      hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                      labelText: "Document Name",
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            SizedBox(
              height: 4,
            ),
//           Row(children: [
//             SizedBox(width: 10),
//             Expanded(
//                 child: TypeAheadField(
//                     textFieldConfiguration: TextFieldConfiguration(
//                         style: TextStyle(),
//                         focusNode: _focusNode,
//                         onTap: () {
//                           print("focus");
//                           setState(() {
//                             if (empCustLabel == "From Employee") {
//
//                               customerController.text = "";
//
//                               empCustLabel = "From Customer";
//                               print(empCustLabel);
//                             } else {
//                               customerController.text = "";
//
//                               empCustLabel = "From Employee";
//
//                               print(empCustLabel);
//
//                             }
//                           });
//                         },
//                         controller: customerController,
//                         decoration: InputDecoration(
//                           errorStyle: TextStyle(color: Colors.red),
//                           errorText:
//                               customerSelect ? "Please Select user ?" : null,
// //                            errorText: _validateName ? "please enter name" : null,
// //                            errorBorder:InputBorder.none ,
//                           suffixIcon: IconButton(
//                             icon: Icon(Icons.remove_circle),
//                             color: Colors.blue,
//                             onPressed: () {
//                               print("cleared");
//                               customerController.text = "";
//                               salesLedgerId = 0;
//                             },
//                           ),
//
//                           isDense: true,
//                           contentPadding:
//                               EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(14.0)),
//                           // i need very low size height
//                           labelText:
//                               '${empCustLabel.toString()}', // i need to decrease height
//                         )),
//                     suggestionsBoxDecoration:
//                         SuggestionsBoxDecoration(elevation: 90.0),
//
//                     suggestionsCallback: (pattern) {
//                       // print("start with upper case");
//                       // if(pattern.toUpperCase() ==  pattern){
//                       //   print("capital 1st");
//
//                       if (empCustLabel == "From Employee") {
//                         return users.where(
//                             (user) => user['emEmployeeName'].contains(pattern));
//                       } else {
//                         return customers
//                             .where((usr) => usr['lhName'].contains(pattern.toUpperCase()));
//                       }
//
//                       // }
//                       // else{
//                       //   print("small first");
//                       //   return users.where((user) =>
//                       //       user['emEmployeeName'].contains(pattern.toUpperCase()));
//                       // }
//                     },
//                     itemBuilder: (context, suggestion) {
//                       return Card(
//                         color: Colors.white,
//                         shadowColor: Colors.blue,
//                         child: ListTile(
//                           focusColor: Colors.blue,
//                           hoverColor: Colors.red,
//                           title:Container(
//                             child:  empCustLabel == "From Employee"
//                                 ? Text(
//                               suggestion['emEmployeeName'] ?? "",
//                               style: TextStyle(color: Colors.black),
//                             )
//                                 : Text(
//                               suggestion['lhName'] ?? "",
//                               style: TextStyle(color: Colors.black),
//                             ),
//                           )
//                         ),
//                       );
//                     },
//                     onSuggestionSelected: (suggestion) {
//                       setState(() {
//                         if (empCustLabel == "From Employee") {
//                           print("selected Employee");
//
//                           print(suggestion['emEmployeeName']);
//                           print("selected Employee");
//
//                           customerController.text =
//                               suggestion['emEmployeeName'];
//                         } else {
//                           print("selected Customer");
//
//                           print(suggestion['lhName']);
//                           print("selected Customer");
//
//                           customerController.text = suggestion['lhName'];
//                         }
//                         print("close.... $salesLedgerId");
//                         salesLedgerId = 0;
//
//                         print(suggestion['id']);
//                         print(".......sales Ledger id");
//                         salesLedgerId = suggestion['id'];
//                         if (suggestion['id'] != null) {
//                           // getCustomerLedgerBalance(suggestion.id);
//                         }
//                         print(salesLedgerId);
//                         print("...........");
//                       });
//                     },
//                     errorBuilder: (BuildContext context, Object error) => Text(
//                         '$error',
//                         style: TextStyle(color: Theme.of(context).errorColor)),
//                     transitionBuilder:
//                         (context, suggestionsBox, animationController) =>
//                             FadeTransition(
//                               child: suggestionsBox,
//                               opacity: CurvedAnimation(
//                                   parent: animationController,
//                                   curve: Curves.elasticIn),
//                             ))),
//             SizedBox(
//               width: 10,
//             ),
//           ]),

            Row(
              children: [
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    readOnly: true,

                    controller: collectedForController,
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
                      errorStyle: TextStyle(color: Colors.red),
                      errorText: handOverFromSelect
                          ? "Invalid Handed Over From ?"
                          : null,
//                    suffixIcon: Icon(
//                      Icons.calendar_today,
//                      color: Colors.blue,
//                      size: 24,
//                    ),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 16.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0)),
                      // curve brackets object
//                    hintText: "Quantity",
                      hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                      labelText: "Document From",
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),

            SizedBox(
              height: 4,
            ),
            Row(
              children: [
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    controller: toEmployeeController,
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
                      errorStyle: TextStyle(color: Colors.red),
                      errorText:
                          toEmployeeSelect ? "Invalid To Employee ?" : null,
//                            errorText: _validateName ? "please enter name" : null,
//                            errorBorder:InputBorder.none ,
//                    suffixIcon: Icon(
//                      Icons.calendar_today,
//                      color: Colors.blue,
//                      size: 24,
//                    ),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 16.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0)),
                      // curve brackets object
//                    hintText: "Quantity",
                      hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                      labelText: "Document To",
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),

            SizedBox(
              height: 4,
            ),
            Row(
              children: [
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: handedOverToController,
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
                      errorStyle: TextStyle(color: Colors.red),
                      errorText:
                          handOverToSelect ? "Invalid Handed Over To ?" : null,
//                    suffixIcon: Icon(
//                      Icons.calendar_today,
//                      color: Colors.blue,
//                      size: 24,
//                    ),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 16.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0)),
                      // curve brackets object
//                    hintText: "Quantity",
                      hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                      labelText: "Handed Over To",
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),

//           SizedBox(
//             height: 4,
//           ),
//           Row(
//             children: [
//               SizedBox(width: 10),
//               Expanded(
//                 child: TextFormField(
//                   controller: generalRemarksController,
//                   enabled: true,
//                   validator: (v) {
//                     if (v.isEmpty) return "Required";
//                     return null;
//                   },
// //
// //                  focusNode: field1FocusNode,
//                   cursorColor: Colors.black,
//
//                   scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
//                   keyboardType: TextInputType.text,
//
//                   decoration: InputDecoration(
//                     errorStyle: TextStyle(color: Colors.red),
//                     errorText: remarksSelect ? "Invalid Remarks ?" : null,
// //                    suffixIcon: Icon(
// //                      Icons.calendar_today,
// //                      color: Colors.blue,
// //                      size: 24,
// //                    ),
//                     isDense: true,
//                     contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 16.0),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(14.0)),
//                     // curve brackets object
// //                    hintText: "Quantity",
//                     hintStyle: TextStyle(color: Colors.black, fontSize: 15),
//
//                     labelText: "Remarks",
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//             ],
//           ),

            SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: Center(child: Text("Closed")),

                    value: checkedValue,
                    onChanged: (newValue) {
                      setState(() {
                        checkedValue = newValue!;
                        print(checkedValue);
                      });
                    },

                    // controlAffinity:
                    // ListTileControlAffinity
                    //     .leading, //  <-- leading Checkbox
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      addMovement();
                    },
                    child: Text("Save"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lightBlueAccent,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),

                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            SizedBox(height: 4),
            documentList.length <= 0
                ? Container(
              height: 500,
              width: 350,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ):
            Row(
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
                      child:DataTable(
                        columnSpacing: 17,
                        onSelectAll: (b) {},
                        sortAscending: true,
                        columns: <DataColumn>[
                          DataColumn(
                            label: Text('#'),
                          ),
                          DataColumn(
                            label: Text('From'),
                          ),
                          DataColumn(
                            label: Text('To'),
                          ),
                          DataColumn(
                            label: Text('Date'),
                          ),

                          // DataColumn(
                          //   label: Text(' '),
                          // ),
                        ],
                        rows: documentList
                            .map(
                              (itemRow) =>
                              DataRow(
                                cells: [
                                  DataCell(
                                    Text(getItemIndex(itemRow)
                                        .toString()),
                                    showEditIcon: false,
                                    placeholder: false,
                                  ),
                                  DataCell(
                                    Text(itemRow['ddHandedOverFrom']
                                        .toString()),
                                    showEditIcon: false,
                                    placeholder: false,
                                  ),
                                  DataCell(
                                    Text(itemRow['ddHandedOverTo']
                                        .toString()),
                                    showEditIcon: false,
                                    placeholder: false,
                                  ),
                                  DataCell(
                                    Text(getTime(itemRow['ddDate']).toString()
                                        ),
                                    showEditIcon: false,
                                    placeholder: false,
                                  ),


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
                      // DataTable(
                      //     showCheckboxColumn: false, // <-- this is important
                      //     columns: [
                      //       DataColumn(label: Text('#')),
                      //       DataColumn(label: Text('From')),
                      //       DataColumn(label: Text('To')),
                      //       DataColumn(label: Text('Date')),
                      //     ],
                      //     rows: [
                      //       DataRow(
                      //         cells: [
                      //           DataCell(Text("1")),
                      //           DataCell(Text(documentFrom)),
                      //           DataCell(Text(documentHandedOverTo)),
                      //           DataCell(
                      //             Text(getTime(this.widget.data['dhEntryDate']).toString()),
                      //           ),
                      //         ],
                      //         onSelectChanged: (newValue) {
                      //           print('row 1 pressed');
                      //         },
                      //       ),
                      //       // DataRow(
                      //       //   cells: [
                      //       //     DataCell(Text(obj['user2'])),
                      //       //     DataCell(Text(obj['name-b'])),
                      //       //   ],
                      //       //   onSelectChanged: (newValue) {
                      //       //     print('row 2 pressed');
                      //       //   },
                      //       // ),
                      //     ]),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                )
              ],
            ),
            SizedBox(
              width: 4,
              height: 4,
            ),
            Wrap(
              children: [
                SizedBox(
                  width: 37,
                ),
                Center(
                  child: Visibility(
                    visible: this.widget?.data['dhImage'] != null,
                    child: GestureDetector(
                      onTap: () {
                        print(this.widget?.data['dhImage']);
                        Widget hideButton = TextButton(
                          child: Text("Close"),
                          onPressed: () {
                            setState(() {
                              print("yes...");
                              Navigator.pop(context); //okk
//                              Navigator.pop(context);

//                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()),);
                            });
                          },
                        );
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return WillPopScope(
                                onWillPop:() async => false,

                                child: new AlertDialog(title:Center(child: Text("Image")),
                                    content: Center(
                                      child: Image.network(
                                        this.widget?.data['dhImage'] ?? "",
                                        fit: BoxFit.fitHeight,
                                        // height:300.0,
                                        width: 220.0,
                                      ),
                                    ),
                                    actions: <Widget>[hideButton]
//                   GestureDetector(
//                     child: Text('Ok'),
//
//                     onTap: (){
//                       setState(() {
//                         print("yes...");
//                         pref.remove('userData');
//                         Navigator.pop(context); //okk
// //                              Navigator.pop(context);
//                         Navigator.pushReplacementNamed(context, "/logout");
//                       });
//
//                       },
//                     ),
                                  // ),
                                  // new FlatButton(
                                  //   onPressed: () {
                                  //     Navigator.pop(context);
                                  //   },
                                  //   child: new Text('Go Back'),
                                  // ),
                                  // ],
                                ),
                              );
                            });
                      },
                      child: Center(
                        child: Image.network(
                          this.widget?.data['dhImage'] ?? "",
                          fit: BoxFit.fitWidth,
                          height: 150.0,
                          width: 200.0,
                        ),
                      ),
                    ),

                    // AssetImage.Network(
                    //   imageUrl: "http://via.placeholder.com/350x150",
                    //   placeholder: (context, url) => new CircularProgressIndicator(),
                    //   errorWidget: (context, url, error) => new Icon(Icons.error),
                    // ),
                    // FadeInImage.assetNetwork(
                    //   // placeholder: 'assets/loading.gif',
                    //   image: this.widget.data['dhImage'],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
