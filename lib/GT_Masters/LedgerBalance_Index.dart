import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../appbarWidget.dart';
import '../ledgerBalanceCreate.dart';
import '../models/userdata.dart';
import 'AppTheam.dart';
import 'Masters_HomePage.dart';
import 'Masters_UI/cuWidgets.dart';



class LedgerBalance_Index extends StatefulWidget {
  @override
  _LedgerBalance_IndexState createState() => _LedgerBalance_IndexState();
}

class _LedgerBalance_IndexState extends State<LedgerBalance_Index> {


  CUWidgets cw=CUWidgets();
  AppTheam theam =AppTheam();
  var ItemList=[];


  late SharedPreferences pref;
  dynamic data;
  dynamic branch;
  var res;
  dynamic user;
  late int branchId;
  late int userId;
  late UserData userData;
  String branchName = "";
  dynamic userName;
  late String token;
  late String DeviceId;
// //----------------------------------
  void initState() {
    setState(() {
      SharedPreferences.getInstance().then((value) {
        pref = value;
        read();
        GetItem();
      });
    });
  }

  bool Status=false;

  // //------------------for appbar------------
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

// //---------------end---for appbar------------




//--------------Get unit-----------------------

  GetItem() async {
    Status=false;
    var jsonres = await cw.CUget_With_Parm(api: "MLedgerHeads", Token: token);

    if (jsonres != false) {
      var res = json.decode(jsonres)["ledgerHeads"] as List;
      // print("ItemList = $res");
      setState(() {
        Status=true;
        ItemList= res;
        usersFiltered=res;
      });
// return usersFiltered;
    }
  }


  BackFun(){
    Navigator.pushReplacement
      (context, MaterialPageRoute(builder: (context) =>
        Masters_Home_Pgae(),
    ));

  }



  getItemIndex(dynamic item) {
    var index = ItemList.indexOf(item);
    return index + 1;
  }

//--------------------------Table Search box-----------------------

  var usersFiltered=[];
  TextEditingController TblSearchController =TextEditingController();
  TextEditingController TblNumSearchController =TextEditingController();
  String _searchResult = '';




