import 'dart:async';
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

class Master_Location extends StatefulWidget {
  @override
  _Master_LocationState createState() => _Master_LocationState();
}

class _Master_LocationState extends State<Master_Location> {


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

  TextEditingController Mstr_Location_Controller = TextEditingController();
  TextEditingController Mstr_Area_Controller = TextEditingController();

bool Mstr_Location_Validation=false;
bool Mstr_Area_Validation=false;



int Mstr_Area_Id=0;

var Edit_Id=null;
var Location_List=[];
  static List<Area> area = [];
// //----------------------------------
  void initState() {
    setState(() {
      SharedPreferences.getInstance().then((value) {
        pref = value;
        read();
        GetArea();
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
    var index = Location_List.indexOf(item);
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


    List<dynamic> JsonArea=jsonDecode(json.body)["mArea"];
    List<Area>areajsondata =JsonArea.map((JsonArea) => Area.formJson(JsonArea)).toList();

    area=areajsondata;
  }




  bool TableShow=true;

  //---------MLocations-------------------
  GetLocation()async{
// print("in GetArea");
    final _json= await http.get("${Env.baseUrl}MLocations" as Uri,
        headers: {
          "Authorization": user.user["token"],
        }
    ) ;

    if(_json.statusCode==200||_json.statusCode==201){

      print("MLocations result");
      print(_json.body.toString());
      Location_List=jsonDecode(_json.body)["mLocation"];
      var _JsonLocation=jsonDecode(_json.body)["mLocation"];
      print("_JsonLocation");
      print(_JsonLocation);

    }
return Location_List;

  }


Validation(){

    if(Mstr_Location_Controller.text==""){
      setState(() {
        Mstr_Location_Validation=true;
      });
    }else if(Mstr_Area_Id==null||Mstr_Area_Controller.text==""){
      setState(() {
        Mstr_Location_Validation=false;
        Mstr_Area_Validation=true;
      });


    }

    else{

      setState(() {
        Mstr_Location_Validation=false;
        Mstr_Area_Validation=false;
        SaveButtonText=="Save"?Save_Location():Update_Location();
      });

    }

}


  Save_Location()async{

    var parm= {
      "mlName": Mstr_Location_Controller.text,
      "mlAreaId": Mstr_Area_Id,
      "maName": Mstr_Area_Controller.text
    };


    var _parm = json.encode(parm);

    print(_parm);

    var res=await cw.post(api:"MLocations",body:_parm,deviceId: DeviceId,Token: token);

    if(res!=false){
if(res.toString().contains("errorMessage"))
  {
   var  _res=json.decode(res);
   cw.MessagePopup(context, _res["errorMessage"], Colors.lightBlueAccent) ;

  }else{

  cw.SavePopup(context);
  Reset();
}

    }
  }




  Reset(){
    setState(() {
      Mstr_Location_Controller.text = "";
      Mstr_Area_Controller.text ="";
      Mstr_Location_Validation=false;
      Mstr_Area_Validation=false;
      Mstr_Area_Id=0;
      SaveButtonText="Save";
      Edit_Id=null;
    });
  }



  EditBinde(data){
print(data["mlName"]);
    setState(() {
      Mstr_Location_Controller.text =data["mlName"];
      Mstr_Area_Controller.text =data["maName"];
      Mstr_Area_Id=data["mlAreaId"];
      SaveButtonText="Update";
    });

  }




  Update_Location()async{

    var parm= {
      "id":Edit_Id,
      "mlName": Mstr_Location_Controller.text,
      "mlAreaId": Mstr_Area_Id,
      "maName": Mstr_Area_Controller.text
    };


    var _parm = json.encode(parm);

    print(_parm);


    var res= await cw.put(api:"MLocations/$Edit_Id" ,Token: token,deviceId: DeviceId,body:_parm);

    if(res !=false){


      cw.UpdatePopup(context);

      Reset();


    }else{

      cw.FailePopup(context);
    }

  }



Delete_Location(id)async{

  var res= await cw.delete(api:"MLocations/$id" ,Token: token,deviceId: DeviceId);

    if(res !=false){


      cw.DeletePopup(context);

Reset();


    }else{

      cw.FailePopup(context);
    }

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
        title:"Location", ), preferredSize: Size.fromHeight(80)),

      body:ListView(
          shrinkWrap: true,
          children: [

            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: cw.CUTestbox(
                      controllerName: Mstr_Location_Controller,
                      label: "Location",
                      errorcontroller:Mstr_Location_Validation,
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
                            controller: Mstr_Area_Controller,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              errorStyle: TextStyle(color: Colors.red),
                              errorText: Mstr_Area_Validation
                                  ? "Please Select Area ?"
                                  : null,
//                            errorText: _validateName ? "please enter name" : null,
//                            errorBorder:InputBorder.none ,
                              suffixIcon: IconButton(
                                icon: Icon(Icons.remove_circle),
                                color: Colors.blue,
                                onPressed: () {
                                  setState(() {
                                    print("cleared");
                                    Mstr_Area_Controller.text = "";
                                    Mstr_Area_Id = 0;

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
                              'Area search', // i need to decrease height
                            )),
                        suggestionsBoxDecoration:
                        SuggestionsBoxDecoration(elevation: 90.0),
                        suggestionsCallback: (pattern) {
                          return area.where((user) =>
                              user.maName.toUpperCase().contains(pattern.toUpperCase()));
                        },
                        itemBuilder: (context, suggestion) {
                          return Card(
                            color:theam.DropDownClr,
                            child: ListTile(
                              // focusColor: Colors.blue,
                              // hoverColor: Colors.red,
                              title: Text(
                                suggestion.maName,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          print(suggestion.maName);
                          print("selected");

                          Mstr_Area_Controller.text = suggestion.maName;
                          print("close.... $Mstr_Area_Id");
                          Mstr_Area_Id = 0;

                          print(suggestion.id);
                          print("....... Area id");
                          Mstr_Area_Id = suggestion.id;

                          print(Mstr_Area_Id);
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
                future: GetLocation(),
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
                            label: Text('Item Type',style: theam.TableFont,),
                          ),
                          // DataColumn(
                          //   label: Text('Address'),
                          // ),
                          DataColumn(
                            label: Text('Contact No ',style: theam.TableFont,),
                          ),
                          // DataColumn(
                          //   label: Text('Country '),
                          // ),
                          DataColumn(
                            label: Text(''),
                          ),

                        ],
                        rows: Location_List
                            .map(
                              (itemRow) => DataRow(
                            cells: [
                              DataCell(
                                Text(getItemIndex(itemRow).toString()),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Text(itemRow["mlName"].toString()=="null"?"--":itemRow["mlName"]),
                                showEditIcon: false,
                                placeholder: false,
                              ),



                              DataCell(
                                Text(itemRow["maName"].toString()=="null"?"--":itemRow["maName"]),
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
                                        child: Row(
                                          children: [
                                          GestureDetector(child:
                                          Padding(
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
                                              Delete_Location(itemRow["id"]);

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






class LocationList {
  late int id;
  dynamic mlName;
  var mlAreaId;
  dynamic maName;

  LocationList({required this.id,this.mlName,this.mlAreaId,this.maName});

  LocationList.formJson(Map<String, dynamic> json ){

    id=json["id"];
    mlName=json["mlName"];
    mlAreaId=json["mlAreaId"];
    maName=json["maName"];
  }


}

