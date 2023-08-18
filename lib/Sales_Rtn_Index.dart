import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:new_qizo_gt/urlEnvironment/urlEnvironment.dart';
import 'package:printing/printing.dart';
import 'GT_Masters/AppTheam.dart';
import 'appbarWidget.dart';
import 'indexpage.dart';
import 'models/userdata.dart';
import 'models/usersession.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sales_Rtn_Index extends StatefulWidget {
  @override
  _Sales_Rtn_IndexState createState() => _Sales_Rtn_IndexState();
}

class _Sales_Rtn_IndexState extends State<Sales_Rtn_Index> {
  @override
  void initState() {

    SharedPreferences.getInstance().then((value) {
      pref = value;
      read();

      setState(() {
        getindexdata();
      });


    });
  }
  String? token;
  dynamic user;
  SharedPreferences? pref;
  UserData? userData;
  String? branchName;
  dynamic userName;
  List<dynamic> t = [];
  bool showProgress = true;
  var formatter = NumberFormat('#,##,##,##,##0.00');
  AppTheam theam =AppTheam();

//  get Token
  read() async {
    var v = pref?.getString("userData");
    print("USER DATA: $v");
    var c = json.decode(v!);

    user = UserData.fromJson(c); // token gets this code user.user["token"]
    setState(() {
      print("user data................");
      print(user.user["token"]);
      token = user.user["token"]; //  passes this user.user["token"]
      pref?.setString("customerToken", user.user["token"]);
      branchName = user.branchName;
      userName = user.user["userName"];
      print(".....");
      print(branchName);
      print(userName);
    });
  }


//get data to list


  getindexdata()async{
    try {
      var res = await http.get("${Env.baseUrl}SalesRtnHeaders" as Uri,
          headers: {'Authorization': user.user['token']});
      print(".....api data..getdata....");
      print(res.body);
      setState(() {
        var dt = json.decode(res.body);
        print(".....api data..1....");
        print(dt);
        // t = dt as List;
        t = dt as List;
        t.forEach(print);
        print(t);
        print(res.statusCode);
        showProgress = false;


      });
    }catch(e){print("error in getindexdata $e");}
  }












  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
//      key: scaffoldKey,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(190.0),
              child:  Appbarcustomwidget(uname: userName, branch:" branchName", pref: pref, title:"Sales Return Index")
          ),
          body: ListView(children: <Widget>[

            SizedBox(
              height: 4,
            ),
            showProgress ?
            Container(
              height: 500,
              width: 350,
              child: Center(
                  child:Text("Loading Sales....")
                //   CircularProgressIndicator(),
              ),
            ):Container(
              child: t.length > 0 ?
              Row(
//            verticalDirection: VerticalDirection.down,
//            crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  SizedBox(
                    width: 4,
                  ),

                  Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: DataTable(
                            columnSpacing: 17,
                            headingRowColor: theam.TableHeadRowClr,
                            onSelectAll: (b) {},
                            sortAscending: true,
                            columns: <DataColumn>[
                              DataColumn(
                                label: Text('Vch No',style: theam.TableFont,),
                              ),
                              DataColumn(
                                label: Text('Voucher Date',style: theam.TableFont,),
                              ),
                              DataColumn(
                                label: Text('Party Name',style: theam.TableFont,),
                              ),
                              DataColumn(
                                label: Text('Invoice Type',style: theam.TableFont,),
                              ),

                              // DataColumn(
                              //   label: Text('Edit',style: theam.TableFont,),
                              // ),

                            ],
                            rows: t
                                .map(
                                  (itemRow) => DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                        '${itemRow['voucherNo'].toString()}'),
                                    showEditIcon: false,
                                    placeholder: false,
                                  ),
                                  DataCell(
                                    GestureDetector(
                                        onTap: () {},
                                        child:
                                        // Text('${DateFormat("dd-MM-yyyy").format(DateTime.parse(itemRow['voucherDate']))}'),

                                        Text((itemRow['voucherDate']!=null)?DateFormat("dd-MM-yyyy").format(DateTime.parse(itemRow['voucherDate'])):"--/--/---")
                                    ),
                                    showEditIcon: false,
                                    placeholder: false,
                                  ),
                                  DataCell(
                                    GestureDetector(
                                      onTap: () {},
                                      child: Text('${itemRow['partyName'].toString()}'),

                                    ),
                                    showEditIcon: false,
                                    placeholder: false,
                                  ),
                                  DataCell(
                                    GestureDetector(
                                      onTap: () {},
                                      child: Text('${itemRow['invoiceType']??"".toString()}'),
                                    ),
                                    showEditIcon: false,
                                    placeholder: false,
                                  ),
                                  // DataCell(
                                  //   Center(
                                  //     child: GestureDetector(
                                  //         onTap: () {
                                  //           print(itemRow);
                                  //           Navigator.push(
                                  //             context,
                                  //             MaterialPageRoute(
                                  //                 builder: (context) =>
                                  //                     SalesReturn(
                                  //                         passvalue:itemRow['id'].toInt(),passname: itemRow['partyName'].toString(),itemrowdata:itemRow)),);
                                  //         },
                                  //         child:
                                  //         Icon(Icons.edit)),
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
              ): Container(
                height: 400,
                child: Center(
                    child: Text("No Order Found")),
              ),
            ),
            WillPopScope(
              onWillPop: _onBackPressed,
              child: Text(""),
            ),

          ]),
        ));
  }

  Future<bool> _onBackPressed() async {
    Navigator.of(context, rootNavigator: true).pop();
    return true;
  }
}
