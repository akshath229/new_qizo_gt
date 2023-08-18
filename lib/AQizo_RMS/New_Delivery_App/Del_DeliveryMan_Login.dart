// import 'dart:convert';
// import 'package:barcode_scan/barcode_scan.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_app/login.dart';
// import 'package:flutter_app/models/userdata.dart';
// import 'package:flutter_app/urlEnvironment/urlEnvironment.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:flutter_app/AQizo_RMS/New_Delivery_App/Del_Qr_Reader.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class Del_Login_DeliveyMan extends StatefulWidget {
//   var Token;
//   var pref;
//   Del_Login_DeliveyMan({this.Token,this.pref});
//   @override
//   _Del_Login_DeliveyManState createState() => _Del_Login_DeliveyManState();
// }
// class _Del_Login_DeliveyManState extends State<Del_Login_DeliveyMan> {
//   TextEditingController userNameController=TextEditingController();
//   TextEditingController passwordController=TextEditingController();
//   bool _validate_EmpCodce=false;
//   bool _validate_Password=false;
//
//
//
//
//   OnLogin(tkn)async{
// setState(() {
//   _validate_EmpCodce == true;
// });
//
//
// if(_validate_EmpCodce==false&&_validate_Password==false){
//   var result=await http.get("${Env.baseUrl}Musers/qr",headers: {
//     "Authorization": " ",
//   });
//
// if(result.statusCode==200){
//
//  var res= json.decode(result.body);
//   print(res["employeeMaster"]);
//   if(res["employeeMaster"].toString()!="[]") {
//     print("HAve result");
//     setState(() {
//       _validate_EmpCodce=false;
//     });
//     var password=  res["employeeMaster"][0]["emPwd"];
//     print("----------");
//     print(password);
// if(password.toString().toLowerCase()==passwordController.text.toLowerCase()){
//   Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => Del_Qr_Rreader(Del_Man_Id: res["employeeMaster"][0]["1d"],)),
//   );
// print("Success");
// }
//   }
//     else
//     {
//       print("no result");
// setState(() {
//   _validate_EmpCodce=true;
// });
//   }
// }
// print(result.body);
// print(result.statusCode);
// }
//   }
//   ///......................Qr reader function start..............................
//   void qr_Barcode_Readfunction() async {
//     try {
//       print("in qr_Barcode_Readfunction ");
//       var result = await BarcodeScanner.scan();
//       print("type");
//       print(result.type);
//       print("rawContent");
//       print(result.rawContent);
//       print("format");
//       print(result.format);
//       print("formatNote");
//       print(result.formatNote);
//       print(result.formatNote);
//       final RegExp regexp = new RegExp(r'^0+(?=.)');
//       print("${result.rawContent} => ${result.rawContent.replaceAll(regexp, '')}");
//       var res=result.rawContent.replaceAll(regexp,'');
//       read(res);
//      // Getdata(res);
//       // Getdata(129);
//      // GetPref();
//     }
//     catch(e) {  print("Error on qr_Barcode_Readfunction $e");}
//
//   }
//
//   ///......................Qr reader function ends..............................
//
//   BAckButton(){
//     Widget noButton = FlatButton(
//       child: Text("No"),
//       onPressed: () {
//           print("No...");
//           Navigator.pop(context); // this is proper..it will only pop the dialog which is again a screen
//       },
//     );
//     Widget yesButton = FlatButton(
//       child: Text("Yes"),
//       onPressed: () {
//           print("Logout...");
//           try {
//             widget.pref.remove('userData');
//           }catch(e){
//             print("catch...");
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => Login()),
//             );
// return;
//           }
//
//           Navigator.pop(context);
//           Navigator.pushNamedAndRemoveUntil(context, "/logout",
//                   (route) => false);
//       },
//     );
//     showDialog(
//         context: context,
//         builder: (c) => AlertDialog(
//             content: Text("Do you really want to logout?"),
//             actions: [yesButton, noButton]));
//   }
//   SharedPreferences pref;
//   dynamic user;
//   String token;
//   var EmpId;
//
//   GetPref()async{
//
//   var res=await  SharedPreferences.getInstance().then((value) {
//       pref = value;
//   });
// print("res.toString()");
// print(res.toString());
//     await read(pref);
//   }
//
//
//   read(p) async {
//     print("oipoipiop");
//     var v = pref.getString("userData");
//     var c = json.decode(v);
//     user = UserData.fromJson(c); // token gets this code user.user["token"]
//     setState(() {
//       token = user.user["token"]; //  passes this user.user["token"]
//       pref.setString("customerToken", user.user["token"]);
//       EmpId=user.user["loginedEmployeeId"];
//       print("uiuiouioiuouio");
//       print(EmpId);
//       OnLogin(token);
//     });
//   }
//
//
//   ///---------------------------
//   @override
//   Widget build(BuildContext context) {
//       return
//        Scaffold(
//
//          body: Column(
//              mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
//              children: [
//                Padding(padding: EdgeInsets.fromLTRB(310, 20, 20, 10),
//                  child: IconButton(
//                      iconSize: 100,
//                      icon: Icon(Icons.qr_code,
//                        color: Colors.teal,
//                        size: 150,),
//                      onPressed: (){
//                        qr_Barcode_Readfunction();
//                      }
//                  ),)]
//          ),
//       );
//   }
//  }
//
//



