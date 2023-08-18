import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../appbarWidget.dart';
import '../models/userdata.dart';
import 'AppTheam.dart';
import 'Masters_UI/cuWidgets.dart';
import 'Models/Tax_master.dart';


class Tax_Master extends StatefulWidget {
  @override
  _Tax_MasterState createState() => _Tax_MasterState();
}

class _Tax_MasterState extends State<Tax_Master> {
  double TextBoxCurve=10.0;
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

  void initState() {
    setState(() {
      SharedPreferences.getInstance().then((value) {
        pref = value;
        read();
        GetTax();
        GetTaxType();
        GetAddTax();
      });
    });
  }

  CUWidgets cw = CUWidgets();
  AppTheam theam =AppTheam();
  static List<Tax> taxlist = [];



  TextEditingController Tax_Type_Controller = TextEditingController();
  TextEditingController Description_Controller = TextEditingController();
  TextEditingController Tax_Percentage_Controller = TextEditingController();
  TextEditingController Additionl_Tax_Controller = TextEditingController();
  TextEditingController Account_Head_Controller = TextEditingController();
  TextEditingController Purchase_Account_Controller = TextEditingController();
  TextEditingController Purchase_Return_Controller = TextEditingController();
  TextEditingController Sales_Account_Controller = TextEditingController();
  TextEditingController Sales_Return_Controller = TextEditingController();


  TextEditingController Des_CGST_Controller = TextEditingController();
  TextEditingController Des_SGST_Controller = TextEditingController();
  TextEditingController Des_IGST_Controller = TextEditingController();

  TextEditingController TxPer_CGST_Controller = TextEditingController();
  TextEditingController TxPer_SGST_Controller = TextEditingController();
  TextEditingController TxPer_IGST_Controller = TextEditingController();


  TextEditingController AccHd_CGST_Controller = TextEditingController();
  TextEditingController AccHd_SGST_Controller = TextEditingController();
  TextEditingController AccHd_IGST_Controller = TextEditingController();



  TextEditingController PrAcc_CGST_Controller = TextEditingController();
  TextEditingController PrAcc_SGST_Controller = TextEditingController();
  TextEditingController PrAcc_IGST_Controller = TextEditingController();




  TextEditingController PrRtn_CGST_Controller = TextEditingController();
  TextEditingController PrRtn_SGST_Controller = TextEditingController();
  TextEditingController PrRtn_IGST_Controller = TextEditingController();



  TextEditingController SlsAcc_CGST_Controller = TextEditingController();
  TextEditingController SlsAcc_SGST_Controller = TextEditingController();
  TextEditingController SlsAcc_IGST_Controller = TextEditingController();



  TextEditingController SlsRtn_CGST_Controller = TextEditingController();
  TextEditingController SlsRtn_SGST_Controller = TextEditingController();
  TextEditingController SlsRtn_IGST_Controller = TextEditingController();

  bool Tax_Type_Select = false;
  bool Description_Select = false;
  bool Tax_Percentage_Select = false;

  int Tax_Type_Id = 0;
  int Additionl_Tax_Id = 0;

  String Save_UpdateButton="Save";

  var Taxtype=[];
  var AddTax=[];
  var Edit_Id=0;
bool showGstprt=false;



  //-------get tax--------------------------

  GetTax()async {
    var res = await cw.CUget_With_Parm(Token: token, api: "MTaxes");

    if (res != false) {
      // print(res);
setState(() {
  var result = jsonDecode(res);
  List<dynamic> t = result["taxList"];
  List<Tax> p = t.map((t) => Tax.formJson(t)).toList();
  taxlist = p;
});

    } else {
      print("Error on GetItemGrp");
    }
  }


//--------------------get Int from Set of Characters-----------------

  SortInt(Sortdata){
    if(Sortdata.toString()=="" ||Sortdata.toString()=="null"){
      Sortdata="0";
    }
    var charect= Sortdata.replaceAll(RegExp("[a-zA-Z]"),'');
    var numbers=charect.replaceAll(RegExp(r'[^\w\s\\d.]+'),'');
    return numbers.trim();
  }


  //-------get tax type----------------------

