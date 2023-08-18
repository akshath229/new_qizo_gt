import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../appbarWidget.dart';
import '../../models/userdata.dart';
import '../../urlEnvironment/urlEnvironment.dart';
import '../AppTheam.dart';
import '../Masters_UI/cuWidgets.dart';

class Master_District extends StatefulWidget {
  @override
  _Master_DistrictState createState() => _Master_DistrictState();
}

class _Master_DistrictState extends State<Master_District> {


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

  TextEditingController Mstr_District_Controller = TextEditingController();
  TextEditingController Mstr_State_Controller = TextEditingController();

  bool Mstr_District_Validation=false;
  bool Mstr_State_Validation=false;



  int Mstr_State_Id=0;
var Edit_Id=null;

  var District_List=[];

  static List<DistrictList> _districtlist =[];

  static List<StateList> _statelist = [];
// //----------------------------------
  void initState() {
    setState(() {
      SharedPreferences.getInstance().then((value) {
        pref = value;
        read();
        GetState();
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
    print("item");
    print(District_List);
    var index = District_List.indexOf(item);
    return index + 1;
  }


//------- -------------------------
  GetDistrict()async{
// print("in GetArea");
    final json= await http.get("${Env.baseUrl}MDistricts" as Uri,
        headers: {
          "Authorization": user.user["token"],
        }
    ) ;

//print(json.body.toString());

    District_List=jsonDecode(json.body)["mDistrict"] as List;
    List<dynamic> JsonDistrict=jsonDecode(json.body)["mDistrict"];
    List<DistrictList>Districtdata =JsonDistrict.map((JsonDistrict) => DistrictList.formJson(JsonDistrict)).toList();

    _districtlist=Districtdata;
    return _districtlist;
  }











  bool TableShow=true;



  GetState()async{
// print("in GetArea");
    final _json= await http.get("${Env.baseUrl}mstates" as Uri,
        headers: {
          "Authorization": user.user["token"],
        }
    ) ;

//print(json.body.toString());
    if(_json.statusCode==200||_json.statusCode==201){

      List<dynamic> JsonState=jsonDecode(_json.body);
      List<StateList>statedata =JsonState.map((JsonState) => StateList.formJson(JsonState)).toList();

      _statelist=statedata;

    }


  }







  Validation(){

    if(Mstr_District_Controller.text==""){
      setState(() {
        Mstr_District_Validation=true;
      });
    }else if(Mstr_State_Id==null||Mstr_State_Controller.text==""){
      setState(() {
        Mstr_District_Validation=false;
        Mstr_State_Validation=true;
      });


    }

    else{

      setState(() {
        Mstr_District_Validation=false;
        Mstr_State_Validation=false;
        SaveButtonText=="Save"?Save_District():Update_Location();
      });

    }

  }


  Save_District()async{

var parm={
  "mdName": Mstr_District_Controller.text,
  "mdStateId": Mstr_State_Id,
  "msName": Mstr_State_Controller.text
};


var _parm = json.encode(parm);

print(_parm);

var res=await cw.post(api:"MDistricts",body:_parm,deviceId: DeviceId,Token: token);

if(res!=false){


  cw.SavePopup(context);
  Reset();
}
  }



  Reset(){
    setState(() {
       Mstr_District_Controller.text = "";
       Mstr_State_Controller.text ="";
       Mstr_District_Validation=false;
       Mstr_State_Validation=false;
       Mstr_State_Id=0;
       Edit_Id=null;
    });
  }




  EditBinde(data){
    print(data["mdName"]);
    setState(() {
      Mstr_State_Controller.text =data["msName"];
      Mstr_District_Controller.text =data["mdName"];
      Mstr_State_Id=data["mdStateId"];
      SaveButtonText="Update";
    });

  }




  Update_Location()async{

    var parm={
      "id":Edit_Id,
      "mdName": Mstr_District_Controller.text,
      "mdStateId": Mstr_State_Id,
      "msName": Mstr_State_Controller.text
    };


    var _parm = json.encode(parm);

    print(_parm);


    var res= await cw.put(api:"MDistricts/$Edit_Id" ,Token: token,deviceId: DeviceId,body:_parm);

    if(res !=false){


      cw.UpdatePopup(context);

      Reset();


    }else{

      cw.FailePopup(context);
    }

  }



  Delete_District(id)async{

    var res= await cw.delete(api:"MDistricts/$id" ,Token: token,deviceId: DeviceId);

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
        title:"District", ), preferredSize: Size.fromHeight(80)),

      body:ListView(
          shrinkWrap: true,
          children: [

            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: cw.CUTestbox(
                      controllerName: Mstr_District_Controller,
                      label: "District",
                      errorcontroller:Mstr_District_Validation,
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
                            controller: Mstr_State_Controller,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              errorStyle: TextStyle(color: Colors.red),
                              errorText: Mstr_State_Validation
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
                                    Mstr_State_Controller.text = "";
                                    Mstr_State_Id = 0;

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
                              'State search', // i need to decrease height
                            )),
                        suggestionsBoxDecoration:
                        SuggestionsBoxDecoration(elevation: 90.0),
                        suggestionsCallback: (pattern) {
                          return _statelist.where((user) =>
                              user.msName.toUpperCase().contains(pattern.toUpperCase()));
                        },
                        itemBuilder: (context, suggestion) {
                          return Card(
                            color:theam.DropDownClr,
                            child: ListTile(
                              // focusColor: Colors.blue,
                              // hoverColor: Colors.red,
                              title: Text(
                                suggestion.msName,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          print(suggestion.msName);
                          print("selected");

                          Mstr_State_Controller.text = suggestion.msName;
                          print("close.... $Mstr_State_Id");
                          Mstr_State_Id = 0;

                          print(suggestion.id);
                          print("....... Area id");
                          Mstr_State_Id = suggestion.id;

                          print(Mstr_State_Id);
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
                future: GetDistrict(),
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
                            label: Text('District',style: theam.TableFont,),
                          ),
                          // DataColumn(
                          //   label: Text('Address'),
                          // ),

                          DataColumn(
                            label: Text(''),
                          ),

                        ],
                        rows:District_List
                            .map(
                              (itemRow) => DataRow(
                            cells: [
                              DataCell(
                                Text(getItemIndex(itemRow).toString()),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Text(itemRow["mdName"]),
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





class DistrictList {
  late int id;
  dynamic mdName;
  var mdStateId;
  dynamic msName;

  DistrictList({required this.id,this.mdName,this.mdStateId,this.msName});

  DistrictList.formJson(Map<String, dynamic> json ){

    id=json["id"];
    mdName=json["mdName"];
    mdStateId=json["mdStateId"];
    msName=json["msName"];
  }


}




class StateList {
  late int id;
  dynamic msName;


  StateList({required this.id,this.msName,});

  StateList.formJson(Map<String, dynamic> json ){

    id=json["id"];
    msName=json["msName"];
  }


}