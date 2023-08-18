import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:new_qizo_gt/salesmanhome.dart';
import 'package:new_qizo_gt/urlEnvironment/urlEnvironment.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'indexpage.dart';
import 'models/userdata.dart';
class ShopVisitedIndexPage extends StatefulWidget {
  @override
  _ShopVisitedIndexPageState createState() => _ShopVisitedIndexPageState();
}

class _ShopVisitedIndexPageState extends State<ShopVisitedIndexPage> {
  dynamic branchName;
  dynamic userName;
  dynamic data;
  dynamic customerName;
  dynamic branch;
  dynamic user;
  dynamic nowTime;
  bool showProgress = true;
  List<dynamic> t = [];
  dynamic customer = "";

  late SharedPreferences pref;
  dynamic prog;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      SharedPreferences.getInstance().then((value) {
//         prog = new ProgressDialog(
//           context,
//           type: ProgressDialogType.Normal,
//           isDismissible: true,
//           showLogs: true,
//         );
//         prog.style(
//           message: "Loading ....", //
// //      progress: 0.0,
// //      maxProgress: 100.0,
//         );
//         prog.show();
        pref = value;
//         read();
// setState(() {
//
// });

        setState(() {
          read();

          getIndexCustomerVisited();
          getCustomer(63);
        });
        var date = DateTime.now();
        // var formatter =
        // new DateFormat('MM-dd-yyyy'); // this dd-MM-yyyy format i want

        // String formattedDate = formatter
        //     .format(DateTime.parse(date.toString()));
        DateTime now = DateTime.now();
        // String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
        nowTime = DateFormat('kk:mm:ss').format(now);

        print(date);
        print(nowTime);
      });
    });

    super.initState();

    // quantityController.addListener(qtyListener);
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
      // prog.hide();
    });
//    getCustomer();
//    showDialog(
//        context: context,
//        builder: (context) => AlertDialog(
//              title: Text("data:   " + user.branchName),
//              content: Text("user data:   " + user.user["token"]),
//            ));
  }

  removeListElement(int id) {
    // print(sl);
    t.removeWhere((element) => element['id'] == id);
    // customerItemAdd.removeWhere((element) => element.id == id);
    // grandTotal = grandTotal - amount;

    print("deleted");
//   customerItemAdd.indexOf(sl);

//    print('item:$name  rate: $price');
  }

  getItemIndex(dynamic item) {
    var index = t.indexOf(item);
    return index + 1;
  }

