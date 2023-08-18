// import 'package:flutter/material.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
//
// class GenSett_Account extends StatefulWidget {
//   @override
//   _GenSett_AccountState createState() => _GenSett_AccountState();
// }
//
// class _GenSett_AccountState extends State<GenSett_Account> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(children: [
//
// //       Padding(
// //         padding: const EdgeInsets.all(8.0),
// //         child: Row(
// //           children: [
// //             Expanded(
// //               child: TypeAheadField(
// //                   textFieldConfiguration: TextFieldConfiguration(
// //                       style: TextStyle(),
// //                       controller: Item_Default_Stock_Type,
// //                       textInputAction: TextInputAction.next,
// //                       decoration: InputDecoration(
// //                         errorStyle: TextStyle(color: Colors.red),
// //                         errorText: Validation_Item_Default_Stock_Type
// //                             ? "Please Select Stock Type ?"
// //                             : null,
// // //                            errorText: _validateName ? "please enter name" : null,
// // //                            errorBorder:InputBorder.none ,
// //                         suffixIcon: IconButton(
// //                           icon: Icon(Icons.remove_circle),
// //                           color: Colors.blue,
// //                           onPressed: () {
// //                             setState(() {
// //                               print("cleared");
// //                               Item_Default_Stock_Type.text = "";
// //                               Id_Item_Default_Stock_Type = null;
// //
// //                             });
// //                           },
// //                         ),
// //
// //                         isDense: true,
// //                         contentPadding:
// //                         EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
// //                         border: OutlineInputBorder(
// //                             borderRadius: BorderRadius.circular(10.0)),
// //                         // i need very low size height
// //                         labelText:
// //                         'Item Default Stock Type', // i need to decrease height
// //                       )),
// //                   suggestionsBoxDecoration:
// //                   SuggestionsBoxDecoration(elevation: 90.0),
// //                   suggestionsCallback: (pattern) {
// //                     return _StkTyp.where((user) =>
// //                         user.stockType.toUpperCase().contains(pattern.toUpperCase()));
// //                   },
// //                   itemBuilder: (context, suggestion) {
// //                     return Card(
// //                       color:theam.DropDownClr,
// //                       child: ListTile(
// //                         // focusColor: Colors.blue,
// //                         // hoverColor: Colors.red,
// //                         title: Text(
// //                           suggestion.stockType,
// //                           style: TextStyle(color: Colors.white),
// //                         ),
// //                       ),
// //                     );
// //                   },
// //                   onSuggestionSelected: (suggestion) {
// //                     print(suggestion.stockType);
// //                     print("selected");
// //
// //                     Item_Default_Stock_Type.text = suggestion.stockType;
// //                     print("close.... $Id_Item_Default_Stock_Type");
// //                     Id_Item_Default_Stock_Type = null;
// //
// //                     print(suggestion.id);
// //                     print("....... Id__Item_Default_Stock_Type");
// //                     Id_Item_Default_Stock_Type = suggestion.id;
// //
// //                     print(Id_Item_Default_Stock_Type);
// //                     print("...........");
// //                   },
// //                   errorBuilder: (BuildContext context, Object error) =>
// //                       Text('$error',
// //                           style: TextStyle(
// //                               color: Theme.of(context).errorColor)),
// //                   transitionBuilder:
// //                       (context, suggestionsBox, animationController) =>
// //                       FadeTransition(
// //                         child: suggestionsBox,
// //                         opacity: CurvedAnimation(
// //                             parent: animationController,
// //                             curve: Curves.elasticIn),
// //                       )),
// //             ),
// //           ],
// //         ),
// //       ),
//     ],);
//   }
// }
