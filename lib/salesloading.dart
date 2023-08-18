import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:new_qizo_gt/salesloadingView.dart';
import 'package:new_qizo_gt/urlEnvironment/urlEnvironment.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import 'models/salesorderres.dart';
import 'models/userdata.dart';

class SalesLoading extends StatefulWidget {
  @override
  _SalesLoadingState createState() => _SalesLoadingState();
}

class _SalesLoadingState extends State<SalesLoading> {
  SharedPreferences? pref;
  dynamic user;
  dynamic token;
  dynamic req;
  dynamic longitude;
  dynamic latitude;
  dynamic branchName;
  dynamic userName;
  bool showProgress = true;

  // Use this instead

  List<SalesOrderRes> salesOrdRes = [];

  @override
  void initState() {
    setState(() {
      print("Sales man Home...............");
      SharedPreferences.getInstance().then((value) {
        pref = value;
        read();
        getSalesOrder();
      });

      super.initState();
    });
  }

  @override
  void dispose() {
    // TODO: Add code here
    super.dispose();
  }

  read() async {
    var v = pref?.getString("userData");
    print("USER DATA: $v");

    var c = json.decode(v!);
    req = c;

    user = UserData.fromJson(c); // token gets this code user.user["token"] res
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

//    getCustomer();
//    showDialog(
//        context: context,
//        builder: (context) => AlertDialog(
//              title: Text("data:   " + user.branchName),
//              content: Text("user data:   " + user.user["userName"]),
//            ));
  }

  getSalesOrder() async {
    var res = await http.get("${Env.baseUrl}TsalesOrderHeaders/0/4" as Uri,
        headers: {'Authorization': user.user['token']});

    print(res.body);
    var c = json.decode(res.body);
    print(res.statusCode);

    setState(() {
      List<dynamic> t = c['soHeader'];
      print(t);
      salesOrdRes = t.map((t) => SalesOrderRes.fromJson(t)).toList();
      print(".....data...");
      print(salesOrdRes[0].sohFromLedgerName);
      print(".....data...");
      showProgress = false;
    });

    // salesOrderRes = c['soHeader'];
    // salesOrderRes.forEach((element) {
    //   print(element.sohOrderNo);
    // });

    // print(salesOrderRes);

    if (res.statusCode == 200) {
      print('success');
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
                        "Sales Loading",
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
                              pref?.remove('userData');
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
        body: showProgress ?
        Container(
          child:Center(child: CircularProgressIndicator()),


        ):
        SingleChildScrollView(
          child: salesOrdRes.length > 0
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
                        child: Visibility(
                          visible: salesOrdRes.length > 0,
                          child: DataTable(
                            columnSpacing: 13,
                            onSelectAll: (b) {},
                            sortAscending: true,
                            columns: <DataColumn>[
                              DataColumn(
                                label: Text('#'),
                              ),
                              DataColumn(
                                label: Text('Order No'),
                              ),
                              DataColumn(
                                label: Text('Customer'),
                              ),
                            ],
                            rows: salesOrdRes
                                .map(
                                  (itemRow) => DataRow(
                                    //   selected: true,
                                    // onSelectChanged: (bool selected) {
                                    //   if (selected) {
                                    //     print("Onselect :" +
                                    //         salesOrdRes.indexOf(itemRow).toString());
                                    //   }
                                    // },
                                    cells: [
                                      DataCell(
                                        Text(
                                          getItemIndex(itemRow).toString(),
                                        ),
                                        onTap: () {
                                          print("hi" +
                                              salesOrdRes
                                                  .indexOf(itemRow)
                                                  .toString());
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SalesLoadingView(
                                                        itemRow.id)),
                                          );
                                        },
                                        // Text(getItemIndex(itemRow).toString()),
                                        showEditIcon: false,
                                        placeholder: false,
                                      ),
                                      DataCell(
                                        Text(itemRow.sohOrderNo.toString()),
                                        onTap: () {
                                          // do whatever you want
                                          print("hi :" +
                                              itemRow.sohOrderNo.toString());
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SalesLoadingView(
                                                        itemRow.id)),
                                          );
                                        },
                                        showEditIcon: false,
                                        placeholder: false,
                                      ),
                                      DataCell(
                                        Text(itemRow.sohFromLedgerName
                                            .toString()),
                                        onTap: () {
                                          print("hi" +
                                              itemRow.sohFromLedgerName
                                                  .toString());
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SalesLoadingView(
                                                        itemRow.id)),
                                          );
                                          // do whatever you want
                                        },
                                        showEditIcon: false,
                                        placeholder: false,
                                      ),

                                      // DataCell(
                                      //   FlatButton(
                                      //     padding:
                                      //     const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      //     child: Icon(Icons.delete),
                                      //     onPressed: () {
                                      //       setState(() {
                                      //         removeListElement(itemRow,
                                      //             );
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
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                )
              : Container(
                  child: Center(
                    // SizedBox(
                    //   width: 90,
                    // ),
                    child: Visibility(
                      visible: salesOrdRes.length <= 0,
                      child: Center(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 150,
                              height: 500,
                            ),
                            Center(
                                child: Text("No Data Found")),
                            SizedBox(
                              width: 50,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   width: 20,
                    // ),
                  ),
                ),
        )

      ),
    );
  }

  getItemIndex(item) {
    int index = salesOrdRes.indexOf(item);
    return index + 1;
  }

  removeListElement(dynamic item) {
    // print("removed");
  }
}
