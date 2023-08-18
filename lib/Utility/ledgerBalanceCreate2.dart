import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../AQizo_RMS/RMS_Home2.dart';
import '../GT_Masters/AppTheam.dart';
import '../GT_Masters/Masters_UI/cuWidgets.dart';
import '../GT_Masters/Models/LedgerGroupsModel.dart';
import '../GT_Masters/Models/LedgerHeadesModel.dart';
import '../appbarWidget.dart';
import '../models/userdata.dart';
import '../urlEnvironment/urlEnvironment.dart';

class CreateLedgeBlnc2 extends StatefulWidget {
  var Parm_id;
  String PageType;
  CreateLedgeBlnc2({this.Parm_id,required this.PageType});

  @override
  _CreateLedgeBlnc2State createState() => _CreateLedgeBlnc2State();
}

class _CreateLedgeBlnc2State extends State<CreateLedgeBlnc2> {
  double TextBoxCurve=10.0;
  AppTheam theam =AppTheam();

  static List<LedgerGrpModel>_ledgerGrpModel=[];
  static List<Area> area = [];
  static List<StateMaster> state=[];

  TextEditingController NameController= TextEditingController();
  TextEditingController AreaController=TextEditingController();
  TextEditingController EmaiNameController=TextEditingController();
  TextEditingController Address1Controller=TextEditingController();
  TextEditingController Address2Controller=TextEditingController();
  TextEditingController Address3Controller=TextEditingController();
  TextEditingController PincodeController=TextEditingController();
  TextEditingController StateController=TextEditingController();
  TextEditingController ContactPersonController=TextEditingController();
  TextEditingController ContactNoController=TextEditingController();
  TextEditingController EmailController=TextEditingController();
  TextEditingController PanNoController=TextEditingController();
  TextEditingController GroupUnderController=TextEditingController();
  TextEditingController GstController=TextEditingController();

  TextEditingController nameLatinController=TextEditingController();
  TextEditingController buildingNoController=TextEditingController();
  TextEditingController buildingNoLatinController=TextEditingController();
  TextEditingController streetNameController=TextEditingController();
  TextEditingController streetNameLatinController=TextEditingController();
  TextEditingController districtController=TextEditingController();
  TextEditingController districtLatinController=TextEditingController();
  TextEditingController cityController=TextEditingController();
  TextEditingController cityLatinController=TextEditingController();
  TextEditingController countryController=TextEditingController();
  TextEditingController countryLatinController=TextEditingController();
  TextEditingController pinNoController=TextEditingController();
  TextEditingController pinNoLatinController=TextEditingController();
  TextEditingController OpnBlncController=TextEditingController();


  int? GroupUnder_id=null;
  bool GroupUnder_Valid=false;
  var slnum=0;
  bool areaSelect=false;
  int? areaId=null;
  String AreaName="";
  bool emaliingformShow=true;
  late Icon emaliingformIcon;
  int? StateId=null;
  dynamic  StateName="";
  bool  Namevalid=false;


  late SharedPreferences pref;
  dynamic data;
  dynamic branch;
  //var res;
  dynamic user;
  late int branchId;
  late int userId;
  late UserData userData;
  String branchName = "";
  dynamic userName;
  late String token;
  var DeviceId;



  int opBlnce_DrCr = 0;

//--------------------------------


  CUWidgets cw  =CUWidgets();
  List <LedgerHeads> LedgH= [];

