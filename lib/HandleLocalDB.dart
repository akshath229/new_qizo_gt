import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:new_qizo_gt/sales.dart';
import 'package:new_qizo_gt/urlEnvironment/urlEnvironment.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'GT_Masters/AppTheam.dart';
import 'GT_Masters/Printing/Gst_Print_Foramt.dart';
import 'Local_Db/Local_db.dart';
import 'appbarWidget.dart';
import 'models/userdata.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;

class HandleLocalDB extends StatefulWidget {
  @override
  _HandleLocalDBState createState() => _HandleLocalDBState();
}

class _HandleLocalDBState extends State<HandleLocalDB> {

  var retunid;
  bool Save_Pending=false;

  @override
  void initState() {

    SharedPreferences.getInstance().then((value) {
      pref = value;
      read();

      setState(() {
        // getindexdata("1");

        getdata();
        GeneralSettings();
      });


    });
  }
getdata() async{
  Directory? documentsDirectory = await getExternalStorageDirectory();
  var  pathh = path.join(documentsDirectory!.path, "qizo_Gt_LocalDb.db");

  final database = openDatabase(pathh);
  final db = await database;

  final List<Map<String, dynamic>> count = await db.rawQuery(
      "SELECT count(*) from salesHeader");
  print(count.toString().substring(12, count
      .toString()
      .length - 2));
  final List<Map<String, dynamic>> salesHeader = await db.rawQuery("SELECT * from salesHeader");
  print("sdfasdfsaf" + salesHeader[0]["localSyncId"].toString());

  int m =  int.parse(count.toString().substring(12, count.toString().length - 2));
  print("the value of m is " + m.toString());
  for (int i = 1; i < m; i++) {
    return GetUpdateData(i);
  }
}


  late String token;
  dynamic user;
  late SharedPreferences pref;
  late UserData userData;
  late String branchName;
  dynamic userName;
  List<dynamic> t = [];
  bool showProgress = true;
  var formatter = NumberFormat('#,##,##,##,##0.00');
  AppTheam theam =AppTheam();
  var DefultPrint_typ=null;
  var usersFiltered=[];
  String _searchResult = '';
  TextEditingController TblSearchController =TextEditingController();
//  get Token
  bool ShowAll=false;

  read() async {
    var v = pref.getString("userData");
    print("USER DATA: $v");
    var c = json.decode(v!);

    user = UserData.fromJson(c); // token gets this code user.user["token"]
    setState(() {
      print("user data................");
      print(user.user["token"]);
      token = user.user["token"]; //  passes this user.user["token"]
      pref.setString("customerToken", user.user["token"]);
      branchName = user.branchName;
      userName = user.user["userName"];
      print(".....");
      print(branchName);
      print(userName);
    });
  }
//get data to list

  // getindexdata(typ)async{
  //   try {
  //     var res = await http.get("${Env.baseUrl}SalesHeaders/1/$typ",
  //         headers: {'Authorization': user.user['token']});
  //     print(".....api data..getdata....");
  //     //  print(res.body);
  //     setState(() {
  //       var dt = json.decode(res.body);
  //       print(".....api data..1....");
  //       // print(dt);
  //       // log("jiuou $dt");
  //       // t = dt as List;
  //       t = dt['listHeader'] as List;
  //       usersFiltered=dt['listHeader'] as List;
  //       t.forEach(print);
  //       //  print(t);
  //       print(res.statusCode);
  //       showProgress = false;
  //       // if(res.statusCode==200){showProgress= false;}
  //       // else{showProgress= true;}
  //
  //     });
  //   }catch(e){print("error in getindexdata $e");}
  // }
  //


