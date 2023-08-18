import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';


import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../appbarWidget.dart';
import '../models/userdata.dart';
import '../urlEnvironment/urlEnvironment.dart';
import 'RMS_HomePage.dart';



class Rms_ItemBill_Index extends StatefulWidget {
  @override
  _Rms_ItemBill_IndexState createState() => _Rms_ItemBill_IndexState();
}

class _Rms_ItemBill_IndexState extends State<Rms_ItemBill_Index> {
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
                  uname:userName ,
                  branch:branchName ,
                  pref: pref,
                  title: "Pending Orders",
                  child:IconButton(onPressed: (){

                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Rms_Homes(),));
                  },icon:Icon(Icons.home,color: Colors.white,size: 30,)),
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
    Navigator.pop(context); // This line pops the current screen.
    return true; // This line is to denote that the back action has been handled.
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

  _Rms_ItemBill_IndexState itembillIndx = _Rms_ItemBill_IndexState(); // function call from another class
  String stateText = "Loading....";


  Widget build(BuildContext context) {
    widget.pendingData.toString() == "null"
        ? stateText = "Loading.... "
        : stateText = "No Pending Items";

    return widget.pendingData.toString() == "null" ||
        widget.pendingData.toString() == "[]"
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
        : Scrollbar(
      showTrackOnHover: true, thickness: 10, radius: Radius.circular(40),
      child: ListView(shrinkWrap: true, physics: ScrollPhysics(), children: [
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
                      builder: (context) =>
                          AlertDialog(
                              title: Text("Do you want to Process Order?"),
                              actions: [
                                TextButton(
                                  child: Text("Yes"),
                                  onPressed: () async {
                                    var prsid = widget.pendingData[i]["id"].toString();
                                    print(prsid.toString());
                                    print("Process id");

                                    var k = await itembillIndx.startProcess(prsid, widget.usersData);
                                    print(k.toString());
                                    //Navigator.pop(context);
                                    if (k == true) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Rms_ItemBill_Index(),
                                        ),
                                      );
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    primary: Colors.white, // This is for text color
                                    onSurface: Colors.grey,  // This will change the color when button is pressed, hover, or focused
                                  ),
                                ),

                                TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    primary: Colors.white, // This is for text color
                                    onSurface: Colors.grey,  // This will change the color when button is pressed, hover, or focused
                                  ),
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
                    child: SingleChildScrollView(
                      physics: ScrollPhysics(), scrollDirection: Axis.vertical,

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
                      ),
                    )),
              ),
            );
          },
        ),
      ]),
    );
  }
}
