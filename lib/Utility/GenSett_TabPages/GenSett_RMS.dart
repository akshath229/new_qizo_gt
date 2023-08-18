// import 'package:flutter/material.dart';
// import 'package:flutter_app/GT_Masters/Masters_UI/cuWidgets.dart';
//
// class GenSett_RMS extends StatefulWidget {
//   @override
//   _GenSett_RMSState createState() => _GenSett_RMSState();
// }
//
// class _GenSett_RMSState extends State<GenSett_RMS> {
//
//   CUWidgets cw=CUWidgets();
//   TextEditingController Rms_Counter_Printer = new TextEditingController();
//   TextEditingController Rms_Kot_Printer = new TextEditingController();
//
// bool Enable_Makeorder_In_Rms=false;
// bool Bypass_Delivery_Process_In_Rms=false;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(children: [
//
//
//         SizedBox(height: 10,),
//         cw.CUTestbox(
//           controllerName: Rms_Counter_Printer,
//           label: "Rms Counter Printer"
//
//         ),
//
//         SizedBox(height: 10,),
//
//         cw.CUTestbox(
//           controllerName: Rms_Kot_Printer,
//           label: "Rms Kot Printer"
//
//         ),
//
//
//
//         Row(children: [
//           Checkbox(
//
//             value: Enable_Makeorder_In_Rms,
//             onChanged: (bool value) {
//               setState(() {
//                 Enable_Makeorder_In_Rms=!Enable_Makeorder_In_Rms;
//               });
//             },
//           ),
//           Text("Enable Makeorder In Rms"),
//         ],),
//
//
//
//         Row(children: [
//           Checkbox(
//
//             value:Bypass_Delivery_Process_In_Rms,
//             onChanged: (bool value) {
//               setState(() {
//                 Bypass_Delivery_Process_In_Rms=!Bypass_Delivery_Process_In_Rms;
//               });
//             },
//           ),
//           Text("Bypass Delivery Process In Rms"),
//         ],),
//
//
//       ],),
//     );
//   }
// }
