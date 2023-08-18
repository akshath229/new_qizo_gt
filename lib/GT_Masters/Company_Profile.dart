import 'dart:convert';

import 'dart:ui';
import 'package:dio/dio.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../Utility/ledgerBalanceCreate2.dart';
import '../appbarWidget.dart';
import '../models/userdata.dart';
import '../urlEnvironment/urlEnvironment.dart';
import 'AppTheam.dart';
import 'Masters_UI/cuWidgets.dart';

class Company_Profile extends StatefulWidget {
  var parmId;
  Company_Profile({this.parmId});
  @override
  _Company_ProfileState createState() => _Company_ProfileState();
}

class _Company_ProfileState extends State<Company_Profile> {
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
  double TextBoxCurve = 10.0;
  var BtnNme = "Save";

  bool Sow_Hide_GnrlDtls = true;
  bool Sow_Hide_Add_Dtls = false;
  bool Sow_Hide_BankDtls = false;

  CUWidgets cu = CUWidgets();
  AppTheam theam = AppTheam();

  ///     General Details------------------------------

  TextEditingController Gen_NameController = TextEditingController();
  TextEditingController Gen_NameLatinController = TextEditingController();
  TextEditingController Gen_MailingNameController = TextEditingController();
  TextEditingController Gen_StateController = TextEditingController();
  TextEditingController Gen_EmailController = TextEditingController();
  TextEditingController Gen_ContactController = TextEditingController();
  TextEditingController Gen_MobileController = TextEditingController();
  TextEditingController Gen_GST_NoController = TextEditingController();
  TextEditingController Gen_PAN_NoController = TextEditingController();
  bool Gen_NameValid = false;
  bool Gen_StateValid = false;
  bool Gen_ContactValid = false;
  bool Gen_GST_NoValid = false;
  var Gen_State_Id = null;



  var LedgId=null;
  ///     Address Details------------------------------
  TextEditingController nameLatinController = TextEditingController();
  TextEditingController buildingNoController = TextEditingController();
  TextEditingController buildingNoLatinController = TextEditingController();
  TextEditingController streetNameController = TextEditingController();
  TextEditingController streetNameLatinController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController districtLatinController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController cityLatinController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController countryLatinController = TextEditingController();
  TextEditingController pinNoController = TextEditingController();
  TextEditingController pinNoLatinController = TextEditingController();

  ///        Bank Details----------------------------------------

  TextEditingController Bnk_BankController = TextEditingController();
  TextEditingController Bnk_BranchController = TextEditingController();
  TextEditingController Bnk_AccountNoController = TextEditingController();
  TextEditingController Bnk_IFSCController = TextEditingController();
  TextEditingController Bnk_WEBController = TextEditingController();

  static List<StateMaster> state = [];

  // static List<Company_Profile_Model> CmpnyProf=new List<Company_Profile_Model>();
  // Company_Profile_Model Cmpny_Prof_data;