  GetTaxType()async {
    var res = await cw.CUget_With_Parm(Token: token, api: "MTaxTypes");

    if (res != false) {
     // print(res);
      setState(() {
        var result = jsonDecode(res);
        Taxtype = result as List;
      });

    } else {
      print("Error on GetTaxType");
    }
  }


  //-------get tax type----------------------

  GetAddTax()async {
    var res = await cw.CUget_With_Parm(Token: token, api: "MIadditionalTaxes");

    if (res != false) {
      print(res);
      setState(() {
        var result = jsonDecode(res);
        AddTax = result as List;
      });

    } else {
      print("Error on GetAddTax");
    }
  }

Clear(){
setState(() {
  Edit_Id=0;
  Save_UpdateButton="Save";
  showGstprt=false;
  GetTax();
    Tax_Type_Controller.text = "";
    Description_Controller.text = "";
    Tax_Percentage_Controller.text = "";
    Additionl_Tax_Controller.text = "";
    Account_Head_Controller.text = "";
    Purchase_Account_Controller.text = "";
    Purchase_Return_Controller.text = "";
    Sales_Account_Controller.text = "";
    Sales_Return_Controller.text = "";

    Des_CGST_Controller.text = "";
    Des_SGST_Controller.text = "";
    Des_IGST_Controller.text = "";

    TxPer_CGST_Controller.text = "";
    TxPer_SGST_Controller.text = "";
    TxPer_IGST_Controller.text = "";

    AccHd_CGST_Controller.text = "";
    AccHd_SGST_Controller.text = "";
    AccHd_IGST_Controller.text = "";

    PrAcc_CGST_Controller.text = "";
    PrAcc_SGST_Controller.text = "";
    PrAcc_IGST_Controller.text = "";

    PrRtn_CGST_Controller.text = "";
    PrRtn_SGST_Controller.text = "";
    PrRtn_IGST_Controller.text = "";

    SlsAcc_CGST_Controller.text = "";
    SlsAcc_SGST_Controller.text = "";
    SlsAcc_IGST_Controller.text = "";

    SlsRtn_CGST_Controller.text = "";
    SlsRtn_SGST_Controller.text = "";
    SlsRtn_IGST_Controller.text = "";

    Tax_Type_Select = false;
   Description_Select = false;
   Tax_Percentage_Select = false;

   Tax_Type_Id = 0;
   Additionl_Tax_Id = 0;


});
}


//---------------------set tax accourding to description---if type GST----------------------------------
  SetAllTaxDesc(a){
    if(a==""){
      a="0";
    }
var tx=double.parse(a);
 double taxper=tx/2;

   setState(() {

     Account_Head_Controller.text= "GST $a%";
     Purchase_Account_Controller.text= "GST $a%";
     Purchase_Return_Controller.text= "GST $a%";
     Sales_Account_Controller.text= "GST $a%";
     Sales_Return_Controller.text= "GST $a%";

     Des_CGST_Controller.text="CGST ${taxper.toString()}%";
     Des_SGST_Controller.text= "SGST ${taxper.toString()}%";
     Des_IGST_Controller.text= "IGST $a%";


     AccHd_CGST_Controller.text="CGST ${taxper.toString()}%";
     AccHd_SGST_Controller.text= "SGST ${taxper.toString()}%";
     AccHd_IGST_Controller.text= "IGST $a%";


     PrAcc_CGST_Controller.text= "CGST ${taxper.toString()}%";
     PrAcc_SGST_Controller.text= "SGST ${taxper.toString()}%";
     PrAcc_IGST_Controller.text= "IGST $a%";


     PrRtn_CGST_Controller.text= "CGST ${taxper.toString()}%";
     PrRtn_SGST_Controller.text= "SGST ${taxper.toString()}%";
     PrRtn_IGST_Controller.text= "IGST $a%";


     SlsAcc_CGST_Controller.text= "CGST ${taxper.toString()}%";
     SlsAcc_SGST_Controller.text= "SGST ${taxper.toString()}%";
     SlsAcc_IGST_Controller.text= "IGST $a%";


     SlsRtn_CGST_Controller.text= "CGST ${taxper.toString()}%";
     SlsRtn_SGST_Controller.text= "SGST ${taxper.toString()}%";
     SlsRtn_IGST_Controller.text= "IGST $a%";

   });
  } //if Type GST  Set all Cgst And Igst




//---------------------set tax accourding to Tax per-----if type GST---------------------------------

