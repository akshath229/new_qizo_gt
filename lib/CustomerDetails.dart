import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:new_qizo_gt/urlEnvironment/urlEnvironment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'GT_Masters/AppTheam.dart';
import 'appbarWidget.dart';
import 'models/userdata.dart';

class Customer_Details extends StatefulWidget {
  @override
  _Customer_DetailsState createState() => _Customer_DetailsState();
}

class _Customer_DetailsState extends State<Customer_Details> {



  AppTheam theam=AppTheam();
  TextEditingController AreaController=TextEditingController();




  bool areaSelect=false;
  int areaId=0;
  String AreaName="";
var arealist=[];
  bool allDataList=false;
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
  var DeviceId;


//--------------------------------


var   userlist=[];
 var tablevisible=-1;
bool show=false;


  void initState() {
    setState(() {
      SharedPreferences.getInstance().then((value) {
        pref = value;
        read();
        GetArea();
      });
    });
  }

//-----------get area---------------------------

  GetArea()async{
    print("in GetArea");
    final json= await http.get("${Env.baseUrl}mareas" as Uri,
        headers: {
          "Authorization": user.user["token"],
        }
    ) ;

    print(json.body.toString());
    arealist=jsonDecode(json.body)["mArea"] as List;

  }



//--------------------------------------------
  GetUser(id)async{
    print("in GetUser");
    final json= await http.get("${Env.baseUrl}MLedgerHeads/$id/-6" as Uri,
        headers: {
          "Authorization": user.user["token"],
        }
    ) ;
if(json.statusCode==200||json.statusCode==201) {
  //print(json.body.toString());


   Timer(Duration(seconds: 1),(){
     setState(() {
     show=false;
     userlist=jsonDecode(json.body)["accList"] as List;
     usersFiltered=jsonDecode(json.body)["accList"] as List; //for list data while enter tthe page
     tablevisible=userlist.length;
     });
   }

   );



}else
  {
    setState(() {
      show=false;
      tablevisible=0;
    });


  }


  }




  
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



//---------------Reset Function-----------------------

  ResetFunction(){

    setState(() {
      areaSelect=false;
      areaId=0;
      AreaName="";
      AreaController.text="";

    });



  }



