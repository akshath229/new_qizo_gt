import 'dart:async';
import 'dart:convert';


import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:new_qizo_gt/urlEnvironment/urlEnvironment.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import 'models/postsalesloadingview.dart';
import 'models/salesloadingviewres.dart';
import 'models/userdata.dart';
// import 'package:simple_tooltip/simple_tooltip.dart';

class SalesLoadingView extends StatefulWidget {
  final dynamic id;

  // final dynamic images;

  SalesLoadingView(this.id);

  _SalesLoadingViewState createState() => _SalesLoadingViewState();
}

class _SalesLoadingViewState extends State<SalesLoadingView> {
  List<SalesLoadingViewPostData> barCodes = [];
  SalesLoadingViewPostData? barCode;

  List<RelSalesLoadingBarcodeDetails> detailsBarCodes =[];
  RelSalesLoadingBarcodeDetails? detailsBarCode;
  static AudioCache cache = AudioCache();
  AudioPlayer? player;
  SharedPreferences? pref;
  dynamic user;
  dynamic token;
  dynamic req;
  dynamic longitude;
  dynamic latitude;
  dynamic branchName;
  dynamic userName;
  Widget? loadingView;
  ByteData? audioData;
  dynamic prs;
  bool showProgress =true;
  // bool toolTipShow = false;
  // bool toolTipHide = false;
  bool showTooltip = false;

  int? newIndex;
  dynamic itemName;
  Widget? scanButton;
  Widget? yesButton;
  Widget? noButton;
  int? totalIndex;
  dynamic results = "Not Yet Selected Scan!";
  dynamic codeFormat = "";
  List<SalesOrderLoadingViewRes> loadingViewRes = [];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  // var qr = List<dynamic>();

  @override
  void initState() {
    setState(() {
      print("Sales loading View...............");
      print("............");
      print(this.widget.id);

      SharedPreferences.getInstance().then((value) {
        pref = value;
        read();
        getSalesLoadingView();
      });

      super.initState();
    });
  }

