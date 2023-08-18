

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../appbarWidget.dart';
import '../models/userdata.dart';
import 'AppTheam.dart';
import 'Masters_UI/cuWidgets.dart';
import 'Models/LedgerGroupsModel.dart';

class Account_Grp extends StatefulWidget {
  @override
  _Account_GrpState createState() => _Account_GrpState();
}


class _Account_GrpState extends State<Account_Grp> {

  CUWidgets cw=CUWidgets();
  AppTheam theam =AppTheam();

static List<LedgerGrpModel>_ledgerGrpModel=[];
static List<PricelevelModel>_priceLvlModel=[];

  late SharedPreferences pref;
  dynamic data;
  dynamic branch;
  // var res;
  dynamic user;
  late int branchId;
  late int userId;
  late UserData userData;
  String branchName = "";
  dynamic userName;
  late String token;
  late String DeviceId;


  TextEditingController GroupUnderController=TextEditingController();
  TextEditingController GroupNatureController=TextEditingController();
  TextEditingController Pricing_LevelController=TextEditingController();
  TextEditingController NameController=TextEditingController();
  TextEditingController AliasController=TextEditingController();


  bool GroupUnder_Valid=false;
  bool GroupNature_Valid=false;
  bool Pricing_Level_Valid=false;
  bool Name_Valid=false;


  int GroupUnder_id = 0;
  int GroupNature_id = 0;
  int Pricing_Level_id = 0;


  bool Show_GroupNature=false;
  late LedgerGrpModel AccData;
  dynamic NaturePrimaryName;
  int Edit_Id = 0; // Defaulted to 0
  String dropdownValue = 'No';
  dynamic ButtonName = "Save";



