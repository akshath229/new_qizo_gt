import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:new_qizo_gt/salesmanhome.dart';
import 'package:new_qizo_gt/technicianhome.dart';
import 'package:new_qizo_gt/urlEnvironment/urlEnvironment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'expensesheetsalesman.dart';
import 'models/userdata.dart';

class ExpenseSheetIndexPage extends StatefulWidget {
  
  dynamic route;
  ExpenseSheetIndexPage(this.route);
  @override
  _ExpenseSheetIndexPageState createState() => _ExpenseSheetIndexPageState();
}

class _ExpenseSheetIndexPageState extends State<ExpenseSheetIndexPage> {
  dynamic branchName;
  dynamic userName;
  dynamic data;
  dynamic customerName;
  dynamic branch;
  dynamic user;
  bool showProgress=true;
  dynamic nowTime;
  List<dynamic> t = [];
  dynamic customer ="";

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

          getIndexExpenseSheet();
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
      if (response.statusCode == 200) {
        var v = json.decode(response.body);
        customerName = v['ledgerHeads'][0]['lhName'];
        print("......");
        print(v['ledgerHeads'][0]['lhName']);
        return customerName;
      } else {
        print("Error getting users");
        return "HTTP Error: ${response.statusCode}";
      }
    } catch (e) {
      print("Error getting users: $e");
      return "Error";
    }
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
  // get indexDocument
  getIndexExpenseSheet() async {
    // TDocumentHandlingdetails/1/1
    var res = await http.get("${Env.baseUrl}MobExpenseSheetheaders" as Uri,
        headers: {'Authorization': user.user['token']});
    print(".....api data......");
    setState(() {
      print(res.body);

      var dt = json.decode(res.body);
      print(".....api data......");
      print(dt);
      t = dt as List;
      t.forEach(print);
      print(t);
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
            appBar:PreferredSize(
              preferredSize: Size.fromHeight(190.0),
              child: Container(
                height: 80,
                color: Colors.blue,
                width: double.maxFinite,
                child: Padding(
                  padding: const EdgeInsets.only(
                    //  bottom: 1,
                      right: 10,
                      left: 10
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
//                    SizedBox(width: 10,),

                        GestureDetector(
                            onTap: () {
                              print("hi");
                            },


                            child: Stack(
                              alignment: Alignment.center,
                                children: [
                               Center(
                                 child: Container(
                            height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40.0),
                                  image: DecorationImage(
                                      image: AssetImage("assets/Home_image.jpg"),
                                      fit: BoxFit.fill
                                  )
                              ),
                                  margin: new EdgeInsets.only(
                                      left: 0.0, top: 5.0, right: 0.0, bottom: 0.0),

                                 ),
                               )
                                ],
                            )
                ),


                  GestureDetector(
                    onTap: () {
                      print("hi");
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          top: 10,
                          bottom: 15
                      ),
                      child: Column(children:[
                        SizedBox(height: 7,),
                      Expanded(
                        child: Text(
                          "Expense Index",
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        ),
                      ),


                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 7),
                          child: Text(

                                    "${branchName.toString()}",
                                    style: TextStyle(fontSize: 13, color: Colors.white),
                          ),
                        ),
                      ),

                      ])
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
                        if(this.widget.route=="SalesMan"){
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SalesManHome()));
                        }
                        else{
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TechnicianHome()));
                        }

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
                                builder: (context) => ExpenseSheetSalesMan()));
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
                showProgress ?Container(
                  height: 500,
                  width: 350,
                  child: Center(
                    child: CircularProgressIndicator(),
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
                                    label: Text('User Name'),
                                  ),
                                  DataColumn(
                                    label: Text('Date'),
                                  ),

                                  DataColumn(
                                    label: Text('Update'),
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
                                        Text(getItemIndex(itemRow)
                                            .toString()),
                                        showEditIcon: false,
                                        placeholder: false,
                                      ),
                                      DataCell(
                                        GestureDetector(
                                          onTap: () {

                                          },
                                          child: Text('${
                                              userName.toString()}'),
                                        ),
                                        showEditIcon: false,
                                        placeholder: false,
                                      ),
                                      DataCell(
                                        Text(getTime
                                          (itemRow['eshDate'])
                                            .toString()),
                                        showEditIcon: false,
                                        placeholder: false,
                                      ),

                                      DataCell(
                                        Center(
                                          child: GestureDetector(
                                              onTap: () {
                                                print(itemRow['id']);
                                                // Navigator.push(
                                                //     context, MaterialPageRoute(
                                                //     builder: (context) =>
                                                //         UpdateReceiptCollection(
                                                //             itemRow)));
                                              },
                                              child: Icon(
                                                  Icons.navigate_next)),
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
                  ):
                  Container(
                    height: 400,
                    child: Center(
                        child: Text("No Data Found")),
                  ),
                ),
              ],
            )));
  }
}
