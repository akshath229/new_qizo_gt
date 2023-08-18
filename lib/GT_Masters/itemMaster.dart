import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_qizo_gt/GT_Masters/taxMaster.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../AQizo_RMS/New_Delivery_App/Del_ItemHome.dart' as delItemHome; // Aliased
import '../appbarWidget.dart';
import '../models/userdata.dart';
import '../urlEnvironment/urlEnvironment.dart';
import 'AppTheam.dart';
import 'Masters_UI/Brand_Create.dart';
import 'Masters_UI/Manufacturer_Create.dart';
import 'Masters_UI/Unit_create_CW.dart';
import 'Masters_UI/cuWidgets.dart';
import 'Models/Items.dart';
import 'Models/Tax_master.dart';
import 'Models/Unit_model.dart';
import 'item_Master_List.dart';

class ItemMaster extends StatefulWidget {

  String Btn_Name;
  dynamic data;

  ItemMaster({required this.Btn_Name, @required this.data});
  @override
  _ItemMasterState createState() => _ItemMasterState();
}

class _ItemMasterState extends State<ItemMaster> {
  double TextBoxCurve=10.0;
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

// //----------------------------------

  CUWidgets cw = CUWidgets();
  AppTheam theam =AppTheam();
  var EditImage;

  static List<ItemList> ItmLst = [];
  static List<Unit> unit = [];
  static List<StockType> sttyp =[];
  static List<ProductType> prodtyp = [];
  static List<Tax> taxlist = [];
  static List<ItemGroup> ItmGrp = [];





  TextEditingController ItemNameController = TextEditingController();
  TextEditingController Print_CaptionrController = TextEditingController();
  TextEditingController Hsn_Controller = TextEditingController();
  TextEditingController Item_Grp_Controller = TextEditingController();


  TextEditingController Pur_Tax_Controller = TextEditingController();
  TextEditingController Sale_Tax_Controller = TextEditingController();



  TextEditingController SRate_Controller = TextEditingController();
  TextEditingController PRate_Controller = TextEditingController();
  TextEditingController Unit_Controller = TextEditingController();
  TextEditingController Mrp_Controller = TextEditingController();

  TextEditingController Stk_typ_Controller = TextEditingController();
  TextEditingController Prod_typ_Controller = TextEditingController();
  TextEditingController Opn_Stk_Controller = TextEditingController();

  TextEditingController Itm_code_Controller = TextEditingController();
  TextEditingController BarCode_Controller = TextEditingController();
  TextEditingController Arabic_Name_Controller = TextEditingController();
  TextEditingController Display_Order_Controller = TextEditingController();




  TextEditingController  Specifications_Controller = TextEditingController();
  TextEditingController  Model_Controller = TextEditingController();
  TextEditingController  Monthly_Target_Controller = TextEditingController();
  TextEditingController  Manufacturer_Controller = TextEditingController();
  TextEditingController  Brand_Controller = TextEditingController();
  TextEditingController  Warranty_Controller = TextEditingController();
  TextEditingController  ROL_Controller = TextEditingController();
  TextEditingController  ROQ_Controller = TextEditingController();
  TextEditingController  Minimum_Qty_Controller = TextEditingController();
  TextEditingController  Description_Controller = TextEditingController();
  TextEditingController  Maximum_Qty_Controller = TextEditingController();





  bool ItemName_Select = false;
  bool Print_Captionr_Select = false;
  bool Hsn_Select = false;
  bool Item_Grp_Select = false;
  bool Unit_Select = false;
  bool Stk_typ_Select = false;
  bool Prod_typ_Select=false;





bool Pur_Tax_Inclusive=false;
  bool Sales_Tax_Inclusive=false;

  int? ItmId = null;
  dynamic UnitId = null;
  int? Stk_typ_Id = null;
  int? Prod_typ_Id=null;
  dynamic Sale_Tax_Id=null;//
  int? Pur_Tax_Id=null;
  int? Item_Grp_Id=null;
  int? Brand_Id=null;
  int? Manufacturer_Id=null;

  var unitTyp=[];
  var BrandList=[];
  var ManufacturerList=[];

///--------------------rate page-----------------
  var RateList=[];//for rate table
  var rtlst={};//for rate table
  int rowid=0;//for rate table row identify
 bool rate_tbl_visibel=false;
 // Icon AddEditIcon= Icon(Icons.add_circle_outline);
  var RateEdit_Id=0;
///-----------------------------------------------

  String Button_Name="Save";
   int? Edit_Id=null;
  var dio = Dio();