  initState(){
    SharedPreferences.getInstance().then((value) {
      pref=value;
      read();
      GetGrpUnder();
      GetPriceLvl();
    });
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

// //----------------------------------





GetGrpUnder()async {
  var res = await cw.CUget_With_Parm(api: "MledgerGroups", Token: token);

  if (res != false) {
    // print("res");
    // print(json.decode(res));
    List<dynamic> jsondata = json.decode(res)["mledgerGroup"];

    _ledgerGrpModel = jsondata.map((e) => LedgerGrpModel.fromJson(e)).toList();
    return _ledgerGrpModel;
  }
}





GetPriceLvl()async {
    var res = await cw.CUget_With_Parm(api: "MpricingLevels", Token: token);

    if (res != false) {
      print("GetPriceLvl");
      print(json.decode(res));
      List<dynamic> jsondatas = json.decode(res);

      _priceLvlModel = jsondatas.map((e) => PricelevelModel.formJson(e)).toList();
      // return _priceLvlModel;
    }
  }


 Save()async {
   bool _validation =await Validation();
   print(_validation.toString());
   if(_validation==true) {
     var Accdataparm = {
       "lgName": NameController.text,
       "lgAliasName": AliasController.text,
       "lgUnderGruupId": GroupUnder_id,
       "groupUnder": GroupUnderController.text,
       "lgPrimaryId": GroupNature_id,
       "lgPrimaryName": NaturePrimaryName,
       "lgType": "U",
       "lgGrpBehaveSubLedger": dropdownValue == "Yes" ? true : false,
       "lgUserId": userId,
       "lgBranchId": branchId,
       "lgPriceLevelId": Pricing_Level_id,
     };

     AccData = LedgerGrpModel(
       id: Edit_Id,
       lgName: NameController.text,
       lgAliasName: AliasController.text,
       lgUnderGruupId: GroupUnder_id,
       groupUnder: GroupUnderController.text,
       lgPrimaryId:GroupNature_id,
       lgPrimaryName:NaturePrimaryName,
       lgType: "U",
       lgGrpBehaveSubLedger: dropdownValue == "Yes" ? true : false,
       lgUserId: userId,
       lgBranchId: branchId,
       lgPriceLevelId: Pricing_Level_id,
     );

if(ButtonName=="Save") {
  print(json.encode(Accdataparm).toString());
  var postdata = json.encode(Accdataparm);
  var res = await cw.post(api: "MledgerGroups",
      body: postdata,
      deviceId: DeviceId,
      Token: token);

  if (res != false) {
    print("res");
    print(res);
    Clear();
    cw.SavePopup(context);
  }
  else {
    cw.FailePopup(context);
  }
}
//----------Edit part-----------------------
else{

  print("on Edit");
  print(json.encode(AccData).toString());
  var putdata = json.encode(AccData);
  var res = await cw.put(api:"MledgerGroups/$Edit_Id",
      body: putdata,
      deviceId: DeviceId,
      Token: token);

  if (res != false) {
    print("res");
    print(res);
    Clear();
    cw.UpdatePopup(context);
  }
  else {
    cw.FailePopup(context);
  }

}
   }
 }




  Clear(){
  setState(() {
     GroupUnderController.text="";
     GroupNatureController.text="";
     Pricing_LevelController.text="";
     NameController.text="";
     AliasController.text="";
     NaturePrimaryName="";

     GroupUnder_Valid=false;
     GroupNature_Valid=false;
     Pricing_Level_Valid=false;
     Name_Valid=false;


     GroupUnder_id=0;
     GroupNature_id=0;
     Pricing_Level_id=0;


     Show_GroupNature=false;

     dropdownValue="No";
     ButtonName="Save";
     Edit_Id=0;
  });


  }

   Validation() {
     if (NameController.text == "") {
       setState(() {
         Name_Valid = true;
       });
       return false;
     } else if (GroupUnder_id.toString() == "null") {
       setState(() {
         GroupUnder_Valid = true;
         Name_Valid = false;
       });
       return false;
     }
     else {
       setState(() {
         GroupUnder_Valid = false;
         Name_Valid = false;
       });
       return true;
     }
   }



  EditBind(data) {

    print(data.id);
    Edit_Id=data.id;
    setState(() {
      ButtonName="Update";
      GroupUnderController.text=data.groupUnder;
      GroupNatureController.text=data.lgPrimaryName;
     // Pricing_LevelController.text=data.lgPriceLevelId;
      NameController.text=data.lgName;
      AliasController.text=data.lgAliasName;
      NaturePrimaryName=data.lgPrimaryName;

      GroupUnder_id=data.lgUnderGruupId;
      GroupNature_id=data.lgPrimaryId;
      Pricing_Level_id=data.lgPriceLevelId;
      dropdownValue=data.lgGrpBehaveSubLedger==true?"Yes":"No";

      if(GroupUnder_id.toString()=="0"){
        setState(() {
          Show_GroupNature=true;
        });
      }
      else{
        setState(() {
          Show_GroupNature=false;
        });
      }

    });

  }



  Delete(id)async {
print("Delete");
print(id.toString());
    var res=await cw.delete(api:"MledgerGroups/$id",deviceId: DeviceId,Token: token);
if(res!=false) {
  cw.DeletePopup(context);
  Clear();
}
else{
  cw.FailePopup(context);
}


  }


  ///-----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(child: Appbarcustomwidget(uname: userName, branch: branchName, pref: pref, title:"Account Group"), preferredSize: Size.fromHeight(80)),




        body: ListView(children: [

           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Column(
               children: [
                 cw.CUTestbox(
                     label: "Name",
                     controllerName: NameController,
                    errorcontroller: Name_Valid,
                ),
                 SizedBox(height: 8,),

                 cw.CUTestbox(label: "Alias",
                 controllerName: AliasController),
                 SizedBox(height: 8,),

                 PricingLevelTextBox(),
                 SizedBox(height: 8,),

                 Group_Under_TextBox(),
                 SizedBox(height: 8,),

                 Visibility(visible: Show_GroupNature==true,
                     child: GroupNatureTextBox()),
                  SizedBox(height: 3,),
              Row(children: [
                Text(" Group behave like Subledger   : ",style: TextStyle(fontSize: 19),),
                SizedBox(width: 100,
                    height:40,child: Dropdown_Button ()),
              ],)

               ],
             ),
           ),

              // Divider(color: Colors.teal,indent: 5,endIndent: 5,thickness: 1,),

               SizedBox(height: MediaQuery.of(context).size.height/2.39,
                 child: SingleChildScrollView(scrollDirection:Axis.vertical ,
                   child: SingleChildScrollView(scrollDirection:Axis.horizontal,
                     child:_ledgerGrpModel.length>0 ?
                     FutureBuilder(
                         future: GetGrpUnder(),
                       initialData:GetGrpUnder(),
                       builder: (context, snapshot) => DataTable(
                         columnSpacing: 6,
                           headingRowColor: theam.TableHeadRowClr,
                           dataRowHeight: 40,
                           columns: <DataColumn>[
                         DataColumn(
                           label:Text("Name ",style: theam.TableFont,),
                         ),
                         // DataColumn(
                         //   label:Text("Group Under"),
                         // ),
                         // DataColumn(
                         //   label:Text("Primary Under"),
                         // ),
                             DataColumn(
                           label:Text(""),
                         )

                       ],
                         rows:_ledgerGrpModel.map((row) =>
                         DataRow(cells:[
                           DataCell(
                               Text(row.lgName)),

                           // DataCell(Text(row.groupUnder)),

                           // DataCell(Text(row.lgPrimaryName)),
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
                                           print("edit $row");
                                           print(row.lgName);
                                           EditBind(row);
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
                                           Delete(row.id);

                                         },


                                       )
                                     ],),
                                   ),)
                               ],
                               icon: Icon(Icons.more_horiz),
                               //offset: Offset()
                             ),
                           )
                         ]
                         )
                       ).toList()),
                     ):

                         Text("")
                   ),
                 ),
               ),


      ]),



        bottomNavigationBar: Row(
        children: [
          SizedBox(width: 8,),
          Expanded(child: Container(height: 50,child: cw.CUButton(function: (){
            Save();
          },
              name:ButtonName,Labelstyl: TextStyle(fontSize: 25,color: Colors.white),
              color:theam.saveBtn_Clr
          ))),



          Expanded(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(height: 50,child: cw.CUButton(function: (){
              Clear();
            }, color: Colors.indigo,name: "Clear",Labelstyl: TextStyle(fontSize: 25,color: Colors.white))),
          )),


        ],
      ),

      ),




    );
  }


  //-----------------------Group_Under_TextBo---------------------------
