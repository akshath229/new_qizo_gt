// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_app/login.dart';
// import 'package:flutter_app/models/userdata.dart';
// import 'package:flutter_app/urlEnvironment/urlEnvironment.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class Add_BaseURL extends StatelessWidget {
//
//   static SharedPreferences pref;
//   var BaseUrl="";
//    TextEditingController URLController = TextEditingController();
//     AddUrl() async {
//       var userData = {
//         "Url":URLController.text
//       };
//       pref = await SharedPreferences.getInstance();
//       pref.setString("userData", json.encode(userData));
//
//
//
//       BaseUrl=URLController.text;
//       print(BaseUrl);
//   var url=   URLController.text;
//   print("Env baseUrl");
//   print(Env.baseUrl);
//
//     return url;
//   }
//
//
//
//    GetUrl()async{
//       var url=
//     SharedPreferences.getInstance().then((value) async {
//       pref = value;
//       var v = pref.getString("userData");
//       print("USER DATA: $v");
//       var c = json.decode(v);
//     var  user = UserData.fromJson(c); // token gets this code user.user["token"] res
//
//
//         // print(user.Url);
//       return null;
//
// });
//
//
//       var tt=await Env.baseUrl;
//       print("Env baseUrl");
//       print(Env.baseUrl);
//       print(tt);
//       print(" tt $tt");
//       return url;
//     }
//
//
//
//     UrlTst(){
//
//       print(Env.baseUrl);
//     }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//           appBar: AppBar(
//             backgroundColor: Colors.teal,
//             centerTitle: true,
//             automaticallyImplyLeading: false,
//             title: Text(
//               'Qizo GT',
//             ),
//           ),
//           body:Container(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//
//
//             padding: EdgeInsets.all(10),
//             child: Column(crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(height: 100,),
//                 TextField(
//                   enabled: true,
//                   controller: URLController,
//                   decoration: InputDecoration(
//                     errorStyle: TextStyle(
//                       color: Colors.brown,
//                       fontSize: 15.0,
//                     ),
//                     border: OutlineInputBorder(),
//                     labelText: 'Enter URL',
//                   ),
//                 ),
//                SizedBox(width: MediaQuery.of(context).size.width-10,
//                    child:
//                ElevatedButton(onPressed: (){
//
//                  AddUrl();
//
//                  // Navigator.push(
//                  //   context,
//                  //   MaterialPageRoute(builder: (context) => Login()),
//                  // );
//                }, child: Text("ADD"))),
//
//
//               ElevatedButton(onPressed: () async {
//                  var s=await GetUrl();
// print("trreytry$s");
//               }, child: Text("Get")),
//
//
//               ElevatedButton(onPressed: () async {
//                 UrlTst();
//               }, child: Text("print"))
//
//               ],
//             ),
//           ));
//   }
// }
