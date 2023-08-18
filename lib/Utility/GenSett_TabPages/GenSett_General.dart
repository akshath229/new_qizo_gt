// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_app/GT_Masters/AppTheam.dart';
// import 'package:flutter_app/Utility/GenSett_TabPages/GenSett_Model/GenSett_Model_Item_Product_Type.dart';
// import 'package:flutter_app/Utility/GenSett_TabPages/GenSett_Model/GenSett_Model_StockTypeStatics.dart';
// import 'package:flutter_app/models/userdata.dart';
// import 'package:flutter_app/urlEnvironment/urlEnvironment.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class GenSett_General extends StatefulWidget {
//
//   TextEditingController Item_Default_Stock_Type;
//   TextEditingController Item_Default_Product_Type;
//
//   bool Validation_Item_Default_Stock_Type;
//   bool Validation_Item_Default_Product_Type;
//
//   int Id_Item_Default_Stock_Type;
//   int Id_Item_Default_Product_Type;
//
//   bool Enable_master_index_page;
//   bool Enable_transaction_index_page;
//   bool Purchase_Tax_Inclusive;
//   bool Sales_TaxInclusive;
//   bool Batch_Expiry_applicable;
//   bool Show_Notes_Purchase_Or_Sales;
//   bool Enable_godown;
//   GenSett_General({
//     this.Item_Default_Stock_Type,
//     this.Show_Notes_Purchase_Or_Sales,
//     this.Validation_Item_Default_Stock_Type,
//     this.Batch_Expiry_applicable,
//     this.Enable_godown,
//     this.Enable_master_index_page,
//     this.Enable_transaction_index_page,
//     this.Id_Item_Default_Product_Type,
//     this.Id_Item_Default_Stock_Type,
//     this.Item_Default_Product_Type,
//     this.Purchase_Tax_Inclusive,
//     this.Sales_TaxInclusive,
//     this.Validation_Item_Default_Product_Type,
//   });
//
//   @override
//   _GenSett_GeneralState createState() => _GenSett_GeneralState();
// }
//
// class _GenSett_GeneralState extends State<GenSett_General> {
//
//
//     AppTheam theam =AppTheam();
//   static List<StockTypeStatics> _StkTyp = new List<StockTypeStatics>();
//
//   static List<ProductType> _prodTyp = new List<ProductType>();
//
//   void initState() {
//     setState(() {
//       SharedPreferences.getInstance().then((value) {
//         pref = value;
//         read();
//         GetStockTypeStatics();
//         GetProductTypeStatics();
//       });
//     });
//   }
//
//   SharedPreferences pref;
//   dynamic data;
//   dynamic branch;
//   var res;
//   dynamic user;
//   int branchId;
//   int userId;
//   UserData userData;
//   String branchName = "";
//   dynamic userName;
//   String token;
//   String DeviceId;
//
//
//
//
//   // //------------------for appbar------------
//   read() async {
//     var v = pref.getString("userData");
//     var c = json.decode(v);
//     user = UserData.fromJson(c); // token gets this code user.user["token"]
//     setState(() {
//       branchId = int.parse(c["BranchId"]);
//       token = user.user["token"]; //  passes this user.user["token"]
//       pref.setString("customerToken", user.user["token"]);
//       branchName = user.branchName;
//       userName = user.user["userName"];
//       userId = user.user["userId"];
//       DeviceId = user.deviceId;
//     });
//   }
//
//
//
//   GetStockTypeStatics()async{
// // print("in GetArea");
//     final _json= await http.get("${Env.baseUrl}MStockTypeStatics",
//         headers: {
//           "Authorization": user.user["token"],
//         }
//     ) ;
//
//     if(_json.statusCode==200||_json.statusCode==201){
//
//
//       List<dynamic> Json=jsonDecode(_json.body);
//       List<StockTypeStatics>jsondata =Json.map((Json) => StockTypeStatics.fromJson(Json)).toList();
//
//     _StkTyp=jsondata;
//
//     }
//
//
//   }
//
//
//     GetProductTypeStatics()async{
//
//       final _json= await http.get("${Env.baseUrl}MProductTypeStatics",
//           headers: {
//             "Authorization": user.user["token"],
//           }
//       ) ;
//
//       if(_json.statusCode==200||_json.statusCode==201){
//
//
//         List<dynamic> Json=jsonDecode(_json.body);
//         List<ProductType>jsondata =Json.map((Json) => ProductType.fromJson(Json)).toList();
//
//         _prodTyp=jsondata;
//
//       }
//
//
//     }
//
//
//   @override
//   Widget build(BuildContext context) {
//         return ListView(
//           shrinkWrap: true,
//           children: [
//
//
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TypeAheadField(
//                         textFieldConfiguration: TextFieldConfiguration(
//                             style: TextStyle(),
//                             controller: widget.Item_Default_Stock_Type,
//                             textInputAction: TextInputAction.next,
//                             decoration: InputDecoration(
//                               errorStyle: TextStyle(color: Colors.red),
//                               errorText: widget.Validation_Item_Default_Stock_Type
//                                   ? "Please Select Stock Type ?"
//                                   : null,
// //                            errorText: _validateName ? "please enter name" : null,
// //                            errorBorder:InputBorder.none ,
//                               suffixIcon: IconButton(
//                                 icon: Icon(Icons.remove_circle),
//                                 color: Colors.blue,
//                                 onPressed: () {
//                                   setState(() {
//                                     print("cleared");
//                                     widget.Item_Default_Stock_Type.text = "";
//                                     widget.Id_Item_Default_Stock_Type = null;
//
//                                   });
//                                 },
//                               ),
//
//                               isDense: true,
//                               contentPadding:
//                               EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10.0)),
//                               // i need very low size height
//                               labelText:
//                               'Item Default Stock Type', // i need to decrease height
//                             )),
//                         suggestionsBoxDecoration:
//                         SuggestionsBoxDecoration(elevation: 90.0),
//                         suggestionsCallback: (pattern) {
//                           return _StkTyp.where((user) =>
//                               user.stockType.toUpperCase().contains(pattern.toUpperCase()));
//                         },
//                         itemBuilder: (context, suggestion) {
//                           return Card(
//                             color:theam.DropDownClr,
//                             child: ListTile(
//                               // focusColor: Colors.blue,
//                               // hoverColor: Colors.red,
//                               title: Text(
//                                 suggestion.stockType,
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           );
//                         },
//                         onSuggestionSelected: (suggestion) {
//                           print(suggestion.stockType);
//                           print("selected");
//
//                           widget.Item_Default_Stock_Type.text = suggestion.stockType;
//                           print("close.... ${widget.Id_Item_Default_Stock_Type}");
//                           widget.Id_Item_Default_Stock_Type = null;
//
//                           print(suggestion.id);
//                           print("....... Id__Item_Default_Stock_Type");
//                           widget.Id_Item_Default_Stock_Type = suggestion.id;
//
//                           print(widget.Id_Item_Default_Stock_Type);
//                           print("...........");
//                         },
//                         errorBuilder: (BuildContext context, Object error) =>
//                             Text('$error',
//                                 style: TextStyle(
//                                     color: Theme.of(context).errorColor)),
//                         transitionBuilder:
//                             (context, suggestionsBox, animationController) =>
//                             FadeTransition(
//                               child: suggestionsBox,
//                               opacity: CurvedAnimation(
//                                   parent: animationController,
//                                   curve: Curves.elasticIn),
//                             )),
//                   ),
//                 ],
//               ),
//             ),
//
//
//
//
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TypeAheadField(
//                         textFieldConfiguration: TextFieldConfiguration(
//                             style: TextStyle(),
//                             controller: widget.Item_Default_Product_Type,
//                             textInputAction: TextInputAction.next,
//                             decoration: InputDecoration(
//                               errorStyle: TextStyle(color: Colors.red),
//                               errorText: widget.Validation_Item_Default_Product_Type
//                                   ? "Please Select Product Type ?"
//                                   : null,
// //                            errorText: _validateName ? "please enter name" : null,
// //                            errorBorder:InputBorder.none ,
//                               suffixIcon: IconButton(
//                                 icon: Icon(Icons.remove_circle),
//                                 color: Colors.blue,
//                                 onPressed: () {
//                                   setState(() {
//                                     print("cleared");
//                                     widget.Item_Default_Product_Type.text = "";
//                                     widget.Id_Item_Default_Product_Type = null;
//
//                                   });
//                                 },
//                               ),
//
//                               isDense: true,
//                               contentPadding:
//                               EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10.0)),
//                               // i need very low size height
//                               labelText:
//                               'Item Default Product Type', // i need to decrease height
//                             )),
//                         suggestionsBoxDecoration:
//                         SuggestionsBoxDecoration(elevation: 90.0),
//                         suggestionsCallback: (pattern) {
//                           return _prodTyp.where((user) =>
//                               user.productType.toUpperCase().contains(pattern.toUpperCase()));
//                         },
//                         itemBuilder: (context, suggestion) {
//                           return Card(
//                             color:theam.DropDownClr,
//                             child: ListTile(
//                               // focusColor: Colors.blue,
//                               // hoverColor: Colors.red,
//                               title: Text(
//                                 suggestion.productType,
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           );
//                         },
//                         onSuggestionSelected: (suggestion) {
//                           print(suggestion.productType);
//                           print("selected");
//
//                           widget.Item_Default_Product_Type.text = suggestion.productType;
//
//                           widget.Id_Item_Default_Product_Type = null;
//
//                           print(suggestion.id);
//                           print("....... Id__Item_Default_Product_Type");
//                           widget.Id_Item_Default_Product_Type = suggestion.id;
//
//                           print(widget.Id_Item_Default_Product_Type);
//                           print("...........");
//                         },
//                         errorBuilder: (BuildContext context, Object error) =>
//                             Text('$error',
//                                 style: TextStyle(
//                                     color: Theme.of(context).errorColor)),
//                         transitionBuilder:
//                             (context, suggestionsBox, animationController) =>
//                             FadeTransition(
//                               child: suggestionsBox,
//                               opacity: CurvedAnimation(
//                                   parent: animationController,
//                                   curve: Curves.elasticIn),
//                             )),
//                   ),
//                 ],
//               ),
//             ),
//
//
//
//
//
//
//
//             Row(
//               children: [
//                 Checkbox(
//
//                   value: widget.Enable_master_index_page,
//                   onChanged: (bool value) {
//                     setState(() {
//                       widget.Enable_master_index_page=!widget.Enable_master_index_page;
//                     });
//                   },
//                 ),
// Text("Enable master index page"),
//
//
//
//
//
//
//               ],
//             ),
//
//
//
//
//             Row(
//               children: [
//                 Checkbox(
//
//                   value: widget.Enable_transaction_index_page,
//                   onChanged: (bool value) {
//                     setState(() {
//                       widget.Enable_transaction_index_page=!widget.Enable_transaction_index_page;
//                     });
//                   },
//                 ),
//                 Text("Enable transaction index page"),
//
//
//
//
//
//
//               ],
//             ),
//
//
//
//             Row(
//               children: [
//                 Checkbox(
//
//                   value: widget.Purchase_Tax_Inclusive,
//                   onChanged: (bool value) {
//                     setState(() {
//                       widget.Purchase_Tax_Inclusive=!widget.Purchase_Tax_Inclusive;
//                     });
//                   },
//                 ),
//                 Text("Purchase Tax Inclusive"),
//
//
//
//
//
//
//               ],
//             ),
//
//
//             Row(
//               children: [
//                 Checkbox(
//
//                   value: widget.Sales_TaxInclusive,
//                   onChanged: (bool value) {
//                     setState(() {
//                       widget.Sales_TaxInclusive=!widget.Sales_TaxInclusive;
//                     });
//                   },
//                 ),
//                 Text("Sales TaxInclusive"),
//
//
//
//
//
//
//               ],
//             ),
//
//
//
//
//
//
//             Row(
//               children: [
//                 Checkbox(
//
//                   value: widget.Batch_Expiry_applicable,
//                   onChanged: (bool value) {
//                     setState(() {
//                       widget.Batch_Expiry_applicable=!widget.Batch_Expiry_applicable;
//                     });
//                   },
//                 ),
//                 Text("Batch & Expiry applicable"),
//
//
//
//
//
//
//               ],
//             ),
//
//
//             Row(
//               children: [
//                 Checkbox(
//
//                   value: widget.Show_Notes_Purchase_Or_Sales,
//                   onChanged: (bool value) {
//                     setState(() {
//                       widget.Show_Notes_Purchase_Or_Sales=!widget.Show_Notes_Purchase_Or_Sales;
//                     });
//                   },
//                 ),
//                 Text("Show Notes Purchase/Sales"),
//
//
//
//
//
//
//               ],
//             ),
//
//
//
//             Row(
//               children: [
//                 Checkbox(
//
//                   value: widget.Enable_godown,
//                   onChanged: (bool value) {
//                     setState(() {
//                       widget.Enable_godown=!widget.Enable_godown;
//                       print(widget.Enable_godown);
//                     });
//                   },
//                 ),
//                 Text("Enable godown"),
//
//
//
//
//
//
//               ],
//             ),
//           ],);
//
//
//
//
//   }
// }
