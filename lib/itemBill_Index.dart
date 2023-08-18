import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'AQizo_RMS/RMS_HomePage.dart';
import 'appbarWidget.dart';
import 'models/userdata.dart';
import 'urlEnvironment/urlEnvironment.dart';

// import 'package:esc_pos_utils/esc_pos_utils.dart';
// import 'package:esc_pos_printer/esc_pos_printer.dart';

class itemBillIndex extends StatefulWidget {
  @override
  _itemBillIndexState createState() => _itemBillIndexState();
}

class _itemBillIndexState extends State<itemBillIndex> {
// //-----------------------------------------
  late SharedPreferences pref;
  dynamic data;
  dynamic branch;
  var res;
  dynamic user;
  late int branchId;
  late int userId;
  late UserData userData;
  String branchName = "";
  dynamic userName;
  late String token;
  int total = 0;
  var tabStats = "";

// //----------------------------------
//
//   static List<Tabledata> TD = new List<Tabledata>();
//
  void initState() {
    setState(() {
      SharedPreferences.getInstance().then((value) {
        pref = value;
        read();
        Initial_Functions();
      });
    });
  }

// //------------------for appbar------------
  read() async {
    var v = pref.getString("userData");
    var c = json.decode(v!);
    user = UserData.fromJson(c); // token gets this code user.user["token"]
    setState(() {
      branchId = int.parse(c["BranchId"]);
      token = user.user["token"]; //  passes this user.user["token"]
      pref.setString("customerToken", user.user["token"]);
      branchName = user.branchName;
      userName = user.user["userName"];
      userId = user.user["userId"];
      DeviceId = user.deviceId;
    });
  }

// //---------------end---for appbar------------

  var AllPending =null;
  var CustomerPending = null;
  var WaiterPending =null;
  var DeviceId;

  Initial_Functions() {
    setState(() {
      getAllBillData();
      getWaiterData();
      getCustomerData();
    });
  }

  //------------------get all data--------------------------------------
  getAllBillData() async {
    try {
      //print("in getAllBillData");
      String url = "${Env.baseUrl}SalesHeaders/1/rmspendingorderprocessall";
      final res =
          await http.get(url as Uri, headers: {"Authorization": user.user["token"]});
      setState(() {
        var jsonData = jsonDecode(res.body);
        // print(jsonData.toString());
        AllPending = jsonData["salesHeader"];
      });
    } catch (e) {
      print("error on getAllBillData $e");
    }
  }

  //--------------END----get all data---------------------------------------

  //------------------get Customer data--------------------------------------
  getCustomerData() async {
    try {
      print("in getAllBillData");
      String url =
          "${Env.baseUrl}SalesHeaders/1/rmspendingorderprocesscustomer";
      final res =
          await http.get(url as Uri, headers: {"Authorization": user.user["token"]});
      setState(() {
        var jsonData = jsonDecode(res.body);
        //print(jsonData.toString());
        CustomerPending = jsonData["salesHeader"];
        print(CustomerPending.toString());
      });
    } catch (e) {
      print("error on getCustomerData $e");
    }
  }

  //--------------END----get all data---------------------------------------

  //------------------get Customer data--------------------------------------
  getWaiterData() async {
    try {
      // print("in getAllBillData");
      String url = "${Env.baseUrl}SalesHeaders/1/rmspendingorderprocesswaiter";
      final res =
          await http.get(url as Uri, headers: {"Authorization": user.user["token"]});
      setState(() {
        var jsonData = jsonDecode(res.body);
        // print(jsonData.toString());
        WaiterPending = jsonData["salesHeader"];
        // print(WaiterPending);
      });
    } catch (e) {
      print("error on getWaiterData $e");
    }
  }

  //--------------END----get all data---------------------------------------

