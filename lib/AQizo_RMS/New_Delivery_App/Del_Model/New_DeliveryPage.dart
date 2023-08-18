import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';



import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../appbarWidget.dart';
import '../../../login.dart';
import '../../../models/userdata.dart';
import '../../../urlEnvironment/urlEnvironment.dart';

class Del_Qr_Rreader2 extends StatefulWidget {

  var Del_Man_Id;
  Del_Qr_Rreader2({this.Del_Man_Id});

  @override
  _Del_Qr_Rreader2State createState() => _Del_Qr_Rreader2State();
}

class _Del_Qr_Rreader2State extends State<Del_Qr_Rreader2> {
  late SharedPreferences pref;
  late int branchId;
  late int userId;
  late UserData userData;
  String branchName = "";
  dynamic userName;
  late String token;
  dynamic user;
  dynamic currencyName;
  var ScannedDatas=[];
  bool is_processes=false;
  var   EmpId;
  var Del_Man_Id;
  @override
  void initState() {
    // TODO: implement initState
    ScannedDatas=[];
    SharedPreferences.getInstance().then((value) {
      pref = value;
      read();
    });
    print("adsfdf " + Env.camera);
    qr_Barcode_Readfunction();
  }
  read() async {
    var v = pref.getString("userData");
    var c = json.decode(v!);
    user = UserData.fromJson(c); // token gets this code user.user["token"]
    setState(() {
      branchId = int.parse(c["BranchId"]);
      token = user.user["token"]; //  passes this user.user["token"]
      print(user.user["token"]);
      pref.setString("customerToken", user.user["token"]);
      branchName = user.branchName;
      userName = user.user["userName"];
      userId = user.user["userId"];
      currencyName = user.user["currencyName"];
      //  EmpId=user.user["loginedEmployeeId"];
      EmpId=widget.Del_Man_Id;
      print("----EmpId----");
      print(EmpId.toString());
    });
  }
  void qr_Barcode_Readfunction() async {
    try {
      print("in qr_Barcode_Readfunction ");
      if(Env.camera=="Front"){
        var result = await BarcodeScanner.scan( options: ScanOptions(useCamera: 1,));
        final RegExp regexp = new RegExp(r'^0+(?=.)');
        print("${result.rawContent} => ${result.rawContent.replaceAll(regexp, '')}");
        var res=result.rawContent.replaceAll(regexp, '');
        Getdata(res);
      }else{
        var result = await BarcodeScanner.scan();
        final RegExp regexp = new RegExp(r'^0+(?=.)');
        print("${result.rawContent} => ${result.rawContent.replaceAll(regexp, '')}");
        var res=result.rawContent.replaceAll(regexp, '');
        Getdata(res);
      }
      // Getdata(129);
    }
    catch(e) {  print("Error on qr_Barcode_Readfunction $e");}
  }



  Getdata(id)async{
    setState(() {
      is_processes=false;
    });
    var result=await http.get("${Env.baseUrl}SalesHeaders/$id/VoucherNumber" as Uri,headers: {
      "Authorization": token,
    });
    if(result.statusCode==200){
      var res=json.decode(result.body);
      print("salesHeader");
      print(res["salesHeader"]);
      if(res["salesHeader"].toString()=="[]"){
        qr_Barcode_Readfunction();
      }
      print("salesDetails");
      print(res["salesDetails"]);
      print(res["salesHeader"][0]["voucherNo"].toString());
      for(int j=0;j<ScannedDatas.length;j++){
        if(res["salesHeader"][0]["id"]== ScannedDatas[j]["Sh_id"]){
          setState(() {
            is_processes=true;
          });
        }
      }
      if(res["salesHeader"][0]["cancelFlg"]==true||res["salesHeader"][0]["orderstatus"]=="delivered"|| is_processes==true){
        // onPlayAudios();
        print("dsadefasf");
        qr_Barcode_Readfunction();
      }
      else{
        var qrdata= {
          "Sh_id":res["salesHeader"][0]["id"],
          "Billnum":res["salesHeader"][0]["voucherNo"],
          "Name":res["salesHeader"][0]["partyName"],
          "Phonenum":res["salesHeader"][0]["phone"],
          "Amount":res["salesHeader"][0]["amount"]
        };
        print("qrdata");
        print(qrdata);
        setState(() {
          ScannedDatas.add(qrdata);
          BillNumber_Controller.text="";
        });
        Proccess();
        qr_Barcode_Readfunction();
      }
      print(ScannedDatas);
    }else{
      print("dfdsds");
      // qr_Barcode_Readfunction();
      // onPlayAudios();
    }
  }
  Proccess()async {
    var datatime = new DateFormat("yyyy-MM-dd").format(DateTime.now());
    print(datatime);
    print(ScannedDatas);
    if (ScannedDatas.length < 1) {
      // onPlayAudios();
      print("Order not Selected");
    } else {
      var parm = {
        "voucherNo": 1,
        "delDate": datatime,
        "salesManId":EmpId, //widget.Del_Man_Id,
        "salesMan": null,
        "rmsDeliverDetails": [
          for(int i = 0; i < ScannedDatas.length; i++){
            "salesHeaderId": ScannedDatas[i]["Sh_id"]
          }
        ]
      };
      var finaldata = json.encode(parm);
      print("--finaldata--");
      print(finaldata);
      var result = await http.post("${Env.baseUrl}RmsDeliveryHeaders" as Uri,
          headers: {
            'accept': 'application/json',
            'content-type': 'application/json',
            'Authorization': user.user["token"],
            'deviceId': user.deviceId
          },
          body: finaldata);

      print("-------parm------");
      print(result.body);
      print(result.statusCode);

      if(result.statusCode==200||result.statusCode==201){
        onPlayAudio();
        setState(() {
          ScannedDatas=[];
        });
      }
      if(result.statusCode!=200||result.statusCode!=201){
        // onPlayAudios();
      }
    }

  }

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
          pref.remove('userData');
        }catch(e){
          print("catch...");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
          return;
        }

        Navigator.pop(context);
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
  // void onPlayAudios() async {
  //   try {
  //     print("assets/beep.mp3");
  //     //AudioPlayer audioPlayer = AudioPlayer();
  //     final player = AudioCache();
  //     await player.play("beep.mp3");
  //   } catch (e) {
  //     print("error123 $e");
  //   }
  // }
  void onPlayAudio() async {
    try {
      print("assets/beep.mp3");
      //AudioPlayer audioPlayer = AudioPlayer();
      final player = AudioCache();
      await player.play("beep.mp3");
    } catch (e) {
      print("error123 $e");
    }
  }
  TextEditingController BillNumber_Controller =TextEditingController();


  ///---------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:PreferredSize(child: Appbarcustomwidget(uname: userName, branch: branchName, pref: pref, title: "Orders"), preferredSize: Size.fromHeight(80)) ,
        body:WillPopScope(
          onWillPop: (){
            return  BAckButton();
          },
          child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Center(
                  child: IconButton(icon: Icon(Icons.qr_code,
                  color: Colors.teal,
                  size: 90,), onPressed: (){qr_Barcode_Readfunction();}
                  ),
                ),
                ],
              ),
          ),
        ),
    );
  }
}
