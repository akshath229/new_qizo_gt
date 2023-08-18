// import 'package:flutter/material.dart';
//
//
// class GenSett_Purchase extends StatefulWidget {
//   @override
//   _GenSett_PurchaseState createState() => _GenSett_PurchaseState();
// }
//
// class _GenSett_PurchaseState extends State<GenSett_Purchase> {
//
//
//   bool Purchase_Edit_After_Stock_Update=false;
//   bool Generate_Barcode_In_Purchase=false;
//   bool Auto_Generate_Batch_In_Purchase=false;
//   bool Update_ItemRate_BasedOn_Purchase=false;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return  Column(children: [
//       Row(children: [
//   Checkbox(
//
//     value: Purchase_Edit_After_Stock_Update,
//     onChanged: (bool value) {
//       setState(() {
//         Purchase_Edit_After_Stock_Update=!Purchase_Edit_After_Stock_Update;
//       });
//     },
//   ),
//   Text("Purchase Edit After Stock Update"),
// ],),
//
//
//
//       Row(children: [
//         Checkbox(
//
//           value: Generate_Barcode_In_Purchase,
//           onChanged: (bool value) {
//             setState(() {
//               Generate_Barcode_In_Purchase=!Generate_Barcode_In_Purchase;
//             });
//           },
//         ),
//         Text("Generate Barcode In Purchase"),
//       ],),
//
//
//
//       Row(children: [
//         Checkbox(
//
//           value: Auto_Generate_Batch_In_Purchase,
//           onChanged: (bool value) {
//             setState(() {
//               Auto_Generate_Batch_In_Purchase=!Auto_Generate_Batch_In_Purchase;
//             });
//           },
//         ),
//         Text("Auto Generate Batch In Purchase"),
//       ],),
//
//
//
//       Row(children: [
//         Checkbox(
//
//           value: Update_ItemRate_BasedOn_Purchase,
//           onChanged: (bool value) {
//             setState(() {
//               Update_ItemRate_BasedOn_Purchase=!Update_ItemRate_BasedOn_Purchase;
//             });
//           },
//         ),
//         Text("Update ItemRate BasedOn Purchase"),
//       ],),
//
//     ],);
//   }
// }
