// // //import 'package:flutter/cupertino.dart';
// // //import 'package:flutter/material.dart';
// // //
// // //enum DialogAction { yes, abort }
// // //
// // //class Dialog {
// // //  static Future<DialogAction> yesAbortDialog(
// // //    BuildContext context,
// // //    String title,
// // //    String body,
// // //  ) async{
// // //      final action = await showDialog(
// // //          context:context,
// // //          barrierDismissible: false,
// // //        builder: (BuildContext context){
// // //                return AlertDialog(
// // //                  shape: RoundedRectangleBorder(
// // //                    borderRadius: BorderRadius.circular(10),
// // //                  ),
// // //                  actions: [
// // //                    FlatButton(
// // //
// // //                    ),
// // //                  ],
// // //                );
// // //        }
// // //      );
// // //      return (action !=null )? action :DialogAction.abort;
// // //  }
// // //}
// //
// // import 'dart:convert';
// //
// // import 'package:flutter/material.dart';
// // import 'package:flutter_app/urlEnvironment/urlEnvironment.dart';
// // import 'package:flutter_typeahead/flutter_typeahead.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:shared_preferences/shared_preferences.dart';
// //
// // import 'models/userdata.dart';
// //
// // class dialogs extends StatefulWidget {
// //   @override
// //   _dialogsState createState() => _dialogsState();
// // }
// //
// // class _dialogsState extends State<dialogs> {
// //
// //
// //
// //
// //   final List<String> _items = ['One','Two', 'Three', 'Four','One','Two', 'Three', 'Four','One','Two', 'Three', 'Four'].toList();
// //   String _selection;
// //   SharedPreferences pref;
// //  dynamic user;
// //
// //   read() async {
// //     var v = pref.getString("userData");
// //     var c = json.decode(v);
// //     user = UserData.fromJson(c); // token gets this code user.user["token"]
// //     setState(() {
// //
// //     });
// //   }
// //
// //
// //
// //
// //   void initState() {
// //     _selection = _items.first;
// //
// //     SharedPreferences.getInstance().then((value) {
// //       pref = value;
// //      read();
// //       GetUnit();
// //
// //     super.initState();
// //   });
// //         }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final dropdownMenuOptions = _items
// //         .map((String a) =>
// //             new DropdownMenuItem<String>(value: a, child: new Text(a)))
// //         .toList();
// //     return SafeArea(
// //         child: Scaffold(
// //             resizeToAvoidBottomInset: false,
// // //      key: scaffoldKey,
// //             appBar: PreferredSize(
// //               preferredSize: Size.fromHeight(190.0),
// //               child: Container(
// //                 height: 80,
// //                 color: Colors.blue,
// //                 width: double.maxFinite,
// //                 child: Padding(
// //                   padding: const EdgeInsets.only(
// //                       //  bottom: 1,
// //                       right: 10,
// //                       left: 10),
// //                   child: Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       children: [
// //                         GestureDetector(
// //                             onTap: () {
// //                               print("hi");
// //                             },
// //                             child: Stack(
// //                               alignment: Alignment.center,
// //                               // fit: StackFit.expand,
// //                               children: [
// //                                 Center(
// //                                   child: Container(
// //                                     height: 60,
// //                                     width: 60,
// //                                     decoration: BoxDecoration(
// //                                         borderRadius:
// //                                             BorderRadius.circular(40.0),
// //                                         image: DecorationImage(
// //                                             image:
// //                                                 AssetImage("assets/icon1.jpg"),
// //                                             fit: BoxFit.fill)),
// //                                     margin: new EdgeInsets.only(
// //                                         left: 0.0,
// //                                         top: 5.0,
// //                                         right: 0.0,
// //                                         bottom: 0.0),
// //                                     child: Align(
// //                                       alignment: Alignment.center,
// //                                       child: Center(
// //                                         child: Text(
// //                                           "",
// //                                           style: TextStyle(
// //                                               fontSize: 10, color: Colors.red),
// //                                         ),
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 )
// //                               ],
// //                             )),
// //                         GestureDetector(
// //                           onTap: () {
// //                             print("hi");
// //                           },
// //                           child: Container(
// //                               margin: EdgeInsets.only(top: 10, bottom: 15),
// //                               child: Column(children: [
// //                                 SizedBox(
// //                                   height: 7,
// //                                 ),
// //                                 Expanded(
// //                                   child: Text(
// //                                     "Sales",
// //                                     style: TextStyle(
// //                                         fontSize: 22, color: Colors.white),
// //                                   ),
// //                                 ),
// //                                 Expanded(
// //                                   child: Padding(
// //                                     padding: const EdgeInsets.only(top: 7),
// //                                     child: Text(
// //                                       "branchName",
// //                                       style: TextStyle(
// //                                           fontSize: 13, color: Colors.white),
// //                                     ),
// //                                   ),
// //                                 ),
// //                               ])),
// //                         ),
// //                         GestureDetector(
// //                           onTap: () {
// //                             Widget noButton = FlatButton(
// //                               child: Text("No"),
// //                               onPressed: () {
// //                                 setState(() {
// //                                   print("No...");
// //                                   Navigator.pop(
// //                                       context); // this is proper..it will only pop the dialog which is again a screen
// //                                 });
// //                               },
// //                             );
// //
// //                             Widget yesButton = FlatButton(
// //                               child: Text("Yes"),
// //                               onPressed: () {
// //                                 setState(() {
// //                                   print("yes...");
// //
// //                                   Navigator.pop(context); //okk
// // //                              Navigator.pop(context);
// //                                   Navigator.pushReplacementNamed(
// //                                       context, "/logout");
// //
// // //                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()),);
// //                                 });
// //                               },
// //                             );
// //                             showDialog(
// //                                 context: context,
// //                                 builder: (c) => AlertDialog(
// //                                     content:
// //                                         Text("Do you really want to logout?"),
// //                                     actions: [yesButton, noButton]));
// //                           },
// //                           child: Container(
// //                             margin: new EdgeInsets.only(
// //                                 left: 0.0, top: 25.0, right: 0.0, bottom: 0.0),
// //                             child: Text(
// //                               "userName",
// //                               style:
// //                                   TextStyle(fontSize: 13, color: Colors.white),
// //                             ),
// //                           ),
// //                         )
// //                       ]),
// //                 ),
// //               ),
// //             ),
// //             body: ListView(
// //                 shrinkWrap: true, // new line
// //                 physics: NeverScrollableScrollPhysics(),
// //                 children: <Widget>[
// //                   SizedBox(height: 10),
// //                   Row(children: [
// //
// //
// //                     new DropdownButton<String>(
// //                         dropdownColor: Colors.blue,
// //                         underline: Container(),
// //                         value: _selection,
// //                         iconSize: 0.0,
// //                         items: dropdownMenuOptions,
// //                         onChanged: (s) {
// //                           setState(() {
// //                             _selection = s;
// //                             print(_selection);
// //                           });
// //                         }),
// //
// //
// //                     Container(
// //                       width: 100,
// //                         height: 100,
// //                         child: TypeAheadField(
// //                             textFieldConfiguration: TextFieldConfiguration(
// //                               controller:UnitController ,
// //                               style: TextStyle(),
// //                               decoration: InputDecoration(
// //                               //  errorStyle: TextStyle(color: Colors.red),
// //                                // errorText: unitSelect
// //                                 //    ? "Invalid Unit Selected"
// //                                  //   : null,
// //                                 // suffixIcon: IconButton(
// //                                 //   icon: Icon(Icons.remove_circle),
// //                                 //   color: Colors.blue,
// //                                 //   onPressed: () {
// //                                 //     setState(() {
// //                                 //       print("cleared");
// //                                 //       UnitController.text = "";
// //                                 //       //  salesPaymentId = 0;
// //                                 //     });
// //                                 //   },
// //                                 // ),
// //                                 isDense: true,
// //                                 contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20, 16.0),
// //                                 // border: OutlineInputBorder(
// //                                 //     borderRadius: BorderRadius.circular(14.0)),
// //
// //                                 hintStyle: TextStyle(color: Colors.black, fontSize: 15),
// //                                 labelText: "Unit",
// //                               ),
// //                             ),
// //
// //                             suggestionsBoxDecoration:
// //                             SuggestionsBoxDecoration(elevation: 90.0),
// //                             suggestionsCallback: (pattern) {
// // //                        print(payment);
// //                               return unit.where((unt) => unt.description.contains(pattern));
// //                             },
// //                             itemBuilder: (context, suggestion) {
// //                               return Card(
// //                                 color: Colors.white,
// //                                 child: ListTile(
// //                                   title: Text(
// //                                     suggestion.description,
// //                                     style: TextStyle(color: Colors.black),
// //                                   ),
// //                                 ),
// //                               );
// //                             },
// //                             onSuggestionSelected: (suggestion) {
// //                               print(suggestion.description);
// //                               print("Unit selected");
// //
// //                               UnitController.text = suggestion.description;
// //                               print("close.... $unitId");
// //                               unitId = 0;
// //
// //                               print(suggestion.id);
// //                               print(".......Unit id");
// //                               unitId = suggestion.id;
// //                               print(unitId);
// //                               print("...........");
// //                             },
// //                             errorBuilder: (BuildContext context, Object error) =>
// //                                 Text('$error',
// //                                     style: TextStyle(
// //                                         color: Theme.of(context).errorColor)),
// //                             transitionBuilder:
// //                                 (context, suggestionsBox, animationController) =>
// //                                 FadeTransition(
// //                                   child: suggestionsBox,
// //                                   opacity: CurvedAnimation(
// //                                       parent: animationController,
// //                                       curve: Curves.elasticIn),
// //                                 ))),
// //
// //                   ])
// //                 ])));
// //   }
// //
// //   TextEditingController UnitController = new TextEditingController();
// //
// // int   unitId = 0;
// //   static List<unitlist> unit = new List<unitlist>();
// //   dynamic  units=[];
// //   GetUnit() async {
// //     String url = "${Env.baseUrl}GtUnits";
// //     try {
// //       final res =
// //       await http.get(url, headers: {"Authorization": user.user["token"]});
// //       print("Units");
// //       List<dynamic> tagsJson = json.decode(res.body)['gtunit'];
// //      // List<UnitType> ut = tagsJson.map((tagsJson) => UnitType.fromJson(tagsJson)).toList();
// //       List<unitlist> ut = tagsJson.map((tagsJson) => unitlist.fromJson(tagsJson)).toList();
// //       print(tagsJson.length);
// //      unit = ut;
// //
// //     } catch (e) {
// //       print("error on  unit= $e");
// //     }
// //   }
// //
// //
// //
// //
// // }
// // class unitlist {
// //   String description;
// //   int id;
// //
// //
// //
// //   unitlist({this.description,this.id});
// //
// //   factory unitlist.fromJson(Map<String, dynamic> parsedJson){
// //     return unitlist(
// //
// //       description:parsedJson["description"],
// //       id:parsedJson["id"],
// //
// //     );
// //   }
// // }
//
//
//
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_app/urlEnvironment/urlEnvironment.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'models/userdata.dart';
//
//   @override
//   SharedPreferences pref;
//  dynamic user;
//
//   read() async {
//     var v = pref.getString("userData");
//     var c = json.decode(v);
//     user = UserData.fromJson(c); // token gets this code user.user["token"]
//
//   }
//
//
//
//
//   void initState() {
//     SharedPreferences.getInstance().then((value) {
//       pref = value;
//      read();
//   });
//         }
//
//
//
//
//     Widget appbar(BuildContext context, String title , String userneme,String customer,) {
//       return  PreferredSize(
//         preferredSize: Size.fromHeight(190.0),
//         child: Container(
//           height: 80,
//           color: Colors.blue,
//           width: double.maxFinite,
//           child: Padding(
//             padding: const EdgeInsets.only(
//               //  bottom: 1,
//                 right: 10,
//                 left: 10
//             ),
//             child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//
//                   GestureDetector(
//                       onTap: () {
//                         print("hi");
//                       },
//                       child: Stack(
//                         alignment: Alignment.center,
//                         // fit: StackFit.expand,
//                         children: [
//                           Center(
//                             child: Container(
//
//                               height: 60,
//                               width: 60,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(40.0),
//                                   image: DecorationImage(
//                                       image: AssetImage("assets/icon1.jpg"),
//                                       fit: BoxFit.fill
//                                   )
//                               ),
//                               margin: new EdgeInsets.only(
//                                   left: 0.0, top: 5.0, right: 0.0, bottom: 0.0),
//                               child: Align(alignment: Alignment.center,
//                                 child: Center(
//                                   child: Text(
//                                     "",
//                                     style: TextStyle(fontSize: 10, color: Colors.red),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           )
//                         ],
//                       )
//                   ),
//
//
//
//                   GestureDetector(
//                     onTap: () {
//                       print("hi");
//                     },
//                     child: Container(
//                         margin: EdgeInsets.only(
//                             top: 10,
//                             bottom: 15
//                         ),
//                         child: Column(children:[
//                           SizedBox(height: 7,),
//                           Expanded(
//                             child: Text(
//                               (title),
//                               style: TextStyle(fontSize: 22, color: Colors.white),
//                             ),
//                           ),
//
//
//                           Expanded(
//                             child: Padding(
//                               padding: const EdgeInsets.only(top: 7),
//                               child: Text(
//                                 (userneme),
//
//                                 style: TextStyle(fontSize: 13, color: Colors.white),
//                               ),
//                             ),
//                           ),
//                         ])
//                     ),
//                   ),
//
//
//
//
//                   GestureDetector(
//                     onTap: () {
//                       Widget noButton = FlatButton(
//                         child: Text("No"),
//                         onPressed: () {
//                           print("No...");
//
//
//                           // setState(() {
//                           //   print("No...");
//                           //   Navigator.pop(
//                           //       context); // this is proper..it will only pop the dialog which is again a screen
//                           // });
//                         },
//                       );
//
//                       Widget yesButton = FlatButton(
//                         child: Text("Yes"),
//                         onPressed: () {
//                           read();
//
//                             print("yes...");
//                             pref.remove('userData');
//                             Navigator.pop(context); //okk
// //                              Navigator.pop(context);
//                             Navigator.pushReplacementNamed(
//                                 context, "/logout");
//
// //                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()),);
//
//                         },
//                       );
//                       showDialog(
//                           context: context,
//                           builder: (c) => AlertDialog(
//                               content: Text("Do you really want to logout?"),
//                               actions: [yesButton, noButton]));
//                     },
//                     child: Container(
//                       margin: new EdgeInsets.only(
//                           left: 0.0, top: 25.0, right: 0.0, bottom: 0.0),
//                       child: Text(
//                         (customer),
//
//                         style: TextStyle(fontSize: 13, color: Colors.white),
//                       ),
//                     ),
//                   )
//                 ]),
//           ),
//         ),
//       );
//     }
//
//
//