  ///---------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return  SafeArea(child:
    Scaffold(

      appBar: PreferredSize(child:
      Appbarcustomwidget(uname:userName, branch:branchName, pref: pref,
        title: "Ledger Index",
        //   child: IconButton(icon: Icon(Icons.add_circle_outline, size: 30,),
        //     onPressed:() {
        //       Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //               builder: (context) =>ItemMaster(Btn_Name:"Save",data: null,)
        //       ));
        // }),
      ),
          preferredSize: Size.fromHeight(80)),
      // bottomNavigationBar: cw.CUButton(name: "ui",H: 50,W: 50,function:() {

      // }),

      body:WillPopScope(
        onWillPop:() {
          return BackFun();
        },
        child: ListView(shrinkWrap: true,

          children: [
            SizedBox(height: 4),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,

                child:Status==false?

                SizedBox(height:MediaQuery.of(context).size.height/2,
                  width:MediaQuery.of(context).size.width,
                  child: Center(child: Text("Loading.....")),
                ):

                ItemList.length<1?

                SizedBox(height:MediaQuery.of(context).size.height/2,
                  width:MediaQuery.of(context).size.width,
                  child: Center(child: Text("Data Not Available")),
                ):


                DataTable(
                  columnSpacing: 12,
                  headingRowColor: theam.TableHeadRowClr,
                  onSelectAll: (b) {},
                  sortAscending: true,
                  showCheckboxColumn: false,
                  columns: <DataColumn>[
                    DataColumn(
                      label: Text(
                        'No',style: theam.TableFont,
                        textAlign: TextAlign.left,
                      ),
                    ),




                    DataColumn(
                      label: Column(crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('Name',style: theam.TableFont,),
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
                                onChanged: (value) {
                                  setState(() {
                                    _searchResult = value;
                                    usersFiltered = ItemList.where((user) => user['lhName'].toLowerCase().contains(_searchResult) || user['lhName'].toLowerCase().contains(_searchResult)).toList();
                                  });
                                }),
                          ),
                        ],
                      ),
                    ),




                    DataColumn(
                      label: Column(crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('Item Group',style: theam.TableFont,),
                          Container(height: 25,width: 55,
                            child: TextField(style: TextStyle(color: Colors.deepPurple,),
                                controller: TblNumSearchController,
                                decoration: new InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding:
                                    EdgeInsets.only(bottom: 10, left: 0.5, right:0.5),
                                    hintText: 'Search',
                                    hintStyle: TextStyle(color: Colors.black)),
                                onChanged: (value) {
                                  setState(() {
                                    _searchResult = value;
                                    usersFiltered = ItemList.where((user) => user['lhGroup'].toString().toLowerCase().contains(_searchResult) || user['lhGroup'].toString().toLowerCase().contains(_searchResult)).toList();
                                  });
                                }),
                          ),
                        ],
                      ),
                    ),


                    DataColumn(
                      label: Text('Arabic Name',style: TextStyle(color: Colors.white),),
                    ),

                    // DataColumn(
                    //   label: Text('Stock Type'),
                    // ),


                    DataColumn(
                      label: Text(''),
                    ),

                  ],
                  rows: List.generate(usersFiltered.length, (index) =>
                      DataRow(
                        cells: [
                          DataCell(
                            Text(getItemIndex(usersFiltered[index]).toString()),
                            showEditIcon: false,
                            placeholder: false,
                          ),



                          DataCell(
                            Container(width: 200,
                                child: Text('${usersFiltered[index]['lhName']??"---".toString()}')),
                            showEditIcon: false,
                            placeholder: false,
                          ),


                          DataCell(
                            Text(usersFiltered[index]["lhGroup"].toString()=="null"?"--":usersFiltered[index]["lhGroup"]),
                            showEditIcon: false,
                            placeholder: false,
                          ),

                          DataCell(
                            Text(
                                usersFiltered[index]["nameLatin"].toString()=="null"?"--":usersFiltered[index]["nameLatin"]
                              ),
                            showEditIcon: false,
                            placeholder: false,
                          ),




                          // DataCell(
                          //   Text(
                          //       usersFiltered[index]["stockType"].toString()=="null"?"--":usersFiltered[index]["stockType"]
                          //   ),
                          //   showEditIcon: false,
                          //   placeholder: false,
                          // ),


                          DataCell(
                            PopupMenuButton<int>(
                              onSelected:(a){
                                print("saf $a");
                              } ,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),

                              ),
                              color:theam.EditpopupClr,
                              itemBuilder: (context) => [
                                PopupMenuItem(height: 30,
                                  child:
                                  Container(
                                    child: Row(children: [
                                      GestureDetector(child: Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Icon(Icons.edit,color: Colors.white,),
                                      ),
                                        onTap: (){
                                          Navigator.pop(context);
                                          print("edit ${usersFiltered[index]}");
                                          setState(() {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CreateLedgeBlnc(Parm_id:usersFiltered[index]["id"],PageType:"Update",)

                                                ));
                                          });
                                          // Edit(itemRow);
                                        },

                                      ),
                                      Spacer(),
                                      GestureDetector(child: Padding(
                                        padding: const EdgeInsets.only(left: 5,right: 5),
                                        child: Icon(Icons.delete,color: Colors.white,),
                                      ),
                                        onTap: (){
                                          Navigator.pop(context);
                                          print("delete");

                                          //  print(usersFiltered[index].toString());
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>CreateLedgeBlnc(Parm_id:usersFiltered[index]["id"],PageType:"Delete",)
                                              ));


                                        },


                                      )
                                    ],),
                                  ),)
                              ],
                              icon: Icon(Icons.more_horiz),
                              //offset: Offset()
                            ), showEditIcon: false,
                            placeholder: false,
                          ),


                        ],
                      ),
                  )
                      .toList(),
                )


            ),



          ],),
      ),


      bottomSheet: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(backgroundColor: Colors.blue.shade800,
              child:Icon(Icons.add_circle_outline, size: 30,),
              onPressed:() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>CreateLedgeBlnc(PageType: "Save",Parm_id: null,)
                    ));
              }
          )),


    ));

  }



}









