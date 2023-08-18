import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:new_qizo_gt/receiptcollection.dart';
import 'package:new_qizo_gt/urlEnvironment/urlEnvironment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'appbarWidget.dart';
import 'models/userdata.dart';

class ReceiptCollectionIndex extends StatefulWidget {


  dynamic passvalue;

  ReceiptCollectionIndex({this.passvalue});

  @override
  _ReceiptCollectionIndexState createState() => _ReceiptCollectionIndexState();
}

class _ReceiptCollectionIndexState extends State<ReceiptCollectionIndex> {
  dynamic branchName;
  dynamic userName;
  dynamic data;
  bool showProgress = true;
  dynamic customerName;
  dynamic branch;
  dynamic user;
  dynamic nowTime;
  dynamic ShpName="";
  List<dynamic> t = [];
  dynamic customer = "";
  dynamic datas;
  List<dynamic> CR_Approve = [];
  List<dynamic> CR_notApprove = [];
  dynamic NotAPrAmd=0.00;
   dynamic APrAmd=0.00;
  dynamic TtlAmd=0.00;
  late SharedPreferences pref;
  dynamic prog;
  var formatter = NumberFormat('#,##,000.00');
  late bool visibilityTableRow;
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

         // getIndexReceiptCollectionorg();

          datas =widget.passvalue;

          print("adsfg $datas");

          if(datas['ledgerId']==null ||datas['ledgerId']==0 || datas['ledgerId']=="null" )
          {

            getIndexReceiptCollection (0);
            visibilityTableRow=true;
          } else {
          getIndexReceiptCollection (datas['ledgerId']);
          visibilityTableRow=false;
          }
         // getCustomer(63);
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
      final response = await http.get(
        "${Env.baseUrl}MLedgerHeads/${id.toString()}" as Uri,
        headers: {
          "Authorization": user.user["token"],
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
        var v = json.decode(response.body);
        customerName = v['ledgerHeads'][0]['lhName'];
        return customerName;
      } else {
        print("Error getting users");
        return "Error";
      }
    } catch (e) {
      print("Error getting users");
      return "Error";
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
    var formattedDates =
        DateFormat('MMM dd , yyyy').format(DateTime.parse(date));
    // print(formattedDate);
    return "${formattedDates.toString()}" + " - " + formattedTime;
  }

