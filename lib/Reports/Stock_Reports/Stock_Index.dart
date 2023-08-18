import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../appbarWidget.dart';
import '../../models/userdata.dart';
import '../Report_Button.dart';
import 'Stock_Aging_Report.dart';
import 'Stock_Edit_Report.dart';
import 'Stock_Item_Group_Wise.dart';
import 'Stock_Report.dart';

class Stock_Index extends StatefulWidget {


  @override
  _Stock_IndexState createState() => _Stock_IndexState();
}

class _Stock_IndexState extends State<Stock_Index> {
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
          title: "Stock"), preferredSize: Size.fromHeight(80)),


      body:Column(children: [

        SizedBox(height: 10,),
        _report_button.ReportCustomButton(context:context,name:"Stock Report",linkepage:Stock_Report() ),
        SizedBox(height: 10,),
        _report_button.ReportCustomButton(context:context,name:"Stock Aging Report",linkepage:Stock_Aging_Report() ),
        SizedBox(height: 10,),
        _report_button.ReportCustomButton(context:context,name:"Item Group Wise Stock",linkepage:StockItm_Grp_Wise() ),
 SizedBox(height: 10,),
        _report_button.ReportCustomButton(context:context,name:"Stock Edit Report",linkepage:Stock_Edit_Report() ),

      ]),
    ));
  }





}