  var Edit_Id=null;
  String ButtonName="Save";
  void initState() {
    setState(() {
      SharedPreferences.getInstance().then((value) {
        pref = value;
        read();
        GetArea();
        GetState();
        GetGrpUnder();

        if(widget.Parm_id==null){
          setState(() {
            print("Create");
            ButtonName=widget.PageType;
            print(widget.Parm_id.toString());
          });

        }
        else {
          setState(() {
            print("Edit Or Delete");
            Edit_Id=widget.Parm_id;
            print(widget.Parm_id.toString());
            ButtonName=widget.PageType;
            EditOrDeleteBind();
          });
        }
      });

    });
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


//-----------get State--------------------------
  GetState()async{
    //  print("in GetState");
    final json= await http.get("${Env.baseUrl}mstates" as Uri,
        headers: {
          "Authorization": user.user["token"],
        }
    ) ;

    //print(json.body.toString());

    List<dynamic> Staedata= jsonDecode(json.body);

    List<StateMaster> Stmstr =Staedata.map((Staedata) => StateMaster.formJson(Staedata)).toList();

    state=Stmstr;
  }


  //-----------get Get GrpUnder--------------------------
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


//----------------validatio part-----------------------------


  Validation(){
    var _tempopBlce=OpnBlncController.text==""?"0":OpnBlncController.text;
    double _OpBlncAmt=double.parse(_tempopBlce);
    if(opBlnce_DrCr==0 && _OpBlncAmt>0)
    {
      cw.MessagePopup(context, "Please Add Op.Balance Type", Colors.red);
      return;
    }

    if(NameController.text==""){

      setState(() {
        Namevalid=true;

      });
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Center(
              child: Text(
                "Please Add Name",
                style: TextStyle(color: Colors.red),
              ),
            ),
//              content: Text("user data:   " + user.user["token"]),
          ));

    }
    else{
      setState(() {
        Namevalid=false;

      });
      SaveLeger();


    }



  }






  //-----------------Save part----------------------------------

  SaveLeger() async {
    if(ButtonName=="Save") {
      print(" in SaveLeger");
      var req = {
        "lhName": NameController.text,
        "lhAliasName": null,
        "lhGroupId": GroupUnder_id,
        "lhType": "S",
        "lhPricingLevelId": null,
        "lhMaintainBillByBill": null,
        "lhCreditPeriod": null,
        "lhMailingName": EmaiNameController.text,
        "lhMailingAddress1": Address1Controller.text,
        "lhMailingAddress2": Address2Controller.text,
        "lhMailingAddress3": Address3Controller.text,
        "lhStateId": StateId,
        "lhPincode": PincodeController.text,
        "lhPanNo": PanNoController.text,
        "lhGstno": GstController.text,
        "lhOpeningBalance": OpnBlncController.text,
        "lhOpeningType": opBlnce_DrCr==1?"Dr":"Cr",
        "lhContactPerson": ContactPersonController.text,
        "lhContactNo": ContactNoController.text,
        "lhEmail": EmailController.text,
        "lhBankName": null,
        "lhAccountNo": null,
        "lhBankBranch": null,
        "lhIfscCode": null,
        "lhAreaId": areaId,
        "lhRemarks": null,
        "lhUserId": userId,
        "lhBranchId": branchId,
        "nameLatin":nameLatinController.text,
        "buildingNo":buildingNoController.text,
        "buildingNoLatin":buildingNoLatinController.text,
        "streetName":streetNameController.text,
        "streetNameLatin":streetNameLatinController.text,
        "district":districtController.text,
        "districtLatin" :districtLatinController.text,
        "city":cityController.text,
        "cityLatin":cityLatinController.text,
        "country":countryController.text,
        "countryLatin":countryLatinController.text,
        "pinNo" : pinNoController.text,
        "pinNoLatin":pinNoLatinController.text
      };

      var parm = json.encode(req);
      print(parm);


      var result = await http.post("${Env.baseUrl}MLedgerHeads" as Uri,
        headers: {
          'accept': 'application/json',
          'content-type': 'application/json',
          'Authorization': user.user["token"],
          'deviceId': user.deviceId,
        },
        body: parm,);
      print(result.body);
      if (result.statusCode == 200 || result.statusCode < 210) {
        showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(
                  title: Center(
                    child: Text(
                      "Saved",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
//              content: Text("user data:   " + user.user["token"]),
                ));
        ResetFunction();
      }
      else {
        showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(
                  title: Center(
                    child: Text(
                      "save failed",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
//              content: Text("user data:   " + user.user["token"]),
                ));
      }
    }

//-------------------------------Update--------------------------------------
    else if(ButtonName=="Update"){
      print(" in Edit update");
      var Editreq = {
        "id":Edit_Id,
        "lhName": NameController.text,
        "lhAliasName": null,
        "lhGroupId": GroupUnder_id,
        "lhType": "S",
        "lhPricingLevelId": null,
        "lhMaintainBillByBill": null,
        "lhCreditPeriod": null,
        "lhMailingName": EmaiNameController.text,
        "lhMailingAddress1": Address1Controller.text,
        "lhMailingAddress2": Address2Controller.text,
        "lhMailingAddress3": Address3Controller.text,
        "lhStateId": StateId,
        "lhPincode": PincodeController.text,
        "lhPanNo": PanNoController.text,
        "lhGstno": GstController.text,
        "lhOpeningBalance": OpnBlncController.text,
        "lhOpeningType": opBlnce_DrCr==1?"Dr":"Cr",
        "lhContactPerson": ContactPersonController.text,
        "lhContactNo": ContactNoController.text,
        "lhEmail": EmailController.text,
        "lhBankName": null,
        "lhAccountNo": null,
        "lhBankBranch": null,
        "lhIfscCode": null,
        "lhAreaId": areaId,
        "lhRemarks": null,
        "lhUserId": userId,
        "lhBranchId": branchId,
        "nameLatin":nameLatinController.text,
        "buildingNo":buildingNoController.text,
        "buildingNoLatin":buildingNoLatinController.text,
        "streetName":streetNameController.text,
        "streetNameLatin":streetNameLatinController.text,
        "district":districtController.text,
        "districtLatin" :districtLatinController.text,
        "city":cityController.text,
        "cityLatin":cityLatinController.text,
        "country":countryController.text,
        "countryLatin":countryLatinController.text,
        "pinNo" : pinNoController.text,
        "pinNoLatin":pinNoLatinController.text
      };
      var EditParm=json.encode(Editreq);
      print(EditParm);

      var res=await cw.put(api:"MLedgerHeads/$Edit_Id",body:EditParm,deviceId: DeviceId,Token: token);
      if(res!=false){
        cw.UpdatePopup(context);
        ResetFunction();
      }else{cw.FailePopup(context);}
    }

//-------------------------------Delete--------------------------------------
    else if(ButtonName=="Delete"){
      var res=await cw.delete(api:"MLedgerHeads/$Edit_Id",deviceId: DeviceId,Token: token);
      if(res!=false){
        ResetFunction();
        cw.DeletePopup(context);
      }else{cw.FailePopup(context);}

    }
  }


//---------------Reset Function-----------------------

  ResetFunction(){

    setState(() {
      slnum=0;
      areaSelect=false;
      areaId=null;
      AreaName="";
      emaliingformShow=true;
      emaliingformIcon;
      StateId=null;
      StateName="";
      Namevalid=false;

      NameController.text="";
      AreaController.text="";
      EmaiNameController.text="";
      Address1Controller.text="";
      Address2Controller.text="";
      Address3Controller.text="";
      PincodeController.text="";
      StateController.text="";
      ContactPersonController.text="";
      ContactNoController.text="";
      EmailController.text="";
      PanNoController.text="";
      Edit_Id=null;
      ButtonName="Save";
      GroupUnderController.text="";
      GroupUnder_id=null;
      GstController.text="";

      nameLatinController.text="";
      buildingNoController.text="";
      buildingNoLatinController.text="";
      streetNameController.text="";
      streetNameLatinController.text="";
      districtController.text="";
      districtLatinController.text="";
      cityController.text="";
      cityLatinController.text="";
      countryController.text="";
      countryLatinController.text="";
      pinNoController.text="";
      pinNoLatinController.text="";
      OpnBlncController.text="";
      opBlnce_DrCr=0;

    });



  }




//--------------------Edit Binding-------------------------------------
  EditOrDeleteBind()async{

    print("on Bind Data");
    var res=await cw.CUget_With_Parm(api: "MLedgerHeads/$Edit_Id",Token:token);


    if(res!=false){
      print("Edit Data");

      var LB=json.decode(res)["ledgerHeads"] ;
      setState(() {
        print(LB[0]["lhName"].toString());
        NameController.text=LB[0]["lhName"];
        AreaController.text=LB[0]["areaName"];
        EmaiNameController.text=LB[0]["lhMailingName"];
        Address1Controller.text=LB[0]["lhMailingAddress1"];
        Address2Controller.text=LB[0]["lhMailingAddress2"];
        Address3Controller.text=LB[0]["lhMailingAddress3"];
        PincodeController.text=LB[0]["lhPincode"];
        StateController.text=LB[0]["lhState"];
        ContactPersonController.text=LB[0]["lhContactPerson"];
        ContactNoController.text=LB[0]["lhContactNo"];
        EmailController.text=LB[0]["lhEmail"];
        PanNoController.text=LB[0]["lhPanNo"];
        GroupUnderController.text=LB[0]["lhGroup"];
        GroupUnder_id=LB[0]["lhGroupId"];
        areaId=LB[0]["lhAreaId"];
        AreaName=LB[0]["areaName"];
        StateId=LB[0]["lhStateId"];
        StateName=LB[0]["lhState"];
        GstController.text=LB[0]["lhGstno"];
        emaliingformShow=true;
        nameLatinController.text=LB[0]["nameLatin"];
        buildingNoController.text=LB[0]["buildingNo"];
        buildingNoLatinController.text=LB[0]["buildingNoLatin"];
        streetNameController.text=LB[0]["streetName"];
        streetNameLatinController.text=LB[0]["streetNameLatin"];
        districtController.text=LB[0]["district"];
        districtLatinController.text=LB[0]["districtLatin"];
        cityController.text=LB[0]["city"];
        cityLatinController.text=LB[0]["cityLatin"];
        countryController.text=LB[0]["country"];
        countryLatinController.text=LB[0]["countryLatin"];
        pinNoController.text=LB[0]["pinNo"];
        pinNoLatinController.text=LB[0]["pinNoLatin"];
        OpnBlncController.text=LB[0]["lhOpeningBalance"].toString();


        if(LB[0]["lhOpeningType"].toString()=="null"||LB[0]["lhOpeningType"].toString()==""){
          opBlnce_DrCr=0;
        }else if(LB[0]["lhOpeningType"]=="Dr"){
          opBlnce_DrCr=1;
        }else{
          opBlnce_DrCr=2;
        }


      });


    }

  }










  ///-----------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: Appbarcustomwidget(
                uname:userName, branch:branchName , pref: pref, title: "Create Ledger"),
          ),


          body: ListView(children: [
            SizedBox(height: 2,),
            Padding(
              padding: const EdgeInsets.fromLTRB(8,8,8,8),
              child:    Container(width: MediaQuery.of(context).size.width,
                height: 50,
                child: Row(children: [

                  Expanded(
                    child: TextFormField(
                      controller: NameController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          contentPadding:EdgeInsets.fromLTRB(20,10,10,10),
                          labelText: "Name",
                          errorText:Namevalid==true?"Invalid Name":null,
                          errorStyle: TextStyle(color: Colors.red),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(TextBoxCurve))),

                    ),
                  ),

                  SizedBox(width: 3,),


                  Expanded(
                    child: TextFormField(
                      textDirection: TextDirection.rtl,
                      controller: nameLatinController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          contentPadding:EdgeInsets.fromLTRB(20,10,10,10),
                          labelText: "Name Latin",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(TextBoxCurve))),
                    ),
                  ),
                ],),),
            ),


            Padding(
              padding: const EdgeInsets.fromLTRB(8,0,8,8),
              child: Group_Under_TextBox(),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(8,0,8,8),
              child: Row(
                children: [
                  Expanded(
                    child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                            style: TextStyle(),
                            controller: AreaController,
                            textInputAction: TextInputAction.next,
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
                                    areaId = null;

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

                          AreaController.text = suggestion.maName;
                          print("close.... $areaId");
                          areaId = null;
                          AreaName = suggestion.maName;
                          print(suggestion.id);
                          print("....... Area id");
                          areaId = suggestion.id;

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

                ],
              ),
            ),


            Padding(
              padding: const EdgeInsets.fromLTRB(8,0,8,8),
              child: Row(
                children: [

                  Expanded(child: cw.CUTestbox(controllerName:OpnBlncController,
                      label: "Op.Balance")),



                  Text("   Dr"),
                  Radio(
                    value: 1,
                    groupValue: opBlnce_DrCr,
                    onChanged: (value) {
                      setState(() {
                        opBlnce_DrCr = value!;
                      });
                    },
                    activeColor: Colors.blue.shade600,
                  ),
                  Text("Cr"),
                  Radio(
                    value: 2,
                    groupValue: opBlnce_DrCr,
                    onChanged: (value) {
                      setState(() {
                        opBlnce_DrCr = value!;
                      });
                    },
                    activeColor: Colors.blue.shade600,
                  ),


                ],
              ),
            ),

            Text("     Mailing Details..." ,style: TextStyle(color: Colors.indigoAccent,
                fontSize: 20),),


            Padding(
              padding: const EdgeInsets.fromLTRB(8,8,8,0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: TextFormField(
                  controller: EmaiNameController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      contentPadding:EdgeInsets.fromLTRB(20,10,10,10),
                      labelText: "Mail Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(TextBoxCurve))),
                ),
              ),
            ), //Mail Name




            ///----------------------buildingNo----buildingNoLatin------------------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(8,4,8,0),
              child: Container(width: MediaQuery.of(context).size.width,
                height: 50,
                child: Row(children: [

                  Expanded(
                    child: TextFormField(
                      controller: buildingNoController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          contentPadding:EdgeInsets.fromLTRB(20,10,10,10),
                          labelText: "Building No",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(TextBoxCurve))),

                    ),
                  ),


                  SizedBox(width: 3,),

                  Expanded(

                    child: TextFormField(
                      textDirection: TextDirection.rtl,
                      controller: buildingNoLatinController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          contentPadding:EdgeInsets.fromLTRB(20,10,10,10),
                          labelText: "Building No Latin",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(TextBoxCurve))),
                    ),
                  ),

                ],),),
            ),



            ///----------------------streetName----streetNameLatin------------------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(8,4,8,0),
              child: Container(width: MediaQuery.of(context).size.width,
                height: 50,
                child: Row(children: [

                  Expanded(
                    child: TextFormField(
                      controller: streetNameController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          contentPadding:EdgeInsets.fromLTRB(20,10,10,10),
                          labelText: "Street Name",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(TextBoxCurve))),

                    ),
                  ),


                  SizedBox(width: 3,),

                  Expanded(

                    child: TextFormField(
                      textDirection: TextDirection.rtl,
                      controller: streetNameLatinController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          contentPadding:EdgeInsets.fromLTRB(20,10,10,10),
                          labelText: "Street Name Latin",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(TextBoxCurve))),
                    ),
                  ),

                ],),),
            ),



            ///----------------------district----districtLatin------------------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(8,4,8,0),
              child: Container(width: MediaQuery.of(context).size.width,
                height: 50,
                child: Row(children: [

                  Expanded(
                    child: TextFormField(
                      controller: districtController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          contentPadding:EdgeInsets.fromLTRB(20,10,10,10),
                          labelText: "District",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(TextBoxCurve))),

                    ),
                  ),


                  SizedBox(width: 3,),

                  Expanded(

                    child: TextFormField(
                      textDirection: TextDirection.rtl,
                      controller: districtLatinController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          contentPadding:EdgeInsets.fromLTRB(20,10,10,10),
                          labelText: "District Latin",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(TextBoxCurve))),
                    ),
                  ),

                ],),),
            ),



            ///----------------------city----cityLatin------------------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(8,4,8,0),
              child: Container(width: MediaQuery.of(context).size.width,
                height: 50,
                child: Row(children: [

                  Expanded(
                    child: TextFormField(
                      controller: cityController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          contentPadding:EdgeInsets.fromLTRB(20,10,10,10),
                          labelText: "city",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(TextBoxCurve))),

                    ),
                  ),


                  SizedBox(width: 3,),

                  Expanded(

                    child: TextFormField(
                      textDirection: TextDirection.rtl,
                      controller: cityLatinController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          contentPadding:EdgeInsets.fromLTRB(20,10,10,10),
                          labelText: "City Latin",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(TextBoxCurve))),
                    ),
                  ),

                ],),),
            ),




            ///----------------------country----countryLatin------------------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(8,4,8,0),
              child: Container(width: MediaQuery.of(context).size.width,
                height: 50,
                child: Row(children: [

                  Expanded(
                    child: TextFormField(
                      controller: countryController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          contentPadding:EdgeInsets.fromLTRB(20,10,10,10),
                          labelText: "Country",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(TextBoxCurve))),

                    ),
                  ),


                  SizedBox(width: 3,),

                  Expanded(

                    child: TextFormField(
                      textDirection: TextDirection.rtl,
                      controller: countryLatinController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          contentPadding:EdgeInsets.fromLTRB(20,10,10,10),
                          labelText: "Country Latin",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(TextBoxCurve))),
                    ),
                  ),

                ],),),
            ),




            ///----------------------pinNo----pinNoLatin------------------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(8,4,8,4),
              child: Container(width: MediaQuery.of(context).size.width,
                height: 50,
                child: Row(children: [

                  Expanded(
                    child: TextFormField(
                      controller: pinNoController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          contentPadding:EdgeInsets.fromLTRB(20,10,10,10),
                          labelText: "PinNo",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(TextBoxCurve))),

                    ),
                  ),


                  SizedBox(width: 3,),

                  Expanded(

                    child: TextFormField(
                      textDirection: TextDirection.rtl,
                      controller: pinNoLatinController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          contentPadding:EdgeInsets.fromLTRB(20,10,10,10),
                          labelText: "PinNo Latin",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(TextBoxCurve))),
                    ),
                  ),

                ],),),
            ),





            Padding(
              padding: const EdgeInsets.fromLTRB(8,4,8,4),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: TextFormField(
                  controller: Address1Controller,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      contentPadding:EdgeInsets.fromLTRB(20,10,10,10),
                      labelText: "Address 1",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(TextBoxCurve))),
                ),
              ),
            ), //Address 1


            Padding(
              padding: const EdgeInsets.fromLTRB(8,4,8,4),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: Address2Controller,
                  decoration: InputDecoration(
                      contentPadding:EdgeInsets.fromLTRB(20,10,10,10),
                      labelText: "Address 2",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(TextBoxCurve))),
                ),
              ),
            ),  //Address 2






            Container(width: MediaQuery.of(context).size.width,
              child: Row(children: [
                Expanded(
                  child:  Padding(
                    padding: const EdgeInsets.fromLTRB(8,4,0,4),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: TextFormField(
                        controller: Address3Controller,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            contentPadding:EdgeInsets.fromLTRB(20,10,10,10),
                            labelText: "Address 3",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(TextBoxCurve))),
                      ),
                    ),
                  ),
                ),   // Pincode


                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(3,4,8,4),
                    child: TextFormField(
                      controller: GstController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          contentPadding:EdgeInsets.fromLTRB(20,10,10,10),
                          labelText: "TIN/GST NO",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(TextBoxCurve))),
                    ),
                  ),
                ),   // State
              ],),),



            //Address 3

            Container(width: MediaQuery.of(context).size.width,
              child: Row(children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8,4,0,4),
                    child: TextFormField(
                      controller: PincodeController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          contentPadding:EdgeInsets.fromLTRB(20,10,10,10),
                          labelText: "Pincode",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(TextBoxCurve))),
                    ),
                  ),
                ),   // Pincode


                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(2,4,8,4),
                      child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                            controller: StateController,
                            textInputAction: TextInputAction.next,
                            decoration:  InputDecoration(
                              // errorStyle: TextStyle(color: Colors.red),
                              // errorText: stateSelect
                              //     ? "Please Select Sate ?"
                              //     : null,
                              suffixIcon: IconButton(
                                icon: Icon(Icons.remove_circle),
                                color: Colors.blue,
                                onPressed: () {
                                  setState(() {
                                    print("cleared");
                                    StateController.text = "";
                                    StateId = null;

                                  });
                                },
                              ),
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
                        suggestionsCallback:(pattern){
                          return state.where((element) =>
                              element.msName.toUpperCase().contains(pattern.toUpperCase()));


                        },
                        itemBuilder: (context,suggestion){
                          return Card(
                              color:theam.DropDownClr,
                              child: ListTile(
                                // focusColor: Colors.blue,
                                // hoverColor: Colors.red,
                                title: Text(
                                  suggestion.msName,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ));

                        },
                        onSuggestionSelected: (suggestion){
                          print(suggestion.msName);
                          print("selected");

                          StateController.text = suggestion.msName;
                          print("close.... $areaId");
                          StateId = null;
                          StateName=suggestion.msName;
                          print(suggestion.id);
                          print("....... Sate id");
                          StateId = suggestion.id;

                          print(StateId);
                          print("...........");
                        },
                      )
                  ),
                ),   // State
              ],),),


            Container(width: MediaQuery.of(context).size.width,
              child: Row(children: [
                Expanded(
                  child:    Padding(
                    padding: const EdgeInsets.fromLTRB(8,4,0,4),
                    child: TextFormField(
                      controller: ContactPersonController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          contentPadding:EdgeInsets.fromLTRB(20,10,10,10),
                          labelText: "Contact Person",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(TextBoxCurve))),
                    ),
                  ),   // Contact Person
                ),

                Expanded(
                  child:  Padding(
                    padding: const EdgeInsets.fromLTRB(3,4,8,4),
                    child: TextFormField(
                      controller: ContactNoController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          contentPadding:EdgeInsets.fromLTRB(20,10,10,10),
                          labelText: "Contact No",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(TextBoxCurve))),
                    ),
                  ),   // Contact No
                ),
              ],),),


            Container(width: MediaQuery.of(context).size.width,
              child: Row(children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8,4,0,4),
                    child: TextFormField(
                      controller: EmailController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          contentPadding:EdgeInsets.fromLTRB(20,10,10,10),
                          labelText: "Email",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(TextBoxCurve))),
                    ),
                  ),
                ),   // Pincode


                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(3,4,8,4),
                    child: TextFormField(
                      controller: PanNoController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          contentPadding:EdgeInsets.fromLTRB(20,10,10,10),
                          labelText: "Pan No",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(TextBoxCurve))),
                    ),
                  ),
                ),   // State
              ],),),



            WillPopScope(child: Text(""), onWillPop:() {
              return
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LedgerBalance_Index(),));
            }
            )

          ]),



          bottomNavigationBar:Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      Validation();

                    },
                    child: Container(
                      color:theam.saveBtn_Clr,
                      height: 50,
                      child: Center(child: Text(ButtonName,style: TextStyle(fontSize: 25,color: Colors.white),)),
                    ),
                  ),
                ),
                SizedBox(width: 8,),
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Rms_Homes2(),));
                    },
                    child: Container(
                      color:Colors.indigo,
                      height: 50,
                      child: Center(child: Text("Back",style: TextStyle(fontSize: 25,color: Colors.white),)),
                    ),
                  ),
                ),

              ],
            ),
          ) ,


        ));
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
}















class Area{
  int id;
  String maName;

  Area({required this.id,required this.maName});

  Area.formJson(Map<String, dynamic>json)
  {
    id=json["id"] ;
    maName=json["maName"] ;
  }
}


class StateMaster {
  int id;
  dynamic msStateCode;
  String msName;

  StateMaster({required this.id,required this.msName,this.msStateCode});

  StateMaster.formJson(Map<String, dynamic> json ){

    id=json["id"];
    msStateCode=json["msStateCode"];
    msName=json["msName"];
  }







}