  SetTaxPer(tax){

  //  print(tax);
    if(tax==""){
      tax="0";
    }
    var tx=double.parse(tax);
    double taxper=tx/2;

     TxPer_CGST_Controller.text ="${taxper.toString()}";
     TxPer_SGST_Controller.text ="${taxper.toString()}";
     TxPer_IGST_Controller.text =tax.toString();

  }  //if Type GST  Set Tax per






//---------------------set tax accourding Type Vat-------------------------------------

  SetType_Vat_Gst(txDes){

    var all_Description=SortInt(txDes).toString();
    print(all_Description.toString());
setState(() {
  Account_Head_Controller.text= "GST $all_Description%";
  Purchase_Account_Controller.text= "GST $all_Description%";
  Purchase_Return_Controller.text= "GST $all_Description%";
  Sales_Account_Controller.text= "GST $all_Description%";
  Sales_Return_Controller.text= "GST $all_Description%";
});


  }




//---------------------Check Validation------------------------------------
  CheckValidation() {
    if (Description_Controller.text == "")
    {

      setState(() {
         Description_Select = true;
      });

    }
    else if(Tax_Type_Controller.text==""|| Tax_Type_Id==0) {
      setState(() {
        Tax_Type_Select = true;
        Description_Select=false;
      });
    }

    else if (Tax_Percentage_Controller.text=="") {
      setState(() {
        Tax_Percentage_Select = true;
        Tax_Type_Select = false;
        Description_Select=false;
      });
    }
    else{
setState(() {
  Tax_Percentage_Select = false;
  Tax_Type_Select = false;
  Description_Select=false;
});
      Save();
    }



  }



  //------------------------save--------------------------
  Save ()async {
    print("save Or Edit");

    var Savetax;
    if (Tax_Type_Controller.text.toLowerCase() == "gst") {
      Savetax = {
        "txId":Edit_Id,
        "txDescription": Description_Controller.text,
        "txTaxTypeId": Tax_Type_Id,
        "txPercentage": Tax_Percentage_Controller.text,
        "txAddTaxId": Additionl_Tax_Id==0?null:Additionl_Tax_Id,
        "txCgstCaption": Des_CGST_Controller.text,
        "txSgstCaption": Des_SGST_Controller.text,
        "txIgstcaption": Des_IGST_Controller.text,
        "txCgstPercentage":double.parse(TxPer_CGST_Controller.text),
        "txSgstPercentage":double.parse(TxPer_SGST_Controller.text),
        "txIgstpercentage":double.parse(TxPer_IGST_Controller.text),
      };
    } else {
      Savetax = {
        "txId":Edit_Id,
        "txDescription": Description_Controller.text,
        "txTaxTypeId": Tax_Type_Id,
        "txPercentage": Tax_Percentage_Controller.text,
        "txAddTaxId":  Additionl_Tax_Id==0?null:Additionl_Tax_Id,
      };
    }

    var params = json.encode(Savetax);
    print(params);


    if(Edit_Id.toString()=="0"||Save_UpdateButton=="Save")
    {
 print("Save");


 var  res= await cw.post(api: "MTaxes",deviceId: DeviceId,Token:token,body:params);
 if(res!=false && res.toString().contains("errorMessage")) {
   var resmsg=jsonDecode(res);
   cw.MessagePopup(context,resmsg["errorMessage"],Colors.red);
   return;

 }
 else
 if(res!=false){
   Clear();
   GetTax();
   print(res.toString());
   cw.SavePopup(context);
   FocusScope.of(context).unfocus();
 }else{cw.FailePopup(context);}

    }




    else
      {

      print("Edit");


      var res = await cw.put(
          api: "MTaxes/$Edit_Id", deviceId: DeviceId, Token: token, body: params);

      if (res != false && res.toString().contains("errorMessage")) {
        var resmsg = jsonDecode(res);
        cw.MessagePopup(context, resmsg["errorMessage"],Colors.red);
        return;
      }
      else if (res != false) {
        Clear();
        GetTax();
        print(res.toString());
        cw.UpdatePopup(context);
        FocusScope.of(context).unfocus();
      } else {
        cw.FailePopup(context);
      }
    }

  }






