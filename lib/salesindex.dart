import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:new_qizo_gt/sales.dart';
import 'package:new_qizo_gt/urlEnvironment/urlEnvironment.dart';
import 'package:printing/printing.dart';
import 'GT_Masters/AppTheam.dart';
import 'GT_Masters/Printing/Gst_Print_Foramt.dart';
import 'GT_Masters/Printing/New_Model_PdfPrint.dart';
import 'GT_Masters/Printing/PDF_Printer.dart';
import 'appbarWidget.dart';
import 'indexpage.dart';
import 'models/userdata.dart';
import 'models/usersession.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class salesindex extends StatefulWidget {
  @override
  _salesindexState createState() => _salesindexState();
}

class _salesindexState extends State<salesindex> {
  @override
  void initState() {

    SharedPreferences.getInstance().then((value) {
      pref = value;
      read();

      setState(() {
        getindexdata("1");
        GeneralSettings();
      });


    });
  }
  String? token;
  dynamic user;
  SharedPreferences? pref;
  UserData? userData;
  String? branchName;
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
    var v = pref?.getString("userData");
    print("USER DATA: $v");
    var c = json.decode(v!);

    user = UserData.fromJson(c); // token gets this code user.user["token"]
    setState(() {
      print("user data................");
      print(user.user["token"]);
      token = user.user["token"]; //  passes this user.user["token"]
      pref?.setString("customerToken", user.user["token"]);
      branchName = user.branchName;
      userName = user.user["userName"];
      print(".....");
      print(branchName);
      print(userName);
    });
  }


//get data to list


  getindexdata(typ)async{
    try {
      var res = await http.get("${Env.baseUrl}SalesHeaders/1/$typ" as Uri,
          headers: {'Authorization': user.user['token']});
      print(".....api data..getdata....");
    //  print(res.body);
      setState(() {
        var dt = json.decode(res.body);
        print(".....api data..1....");
       // print(dt);
       // log("jiuou $dt");
        // t = dt as List;
        t = dt['listHeader'] as List;
        usersFiltered=dt['listHeader'] as List;
        t.forEach(print);
      //  print(t);
        print(res.statusCode);
        showProgress = false;
        // if(res.statusCode==200){showProgress= false;}
        // else{showProgress= true;}

      });
    }catch(e){print("error in getindexdata $e");}
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
        getindexdata("2");
      }else
        {
          getindexdata("1");
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
              child:  Appbarcustomwidget(uname: userName, pref: pref, title:"Sales Index")
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
                                //...............for print .......................
                                //     DataColumn(
                                //       label: Text('Print'),
                                //     ),
                                //........................................
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
                                          // Text('${DateFormat("dd-MM-yyyy").format(DateTime.parse(itemRow['voucherDate']))}'),

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

                                              if(DefultPrint_typ.toString().contains("Tax Invoice") ||
                                                  DefultPrint_typ.toString().contains("Simplified")){

                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            New_Model_PdfPrint(Parm_Id: usersFiltered[index]['id'],Page_Type:DefultPrint_typ.contains("Tax Invoice")==true?true:false,)));


                                              }
                                              else{
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Pdf_Print(Parm_Id: usersFiltered[index]['id'],Page_Type: DefultPrint_typ.contains("4")==true?"A4":"3 Inch",)));

                                              }
                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //       builder: (context) =>
                                              //        New_Model_PdfPrint(Parm_Id: itemRow['id'],Page_Type:true,)
                                              //         //  Pdf_Print(Parm_Id:itemRow['id']),
                                              //     ));
                                            },
                                            child:
                                            Icon(Icons.print)),
                                      ),
                                    ),
                                    //...............for print .......................
                                    // DataCell(
                                    //   Center(
                                    //     child: GestureDetector(
                                    //         onTap: () {
                                    //           print(itemRow);
                                    //           Navigator.push(
                                    //             context,
                                    //             MaterialPageRoute(
                                    //                 builder: (context) =>
                                    //                     printing(passvalue:itemRow['id'].toInt())
                                    //             ),);
                                    //         },
                                    //         child:
                                    //         Icon(Icons.print)),
                                    //   ),
                                    // ),
                                    //..................................................
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
                    if (value != null) {  // add this check
                      setState(() {
                        ShowAll = !ShowAll;
                        setState(() {
                          if(ShowAll==true){
                            getindexdata("2");
                          } else {
                            getindexdata("1");
                          }
                        });
                      });
                    }
                  },

                ),
              ],
            ),),

        ));
  }

  Future<bool> _onBackPressed() async {
    Navigator.of(context, rootNavigator: true).pop();
    return true;
  }

}