  void initState() {
    setState(() {
      SharedPreferences.getInstance().then((value) {
        pref = value;
        read();
        GetUnit();
        GetTax();
        GetItemGrp();
        GetItem();
        GetTax();
        GetManufacturer();
        GetBrand();
         RateList=[];
         rtlst={};
        Button_Name=widget.Btn_Name;
         MethodeCheck();// Check for add or edit or delete
      });
    });
  }



//--------------------Add or edit or delete ----------------------------------------
  MethodeCheck() {
    if (Button_Name == "Save") {
      print("Save");
      GetStockType();
      GetProductType();
    }
    else {
      print("Delete or edit");
      EditItemDataBind(widget.data);
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

// //---------------end---for appbar------------

//--------------Get unit-----------------------
  GetUnit() async {
    var jsonres = await cw.CUget_With_Parm(api: "Gtunits", Token: token);

    if (jsonres != false) {
      var res = jsonDecode(jsonres);
      //  print("Unites = $res");

      List<dynamic> unitdetl = res["gtunit"];
      List<Unit> p =
      unitdetl.map((unitdetl) => Unit.fromJson(unitdetl)).toList();
      unit = p;
    }
  }


//--------------GetItem-----------------------
  GetStockType() async {
    var jsonres = await cw.CUget_With_Parm(
        api: "MStockTypeStatics", Token: token);

    if (jsonres != false) {
      var res = jsonDecode(jsonres);
       print("StockType = $res");

      List<dynamic> data = res;
      List<StockType> p =
      data.map((data) => StockType.formJson(data)).toList();
      sttyp = p;

      setState(() {
        Stk_typ_Id=res[0]["id"];
        Stk_typ_Controller.text=res[0]["stockType"];
      });

    }
  }



//--------------GetProductType-----------------------
  GetProductType() async {
    var jsonres = await cw.CUget_With_Parm(
        api: "MProductTypeStatics", Token: token);

    if (jsonres != false) {
      var res = jsonDecode(jsonres);
      print("Product Type = $res");

      List<dynamic> data = res;
      List<ProductType> p =
      data.map((data) => ProductType.formJson(data)).toList();
      prodtyp = p;

      var i=prodtyp.length>1?1:0;
      setState(() {
        Prod_typ_Id=res[i]["id"];
      Prod_typ_Controller.text=res[i]["productType"];
    });

  }
  }




//--------------Get Tx Type-----------------------
  GetTax() async {
    var jsonres = await cw.CUget_With_Parm(
        api: "MTaxes", Token: token);

    if (jsonres != false) {
      var res = jsonDecode(jsonres);
   //   print(" Taxes= $res");

      List<dynamic> data = res["taxList"];
      List<Tax> p =
      data.map((data) => Tax.formJson(data)).toList();
      taxlist = p;
      print(" Taxas are");
      print(p);
    }
  }


//--------------GetItemGrp  Type-----------------------
  GetItemGrp()async{

    var jsonres = await cw.CUget_With_Parm(api: "Gtitemgroups",Token:token );
    if(jsonres !=false){

      var result=jsonDecode(jsonres)["gtItemGroup"];

      List <dynamic> tagsJson =result;
      List<ItemGroup> p = tagsJson.map((tagsJson) => ItemGroup.fromJson(tagsJson)).toList();
      ItmGrp = p;
// print(jsonEncode(p));
    }else{
      print("Error on GetItemGrp");
    }

  }


//--------------GetItemGrp  Type-----------------------
  GetItem()async{

    var jsonres = await cw.CUget_With_Parm(api:"GtitemMasters/0/1/",Token:token );
    if(jsonres !=false){

      var result=jsonDecode(jsonres);
      List<dynamic> t = result;
      List<ItemList> p = t.map((t) => ItemList.fromJson(t)).toList();
      ItmLst = p;

// print(jsonEncode(p));
    }else{
      print("Error on GetItem");
    }

  }






  //--------------Get Brand------------------
  GetBrand() async {
    var jsonres = await cw.CUget_With_Parm(
        api: "MBrands", Token: token);

    if (jsonres != false) {
      var res = jsonDecode(jsonres);

      BrandList = res as List;

    }
  }





//--------------Get Manufacturer-----------------------
  GetManufacturer() async {
    var jsonres = await cw.CUget_With_Parm(
        api: "MManufacturers", Token: token);

    if (jsonres != false) {
      var res = jsonDecode(jsonres);
      //   print(" Taxes= $res");

      ManufacturerList= res as List;

    }
  }









  //--------------Validation before save-----------------------

Validation_SaveAll(){


if(ItemNameController.text==""){
  print("Validation Completed");
  setState(() {

    ItemName_Select=true;
  });
}

else if(Item_Grp_Controller.text=="" &&Item_Grp_Id==null ){

  setState(() {
    Item_Grp_Select=true;
    ItemName_Select=false;
  });
}
else if(Stk_typ_Controller.text==""||Stk_typ_Id==null) {
  setState(() {
    Item_Grp_Select = false;
    Stk_typ_Select = true;
    cw.MessagePopup(context, "Please Add Stock Type", Colors.indigo.shade400);
  });
}
else if(Prod_typ_Controller.text==""||Prod_typ_Id==null){

  setState(() {
    Prod_typ_Select=true;
    Stk_typ_Select = false;
    cw.MessagePopup(context, "Please Add Product Type", Colors.indigo.shade400);
  });


}else {
  setState(() {
    Item_Grp_Select=false;
    ItemName_Select=false;
    Prod_typ_Select=false;
    print("Validation Completed");
      ItemMstrsave();
  });

}

}

///-------------------------single rate add-------------------------------
  Validation_Rate() {
    if (Unit_Controller.text == "" || UnitId == null) {
      setState(() {
      //  Unit_Select = true;
      });
    } else {
      setState(() {
      //  Unit_Select = false;
        AddRate();
        //Save_edit == "Icon(IconData(U+0E570))" ? AddRate() : SaveEditRate();
      });
    }
  }


  AddRate() {
    RateList.clear();
    print("AddRate");
    rtlst={
      "id":1,
      "p.rate":PRate_Controller.text==""?null:PRate_Controller.text,
      "s.rate":SRate_Controller.text==""?null:SRate_Controller.text,
      "unit_id":UnitId,
      "unit_Name":Unit_Controller.text==""?null:Unit_Controller.text,
      "mrp":Mrp_Controller.text==""?null:Mrp_Controller.text,
    };

    print(rtlst.toString());
    setState(() {
      RateList.add(rtlst);
      SRate_Controller.text = "";
      PRate_Controller.text = "";
      Unit_Controller.text = "";
      Mrp_Controller.text = "";
      UnitId=null;
    });

    print(RateList.toString());
    print("RateList");
  }

  ///----------------------------------------------------------

//---------------------------save------------------------

  ItemMstrsave()async {
    try {

      Validation_Rate();
      UnitId=RateList.length<1?"":RateList[0]["unit_id"];

    if (Button_Name == "Save") {
    //  UnitId=RateList.length<1?"":RateList[0]["unit_id"];
        var finalData = {

// "id":Edit_Id,
          "itmName": ItemNameController.text == "" ? null : ItemNameController
              .text.trim(),
          "itmPrintCaption": Print_CaptionrController.text,
          "itmStkTypeId": Stk_typ_Id == null ? null : Stk_typ_Id,
          "itmProductTypeId": Prod_typ_Id == null ? null : Prod_typ_Id,
          "itmTaxId": Sale_Tax_Id == null ? null : (Sale_Tax_Id).toInt(),
          "itmGrpId": Item_Grp_Id == null ? null : Item_Grp_Id,
          "itmUnitId":UnitId==null?null:UnitId,
          "itmMfrId": Manufacturer_Id,
          "itmBrandId": Brand_Id,
          "itmCode": Itm_code_Controller.text == "" ? null : Itm_code_Controller
              .text,
          "itmBarCode": BarCode_Controller.text == ""
              ? null
              : BarCode_Controller.text,
          "itmDescription": Description_Controller.text == ""
              ? null
              : Description_Controller.text,
          "itmRol": ROL_Controller.text == "" ? null : ROL_Controller.text,
          "itmRoq": ROQ_Controller.text == "" ? null : ROQ_Controller.text,
          "itmMinQty": Minimum_Qty_Controller.text == ""
              ? null
              : Minimum_Qty_Controller.text,
          "itmMaxQty": Maximum_Qty_Controller.text == ""
              ? null
              : Maximum_Qty_Controller.text,
          "itmWarrantyInMonths": Warranty_Controller.text == ""
              ? null
              : Warranty_Controller.text,
          "itmSpecification": Specifications_Controller.text == ""
              ? null
              : Specifications_Controller.text,
          "itmHsn": Hsn_Controller.text == "" ? null : Hsn_Controller.text,
          "itmModel": Model_Controller.text == "" ? null : Model_Controller
              .text,
          "itmIsTaxAplicable": Sales_Tax_Inclusive,
          //not...........
          "itmMonthlyTarget": Monthly_Target_Controller.text == ""
              ? null
              : Monthly_Target_Controller.text,
          "itmUserId": userId,
          "itmBranchId": branchId,
          "itmTaxInclusive": Sales_Tax_Inclusive,
          //"itmSalesRate": SRate_Controller.text == "" ? null : SRate_Controller.text,
          "itmSalesRate": RateList.length<1?"":RateList[0]["s.rate"]??"",
          //"itmPurchaseRate": PRate_Controller.text == "" ? null: PRate_Controller.text,
          "itmPurchaseRate":RateList.length<1?"":RateList[0]["p.rate"]??"",
          //"itmMrp": Mrp_Controller.text == "" ? null : Mrp_Controller.text,
          "itmMrp":RateList.length<1?"":RateList[0]["mrp"]??"",
          "itmPurchaseTaxId": Pur_Tax_Id,
          "itmPurchaseTaxInclusive": Pur_Tax_Inclusive,
          "itmDisplayOrder": Display_Order_Controller.text == ""
              ? null
              : Display_Order_Controller.text,
          "itmArabicName": Arabic_Name_Controller.text == ""
              ? null
              : Arabic_Name_Controller.text,
          "itmImage": null,
          //_image.toString(),
          "itmIconImgpath": null,
          // "itmBrand" : Brand_Controller.text==""?null:Brand_Controller.text,
          "itmGrp": null,
          //Item_Grp_Controller.text==""?null:Item_Grp_Controller.text,
          "itmMfr": Manufacturer_Controller.text == ""
              ? null
              : Manufacturer_Controller.text,
          "itmProductType": null,
          // Prod_typ_Controller.text==""?null:Prod_typ_Controller.text,
          "itmPurchaseTax": null,
          // Pur_Tax_Controller.text==""?null:Pur_Tax_Controller.text,
          "itmStkType": null,
          //Stk_typ_Controller.text==""?null:Stk_typ_Controller.text,
          "itmTax": null,
          //Sale_Tax_Controller.text==""?null:Sale_Tax_Controller.text,
          "itmUnit":"",//RateList.length<1?"":RateList[0]["unit_Name"]??"",//null,// Unit_Controller.text == "" ? null : Unit_Controller.text,
          // "itmBatchEnabled": true,
          // "itmExpirtyEnabled": true,
          "gtRelItemUom": [

            // for(int i = 0; i < RateList.length; i++){
            //   // "itemid": Edit_Id,
            //   "unitId": RateList[i]["unit_id"],
            //   "mrp": RateList[i]["mrp"],
            //   "srate": RateList[i]["s.rate"],
            //   "prate": RateList[i]["p.rate"],
            //   "unit":null// RateList[i]["unit_Name"],
            // }
          ]
        };
        print(json.encode(finalData).toString());
        var parm = json.encode(finalData);
        print("Save");
        String filePath = _image == null ? "" : _image.path;
        String fileName = 'filePath.jpeg';


        var formData = FormData.fromMap({
          //'itmImage':_image==null?"null": await MultipartFile.fromFile(filePath,filename:fileName),
          // "itmImage":"null",
          // 'itmIcon':"null",
          //'jsonString':json.encode(test),
          'jsonString': parm,
        });

        print("FormData");

        print(formData.fields);
        // print(formData.files);
      RateList.clear();
        var res = await dio.post("${Env.baseUrl}GtitemMasters",
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

// if(res!=false && res.toString().contains("msg")) {
//   // print("contains(msg)");
//   var resmsg=jsonDecode(res);
//   // print(resmsg.toString());
//   // print(resmsg["msg"].toString());
//
//   cw.MessagePopup(context,resmsg["msg"]);
//   return;
//
// }
        if (res.statusCode == 200 || res.statusCode == 201) {
          print(res.toString());
          print("success");
          cw.SavePopup(context);
          RefershFunction();
          GetItem();
        } else {
          print(res.toString());
          print("error");
          cw.FailePopup(context);
        }


        // var res = await cw.post(
        //     api: "GtitemMasters", body: parm, deviceId: DeviceId, Token: token);
        // if (res != false) {
        //   print("success");
        //   print(res.toString());
        // } else {
        //   print("fail");
        //   print(res.toString());
        // }
      }

//-----------Edit---------------
    else if (Button_Name == "Edit") {
      print("Edit");
        var finalEditData = {
          "id": Edit_Id,
          "itmName":
              ItemNameController.text == "" ? null : ItemNameController.text.trim(),
          "itmPrintCaption": Print_CaptionrController.text,
          "itmStkTypeId": Stk_typ_Id == null ? null : Stk_typ_Id,
          "itmProductTypeId": Prod_typ_Id == null ? null : Prod_typ_Id,
          "itmTaxId": Sale_Tax_Id == null ? null : (Sale_Tax_Id).toInt(),
          "itmGrpId": Item_Grp_Id == null ? null : Item_Grp_Id,
          "itmUnitId": UnitId == null ? null : UnitId,
          "itmMfrId": Manufacturer_Id,
          "itmBrandId": Brand_Id,
          "itmCode":Itm_code_Controller.text == "" ? null : Itm_code_Controller.text,
          "itmBarCode":BarCode_Controller.text == "" ? null : BarCode_Controller.text,
          "itmDescription": Description_Controller.text == ""? null: Description_Controller.text,
          "itmRol": ROL_Controller.text == "" ? null : ROL_Controller.text,
          "itmRoq": ROQ_Controller.text == "" ? null : ROQ_Controller.text,
          "itmMinQty": Minimum_Qty_Controller.text == ""? null: Minimum_Qty_Controller.text,
          "itmMaxQty": Maximum_Qty_Controller.text == ""? null: Maximum_Qty_Controller.text,
          "itmWarrantyInMonths":Warranty_Controller.text == "" ? null : Warranty_Controller.text,
          "itmSpecification": Specifications_Controller.text == ""? null: Specifications_Controller.text,
          "itmHsn": Hsn_Controller.text == "" ? null : Hsn_Controller.text,
          "itmModel":
              Model_Controller.text == "" ? null : Model_Controller.text,
          "itmIsTaxAplicable": Sales_Tax_Inclusive,
          //not...........
          "itmMonthlyTarget": Monthly_Target_Controller.text == ""
              ? null
              : Monthly_Target_Controller.text,
          "itmUserId": userId,
          "itmBranchId": branchId,
          "itmTaxInclusive": Sales_Tax_Inclusive,
          "itmSalesRate": RateList.length<1?"":RateList[0]["s.rate"]??"",
          //"itmSalesRate":SRate_Controller.text == "" ? null : SRate_Controller.text,
         // "itmPurchaseRate":PRate_Controller.text == "" ? null : PRate_Controller.text,
          "itmPurchaseRate":RateList.length<1?"":RateList[0]["p.rate"]??"",
          "itmMrp":RateList.length<1?"":RateList[0]["mrp"]??"",
          //"itmMrp": Mrp_Controller.text == "" ? null : Mrp_Controller.text,
          "itmPurchaseTaxId": Pur_Tax_Id,
          "itmPurchaseTaxInclusive": Pur_Tax_Inclusive,
          "itmDisplayOrder": Display_Order_Controller.text == ""
              ? null
              : Display_Order_Controller.text,
          "itmArabicName": Arabic_Name_Controller.text == ""
              ? null
              : Arabic_Name_Controller.text,
          "itmImage": null,
          //_image.toString(),
          "itmIconImgpath": null,
          // "itmBrand" : Brand_Controller.text==""?null:Brand_Controller.text,
          "itmGrp": null,
          //Item_Grp_Controller.text==""?null:Item_Grp_Controller.text,
          "itmMfr": Manufacturer_Controller.text == ""
              ? null
              : Manufacturer_Controller.text,
          "itmProductType": null,
          // Prod_typ_Controller.text==""?null:Prod_typ_Controller.text,
          "itmPurchaseTax": null,
          // Pur_Tax_Controller.text==""?null:Pur_Tax_Controller.text,
          "itmStkType": null,
          //Stk_typ_Controller.text==""?null:Stk_typ_Controller.text,
          "itmTax": null,
          //Sale_Tax_Controller.text==""?null:Sale_Tax_Controller.text,
          "itmUnit":"",//RateList.length<1?"":RateList[0]["unit_Name"]??"",// Unit_Controller.text == "" ? null : Unit_Controller.text,
          // "itmBatchEnabled": true,
          // "itmExpirtyEnabled": true,
          "gtRelItemUom": [
          //   for (int i = 0; i < RateList.length; i++)
          //     {
          //       "itemid": Edit_Id,
          //       "unitId": RateList[i]["unit_id"],
          //       "mrp": RateList[i]["mrp"],
          //       "srate": RateList[i]["s.rate"],
          //       "prate": RateList[i]["p.rate"],
          //       "unit": null, //RateList[i]["unit_Name"],
          //     }
          ]
        };
        var Editparm = json.encode(finalEditData);
      var formData;


      if (_image.runtimeType.toString() == "String") {
        formData = FormData.fromMap({
          // 'itmImage': _image == null ? null : await MultipartFile.fromString(_image,filename: ".jpeg"),
          // 'itmIcon': null,
          'jsonString': Editparm,
        });
      }
      else {
        String filePath = _image == null ? "" : _image.path;
        String fileName = 'filePath.jpeg';
        formData = FormData.fromMap({
          // 'itmImage': _image == null ? null : await MultipartFile.fromFile(
          //     filePath, filename: fileName),
          // 'itmIcon': null,

          'jsonString': Editparm,
        });
      }

      print("FormData");
      print(formData.toString());

      print(formData.fields);

      var res = await dio.put("${Env.baseUrl}GtitemMasters/$Edit_Id",
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

// if(res!=false && res.toString().contains("msg")) {
//   // print("contains(msg)");
//   var resmsg=jsonDecode(res);
//   // print(resmsg.toString());
//   // print(resmsg["msg"].toString());
//
//   cw.MessagePopup(context,resmsg["msg"]);
//   return;
//
// }
      if (res.statusCode == 409) {
        print(res.toString());
        print("Duplicate");
        cw.MessagePopup(context, "Duplicate", Colors.deepOrangeAccent.shade100);
      } else if (res.statusCode == 200 || res.statusCode == 204) {
        print(res.toString());
        print("Updated");
        cw.UpdatePopup(context);
        RefershFunction();
        GetItem();
      } else {
        print(res.toString());
        print("error");
        cw.FailePopup(context);
      }
    }

//-----------Delete---------------
    else {
      print("Delete");
      var res = await cw.delete(
          api: "GtitemMasters/$Edit_Id", Token: token, deviceId: DeviceId);
      if (res != false && res.toString().contains("msg")) {
        var resmsg = jsonDecode(res);
        cw.MessagePopup(context, resmsg["msg"], Colors.red);
        return;
      }
      else if (res != false) {
        cw.DeletePopup(context);
        // RefershFunction();
      } else {
        cw.FailePopup(context);
      }
    }
  }catch(e){
      print("Error in $Button_Name: $e");
      cw.FailePopup(context);

    }
  }



  ///----------------------for image selectoin-------------------------------

  var _image;
  ImagePicker picker = ImagePicker();

  Future getImageFromGallery() async {
    print("on getImage");
try {
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  setState(() {
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      print("image selected.. $_image");
    } else {
      print('No image selected.');
    }
  });
  return true;
}catch(e){ print('error on getImageFromGallery $e');}
  }

  Future getImageFromCamera() async {
    print("on getImage");
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });

      } else {
        print('No image selected.');
      }
    });
  }




  RefershFunction(){

    setState(() {


      ItemNameController.text = "";
      Print_CaptionrController.text = "";
      Hsn_Controller.text = "";
      Item_Grp_Controller.text = "";


      Pur_Tax_Controller.text = "";
      Sale_Tax_Controller.text = "";



      SRate_Controller.text = "";
      PRate_Controller.text = "";
      Unit_Controller.text = "";
      Mrp_Controller.text = "";

      Stk_typ_Controller.text = "";
      Prod_typ_Controller.text = "";
      Opn_Stk_Controller.text = "";

      Itm_code_Controller.text = "";
      BarCode_Controller.text = "";
      Arabic_Name_Controller.text = "";
      Display_Order_Controller.text = "";




      Specifications_Controller.text = "";
      Model_Controller.text = "";
      Monthly_Target_Controller.text = "";
      Manufacturer_Controller.text = "";
      Brand_Controller.text = "";
      Warranty_Controller.text = "";
      ROL_Controller.text = "";
      ROQ_Controller.text = "";
      Minimum_Qty_Controller.text = "";
      Description_Controller.text = "";
      Maximum_Qty_Controller.text = "";

      ItemName_Select = false;
      Print_Captionr_Select = false;
      Hsn_Select = false;
      Item_Grp_Select = false;
      Unit_Select = false;
      Stk_typ_Select = false;
      Prod_typ_Select=false;
      RateList.clear();




      Pur_Tax_Inclusive=false;
      Sales_Tax_Inclusive=false;

      ItmId = null;
      UnitId = null;
      Stk_typ_Id = null;
      Prod_typ_Id=null;
      Sale_Tax_Id=null;//
      Pur_Tax_Id=null;
      Item_Grp_Id=null;
      Brand_Id=null;
      Manufacturer_Id=null;

      unitTyp=[];
      BrandList=[];
      ManufacturerList=[];

      ///--------------------rate page-----------------
      RateList=[];//for rate table
      rtlst={};//for rate table
      rowid=0;//for rate table row identify
      rate_tbl_visibel=false;
     // AddEditIcon= Icon(Icons.add_circle_outline);
      RateEdit_Id!=null;
      ///-----------------------------------------------

      Button_Name="Save";
      Edit_Id=null;
      _image=null;


      GetStockType();
      GetProductType();

    });
  }