  getAudio() async {
    player = await cache.play('Beep.mp3');
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

  Future _scanQR(int index, int ordQty) async {
    if (loadingViewRes[index].qr.length < ordQty) {
      try {
        loadingViewRes[index].qr ??= [];
        ScanResult result = await BarcodeScanner.scan();
        print(codeFormat =
            result.format.toString() == "qr" ? "QR Code" : "Bar Code");

        if (result.rawContent != "") {
          // showDialog(
          //   context: context,
          //   builder: (context) => AlertDialog(
          //       title: Text("$codeFormat Selected"),
          //       content: Text("Code : ${result.rawContent}.")),
          // );
          getAudio();
          loadingViewRes[index].qr.add(result.rawContent);
        } else {
          showDialog(
              context: context,
              builder: (context) =>
                  AlertDialog(title: Text("Code Selection Cancelled")));
          // results = "Code Selection Cancelled";
        }
      } on PlatformException catch (e) {
        ScanResult(
          type: ResultType.Error,
          format: BarcodeFormat.unknown,
        );

        if (e.code == BarcodeScanner.cameraAccessDenied) {
          setState(() {
            'The user did not grant the camera permission!'; // TODO: directly show popup
          });
        } else {
          'Unknown error: $e'; // TODO: directly show popup
        }
      }
      setState(() {});
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                  title: Text(
                "Loaded quantity must be less than or equal ordered quantity",
                style: TextStyle(color: Colors.red),
              )));
      print("too large");

      // print(".llll......");
    }
  }

  //get Sales Loading View
  getSalesLoadingView() async {
    var res = await http.get(
        "${Env.baseUrl}TsalesOrderHeaders/${this.widget.id}/3" as Uri,
        headers: {'Authorization': user.user['token']});
    print(".....data...");
    print(res.body);
    print(".....data...${res.statusCode}");
    if (json.decode(res.body).containsKey("msg")) {
      print("exist...........");
    } else {
      print("not exist..");
    }

    if (res.statusCode == 200 || res.statusCode == 201) {
      setState(() {
        var c = json.decode(res.body);
        print("data......");
        print(c);

        print(c['details']['data']);
        List<dynamic> t = c['details']['data'];

        // print(t);
        loadingViewRes =
            t.map((t) => SalesOrderLoadingViewRes.fromJson(t)).toList();
        print(loadingViewRes);

        showProgress = false;
      });
    } else {
      print("too large");
    }
  }

  // save into loading view
  saveSalesLoadingView() async {
    barCodes.clear();
    // bool checkList = false;
    loadingViewRes.asMap().forEach((i, rece) {
      print("...");
      print(rece.qr);
      // print(rece.tldItemId);
      print("...");

      if (rece.qr.length <= 0) {
        print("array is empty");
        // print(rece.tldQty);
        // checkList = true;
        print(rece.qr.length);

        print(rece.sdItemId);
      } else {
        print("array List is");
        print(rece.qr.length);
        print(rece.sdItemId);

        // print(rece.tldItemId);
        // detailsBarCode = RelSalesLoadingBarcodeDetails(slbBarcode: rece.qr.toString());
        detailsBarCodes.clear();

        detailsBarCode = RelSalesLoadingBarcodeDetails(
             // SlbLoadingDetailsId:loadingViewRes.indexWhere((element)
             // => rece.sdItemId == element.sdItemId)+1

            slbBarcode:rece.qr.toString()
            // tldItemId: rece.sdItemId,
            // tldQty: double.parse(rece.qr.length.toString()),
            // relSalesLoadingBarcodeDetails: detailsBarCodes
          // [
          //   RelSalesLoadingBarcodeDetails(
          //       SlbLoadingDetailsId:1 ,
          //       slbBarcode: rece.qr.toString())
          // ]

        );
        detailsBarCodes.add(detailsBarCode!);






        barCode = SalesLoadingViewPostData(
            tldItemId: rece.sdItemId,
            tldQty: double.parse(rece.qr.length.toString()),
            relSalesLoadingBarcodeDetails:
            rece.qr.map((e) =>
             RelSalesLoadingBarcodeDetails(
                SlbLoadingDetailsId:loadingViewRes.indexWhere((e)=>
                e.qr == rece.qr
                )+1 ,
                 slbBarcode: e.toString()
             )
            ).toList()
          // [
          //   // detailsBarCodes.map((e) =>
          //   //     {'slbBarcode':e.slbBarcode}.toList()
          //   // )
          //     RelSalesLoadingBarcodeDetails(
          //         slbBarcode: rece.qr.toString())
          //   ]

        );

        barCodes.add(barCode!);
      }
    });
    if (barCodes.length > 0) {
      prs = new ProgressDialog(
        context,
        type: ProgressDialogType.Normal,
        isDismissible: true,
        showLogs: true,
      );
      prs.style(
        message: "Adding Data", //
//      progress: 0.0,
//      maxProgress: 100.0,
      );

      prs.show();
      var req = {
        "tlhSalesOrderHeaderId": widget.id,
        "tsalesloadingDetails": barCodes
      };
      print(req);
      var params = json.encode(req);
      print(params);


      // return;
      var res = await http.post("${Env.baseUrl}TsalesloadingHeaders" as Uri,
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
            'Authorization': user.user['token']
          },
          body: params);
      print(res.statusCode);
      if (res.statusCode == 200 || res.statusCode == 201) {
        print(res.body);
        prs.hide();

        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                    title: Text(
                  "Data Updated ",
                  // style: TextStyle(color: Colors.red),
                )));
        prs.hide();

        Timer(Duration(seconds: 2), () {
          print("Yeah, this line is printed after 2 seconds");

          Navigator.pop(context);
        });


      }
      else{
        // prs.hide();
      }
      prs.hide();

    } else {
      print("item Qr code is empty");
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                  title: Text(
                "Please Scan Code with Items",
                style: TextStyle(color: Colors.red),
              )));
    }

    // "tlhDate": "2020-09-15T00:00:00",
    // "lthTime": "10:10:12",
    // "tsalesloadingDetails": [
    // {
    // "tldItemId": 31,
    // "tldQty": 2.0,
    // "relSalesLoadingBarcodeDetails": [
    // {
    // "SlbBarcode":"BC101"
    // },
    // {
    // "SlbBarcode":"BC102"
    // }
    // ]
    // },
    // {
    // "tldItemId": 32,
    // "tldQty": 15.0,
    // "relSalesLoadingBarcodeDetails": [
    // {
    // "SlbBarcode":"BC201"
    // },
    // {
    // "SlbBarcode":"BC202"
    // },
    // {
    // "SlbBarcode":"BC202"
    // }
    // ]
    // }
    // ]

    print("func");

    // if (checkList) {
    //   print("item Qr code is empty");
    //   showDialog(
    //       context: context,
    //       builder: (context) => AlertDialog(
    //               title: Text(
    //             "Please Scan Code with Items",
    //             style: TextStyle(color: Colors.red),
    //           )));
    // } else {
    //   var req = {
    //     "tlhSalesOrderHeaderId": widget.id,
    //     "tsalesloadingDetails": barCodes
    //   };
    //   var params = json.encode(req);
    //   print(params);
    //
    //   var res = await http.post("${Env.baseUrl}TsalesloadingHeaders",
    //       headers: {
    //         'content-type': 'application/json',
    //         'accept': 'application/json',
    //         'Authorization': user.user['token']
    //       },
    //       body: params);
    //   print(res.statusCode);
    //   if (res.statusCode == 200 || res.statusCode == 201) {
    //     print(res.body);
    //
    //     showDialog(
    //         context: context,
    //         builder: (context) => AlertDialog(
    //                 title: Text(
    //               "Data Updated ",
    //               // style: TextStyle(color: Colors.red),
    //             )));
    //   }
    // }
  }

  Widget continueButton = TextButton(
    child: Text("Continue"),
    onPressed: () {},
  );

  openDialog(int i) {
    int len = 0;
    len = loadingViewRes[i].sdQty.round();
    print(len);
    print(loadingViewRes[i].qr.length);
    // Widget ee = ;
    totalIndex = i;
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, menu) {
              return AlertDialog(
                content: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Visibility(
                      visible: loadingViewRes[i].qr.length > 0,
                      child: Container(
                        // margin:EdgeInsets.symmetric(vertical: 0,horizontal: 10.0) ,
                        child: DataTable(
                          columnSpacing: 12,
                          onSelectAll: (b) {},
                          //
                          sortAscending: true,
                          columns: <DataColumn>[
                            DataColumn(label: Text('')),
                            DataColumn(label: Text('#')),
                            DataColumn(label: Text('QR/BarCode')),
                          ],
                          rows: loadingViewRes[i]
                              .qr
                              .asMap()
                              .map(
                                (index, qr) {
                                  // bool showTooltip = false;
                                  // bool toolTipHide = true;
                                  // newIndex =index;
                                  return MapEntry(
                                      index,
                                      DataRow(
                                        selected: true,
                                        cells: [
                                          DataCell(
                                            Stack(
                                              alignment: Alignment.topLeft,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      loadingViewRes[i]
                                                          .qr
                                                          .removeAt(index);
                                                      menu(
                                                          () {}); // s = setState
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.delete,
                                                    size: 20,
                                                  ),
                                                  // iconSize: 20,
                                                ),
                                              ],
                                            ),
                                            onTap: () {
                                              loadingViewRes[index]
                                                  .qr
                                                  .removeAt(i);
                                              menu(() {}); // s = setState
                                            },
                                            showEditIcon: false,
                                            placeholder: false,
                                          ),
                                          DataCell(
                                            // newIndex == index + 1
                                            //     ? SimpleTooltip(
                                            //         maxHeight: 75,
                                            //         maxWidth: 75,
                                            //         tooltipTap: () {
                                            //           setState(() {
                                            //             print("deleted");
                                            //             loadingViewRes[totalIndex]
                                            //                 .qr
                                            //                 .removeAt(index);
                                            //             print("deleted");
                                            //             print("Tooltip tap");
                                            //             print(index + 1);
                                            //
                                            //             showTooltip = false;
                                            //           });
                                            //           // s(() {
                                            //
                                            //
                                            //             // newIndex =index+1;
                                            //           // });
                                            //         },
                                            //         hideOnTooltipTap: true,
                                            //         animationDuration:
                                            //             Duration(seconds: 2),
                                            //         show: showTooltip,
                                            //   // minHeight: 2.0,
                                            //         tooltipDirection:
                                            //             TooltipDirection.right,
                                            //         child: Container(
                                            //           width: 20,
                                            //           height: 20,
                                            //           child: GestureDetector(
                                            //             onTap: () {
                                            //
                                            //               print(
                                            //                   "Index is ${index + 1}");
                                            //             },
                                            //             child: Text((index + 1)
                                            //                 .toString()),
                                            //           ),
                                            //         ),
                                            //
                                            //         content:
                                            //         Stack(
                                            //           children: [
                                            //             FlatButton(
                                            //               onPressed: (){
                                            //                 setState(() {
                                            //                   print("deleted");
                                            //
                                            //                 });
                                            //               },
                                            //               child:  Icon(Icons.delete,
                                            //                 size: 30,
                                            //                 color: Colors.brown,
                                            //               ),
                                            //             ),
                                            //
                                            //             // SizedBox(width: 40,)
                                            //
                                            //           ],
                                            //
                                            //         ),
                                            //
                                            //         // IconButton(
                                            //         //   padding: EdgeInsets.all(4.0),
                                            //         //   onPressed: () {
                                            //         //     setState(() {
                                            //         //       loadingViewRes[i]
                                            //         //           .qr
                                            //         //           .removeAt(index);
                                            //         //       menu(() {}); // s = setState
                                            //         //     });
                                            //         //   },
                                            //         //   icon: Icon(Icons.delete),
                                            //         //   iconSize: 2,
                                            //         // ),
                                            //
                                            //
                                            //         // Text(
                                            //         //   "Index is ${index + 1}........",
                                            //         //   style: TextStyle(
                                            //         //     color: Colors.black,
                                            //         //     fontSize: 18,
                                            //         //     decoration:
                                            //         //         TextDecoration.none,
                                            //         //   ),
                                            //         // )
                                            // )
                                            //     :
                                            Text((index + 1).toString()),
                                            onTap: () {
                                              setState(() {
                                                print(showTooltip);
                                                showTooltip = true;
                                                print(index + 1);
                                                newIndex = index + 1;

                                                noButton = TextButton(
                                                  child: Text("No"),
                                                  onPressed: () {
                                                    setState(() {
                                                      print("No...");
                                                      Navigator.pop(
                                                          context); // this is proper..it will only pop the dialog which is again a screen
                                                    });
                                                  },
                                                );

                                                yesButton = TextButton(
                                                  child: Text("Yes"),
                                                  onPressed: () {
                                                    setState(() {
                                                      print("yes...");
                                                      loadingViewRes[i]
                                                          .qr
                                                          .removeAt(index);
                                                    });
                                                    Navigator.pop(
                                                        context); // this is proper..it will only pop the dialog which is again a screen
                                                  },
                                                );
                                                // showDialog(
                                                //     context: context,
                                                //     builder: (context) => AlertDialog(
                                                //         content: Text(
                                                //             "Do you want to delete ?"),
                                                //         actions: [
                                                //           yesButton,
                                                //           noButton
                                                //         ]));
                                                if (newIndex == index + 1) {
                                                  showTooltip = true;
                                                } else {
                                                  showTooltip = false;
                                                }
                                                print(showTooltip);
                                              });
                                            },
                                            showEditIcon: false,
                                            placeholder: false,
                                          ),
                                          DataCell(
                                            Text(qr),
                                            onTap: () {
                                              print("QR Code: $qr");
                                            },
                                            showEditIcon: false,
                                            placeholder: false,
                                          ),
                                        ],
                                      ));
                                },
                              )
                              .values
                              .toList(),
                          // rows: const <DataRow>[
                          //   DataRow(cells: <DataCell>[
                          //     DataCell(Text('Sarah')),
                          //     DataCell(Text('19')),
                          //     DataCell(Text('Student')),
                          //   ]),
                          //   DataRow(cells: <DataCell>[
                          //     DataCell(Text('Sarah')),
                          //     DataCell(Text('19')),
                          //     DataCell(Text('Student')),
                          //   ]),
                          //   DataRow(cells: <DataCell>[
                          //     DataCell(Text('Sarah')),
                          //     DataCell(Text('19')),
                          //     DataCell(Text('Student')),
                          //   ])
                          // ],
                        ),
                      ),
                    ),
                  ),
                ),
                actions: [
                  // Scanning view

                  // Loading View
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          print("ok");
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.lightBlueAccent,
                          ),
                          width: 30,
                          height: 30,
                          child: Center(
                            child: Text(
                              "ok",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 165,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 0,
                            height: 50,
                          ),
                          IconButton(
                              onPressed: () async {
                                print(loadingViewRes[i].sdQty);
                                print(loadingViewRes[i].qr.length);
                                print("....");
                                print(len);

                                if (loadingViewRes[i].qr.length <= len) {
                                  print("Scanning");

                                  await _scanQR(i, len);
                                  menu(() {});
                                } else {
                                  print("quantity too large");
                                }
                              },
                              icon: Icon(Icons.camera_alt,
                                  color: Colors.lightBlueAccent),
                              iconSize: 30,
                              tooltip: "QR / BarCode Scan"),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      )
                    ],
                  )
                ],
                backgroundColor: Colors.white,
                title: Center(
                  child: Text(
                    loadingViewRes[i].itemName,
                    style: TextStyle(fontSize: 13),
                  ),
                ),

                // content:IconButton(
                //   onPressed: () {
                //     print("scanning...");
                //     _scanQR();
                //
                //
                //
                //   },
                //   icon: Icon(
                //     Icons.camera_alt,
                //     // color: Colors.,
                //   ),
                //   iconSize: 20,
                //   tooltip: "QR Code Scan",
                // )
              );
            }));
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
                          "Sales View",
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

          body: SizedBox(
            height: double.maxFinite,
            child: showProgress ?
            Container(
              child:Center(child: CircularProgressIndicator()),


            ):
            SingleChildScrollView(
              child: loadingViewRes.length > 0
                  ? Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Visibility(
                                  visible: loadingViewRes.length > 0,
                                  child: DataTable(
                                    columnSpacing: 13,
                                    onSelectAll: (b) {},
                                    sortAscending: true,
                                    columns: <DataColumn>[
                                      DataColumn(
                                        label: Text('#'),
                                      ),
                                      DataColumn(
                                        label: Text('Item'),
                                      ),
                                      DataColumn(
                                        label: Text('Ord.Qty'),
                                      ),
                                      DataColumn(
                                        label: Text('Loaded Qty'),
                                      ),
                                      DataColumn(
                                        label: Text('BarCode'),
                                      ),
                                    ],
                                    rows: loadingViewRes
                                        .asMap()
                                        .map(
                                          (index, itemRow) => MapEntry(
                                              index,
                                              DataRow(
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
                                                        (index + 1).toString()),
                                                    onTap: () {},
                                                    showEditIcon: false,
                                                    placeholder: false,
                                                  ),
                                                  DataCell(
                                                    Text(itemRow.itemName
                                                        .toString()),
                                                    onTap: () {
                                                      print(
                                                          "hi : ${itemRow.itemName}");
                                                    },
                                                    showEditIcon: false,
                                                    placeholder: false,
                                                  ),
                                                  DataCell(
                                                    Text(itemRow.sdQty
                                                        .toString()),
                                                    onTap: () {
                                                      print("hi" +
                                                          itemRow.sdQty
                                                              .toString());

                                                      // do whatever you want
                                                    },
                                                    showEditIcon: false,
                                                    placeholder: false,
                                                  ),
                                                  DataCell(
                                                    Text(
                                                      "${loadingViewRes[index].qr.length}",
                                                    ),
                                                    onTap: () {},
                                                    // Text(getItemIndex(itemRow).toString()),
                                                    showEditIcon: false,
                                                    placeholder: false,
                                                  ),
                                                  DataCell(
                                                    IconButton(
                                                      onPressed: () {
                                                        openDialog(index);
                                                        print(loadingViewRes[
                                                                index]
                                                            .qr
                                                            .length);
                                                      },
                                                      icon: Icon(Icons.scanner),
                                                      // please test this once
                                                      iconSize: 20,
                                                    ),
                                                    onTap: () {},
                                                    // Text(getItemIndex(itemRow).toString()),
                                                    showEditIcon: false,
                                                    placeholder: false,
                                                  ),
                                                ],
                                              )),
                                        )
                                        .values
                                        .toList(),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: 20,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                print("save");
                                saveSalesLoadingView();
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.lightBlueAccent,
                                  ),
                                  height: 50,
                                  width: 340,
                                  child: Center(
                                    child: Text(
                                      "Save",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )),
                            )
                          ],
                        )
                      ],
//            verticalDirection: VerticalDirection.down,
//            crossAxisAlignment: CrossAxisAlignment.start,
                    )
                  : Visibility(
                      visible: loadingViewRes.length <= 0,
                      child: Center(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 150,
                              height: 500,
                            ),
                            Center(child: Text("No Data Found")),
                            SizedBox(
                              width: 50,
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          )),
    );
  }

  int getItemIndex(dynamic item) {
    int index = loadingViewRes.indexOf(item);
    return index + 1;
  }
}

class SalesLoad {
  String itemName;
  List<dynamic> qrCodes = [];

  SalesLoad({required this.itemName, required this.qrCodes});
}