  //----------------start to Process--------------------------------------
  startProcess(id, UserDtls) async {
    print(id);
    print("${Env.baseUrl}SalesHeaders/$id/rmsprocessorder");

    try {
    var req = {"id": id};
    var params = json.encode(req);
    print("params");
    print(params);
    print(UserDtls.user["token"]);
    // print(UserDtls.DeviceId);
    var res = await http.put("${Env.baseUrl}SalesHeaders/$id/rmsprocessorder" as Uri,
        headers: {
          'accept': 'application/json',
          'content-type': 'application/json',
          'Authorization': UserDtls.user["token"],
        },
        body: params);
    print(res.statusCode);
    var jsonData = jsonDecode(res.body);
    print("startProcess");
    print(jsonData);
    if (jsonData["msg"] == "Order processed" || res.statusCode == 200) {
      // GetdataPrint(id);
      // Initial_Functions();
      return true;
    }
else{


      return false;
    }

    } catch (e) {
      print("error on startProcess $e");
    }
  }

//--------------END--start to Process----------------------------------------

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
          length: 3,
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                flexibleSpace: Appbarcustomwidget(
                  uname: branchName,
                  branch: userName,
                  pref: pref,
                  title: "Pending Orders",
                ),
                actions: [
                  GestureDetector(
                    onTap: () {
                      //getWaiterData();
                      //getCustomerData();
                    },
                    child: Text(""),
                  ),
                  Text(""),
                ],
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(90),
                  child: TabBar(
                    indicatorColor: Colors.indigo,
                    unselectedLabelColor: Colors.white,
                    labelColor: Colors.deepPurple,
                    onTap: (a) {
                      print(a.toString());
                      getAllBillData();
                      getWaiterData();
                      getCustomerData();
                    },
                    tabs: [
                      Tab(icon: Icon(Icons.wysiwyg), text: "All"),
                      Tab(icon: Icon(Icons.people), text: "Customer"),
                      Tab(icon: Icon(Icons.fastfood), text: "Waiter")
                    ],
                  ),
                ),
              ),
              body: WillPopScope(
                onWillPop: _onBackPressed,
                child: TabBarView(
                  children: [
                    Tabes(
                      pendingData: AllPending,
                      usersData: user,
                    ),
                    Tabes(
                      pendingData: CustomerPending,
                      usersData: user,
                    ),
                    Tabes(
                      pendingData: WaiterPending,
                      usersData: user,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    print("Back");
    // If you're pushing a new route and waiting for it to finish, use Navigator.pushReplacement
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Rms_Homes()),
    );
    return true;  // this means you're allowing the user to exit the app or go back
  }

}

class Tabes extends StatefulWidget {
  dynamic pendingData;
  dynamic usersData;

  Tabes({
    @required this.pendingData,
    @required this.usersData,
  });

  @override
  _TabesState createState() => _TabesState();
}

dynamic dataForTicket = [];

// PrinterNetworkManager _printerManager = PrinterNetworkManager();
class _TabesState extends State<Tabes> {
  @override
  dynamic branchName = "";
  dynamic userName = "";
  dynamic userId;

  _itemBillIndexState itembillIndx =_itemBillIndexState(); // function call from another class
String stateText="Loading....";



  Widget build(BuildContext context) {

    widget.pendingData.toString() == "null"? stateText="Loading.... ": stateText="No Pending Items";

    return widget.pendingData.toString() == "null" ||  widget.pendingData.toString()=="[]"
        ? Center(
            child: GestureDetector(
              onTap: () {
                //GetdataPrint(16);
              },
              child: Text(
                stateText,
                style: TextStyle(color: Colors.red, fontSize: 25),
              ),
            ),
          )
        : ListView(shrinkWrap: true, physics: ScrollPhysics(), children: [
            SizedBox(
              height: 5,
            ),
            GridView.builder(
              physics: ScrollPhysics(),
              itemCount: widget.pendingData.length,
              shrinkWrap: true,
              reverse: false,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, mainAxisExtent: 140),
              itemBuilder: (c, i) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      print(widget.pendingData[i]["id"].toString());
                      // getWaiterData();
                      // getCustomerData();
                      //startProcess(1);
                    });
                  },
                  onDoubleTap: () {
                    setState(() {
                      userName = widget.usersData.branchName;
                      userName = widget.usersData.user["userName"];
                      userId = widget.usersData.user["userId"];
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                  title: Text("Do you want to Process Order?"),
                                  actions: [
                                    TextButton(

                                      child: Text("Yes"),
                                      onPressed: () async {
                                        var prsid = widget.pendingData[i]["id"]
                                            .toString();
                                        print(prsid.toString());
                                        print("Process id");

                                        var k = await itembillIndx.startProcess(
                                            prsid, widget.usersData);
                                        print(k.toString());
                                        //Navigator.pop(context);
                                        if (k == true) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    itemBillIndex(),
                                              ));
                                        }
                                      },
                                    ),
                                    TextButton(

                                      child: Text("No"),
                                      onPressed: () {
                                        setState(() {
                                          print("No...");
                                          Navigator.pop(context);
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) => Testpage()));// this is proper..it will only pop the dialog which is again a screen
                                        });
                                      },
                                    )
                                  ]));
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Card(
                        borderOnForeground: true,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30)),
                            side: BorderSide(width: 1.5, color: Colors.blue)),
                        margin: EdgeInsets.all(6),
                        shadowColor: Colors.indigo,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Text(
                                    " Bill No      :  " +
                                        widget.pendingData[i]["voucherNo"]
                                            .toString(),
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  // SizedBox(width: 70,),
                                  Spacer(),

                                  Text(
                                    widget.pendingData[i]['orderType'] == null
                                        ? ""
                                        : widget.pendingData[i]['orderType']
                                            .toString(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: widget.pendingData[i]
                                                    ['orderType'] ==
                                                "waiter"
                                            ? Colors.brown
                                            : Colors.red),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                " Token No :  " +
                                    widget.pendingData[i]["tokenNo"].toString(),
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              // Text(("  Voucher Date "+pendingData[i]['voucherDate'])==null?"-:-:":(DateFormat("dd-MM-yyyy").format(DateTime.parse(Item_BillData[i]['voucherDate'])))),
                              Text(
                                (" Table No  : " +
                                    (widget.pendingData[i]['deliveryTo'])
                                        .toString()),
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                " Customer Name :  " +
                                    (widget.pendingData[i]["partyName"] == null
                                        ? ""
                                        : widget.pendingData[i]["partyName"]
                                            .toString()),
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        )),
                  ),
                );
              },
            ),
          ]);
  }