// get customer account

  Future<String> getCustomer(dynamic id) async {
    try {
      final response = await http
          .get("${Env.baseUrl}MLedgerHeads/${id.toString()}" as Uri, headers: {
        "Authorization": user.user["token"],
      });
      print(response.statusCode);
      print(response.body);
      var v = json.decode(response.body);
      customerName = "";
      customerName = v['ledgerHeads'][0]['lhName'];
      print("......");
      print(v['ledgerHeads'][0]['lhName']);

      return customerName;
    } catch (e) {
      print("Error getting users");
      return 'Error getting users';  // return a string message indicating the error
    }
  }


  getTime(dynamic date) {
    // var formatter =
    // new DateFormat('HH:mm');
    var dateFormate = DateFormat("dd-MM-yyyy").format(DateTime.parse(date));

    // String formattedDates = formatter
    //     .format(DateTime.parse(date));
    var formattedTime = DateFormat.jm().format(DateTime.parse(date));
    //
    // print(formattedTime);
    var formattedDates = DateFormat('MMM dd , yyyy').format(
        DateTime.parse(date));
    // print(formattedDate);
    return  formattedTime;
  }
  getDate(dynamic date) {
    // var formatter =
    // new DateFormat('HH:mm');
    var dateFormate = DateFormat("dd-MM-yyyy").format(DateTime.parse(date));

    // String formattedDates = formatter
    //     .format(DateTime.parse(date));
    var formattedTime = DateFormat.jm().format(DateTime.parse(date));
    //
    // print(formattedTime);
    var formattedDates = DateFormat('MMM dd , yyyy').format(
        DateTime.parse(date));
    // print(formattedDate);
    return "${formattedDates.toString()}";
  }

  // get indexDocument
  getIndexCustomerVisited() async {
    // TDocumentHandlingdetails/1/1
    var res = await http.get("${Env.baseUrl}TcustomerVisitHistories" as Uri,
        headers: {'Authorization': user.user['token']});
    print(".....api data......");
    print(res.body);
    setState(() {
      var dt = json.decode(res.body);
      print(".....api data......");
       print(dt);
      t = dt['visitDetails']['data'] as List;
      t.forEach(print);
      print(t);
       // t=[];
      print(res.statusCode);
      showProgress= false;
    });
  }

  // move to element list
  moveListElement(int id) {
    print(id);
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
                            "Shop Visit Index",
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
                                  Navigator.pop(context);
                                });
                              },
                            );


                            Widget yesButton = TextButton(
                              child: Text("Yes"),
                              onPressed: () {
                                setState(() {
                                  print("Yes...");
                                  pref.remove('userData');
                                  Navigator.pop(context);
                                  Navigator.pushReplacementNamed(context, "/logout");
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
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SalesManHome()));
                      },
                      child: Center(
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blueAccent,
                              ),
                              width: 35,
                              height: 35,
                              child: Center(
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                // style: TextStyle(color: Colors.white),),
                              ))),
                    ),
                    SizedBox(
                      width: 275,
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CustomerVisited()));
                      },
                      child: Center(
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60),
                                color: Colors.blueAccent,
                              ),
                              width: 35,
                              height: 35,
                              child: Center(
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  )))),
                    )
                  ],
                ),
                showProgress ? Container(
                  height: 500,
                  width: 350,
                  child: Center(
                   // child: CircularProgressIndicator(),
                      child:Text("No Visit History")
                  ),
                ):
                Container(
                  child: t.length >0 ?
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
                              child: DataTable(
                                columnSpacing: 17,
                                onSelectAll: (b) {},
                                sortAscending: true,
                                columns: <DataColumn>[
                                  DataColumn(
                                    label: Text('#'),
                                  ),
                                  DataColumn(
                                    label: Text('Customer Name'),
                                  ),
                                  DataColumn(
                                    label: Text('Date'),
                                  ),
                                  DataColumn(
                                    label: Text('Time In'),
                                  ),

                                  DataColumn(
                                    label: Text('Time Out'),
                                  ),
                                  // DataColumn(
                                  //   label: Text(' '),
                                  // ),
                                ],
                                rows: t
                                    .map(
                                      (itemRow) => DataRow(
                                    cells: [
                                      DataCell(
                                        Text(
                                            getItemIndex(itemRow).toString()),
                                        showEditIcon: false,
                                        placeholder: false,
                                      ),
                                      DataCell(
                                        GestureDetector(
                                          onTap: () {},
                                          child: Text(
                                              '${itemRow['Customer'].toString()}'),
                                        ),
                                        showEditIcon: false,
                                        placeholder: false,
                                      ),

                                      DataCell(
                                          itemRow['Date'] != "" ?
                                       GestureDetector(
                                         onTap: (){
                                           print(itemRow['Date']);
                                         },
                                         child: Text(
                                           itemRow['Date']
                                               .toString()),)   :
                                          Text("No Date")
                                      ),
                                      DataCell(
                                          itemRow['TvhDateIn'] != "" ?
                                        GestureDetector(child: Text(itemRow['TvhDateIn']
                                            .toString()),)  :
                                          Center(child: Text("-"))
                                      ),

                                      DataCell(
                                        Center(
                                          child: GestureDetector(
                                              onTap: () {
                                                print(itemRow['id']);
                                                print("${itemRow['TvhDateIn']}");
                                                // Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //         builder: (context) =>
                                                //             UpdateReceiptCollection(
                                                //                 itemRow)));
                                              },
                                              child: itemRow['TvhDateOut'] != "" ?
                                              Text(itemRow['TvhDateOut']
                                                  .toString()):
                                                  Text("-")
                                              ),
                                        ),
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
                            ),
                          )),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  )
                  :Container(
                    height: 400,
                    child: Center(
                        child: Text("No Visit History")),
                  ),
                ),
              ],
            )));
  }
}