///.....................................................................................................class
///
///

import 'dart:convert';
import 'dart:ui';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../login.dart';
import '../../models/userdata.dart';
import '../../urlEnvironment/urlEnvironment.dart';
import 'Del_Qr_Reader.dart';

class Del_Login_DeliveyMan extends StatefulWidget {

  var Token;
  var pref;
  Del_Login_DeliveyMan({this.Token,this.pref});

  @override
  _Del_Login_DeliveyManState createState() => _Del_Login_DeliveyManState();
}

class _Del_Login_DeliveyManState extends State<Del_Login_DeliveyMan> {


  OnLogin(tkn)async{
    print("the value of tkn" + tkn);

    var data={
      "qrcode": "$tkn"
    };
    var params = jsonEncode(data);
      var result=await http.post("${Env.baseUrl}Musers/qr" as Uri,headers: {
        "Authorization": widget.Token,
        "accept": "application/json",
      "content-type": "application/json"
      }, body: params);

    print("result1");
      if(result.statusCode==200){
        print("result2");
        var res= json.decode(result.body);
        print(result.body.toString());
        // print("result of users Employ id" + res["users"][0]["userEmployeeId"].toString());
        if(res["users"].toString()!="[]") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                Del_Qr_Rreader(Del_Man_Id: res["users"][0]["userEmployeeId"])),
          );
          print("Success");
        }

        else{

        showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(builder: (context, setState) {
                return AlertDialog(actions: [
                  Container(
                    height: 50,
                    width: 300,
                    child: Center(
                        child: Text("this qr is not found in the table",
                            style: TextStyle(
                              color: Colors.brown,
                              fontSize: 20,
                            ))),
                  )
                ]);
              });
            });

      }
      }
     else {
        print(result.statusCode);
        showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(builder: (context, setState) {
                return AlertDialog(actions: [
                  Container(
                    height: 50,
                    width: 300,
                    child: Center(
                        child: Text("Can't find Qr",
                            style: TextStyle(
                              color: Colors.brown,
                              fontSize: 20,
                            ))),
                  )
                ]);
              });
            });

      }
  }
  ///......................Qr reader function start..............................
  void qr_Barcode_Readfunction() async {
    try {
      print("in qr_Barcode_Readfunction ");
      var result = await BarcodeScanner.scan();
      print("type");
      print(result.type);
      print("rawContent");
      print(result.rawContent);
      print("format");
      print(result.format);
      final RegExp regexp = new RegExp(r'^0+(?=.)');
      print("${result.rawContent} => ${result.rawContent.replaceAll(regexp, '')}");
      var res=result.rawContent.replaceAll(regexp,'');
     // Getdata(res);
      // Getdata(129);
     // GetPref();
      var ValueofQr=result.rawContent;
      OnLogin(ValueofQr);
      setState(() {

      });
    }
    catch(e) {  print("Error on qr_Barcode_Readfunction $e");}

  }

  ///......................Qr reader function ends..............................


  BAckButton(){

    Widget noButton = TextButton(
      child: Text("No"),
      onPressed: () {
        print("No...");
        Navigator.pop(context); // this is proper..it will only pop the dialog which is again a screen
      },
    );

    Widget yesButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        print("Logout...");
        try {
          widget.pref.remove('userData');
        }catch(e){
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => Login()),
          // );
          print("catch...");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );

          return;
          Navigator.pushNamedAndRemoveUntil(context, "/logout",
                  (route) => false);

        }

        Navigator.pop(context); //okk

        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => Login()),
        // );

        Navigator.pushNamedAndRemoveUntil(context, "/logout",
                (route) => false);

      },
    );
    showDialog(
        context: context,
        builder: (c) => AlertDialog(
            content: Text("Do you really want to logout?"),
            actions: [yesButton, noButton]));
  }
  late SharedPreferences pref;
  dynamic user;
  late String token;
  var EmpId;

  GetPref()async{

    var res=await  SharedPreferences.getInstance().then((value) {
      pref = value;
      print(pref.toString());
    });
    print("res.toString()");
    print(res.toString());
    await read(pref);
  }


  read(p) async {

    print("oipoipiop");
    var v = pref.getString("userData");
    var c = json.decode(v!);
    user = UserData.fromJson(c); // token gets this code user.user["token"]
    setState(() {
      token = user.user["token"]; //  passes this user.user["token"]
      pref.setString("customerToken", user.user["token"]);
      EmpId=user.user["loginedEmployeeId"];
      print("uiuiouioiuouio");
      print(EmpId);

      OnLogin(token);


    });
  }


  ///---------------------------
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: WillPopScope(
              onWillPop: (){
                return BAckButton();
              },
              child: Center(
                child: SizedBox(
                  width: 500,
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                        child: IconButton(
                            iconSize: 100,
                            icon: Icon(Icons.qr_code,
                              color: Colors.teal,
                              size: 150,),
                            onPressed: (){
                              qr_Barcode_Readfunction();
                            }
                        ),),
                SizedBox(
                  height:30),
                      Text(
                        '    Scan Delivery man qr code',
                        style: TextStyle(
                            fontSize: 20, color: Colors.teal
                        ),
                      )
                    ]
                ),
                ),
              ),
            ),

          ),
        ));
  }
}
