import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../appbarWidget.dart';
import '../../models/userdata.dart';
import '../Report_Button.dart';
import 'Sales_Item_ProfitReport.dart';
import 'Sales_Item_Report.dart';
import 'Sales_Report.dart';
import 'Sales_Rtn_Report.dart';
import 'Sales_Vat_Report.dart';
import 'Salesmanwise _Report.dart';
import 'Salesmanwise_Sales_Report.dart';

class Sales_Rpt_Index extends StatefulWidget {


  @override
  _Sales_Rpt_IndexState createState() => _Sales_Rpt_IndexState();
}

class _Sales_Rpt_IndexState extends State<Sales_Rpt_Index> {
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
          title: "Sales"), preferredSize: Size.fromHeight(80)),


      body:Column(children: [

        SizedBox(height: 10,),
        _report_button.ReportCustomButton(context:context,name:"Sales Summary Report",linkepage:Sales_Report() ),
        SizedBox(height: 10,),
        _report_button.ReportCustomButton(context:context,name:"Sales Vat Report",linkepage:Sales_Vat_Report()),
          SizedBox(height: 10,),
        _report_button.ReportCustomButton(context:context,name:"Sales Return Report",linkepage:Sales_Rtn_Report()),
         SizedBox(height: 10,),
        _report_button.ReportCustomButton(context:context,name:"Salesmanwise Summary Report",linkepage:Salesmanwise_Report()),
        SizedBox(height: 10,),
        _report_button.ReportCustomButton(context:context,name:"Salesmanwise Sales Report",linkepage:Salesmanwise_Sales_Report()),
        SizedBox(height: 10,),
        _report_button.ReportCustomButton(context:context,name:"Sales Item Report",linkepage:Sales_Item_Report()),
         SizedBox(height: 10,),
        _report_button.ReportCustomButton(context:context,name:"Item Profit Report",linkepage:Sales_Item_Profit_Report()),

      ]),
    ));
  }





}











