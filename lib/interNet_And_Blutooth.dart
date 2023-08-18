// import 'package:connectivity/connectivity.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:connectivity/connectivity.dart';
// class Inter_Net_And_Blutooth_Connection extends StatefulWidget {
//   @override
//   _Inter_Net_And_Blutooth_ConnectionState createState() => _Inter_Net_And_Blutooth_ConnectionState();
//
//
// void blutooth(){
//
//   checkPerm() async {
//     var status = await Permission.bluetooth.status;
//     if (status.isDenied) {
//
//       await Permission.bluetooth.request();
//     }
//
//     if (await Permission.bluetooth.status.isPermanentlyDenied) {
//       openAppSettings();
//     }
//
//   }
//
//
//
// }
//
//  void internet_check() async {
//     var i;
//     var result = await (Connectivity().checkConnectivity());
//     {
//       if (result == ConnectivityResult.mobile ||
//           result == ConnectivityResult.wifi) {
//         // var i=true;
//        // return true;
//         print(" ss Net not Connected");
//       }
//       else if (result == ConnectivityResult.none) {
//          print("Net not Connected");
//         i=false;
//         showDialog(
//           context:const,
//           builder: (context) =>
//           new AlertDialog(
//             title: new Text('No Internet Connection'),
//             content: new Text('Check Internet Connection'),
//           ),
//         );
//         //return false;
//       }
//     }
//   }
// }
//
//
//
// class _Inter_Net_And_Blutooth_ConnectionState extends State<Inter_Net_And_Blutooth_Connection> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
//
// class BlutoothConnection{
//  // BlutoothConnection() {}
// }
//
//