//-----use to data binding both Edit And Delete-------
  EditItemDataBind(Edit_Data)async{
//     print("EditItemDataBind");
// print(Edit_Data.toString());
// print(Edit_Data["itmName"].toString());
//     print(Edit_Data["itmImage"].toString());
setState(() {


Edit_Id=Edit_Data["id"];
    ItemNameController.text=Edit_Data["itmName"].toString()=="null"?"":Edit_Data["itmName"];
    Print_CaptionrController.text=Edit_Data["itmPrintCaption"].toString()=="null"?"":Edit_Data["itmPrintCaption"];
    Hsn_Controller.text=Edit_Data["itmHsn"].toString()=="null"?"":Edit_Data["itmHsn"];
    Item_Grp_Controller.text=Edit_Data["igDescription"].toString()=="null"?"":Edit_Data["igDescription"];

// print("------------------");
// var s=taxlist.map((e) {
//   if(e.txId==Edit_Data["itmPurchaseTaxId"]){
//     return e.txDescription;
//   }
//   return 0;
// });


    Pur_Tax_Controller.text=Edit_Data["itmPurchaseTax"].toString()=="null"?"":Edit_Data["itmPurchaseTax"];
   // Pur_Tax_Controller.text=PurTax.toString()=="null"?"":PurTax;
    Sale_Tax_Controller.text=Edit_Data["txDescription"].toString()=="null"?"":Edit_Data["txDescription"].toString();




    Stk_typ_Controller.text=Edit_Data["stockType"].toString()=="null"?"":Edit_Data["stockType"];
    Prod_typ_Controller.text=Edit_Data["productType"].toString()=="null"?"":Edit_Data["productType"];
   // Opn_Stk_Controller.text=Edit_Data["id"].toString()=="null"?"":Edit_Data["id"].toString();
      Opn_Stk_Controller.text="";
    Itm_code_Controller.text=Edit_Data["itmCode"].toString()=="null"?"":Edit_Data["itmCode"];
    BarCode_Controller.text=Edit_Data["itmBarCode"].toString()=="null"?"":Edit_Data["itmBarCode"];
    Arabic_Name_Controller.text=Edit_Data["itmArabicName"].toString()=="null"?"":Edit_Data["itmArabicName"];
    Display_Order_Controller.text=Edit_Data["itmDisplayOrder"].toString()=="null"?"":Edit_Data["itmDisplayOrder"].toString();




    Specifications_Controller.text=Edit_Data["itmSpecification"].toString()=="null"?"":Edit_Data["itmSpecification"];
    Model_Controller.text=Edit_Data["itmModel"].toString()=="null"?"":Edit_Data["itmModel"];
    Monthly_Target_Controller.text=Edit_Data["itmMonthlyTarget"].toString()=="null"?"":Edit_Data["itmMonthlyTarget"].toString();
    Manufacturer_Controller.text=Edit_Data["mfrDescription"].toString()=="null"?"":Edit_Data["mfrDescription"];
    Brand_Controller.text=Edit_Data["brndDescription"].toString()=="null"?"":Edit_Data["brndDescription"];
    Warranty_Controller.text=Edit_Data["itmWarrantyInMonths"].toString()=="null"?"":Edit_Data["itmWarrantyInMonths"].toString();
    ROL_Controller.text=Edit_Data["itmRol"].toString()=="null"?"":Edit_Data["itmRol"].toString();
    ROQ_Controller.text=Edit_Data["itmRoq"].toString()=="null"?"":Edit_Data["itmRoq"].toString();
    Minimum_Qty_Controller.text=Edit_Data["itmMinQty"].toString()=="null"?"":Edit_Data["itmMinQty"].toString();
    Description_Controller.text=Edit_Data["itmDescription"].toString()=="null"?"":Edit_Data["itmDescription"].toString();
    Maximum_Qty_Controller.text=Edit_Data["itmMaxQty"].toString()=="null"?"":Edit_Data["itmMaxQty"].toString();



    Pur_Tax_Inclusive=Edit_Data["itmPurchaseTaxInclusive"].toString()=="null"?false:Edit_Data["itmPurchaseTaxInclusive"];
    Sales_Tax_Inclusive=Edit_Data["itmTaxInclusive"].toString()=="null"?false:Edit_Data["itmTaxInclusive"];

    ItmId = Edit_Data["id"];
    UnitId = Edit_Data["itmUnitId"];
    Stk_typ_Id = Edit_Data["itmStkTypeId"];
    Prod_typ_Id=Edit_Data["itmProductTypeId"];
    Sale_Tax_Id=Edit_Data["itmTaxId"];
    Pur_Tax_Id=Edit_Data["itmPurchaseTaxId"];
    Item_Grp_Id=Edit_Data["itmGrpId"];
    Brand_Id=Edit_Data["itmBrandId"];
    Manufacturer_Id=Edit_Data["itmMfrId"];


      SRate_Controller.text=Edit_Data["itmSalesRate"].toString()=="null"?"":Edit_Data["itmSalesRate"].toString();
      PRate_Controller.text=Edit_Data["itmPurchaseRate"].toString()=="null"?"":Edit_Data["itmPurchaseRate"].toString();
      Unit_Controller.text=Edit_Data["itmUnit"].toString()=="null"?"":Edit_Data["itmUnit"];
      Mrp_Controller.text=Edit_Data["itmMrp"].toString()=="null"?"":Edit_Data["itmMrp"].toString();

      _image= Edit_Data["itmImage"]==""?null:Edit_Data["itmImage"];

  var PurTaxNAme="";

if(Pur_Tax_Id!=null){
 PurTaxNAme =  GetTaxName(Pur_Tax_Id);
}
  Pur_Tax_Controller.text=PurTaxNAme;
   // print(Edit_Data["itmImage"]);

var RateBindUnit=Edit_Data["itmUnitId"].toString()=="null"?"":Edit_Data["itmUnitId"].toString();
  var UnitName="";
  if(RateBindUnit!=""){
     UnitName= GetUnitName(RateBindUnit);
  }

  Unit_Controller.text=UnitName??"";
var ratebind={

    "id":1,
    "p.rate":Edit_Data["itmPurchaseRate"].toString()=="null"?"":Edit_Data["itmPurchaseRate"].toString(),
    "s.rate":Edit_Data["itmSalesRate"].toString()=="null"?"":Edit_Data["itmSalesRate"].toString(),
    "unit_id":Edit_Data["itmUnitId"].toString()=="null"?"":Edit_Data["itmUnitId"].toString(),
    "unit_Name":UnitName??"",
    "mrp":Edit_Data["itmMrp"].toString()=="null"?"":Edit_Data["itmMrp"].toString()

    };

  RateList.add(ratebind);

});
  }


  GetUnitName(id){
    var s;
    final _results = unit.where((product) => product.id.toString() == id.toString());
    for (Unit p in _results) {
      s=p.description;
      print(p.description);
      print("p.description");
    }
    return s;
  }

  GetTaxName(id){
    print("taxlist");
    var s;
    final _results = taxlist.where((product) => product.txId.toString() == id.toString());
    for (Tax p in _results) {
      s=p.txDescription;
      print(p.txDescription);
      print("p.txDescription");
    }
    return s;
  }