  GetUpdateData(Id) async {
    Directory? documentsDirectory = await getExternalStorageDirectory();
    var pathh = path.join(documentsDirectory!.path, "qizo_Gt_LocalDb.db");

    final database = openDatabase(pathh);
    final db = await database;
    final List<Map<String, dynamic>> count = await db.rawQuery( "SELECT count(*) from salesHeader");
    print(count.toString().substring(12, count
        .toString()
        .length - 2));
    final List<Map<String, dynamic>> salesHeader = await db.rawQuery("SELECT * from salesHeader");
    print("sdfasdfsaf" + salesHeader[0]["localSyncId"].toString());



    print(" print in");
  }

  void UpdateToServer() async {
    Directory? documentsDirectory = await getExternalStorageDirectory();
    var pathh = path.join(documentsDirectory!.path, "qizo_Gt_LocalDb.db");

    final database = openDatabase(pathh);
    final db = await database;

    final List<Map<String, dynamic>> count = await db.rawQuery(
        "SELECT count(*) from salesHeader");
    print(count.toString().substring(12, count
        .toString()
        .length - 2));
    final List<Map<String, dynamic>> salesHeader = await db.rawQuery("SELECT * from salesHeader");
    print("sdfasdfsaf" + salesHeader[0]["localSyncId"].toString());

    int j = salesHeader[0]["localSyncId"];
    int m = j + int.parse(count.toString().substring(12, count.toString().length - 2));
    print("the value of m is " + m.toString());
    for (int i = j; i < m; i++) {

      try {
        print("the updates are ");

        var req = await Local_Db().GetUpdateData(i);

        print("request geted");

        final url = "${Env.baseUrl}SalesHeaders";
        var params = json.encode(req);

        print("the parameters are" + params.toString());



        if(params.toString() == "null"){
          print("datas asll redy saved");
        }
        else {
          print("iouioiououi");
          // debugPrint(params);
          log(params.toString());

          setState(() {
            Save_Pending = false;
          });

          var res = await http.post(url as Uri,
              headers: {
                'accept': 'application/json',
                'content-type': 'application/json',
                'Authorization': user.user["token"],
                'deviceId': user.deviceId
              },
              body: params.toString());

          print("salesSave : " + res.statusCode.toString());
          print("salesSave : " + res.body.toString());
          if (res.statusCode == 500) {
            var c = json.decode(res.body);
            var msg = c['erromsg'].toString();
            showDialog(
                context: context,
                builder: (context) =>
                    AlertDialog(
                      title: Text(msg),
                    ));
          }
          else if (res.statusCode == 200 || res.statusCode == 201) {
            print("the result is " + res.body.toString());
            retunid = await jsonDecode(res.body);
            print(
                "the voucher number is " + retunid['voucherNo'].toString());
            await db.rawQuery(
                "UPDATE salesHeader SET SyncVoucherNo = ${retunid['voucherNo']
                    .toString()} WHERE localSyncId=$i;");
            print(
                "the voucher number is " + retunid['id'].toString());
            await db.rawQuery(
                "UPDATE salesHeader SET syncServerId = ${retunid['id']
                    .toString()} WHERE localSyncId=$i;");
          }
        }
      }
      catch (e) {
        print("the exeption is " + e.toString());
      }
      // }
      // else {
      //   print("database is fully added");
      // }
    }

  }

  void deleteLocalTable() async{
    Directory? documentsDirectory = await getExternalStorageDirectory();
    var  pathh = path.join(documentsDirectory!.path, "qizo_Gt_LocalDb.db");

    final database = openDatabase(pathh);
    final db = await database;

    final List<Map<String, dynamic>> count = await db.rawQuery(
        "SELECT count(*) from salesHeader where SyncVoucherNo NOTNULL");
    print(count.toString().substring(12, count
        .toString()
        .length - 2));
    final List<Map<String, dynamic>> salesHeader = await db.rawQuery("SELECT * from salesHeader");
    print("sdfasdfsaf" + salesHeader[0]["localSyncId"].toString());

    int j = salesHeader[0]["localSyncId"];
    int m = j + int.parse(count.toString().substring(12, count.toString().length - 2));
    print("the value of m is " + m.toString());
    for (int i = j; i < m; i++) {
      await db.rawDelete(' DELETE FROM salesHeader WHERE localSyncId = $i;');
      await db.execute(' DELETE FROM salesDetails WHERE SHID = $i;');
    }



    // await db.rawDelete(' DELETE FROM salesHeader WHERE localSyncId = 1;');
    // await db.execute(' DELETE FROM salesDetails WHERE SHID = 1;');

    var dltdata =  await db.rawQuery('select localSyncId from salesHeader where SyncVoucherNo ISNULL');
    print("the data is " + dltdata.toString());



  }

