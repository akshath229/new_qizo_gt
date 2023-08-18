import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../appbarWidget.dart';
import '../../models/userdata.dart';
import '../Report_Button.dart';
import 'Rpt_Journal_Details.dart';
import 'Rpt_Ledger_Statement.dart';
import 'Rpt_Payment_Details.dart';
import 'Rpt_Receipt_Details.dart';
import 'Rpt_Trial_Balance.dart';

class Account_Rpt_Index extends StatefulWidget {


  @override
  _Account_Rpt_IndexState createState() => _Account_Rpt_IndexState();
}

class _Account_Rpt_IndexState extends State<Account_Rpt_Index> {
  late SharedPreferences pref;

  dynamic data;

  dynamic branch;

  dynamic user;

  late int branchId;

  late int userId;

  late UserData userData;

  String branchName = "";

  dynamic userName;

  late String token;

  late String DeviceId;

  Report_Button _report_button= Report_Button();


  read() async {
    setState(() {

      var v = pref.getString("userData");
      var c = json.decode(v!);
      user = UserData.fromJson(c); // token gets this code user.user["token"]
      branchId = int.parse(c["BranchId"]);
      token = user.user["token"]; //  passes this user.user["token"]
      pref.setString("customerToken", user.user["token"]);
      branchName = user.branchName;
      userName = user.user["userName"];
      userId = user.user["userId"];
      DeviceId = user.deviceId;
    });
  }


  void initState() {
    setState(() {


      SharedPreferences.getInstance().then((value) {
        pref = value;
        read();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: PreferredSize(child: Appbarcustomwidget(uname: userName,
          branch: branchName,
          pref: pref,
          title: "Account"), preferredSize: Size.fromHeight(80)),


      body:Column(children: [

        SizedBox(height: 10,),
        _report_button.ReportCustomButton(context:context,name:"Payment Details Report",linkepage:Payment_Details_Report() ),
        SizedBox(height: 10,),
        _report_button.ReportCustomButton(context:context,name:"Receipt Details",linkepage:Receipt_Details_Report()),
        SizedBox(height: 10,),
        _report_button.ReportCustomButton(context:context,name:"Journal Details",linkepage:Journal_Details_Report()),
        SizedBox(height: 10,),
        _report_button.ReportCustomButton(context:context,name:"Ledger Statement",linkepage:Ledger_Statement_Report()),
        SizedBox(height: 10,),
        _report_button.ReportCustomButton(context:context,name:"Trial Balance",linkepage:Trial_Balance_Report()),
        SizedBox(height: 10,),

      ]),
    ));
  }





}