  //Delete--------------------
  Delete(id){

    print("delete $id");
    var res=cw.delete(api: "MTaxes/$id", Token:token, deviceId:DeviceId,);

    if(res!=false){
      cw.DeletePopup(context);

      Timer(Duration(milliseconds: 500),(){

        setState(() {
          GetTax();
        });

      });




    }else
    {
      cw.FailePopup(context);
    }

  }


  //----Edit Binding--------------------
  EditBinding(EditData){
    Save_UpdateButton="Update";

    Tax_Type_Id=EditData.txTaxTypeId;
    Description_Controller.text =EditData.txDescription.toString();
    Tax_Percentage_Controller.text=EditData.txPercentage.toString();
print(EditData.toString());
if(EditData.txTaxTypeId.toString()=="1")
{
print("type = vat");
Tax_Type_Controller.text="VAT";
SetType_Vat_Gst(EditData.txDescription);
}

else{
  Tax_Type_Controller.text="GST";
  print(EditData.txPercentage.toString());
var DescTax=  SortInt(EditData.txDescription.toString());
var PerTax=  SortInt(EditData.txPercentage.toString());
print(PerTax);
setState(() {
  SetAllTaxDesc(DescTax);
  SetTaxPer(PerTax);
  showGstprt=true;
});

}

  }