//---------------- getRateEditData-get Rate part of Item while edit---------------------

  getRateEditData(id)async{
    print("AddRatessss");
    var jsonres = await cw.CUget_With_Parm(api: "GtitemMasters/$id",Token:token );
    if(jsonres!=false){
      print(jsonres.toString());
      var result=jsonDecode(jsonres);
      var RateData=result["uomgtRelItemUom"];


      print("RateData.length");
      print(RateData.length.toString());

      for(int i=0;i< RateData.length;i++){
        rowid=RateData[i]["id"];
        var EditRateData={
          "id":RateData[i]["id"],
          "p.rate":RateData[i]["prate"].toString()==""?"null":RateData[i]["prate"].toString(),
          "s.rate":RateData[i]["srate"].toString()==""?"null":RateData[i]["srate"].toString(),
          "unit_id":RateData[i]["unitId"].toString()==""?"null":RateData[i]["unitId"],
          "unit_Name":RateData[i]["description"].toString()==""?"null":RateData[i]["description"].toString(),
          "mrp":RateData[i]["mrp"].toString()==""?"null":RateData[i]["mrp"].toString(),
        };

        RateList.add(EditRateData);
      }
setState(() {
  rate_tbl_visibel=true;
});
    }


  }



  BackFun(){

    Navigator.pushReplacement
      (context, MaterialPageRoute(builder: (context) => Item_Mstr_List(),));

  }


