import 'dart:convert';

import 'package:flutter/material.dart';

import 'Local_db.dart';
import 'Local_db_Model/Test_offline_Sales.dart';
import 'Package:http/http.dart' as http;


class LocalDb_Test extends StatefulWidget {
  @override
  _LocalDb_TestState createState() => _LocalDb_TestState();
}

class _LocalDb_TestState extends State<LocalDb_Test> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  //  Testfunrtion();

  }


  // Testfunrtion()async{
  //
  //     isloading=false;
  //     tdmodel=await GetData();
  //  setState(() {});
  //
  // }
//
//   TestModel tdmodel =TestModel();
// bool isloading=true;
//
//   GetData()async{
//
// var res = await http.get("https://reqres.in/api/users?page=2");
//   print(res.body);
//
//   var jsonres=json.decode(res.body);
//
// return TestModel.fromJson(jsonres);
//   }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              TextButton(
                  onPressed: () {
                    Local_Db().LocalDb_InitialFunction();
                  },
                  child: Text("Open Db")),




              TextButton(
                  onPressed: () {
                    Local_Db().Getall_DataFrom_server();
                  },
                  child: Text("Savedata")),





              TextButton(
                  onPressed: () {
                    Local_Db().TestGetData();
                  },
                  child: Text(" Test Get data")),





              TextButton(
                  onPressed: () {
                    Local_Db().Test();
                  },
                  child: Text("Test")),





              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Ofline_Sales(),
                    ));
                  },
                  child: Text("Go")),




              TextButton(
                  onPressed: () {
                    Local_Db().DropTable();
                  },
                  child: Text("Drop All Tbls")),






              TextButton(
                  onPressed: () {
                    Local_Db().UpdateTodb();
                  },
                  child: Text("Update To  Db ")),

              //
              //  tdmodel.data!=null ?Column(children: [
              //   for(int i=0;i<tdmodel.data.length;i++)
              //     Container(
              //       height: 40,
              //       width: 40,
              //       decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(tdmodel.data[i].avatar))),
              //         child: Text(tdmodel.data[i].lastName.toString())),
              //
              // ],):
              //     Text("nill")


            ],
          ),
        ),
      ),
    );
  }
}