TypeAheadField<LedgerGrpModel> Group_Under_TextBox() {
  return TypeAheadField(
                 textFieldConfiguration: TextFieldConfiguration(
                    controller: GroupUnderController,
                   style: TextStyle(),
                   decoration: InputDecoration(
                     errorStyle: TextStyle(color: Colors.red),
                     errorText: GroupUnder_Valid ? "Invalid Group Under" : null,
                     suffixIcon: IconButton(
                       icon: Icon(Icons.remove_circle),
                       color: Colors.blue,
                       onPressed: () {
                         print("cleared");
                         GroupUnderController.text = "";
                       },
                     ),

                     isDense: true,
                     contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 16.0),
                     border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(10.0)),
                     hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                     labelText: "Group Under",
                   ),
                 ),
                 suggestionsBoxDecoration:
                 SuggestionsBoxDecoration(elevation: 90.0),
                 suggestionsCallback: (pattern) {
//                        print(payment);
                   return _ledgerGrpModel.where((Lgrp) => Lgrp.lgName.toString().trim().toLowerCase().contains(pattern));
                 },
                 itemBuilder: (context, suggestion) {
                   return Card(
                     margin: EdgeInsets.all(2),
                     color: Colors.white,
                     child: ListTile(
                       tileColor:theam.DropDownClr,
                       title: Column(
                         children: [
                           Text(
                             suggestion.lgName,
                             style: TextStyle(color: Colors.white),
                           ),
                         ],
                       ),
                     ),
                   );
                 },
                 onSuggestionSelected: (suggestion) {
                   print( suggestion.lgName);
                   print("Group Under selected");

                   GroupUnderController.text =  suggestion.lgName;
                   GroupUnder_id= suggestion.id;
                   print("...........");
                   print("....$GroupUnder_id.......");
                   if(GroupUnder_id.toString()=="0"){
                      setState(() {
                        Show_GroupNature=true;
                      });
                   }
                   else{
                     setState(() {
                       GroupNature_id= suggestion.lgPrimaryId;
                       NaturePrimaryName=suggestion.lgPrimaryName;
                       Show_GroupNature=false;
                     });
                   }
                 },
                 errorBuilder: (BuildContext context, Object? error) =>
                     Text(
                         '$error',
                         style: TextStyle(color: Theme
                             .of(context)
                             .errorColor)),
                 transitionBuilder:
                     (context, suggestionsBox, animationController) =>
                     FadeTransition(
                       child: suggestionsBox,
                       opacity: CurvedAnimation(
                           parent: animationController!,
                           curve: Curves.elasticIn),
                     )
               );
}