//--------------------------Barcode Reader----------------------

  void qr_Barcode_Readfunction() async {
    try {
      print("in qr_Barcode_Readfunction ");
      var result = await BarcodeScanner.scan();
      // print("type");
      // print(result.type);
      // print("rawContent");
      // print(result.rawContent);
      // print("format");
      // print(result.format);
      // print("formatNote");
      // print(result.formatNote);

      print(result.formatNote);
      setState(() {
        BarCode_Controller.text=result.rawContent.toString();
      });
    }
    catch(e) {  print("Error on qr_Barcode_Readfunction $e");}

  }




//-----------------------tab part-----------------------------
  var TabList=["Tax","Rate","Stock","Other","More",];
  var TabListIcon=[Icons.assignment_outlined,
    Icons.attach_money,
    Icons.local_shipping,
    Icons.pending_actions,
    Icons.pending,];


  ///------------------------Functions end-----------------------------




  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
          child: Scaffold(
            // backgroundColor: Colors.red,
             resizeToAvoidBottomInset: true,
              appBar: PreferredSize(
                  child: Appbarcustomwidget(
                      uname: userName,
                      branch: branchName,
                      pref: pref,
                      title: "Item Master"),
                  preferredSize: Size.fromHeight(80)),
              body: WillPopScope(
                onWillPop:() {
                  return BackFun();
                },
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    //-------------------item name-----------------
                    // FocusScope.of(context).unfocus(); //for remove keyboard
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TypeAheadField(
                          textFieldConfiguration:
                          TextFieldConfiguration(
onTap: (){
  GetItem();
},
                          onChanged: (a){
                            if(Button_Name=="Save"){
                              setState(() {
                                Print_CaptionrController.text= ItemNameController.text;

                                if(ItmLst.map((e) => e.itmName.trim().toLowerCase())
                                    .contains(a.toString().trim().toLowerCase())) {
                                  // print(" in");
                                  setState(() {
                                    ItemName_Select = true;
                                  });
                                }
                                else{
                                  setState(() {
                                    ItemName_Select=false;
                                    Print_CaptionrController.text= ItemNameController.text;

                                    // print("noo");
                                  });
                                }
                              });
                            }
                                } ,
                              style: TextStyle(),
                              controller:
                              ItemNameController,
                              decoration: InputDecoration(
                                errorStyle: TextStyle(
                                    color: Colors.red),
                                errorText: ItemName_Select
                                    ? "Item already exist ?"
                                    : null,
//                            errorText: _validateName ? "please enter name" : null,
//                            errorBorder:InputBorder.none ,
                                suffixIcon: IconButton(
                                  icon: Icon(Icons
                                      .remove_circle),
                                  color: Colors.blue,
                                  onPressed: () {
                                    setState(() {
                                      print("cleared");
                                      ItemNameController.text = "";
                                    });
                                  },
                                ),

                                isDense: true,
                                contentPadding:
                                EdgeInsets.fromLTRB(
                                    20.0,
                                    10.0,
                                    20.0,
                                    10.0),
                                border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                        10.0)),
                                labelText: 'Item Name',
                              )),
                          suggestionsBoxDecoration:
                          SuggestionsBoxDecoration(
                              elevation: 90.0),
                          suggestionsCallback: (pattern) {
                            return ItmLst.where((user) =>
                                user.itmName.trim().toUpperCase().contains(
                                    pattern.trim().toUpperCase()));
                          },
                          itemBuilder: (context, suggestion) {
                            return Card(
                              margin: EdgeInsets.only(
                                  top: 2, right: 2, left: 2),
                              color:theam.DropDownClr,
                              child: ListTile(
                                // focusColor: Colors.blue,
                                // hoverColor: Colors.red,
                                title: Text(
                                  suggestion.itmName,
                                  style: TextStyle(
                                      color: Colors.white),
                                ),
                              ),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            print(suggestion.itmName);
                            print("selected");
                            setState(() {
                              ItemName_Select = true;
                            });
                            print(json.encode(suggestion).toString());
                            var itm_data =jsonEncode(suggestion);
                            setState(() {
                              ItemNameController.text =
                                  (suggestion.itmName).toString();

                            });

                            print("...........");
                          },
                          errorBuilder: (BuildContext context,
                              Object? error) =>
                              Text('$error',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .errorColor)),
                          transitionBuilder: (context,
                              suggestionsBox,
                              animationController) =>
                              FadeTransition(
                                child: suggestionsBox,
                                opacity: CurvedAnimation(
                                    parent:
                                    animationController!,
                                    curve: Curves.elasticIn),
                              )),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                                child: cw.CUTestbox(
                                    label: "Bar Code", controllerName: BarCode_Controller)),
                          ),
                          IconButton(icon: Icon(Icons.qr_code), onPressed: (){

                            qr_Barcode_Readfunction();
                          })
                        ],
                      ),
                    ),




                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                      child:

                      Container(
                          child:
                          TextFormField(
                            // inputFormatters: <TextInputFormatter>[
                            //
                            // ],
                            textDirection: TextDirection.rtl,
                            style: TextStyle(fontSize: 15),
                            //showCursor: true,
                            controller: Arabic_Name_Controller,
                            cursorColor: Colors.black,

                            scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(TextBoxCurve)),

                              hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                              labelText: "Arabic Name",
                            ),
                          )
                      ),
                    ),

                    Row(
                      children: [
                        Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                              child: Container(
                                  child:
                                  TextFormField(
                                    style: TextStyle(fontSize: 15),
                                    //showCursor: true,
                                    controller: Print_CaptionrController,
                                    cursorColor: Colors.black,

                                    scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                                    onTap: () {
                                      setState(() {
                                        Print_CaptionrController.text= ItemNameController.text;

                                      });
                                    },
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(TextBoxCurve)),

                                      hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                                      labelText: "Print Caption",
                                    ),
                                  )
                                  // cw.CUTestbox(
                                  //     label: "Print Caption",
                                  //     controllerName: Print_CaptionrController)
                              ),
                            )),
                        Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                              child: Container(
                                  child: cw.CUTestbox(
                                      label: "HSN",
                                      controllerName: Hsn_Controller)),
                            )),
                      ],
                    ),

                    //------------------item grp--------------
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                      child: TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                            controller:Item_Grp_Controller ,
                            style: TextStyle(),
                            decoration: InputDecoration(
                              errorStyle: TextStyle(color: Colors.red),
                              errorText: Item_Grp_Select
                                  ? "Invalid Group Selected"
                                  : null,
                              suffixIcon: IconButton(
                                icon: Icon(Icons.remove_circle),
                                color: Colors.blue,
                                onPressed: () {
                                  setState(() {
                                    print("cleared");
                                    Item_Grp_Controller.text = "";
                                    //  salesPaymentId = 0;
                                  });
                                },
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 16.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(TextBoxCurve)),

                              hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                              labelText: "Item Group",
                            ),
                          ),

                          suggestionsBoxDecoration:
                          SuggestionsBoxDecoration(elevation: 90.0),
                          suggestionsCallback: (pattern) {
//                        print(payment);
                            return ItmGrp.where((unt) => unt.igDescription.trim().toLowerCase().contains(pattern.trim().toLowerCase()));
                          },
                          itemBuilder: (context, suggestion) {
                            return Card(
                              margin: EdgeInsets.all(2),
                              color:Colors.white,
                              child: ListTile(tileColor:theam.DropDownClr,
                                title: Text(
                                  suggestion.igDescription,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            print(suggestion.igDescription);
                            print("Grp selected");

                            Item_Grp_Controller.text = suggestion.igDescription;
                            print("close.... $Item_Grp_Id");
                            Item_Grp_Id = 0;

                            print(suggestion.id);
                            print(".......GrpId id");
                            Item_Grp_Id = suggestion.id;
                            print(Item_Grp_Id);
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


               ///----------------------------------tab part----------------------------------
               Container(
                 width: MediaQuery.of(context).size.width,
                 height: 50,
                 color: Colors.pink.shade200,
                child:ListView.builder(
                  scrollDirection: Axis.horizontal,

                  itemCount: TabList.length,
                  itemBuilder:(context, index) =>
                      SizedBox(width: MediaQuery.of(context).size.width/5,
                          child: InkWell(onTap: (){
                            setState(() {
                              print(index.toString());
                              Tabindex= index;

                            });

                          },
                            child: Column(mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(TabListIcon[index],color:Tabindex == index? Colors.white:Colors.black87,),
                                Center(
                                    child:
                                    Text(TabList[index],style: TextStyle(fontWeight: FontWeight.bold,
                                    color:Tabindex == index? Colors.white:Colors.black87,fontSize: 16),)),
                              ],
                            ),
                          ),

                      ),)
               ),

                      Container(child:SelectedTab(Tabindex),)


                  ],
                ),
              ),