//----------------start to Process--------------------------------------
// startProcess(id) async {
//   print(id);
//   print("${Env.baseUrl}$id/rmsprocessorder");
//
//   try {
//     var req = {"id": id};
//     var params = json.encode(req);
//     print("params");
//     print(params);
//     var res = await http.put("${Env.baseUrl}SalesHeaders/$id/rmsprocessorder",
//         headers: {
//           'accept': 'application/json',
//           'content-type': 'application/json',
//           'Authorization': widget.usersData.user["token"],
//           'deviceId': widget.usersData.deviceId
//         },
//         body: params);
//     print(res.statusCode);
//     var jsonData = jsonDecode(res.body);
//     print("startProcess");
//     print(jsonData);
//     if(jsonData["msg"]=="Order processed" ||res.statusCode==200){
//       GetdataPrint(id);
//     }
//   } catch (e) {
//     print("error on startProcess $e");
//   }
// }
//--------------END--start to Process----------------------------------------

//--------------------Print part-------------------------------------------

// GetdataPrint(id) async {
//   print("sales for print : $id");
//   double amount = 0.0;
//   try {
//     final tagsJson =
//     await http.get("${Env.baseUrl}SalesHeaders/$id", headers: {
//       //Soheader //SalesHeaders
//       "Authorization": widget.usersData.user["token"],
//     });
//     dataForTicket = await jsonDecode(tagsJson.body);
//     // print("sales for print");
//     print(dataForTicket);
//    // print(dataForTicket["salesHeader"][0]["voucherNo"]);
//     Timer(Duration(microseconds: 1,), () async{
//      await wifiprinting();
//     });
//     Timer(Duration(milliseconds: 5), () async{
//       Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//               builder: (context) =>
//                   itemBillIndex()));
//     });
//
//   } catch (e) {
//     print('error on databinding $e');
//   }
// }