//......................test screen....................................................................






// //import 'package:barcode_scan/barcode_scan.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_app/dialogs.dart';
// // import 'package:simple_tooltip/simple_tooltip.dart';
//
// //import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// //import 'package:fluttertoast/fluttertoast.dart';
// //import 'package:cloud_firestore/cloud_firestore.dart';
//
//
// import 'package:permission_handler/permission_handler.dart';
//
//
//
//
// class TestScreen extends StatefulWidget {
//   @override
//   _TestScreenState createState() => _TestScreenState();
// }
//
// class _TestScreenState extends State<TestScreen> {
//   dynamic _message = '';
//   bool _show = false;
//   bool hideOnTap = false;
//   // TooltipDirection _direction = TooltipDirection.down;
//   bool _changeBorder = false;
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//
//
//
//   // _register() {
//   //   _firebaseMessaging.getToken().then((token) => print(token));
//   // }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     print("data");
// //    getMessage();
// //    fcmInIt();
//
//   }
//
//
//
//
//
// //  void fcmInIt() {
// //    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
// //    _firebaseMessaging.configure(
// //      onMessage: (Map<String, dynamic> message) async {
// //        print("onMessage: $message");
// ////        _showItemDialog(message);
// //      },
// ////      onBackgroundMessage: myBackgroundMessageHandle,
// //      onLaunch: (Map<String, dynamic> message) async {
// //        print("onLaunch: $message");
// ////        _navigateToItemDetail(message);
// //      },
// //      onResume: (Map<String, dynamic> message) async {
// //        print("onResume: $message");
// ////        _navigateToItemDetail(message);
// //      },
// //    );
// //  }
//
//   void getMessage() {
//     _firebaseMessaging.configure(
//         onMessage: (Map<String, dynamic> message) async {
//           print('on message $message');
//           setState(() => _message = message["notification"]["title"]);
//         }, onResume: (Map<String, dynamic> message) async {
//       print('on resume $message');
//       setState(() => _message = message["notification"]["title"]);
//     }, onLaunch: (Map<String, dynamic> message) async {
//       print('on launch $message');
//       setState(() => _message = message["notification"]["title"]);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return SafeArea(
//       child: Scaffold(
//       //  appBar: appbar(context, 'Test page',"j","f"),
//         body: Center(
//           child: Container(
//             child: Column(
//               children: <Widget>[
//                 RaisedButton(
//                   child: Text("toogle: $_show"),
//                   onPressed: () {
//                     setState(() {
//                       _show = !_show;
//                     });
//                   },
//                 ),
//                 RaisedButton(
//                   child: Text("change direction"),
//                   onPressed: () {
//                     setState(() {
//                       // switch (_direction) {
//                       //   case TooltipDirection.up:
//                       //     _direction = TooltipDirection.right;
//                       //     break;
//                       //   case TooltipDirection.right:
//                       //     _direction = TooltipDirection.down;
//                       //     break;
//                       //   case TooltipDirection.down:
//                       //     _direction = TooltipDirection.left;
//                       //     break;
//                       //   case TooltipDirection.left:
//                       //     _direction = TooltipDirection.up;
//                       //     break;
//                       //   default:
//                       // }
//                     });
//                   },
//                 ),
//                 RaisedButton(
//                   child: Text("hideOnTap: $hideOnTap"),
//                   onPressed: () {
//                     setState(() {
//                       hideOnTap = !hideOnTap;
//                     });
//                   },
//                 ),
//                 RaisedButton(
//                   child: Text("change border: $hideOnTap"),
//                   onPressed: () {
//                     setState(() {
//                       _changeBorder = !_changeBorder;
//                     });
//                   },
//                 ),
//                 // Align(
//                 //   alignment: AlignmentDirectional.center,
//                 //   child: SimpleTooltip(
//                 //     show: _show,
//                 //     tooltipDirection: _direction,
//                 //     hideOnTooltipTap: hideOnTap,
//                 //     borderWidth: _changeBorder ? 0 : 3,
//                 //     child: Container(
//                 //       color: Colors.cyan,
//                 //       width: 80,
//                 //       height: 80,
//                 //     ),
//                 //     minWidth: 200,
//                 //     content: Container(
//                 //       width: 200,
//                 //       child: Text("content!"),
//                 //       color: Colors.blue,
//                 //     ),
//                 //     // routeObserver: MyApp.of(context).routeObserver,
//                 //   ),
//                 // ),
//                 RaisedButton(
//                   child: Text("New route"),
//                   onPressed: () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (ctx) {
//                           return Scaffold(
//                              appBar: AppBar(),
//                              body:Text("data")
//                           );
//                         },
//                       ),
//                     );
//                   },
//                 ),
//
//                 RaisedButton(
//                   child: Text("New route"),
//                   onPressed: () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (Context) {
//                           return SafeArea(
//                             child: Scaffold(
//                                  appBar: AppBar(),
//                                 // body:Text("data")
//                             ),
//                           );
//                         },
//                       ),
//                     );
//                   },
//                 ),
//
//
//               ],
//             ),
//           ),
//         ),
//
// //         body: Center(
// //           child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: <Widget>[
// //                 Text("Message: $_message"),
// //                 OutlineButton(
// //                   child: Text("Register My Device"),
// //                   onPressed: () {
// //                     _register();
// //                   },
// //                 ),
// // //                Column(
// // //                  children: [
// // //                    StreamBuilder()
// // //                  ],
// // //                ),
// //                 // Text("Message: $message")
// //               ]),
// //
// //         ),
//
//
//
//
//
//       ),
//     );
//   }
// }
//
// //import 'package:flutter/material.dart';
// //import 'package:progress_dialog/progress_dialog.dart';
// //
// //ProgressDialog pr;
// //
// //class TestScreen extends StatefulWidget {
// //  @override
// //  _TestScreenState createState() => _TestScreenState();
// //}
// //
// //class _TestScreenState extends State<TestScreen> {
// //  double percentage = 0.0;
// //
// //  @override
// //  Widget build(BuildContext context) {
// //    pr = new ProgressDialog(context, showLogs: true);
// //    pr.style(message: 'Please wait...');
// //
// //    return Scaffold(
// //      appBar: AppBar(
// //        title: Text("Page - 2"),
// //      ),
// //      body: SafeArea(
// //        child: Column(
// //          children: <Widget>[
// //            GridView.count(
// //              shrinkWrap: true,
// //              primary: true,
// //              crossAxisCount: 2,
// //              children: <Widget>[
// //                Container(
// //                  width: 40,
// //                  height: 50,
// //                  color: Colors.blue,
// //                  child: Center(
// //                    child: RaisedButton(
// //                      child: Text('Show dialog and go to next screen',
// //                          style: TextStyle(color: Colors.white)),
// //                      color: Colors.blueAccent,
// //                      onPressed: () {
// //                        pr.show();
// //                        Future.delayed(Duration(seconds: 10)).then((value) {});
// //                      },
// //                    ),
// //                  ),
// //                ),
// ////                SizedBox(width: 10,),
// //                Container(
// //                  width: 20,
// //                  height: 20,
// //                  color: Colors.blue,
// //                  child: RaisedButton(
// //                    child: Text("Hide...."),
// //                    color: Colors.blue,
// //                    onPressed: () {
// //                      pr.hide().whenComplete(() {});
// //                    },
// //                  ),
// //                ),
// //                Container(
// //                  color: Colors.blue,
// //                  child: RaisedButton(
// //                    onPressed: () {},
// //                  ),
// //                ),
// //                Container(
// //                  color: Colors.blue,
// //                  child: RaisedButton(
// //                    onPressed: () {},
// //                  ),
// //                ),
// //              ],
// //            ),
// ////            Divider(
// ////              color: Colors.grey.shade600,
// ////            ),
// ////            Center(
// ////              child: RaisedButton(
// ////                child: Text("Button"),
// ////                onPressed: (){},
// ////              ),
// ////            )
// //          ],
// //        ),
// //      ),
// //    );
// //  }
// //}
//
// //   autocomplete
//
// //                SimpleAutocompleteFormField<Customer>(
// //
// //                  controller: passController,
// ////                  autofocus: true,
// //                  decoration: InputDecoration(
// ////                      contentPadding:  EdgeInsets.all(3.0),
// //
// //                      labelText: 'Customer Search',
// //                      border: OutlineInputBorder()),
// //                  maxSuggestions: 10,
// //
// //                  suggestionsHeight: 100,
// ////maxLength: 10,
// ////                  minSearchLength: ,
// //
// //                  itemBuilder: (context, users) => Padding(
// //                    padding:const EdgeInsets.fromLTRB(20,30,30,30),
// ////                    margin: const EdgeInsets.only(right: 10, left: 10),
// //
// ////                    suggestions:10,
// ////                    child: Text(item),
// ////                    Text('Selected person: "$selectedPerson"'),
// //
// //                    child: Column(
// //                        crossAxisAlignment: CrossAxisAlignment.start,
// //                        children: [
// //                          Text(
// //                            users.lhName,
// //                          )
// //                          // ithu okk an
// //
// ////                          Text(user.lhName)
// //                        ]),
// //                  ),
// //                  keyboardType: TextInputType.multiline,
// //
// //                  onSearch: (search) async => users
// //                      .where((u) =>
// //                          u.lhName
// //                              .toLowerCase()
// //                              .contains(search.toLowerCase()) ||
// //                          u.lhName.toLowerCase().contains(search.toLowerCase()))
// //                      .toList(),
// //                  itemFromString: (string) => users.singleWhere(
// //                      (u) => u.lhName.toLowerCase() == string.toLowerCase(),
// //                      orElse: () => null),
// //                  onChanged: (u) => setState(() {
// ////                    print("close.... $salesLedgerId");
// ////
// ////                    print(u.id);
// ////
// ////                    print(".......");
// //
// //                    print(passController.text);
// //                    salesLedgerId = 0;
// ////                    print(paymentController.text);
// //                    print("close");
// //                    if (passController.text == "") {
// //                      print("hi.....");
// //                      passController.text = "";
// ////                        u.lhName ="Select Customer";
// //                      return;
// //                    }
// //
// //                    passController.text = u.lhName;
// //                    if (u.id != null) {
// //                      salesLedgerId = u.id;
// //                    }
// //
// //                    print(paymentController.text);
// //                    getCustomerLedgerBalance(u.id);
// //
// //                    print("..... sales payment id");
// //
// //                    print(salesPaymentId);
// //                    print(".....");
// //                  }),
// //                  onSaved: (u) => setState(() {
// ////                    print("close");
// //
// //                    selectedPerson = u.lhName;
// //                    passController.text = u.lhName;
// //
// //                    print(u);
// //                  }),
// //
// //                  validator: (u) =>
// //                      u.lhName == null || passController.text == ""
// //                          ? 'Invalid person.'
// //                          : null,
// //                ),
//
// // auto complete // above code
//
// // Qr Code or BarcodeScanner code below
//
// //import 'dart:async';
// //import 'dart:io' show Platform;
// //
// //import 'package:barcode_scan/barcode_scan.dart';
// //import 'package:flutter/material.dart';
// //import 'package:flutter/services.dart';
// //
// //void main() {
// //  runApp(_MyApp());
// //}
// //
// //class _MyApp extends StatefulWidget {
// //  @override
// //  _MyAppState createState() => _MyAppState();
// //}
// //
// //class _MyAppState extends State<_MyApp> {
// //  ScanResult scanResult;
// //
// //  final _flashOnController = TextEditingController(text: "Flash on");
// //  final _flashOffController = TextEditingController(text: "Flash off");
// //  final _cancelController = TextEditingController(text: "Cancel");
// //
// //  var _aspectTolerance = 0.00;
// //  var _numberOfCameras = 0;
// //  var _selectedCamera = -1;
// //  var _useAutoFocus = true;
// //  var _autoEnableFlash = false;
// //
// //  static final _possibleFormats = BarcodeFormat.values.toList()
// //    ..removeWhere((e) => e == BarcodeFormat.unknown);
// //
// //  List<BarcodeFormat> selectedFormats = [..._possibleFormats];
// //
// //  @override
// //  // ignore: type_annotate_public_apis
// //  initState() {
// //    super.initState();
// //
// //    Future.delayed(Duration.zero, () async {
// //      _numberOfCameras = await BarcodeScanner.numberOfCameras;
// //      setState(() {});
// //    });
// //  }
// //
// //  @override
// //  Widget build(BuildContext context) {
// //    var contentList = <Widget>[
// //      if (scanResult != null)
// //        Card(
// //          child: Column(
// //            children: <Widget>[
// //              ListTile(
// //                title: Text("Result Type"),
// //                subtitle: Text(scanResult.type?.toString() ?? ""),
// //              ),
// //              ListTile(
// //                title: Text("Raw Content"),
// //                subtitle: Text(scanResult.rawContent ?? ""),
// //              ),
// //              ListTile(
// //                title: Text("Format"),
// //                subtitle: Text(scanResult.format?.toString() ?? ""),
// //              ),
// //              ListTile(
// //                title: Text("Format note"),
// //                subtitle: Text(scanResult.formatNote ?? ""),
// //              ),
// //            ],
// //          ),
// //        ),
// //      ListTile(
// //        title: Text("Camera selection"),
// //        dense: true,
// //        enabled: false,
// //      ),
// //      RadioListTile(
// //        onChanged: (v) => setState(() => _selectedCamera = -1),
// //        value: -1,
// //        title: Text("Default camera"),
// //        groupValue: _selectedCamera,
// //      ),
// //    ];
// //
// //    for (var i = 0; i < _numberOfCameras; i++) {
// //      contentList.add(RadioListTile(
// //        onChanged: (v) => setState(() => _selectedCamera = i),
// //        value: i,
// //        title: Text("Camera ${i + 1}"),
// //        groupValue: _selectedCamera,
// //      ));
// //    }
// //
// //    contentList.addAll([
// //      ListTile(
// //        title: Text("Button Texts"),
// //        dense: true,
// //        enabled: false,
// //      ),
// //      ListTile(
// //        title: TextField(
// //          decoration: InputDecoration(
// //            hasFloatingPlaceholder: true,
// //            labelText: "Flash On",
// //          ),
// //          controller: _flashOnController,
// //        ),
// //      ),
// //      ListTile(
// //        title: TextField(
// //          decoration: InputDecoration(
// //            hasFloatingPlaceholder: true,
// //            labelText: "Flash Off",
// //          ),
// //          controller: _flashOffController,
// //        ),
// //      ),
// //      ListTile(
// //        title: TextField(
// //          decoration: InputDecoration(
// //            hasFloatingPlaceholder: true,
// //            labelText: "Cancel",
// //          ),
// //          controller: _cancelController,
// //        ),
// //      ),
// //    ]);
// //
// //    if (Platform.isAndroid) {
// //      contentList.addAll([
// //        ListTile(
// //          title: Text("Android specific options"),
// //          dense: true,
// //          enabled: false,
// //        ),
// //        ListTile(
// //          title:
// //          Text("Aspect tolerance (${_aspectTolerance.toStringAsFixed(2)})"),
// //          subtitle: Slider(
// //            min: -1.0,
// //            max: 1.0,
// //            value: _aspectTolerance,
// //            onChanged: (value) {
// //              setState(() {
// //                _aspectTolerance = value;
// //              });
// //            },
// //          ),
// //        ),
// //        CheckboxListTile(
// //          title: Text("Use autofocus"),
// //          value: _useAutoFocus,
// //          onChanged: (checked) {
// //            setState(() {
// //              _useAutoFocus = checked;
// //            });
// //          },
// //        )
// //      ]);
// //    }
// //
// //    contentList.addAll([
// //      ListTile(
// //        title: Text("Other options"),
// //        dense: true,
// //        enabled: false,
// //      ),
// //      CheckboxListTile(
// //        title: Text("Start with flash"),
// //        value: _autoEnableFlash,
// //        onChanged: (checked) {
// //          setState(() {
// //            _autoEnableFlash = checked;
// //          });
// //        },
// //      )
// //    ]);
// //
// //    contentList.addAll([
// //      ListTile(
// //        title: Text("Barcode formats"),
// //        dense: true,
// //        enabled: false,
// //      ),
// //      ListTile(
// //        trailing: Checkbox(
// //          tristate: true,
// //          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
// //          value: selectedFormats.length == _possibleFormats.length
// //              ? true
// //              : selectedFormats.length == 0 ? false : null,
// //          onChanged: (checked) {
// //            setState(() {
// //              selectedFormats = [
// //                if (checked ?? false) ..._possibleFormats,
// //              ];
// //            });
// //          },
// //        ),
// //        dense: true,
// //        enabled: false,
// //        title: Text("Detect barcode formats"),
// //        subtitle: Text(
// //          'If all are unselected, all possible platform formats will be used',
// //        ),
// //      ),
// //    ]);
// //
// //    contentList.addAll(_possibleFormats.map(
// //          (format) => CheckboxListTile(
// //        value: selectedFormats.contains(format),
// //        onChanged: (i) {
// //          setState(() => selectedFormats.contains(format)
// //              ? selectedFormats.remove(format)
// //              : selectedFormats.add(format));
// //        },
// //        title: Text(format.toString()),
// //      ),
// //    ));
// //
// //    return MaterialApp(
// //      debugShowCheckedModeBanner: false,
// //      home: Scaffold(
// //        appBar: AppBar(
// //          title: Text('Barcode Scanner Example'),
// //          actions: <Widget>[
// //            IconButton(
// //              icon: Icon(Icons.camera),
// //              tooltip: "Scan",
// //              onPressed: scan,
// //            )
// //          ],
// //        ),
// //        body: ListView(
// //          scrollDirection: Axis.vertical,
// //          shrinkWrap: true,
// //          children: contentList,
// //        ),
// //      ),
// //    );
// //  }
// //
// //  Future scan() async {
// //    try {
// //      var options = ScanOptions(
// //        strings: {
// //          "cancel": _cancelController.text,
// //          "flash_on": _flashOnController.text,
// //          "flash_off": _flashOffController.text,
// //        },
// //        restrictFormat: selectedFormats,
// //        useCamera: _selectedCamera,
// //        autoEnableFlash: _autoEnableFlash,
// //        android: AndroidOptions(
// //          aspectTolerance: _aspectTolerance,
// //          useAutoFocus: _useAutoFocus,
// //        ),
// //      );
// //
// //      var result = await BarcodeScanner.scan(options: options);
// //
// //      setState(() => scanResult = result);
// //    } on PlatformException catch (e) {
// //      var result = ScanResult(
// //        type: ResultType.Error,
// //        format: BarcodeFormat.unknown,
// //      );
// //
// //      if (e.code == BarcodeScanner.cameraAccessDenied) {
// //        setState(() {
// //          result.rawContent = 'The user did not grant the camera permission!';
// //        });
// //      } else {
// //        result.rawContent = 'Unknown error: $e';
// //      }
// //      setState(() {
// //        scanResult = result;
// //      });
// //    }
// //  }
// //}
//
// // Qr Code or BarcodeScanner code above
//