//---------------------button tab row---------------------------------------------
              bottomNavigationBar: Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(4, 4, 2, 4),
                        child: cw.CUButton(
                            name: Button_Name,
                            H: 50,
                            function: () {
                              Validation_SaveAll();
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
                              name: "Back",
                              H: 50,
                              function: () {
                                BackFun();
                              },
                              Labelstyl: TextStyle(
                                fontSize: 30,
                                  color: Colors.white
                              ),
                              color: Colors.indigo),
                        ))
                  ],
                ),
              ) ),

        ));
  }


Color SelectTabClr=Colors.white;
int Tabindex=0;

SelectedTab(a){

  switch(a.toString()) {
    case "0": {
     return Taxpage();
    }
    break;

    case "1": {
      return  Ratepage();
    }
    break;

    case "2": {
      return  Stockpage();
    }
    break;
    case "3": {
      return   OtherDtlpage();
    }
    break;

    case "4": {
      return  MoreDtlpage();
    }
    break;

    // case "5": {
    //   return   Ratepage();
    // }
    // break;

    default: {
      Ratepage();
    }
    break;
  }

}

  ///------------------Tax page----------------------------------

  Widget Taxpage() {
    return Column(
      //physics: ScrollPhysics(),
      children: [
        SizedBox(
          height: 10,
        ),


        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 2),
          child: TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                onTap: (){
                  GetTax();
                  },
                controller: Pur_Tax_Controller,
                style: TextStyle(),
                decoration: InputDecoration(
                  // errorStyle: TextStyle(color: Colors.red),
                  // errorText: Prod_typ_Select ? "Invalid Group Selected" : null,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.remove_circle),
                    color: Colors.blue,
                    onPressed: () {
                      setState(() {
                        print("cleared");
                        Pur_Tax_Controller.text = "";
                        //  salesPaymentId = 0;
                      });
                    },
                  ),

                  prefixIcon: IconButton(
                    icon: Icon(Icons.add_circle),
                    color: Colors.blue,
                    onPressed: () {
                      setState(() {
                        FocusScope.of(context).unfocus();
                        print("Add Tax");
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Tax_Master()));

                      });
                    },
                  ),

                  isDense: true,
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 16.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(TextBoxCurve)),
                  hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                  labelText: "Purchase Tax",
                ),
              ),
              suggestionsBoxDecoration:
              SuggestionsBoxDecoration(elevation: 90.0),
              suggestionsCallback: (pattern) {
                //print(prodtyp);
                return taxlist.where((dd) => dd.txDescription.trim().toLowerCase().contains(pattern.trim().toLowerCase()));
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
                          suggestion.txDescription,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
              onSuggestionSelected: (suggestion) {
                print(suggestion.txDescription);
                print("Pur Tax type selected");

                Pur_Tax_Controller.text = suggestion.txDescription;
                print("close.... $Pur_Tax_Id");
                Pur_Tax_Id = 0;

                print(suggestion.txId);
                print(".......Pur_Tax_Id id");
                Pur_Tax_Id = suggestion.txId;
                print(Pur_Tax_Id);
                print("...........");
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
                  )),
        ),

        Row(
          children: [
            Text("     Inclusive"),
            Checkbox(
              checkColor: Colors.white,
              // fillColor:Colors.red,
              value: Pur_Tax_Inclusive,
              onChanged: (value) {
                setState(() {
                  Pur_Tax_Inclusive = !Pur_Tax_Inclusive;
                  print("Pur_Tax_Inclusive "+Pur_Tax_Inclusive.toString());
                });
              },
            ),
          ],
        ),


        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 2),
          child: TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                onTap: (){
                  GetTax();
                },
                controller: Sale_Tax_Controller,
                style: TextStyle(),
                decoration: InputDecoration(
                  // errorStyle: TextStyle(color: Colors.red),
                  // errorText: Prod_typ_Select ? "Invalid Group Selected" : null,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.remove_circle),
                    color: Colors.blue,
                    onPressed: () {
                      setState(() {
                        print("cleared");
                        Sale_Tax_Controller.text = "";
                        //  salesPaymentId = 0;
                      });
                    },
                  ),

                  prefixIcon: IconButton(
                    icon: Icon(Icons.add_circle),
                    color: Colors.blue,
                    onPressed: () {
                      setState(() {
                        FocusScope.of(context).unfocus();
                        print("Add Tax");
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Tax_Master()));

                      });
                    },
                  ),

                  isDense: true,
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 16.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(TextBoxCurve)),
                  hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                  labelText: "Sales Tax",
                ),
              ),
              suggestionsBoxDecoration:
              SuggestionsBoxDecoration(elevation: 90.0),
              suggestionsCallback: (pattern) {
                //print(prodtyp);
                return taxlist.where((dd) => dd.txDescription.trim().toLowerCase().contains(pattern.trim().toLowerCase()));
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
                          suggestion.txDescription,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
              onSuggestionSelected: (suggestion) {
                print(suggestion.txDescription);
                print("Sales  Tax type selected");

                Sale_Tax_Controller.text = suggestion.txDescription;
                print("close.... $Sale_Tax_Id");
                Sale_Tax_Id = 0;

                print(suggestion.txId);
                print(".......Sale_Tax_Id id");
                Sale_Tax_Id = suggestion.txId;
                print(Sale_Tax_Id);
                print("...........");
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
                  )),
        ),


        Row(children: [ Text("    Inclusive"),
          Checkbox(
            checkColor: Colors.white,
            // fillColor:Colors.red,
            value:Sales_Tax_Inclusive,
            onChanged: (value) {
              setState(() {
                Sales_Tax_Inclusive = !Sales_Tax_Inclusive;
                print("Sales_Tax_Inclusive  "+Sales_Tax_Inclusive.toString());
              });
            },
          ),],),
        SizedBox(
          height: 50,
        ),
      ],
    );
  }