  void initState() {
    setState(() {
      SharedPreferences.getInstance().then((value) {
        pref = value;
        read();
        GetState();
        if(widget.parmId!=null){
          EditDataBinding(widget.parmId);
        }
      });
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

//-----------get State--------------------------
  GetState() async {
      print("in GetState");
    final json = await http.get("${Env.baseUrl}mstates" as Uri, headers: {
      "Authorization": user.user["token"],
    });

    print(json.body.toString());

    List<dynamic> Staedata = jsonDecode(json.body);

    List<StateMaster> Stmstr =
        Staedata.map((Staedata) => StateMaster.formJson(Staedata)).toList();

    state = Stmstr;

    var stsdata=jsonDecode(json.body);
      Gen_StateController.text = stsdata[0]["msName"];
  }

  Reset() {
    setState(() {
      nameLatinController.text = "";
      buildingNoController.text = "";
      buildingNoLatinController.text = "";
      streetNameController.text = "";
      streetNameLatinController.text = "";
      districtController.text = "";
      districtLatinController.text = "";
      cityController.text = "";
      cityLatinController.text = "";
      countryController.text = "";
      countryLatinController.text = "";
      pinNoController.text = "";
      pinNoLatinController.text = "";

      Gen_NameController.text = "";
      Gen_NameLatinController.text = "";
      Gen_MailingNameController.text = "";
      Gen_StateController.text = "";
      Gen_EmailController.text = "";
      Gen_ContactController.text = "";
      Gen_MobileController.text = "";
      Gen_GST_NoController.text = "";
      Gen_PAN_NoController.text = "";

      Bnk_BankController.text = "";
      Bnk_BranchController.text = "";
      Bnk_AccountNoController.text = "";
      Bnk_IFSCController.text = "";
      Bnk_WEBController.text = "";

      Gen_NameValid = false;
      Gen_StateValid = false;
      Gen_ContactValid = false;
      Gen_GST_NoValid = false;
      Gen_State_Id = null;

      Sow_Hide_GnrlDtls = true;
      Sow_Hide_Add_Dtls = false;
      Sow_Hide_BankDtls = false;
    });
  }

  ValidationCheck() {
    if (Gen_NameController.text == "") {
      setState(() {
        Gen_NameValid = true;
        Sow_Hide_GnrlDtls = true;
      });
    } else if (Gen_StateController.text == "") {
      setState(() {
        Gen_StateValid = true;
        Gen_NameValid = false;
        Sow_Hide_GnrlDtls = true;
      });
    } else {
      setState(() {
        Gen_StateValid = false;
        Gen_NameValid = false;
       // BtnNme == "Save" ? CmpnyProf_Save() : CmpnyProf_Update;
        CmpnyProf_Save();
      });
    }
  }



  var dio = Dio();
  CmpnyProf_Save() async {
    print("save");
    var req = {
      "companyProfileId":widget.parmId,
      "companyProfileName": Gen_NameController.text,
      "companyProfileShortName": null,
      "companyProfileMailingName": Gen_MailingNameController.text,
      "companyProfileAddress1": null,
      "companyProfileAddress2": null,
      "companyProfileAddress3": null,
      "companyProfileGstNo": Gen_GST_NoController.text,
      "companyProfilePan": Gen_PAN_NoController.text,
      "companyProfileMobile": Gen_MobileController.text,
      "companyProfileContact": Gen_ContactController.text,
      "companyProfileEmail": Gen_EmailController.text,
      "companyProfileWeb": Bnk_WEBController.text,
      "companyProfileBankName": Bnk_BankController.text,
      "companyProfileAccountNo": Bnk_AccountNoController.text,
      "companyProfileBranch": Bnk_BranchController.text,
      "companyProfileIfsc": Bnk_IFSCController.text,
      "companyProfileImagePath": null,
      "companyProfileIsPrintHead": null,
      "companyProfileStateId": Gen_State_Id,
      "companyProfileLedgerId": LedgId??1,
      "companyProfilePin": pinNoController.text,
      "companyProfileNameLatin": Gen_NameLatinController.text,
      "buildingNo": buildingNoController.text,
      "buildingNoLatin": buildingNoLatinController.text,
      "streetName": streetNameController.text,
      "streetNameLatin": streetNameLatinController.text,
      "district": districtController.text,
      "districtLatin": districtLatinController.text,
      "city": cityController.text,
      "cityLatin": cityLatinController.text,
      "country": countryController.text,
      "countryLatin": countryLatinController.text,
      "pinNo": pinNoController.text,
      "pinNoLatin": pinNoLatinController.text,
      "companyProfileLedger": null,
     // "companyProfileState": Gen_StateController.text,
    };

    var finalData = json.encode(req);
    print(finalData);



    var formData = FormData.fromMap({
      'file1':null,
      'jsonString': finalData,
    });

    print("FormData");

    print(formData.fields);

    var res = await dio.put("${Env.baseUrl}MCompanyProfiles/${widget.parmId}",
      data: formData,
      options: Options(
        headers: {
          'content-type': 'multipart/form-data',
          'Authorization': token,
          'deviceId': DeviceId,
        },
        // followRedirects: false,

      ),
    );
    // print(res.hashCode.toString());
    print(res.statusMessage);
    print(res.data);
    print(res.statusCode);
if(res.statusMessage!.contains("OK")){

  cu.SavePopup(context);
Reset();
}



  //
  // // var res =await cu.post(api: "MCompanyProfiles", body: finalData,);
  //   var res =await http.put("${Env.baseUrl}MCompanyProfiles",body:finalData,
  //       headers: {
  //       'accept': 'application/json',
  //       'content-type': 'application/json',});
  //
  //
  //   print("res.body");
  //   print(res.body);
  //
  //   if(res.body.toString().contains("msg")){
  //     var resultmsg=json.decode(res.body);
  //     cu.MessagePopup(context, resultmsg['msg'], Colors.indigo.shade400);
  //   } else
  //   if (res.statusCode<210||res.statusCode==500 ) {
  //     print(res);
  //     cu.SavePopup(context);
  //     Reset();
  //   }
  //   else{
  //
  //     cu.FailePopup(context);
  //   }






  }





  EditDataBinding(id)async{
print("EditDataBinding/$id");
   var res=await cu.CUget_With_Parm(api:"MCompanyProfiles/$id",Token: token);

if(res !=false){

  print(res);
  setState(() {
  var resdata=json.decode(res);
print(resdata);
print(resdata["companyProfileName"]);

  nameLatinController.text= resdata["companyProfileNameLatin"];
  buildingNoController.text= resdata["buildingNo"];
  buildingNoLatinController.text= resdata["buildingNoLatin"];
  streetNameController.text= resdata["streetName"];
  streetNameLatinController.text= resdata["streetNameLatin"];
  districtController.text= resdata["district"];
  districtLatinController.text =resdata["districtLatin"];
  cityController.text= resdata["city"];
  cityLatinController.text= resdata["cityLatin"];
  countryController.text= resdata["country"];
  countryLatinController.text= resdata["countryLatin"];
  pinNoController.text= resdata["pinNo"];
  pinNoLatinController.text= resdata["pinNoLatin"];

  Gen_NameController.text =resdata["companyProfileName"];
  Gen_NameLatinController.text= resdata["companyProfileNameLatin"];
  Gen_MailingNameController.text= resdata["companyProfileMailingName"];
  Gen_StateController.text =resdata["companyProfileState"];
  Gen_EmailController.text= resdata["companyProfileEmail"];
  Gen_ContactController.text= resdata["companyProfileContact"];
  Gen_MobileController.text= resdata["companyProfileMobile"];
  Gen_GST_NoController.text= resdata["companyProfileGstNo"];
  Gen_PAN_NoController.text= resdata["companyProfilePan"];

  Bnk_BankController.text= resdata["companyProfileBankName"];
  Bnk_BranchController.text= resdata["companyProfileBranch"];
  Bnk_AccountNoController.text =resdata["companyProfileAccountNo"];
  Bnk_IFSCController.text =resdata["companyProfileIfsc"];
  Bnk_WEBController.text= resdata["companyProfileBankName"];
Gen_State_Id=resdata["companyProfileStateId"];


  LedgId=resdata["companyProfileLedgerId"];

});
}
  }





  AddImage(){




  }







  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Appbarcustomwidget(
            uname: userName,
            branch: branchName,
            pref: pref,
            title: "Company Profile"),
      ),
      body: ListView(children: [

        Padding(
          padding: const EdgeInsets.only(left: 8,right: 8,top: 8),
          child: Row(
            children: [

              InkWell(
                child: Text(
                  "General Details",
                  style: TextStyle(
                      fontSize: 22,
                      color:
                          Sow_Hide_GnrlDtls == true ? Colors.teal : Colors.black),
                ),
                onTap: () {
                  setState(() {
                    Sow_Hide_GnrlDtls = !Sow_Hide_GnrlDtls;
                  });
                },
              ),

SizedBox(width: 5,),
              IconButton(icon: Icon(Icons.account_circle,size: 35,), onPressed:(){
                    AddImage();
              })
            ],
          ),
        ),
        Visibility(visible: Sow_Hide_GnrlDtls, child: General_Details_Widget()),


        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            child: Text(
              "Address Details",
              style: TextStyle(
                  fontSize: 22,
                  color:
                      Sow_Hide_Add_Dtls == true ? Colors.teal : Colors.black),
            ),
            onTap: () {
              setState(() {
                Sow_Hide_Add_Dtls = !Sow_Hide_Add_Dtls;
                if (Sow_Hide_BankDtls == false && Sow_Hide_Add_Dtls == false) {
                  Sow_Hide_GnrlDtls = true;
                }
              });
            },
          ),
        ),
        Visibility(visible: Sow_Hide_Add_Dtls, child: Address_Details_Widget()),


        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            child: Text(
              "Bank Details",
              style: TextStyle(
                fontSize: 22,
                color: Sow_Hide_BankDtls == true ? Colors.teal : Colors.black,
              ),
            ),
            onTap: () {
              setState(() {
                Sow_Hide_BankDtls = !Sow_Hide_BankDtls;
                if (Sow_Hide_BankDtls == false && Sow_Hide_Add_Dtls == false) {
                  Sow_Hide_GnrlDtls = true;
                }
              });
            },
          ),
        ),
        Visibility(visible: Sow_Hide_BankDtls, child: Bank_Details_Widget()),
      ]),





         bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: Row(
          children: [
            Expanded(
                child: cu.CUButton(
                    function: () {
                      ValidationCheck();
                    },
                    H: 50,
                    name: "Save",
                    Labelstyl: TextStyle(fontSize: 25),
                    color: theam.saveBtn_Clr)),
            SizedBox(
              width: 3,
            ),
            Expanded(
                child: cu.CUButton(
                    function: () {
                      Reset();
                    },
                    H: 50,
                    name: "Clear",
                    Labelstyl: TextStyle(fontSize: 25),
                    color: Colors.indigo))
          ],
        ),
      ),
    ));
  }















  Widget General_Details_Widget() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: Row(
              children: [
                Expanded(
                    child: cu.CUTestbox(
                        controllerName: Gen_NameController,
                        label: "Name",
                        errorcontroller: Gen_NameValid)),
                SizedBox(
                  width: 3,
                ),
                Expanded(
                  child: TextFormField(
                    textDirection: TextDirection.rtl,
                    controller: Gen_NameLatinController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                        labelText: "Name Latin",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(TextBoxCurve))),
                  ),

                ),
              ],
            ),
          ), // Name

          SizedBox(
            height: 3,
          ),

          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: Row(
              children: [
                Expanded(
                    child: cu.CUTestbox(
                        controllerName: Gen_MailingNameController,
                        label: "Mailing Name")),
                SizedBox(
                  width: 3,
                ),
                Expanded(
                    child: cu.CUTestbox(
                        controllerName: Gen_GST_NoController,
                        label: "GST No",
                        errorcontroller: Gen_GST_NoValid)),
              ],
            ),
          ), //Gst

          SizedBox(
            height: 3,
          ),

          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                        controller: Gen_StateController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(color: Colors.red),
                          errorText:
                              Gen_StateValid ? "Please Select Sate ?" : null,
                          suffixIcon: IconButton(
                            icon: Icon(Icons.remove_circle),
                            color: Colors.blue,
                            onPressed: () {
                              setState(() {
                                print("cleared");
                                Gen_StateController.text = "";
                                Gen_State_Id = null;
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
                    suggestionsCallback: (pattern) {
                      return state.where((element) => element.msName
                          .toUpperCase()
                          .contains(pattern.toUpperCase()));
                    },
                    itemBuilder: (context, suggestion) {
                      return Card(
                          color: theam.DropDownClr,
                          child: ListTile(
                            // focusColor: Colors.blue,
                            // hoverColor: Colors.red,
                            title: Text(
                              suggestion.msName,
                              style: TextStyle(color: Colors.white),
                            ),
                          ));
                    },
                    onSuggestionSelected: (suggestion) {
                      print(suggestion.msName);

                      print("....... Sate id");
                      Gen_State_Id = suggestion.id;
                      Gen_StateController.text = suggestion.msName;
                      print(Gen_State_Id);
                      print("...........");
                    },
                  ),
                ),
                SizedBox(
                  width: 3,
                ),
                Expanded(
                    child: cu.CUTestbox(
                  controllerName: Gen_PAN_NoController,
                  label: "PAN No",
                )),
              ],
            ),
          ), //State  Pan

          SizedBox(
            height: 3,
          ),

          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: Row(
              children: [
                Expanded(
                    child: cu.CUTestbox(
                        controllerName: Gen_ContactController,
                        label: "Contact No",
                        errorcontroller: Gen_ContactValid)),
                SizedBox(
                  width: 3,
                ),
                Expanded(
                    child: cu.CUTestbox(
                  controllerName: Gen_MobileController,
                  label: "Mobile",
                )),
              ],
            ),
          ), // Contact

          SizedBox(
            height: 3,
          ),

          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: cu.CUTestbox(
                      controllerName: Gen_EmailController, label: "Email"),
                )
              ],
            ),
          ), // Email
        ],
      ),
    );
  }






  Column Address_Details_Widget() {
    return Column(
      children: [
        ///----------------------buildingNo----buildingNoLatin------------------------------
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: buildingNoController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                        labelText: "Building No",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(TextBoxCurve))),
                  ),
                ),
                SizedBox(
                  width: 3,
                ),
                Expanded(
                  child: TextFormField(
                    textDirection: TextDirection.rtl,
                    controller: buildingNoLatinController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                        labelText: "Building No Latin",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(TextBoxCurve))),
                  ),
                ),
              ],
            ),
          ),
        ),

        ///----------------------streetName----streetNameLatin------------------------------
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: streetNameController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                        labelText: "Street Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(TextBoxCurve))),
                  ),
                ),
                SizedBox(
                  width: 3,
                ),
                Expanded(
                  child: TextFormField(
                    textDirection: TextDirection.rtl,
                    controller: streetNameLatinController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                        labelText: "Street Name Latin",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(TextBoxCurve))),
                  ),
                ),
              ],
            ),
          ),
        ),

        ///----------------------district----districtLatin------------------------------
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: districtController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                        labelText: "District",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(TextBoxCurve))),
                  ),
                ),
                SizedBox(
                  width: 3,
                ),
                Expanded(
                  child: TextFormField(
                    textDirection: TextDirection.rtl,
                    controller: districtLatinController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                        labelText: "District Latin",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(TextBoxCurve))),
                  ),
                ),
              ],
            ),
          ),
        ),

        ///----------------------city----cityLatin------------------------------
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: cityController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                        labelText: "city",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(TextBoxCurve))),
                  ),
                ),
                SizedBox(
                  width: 3,
                ),
                Expanded(
                  child: TextFormField(
                    textDirection: TextDirection.rtl,
                    controller: cityLatinController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                        labelText: "City Latin",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(TextBoxCurve))),
                  ),
                ),
              ],
            ),
          ),
        ),

        ///----------------------country----countryLatin------------------------------
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: countryController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                        labelText: "Country",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(TextBoxCurve))),
                  ),
                ),
                SizedBox(
                  width: 3,
                ),
                Expanded(
                  child: TextFormField(
                    textDirection: TextDirection.rtl,
                    controller: countryLatinController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                        labelText: "Country Latin",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(TextBoxCurve))),
                  ),
                ),
              ],
            ),
          ),
        ),

        ///----------------------pinNo----pinNoLatin------------------------------
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: pinNoController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                        labelText: "PinNo",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(TextBoxCurve))),
                  ),
                ),
                SizedBox(
                  width: 3,
                ),
                Expanded(
                  child: TextFormField(
                    textDirection: TextDirection.rtl,
                    controller: pinNoLatinController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                        labelText: "PinNo Latin",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(TextBoxCurve))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }





  Widget Bank_Details_Widget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          cu.CUTestbox(controllerName: Bnk_BankController, label: "Bank"),
          SizedBox(
            height: 3,
          ),
          cu.CUTestbox(controllerName: Bnk_BranchController, label: "Branch"),
          SizedBox(
            height: 3,
          ),
          cu.CUTestbox(
              controllerName: Bnk_AccountNoController, label: "Account No"),
          SizedBox(
            height: 3,
          ),
          Row(
            children: [
              Expanded(
                  child: cu.CUTestbox(
                      controllerName: Bnk_IFSCController, label: "IFSC")),
              SizedBox(
                width: 3,
              ),
              Expanded(
                  child: cu.CUTestbox(
                      controllerName: Bnk_WEBController, label: "WEB")),
            ],
          )
        ],
      ),
    );
  }
}