  GeneralSettings()async{


    final res =
    await http.get("${Env.baseUrl}generalSettings" as Uri, headers: {
      "Authorization": user.user["token"],
    });

    if(res.statusCode<210) {
      print(res);
      var GenSettingsData = json.decode(res.body);
      print(GenSettingsData[0]["applicationTaxTypeGst"]);
      setState(() {
        print("DefultPrint_typ");
        DefultPrint_typ=GenSettingsData[0]["salesPrinterType"];

      });
    }
  }

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      if(ShowAll==true){
        GetUpdateData(2);
      }else
      {
        GetUpdateData(3);
      }

    });
    return null;
  }



  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
//      key: scaffoldKey,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(190.0),
              child:  Appbarcustomwidget(uname: userName, branch: branchName, pref: pref, title:"Local DB")
          ),
          body: RefreshIndicator(
            key:refreshKey,
            onRefresh:refreshList,
            child: ListView(children: <Widget>[

              SizedBox(
                height: 4,
              ),
              showProgress ?
              Container(
                height: 500,
                width: 350,
                child: Center(
                    child:Text("Loading Sales....")
                  //   CircularProgressIndicator(),
                ),
              ):Container(
                child: t.length > 0 ?
                Row(
//            verticalDirection: VerticalDirection.down,
//            crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    SizedBox(
                      width: 4,
                    ),

                    Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: DataTable(
                              columnSpacing: 17,
                              headingRowColor: theam.TableHeadRowClr,
                              onSelectAll: (b) {},
                              sortAscending: true,
                              columns: <DataColumn>[


                                DataColumn(
                                  label: Column(crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text('Vch No',style: theam.TableFont,),
                                      Container(height: 25,width: 55,
                                        child: TextField(style: TextStyle(color: Colors.white,),
                                            controller: TblSearchController,
                                            decoration: new InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding:
                                                EdgeInsets.only(bottom: 10, left: 0.5, right:0.5),
                                                hintText: 'Search',
                                                hintStyle: TextStyle(color: Colors.black)
                                            ),
                                            onChanged: (value    ) {
                                              setState(() {
                                                _searchResult = value;
                                                usersFiltered = t.where((user) => user['voucherNo'].toString().toLowerCase().contains(_searchResult) || user['voucherNo'].toString().toLowerCase().contains(_searchResult)).toList();
                                              });
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                                DataColumn(
                                  label: Text('Voucher Date',style: theam.TableFont,),
                                ),
                                DataColumn(
                                  label: Text('Party Name',style: theam.TableFont,),
                                ),
                                DataColumn(
                                  label: Text('Invoice Type',style: theam.TableFont,),
                                ),
                                DataColumn(
                                  label: Text('Amount',style: theam.TableFont,),
                                ),
                                DataColumn(
                                  label: Text('Canceled',style: theam.TableFont,),
                                ),
                                DataColumn(
                                  label: Text('Edit',style: theam.TableFont,),
                                ),
                                DataColumn(
                                  label: Text('Print',style: theam.TableFont,),
                                ),
                              ],
                              rows: List.generate(usersFiltered.length, (index) =>
                                  DataRow(
                                    cells: [
                                      DataCell(
                                        Text(
                                            '${usersFiltered[index]['voucherNo'].toString()}'),
                                        showEditIcon: false,
                                        placeholder: false,
                                      ),
                                      DataCell(
                                        GestureDetector(
                                            onTap: () {},
                                            child:

                                            Text((usersFiltered[index]['voucherDate']!=null)?DateFormat("dd-MM-yyyy").format(DateTime.parse(usersFiltered[index]['voucherDate'])):"--/--/---")
                                        ),
                                        showEditIcon: false,
                                        placeholder: false,
                                      ),
                                      DataCell(
                                        GestureDetector(
                                          onTap: () {},
                                          child: Text('${usersFiltered[index]['partyName'].toString()}'),

                                        ),
                                        showEditIcon: false,
                                        placeholder: false,
                                      ),
                                      DataCell(
                                        GestureDetector(
                                          onTap: () {},
                                          child: Text('${usersFiltered[index]['invoiceType'].toString()}'),
                                        ),
                                        showEditIcon: false,
                                        placeholder: false,
                                      ),
                                      DataCell(
                                        Container(
                                          alignment: Alignment.centerRight,
                                          child: Text(((usersFiltered[index]['amount']!=null))?formatter.format((usersFiltered[index]['amount'])):"0.0"
                                              .toString()),
                                        ),
                                        showEditIcon: false,
                                        placeholder: false,
                                      ),
                                      DataCell(
                                        GestureDetector(
                                          onTap: () {},
                                          // child: Text('${itemRow['cancelFlg'].toString()}'),
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(((usersFiltered[index]['cancelFlg']!=null))?((usersFiltered[index]['cancelFlg']).toString()):"-"
                                                .toString()),
                                          ),),
                                        showEditIcon: false,
                                        placeholder: false,
                                      ),
                                      DataCell(
                                        Center(
                                          child: GestureDetector(
                                              onTap: () {
                                                print(usersFiltered[index]);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Newsalespage(
                                                              passvalue:usersFiltered[index]['id'].toInt(),passname: usersFiltered[index]['partyName'].toString(),itemrowdata:usersFiltered[index])),);
                                              },
                                              child:
                                              Icon(Icons.edit)),
                                        ),
                                      ),
                                      DataCell(
                                        Center(
                                          child: GestureDetector(
                                              onTap: () {
                                                print(usersFiltered[index]);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            GST_Print_Format(Parm_Id: usersFiltered[index]['id'], title:"title",  Details_Data: "")));
                                                return;
                                              },
                                              child:
                                              Icon(Icons.print)),
                                        ),
                                      ),
                                    ],
                                  ),
                              )
                                  .toList(),
                            ),
                          ),
                        )),
                    SizedBox(
                      width: 10,
                    )
                  ],
                ): Container(
                  height: 400,
                  child: Center(
                      child: Text("No Order Found")),
                ),
              ),
              WillPopScope(
                onWillPop: _onBackPressed,
                child: Text(""),
              ),

            ]),
          ),


          bottomNavigationBar: showProgress ?
          Center(
              child:Text("")
            //   CircularProgressIndicator(),
          ): Container(
            height: 40,
            color: Colors.transparent,
            child: Row(
              children: [
                Text("   Show All",style: TextStyle(fontSize: 20,color: Colors.blue.shade600,fontWeight: FontWeight.bold),),


                Checkbox(
                  activeColor: Colors.blue,
                  checkColor: Colors.white,
                  fillColor: MaterialStateProperty.all(Colors.blue.shade600,) ,

                  value:ShowAll,
                  onChanged: (bool? value) {
                    setState(() {
                      ShowAll = !ShowAll;
                      setState(() {
                        if(ShowAll==true){
                          GetUpdateData(1);
                        }else
                        {
                          GetUpdateData(2);
                        }

                      });
                    });
                  },
                ),
              ],
            ),),

        ));
  }
  Future<bool> _onBackPressed() {
    Navigator.of(context, rootNavigator: true).pop();
    return Future.value(true); // or return Future.value(false); based on your need
  }

}
