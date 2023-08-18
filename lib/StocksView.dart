import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:new_qizo_gt/urlEnvironment/urlEnvironment.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/finishedgoods.dart';
import 'models/userdata.dart';

class StockView extends StatefulWidget {
  @override
  _StockViewState createState() => _StockViewState();
}

class _StockViewState extends State<StockView> {
  late UserData userData;
  late String branchName;
  dynamic userName;
  late String token;
  dynamic user;
  dynamic branchId;
  var userId;
 var StkData=[];
  static List<FinishedGoods> goods = [];





  void initState() {
    SharedPreferences.getInstance().then((value) {
      pref = value;
      read();
      getFinishedGoods();
      getStk();
    });

  }

  late SharedPreferences pref;
  read() async {
    var v = pref.getString("userData");
    print("USER DATA: $v");
    var c = json.decode(v!);

    user = UserData.fromJson(
        c); // token gets this code user.user["token"]

    setState(() {
      print("user data................");
      branchId =int.parse(c["BranchId"]) ;
      print(user.user["token"]);
      token = user.user["token"]; //  passes this user.user["token"]
      pref.setString("customerToken", user.user["token"]);
      branchName = user.branchName;
      userName = user.user["userName"];
      print(".....");
      userId=user.user["userId"];
      print(branchName);
      print(userName);
    });
  }




  getStk() async {
    String url = "${Env.baseUrl}gtstocks";
    try {
      final res =
      await http.get(url as Uri, headers: {"Authorization": user.user["token"]});

      print("Stocks");
      //print(res.body);

      print("json decoded");

      var tagsJson = json.decode(res.body);
      print(tagsJson);
      setState(() {
        StkData=tagsJson;
        print(StkData[0]["itemId"]);
      });

      // List<FinishedGoods> p =
      // t.map((t) => FinishedGoods.fromJson(t)).toList();

      // print(p);
      // goods = p;
    } catch (e) {}
  }

  getFinishedGoods() async {
    String url = "${Env.baseUrl}GtItemMasters/1/1";
    try {
      final res =
      await http.get(url as Uri, headers: {"Authorization": user.user["token"]});

      print("goods Condition");
      // print("statusCode"+res.statusCode.toString());
      if(res.statusCode==200) {
         print(res.body);
        // print("json decoded");
        var tagsJson = json.decode(res.body);
        print("item list");
        print(tagsJson);
        List<dynamic> t = json.decode(res.body);
        List<FinishedGoods> p = t
            .map((t) => FinishedGoods.fromJson(t))
            .toList();

        // print(p);
        goods = p;
      }
    } catch (e) {print("error on getFinishedGoods : $e");}
  }


  GetItemName(id){
var s;
    final _results = goods
        .where((product) => product.id.toString() == id.toString());

    print(_results.toString());
    for (FinishedGoods p in _results) {

     s=p.itmName;
         print(p.itmName);
    }
 return s;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(appBar:AppBar(),
      body: ListView(shrinkWrap: true,
        children: [
          Text("uopop"),

          SingleChildScrollView(
              scrollDirection:Axis.vertical,
              child: DataTable(
                columnSpacing: 17,
                onSelectAll: (b) {},
                sortAscending: true,
                columns: <DataColumn>[
                  DataColumn(
                    label: Text('#'),
                  ),
                  DataColumn(
                    label: Text('Item'),
                  ),
                  DataColumn(
                    label: Text('Stock'),
                  ),
                  DataColumn(
                    label: Text('S Rate'),
                  ),
                  DataColumn(
                    label: Text('Amount'),
                  ),
                  // DataColumn(
                  //   label: Text('Invoice Num'),
                  // ),
                ],
                rows: StkData
                    .map(
                      (itemRow) => DataRow(
                    cells: [
                      DataCell(
                        Text("1"),
                        showEditIcon: false,
                        placeholder: false,
                      ),
                      DataCell(
                        Text(GetItemName(itemRow['itemId'].toString()=="null"?"":itemRow['itemId'].toString())),
                        showEditIcon: false,
                        placeholder: false,
                      ),
                      DataCell(
                        Text(itemRow['qty'].toString()),
                        showEditIcon: false,
                        placeholder: false,
                      ),
                      DataCell(
                        Text(itemRow['srate'].toString()),
                        showEditIcon: false,
                        placeholder: false,
                      ),

                      DataCell(
                        Text(itemRow['godownId'].toString()),
                        showEditIcon: false,
                        placeholder: false,
                      ),
                    ],
                  ),
                )
                    .toList(),
              ),
            ),

          
          
          IconButton(icon: Icon(Icons.data_usage), onPressed:(){
            var s= GetItemName(1219);
            print("dfgfdg");
            print(s);
          })
        ],
      ),
    ));
  }
}