  getItemIndex(dynamic item) {
      var index = userlist.indexOf(item);
      return index + 1;

  }


//----------------list all data while click checkbox----------------------
  ListAllData(allDataList){

   // print("allDataList");
    //print(allDataList.toString());
    if(allDataList==true){
      GetUser(0);
AreaController.text="";

  }else{
      Timer(Duration(seconds: 1),() {
        setState(() {
          show  = false;
        });
      });

    }
          }





//---------test for search datatable------
 var usersFiltered=[];
TextEditingController TblSearchController =TextEditingController();
TextEditingController TblNumSearchController =TextEditingController();
  String _searchResult = '';

//---------test for search datatable------






  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: Appbarcustomwidget(
                uname:userName, branch:branchName, pref: pref, title: "Customer"),

          ),


          body: ListView(
              children: [
            SizedBox(height: 10,),


            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8,0,8,8),
                    child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                            style: TextStyle(),
                            enabled: !allDataList,
                            controller: AreaController,
                            decoration: InputDecoration(
                              errorStyle: TextStyle(color: Colors.red),
                              errorText: areaSelect
                                  ? "Please Select Customer ?"
                                  : null,
//                            errorText: _validateName ? "please enter name" : null,
//                            errorBorder:InputBorder.none ,
                              suffixIcon: IconButton(
                                icon: Icon(Icons.remove_circle),
                                color: Colors.blue,
                                onPressed: () {
                                  setState(() {
                                    print("cleared");
                                    AreaController.text = "";
                                    areaId = 0;
                                  });
                                },
                              ),

                              isDense: true,
                              contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18.0)),
                              // i need very low size height
                              labelText:
                              'Area search', // i need to decrease height
                            )),
                        suggestionsBoxDecoration:
                        SuggestionsBoxDecoration(elevation: 90.0),
                        suggestionsCallback: (pattern) {
                          return arealist.where((user) =>
                              user["maName"].toString().trim().toLowerCase().contains(pattern.toLowerCase()));
                        },
                        itemBuilder: (context, suggestion) {
                          return Card(
                            color: theam.DropDownClr,
                            child: ListTile(
                              // focusColor: Colors.blue,
                              // hoverColor: Colors.red,
                              title: Text(
                                suggestion["maName"],
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          print(suggestion["maName"]);
                          print("selected");

                          AreaController.text = suggestion["maName"];
                          print("close.... $areaId");
                          areaId = 0;
                          AreaName = suggestion["maName"];
                          print(suggestion["id"]);
                          print("....... Area id");
                          areaId = suggestion["id"];
                         setState(() {
                           tablevisible=-1;
                           show=true;
                           GetUser(areaId);
                         });


                          print(areaId);
                          print("...........");
                        },
                        errorBuilder: (BuildContext context, Object? error) =>
                            Text('$error',
                                style: TextStyle(
                                    color: Theme.of(context).errorColor)),
                        transitionBuilder:
                            (context, suggestionsBox, animationController) =>
                            FadeTransition(
                              child: suggestionsBox,
                              opacity: CurvedAnimation(
                                  parent: animationController!,
                                  curve: Curves.elasticIn),
                            )),
                  ),
                ),

            Text("Show All"),
            Checkbox(
              checkColor: Colors.white,
              // fillColor:Colors.red,
              value: allDataList,
              onChanged: (value) {
                setState(() {
                  allDataList = !allDataList;
                });


                setState(() {
                    tablevisible=-1;
                    show=true;
                  ListAllData(allDataList);

                });
              },
            )
          ],
            ),

            Center(
              child: Visibility(visible: show==true,
                  child: SizedBox(width: 30,height: 30,
                      child: CircularProgressIndicator())),
            ),

           if (tablevisible>0) SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(showCheckboxColumn: false,
                  columnSpacing: 17,
                  onSelectAll: (b) {},
                  sortAscending: true,

                  columns: <DataColumn>[
                    DataColumn(
                      label: Text('No'),
                    ),
                    DataColumn(
                      label: Column(crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('Name'),
                          Container(height: 25,width: 55,
                            child: TextField(style: TextStyle(color: Colors.deepPurple,),
                                controller: TblSearchController,
                                decoration: new InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding:
                                  EdgeInsets.only(bottom: 10, left: 0.5, right:0.5),
                                    hintText: 'Search', ),
                                onChanged: (value) {
                                  setState(() {
                                    _searchResult = value;
                                    usersFiltered = userlist.where((user) => user['name'].toLowerCase().contains(_searchResult) || user['name'].contains(_searchResult)).toList();
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
                          Text('Number'),
                          Container(height: 25,width: 55,
                            child: TextField(
                              style:    TextStyle(color: Colors.deepPurple,),
                                controller: TblNumSearchController,
                                decoration: new InputDecoration(
                                    contentPadding:
                                    EdgeInsets.only(bottom: 10, left: 0.5, right:0.5),
                                    hintText: 'Search', border: InputBorder.none),
                                onChanged: (value) {
                                  setState(() {
                                    _searchResult = value;
                                    usersFiltered = userlist.where((user) => user['contactNo'].toString().contains(_searchResult) || user['contactNo'].toString().contains(_searchResult)).toList();
                                  });
                                }),
                          ),
                        ],
                      ),
                    ),

                    DataColumn(
                      label: Text('Group'),
                    ),

                    DataColumn(
                      label: Text('Mail Name'),
                    ),


                    DataColumn(
                      label: Text('Address 1'),
                    ),

                    DataColumn(
                      label: Text('Address 2'),
                    ),

                    DataColumn(
                      label: Text('Address 3'),
                    ),


                    DataColumn(
                      label: Text('Pin'),
                    ),

                    DataColumn(
                      label: Visibility(visible:allDataList,
                          child: Text('Area')),
                    ),


                    DataColumn(
                      label: Text('Route'),
                    ),


                    DataColumn(
                      label: Text('Email'),
                    ),


                    DataColumn(
                      label: Text('State'),
                    ),




                  ],
                 // rows: userlist.map((itemRow) =>
                  rows: List.generate(usersFiltered.length, (index) =>
                      DataRow(
                      cells: [
                        DataCell(
                          // Text(getItemIndex(userlist).toString()),
                          Text((getItemIndex(userlist[index]).toString())),
                          showEditIcon: false,
                          placeholder: false,
                        ),
                        DataCell(
                          Container(width: 150,
                            child: Text(
                                '${usersFiltered[index]['name'].toString()}'),
                          ),
                          showEditIcon: false,
                          placeholder: false,
                        ),
                        DataCell(
                          Text(
                              '${usersFiltered[index]['contactNo']??"---".toString()}'),//'${usersFiltered[index]['name'].toString()}'),
                          showEditIcon: false,
                          placeholder: false,
                        ),

                        DataCell(
                          Container(width: 120,
                            child: Text(
                                '${usersFiltered[index]['group']??"---".toString()}'),
                          ),
                          showEditIcon: false,
                          placeholder: false,
                        ),

                        DataCell(
                          Container(width: 120,
                            child: Text(
                                '${usersFiltered[index]['mailingName']??"---".toString()}'),
                          ),
                          showEditIcon: false,
                          placeholder: false,
                        ),

                        DataCell(
                          Container(width: 120,
                            child: Text(
                                '${usersFiltered[index]['address1']??"---".toString()}'),
                          ),
                          showEditIcon: false,
                          placeholder: false,
                        ),

                        DataCell(
                          Container(width: 120,
                            child: Text(
                                '${usersFiltered[index]['address2']??"---".toString()}'),
                          ),
                          showEditIcon: false,
                          placeholder: false,
                        ),

                        DataCell(
                          Container(width: 120,
                            child: Text(
                                '${usersFiltered[index]['address3']??"---".toString()}'),
                          ),
                          showEditIcon: false,
                          placeholder: false,
                        ),


                        DataCell(
                          Text(
                              '${usersFiltered[index]['pincode']??"---".toString()}'),
                          showEditIcon: false,
                          placeholder: false,
                        ),


                        DataCell(
                          Visibility(visible:allDataList,
                            child: Text(
                                '${usersFiltered[index]['area']??"---".toString()}'),
                          ),
                          showEditIcon: false,
                          placeholder: false,
                        ),


                        DataCell(
                          Text(
                              '${usersFiltered[index]['route']??"---".toString()}'),
                          showEditIcon: false,
                          placeholder: false,
                        ),


                        DataCell(
                          Text(
                              '${usersFiltered[index]['email']??"---".toString()}'),
                          showEditIcon: false,
                          placeholder: false,
                        ),



                        DataCell(
                          Text(
                              '${usersFiltered[index]['state']??"---".toString()}'),
                          showEditIcon: false,
                          placeholder: false,
                        ),













                      ],
                    ),
                  )
                      .toList(),
                ),
              ),
            )

           else if (tablevisible==0)
             Center(child: Text("Not Available !",style: TextStyle(color: Colors.red,fontSize: 15),))
else Text("")
          ]),








          //
          // bottomNavigationBar:Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: GestureDetector(
          //     onTap: (){
          //
          //
          //     },
          //     child: Container(
          //       color: Colors.blue,
          //       height: 50,
          //       width: MediaQuery.of(context).size.width,
          //       child: Center(child: Text("Save",style: TextStyle(fontSize: 25),)),
          //     ),
          //   ),
          // ) ,


        ));
  }
}