///------------------Rate page----------------------------------

  Widget Ratepage() {


    // AddRate() {
    //  print("AddRate");
    //   rtlst={
    //     "id":rowid+1,
    //    "p.rate":PRate_Controller.text==""?null:PRate_Controller.text,
    //     "s.rate":SRate_Controller.text==""?null:SRate_Controller.text,
    //    "unit_id":UnitId,
    //    "unit_Name":Unit_Controller.text==""?null:Unit_Controller.text,
    //    "mrp":Mrp_Controller.text==""?null:Mrp_Controller.text,
    //  };

    //  print(rtlst.toString());
    //  setState(() {
    //    RateList.add(rtlst);
    //    rate_tbl_visibel=true;
    //    SRate_Controller.text = "";
    //    PRate_Controller.text = "";
    //    Unit_Controller.text = "";
    //    Mrp_Controller.text = "";
    //    UnitId=null;
    //  });
    //
    //  print(RateList.toString());
    //  print("RateList");
    // }



   // EditRate(data){
   //
   //    print(data["id"]);
   //    print(data["p.rate"]);
   //    print(data["s.rate"]);
   //    print(data["unit_id"]);
   //    print(data["unit_Name"]);
   //    print(data["mrp"]);
   //
   //    setState(() {
   //
   //      SRate_Controller.text = data["s.rate"]??"".toString();
   //      PRate_Controller.text = data["p.rate"]??"".toString();
   //      Unit_Controller.text = data["unit_Name"]??"".toString();
   //      Mrp_Controller.text =data["mrp"]??"".toString();
   //      UnitId=data["unit_id"];
   //      RateEdit_Id=data["id"];
   //    });
   // }


//    SaveEditRate(){
//  print(RateEdit_Id.toString());
// setState(() {
// //  AddEditIcon= Icon(Icons.add_circle_outline);
//   RateList.removeWhere((element) => element["id"]==RateEdit_Id);
//   rtlst={
//     "id":rowid+1,
//     "p.rate":PRate_Controller.text==""?null:PRate_Controller.text,
//     "s.rate":SRate_Controller.text==""?null:SRate_Controller.text,
//     "unit_id":UnitId,
//     "unit_Name":Unit_Controller.text==""?null:Unit_Controller.text,
//     "mrp":Mrp_Controller.text==""?null:Mrp_Controller.text,
//   };

//   print(rtlst.toString());
//   setState(() {
//     RateList.add(rtlst);
//     rate_tbl_visibel=true;
//     SRate_Controller.text = "";
//     PRate_Controller.text = "";
//     Unit_Controller.text = "";
//     Mrp_Controller.text = "";
//     UnitId=null;
//   });
//
//   print(RateList.toString());
//   print("RateList");
//
//
//
//
// });
//    }
//
//      Validation_Rate(Save_edit) {
//        if (Unit_Controller.text == "" || UnitId == null) {
//          setState(() {
//            Unit_Select = true;
//          });
//        } else {
//          setState(() {
//            Unit_Select = false;
//            SaveEditRate();
//            //Save_edit == "Icon(IconData(U+0E570))" ? AddRate() : SaveEditRate();
//          });
//        }
//      }


    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
          child: Container(
              child: cw.CUTestbox(
                  label: "P.Rate", controllerName: PRate_Controller,
                TextInputFormatter:<TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
                TextInputType: TextInputType.number
              )),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
          child: Container(
              child: cw.CUTestbox(
                  label: "S.Rate", controllerName: SRate_Controller,
                  TextInputFormatter:<TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
                  TextInputType: TextInputType.number
              )),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
          child: TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                onTap:() {
                  GetUnit();
                },
                controller: Unit_Controller,
                style: TextStyle(),
                decoration: InputDecoration(
                  errorStyle: TextStyle(color: Colors.red),
                  errorText: Unit_Select ? "Invalid Unit Selected" : null,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.remove_circle),
                    color: Colors.blue,
                    onPressed: () {
                      setState(() {
                        print("cleared");
                        Unit_Controller.text = "";
                        //  salesPaymentId = 0;
                      });
                    },
                  ),
                  prefixIcon: IconButton(
                    icon: Icon(Icons.add_circle),
                    color: Colors.blue,
                    onPressed: () {
                      //
                      setState(() {
                        print("Add");
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (c) {
                              return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(width: 1),
                                          borderRadius: BorderRadius.circular(
                                              20),
                                        ),
                                        title: Center(child: Text("Create Unit")),
                                        content: Container(
                                            height: 360,
                                            width: 400,
                                            child:
                                            Create_Unit(UnitList:unit,
                                              Height: 350.0,Wedth: 400.0,
                                              Token: token,
                                              visibility:false,
                                              deviceId:DeviceId,
                                            )),
                                    );
                                  });
                            });

                            FocusScope.of(context).unfocus();
                        //for remove keyboard
                      });
                    },
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 16.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(TextBoxCurve)),
                  hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                  labelText: "Unit",
                ),
              ),
              suggestionsBoxDecoration:
              SuggestionsBoxDecoration(elevation: 90.0),
              suggestionsCallback: (pattern) {
                        print(unit.runtimeType.toString());
                return unit.where((unt) => unt.description.trim().toLowerCase().contains(pattern.trim().toLowerCase()));
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
                          suggestion.description,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
              onSuggestionSelected: (suggestion) {
                print(suggestion.description);
                print("unit selected");

                Unit_Controller.text = suggestion.description;
                print("close.... $UnitId");
                UnitId = null;

                print(suggestion.id);
                print(".......GrpId id");
                UnitId = suggestion.id;
                print(UnitId);
                print("...........");
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
                  )),
        ),


        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: Container(
                    child:
                    cw.CUTestbox(label: "MRP", controllerName: Mrp_Controller,
                        TextInputFormatter:<TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
                        TextInputType: TextInputType.number
                    )),
              ),
            ),
            // IconButton(icon: AddEditIcon,iconSize: 35 ,onPressed: (){
            //
            //   Validation_Rate(AddEditIcon.toString());
            //
            // }),

          ],
        ),


        Visibility(
             visible:rate_tbl_visibel,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  showCheckboxColumn: false,
                  columnSpacing: 18,
                  onSelectAll: (b) {},
                  sortAscending: true,
                  columns: <DataColumn>[
                    DataColumn(
                      label: Text('UOM'),
                    ),
                    DataColumn(
                      label: Text('P.Rate'),
                    ),
                    DataColumn(
                      label: Text('S.Rate'),
                    ),
                    DataColumn(
                      label: Text('MRP'),
                    ),
                    DataColumn(
                      label: Text(''),
                    ),
                  ],
                  rows: RateList.map(
                    (itemRow) => DataRow(
                      onSelectChanged: (a) {
                        print("itemRow.toString()");
                      },
                      cells: [
                        DataCell(
                          Text(itemRow["unit_Name"]??"".toString()),
                          showEditIcon: false,
                          placeholder: false,
                        ),
                        DataCell(
                          Text(itemRow["p.rate"].toString()??"".toString()),
                          showEditIcon: false,
                          placeholder: false,
                        ),
                        DataCell(
                          Text(itemRow["s.rate"].toString()??""),
                          showEditIcon: false,
                          placeholder: false,
                        ),
                        DataCell(
                          Text(itemRow["mrp"].toString()??""),
                          showEditIcon: false,
                          placeholder: false,
                        ),
                        DataCell(
                          PopupMenuButton<int>(
                            onSelected: (a) {
                              print("saf $a");
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            color: Colors.black,
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                height: 30,
                                child: Container(
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                          print("edit $itemRow");
                                          setState(() {
                                           // AddEditIcon=Icon(Icons.edit);
                                          //  EditRate(itemRow);
                                          });

                                          //  Edit(itemRow);
                                        },
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                          print("delete");


                                          setState(() {
                                            RateList.removeWhere((element) => element["id"]==itemRow["id"]);
                                            print(RateList.length.toString());
                                            if(RateList.length<=0){

                                              rate_tbl_visibel=false;
                                            }
                                          });

                                        },
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                            icon: Icon(Icons.more_horiz),
                            //offset: Offset()
                          ),
                          showEditIcon: false,
                          placeholder: false,
                        ),
                      ],
                    ),
                  ).toList(),
                ),
              ),
            )),
        SizedBox(
          height: 50,
        ),
      ],
    );
  }





