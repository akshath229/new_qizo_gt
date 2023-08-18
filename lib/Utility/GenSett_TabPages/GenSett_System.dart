// import 'package:flutter/material.dart';
//
// class GenSett_System extends StatefulWidget {
//   @override
//   _GenSett_SystemState createState() => _GenSett_SystemState();
// }
//
// class _GenSett_SystemState extends State<GenSett_System> {
//
//   TextEditingController System_passwordController = new TextEditingController();
// bool Validate_System_passwordController=false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(children: [
//
//       Container(
//         height: 60,
//         padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
//         child: TextFormField(
//           obscureText: true,
//           controller: System_passwordController,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10.0)),
//             labelText: 'Password',
//             errorStyle: TextStyle(
//               color: Colors.brown,
//               fontSize: 15.0,
//             ),
//             errorText:
//             Validate_System_passwordController ? 'Invalid Password!' : null,
//           ),
//         ),
//       ),
//
//     ],);
//   }
// }