  ///-------------------------------------------
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      child: Scaffold(
          appBar: PreferredSize(
              child: Appbarcustomwidget(
                  uname: userName,
                  branch: branchName,
                  pref: pref,
                  title: "Tax Master"),
              preferredSize: Size.fromHeight(80)),
          body: Container(
            child: ListView(
              shrinkWrap: true,
              children: [



                ///------------------------tax type ----------Add tax---------------------
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TypeAheadField(
                            textFieldConfiguration: TextFieldConfiguration(
                                onChanged: (a) {},
                                style: TextStyle(),
                                controller: Tax_Type_Controller,
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(color: Colors.red),
                                  errorText: Tax_Type_Select==true
                                      ? "Invalid Type ?"
                                      : null,
//                            errorText: _validateName ? "please enter name" : null,
//                            errorBorder:InputBorder.none ,
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.remove_circle),
                                    color: Colors.blue,
                                    onPressed: () {
                                      setState(() {
                                        print("cleared");
                                        Tax_Type_Controller.text = "";
                                      });
                                    },
                                  ),

                                  isDense: true,
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 10.0, 20.0, 10.0),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(TextBoxCurve)),
                                  labelText: 'Tax Type',
                                )),
                            suggestionsBoxDecoration:
                            SuggestionsBoxDecoration(elevation: 90.0),
                            suggestionsCallback: (pattern) {
                              return Taxtype.where((user) => user["txTypDescription"]
                                  .trim()
                                  .toUpperCase()
                                  .contains(pattern.trim().toUpperCase()));
                            },
                            itemBuilder: (context, suggestion) {
                              return Card(
                                margin:
                                EdgeInsets.only(top: 2, right: 2, left: 2),
                                color:theam.DropDownClr,
                                child: ListTile(
                                  // focusColor: Colors.blue,
                                  // hoverColor: Colors.red,
                                  title: Text(
                                    suggestion["txTypDescription"],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            },
                            onSuggestionSelected: (suggestion) {
                              print(suggestion["txTypDescription"]);
                              print("selected");

                              print(json.encode(suggestion).toString());
                              setState(() {
                                Tax_Type_Controller.text =
                                    (suggestion["txTypDescription"]).toString();
                                Tax_Type_Id = suggestion["txTypId"];

                                if(Tax_Type_Controller.text.toString().toLowerCase() =="gst"){
                                  setState(() {
                                    showGstprt=true;
                                  });
                                }
                                else{
                                  setState(() {
                                    showGstprt=false;
                                  });
                                }

                              });

                              print("...........");
                            },
                            errorBuilder:
                                (BuildContext context, Object? error) => Text(
                                '$error',
                                style: TextStyle(
                                    color: Theme.of(context).errorColor)),
                            transitionBuilder: (context, suggestionsBox,
                                animationController) =>
                                FadeTransition(
                                  child: suggestionsBox,
                                  opacity: CurvedAnimation(
                                      parent: animationController!,
                                      curve: Curves.elasticIn),
                                )),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                        child: TypeAheadField(
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: Additionl_Tax_Controller,
                              style: TextStyle(),
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.remove_circle),
                                  color: Colors.blue,
                                  onPressed: () {
                                    setState(() {
                                      print("cleared");
                                      Additionl_Tax_Controller.text = "";
                                      //  salesPaymentId = 0;
                                    });
                                  },
                                ),
                                isDense: true,
                                contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 16.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(TextBoxCurve)),
                                hintStyle: TextStyle(
                                    color: Colors.black, fontSize: 15),
                                labelText: "Additionl Tax ",
                              ),
                            ),
                            suggestionsBoxDecoration:
                            SuggestionsBoxDecoration(elevation: 90.0),
                            suggestionsCallback: (pattern) {
//                        print(payment);
                              return AddTax.where(
                                      (unt) => unt["atDescription"].trim().toLowerCase().contains(pattern.trim().toLowerCase()));
                            },
                            itemBuilder: (context, suggestion) {
                              return Card(
                                margin: EdgeInsets.all(2),
                                color: Colors.white,
                                child: ListTile(
                                  tileColor:theam.DropDownClr,
                                  title: Text(
                                    suggestion["atDescription"],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            },
                            onSuggestionSelected: (suggestion) {
                              print(suggestion["atDescription"]);
                              print("Additionl Tax selected");

                              Additionl_Tax_Controller.text =
                              suggestion["atDescription"];
                              print("close.... $Additionl_Tax_Id");
                              Additionl_Tax_Id = 0;

                              print(suggestion["atId"]);
                              print(".......Additionl Tax  id");
                              Additionl_Tax_Id = suggestion["atId"];
                              print(Additionl_Tax_Id);
                              print("...........");
                            },
                            errorBuilder:
                                (BuildContext context, Object? error) => Text(
                                '$error',
                                style: TextStyle(
                                    color: Theme.of(context).errorColor)),
                            transitionBuilder: (context, suggestionsBox,
                                animationController) =>
                                FadeTransition(
                                  child: suggestionsBox,
                                  opacity: CurvedAnimation(
                                      parent: animationController!,
                                      curve: Curves.elasticIn),
                                )),
                      ),
                    ),
                  ],
                ),



                ///-----------------Description-------------
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 2),
                  child: TextFormField(
                    onChanged: (a){

                      if(Tax_Type_Controller.text.toString().toLowerCase() =="gst"){
                        setState(() {
                          showGstprt=true;
                          var charect= a.replaceAll(RegExp("[a-zA-Z]"),'');
                          var numbers=charect.replaceAll(RegExp(r'[^\w\s]+'),'');
                          SetAllTaxDesc(numbers.trim());
                        });
                      }
                      else{
                        SetType_Vat_Gst(a);
                      }
                    },
                    style: TextStyle(fontSize: 15),
                    //showCursor: true,
                    controller: Description_Controller,
                    cursorColor: Colors.black,
                    textInputAction: TextInputAction.next,
                    scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                    keyboardType: TextInputType.text,
                    onTap: () async {},
                    decoration: InputDecoration(
                      errorStyle: TextStyle(color: Colors.red),
                      errorText: Description_Select == true ? "invalid " : null,
                      isDense: true,
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(TextBoxCurve)),
                      hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                      labelText: "Description",
                    ),
                  ),
                ),


                // FocusScope.of(context).unfocus(); //for remove keyboard




                Visibility(visible: showGstprt==true,

                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(children:[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                            child: Container(
                                child: cw.CUTestbox(
                                    label: "CGST",
                                    controllerName: Des_CGST_Controller ),
                          ),
                        )),


                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                            child: Container(
                                child: cw.CUTestbox(
                                    label: "SGST",
                                    controllerName: Des_SGST_Controller)),
                          ),
                        ),


                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                            child: Container(
                                child: cw.CUTestbox(
                                    label: "IGST",
                                    controllerName:Des_IGST_Controller,)),
                          ),
                        ),

                        ],
                      ),
                    )),

                ///----Tax per-----------------------------
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 2),
                  child: TextFormField(
                    onChanged: (a){
                      if (Tax_Type_Controller.text.toString().toLowerCase() ==
                          "gst") {
                        setState(() {
                          showGstprt = true;
                          var charect = a.replaceAll(RegExp("[a-zA-Z]"), '');
                          var numbers =
                              charect.replaceAll(RegExp(r'[^\w\s]+'), '');
                          SetTaxPer(numbers.trim());
                        });
                      }
                    },
                    style: TextStyle(fontSize: 15),
                    //showCursor: true,
                    controller: Tax_Percentage_Controller,
                    cursorColor: Colors.black,
                    textInputAction: TextInputAction.next,
                    scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                    keyboardType: TextInputType.text,
                    onTap: () async {},
                    decoration: InputDecoration(
                      errorStyle: TextStyle(color: Colors.red),
                      errorText: Tax_Percentage_Select == true ? "invalid " : null,
                      isDense: true,
                      contentPadding:
                      EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(TextBoxCurve)),
                      hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                      labelText: "Tax Percentage",
                    ),
                  ),
                ),


                Visibility(visible: showGstprt==true,

                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(children:[
                        Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                              child: Container(
                                child: cw.CUTestbox(
                                    label: "CGST",
                                    controllerName:TxPer_CGST_Controller ),
                              ),
                            )),


                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                            child: Container(
                                child: cw.CUTestbox(
                                    label: "SGST",
                                    controllerName: TxPer_SGST_Controller)),
                          ),
                        ),


                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                            child: Container(
                                child: cw.CUTestbox(
                                  label: "IGST",
                                  controllerName:TxPer_IGST_Controller,)),
                          ),
                        ),
                      ],
                      ),
                    )),


                ///-------------------purchase------------------------------------
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 4, 8, 2),
                        child: Container(
                            child: cw.CUTestbox(
                              label: "Purchase Account",
                              controllerName: Purchase_Account_Controller, )),
                      ),
                    ),

                  ],
                ),

                Visibility(visible: showGstprt==true,

                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(children:[
                        Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                              child: Container(
                                child: cw.CUTestbox(
                                    label: "CGST",
                                    controllerName:PrAcc_CGST_Controller ),
                              ),
                            )),


                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                            child: Container(
                                child: cw.CUTestbox(
                                    label: "SGST",
                                    controllerName: PrAcc_SGST_Controller)),
                          ),
                        ),


                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                            child: Container(
                                child: cw.CUTestbox(
                                  label: "IGST",
                                  controllerName:PrAcc_IGST_Controller,)),
                          ),
                        ),
                      ],
                      ),
                    )),