//----------printing ticket generate--------------------------
//
//   Future<Ticket> _ticket(PaperSize paper) async {
//     // final ticket = Ticket(paper);
//     print('in');
//     final profile = await CapabilityProfile.load();
//     final ticket = Ticket(paper, profile);
//
//     List<dynamic> slsDet = dataForTicket["salesDetails"] as List;
//     dynamic VchNo = (dataForTicket["salesHeader"][0]["voucherNo"]) == null
//         ? "00"
//         : (dataForTicket["salesHeader"][0]["voucherNo"]).toString();
// // dynamic date=(dataForTicket["salesHeader"][0]["voucherDate"])==null?"-:-:-": DateFormat("yyyy-MM-dd hh:mm:ss").format((dataForTicket["salesHeader"][0]["voucherDate"]));
//     dynamic date = (DateFormat("dd/MM/yyy hh:mm:ss a").format(DateTime.now()).toString());
//     dynamic partyName=(dataForTicket["salesHeader"][0]["partyName"]) == null ||
//         (dataForTicket["salesHeader"][0]["partyName"])== ""
//         ? ""
//         : (dataForTicket["salesHeader"][0]["partyName"]).toString();
//
//
//
//
//     ticket.text(
//         "Order Slip",
//         styles: PosStyles(bold: true,
//           align: PosAlign.center,
//           height: PosTextSize.size2,
//           width: PosTextSize.size2,underline: true
//         ));
//
//
//
//     ticket.text('Token NO : ' + VchNo.toString(),
//         styles: PosStyles(bold: true, width: PosTextSize.size1));
//     //ticket.emptyLines(1);
//     ticket.text('Date     : $date');
//     ticket.text('Delivery :'+(dataForTicket["salesHeader"][0]["voucherNo"]).toString());
//     //---------------------------------------------------------
//     //---------------------------------------------------------
//
//     ticket.hr(ch: '_');
//     ticket.row([
//       PosColumn(
//         text: 'Item',
//         styles: PosStyles(bold: true),
//         width: 5,
//       ),
//       PosColumn(text: 'Rate', width: 2,styles:PosStyles(align: PosAlign.center)),
//       PosColumn(text: 'Qty', width: 1,styles: PosStyles(align: PosAlign.right ),),
//       PosColumn(text: 'Tax', width: 2,styles: PosStyles(align: PosAlign.center ),),
//       PosColumn(text: 'Amonunt', width: 2,styles: PosStyles(align: PosAlign.center ),),
//     ]);
//     ticket
//         .hr(); // for dot line or set ticket.hr(ch: 'charecter', linesAfter: 1);
//
//     dynamic total = 0.000;
//     print("iii");
//     for (var i = 0; i < slsDet.length; i++) {
//      // double tax=((slsDet[i]["amountIncludingTax"])==null?0.00:(slsDet[i]["amountIncludingTax"]));
//       total = (slsDet[i]["netTotal"])+total;
//       // ticket.emptyLines(1); // for space
//       print("iii");
//       print(i.toString());
//       ticket.row( [PosColumn(
//           text: (slsDet[i]["itmName"]),
//           width: 12,
//           styles: PosStyles(
//             fontType: PosFontType.fontB,
//           )),] );
//       ticket.row([
//         PosColumn(
//             text: (' ' + ((slsDet[i]["rate"])).toStringAsFixed(3)).toString(),
//             width: 5,
//             styles: PosStyles(
//               fontType: PosFontType.fontB,
//             )),
//         PosColumn(
//             text: (' ' + ((slsDet[i]["rate"])).toStringAsFixed(3)).toString(),
//             width: 2,
//             styles: PosStyles(
//                 fontType: PosFontType.fontB,align: PosAlign.right
//             )),
//         PosColumn(
//             text: (' ' + ((slsDet[i]["qty"])).toStringAsFixed(0)).toString(),styles:PosStyles(align: PosAlign.right ),
//             width: 1),
//         PosColumn(
//             text:   (' ' + ((slsDet[i]["taxPercentage"])).toStringAsFixed(0))
//
//             ,styles:PosStyles(align: PosAlign.right ),
//             width: 2),
//         PosColumn(
//             text:
//             (' ' +(slsDet[i]["netTotal"]).toStringAsFixed(3)),
//             styles:PosStyles(align: PosAlign.right ),
//             width: 2),
//       ]);
//     }
//
//
//     ticket.hr();
//     ticket.row([
//       PosColumn(
//           text: 'Total',
//           width: 4,
//           styles: PosStyles(
//             bold: true,
//             fontType: PosFontType.fontA,width:  PosTextSize.size2,
//           )),
//       PosColumn(
//           text: 'Rs ' + (total.toStringAsFixed(3)).toString(),
//           width: 8,
//           styles: PosStyles(bold: true,width: PosTextSize.size2,align: PosAlign.right,)),
//     ]);
//     ticket.hr(
//       ch: '_',
//       linesAfter: 1,
//     );
//
//
//     ticket.feed(2);
//     ticket.text('Thank You...Visit again !!',
//         styles: PosStyles(align: PosAlign.center, bold: true));
//
//     ticket.cut();
//     return ticket;
//   }
// //..................................................
//
//   wifiprinting() async {
//     try {
//       print(" print in");
//       _printerManager.selectPrinter('192.168.0.100');
//       //_printerManager.selectPrinter(null);
//       final res =
//       await _printerManager.printTicket(await _ticket(PaperSize.mm80));
//       print(" print in");
//     } catch (e) {
//       print("error on print $e");
//     }
//   }

//----------------------Print part End-----------------------------------------
}
