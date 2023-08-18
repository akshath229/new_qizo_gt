import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:new_qizo_gt/urlEnvironment/urlEnvironment.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'documentmovement.dart';
import 'documentmovementcreate.dart';
import 'models/userdata.dart';

class DocumentMovementIndex extends StatefulWidget {
  @override
  _DocumentMovementIndexState createState() => _DocumentMovementIndexState();
}

class _DocumentMovementIndexState extends State<DocumentMovementIndex> {
  dynamic branchName;
  dynamic userName;
  dynamic data;
  dynamic branch;
  bool showProgress = true;
  dynamic user;
  dynamic nowTime;
  List<dynamic> t = [];

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

          getIndexDocument();
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

  // get indexDocument
  getIndexDocument() async {
    // TDocumentHandlingdetails/1/1
    var res = await http.get("${Env.baseUrl}TDocumentHandlingHeaders" as Uri,
        headers: {'Authorization': user.user['token']});
    print(".....api data......");
    print(res.body);
    setState(() {
      var dt = json.decode(res.body);
      print(".....api data......");
      print(dt);
      t = dt as List;
      t.forEach(print);
      print(t);
      print(res.statusCode);
      showProgress = false;
    });
  }

  // move to element list
  moveListElement(int id) {
    print(id);
  }

  getTime(dynamic date) {
    // var formatter =
    // new DateFormat('HH:mm');
    var dateFormate = DateFormat("dd-MM-yyyy").format(DateTime.parse(date));

    // String formattedDates = formatter
    //     .format(DateTime.parse(date));
    var formattedTime = DateFormat.jm().format(DateTime.parse(date));
    //
    print(formattedTime);
    var formattedDates =
        DateFormat('MMM dd , yyyy').format(DateTime.parse(date));
    // print(formattedDate);
    return "${formattedDates.toString()}" + " - " + formattedTime;
  }

  // remove customer items
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: PreferredSize(
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
                              child:   Container(
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

                          ],),
                        ),


                        GestureDetector(
                          onTap: () {
                            print("hi");
                          },
                          child:
                            Container(
                              margin: EdgeInsets.only(
                              top: 10,
                              bottom: 15
                             ),
                             child: Column(children:[
                                SizedBox(height: 7,),
                               Expanded(
                                 child:Text(
                                "Document Index",
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
                                builder: (context) => DocumentMoment()));
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
                showProgress
                    ? Container(
                        height: 500,
                        width: 350,
                        child: Center(
                          child: CircularProgressIndicator(),
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
                                            label: Text('Document Name'),
                                          ),
                                          DataColumn(
                                            label: Text('Created Date'),
                                          ),
                                          DataColumn(
                                            label: Text('From'),
                                          ),
                                          DataColumn(
                                            label: Text('To'),
                                          ),
                                          DataColumn(
                                            label: Text('Move'),
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
                                                    Text(itemRow[
                                                            'dhDocumentName']
                                                        .toString()),
                                                    showEditIcon: false,
                                                    placeholder: false,
                                                  ),
                                                  DataCell(
                                                    Text(getTime(itemRow[
                                                            'dhEntryDate'])
                                                        .toString()),
                                                    showEditIcon: false,
                                                    placeholder: false,
                                                  ),
                                                  DataCell(
                                                    Text(itemRow[
                                                            'dhCollectedFrom']
                                                        .toString()),
                                                    showEditIcon: false,
                                                    placeholder: false,
                                                  ),
                                                  DataCell(
                                                    Text(itemRow[
                                                            'dhCollectedFor']
                                                        .toString()),
                                                    showEditIcon: false,
                                                    placeholder: false,
                                                  ),
                                                  DataCell(
                                                    Center(
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            print(
                                                                itemRow['id']);
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        DocumentMovementCreate(
                                                                            itemRow)));
                                                          },
                                                          child: Icon(Icons
                                                              .navigate_next)),
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
                            : Container(
                                height: 400,
                                child: Center(child: Text("No Data Found")),
                              ),
                      )
              ],
            )));
  }
}