///------------------------------Purchase Return------------------------------
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 2),
                  child: cw.CUTestbox(label: "Purchase Return",controllerName: Purchase_Return_Controller),
                ),

                Visibility(visible: showGstprt==true,

                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(children:[
                        Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                              child: Container(
                                child: cw.CUTestbox(
                                    label: "CGST",
                                    controllerName:PrRtn_CGST_Controller ),
                              ),
                            )),


                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                            child: Container(
                                child: cw.CUTestbox(
                                    label: "SGST",
                                    controllerName: PrRtn_SGST_Controller)),
                          ),
                        ),


                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                            child: Container(
                                child: cw.CUTestbox(
                                  label: "IGST",
                                  controllerName:PrRtn_IGST_Controller,)),
                          ),
                        ),
                      ],
                      ),
                    )),



                ///-----------------------Sales--------------------------------
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 2),
                  child: Container(
                      child: cw.CUTestbox(
                          label: "Sales Account",
                          controllerName: Sales_Account_Controller)),
                ),

                Visibility(visible: showGstprt==true,

                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(children:[
                        Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                              child: Container(
                                child: cw.CUTestbox(
                                    label: "CGST",
                                    controllerName:SlsAcc_CGST_Controller ),
                              ),
                            )),


                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                            child: Container(
                                child: cw.CUTestbox(
                                    label: "SGST",
                                    controllerName: SlsAcc_SGST_Controller)),
                          ),
                        ),


                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                            child: Container(
                                child: cw.CUTestbox(
                                  label: "IGST",
                                  controllerName:SlsAcc_IGST_Controller,)),
                          ),
                        ),
                      ],
                      ),
                    )),


                ///-----------------------Sales---return----------------------------
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 2),
                  child: Container(
                      child: cw.CUTestbox(
                          label: "Sales Return",
                          controllerName: Sales_Return_Controller)),
                ),


                Visibility(visible: showGstprt==true,

                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(children:[
                        Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                              child: Container(
                                child: cw.CUTestbox(
                                    label: "CGST",
                                    controllerName:SlsRtn_CGST_Controller ),
                              ),
                            )),


                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                            child: Container(
                                child: cw.CUTestbox(
                                    label: "SGST",
                                    controllerName: SlsRtn_SGST_Controller)),
                          ),
                        ),


                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                            child: Container(
                                child: cw.CUTestbox(
                                  label: "IGST",
                                  controllerName:SlsRtn_IGST_Controller,)),
                          ),
                        ),
                      ],
                      ),
                    )),



                ///-----------Acc head---------------------
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 2),
                  child: cw.CUTestbox(label: "Account Head",controllerName: Account_Head_Controller),
                ),


                Visibility(visible: showGstprt==true,

                    child: Row(children:[
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                            child: Container(
                              child: cw.CUTestbox(
                                  label: "CGST",
                                  controllerName:AccHd_CGST_Controller ),
                            ),
                          )),


                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                          child: Container(
                              child: cw.CUTestbox(
                                  label: "SGST",
                                  controllerName: AccHd_SGST_Controller)),
                        ),
                      ),


                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                          child: Container(
                              child: cw.CUTestbox(
                                label: "IGST",
                                controllerName:AccHd_IGST_Controller,)),
                        ),
                      ),
                    ],
                    )),


