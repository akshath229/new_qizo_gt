import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../appbarWidget.dart';
import '../models/userdata.dart';
import 'Accounts_Report/Acc_Report_Index.dart';
import 'Purchase_Reports/Purchase_Report.dart';
import 'Sales_Reports/Sales_Report_Index.dart';
import 'Stock_Reports/Stock_Index.dart';
import 'Stock_Reports/Stock_Report.dart';
class Report_Home_Pgae extends StatefulWidget {
  @override
  _Report_Home_PgaeState createState() => _Report_Home_PgaeState();
}

class _Report_Home_PgaeState extends State<Report_Home_Pgae> {


  late SharedPreferences pref;
  dynamic data;
  dynamic branch;
  // var res;
  dynamic user;
  late int branchId;
  late int userId;
  late UserData userData;
  String branchName = "";
  dynamic userName;
  late String token;
  late String DeviceId;

  read() async {
    var v = pref.getString("userData");
    var c = json.decode(v!);
    user = UserData.fromJson(c); // token gets this code user.user["token"]
    setState(() {
      branchId = int.parse(c["BranchId"]);
      token = user.user["token"]; //  passes this user.user["token"]
      pref.setString("customerToken", user.user["token"]);
      branchName = user.branchName;
      userName = user.user["userName"];
      userId = user.user["userId"];
      DeviceId = user.deviceId;
    });
  }

// //----------------------------------

  void initState() {
    setState(() {
      SharedPreferences.getInstance().then((value) {
        pref = value;
        read();
        internet_check();
      });
    });
  }
  void PageNavigate(page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  // Widget PageNavigate(page){
  //   setState(() {
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) =>
  //             page));
  //   });
  //
  // }




// --------------------Net Connection Checking-------------------------------------------------------

  var NetWrkSts=false;

  SelectedPage(a){

    switch(a.toString()) {
      case "0": {
        PageNavigate(Stock_Index());
      }
      break;

      case "1": {
        PageNavigate(Purchase_Report());
      }
      break;

      case "2": {
        PageNavigate(Sales_Rpt_Index());
      }
      break;
      case "3": {
        PageNavigate(Account_Rpt_Index());
      }
      break;

      case "4": {
        PageNavigate(Stock_Report());
      }
      break;

      case "5": {
        PageNavigate(Stock_Report());
      }
      break;
      case "6": {
        // PageNavigate(CreateLedgeBlnc());
        PageNavigate(Stock_Report());
      }
      break;
      case "7": {
        PageNavigate(Stock_Report());
      }
      break;
      case "8": {
        //  PageNavigate(Test2());
        PageNavigate(Stock_Report());


      }
      break;

      default: {
        print("Not Selected");
      }
      break;
    }

  }


  internet_check() async{
    var result = await (Connectivity().checkConnectivity()); {
      if(result==ConnectivityResult.mobile ||result== ConnectivityResult.wifi) {
        //print("NetWrkSts");
        setState(() {
          NetWrkSts=true;
        });

        return true;

      }
      else if (result==ConnectivityResult.none){
        // print("Net not Connected");
        // i=false;
        // showDialog(
        //   context: context,
        //   builder: (context) => new AlertDialog(
        //     title: new Text('No Internet Connection'),
        //     content: new Text('Check Internet Connection'),
        //   ),
        // );
        setState(() {
          NetWrkSts=false;
        });

        return false;
      }


    }


  }




  List<String> Mstr_Name_lst=[
    " Stock ",
    "Purchase",
    " Sales ",
    " Account ",
  ];

  List<String> Mstr_Name_Img_lst=[

    'https://cdn-icons-png.flaticon.com/128/2422/2422792.png',
   'https://d1nhio0ox7pgb.cloudfront.net/_img/o_collection_png/green_dark_grey/512x512/plain/purchase_order.png',
    'https://cdn1.iconfinder.com/data/icons/business-home-vol-1/512/9-512.png',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFyhLHH577dSbP9tivjTRp7rzmPs00-Sjp5w&usqp=CAU',



    //
    // 'https://economictimes.indiatimes.com/thumb/msid-77525190,width-120'
    //     '0,height-900,resizemode-4,imgsize-112483/tax.jpg?from=mdr',
  ];





  ///--------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    var ScreeWidth=MediaQuery.of(context).size.width;
    var ScreeHeight=MediaQuery.of(context).size.height+50;
    return SafeArea(child: Scaffold(
      appBar: PreferredSize(child: Appbarcustomwidget(uname: userName,
          branch: branchName,
          pref: pref,
          title: "Reports"), preferredSize: Size.fromHeight(80)),


      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(physics: ScrollPhysics(),
          itemCount:NetWrkSts==false? Mstr_Name_lst.length:
          Mstr_Name_Img_lst.length,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:ScreeWidth>500? 3:2,
            crossAxisSpacing: 5,
            mainAxisSpacing:6 ,
            childAspectRatio:ScreeWidth>500? 1:1.4,
          ),
          itemBuilder: (c, i) {
            return Container(color: Colors.teal,
              child:
              Padding(
                padding: const EdgeInsets.all(3),
                child: Column(crossAxisAlignment:CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white, // This is the background color
                        // You can add more styling properties if needed
                      ),
                      onPressed: () {
                        print("index :  $i");
                        setState(() {
                          SelectedPage(i);
                        });
                      },
                      child: NetWrkSts == false
                          ? Text(
                        Mstr_Name_lst[i],
                        style: TextStyle(fontSize: 25.0, color: Colors.black),
                      )
                          : SizedBox(
                        height: ScreeWidth / 4,
                        width: ScreeHeight / 2.1,
                        child: FadeInImage(
                          image: NetworkImage(Mstr_Name_Img_lst[i]),
                          placeholder: AssetImage("assets/icon1.jpg"),
                          fadeInCurve: Curves.bounceOut,
                          fadeOutCurve: Curves.decelerate,
                          fadeOutDuration: Duration(seconds: 1,),
                          // fadeInDuration: Duration(seconds: 2,),  // Uncomment this if you want to specify the fadeInDuration
                        ),
                      ),
                    ),

                    Center(
                      child: Text(Mstr_Name_lst[i],style: TextStyle(
                          fontSize: 20.0, color: Colors.black)),
                    )


                  ],),
              ),);
          },
        ),
      ),


    ));
  }
}
