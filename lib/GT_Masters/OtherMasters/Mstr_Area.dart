import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../Utility/ledgerBalanceCreate2.dart';
import '../../appbarWidget.dart';
import '../../models/userdata.dart';
import '../../urlEnvironment/urlEnvironment.dart';
import '../AppTheam.dart';
import '../Masters_UI/cuWidgets.dart';
import 'Mstr_District.dart';

class Master_Area extends StatefulWidget {
  @override
  _Master_AreaState createState() => _Master_AreaState();
}

class _Master_AreaState extends State<Master_Area> {


  CUWidgets cw=CUWidgets();
  AppTheam theam =AppTheam();

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


  var  SaveButtonText="Save";

  TextEditingController Master_Area_Controller = TextEditingController();
  TextEditingController Master_District_Controller = TextEditingController();

  bool Master_Area_Validation=false;
  bool Master_District_Validation=false;



  int Master_District_Id=0;

 var  Edit_Id=null;
  var Area_Data=[];
  static List<Area> area = [];
  static List<DistrictList> _districtList = [];
// //----------------------------------
  void initState() {
    setState(() {
      SharedPreferences.getInstance().then((value) {
        pref = value;
        read();
        GetDistrict();
      });
    });
  }

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



  getItemIndex(dynamic item) {
    var index = Area_Data.indexOf(item);
    return index + 1;
  }


//-----------get area---------------------------
  GetArea()async{
// print("in GetArea");
    final json= await http.get("${Env.baseUrl}mareas" as Uri,
        headers: {
          "Authorization": user.user["token"],
        }
    ) ;

//print(json.body.toString());
    Area_Data=jsonDecode(json.body)["mArea"] as List;

    List<dynamic> JsonArea=jsonDecode(json.body)["mArea"];
    List<Area>areajsondata =JsonArea.map((JsonArea) => Area.formJson(JsonArea)).toList();

    area=areajsondata;
    return  area;
  }




  bool TableShow=true;

  //---------MLocations-------------------
  GetDistrict()async{
// print("in GetArea");
    final _json= await http.get("${Env.baseUrl}MDistricts" as Uri,
        headers: {
          "Authorization": user.user["token"],
        }
    ) ;

    if(_json.statusCode==200||_json.statusCode==201){


      List<dynamic> JsonDis=jsonDecode(_json.body)["mDistrict"];
      List<DistrictList>Disjsondata =JsonDis.map((JsonDis) => DistrictList.formJson(JsonDis)).toList();

      _districtList=Disjsondata;

    }


  }


  Validation(){

    if(Master_Area_Controller.text==""){
      setState(() {
        Master_Area_Validation=true;
      });
    }else if(Master_District_Id==null||Master_District_Controller.text==""){
      setState(() {
        Master_Area_Validation=false;
        Master_District_Validation=true;
      });


    }

    else{

      setState(() {
        Master_Area_Validation=false;
        Master_District_Validation=false;
        SaveButtonText=="Save"?Save_Area():Update_Location();
      });

    }

  }


  Save_Area()async{


var parm={

  "maName": Master_Area_Controller.text,
  "maDistrictId": Master_District_Id,
  "mdName": Master_District_Controller.text
};


var _parm=json.encode(parm);


print(_parm);

var res=await cw.post(api:"mareas",body:_parm,deviceId: DeviceId,Token: token);

if(res!=false){


  cw.SavePopup(context);
  Reset();
}


  }





  EditBinde(data){
    print(data["mdName"]);
    setState(() {
      Master_Area_Controller.text =data["maName"];
      Master_District_Controller.text =data["mdName"];
      Master_District_Id=data["maDistrictId"];
      SaveButtonText="Update";
    });

  }




  Update_Location()async{


    var parm={
      "id":Edit_Id,
      "maName": Master_Area_Controller.text,
      "maDistrictId": Master_District_Id,
      "mdName": Master_District_Controller.text
    };

    var _parm = json.encode(parm);

    print(_parm);


    var res= await cw.put(api:"mareas/$Edit_Id" ,Token: token,deviceId: DeviceId,body:_parm);

    if(res !=false){


      cw.UpdatePopup(context);

      Reset();


    }else{

      cw.FailePopup(context);
    }

  }



  Delete_District(id)async{

    var res= await cw.delete(api:"mareas/$id" ,Token: token,deviceId: DeviceId);

    if(res !=false){


      cw.DeletePopup(context);

      Reset();


    }else{

      cw.FailePopup(context);
    }

  }