  // get indexDocument
  getIndexReceiptCollectionorg() async {
    // TDocumentHandlingdetails/1/1
    var res = await http.get("${Env.baseUrl}MobSmrctCollectionHeaders" as Uri,
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



  getIndexReceiptCollection(dynamic id) async {


    dynamic dtfrm=datas['dtFrom'].toString();
    dynamic dtto=datas['dtTo'].toString();

    var req = {
      "dateFrom": dtfrm,
      "dateTo": dtto,
      "ledgerId":id
    };


    var params = json.encode(req);
    print(params);
    print("${Env.baseUrl}Receipt/1");
    var res = await http.post("${Env.baseUrl}Receipt/1" as Uri,
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
      var dt = json.decode(res.body);
      print(".....api data......");
      print(dt);
      t = dt['details']['data'] as List;



      for(int i=0;i<t.length;i++){
        CR_Approve = t.where((i) => i["Approve"]=="Yes").toList();
     //   print("yyyy$CR_Approve".toString());
        print(res.statusCode);
        CR_notApprove = t.where((i) => i["Approve"]=="No").toList();
       //  print("nnnn$CR_notApprove".toString());
        showProgress= false;
      }



      for(int k=0;k<CR_Approve.length;k++) {
        APrAmd = APrAmd + CR_Approve[k]['Amount'];
      }

      for(int j=0;j<CR_notApprove.length;j++){
        NotAPrAmd=NotAPrAmd +CR_notApprove[j]['Amount'];
      }

      // t.forEach(print);
      // print(t);
      // print(res.statusCode);
      // showProgress = false;
      if(id== 0||id==null)
      {ShpName="";}
      else
      {ShpName = t[0]['Shop Name'].toString(); }

      for(int j=0;j<t.length;j++){
        TtlAmd=TtlAmd +t[j]['Amount'];
      }


    });
  }






 // ------------------------------All function end---------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(190.0),
              child:Appbarcustomwidget(uname:userName, branch:branchName, pref: pref, title: "Receipt Collection")
            ),
            body: ListView(
              children: [
                SizedBox(
                  height: 30,
                ),
                Stack(
                  children: [
                    //SizedBox(width:10,),
                    Padding(
                      padding: const EdgeInsets.only(left:10,top:10),
                      child: Text(ShpName,style: TextStyle(color: Colors.blueAccent,fontSize: 15),),
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     Navigator.pop(context);
                    //     Navigator.pushReplacement(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => SalesManHome()));
                    //   },
                    //   child: Center(
                    //       child: Container(
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(10),
                    //             color: Colors.blueAccent,
                    //           ),
                    //           width: 35,
                    //           height: 35,
                    //           child: Center(
                    //             child: Icon(
                    //               Icons.arrow_back,
                    //               color: Colors.white,
                    //             ),
                    //             // style: TextStyle(color: Colors.white),),
                    //           ))),
                    // ),
                    SizedBox(
                     // width:  (MediaQuery.of(context).size.width / 2)+150,
                    ),
                    Container(
                      //width: (MediaQuery.of(context).size.width / 5),
                      child: Align(
                        alignment:Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReceiptCollections(passvalue:datas['ledgerId'],passname: datas['ledgerId']==null ? "" : t[0]["Shop Name"])));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
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
                                ))),
                          ),
                        ),
                      ),
                    )
                  ],
                ),

                Stack(
                    children:[ Visibility(visible:  CR_Approve.length > 0 ,
                        child: Container(child: Padding(
                            padding: const EdgeInsets.only(left: 35,top: 10),
                            child: Text("Colletion Approved",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.indigo,fontSize: 17,),) ),)),

                      Visibility(
                        visible:  CR_Approve.length > 0 ,
                        child: Align(alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10,right: 10),
                              child: Text("Rs. "+formatter.format(APrAmd).toString(),style: TextStyle(fontWeight: FontWeight.bold),),//NotAPrAmd
                            )),
                      ),
                    ]
                ),


                showProgress ?
                  Container(
                    height: 500,
                    width: 350,
                    child: Center(
                      // child: CircularProgressIndicator(),
                      child:Text("No Receipt Collections"),
                    ),
                  ):Container(
                  child: CR_Approve.length > 0 ?
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
                                  visibilityTableRow? DataColumn(
                                    label: Text('Shop Name'),
                                  )
                                  :DataColumn(
                                    label: Text(''),
                                  ),
                                  DataColumn(
                                    label: Text('Date'),
                                  ),

                                  DataColumn(
                                    label: Text('Collection'),
                                  ),
                                  DataColumn(
                                    label: Text('Type'),
                                  ),
                                  // DataColumn(
                                  //   label: Text('Approve'),
                                  // ),
                                  // DataColumn(
                                  //   label: Text(' '),
                                  // ),
                                ],
                                rows: CR_Approve
                                    .map(
                                      (itemRow) => DataRow(
                                    cells: [
                                      DataCell(
                                        Text(
                                            getItemIndex(itemRow).toString()),
                                        showEditIcon: false,
                                        placeholder: false,
                                      ),
                                      visibilityTableRow? DataCell(
                                        GestureDetector(
                                          onTap: () {},
                                          child: Text(
                                              '${itemRow['Shop Name'].toString()}'),
                                        ),
                                        showEditIcon: false,
                                        placeholder: false,
                                      )
                                      :DataCell(
                                        GestureDetector(
                                          onTap: () {},
                                          child: Text(""),
                                        ),
                                        showEditIcon: false,
                                        placeholder: false,
                                      ),
                                      DataCell(
                                        Text((itemRow['Date'])
                                            .toString()),
                                        showEditIcon: false,
                                        placeholder: false,
                                      ),
                                      DataCell(
                                        Container(
                                          alignment:Alignment.centerRight,
                                          child: Text(formatter.format((itemRow['Amount']))
                                              .toString()),
                                        ),
                                        showEditIcon: false,
                                        placeholder: false,
                                      ),
                                      DataCell(
                                        Text((itemRow['Type'])
                                            .toString()),
                                        showEditIcon: false,
                                        placeholder: false,
                                      ),
                                      // DataCell(
                                      //   Text((itemRow['Approve'])
                                      //       .toString()),
                                      //   showEditIcon: false,
                                      //   placeholder: false,
                                      // ),

                                      // DataCell(
                                      //   Center(
                                      //     child: GestureDetector(
                                      //         onTap: () {
                                      //           print(itemRow['id']);
                                      //           Navigator.push(
                                      //               context,
                                      //               MaterialPageRoute(
                                      //                   builder: (context) =>
                                      //                       UpdateReceiptCollection(
                                      //                           itemRow)));
                                      //         },
                                      //         child:
                                      //         Icon(Icons.navigate_next)),
                                      //   ),
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
                  ): Container(
                   // height: 400,
                    child: Center(
                        child: Text("")),
                  ),
                ),
//----------------------------------Colletion Received Approved--------------------------------------------------------------------

                Stack(
                    children:[ Visibility(visible:  CR_notApprove.length > 0 ,
                        child: Container(child: Padding(
                            padding: const EdgeInsets.only(left: 35,top: 10),
                            child: Text("Colletion Not Approved",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.indigo,fontSize: 17,),) ),)),

                      Visibility(
                        visible:  CR_notApprove.length > 0 ,
                        child: Align(alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10,right: 10),
                              child: Text("Rs. "+formatter.format(NotAPrAmd).toString(),style: TextStyle(fontWeight: FontWeight.bold),),//NotAPrAmd,TtlAmd
                            )),
                      ),
                    ]
                ),


                showProgress ?
                Container(
                  height: 500,
                  width: 350,
                  child: Center(

                    child:Text(""),
                  ),
                ):Container(
                  child: CR_notApprove.length > 0 ?
                  Row(
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
                                  visibilityTableRow? DataColumn(
                                    label: Text('Shop Name'),
                                  )
                                      :DataColumn(
                                    label: Text(''),
                                  ),
                                  DataColumn(
                                    label: Text('Date'),
                                  ),

                                  DataColumn(
                                    label: Text('Collection'),
                                  ),
                                  DataColumn(
                                    label: Text('Type'),
                                  ),
                                  // DataColumn(
                                  //   label: Text('s'),
                                  // ),


                                ],
                                rows: CR_notApprove
                                    .map(
                                      (itemRow) => DataRow(
                                    cells: [
                                      DataCell(
                                        Text(
                                            getItemIndex(itemRow).toString()),
                                        showEditIcon: false,
                                        placeholder: false,
                                      ),
                                      visibilityTableRow? DataCell(
                                        GestureDetector(
                                          onTap: () {},
                                          child: Text(
                                              '${itemRow['Shop Name'].toString()}'),
                                        ),
                                        showEditIcon: false,
                                        placeholder: false,
                                      )
                                          :DataCell(
                                        GestureDetector(
                                          onTap: () {},
                                          child: Text(""),
                                        ),
                                        showEditIcon: false,
                                        placeholder: false,
                                      ),
                                      DataCell(
                                        Text((itemRow['Date'])
                                            .toString()),
                                        showEditIcon: false,
                                        placeholder: false,
                                      ),
                                      DataCell(
                                        Container(
                                          alignment:Alignment.centerRight,
                                          child: Text(formatter.format((itemRow['Amount']))
                                              .toString()),
                                        ),
                                        showEditIcon: false,
                                        placeholder: false,
                                      ),
                                      DataCell(
                                        Text((itemRow['Type'])
                                            .toString()),
                                        showEditIcon: false,
                                        placeholder: false,
                                      ),
                                      // DataCell(
                                      //   Center(
                                      //     child: GestureDetector(
                                      //         onTap: () {
                                      //           print(itemRow['id']);
                                      //           Navigator.push(
                                      //               context,
                                      //               MaterialPageRoute(
                                      //                   builder: (context) =>
                                      //                       UpdateReceiptCollection(
                                      //                           itemRow)));
                                      //         },
                                      //         child:
                                      //         Icon(Icons.navigate_next)),
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
                   // height: 400,
                    child: Center(
                        child: Text("")),
                  ),
                ),

//---------------------------------- End---------------------------------------------------------------------
              ],
            )));
  }
}