List  GroupNature=[{"id":1,"name":"Assets"},
  {"id":2,"name":"Expenses"},
  {"id":3,"name":"Income"},
  {"id":4,"name":"Liabilities"}];

  //-----------------------Group_Nature_TextBo---------------------------
  TypeAheadField GroupNatureTextBox() {
    return TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
          controller: GroupNatureController,
          style: TextStyle(),
          decoration: InputDecoration(
            errorStyle: TextStyle(color: Colors.red),
            errorText: GroupNature_Valid ? "Invalid Group Nature" : null,
            suffixIcon: IconButton(
              icon: Icon(Icons.remove_circle),
              color: Colors.blue,
              onPressed: () {
                print("cleared");
                GroupNatureController.text = "";
              },
            ),

            isDense: true,
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 16.0),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0)),
            hintStyle: TextStyle(color: Colors.black, fontSize: 15),
            labelText: "Group Nature",
          ),
        ),
        suggestionsBoxDecoration:
        SuggestionsBoxDecoration(elevation: 90.0),
        suggestionsCallback: (pattern) {
//                        print(payment);
          return GroupNature.where((Lgrp) => Lgrp["name"].toString().trim().toLowerCase().contains(pattern));
        },
        itemBuilder: (context, suggestion) {
          return Card(
            margin: EdgeInsets.all(2),
            color: Colors.white,
            child: ListTile(
              tileColor: Colors.blueAccent,
              title: Column(
                children: [
                  Text(
                    suggestion["name"],
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          );
        },
        onSuggestionSelected: (suggestion) {
          print( suggestion["name"]);
          print("Group Nature selected");

          GroupNatureController.text =  suggestion["name"];
          NaturePrimaryName=suggestion["name"];
          GroupNature_id= suggestion["id"];
          print("...........");
          print("....$GroupNature_id.......");
        },
        errorBuilder: (BuildContext context, Object? error) =>
            Text(
                '$error',
                style: TextStyle(color: Theme
                    .of(context)
                    .errorColor)),
        transitionBuilder:
            (context, suggestionsBox, animationController) =>
            FadeTransition(
              child: suggestionsBox,
              opacity: CurvedAnimation(
                  parent: animationController!,
                  curve: Curves.elasticIn),
            )
    );
  }





  //-----------------------Pricing Level_TextBo---------------------------
  TypeAheadField<PricelevelModel>PricingLevelTextBox() {
    return TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
          controller: Pricing_LevelController,
          style: TextStyle(),
          decoration: InputDecoration(
            errorStyle: TextStyle(color: Colors.red),
            errorText: Pricing_Level_Valid ? "Invalid Pricing Level" : null,
            suffixIcon: IconButton(
              icon: Icon(Icons.remove_circle),
              color: Colors.blue,
              onPressed: () {
                print("cleared");
                Pricing_LevelController.text = "";
              },
            ),

            isDense: true,
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 16.0),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0)),
            hintStyle: TextStyle(color: Colors.black, fontSize: 15),
            labelText: "Pricing Level",
          ),
        ),
        suggestionsBoxDecoration:
        SuggestionsBoxDecoration(elevation: 90.0),
        suggestionsCallback: (pattern) {
//                        print(payment);
          return _priceLvlModel.where((PLvl) => PLvl.plDescription.toString().trim().toLowerCase().contains(pattern));

        },
        itemBuilder: (context, suggestion) {
          return Card(
            margin: EdgeInsets.all(2),
            color: Colors.white,
            child: ListTile(
              tileColor:theam.DropDownClr,
              title: Column(
                children: [
                  Text(
                    suggestion.plDescription,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        },
        onSuggestionSelected: (suggestion) {
          print( suggestion.plDescription);
          print("price Levelselected");

          Pricing_LevelController.text =  suggestion.plDescription;
          Pricing_Level_id= suggestion.id;
          print("...........");
          print("....$Pricing_Level_id.......");



        },
        errorBuilder: (BuildContext context, Object? error) =>
            Text(
                '$error',
                style: TextStyle(color: Theme
                    .of(context)
                    .errorColor)),
        transitionBuilder:
            (context, suggestionsBox, animationController) =>
            FadeTransition(
              child: suggestionsBox,
              opacity: CurvedAnimation(
                  parent: animationController!,
                  curve: Curves.elasticIn),
            )
    );
  }


Widget  Dropdown_Button () {

    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down_outlined),
      iconSize: 30,
      elevation: 16,
      //dropdownColor: Colors.tealAccent,
      style: const TextStyle(color: Colors.deepPurple),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>['Yes','No'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text("   "+value,style: TextStyle(fontSize: 18),),
        );
      }).toList(),
    );

}

}












class PricelevelModel{
  dynamic plDescription;
  dynamic id;

  PricelevelModel({this.id, this.plDescription});

  PricelevelModel.formJson(Map<String,dynamic>data) {
    id = data['id'];
    plDescription = data['plDescription'];
  }
}