  Reset(){

    setState(() {

        Master_Area_Controller.text = "";
        Master_District_Controller.text = "";

        Master_Area_Validation=false;
        Master_District_Validation=false;



        Master_District_Id=0;
        Edit_Id=null;
    });
  }
  ///------------------------------------------------------------

  @override
  Widget build(BuildContext context) {

    return SafeArea(child: Scaffold(
      appBar:
      PreferredSize(child: Appbarcustomwidget(
        uname:userName,
        branch:branchName,
        pref:pref,
        title:"Area", ), preferredSize: Size.fromHeight(80)),

      body:ListView(
          shrinkWrap: true,
          children: [

            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: cw.CUTestbox(
                      controllerName: Master_Area_Controller,
                      label: "Area",
                      errorcontroller:Master_Area_Validation,

                    ),
                  ),
                ),

              ],
            ),


            Padding(
              padding: const EdgeInsets.fromLTRB(8,0,8,8),
              child: Row(
                children: [
                  Expanded(
                    child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                            style: TextStyle(),
                            controller: Master_District_Controller,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              errorStyle: TextStyle(color: Colors.red),
                              errorText: Master_District_Validation
                                  ? "Please Select District ?"
                                  : null,
//                            errorText: _validateName ? "please enter name" : null,
//                            errorBorder:InputBorder.none ,
                              suffixIcon: IconButton(
                                icon: Icon(Icons.remove_circle),
                                color: Colors.blue,
                                onPressed: () {
                                  setState(() {
                                    print("cleared");
                                    Master_District_Controller.text = "";
                                    Master_District_Id = 0;

                                  });
                                },
                              ),

                              isDense: true,
                              contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              // i need very low size height
                              labelText:
                              'District search', // i need to decrease height
                            )),
                        suggestionsBoxDecoration:
                        SuggestionsBoxDecoration(elevation: 90.0),
                        suggestionsCallback: (pattern) {
                          return _districtList.where((user) =>
                              user.mdName.toUpperCase().contains(pattern.toUpperCase()));
                        },
                        itemBuilder: (context, suggestion) {
                          return Card(
                            color:theam.DropDownClr,
                            child: ListTile(
                              // focusColor: Colors.blue,
                              // hoverColor: Colors.red,
                              title: Text(
                                suggestion.mdName,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          print(suggestion.mdName);
                          print("selected");

                          Master_District_Controller.text = suggestion.mdName;
                          print("close.... $Master_District_Id");
                          Master_District_Id = 0;

                          print(suggestion.id);
                          print("....... District id");
                          Master_District_Id = suggestion.id;

                          print(Master_District_Id);
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

                ],
              ),
            ),



            Visibility(visible: TableShow,
              child: FutureBuilder(
                future: GetArea(),
                builder: (context, snapshot) {
                  // print("iuyi");
                  // print(snapshot.data.toString());
                  // print(snapshot.connectionState.toString());

                  if(snapshot.data.toString()=="null"||snapshot.data==[]) {
                    return Center(child: Text("No Data!"));
                  }
                  else if(snapshot.connectionState.toString()=="ConnectionState.waiting") {
                    return Center(child: Text("Loading...."));
                  }
                  return
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 20,
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
                            label: Text('Area',style: theam.TableFont,),
                          ),
                          // DataColumn(
                          //   label: Text('Country '),
                          // ),
                          DataColumn(
                            label: Text(''),
                          ),

                        ],
                        rows: Area_Data
                            .map(
                              (itemRow) => DataRow(
                            cells: [
                              DataCell(
                                Text(getItemIndex(itemRow).toString()),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Text(itemRow["maName"]),
                                showEditIcon: false,
                                placeholder: false,
                              ),





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
                                              print("edit $itemRow");
                                              setState(() {
                                                 Edit_Id=itemRow["id"];
                                              });
                                              EditBinde(itemRow);
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
                                              Delete_District(itemRow["id"]);

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
                      ),
                    );

                },
              ),
            )
          ]),

      bottomNavigationBar:    SizedBox(height: 80,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 4, 1),
                child: cw.CUButton(H: 50,name: SaveButtonText,W: 60,
                    function: (){Validation();},
                    Labelstyl: TextStyle(
                        fontSize: 30,
                        color: Colors.white
                    ),
                    color:theam.saveBtn_Clr),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 8, 1),
                child: cw.CUButton(color: Colors.indigo,H: 50,name:"Back",W: 60,
                    Labelstyl: TextStyle(
                        fontSize: 30,
                        color: Colors.white
                    ),
                    function: (){

                      Navigator.of(context,rootNavigator: false).pop();

                    }),
              ),
            ),


          ],),
      ),

    ));
  }
}