//---------------------------------------------------------------------------------
                if (taxlist.length>0) Row(
                  children: [
                    Expanded(
                      child: DataTable(showCheckboxColumn: false,

                        columnSpacing: 15,
                        onSelectAll: (b) {},
                        sortAscending: true,
                        headingRowColor: theam.TableHeadRowClr,
                        columns: <DataColumn>[
                          DataColumn(
                            label: Text('Description',style: theam.TableFont,),
                          ),
                          DataColumn(
                            label: Text('Percentage',style: theam.TableFont),
                          ),
                          DataColumn(
                            label: Text(' '),
                          ),

                        ],
                        rows: taxlist
                            .map(
                              (itemRow) => DataRow(
                            onSelectChanged:(a){
                            } ,
                            cells: [
                              DataCell(
                                Container(width:MediaQuery.of(context).size.width/3,
                                    child: Text('${itemRow.txDescription.toString()}')),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Container(width:MediaQuery.of(context).size.width/3,
                                  child: Text(
                                      '${itemRow.txPercentage.toString()}',),
                                ),
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
                                            // print("edit $itemRow");
                                             //print(itemRow.txDescription);
                                             EditBinding(itemRow);
                                             Edit_Id=itemRow.txId;
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
                                            Delete(itemRow.txId);
                                          },


                                        )
                                      ],),
                                    ),)
                                  ],
                                  icon: Icon(Icons.more_horiz),
                                  //offset: Offset()
                                ),


                                showEditIcon: false,
                                placeholder: false,
                              ),



                            ],
                          ),
                        )
                            .toList(),
                      ),
                    )
                  ],
                ) else Center(child:Text(""))






///---------------------button tab row-----------------------
              ],
            ),
          ),
          bottomNavigationBar: Container(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4, 4, 2, 4),
                    child: cw.CUButton(
                        name: Save_UpdateButton,
                        H: 50,
                        function: () {
                          CheckValidation();
                        },
                        Labelstyl: TextStyle(
                          fontSize: 30,
                          color: Colors.white
                        ),
                        color:theam.saveBtn_Clr),
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(2, 4, 4, 4),
                  child: cw.CUButton(
                      name: "Clear",
                      H: 50,
                      function: () {
                        Clear();

                      },
                      Labelstyl: TextStyle(
                        fontSize: 30,
                        color: Colors.white
                      ),
                      color: Colors.indigo),
                ))
              ],
            ),
          )),
    ));
  }
}
