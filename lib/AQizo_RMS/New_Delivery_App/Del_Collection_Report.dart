import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../GT_Masters/AppTheam.dart';
import '../../appbarWidget.dart';
import '../../models/userdata.dart';

class Del_Collection_Report extends StatefulWidget {
  @override
  _Del_Collection_ReportState createState() => _Del_Collection_ReportState();
}

class _Del_Collection_ReportState extends State<Del_Collection_Report> {

  //------------------For App Bar------------------------
  late SharedPreferences pref;
  dynamic branch;
  var res;
  dynamic user;
  late int branchId;
  late int userId;
  late UserData userData;
  String branchName = "";
  dynamic userName;
  late String token;


  AppTheam theam =AppTheam();

  var TableData=[
    {"no":1,"Name":"Name1","val":100,"Coll":"","blnc":""},
    {"no":2,"Name":"Name2","val":370,"Coll":"","blnc":""},
    {"no":3,"Name":"Name3","val":54,"Coll":"","blnc":""},

 ];



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
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    SharedPreferences.getInstance().then((value) {
      pref = value;
      read();
    });
    super.initState();
  }

var Tablext="";







  ChangeAmt(a,itemRow){


    TableData.forEach((element) {
      if(element["no"]==itemRow["no"])
        setState(() {

          element["blnc"]="45";
        });


    });







}


///-----------------------------------
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(190.0),
        child: Appbarcustomwidget(
          branch: branchName,
          pref: pref,
          title: "RMS Home",
          uname: userName,
        )),


    body: ListView(children: <Widget>[

      Row(
        children: [
          Expanded(
            child: DataTable(
              columnSpacing: 17,
              headingRowColor: theam.TableHeadRowClr,
              onSelectAll: (b) {},
              sortAscending: true,
              columns: <DataColumn>[
                DataColumn(
                  label: Text('No',style: theam.TableFont,),
                ),
                DataColumn(
                  label: Text('Voucher Date',style: theam.TableFont,),
                ),


                DataColumn(
                  label: Text(' Rate',style: theam.TableFont,),
                ),

                DataColumn(
                  label: Text(' Coll',style: theam.TableFont,),
                ),


                DataColumn(
                  label: Text('Blnce',style: theam.TableFont,),
                ),


             // DataColumn(
             //      label: Text('',style: theam.TableFont,),
             //    ),

              ],
              rows: TableData
                  .map(
                    (itemRow) => DataRow(
                  cells: [
                    DataCell(
                      Text(
                          '${itemRow['no'].toString()}'),
                      showEditIcon: false,
                      placeholder: false,
                    ),

                    DataCell(
                      GestureDetector(
                        onTap: () {},
                        child: Text('${itemRow['Name'].toString()}'),

                      ),
                      showEditIcon: false,
                      placeholder: false,
                    ),

               DataCell(
                 Text(
                     '${itemRow['val'].toString()}'),
              ),



               DataCell(
                  TextFormField(
                    decoration:InputDecoration(
                      hintText: "Enter",
                        border: InputBorder.none
                    ) ,
                  keyboardType:TextInputType.number ,
                    controller: TextEditingController(text:itemRow['Coll'].toString()),
                    onTap: (){
                      // setState(() {
                      // });
                    },

                    onChanged: (a){




                           // itemRow['Coll'] = a;
                          //  ChangeAmt(a,itemRow);
                            itemRow['Coll'] = a;
                           // return;
                         //   Tablext=a;
                            // try{
                           print("poipoipoi");
                           print(itemRow['Coll'].toString());
                           print(itemRow['Coll'].toString().length.toString());
                              TextEditingController().selection=TextSelection.fromPosition(
                                  TextPosition(offset:itemRow['Coll'].toString().length,
                                  affinity: TextAffinity.upstream,)
                              );
                            // }
                            // catch(e){
                            //   print(e);
                            //
                            // }



                            // var chars = a.split('');
                            // var aa= chars.reversed.join();
                            //
                            // print(aa.toString());

                            if(a!="") {
                            // double amt = double.parse(itemRow['val'].toString());
                            double amt = double.parse(itemRow['val'].toString());

                            double coll = double.parse(a);


                            double blnse = amt - coll;

                            print(blnse.toString());
                            setState(() {
                              itemRow['blnc'] = blnse.toString();
                              print(itemRow);
                            });

                          }else{
                            setState(() {
                              itemRow['blnc'] = itemRow['val'].toString();
                              itemRow['Coll']="";
                            });
                          }

                    },
                    // initialValue: element.itemB,
                ),
              ),
                    DataCell(
                      Text((itemRow['blnc'].toString()==""? itemRow['val'].toString():itemRow['blnc'].toString()),


                      ),
                    ),

                    // DataCell(
                    //  IconButton(icon: Icon(Icons.edit_attributes_sharp), onPressed: (){
                    //    print(itemRow);
                    //  })
                    // )


                  ],
                ),
              )
                  .toList(),
            ),
          ),




        ],
      ),
      // TextButton(onPressed: (){
      //   launch("tel:8232423445");
      // }, child: Text("8232423445"))

    ]),


      ),
    );
  }
}