///------------------Stock page----------------------------------

  Widget Stockpage() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
          child: TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: Stk_typ_Controller,
                style: TextStyle(),
                decoration: InputDecoration(
                  errorStyle: TextStyle(color: Colors.red),
                  errorText: Stk_typ_Select ? "Invalid Stock Type Selected" : null,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.remove_circle),
                    color: Colors.blue,
                    onPressed: () {
                      setState(() {
                        print("cleared");
                        Stk_typ_Controller.text = "";
                        //  salesPaymentId = 0;
                      });
                    },
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 16.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(TextBoxCurve)),
                  hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                  labelText: "Stock Type",
                ),
              ),
              suggestionsBoxDecoration:
              SuggestionsBoxDecoration(elevation: 90.0),
              suggestionsCallback: (pattern) {
                print(sttyp);
                return sttyp.where((dd) => dd.stockType.trim().toLowerCase().contains(pattern.trim().toLowerCase()));
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
                          suggestion.stockType,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
              onSuggestionSelected: (suggestion) {
                print(suggestion.stockType);
                print("unit selected");

                Stk_typ_Controller.text = suggestion.stockType;
                print("close.... $Stk_typ_Id");
                Stk_typ_Id = null;

                print(suggestion.id);
                print(".......Stk_typ_Id id");
                Stk_typ_Id = suggestion.id;
                print(Stk_typ_Id);
                print("...........");
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
                  )),
        ),


        Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
          child: TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: Prod_typ_Controller,
                style: TextStyle(),
                decoration: InputDecoration(
                  errorStyle: TextStyle(color: Colors.red),
                  errorText: Prod_typ_Select ? "Invalid Product Type Selected" : null,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.remove_circle),
                    color: Colors.blue,
                    onPressed: () {
                      setState(() {
                        print("cleared");
                        Prod_typ_Controller.text = "";
                        //  salesPaymentId = 0;
                      });
                    },
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 16.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(TextBoxCurve)),
                  hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                  labelText: "Prodect Type",
                ),
              ),
              suggestionsBoxDecoration:
              SuggestionsBoxDecoration(elevation: 90.0),
              suggestionsCallback: (pattern) {
                //print(prodtyp);
                return prodtyp.where((dd) => dd.productType.trim().toLowerCase().contains(pattern.trim().toLowerCase()));
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
                          suggestion.productType,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
              onSuggestionSelected: (suggestion) {
                print(suggestion.productType);
                print("products type selected");

                Prod_typ_Controller.text = suggestion.productType;
                print("close.... $Prod_typ_Id");
                Prod_typ_Id = null;

                print(suggestion.id);
                print(".......Prod_typ id");
                Prod_typ_Id = suggestion.id;
                print(Prod_typ_Id);
                print("...........");
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
                  )),
        ),





        Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
          child: Container(
              child: cw.CUTestbox(
                  label: "O.P.Stock", controllerName: Opn_Stk_Controller)),
        ),

        SizedBox(
          height: 70,
        ),
      ],
    );
  }





  ///------------------Other Details page----------------------------------

  Widget OtherDtlpage() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
          child: Container(
              child: cw.CUTestbox(
                  label: "Item Code", controllerName: Itm_code_Controller)),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
          child: Container(
              child: cw.CUTestbox(
                  label: "Display Order",
                  controllerName: Display_Order_Controller)),
        ),
        SizedBox(
          height: 50,
        ),
      ],
    );
  }





  ///------------------More Details page----------------------------------

  Widget MoreDtlpage() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: Container(
                    child: cw.CUTestbox(
                        label: "Specifications", controllerName: Specifications_Controller)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: Container(
                    child: cw.CUTestbox(
                        label: "Model", controllerName: Model_Controller)),
              ),
            ),
          ],
        ),

        Row(
          children: [


            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                      onTap:() {
                        GetBrand();
                      },
                      controller: Brand_Controller,
                      style: TextStyle(),
                      decoration: InputDecoration(
                        // errorStyle: TextStyle(color: Colors.red),
                        // errorText: Unit_Select ? "Invalid Unit Selected" : null,
                        suffixIcon: IconButton(
                          icon: Icon(Icons.remove_circle),
                          color: Colors.blue,
                          onPressed: () {
                            setState(() {
                              print("cleared");
                              Brand_Controller.text = "";
                              //  salesPaymentId = 0;
                            });
                          },
                        ),
                        prefixIcon: IconButton(
                          icon: Icon(Icons.add_circle),
                          color: Colors.blue,
                          onPressed: () {
                            //
                            setState(() {
                              print("Add");
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (c) {
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(width: 1),
                                              borderRadius: BorderRadius.circular(
                                                  20),
                                            ),
                                            title: Center(child: Text("Create Brand")),
                                            content: Container(
                                                height: 360,
                                                width: 400,
                                                child:
                                                Create_Brand(height: 350,
                                                    width: 400,token: token,device_id: DeviceId,branchId: branchId,
                                                 userId: userId, TblShow: false,)),

                                            // Create_Brand(data: data,height: h,width: w),
                                          );
                                        });
                                  });

                              FocusScope.of(context).unfocus();
                              //for remove keyboard
                            });
                          },
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 16.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(TextBoxCurve)),
                        hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                        labelText: "Brand",
                      ),
                    ),
                    suggestionsBoxDecoration:
                    SuggestionsBoxDecoration(elevation: 90.0),
                    suggestionsCallback: (pattern) {
                      return BrandList.where((unt) => unt["brndDescription"].trim().toLowerCase().contains(pattern.trim().toLowerCase()));
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
                                suggestion["brndDescription"],
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      print(suggestion["brndDescription"]);
                      print("Brand selected");

                      Brand_Controller.text = suggestion["brndDescription"];
                      print("close.... $Brand_Id");
                      Brand_Id = 0;

                      print(suggestion["brndId"]);
                      print(".......Brand id");
                      Brand_Id = suggestion["brndId"];
                      print(Brand_Id);
                      print("...........");
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
                        )),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                      onTap:() {
                        GetManufacturer();
                      },
                      controller: Manufacturer_Controller,
                      style: TextStyle(),
                      decoration: InputDecoration(
                        // errorStyle: TextStyle(color: Colors.red),
                        // errorText: Unit_Select ? "Invalid Unit Selected" : null,
                        suffixIcon: IconButton(
                          icon: Icon(Icons.remove_circle),
                          color: Colors.blue,
                          onPressed: () {
                            setState(() {
                              print("cleared");
                              Manufacturer_Controller.text = "";
                              //  salesPaymentId = 0;
                            });
                          },
                        ),
                        prefixIcon: IconButton(
                          icon: Icon(Icons.add_circle),
                          color: Colors.blue,
                          onPressed: () {
                            //
                            setState(() {
                              print("Add");
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (c) {
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(width: 1),
                                              borderRadius: BorderRadius.circular(
                                                  20),
                                            ),
                                            title: Center(child: Text("Create Manufacturer")),
                                            content: Container(
                                                height: 360,
                                                width: 400,
                                                child:Create_Manufacturer(height: 350,
                                                  width: 400,
                                                  token: token,
                                                  device_id: DeviceId,
                                                  branch_Id:branchId,User_id: userId,
                                                  TblShow: false,
                                                )),

                                            // Create_Unit(UnitList:unit,
                                            //   Height: 350.0,Wedth: 400.0,
                                            //   Token: token,
                                            //   visibility:false,
                                            //   deviceId:DeviceId,
                                            // )),
                                          );
                                        });
                                  });

                              FocusScope.of(context).unfocus();
                              //for remove keyboard
                            });
                          },
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 16.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(TextBoxCurve)),
                        hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                        labelText: "Manufacturer",
                      ),
                    ),
                    suggestionsBoxDecoration:
                    SuggestionsBoxDecoration(elevation: 90.0),
                    suggestionsCallback: (pattern) {
                      return ManufacturerList.where((unt) => unt["mfrDescription"].trim().toLowerCase().contains(pattern.trim().toLowerCase()));
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
                                suggestion["mfrDescription"],
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      print(suggestion["mfrDescription"]);
                      print("Manufacturer selected");

                      Manufacturer_Controller.text = suggestion["mfrDescription"];
                      print("close.... $Manufacturer_Id");
                      Manufacturer_Id = 0;

                      print(suggestion["mfrId"]);
                      print(".......Manufacturer id");
                      Manufacturer_Id = suggestion["mfrId"];
                      print(Manufacturer_Id);
                      print("...........");
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
                        )),
              ),
            ),
          ],
        ),



        Row(
          children: [

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: Container(
                    child: cw.CUTestbox(
                        label: "Monthly Target", controllerName: Monthly_Target_Controller )),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: Container(
                    child:


                    TextFormField(
                      inputFormatters:  <TextInputFormatter>[
                         FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}")),
                            ],
                      style: TextStyle(fontSize: 15),
                      //showCursor: true,
                      controller: Warranty_Controller,
                      cursorColor: Colors.black,

                      scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                      keyboardType: TextInputType.number,
                      onTap: () async {

                      },
                      decoration: InputDecoration(
                        // errorStyle: TextStyle(color: Colors.red),
                        // errorText: errorcontroller == true ? "invalid " : null,
                        suffix: Container(child: Text("Days ",style: TextStyle(color: Colors.red),)),
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(TextBoxCurve)),
                        hintText: "Number",
                        hintStyle: TextStyle(color: Colors.blueAccent, fontSize: 15),
                        labelText: "Warranty",
                      ),
                    )


                ),
              ),
            ),
          ],
        ),







        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: Container(
                    child: cw.CUTestbox(
                        label: "ROL", controllerName: ROL_Controller)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: Container(
                    child: cw.CUTestbox(
                        label: "ROQ", controllerName: ROQ_Controller,
                    )),
              ),
            ),
          ],
        ),



        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: Container(
                    child: cw.CUTestbox(
                        label: "Maximum Qty", controllerName:Maximum_Qty_Controller )),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: Container(
                    child: cw.CUTestbox(
                        label: "Minimum Qty", controllerName: Minimum_Qty_Controller)),
              ),
            ),
          ],
        ),

        Row(
          children: [

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: Container(

                  child:    TextFormField(
                    style: TextStyle(fontSize: 15),
                    //showCursor: true,
                    controller: Description_Controller,
                    cursorColor: Colors.black,

                    scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                    keyboardType: TextInputType.text,
                    maxLines: null,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(TextBoxCurve)),
                      hintText: "",
                      hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                      labelText: "Description",
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 50,
        ),
      ],
    );
  }





}






