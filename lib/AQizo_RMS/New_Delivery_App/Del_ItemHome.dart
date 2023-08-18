
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:flutter/material.dart' ;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:path_provider/path_provider.dart';

import '../../GT_Masters/AppTheam.dart';
import '../../GT_Masters/Masters_UI/cuWidgets.dart';
import '../../login.dart';
import '../../models/customersearch.dart';
import '../../models/userdata.dart';
import '../../urlEnvironment/urlEnvironment.dart';
import '../RMS_Print/RMS_SimPrint.dart';
import 'Customer_Details.dart';
import 'Del_ItemAddOn.dart';
import 'Del_Model/Del_Model_AddonItms.dart';
import 'Del_View_And_Print_PerBill.dart';

class Del_ItemHome extends StatefulWidget {
  @override
  _Del_ItemHomeState createState() => _Del_ItemHomeState();
}

class _Del_ItemHomeState extends State<Del_ItemHome> {
//-----------------------------------------
  late SharedPreferences pref;
  late ItmBillDetails ItmBLdata;
  late Del_Tabledata TDdata;
  dynamic branch;
  //var res;
  dynamic user;
  late int branchId;
  bool discount=false;
  var discper=0.00;
  bool discact= false;
  late int userId;
  late UserData userData;
  String branchName = "";
  dynamic userName;
  late String token;
  dynamic total = 0;
  int slnum = 0;
  String dateNow = DateFormat("yyyy-MM-dd").format(DateTime.now());
  dynamic TotalAmt = 0.00;
  dynamic TotalTaxAmt = 0.00;
  String PaymentName = ""; //for Add payment type name in heding
//----------------------------------
  dynamic btnItmGrp = [];
  dynamic btnItmLst = [];
  bool grp_Inputbox_Vsbl =
  false; // for hide and show Item Grp Search InputText box
  bool itm_Inputbox_Vsbl =
  false; // for hide and show Item  Search InputText box
  bool listabledataShow = false;
  dynamic itemname = "";

  bool showAddonItems=false;


  bool TablenumValid = false;
  bool quantitySelect = false;
  bool PaymentPopupVisilbe = false; // for list payment types
  bool PaymentAmtPopupVisilbe = false; // display selected payment and type amt
  bool Payment_Credit_Visilbe = false; // for payment type credit visiblee
  bool Pay_Typ_OthAmt_Valid = false;
  bool Pay_Typ_Cash_Valid = false;
  bool Pay_Typ_OthAmt_TxtBx_Visible = false; // for other amout text box hide
  bool imageSetting = false; //  image or text display on button
  bool Itm_Tbl_DeleteBttn_Visible = true; // after payment completed button hide
  bool customerSelect = false;
  bool Pay_Typ_Credit_Ph_Valid = false;

  TextEditingController quantityController = new TextEditingController();
  TextEditingController TablenumController = new TextEditingController();
  TextEditingController TokennumController = new TextEditingController();
  TextEditingController ItemGrpController = new TextEditingController();
  TextEditingController ItemLstController = new TextEditingController();
  TextEditingController UomRateController = new TextEditingController();
  TextEditingController TotalAmtController = new TextEditingController();
  TextEditingController Pay_Typ_Cash_Controller = new TextEditingController();
  TextEditingController Pay_Typ_OthAmt_Controller = new TextEditingController();
  TextEditingController RoundOffController = new TextEditingController();
  TextEditingController DisPerController = new TextEditingController();
  TextEditingController DisAmtController = new TextEditingController();
  TextEditingController DiscTotalAmtController = new TextEditingController();
  TextEditingController Pay_Typ_Tota_Amt_Controller =
  new TextEditingController();
  TextEditingController OrderumController = new TextEditingController();
  TextEditingController customerController = new TextEditingController();
  TextEditingController Pay_Typ_Credit_Ph_Controller =new TextEditingController();
  TextEditingController Bill_No_Controller =new TextEditingController();
  TextEditingController ItemNotesController =new TextEditingController();
  final textController=new TextEditingController();


  TextEditingController DeliveryChargeController =new TextEditingController();

  var ItemNotes_Id = null;
  int PaymentTypID = 0;
  int customerId = 0;
  bool itemSelectvalidate = false;
  int ItemGrpId = 0;
  bool itmGrpVsbl = false;
  bool itmLstVsbl = false;
  bool Noitem = false;
  bool UomRateSelect = false;
  late List<dynamic> UomData;
  late List<dynamic> PayTypData; // get Paymet type api data
  var PayAmtTypData;
  dynamic UOM = null;
  var UomTableData = {};
  var AddonData;
  dynamic itemRate = 0.00;
  dynamic itemQty = 0;
  dynamic Token_Num = 0;
  dynamic itemTaxInOrEx;
  static List<Del_Tabledata> TD = <Del_Tabledata>[];
  static List<ItemGroup> ItmGrp = <ItemGroup>[];
  static List<ItemList> ItmLst = <ItemList>[];
  static List<Customer> users = <Customer>[];


  dynamic Customername = '';
  double itemTblHight = 300; // change  List table height

  var Pay_Typ_RoundOff = 0.00; //"
  var Pay_Typ_Disamt = 0.00; // Payment typ Calculatio
  var Pay_Typ_cash = 0.00; //"
  var Pay_Typ_Other_cash = 0.00; //"


  var KOT_Printer;
  var Bill_Counter;
  var Counter_Printer;

  bool Top_TextBox_Visible=false;
  var EditId;
  String ButtonName="Save";

  AppTheam theam =AppTheam();

  var dataForTicket;
  late double TotalAmtTaxExcl;
  var currencyName;
  var Companydata;
  var footerCaptions;
  var Item_Selected_index;
  var ItemGrp_Selected_index;
  var lockSales;
  ItemAddon AddonItem=ItemAddon();

  var BillingNote;
  Add_UserDetails Cu_Det = Add_UserDetails();


  var Item_notes=[];
  var Cust_Details=[];
  bool Payment_TypShow=false;/// for show or hide paymnet type popup
  static List<ItmBillDetails> IBD = <ItmBillDetails>[];

// Add on
  static List<Del_AddonItems> _Del_Addons = <Del_AddonItems>[];

  late Del_AddonItems Del_AddonDatas;
  void initState() {
    print("sdfdsadsfjyhg");
    setState(() {
      SharedPreferences.getInstance().then((value) {
        pref = value;
        read();
        getItemGrp();
        GetScreenSettings();
        quantityController.text = "1";
        TotalAmtController.text = "0.00";
        DiscTotalAmtController.text="0.00";
        getTokenNo();
        GetPaymentType();
        TD.clear();
        IBD.clear();
        Get_Setting();
        getCustomer();
        GetBillNum();
        GetBillingNote();
        print("init before geralsetting");
        GeneralSettings();
        print("init after geral setting");
        print("textController value" + textController.toString());
        GetFooterData();
        GetCustomer_PH();
        Get_PerviousBill_Id();

      });
    });


  }






  CUWidgets cw=CUWidgets();
//------------------for appbar------------
  var EmpId;
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
      currencyName = user.user["currencyName"];
      GetCompantPro(branchId);
      EmpId=user.user["loginedEmployeeId"];
      print("uiuiouioiuouio");
      print(EmpId);
    });
  }

  BAckButton(){
    Widget noButton = TextButton(
      child: Text("No"),
      onPressed: () {
        print("No...");
        Navigator.pop(context); // this is proper..it will only pop the dialog which is again a screen
      },
    );

    Widget yesButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        setState(() {
          exit(0);
        });
        return;
        print("Logout...");
        try {
          pref.remove('userData');
        }catch(e){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
        }

        Navigator.pop(context); //ok

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );

      },
    );
    showDialog(
        context: context,
        builder: (c) => AlertDialog(
            content: Text("Do you really want to Exit ?"),
            actions: [yesButton, noButton]));


  }
  var Customer_ph_detils=[];
  void printerIptoLocal() async{
    pref = await SharedPreferences.getInstance();
    pref.setString("printerIpCounter", PrinterIpOffline.text);
    pref.setString("printerIpKOT", PrinterIpOfflineKot.text);
    KOT_Printer = pref.getString('printerIpKOT').toString() ?? '';
  }

  TestReplace(){

    var TextTest="1234567890 1234567890 12345678901234567899";

    print("printing the test Replace" + TextTest);
    print(TextTest.toString().replaceRange(10,12,"\n"));


  }


  GetCustomer_PH()async{


    var res=await cw.CUget_With_Parm(api:"SalesCustomers",Token: token);


    print("GetCustomer_PH");
    print(res);
    if(res!=false){
      var jsonres=json.decode(res);
      print("GetCustomer_PH");
      print(jsonres);
      setState(() {
        Customer_ph_detils=jsonres;
      });

    }


  }

  Reset(){

    setState(() {
      TD.clear();
      IBD.clear();
      textController.text= "1";
      quantityController.text = "1";
      DiscTotalAmtController.text = "0.00";
      DiscTotalAmtController.text="0.00";
      DeliveryChargeController.text = "0.00";
      listabledataShow=false;
      ItemGrp_Selected_index=null;
      Item_Selected_index=null;
      ItemGrpController.text="";
      ItemLstController.text="";
      //added by hyder on reset issue
      TotalAmt = 0.00;
      TotalAmtController.text = "0.00";
      //--------------
      Get_Setting();
    });
  }

  GeneralSettings()async{

    var res=await cw.CUget_With_Parm(api:"GeneralSettings",Token: token);

    if(res!=null){
      var jsonres=json.decode(res);
      print("----ressss-----------");
      print(jsonres[0]["rmsCounterPrinter"]);

      pref = await SharedPreferences.getInstance();
      setState(() {
        discact=jsonres[0]["allowdisiscount"];
        discper=jsonres[0]["discountpercentage"];
        print("sasdfd " + discact.toString());
          print("sdfsadfas " + discper.toString());
        print("the prinjjter ip is " + pref.getString('printerIpCounter').toString());
        print("the enableLocalPrinteris " + jsonres[0]["enableLocalPrinter"].toString());
        if(jsonres[0]["enableLocalPrinter"]==true){
        Counter_Printer = pref.getString('printerIpCounter').toString() ?? '';
        print("the Counter_Printer value is " + Counter_Printer.toString());
        KOT_Printer = pref.getString('printerIpKOT').toString() ?? '';
        print("the KOT_Printer value is " + KOT_Printer.toString());
        }
        else{
          if(jsonres[0]["enableMakeorderRms"]==true){
           KOT_Printer=jsonres[0]["rmsKotPrinter"];
            // KOT_Printer="192.168.0.100";
            Counter_Printer=jsonres[0]["rmsCounterPrinter"];
            // Counter_Printer="192.168.0.100";
            Bill_Counter=jsonres[0]["billCounter"];
            print("Billxount" + Bill_Counter.toString());
            textController.text=Bill_Counter.toString();
          }
          else{
            print("kot printer value" + jsonres[0]["rmsKotPrinter"]);


           KOT_Printer=jsonres[0]["rmsKotPrinter"];
            // KOT_Printer="192.168.0.100";


            Counter_Printer=jsonres[0]["rmsCounterPrinter"];
            // Counter_Printer="192.168.0.100";
            Bill_Counter=jsonres[0]["billCounter"];
            textController.text=Bill_Counter.toString();
          }

        }








      });
    }
  }




  GetBillingNote()async {
    var res = await cw.CUget_With_Parm(api: "BillingNoteMasters", Token: token);

    if (res != false) {
      var resData = json.decode(res);
      setState(() {
        print("resData");
        print(resData);
        var s=[];
        s=resData;
        final _results = s.where((product) => product["isActive"].toString() == "true").toList();

        print(_results.toString());

        print("_results");
        print(_results);

        BillingNote=_results;

        print(BillingNote);
      });
    }
  }



  var BillNumber;
  GetBillNum()async{
    var res =await cw.CUget_With_Parm(api: "getsettings/1/gtsales",Token: token);
    if(res!=false){
      var resData=json.decode(res);
      setState(() {

        BillNumber=resData[0]["vocherNo"].toString();
        print("voucher number hyd" + BillNumber );
      });
      setState(() {
      });
    }
  }

  //-----Table no-----------------
  getItemIndex(dynamic item) {
    var index = TD.indexOf(item);
    return index + 1;
  }

  removeListElement(sl, totl,addonRate) {
    print(totl);
    TD.removeWhere((element) => element.ItemSlNo == sl);
    IBD.removeWhere((element) => element.ItemSlNo == sl);
    TotalAmt = TotalAmt - (totl+addonRate);
    var delAmt=DeliveryChargeController.text==""?"0":DeliveryChargeController.text;
    print("totalamttype");
    print(TotalAmt);
    print(double.parse(delAmt).toStringAsFixed(3));

    if(discact==true){
      DiscTotalAmtController.text =  ((TotalAmt - ((TotalAmt* discper)/100.00))  +  double.parse(delAmt)).toStringAsFixed(3);
    }

      TotalAmtController.text = (TotalAmt +double.parse(delAmt)).toStringAsFixed(3);



    if (TD.isEmpty) {
      listabledataShow = false;
      TotalAmt = 0;
      TotalTaxAmt=0;
      TotalAmtController.text = "0.00";
      DiscTotalAmtController.text="0.00";
      slnum = 0;
    }
  }

//----------------------getCustomer-----------------------------------------
  getCustomer() async {
    try {
      final response = await http.get("${Env.baseUrl}MLedgerHeads" as Uri, headers: {
        "Authorization": user.user["token"],
      });
      print(response.statusCode);

      print('...................');
      print(json.decode(response.body));
      var data = json.decode(response.body);

      List<dynamic> t = data['ledgerHeads'];
      List<Customer> p = t.map((t) => Customer.fromJson(t)).toList();
      users = p;
    } catch (e) {
      print("Error getting users $e");
    }
  }

//----------------------Get_Setting--------------------GeneralSettings---------------------

  Get_Setting() async {
    String url = "${Env.baseUrl}GeneralSettings";
    try {
      final res =
      await http.get(url as Uri, headers: {"Authorization": user.user["token"]});
      print("Get_Setting decoded");

      var tagsJson = json.decode(res.body);
      log(tagsJson.toString());
      imageSetting = tagsJson[0]["rmsBillDispImg"]??false;
      print("----------------");
      print(tagsJson[0]["deliveryCharge"].toString());
      DeliveryChargeController.text=tagsJson[0]["deliveryCharge"]==null?"":tagsJson[0]["deliveryCharge"].toString();
      print("imageSetting");
      print(imageSetting);
    } catch (e) {
      print("error in Get_Setting $e");
    }
  }

  //------------------------------------Get_Setting-----end------------------------------------





//----------------------get token no---------------gtsalestoken------------------------------------------

  getTokenNo() async {
    String url = "${Env.baseUrl}getsettings/1/gtsalestoken";
    try {
      final res =
      await http.get(url as Uri, headers: {"Authorization": user.user["token"]});

      // print("json decoded");
      var tagsJson = json.decode(res.body);
      if(res.statusCode==200) {
        setState(() {
          print("token no");
          // print(tagsJson[0]["vocherNo"].toString());
          Token_Num = tagsJson[0]["vocherNo"];
          TokennumController.text = Token_Num.toString();
        });
      }
    } catch (e) {
      print(e);
    }
  }


  ///-----------------------------------------------
  Get_DetailsSaveData(){

    var s;


// print(json.encode(IBD[0].AddOn_Data[0])) ;

    var daetArray=[];

    for(int i=0;i<IBD.length;i++){
      s={
        'ItemSlNo': IBD[i].ItemSlNo,
        'itemId': IBD[i].itemId,
        'qty': IBD[i].qty,
        'rate': IBD[i].rate,
        'disPercentage': IBD[i].disPercentage,
        'cgstPercentage': IBD[i].cgstPercentage,
        'sgstPercentage': IBD[i].sgstPercentage,
        'cessPercentage': IBD[i].cessPercentage,
        'discountAmount': IBD[i].discountAmount,
        'cgstAmount': IBD[i].cgstAmount,
        'sgstAmount': IBD[i].sgstAmount,
        'cessAmount': IBD[i].cessAmount,
        'igstPercentage': IBD[i].igstPercentage,
        'igstAmount': IBD[i].igstAmount,
        'taxPercentage': IBD[i].taxPercentage,
        'taxAmount': IBD[i].taxAmount,
        'taxInclusive': IBD[i].taxInclusive,
        'amountBeforeTax': IBD[i].amountBeforeTax,
        'amountIncludingTax': IBD[i].amountIncludingTax,
        'netTotal': IBD[i].amountIncludingTax,
        'hsncode': IBD[i].hsncode,
        'gdnId': IBD[i].gdnId,
        'taxId': IBD[i].taxId,
        'rackId': IBD[i].rackId,
        'addTaxId': IBD[i].addTaxId,
        'unitId': IBD[i].unitId,
        'nosInUnit': IBD[i].nosInUnit,
        'barcode': IBD[i].barcode,
        'StockId': IBD[i].StockId,
        'BatchNo': IBD[i].BatchNo,
        'ExpiryDate': IBD[i].ExpiryDate,
        'Notes': IBD[i].Notes,
        'adlDiscAmount': IBD[i].adlDiscAmount,
        'adlDiscPercent': IBD[i].adlDiscPercent,
        'shid': IBD[i].shid,
        "relSalesDetailsItemAddon":[
          for(int k=0;k<IBD[i].AddOn_Data.length;k++)
            {

              "addonItemId": IBD[i].AddOn_Data[k].addOnitemId,
              "addonItemRate":  IBD[i].AddOn_Data[k].addonRate,
              "addonItemQty":  IBD[i].AddOn_Data[k].qty
              // "addonItem":  IBD[i].AddOn_Data[k].addonItemName,
            }
        ],
        "relSalesDetailsItemNotes":[
          for(int k=0;k<IBD[i].Item_notes.length;k++)
            {
              "notesId": IBD[i].Item_notes[k]["id"],
            }
        ],
      };
      daetArray.add(s);
    };
    print("detPart");
    print(daetArray) ;
    // print(daetArray.runtimeType) ;
    return daetArray;
  }

  //-------------------------------------Savefunction------------------------------------------
  int vchnum=1;


  IBSave(Detailsdta) async {

    var detPart=await  Get_DetailsSaveData();
    print(detPart);

    var res;
    print("in IBSave");
    // final url = "${Env.baseUrl}SalesHeaders";
    if (Detailsdta.length == 0) {
      showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(actions: [
                Container(
                  height: 50,
                  width: 300,
                  child: Center(
                      child: Text("Please add items..!",
                          style: TextStyle(color: Colors.red, fontSize: 20))),
                )
              ]);
            });
          });
      return;
    }

    // if (TablenumController.text == "") {
    //   setState(() {
    //     TablenumValid = true;
    //   });
    //
    //   return;
    // }
    // TablenumValid = false;

    if (TotalAmtController.text != "Amount paid" &&
        TotalAmtController.text != "Credited") {
      showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(actions: [
                Container(
                  height: 50,
                  width: 300,
                  child: Center(
                      child: Text("Amount Not Payed",
                          style: TextStyle(color: Colors.red, fontSize: 20))),
                )
              ]);
            });
          });
      return;
    }
    print("dgfsfdf");
    print("sadsadfggf" + Cust_Details[0]["OrderTyp"].toString());

    if(Cust_Details[0]["OrderTyp"]=="Delivery"){
      print("is order type is delivery");
    }
    else{
      DeliveryChargeController.text="";
      print("delivery charge changed" + DeliveryChargeController.text );
    }
    var delAmt=DeliveryChargeController.text==""?"0":DeliveryChargeController.text;
    print("thedssaeraw charge is " + delAmt.toString() );

    if(ButtonName=="Save"){




      //--------logic to check sales closed----------
     // final resSclose = await http.get("${Env.baseUrl}GeneralSettings/1/Getrmssale",
      final resSclose = await http.get("${Env.baseUrl}GeneralSettings" as Uri,
          headers: {
        "Authorization": user.user["token"],
      }
          );

      bool enableSalesRms=false;
      var ProceedSales = json.decode(resSclose.body);
      print(ProceedSales.toString());
      for (int i = 0; i < ProceedSales.length; i++) {
        print("inside for " + i.toString() );
        enableSalesRms= ProceedSales[i]['enableSalesRms'];
        print("ProceedSales  :" + ProceedSales[i]['enableSalesRms'].toString());
        print("bool sloked" + enableSalesRms.toString());
      }



      if(enableSalesRms==false)
        {
          print("enableSalesRms " + enableSalesRms.toString() );
          showDialog(
              context: context,
              builder: (buildconext ) {
                return AlertDialog(
                  title: Center(
                      child:
                      Column(
                        children: [
                          Text('You cannot add new bill now, system is under closing stage, try after day close  ', style: TextStyle(color: Colors.redAccent),),
                          TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("Ok"))
                        ],
                      )),
                );
              });
          return;
        }
           //----------end-----------
      Customername = Cust_Details[0]["UserName"];
      print ("the details of saving" + vchnum.toString() + Customername.toString());
      print("in Save");

      print("sdfadsfj " + TotalAmt.toString());
      print("sdfadsfjkg " + TotalTaxAmt.toString());




      var req = {
        // "id":EditId,
        // ButtonName=="Save"?"":"id":EditId,

        "voucherNo":vchnum++,
        "voucherDate": dateNow.toString(),
        "ledgerId":null,// customerId,
        //"partyName": Cust_Details[0]["UserName"],
         "partyName": Customername,
        "DeliveryTo":TablenumController.text,// "Table " + TablenumController.text,
        "TokenNo": Token_Num,
        "paymentType": PaymentTypID,
        "DeliveryType": true,
        "address1": Cust_Details[0]["Add1"],
        "address2": Cust_Details[0]["add2"],
        "Orderstatus": "deliverypending",
        "OrderType": Cust_Details[0]["OrderTyp"],
        "orderHeadId":OrderumController.text,
        "saleTypeInterState": true,
        "phone":Cust_Details[0]["Ph_num"],
        // "phone": Pay_Typ_Credit_Ph_Controller.text == "" ? null : Pay_Typ_Credit_Ph_Controller.text,
        "shipToName": null,
        "shipToAddress1": null,
        "shipToAddress2": null,
        "shipToPhone": Cust_Details[0]["Ph_num"],
        "narration": null,
        //"amount": TotalAmt,
        "amount": TotalAmt + double.parse(delAmt),
        "taxAmt":TotalTaxAmt,
        "discountAmt": Pay_Typ_Disamt,
        "balanceAmount": TotalAmt,
        "cashReceived": Pay_Typ_cash,
        "adjustAmount": Pay_Typ_RoundOff,
        "paymentCondition": null,
        "slesManId": EmpId,
        "branchUpdated": false,
        "userId": userId,
        "branchId": branchId,
        //"otherAmt": Pay_Typ_Other_cash,
        "otherAmt":delAmt,
        "invoiceType": "sales",
        "invoicePrefix": null,
        "invoiceSuffix": null,
        "cancelFlg": null,
        "entryDate": "",
        "gstNo": null,
        "orderDate": null,
        "expDate": null,
        "creditPeriod": null,
        "adlDiscAmount": null,
        "adlDiscPercent": null,
        "otherAmountReceived": null,
        "salesExpense": null,
        // "salesDetails": IBD,
        "salesDetails": detPart,
      };

      var params = json.encode(req);

      print("params.......... " + params.toString());
      log(params);

      print(json.encode(IBD));


     print("save ${Env.baseUrl}SalesHeaders");

      res = await http.post("${Env.baseUrl}SalesHeaders" as Uri,
          headers: {
            'accept': 'application/json',
            'content-type': 'application/json',
            'Authorization': user.user["token"],
            'deviceId': user.deviceId
          },
          body: params);
      print("the sieras is " + res.body.toString());
      log(res.body.toString());
        GetCustomer_PH();
    }
    else// edit
    {

      var Editreq = {
        "id":EditId,
        // ButtonName=="Save"?"":"id":EditId,
        "voucherNo": EditId,
        "voucherDate": dateNow.toString(),
        "ledgerId": customerId,
        "partyName": Customername,
        "DeliveryTo":TablenumController.text,
        "TokenNo": Token_Num,
        "paymentType": PaymentTypID,
        "DeliveryType": true,
        "address1": null,
        "Orderstatus": "deliverypending",
        "OrderType": "waiter",
        "address2": null,
        "saleTypeInterState": true,
        "phone": Pay_Typ_Credit_Ph_Controller.text == ""
            ? null
            : Pay_Typ_Credit_Ph_Controller.text,
        "shipToName": null,
        "shipToAddress1": null,
        "shipToAddress2": null,
        "shipToPhone": null,
        "narration": null,
        "amount": TotalAmt,
        "discountAmt": Pay_Typ_Disamt,
        "balanceAmount": TotalAmt,
        "cashReceived": Pay_Typ_cash,
        "adjustAmount": Pay_Typ_RoundOff,
        "paymentCondition": null,
        "slesManId": null,
        "branchUpdated": false,
        "userId": userId,
        "branchId": branchId,
        "otherAmt": Pay_Typ_Other_cash,
        "invoiceType": null,
        "invoicePrefix": null,
        "invoiceSuffix": null,
        "cancelFlg": null,
        "entryDate": "",
        "gstNo": null,
        "orderDate": null,
        "expDate": null,
        "creditPeriod": null,
        "adlDiscAmount": null,
        "adlDiscPercent": null,
        "otherAmountReceived": null,
        "salesDetails": IBD,
        "salesExpense": []
      };
      var Editparams = json.encode(Editreq);

      print("Edit params");
      print(Editparams);
      print("Edit det");
      print(json.encode(IBD));

      print("edit ${Env.baseUrl}SalesHeaders/$EditId");
      res = await http.put("${Env.baseUrl}SalesHeaders/$EditId" as Uri,
          headers: {
            'accept': 'application/json',
            'content-type': 'application/json',
            'Authorization': user.user["token"],
            'deviceId': user.deviceId
          },
          body: Editparams);
    }
    print("res.data " + res.body);
    print("res.statusCode " + res.statusCode.toString());
    if (res.statusCode == 200 || res.statusCode == 201 || res.statusCode == 204 )
    {
      setState(() {
        TD.clear();
        IBD.clear();
        TotalAmtController.text = "0.00";
        DiscTotalAmtController.text="0.00";
        TablenumController.text = "";
        TokennumController.text = "";
        TotalAmt = 0.00;
        TotalTaxAmt=0.00;
        listabledataShow = false;
        getTokenNo();
        GetBillNum();
        EditId=null;
        //  dataForTicket=json.decode(res.body);

      });
      var resdata=json.decode(res.body);

      // for(int i=0;i<int.parse(textController.text);i++) {

        //   print("the orginal part");
        //   dataForTicket =
        //   await GetPrintdata(resdata["id"], "Tax Invoice (Original)");
        // setState(() {
        //   if (resdata["id"].toString() != "null") {
        //     PerviousBillPrint_Controller.text = resdata["id"].toString();
        //     Perv_Bill_Id = resdata["id"].toString();
        //   }
        // });
      // }
    ///.........................print dual time start.........................

      print("dfadfju" + textController.text);
      for(int i=0;i<int.parse(textController.text??"0").toInt();i++) {
        if(i==0) {
          print("the orginal part");
          await GetPrintdata(resdata["voucherNo"], "Tax Invoice (Original)");
        }
        else{
          print("the copy part");
          await GetPrintdata(resdata["voucherNo"], "Tax Invoice (Copy)");
        }
        print("total tax exclusive");
        setState(() {
          if (resdata["voucherNo"].toString() != "null") {
            PerviousBillPrint_Controller.text = resdata["voucherNo"].toString();
            Perv_Bill_Id = resdata["voucherNo"].toString();
          }
        });
      }
      ///.........................print dual time end.........................
      TotalAmtTaxExcl =
          (dataForTicket["salesHeader"][0]["amount"].toDouble() -
              dataForTicket["salesHeader"][0]["taxAmt"].toDouble()) -
              dataForTicket["salesHeader"][0]["otherAmt"].toDouble();
      print("totalAmtTax  " + TotalAmtTaxExcl.toString());

      showDialog(
          context: context,
          builder: (buildconext) {
            Future.delayed(Duration(seconds: 4), () {
              Navigator.of(buildconext).pop(true);
            });
            return AlertDialog(
              title: Center(child: Text('Success - on Printer: ' + Counter_Printer, style: TextStyle(color: Colors.green),)),
            );
          });


      // showDialog(
      //     context: context,
      //     builder: (context) => AlertDialog(
      //       title: Center(
      //           child: Text(
      //             "Success",
      //             style: TextStyle(color: Colors.blueAccent),
      //           )),
      //     ));


    }
    else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Center(
                child: Text(
                  "Failed !",
                  style: TextStyle(color: Colors.brown),
                )),
          ));
      if(discact==true){
        DiscTotalAmtController.text= (TotalAmt - ((TotalAmt* discper)/100.00)).toStringAsFixed(3);
      }
      TotalAmtController.text = TotalAmt.toString();
    }
  }

  //----------------------------end-----------Savefunction---end-------------------------------------


  Rms_SimPrint SimpPrint=Rms_SimPrint();




  //-----------------Show poup for  selected items --------------------------------------
  ListoTable(array) async {
    UomRateController.text = "";
    UomRateSelect = false;
    quantitySelect = false;
    print("in");
    print(array.toString());
    dynamic Did = (array["id"]).toString();
    int itemid = int.parse(Did);
    itemname = array["itmName"];
    print("hyd:" +  array["itmName"].toString() + "->" +array["activeAddonItems"].toString() + itemid.toString());
    showAddonItems = array["activeAddonItems"];

    // itemRate = array["rate"];
    // quantityController.text = "";
    // quantitySelect = false;
    itemTaxInOrEx = array["itmTaxInclusive"];
    String url = "${Env.baseUrl}gtitemmasters/$itemid/-1";
    try {
      final res =
      await http.get(url as Uri, headers: {"Authorization": user.user["token"]});

      //  print(" Item UOM");
      // print(res.body);

      //  print("json decoded");

      var tagsJson = json.decode(res.body);
      UomData = tagsJson;
      // print(tagsJson.length);
    } catch (e) {
      print("error on ListoTable : $e");
    }
    Map<String, bool> values = {
      'foo': true,
      'bar': false,
    };



    if(MediaQuery.of(context).size.width > 500){
      ///.................original 1...................
      // var s=await AddonItem.initialFuntion(
      //     context, UomData, itemname,
      //     itemid,array["itmImage"],user.user["token"],
      //     BillingNote,imageSetting,currencyName);
      ///.................original 1...................
      print("value of show add on " + showAddonItems.toString());
      var s=await AddonItem.initialFuntion(
          context, UomData, itemname,
          itemid,array["itmImage"],user.user["token"],
          BillingNote,imageSetting,currencyName, values, showAddonItems);

      print("oipoii[");
      print("s");
      print(s);

      if(s!=null){
        print(s[0]["Qty"].toString());
        print(s[0]["data"]);

        quantityController.text=s[0]["Qty"].toString();
        UomTableData= s[0]["data"];
        AddonData=s[0]["AddonData"];
        print("aaaaaaaaaaa");
        print(AddonData.runtimeType);
        print(AddonData);
        Item_notes=s[0]["Notes"];
        bindToTable();

      }
      else
      {print("item Not Selected");}


    }else
    {
      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                //backgroundColor: Colors.pink.shade100,
                actions: [
                  Column(
                    children: [
                      SingleChildScrollView(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            UomData.length == 0
                                ? Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 10),
                              child: Text(
                                "UOM Not Found..!",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                ),
                              ),
                            )
                                : Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 10),
                              child: Text(
                                itemname,
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Divider(
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 225,
                        width: 350,
                        child: ListView(shrinkWrap: true, children: [
                          Visibility(
                            visible: UomData.length > 0,
                            child: DataTable(
                              showCheckboxColumn: false,
                              columnSpacing: 3,
                              onSelectAll: (b) {},
                              sortAscending: true,
                              columns: <DataColumn>[
                                DataColumn(
                                  label: SingleChildScrollView(
                                      physics: NeverScrollableScrollPhysics(),
                                      child: Text('UOM')),
                                ),
                                DataColumn(
                                  label: Text('Rate'),
                                ),
                                // DataColumn(
                                //   label: Text(''),
                                // ),
                                // DataColumn(
                                //   label: Text(''),
                                // ),
                              ],
                              rows: UomData.map(
                                    (itemRow) => DataRow(
                                  onSelectChanged: (a) {
                                    print(itemRow);
                                    UomRateController.text =
                                    itemRow['mrp'] == null
                                        ? "0.00"
                                        : itemRow['mrp'].toString();

                                    setState(() {
                                      UomRateSelect = false;
                                      UomTableData = itemRow;
                                      UOM = itemRow['description'];
                                      print("UOM =: $UOM");
                                    });
                                  },
                                  cells: [
                                    DataCell(
                                      Text(
                                          '${itemRow['description'].toString()}'),
                                      showEditIcon: false,
                                      placeholder: false,
                                    ),
                                    DataCell(
                                      Text(
                                          '${itemRow['mrp'] == null ? "0.00" : itemRow['mrp'].toString()}'),
                                      showEditIcon: false,
                                      placeholder: false,
                                    ),
                                    // DataCell(
                                    //   GestureDetector(
                                    //       onTap: () {
                                    //         print(itemRow);
                                    //         UomRateController.text =
                                    //             itemRow['mrp'] == null
                                    //                 ? "0.00"
                                    //                 : itemRow['mrp'].toString();
                                    //
                                    //         setState(() {
                                    //           UomRateSelect = false;
                                    //           UomTableData = itemRow;
                                    //           UOM = itemRow['description'];
                                    //           print("UOM =: $UOM");
                                    //           print(getUOMIndex(itemRow));
                                    //         });
                                    //
                                    //         // id: 21
                                    //         // AddtoTable(itemRow);
                                    //         //
                                    //         // Navigator.pop(context);
                                    //       },
                                    //       child: Icon(Icons.done_outline_rounded)),
                                    // ),
                                    // DataCell(
                                    //   Visibility(
                                    //       visible: false,
                                    //       child:
                                    //           Text(getUOMIndex(itemRow).toString())),
                                    //   showEditIcon: false,
                                    //   placeholder: false,
                                    // ),
                                  ],
                                ),
                              ).toList(),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 100,
                              height: 50,
                              child: TextFormField(
                                controller: quantityController,
                                enabled: true,
                                validator: (v) {
                                  if (v!.isEmpty) return "Required";
                                  return null;
                                },
                                cursorColor: Colors.black,
                                scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r"^\d+\.?\d{0,2}")),
                                ],
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(color: Colors.red),
                                  errorText:
                                  quantitySelect ? "Invalid Qty" : null,
                                  isDense: true,
                                  contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 16.0),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14.0)),
                                  hintStyle: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                  labelText: "Quantity",
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 150,
                              height: 50,
                              child: TextFormField(
                                readOnly: true,
                                controller: UomRateController,
                                enabled: false,
                                // validator: (v) {
                                //   if (v.isEmpty) return "Required";
                                //   return null;
                                // },

                                cursorColor: Colors.black,
                                // scrollPadding: EdgeInsets.fromLTRB(40, 50, 20, 0),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r"^\d+\.?\d{0,2}")),
                                ],
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(color: Colors.red),
                                  errorText:
                                  UomRateSelect ? "Invalid Rate" : null,
                                  isDense: true,
                                  contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 16.0),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14.0)),
                                  hintStyle: TextStyle(
                                      color: Colors.black, fontSize: 15),

                                  labelText: "Rate",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Expanded(
                              child: TypeAheadField(
                                  suggestionsBoxVerticalOffset: 50,

                                  direction:AxisDirection.up,
                                  textFieldConfiguration: TextFieldConfiguration(
                                      style: TextStyle(),
                                      controller: ItemNotesController,
                                      decoration: InputDecoration(
                                        errorStyle: TextStyle(color: Colors.red),
                                        // errorText: itemSelect
                                        //     ? "Please Select product Item ?"
                                        //     : null,
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.remove_circle),
                                          color: Colors.blue,
                                          onPressed: () {
                                            setState(() {
                                              print("cleared");
                                              ItemNotesController.text = "";
                                              ItemNotes_Id = null;

                                            });
                                          },
                                        ),



                                        isDense: true,
                                        contentPadding:
                                        EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10)),
                                        // i need very low size height
                                        labelText:
                                        'Item search', // i need to decrease height
                                      )),
                                  suggestionsBoxDecoration:
                                  SuggestionsBoxDecoration(elevation: 90.0),
                                  suggestionsCallback: (pattern) {
                                    return BillingNote.where((user) =>
                                        user["notes"].toString().trim().toLowerCase().contains(pattern.trim().toLowerCase()));
                                  },
                                  itemBuilder: (context, suggestion) {
                                    return Card(
                                      color: Colors.blue,
                                      // shadowColor: Colors.blue,
                                      child: ListTile(
                                        tileColor: theam.DropDownClr,
                                        title: Text(
                                          suggestion["notes"],
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    );
                                  },
                                  onSuggestionSelected: (suggestion) {
                                    print(suggestion["notes"]);
                                    print("selected");
                                    ItemNotesController.text=suggestion["notes"];
                                    //  print(salesItemId);
                                    print("...........");

                                  },
                                  errorBuilder: (BuildContext context, Object? error) =>
                                      Text('$error',
                                          style: TextStyle(
                                              color: Theme.of(context).errorColor)),
                                  transitionBuilder:
                                      (context, suggestionsBox, AnimationController? animationController) =>
                                      FadeTransition(
                                        child: suggestionsBox,
                                        opacity: CurvedAnimation(
                                            parent: animationController!,
                                            curve: Curves.elasticIn),
                                      )
                              ),
                            ),


                            IconButton(
                                icon: Icon(Icons.add_shopping_cart,size: 35,color: Colors.teal,),

                                onPressed:(){
                                  if (UOM == null || UOM == "null") {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return StatefulBuilder(
                                              builder: (context, setState) {
                                                return AlertDialog(actions: [
                                                  Container(
                                                    height: 30,
                                                    width: 300,
                                                    child: Center(
                                                        child: Text(
                                                          "UOM is Undefined..!",
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 20),
                                                        )),
                                                  )
                                                ]);
                                              });
                                        });
                                    return;
                                  }
                                  print("in test");
                                  if (UomRateController.text == "" ||
                                      UomRateController.text == "0.00") {
                                    setState(() {
                                      UomRateSelect = true;
                                      return;
                                    });
                                  } else {
                                    setState(() {
                                      UomRateSelect = false;
                                      print(UomTableData);
                                      ItemLstController.text = "";
                                      ItemGrpController.text = "";
                                      bindToTable();
                                      Navigator.pop(context);
                                    });
                                  }
                                })
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              );
            },
          );
        },
      );
    }
  }

//---------------------------------end poup---------------------------------------------


  GetAddItemRate(){
    var AddonTotalRate=0.0;
    for(int i=0;i<AddonData.length;i++){
      print("AddonData[i].addonItemName");
      print(AddonData[i].addonItemName);
      print(AddonData[i].addonRate);
      AddonTotalRate=AddonTotalRate+(AddonData[i].addonRate??0)*(AddonData[i].qty??0);

    }
    return AddonTotalRate;
  }

  //---------------------------------Data Bind To Table------------------------------------------------------------
  bindToTable() {
    try {
      var AddonRate= GetAddItemRate();
      print("-----------AddonRate-------------------");
      print(AddonRate);
      var amtWithTax;
      double taxamt;
      double ItemAddontax;
      var amtWithOutTax;


      itemQty = double.parse(quantityController.text);
      itemRate = (UomTableData['mrp'].toDouble());
      total = (itemRate * itemQty);
      double taxDivValue=0;
      if (itemTaxInOrEx == true) {
        // print("uomtabledata");
        // print( UomTableData['taxPercentage'].toString());
        taxDivValue =(100 + UomTableData['txPercentage'].toDouble()) / 100;
        print("inclusive  " + taxDivValue.toString());
        amtWithTax = itemRate * itemQty;
        print("total  "  + total.toString());
        print(amtWithTax);
        amtWithOutTax = (amtWithTax / taxDivValue);
        taxamt = (amtWithTax - amtWithOutTax);
        if(AddonRate>0){
          ItemAddontax = AddonRate - (AddonRate / taxDivValue);
          print("AddonRate==" + AddonRate.toString());
        }

        print("taxamount=== " + taxamt.toString());
        print(ItemAddontax);
        if(ItemAddontax==null){
          TotalTaxAmt=TotalTaxAmt + taxamt;
        }
        else{
          TotalTaxAmt=TotalTaxAmt + taxamt + ItemAddontax;
          print(TotalTaxAmt);
        }
      } else {
        print("exclusive");
        taxamt = ((total * UomTableData['txPercentage'].toDouble()) / 100) ;
        ItemAddontax =  ((AddonRate * UomTableData['txPercentage'].toDouble()) / 100);
        amtWithTax = taxamt + total;
        amtWithOutTax = total;
        TotalTaxAmt=TotalTaxAmt + taxamt + ItemAddontax;
      }
      print(TotalAmt.runtimeType);
      print(amtWithTax.runtimeType);
      print(amtWithTax);

      TotalAmt = TotalAmt.toDouble() + amtWithTax.toDouble()+AddonRate;
      slnum = ++slnum;
      // TotalAmtController.text = TotalAmt.toStringAsFixed(3); ---with out add on rate
      //  TotalAmtController.text = TotalAmt.toStringAsFixed(3);----- With out delvery amt

      var delivery_Amt=DeliveryChargeController.text==""?"0":DeliveryChargeController.text;
      if(discact == true){
        DiscTotalAmtController.text= ((TotalAmt - ((TotalAmt* discper)/100.00)) +double.parse(delivery_Amt)).toStringAsFixed(3);
      }

        TotalAmtController.text = (TotalAmt+double.parse(delivery_Amt)).toString();








      listabledataShow = true;
      print("the total amount is " + TotalAmt.toString());

      ItmBLdata = ItmBillDetails(
          ItemSlNo: slnum,
          itemId: UomTableData['itemid'],
          qty: itemQty,
          rate: itemRate,
          disPercentage: discper,
          cgstPercentage: UomTableData['txCgstPercentage'],
          sgstPercentage: UomTableData['txSgstPercentage'],
          cessPercentage: null,
          discountAmount: 0,
          cgstAmount: UomTableData['txCgstPercentage'] == null
              ? "0"
              : (total / 100) * UomTableData['txCgstPercentage'],
          sgstAmount: UomTableData['txSgstPercentage'] == null
              ? "0"
              : (total / 100) * UomTableData['txSgstPercentage'],
          cessAmount: 0,
          igstPercentage: UomTableData['txIgstpercentage'],
          igstAmount: UomTableData['txIgstpercentage'] == null
              ? "0"
              : (total / 100) * UomTableData['txIgstpercentage'],
          taxPercentage: UomTableData['txPercentage'],
          taxAmount: taxamt,
          taxInclusive: itemTaxInOrEx,
          amountBeforeTax: amtWithOutTax,
          amountIncludingTax: amtWithTax,
          //ele.Tax_Amt + ele.Gross_Amt,
          netTotal: TotalAmt,
          hsncode: null,
          gdnId: 0,
          taxId: UomTableData['txId'],
          rackId: 0,
          addTaxId: 0,
          unitId: UomTableData['unitId'],
          nosInUnit: 0,
          //ele.Nos_In_Unit,
          barcode: null,
          //
          StockId: 0,
          BatchNo: null,
          ExpiryDate: null,
          Notes: ItemNotesController.text,
          adlDiscAmount: null,
          adlDiscPercent: null,
          shid: EditId,
          AddOn_Data:AddonData,
          Item_notes:Item_notes

      );
      setState(() {
        IBD.add(ItmBLdata);
        print("json encode (ibd)" + jsonEncode(IBD).toString());
      });

      TDdata = Del_Tabledata(
          id: UomTableData['itemid'],
          ItemSlNo: slnum,
          Name: UomTableData['itmName'],
          Qty: itemQty,
          rate: itemRate,
          //Total: itemRate * itemQty,
          Total:amtWithTax+AddonRate??0,
          UOM: UomTableData['description'],
          AmtWithTax: amtWithTax,
          Addon_Data: AddonData,
          Item_notes: Item_notes,
          Item_Addon_Rate:AddonRate
      );
      setState(() {
        TD.add(TDdata);
        print("jsonEncode(TD)");
        print(json.encode(AddonData));
        print("---------------");
        print(jsonEncode(TD));
        listabledataShow = true;
      });
    } catch (e) {
      print("error on Bind to table $e");
    }
  }

  //---------------------------------END  Data Bind To Table------------------------------------------------------------






  // -------------------------get itemGrp
  getItemGrp() async {
    print(" Item Grp");
    String url = "${Env.baseUrl}Gtitemgroups/1/orderbyId";
    print(" Item Grp" + url);
    try {
      print("try");
      final res =
      await http.get(url as Uri, headers: {"Authorization": user.user["token"]});

      print("response body");
      print(res.body);

      //print("json decoded");

      var tagsJson = json.decode(res.body);

      setState(() {
        List<dynamic> t = tagsJson['gtItemGroup'];
        List<ItemGroup> p = t.map((t) => ItemGroup.fromJson(t)).toList();
        btnItmGrp = tagsJson['gtItemGroup'];
        if (btnItmGrp != null) {
          itmGrpVsbl = true;
        } else {
          itmGrpVsbl = false;
        }

        // print("sssss"+(btn1[0]['igDescription']).toString());
        ItmGrp = p;
      });
    } catch (e) {
      print("catch");
      print(e);
    }
  }

//---------------------Get item------------------------------------
  getItem(id) async {
    print("getItem : " + id.toString());

    String url = "${Env.baseUrl}gtitemmasters/$id/0";
    try {
      final res =
      await http.get(url as Uri, headers: {"Authorization": user.user["token"]});

      print(" Item list");
      print(res.body);

      print("json decoded");

      var tagsJson = json.decode(res.body);

      setState(() {
        List<dynamic> t = tagsJson;
        List<ItemList> p = t.map((t) => ItemList.fromJson(t)).toList();
        btnItmLst = tagsJson;
        ItmLst = p;

        if (btnItmLst.isEmpty) {
          itmLstVsbl = false;
          Noitem = true;
        } else {
          itmLstVsbl = true;
          Noitem = false;
        }
      });
    } catch (e) {
      print(e);
    }
  }

  //-------------------------GEt--Payment Type--------------------------------------------
  GetPaymentType() async {
    String url = "${Env.baseUrl}GeneralSettings/1/paymenttype";
    try {
      final res =
      await http.get(url as Uri, headers: {"Authorization": user.user["token"]});

      print("PaymentType");
      print(res.body);

      print("json decoded");

      var tagsJson = json.decode(res.body);
      PayTypData = tagsJson;
    } catch (e) {
      print("error on PaymentType $e");
    }
  }

//-------------------------Get--Payment Type--- End-----------------------------------------

  //-------------------------Set--Payment Type----------poup----------------------------------

  SetPaymentType() {
    if (IBD.length == 0) {
      showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(actions: [
                Container(
                  height: 50,
                  width: 300,
                  child: Center(
                      child: Text("Please add items..!",
                          style: TextStyle(color: Colors.red, fontSize: 20))),
                )
              ]);
            });
          });
      return;
    } else
      // (TablenumController.text == "") {
      //   setState(() {
      //     TablenumValid = true;
      //     showDialog(
      //         context: context,
      //         builder: (context) {
      //           return StatefulBuilder(builder: (context, setState) {
      //             return AlertDialog(actions: [
      //               Container(
      //                 height: 50,
      //                 width: 300,
      //                 child: Center(
      //                     child: Text("Invalid Table No..!",
      //                         style: TextStyle(color: Colors.red, fontSize: 20))),
      //               )
      //             ]);
      //           });
      //         });
      //   });
      //
      //   return;
      // }
      // setState(() {
      //   TablenumValid = false;
      // });

    if (PayTypData.length > 0) {
      PaymentPopupVisilbe = true;
    } else {
      PaymentPopupVisilbe = false;
    }

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(actions: [
              Column(
                children: [
                  SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Text("Payment Type",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Text("  $PaymentName",
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 20,
                              )),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      "Net Amount : Rs " +  TotalAmtController.text,
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  Container(
                      height: 325,
                      width:501> 500? MediaQuery.of(context).size.width:400,
                      child: ListView(shrinkWrap: true, children: [
                        Visibility(
                          visible: PaymentPopupVisilbe == true,
                          child: DataTable(
                            showCheckboxColumn: false,
                            headingRowHeight: 0,
                            onSelectAll: (b) {},
                            sortAscending: true,
                            columns: <DataColumn>[
                              DataColumn(
                                label: Text(''),
                              ),
                            ],
                            rows: PayTypData.map(
                                  (itemRow) => DataRow(
                                onSelectChanged: (a) {
                                  setState(() {
                                    print(itemRow);
                                    Pay_Frm_Reset();
                                    PayAmtTypData = itemRow;
                                    PaymentName = itemRow['paymentType'];
                                    PaymentTypID = itemRow['id'];
                                    if (PayAmtTypData["paymentType"]
                                        .contains('and')) {
                                      print("contain");
                                      Pay_Typ_OthAmt_TxtBx_Visible = true;
                                      Payment_Credit_Visilbe = false;
                                    } else if (PayAmtTypData["paymentType"] ==
                                        "Credit") {
                                      Pay_Typ_OthAmt_TxtBx_Visible = false;
                                      PaymentAmtPopupVisilbe = false;
                                      Payment_Credit_Visilbe = true;
                                    } else {
                                      print(" Not contain");
                                      Pay_Typ_OthAmt_TxtBx_Visible = false;
                                      Payment_Credit_Visilbe = false;
                                    }
                                  });
                                },
                                cells: [
                                  DataCell(
                                    Center(
                                        child: Text(
                                            '${itemRow['paymentType'].toString()}')),
                                    showEditIcon: false,
                                    placeholder: false,
                                  ),
                                ],
                              ),
                            ).toList(),
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),

                        // Patment tyep select  amt  typing---------------------------------------

                        Visibility(
                          visible: PaymentAmtPopupVisilbe == true,
                          child: Column(children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                onChanged: (a) {
                                  print(a.toString());
                                  if (Pay_Typ_Cash_Controller.text == "") {
                                    var TotAmt = TotalAmtController.text;
                                    var amt1 = (double.parse(TotAmt)) - ((Pay_Typ_Disamt));
                                    var amt2 = amt1 - Pay_Typ_RoundOff;
                                    var amt3 = amt2 - Pay_Typ_Other_cash;
                                    Pay_Typ_Tota_Amt_Controller.text = amt3.toStringAsFixed(3);
                                    Pay_Typ_cash = 0.00;
                                    return;
                                  } else {
                                    setState(() {
                                      Pay_Typ_cash = (double.parse(
                                          Pay_Typ_Cash_Controller.text));
                                      var TotAmt = TotalAmtController.text;

                                      print("Pay_Typ_cash");
                                      // print(Pay_Typ_cash);
                                      // print(Pay_Typ_Disamt);
                                      // print(Pay_Typ_RoundOff);

                                      var amt1 = (double.parse(TotAmt)) -
                                          ((Pay_Typ_cash));
                                      var amt2 = amt1 - Pay_Typ_Disamt;
                                      var amt3 = amt2 - Pay_Typ_RoundOff;
                                      var amt = amt3 - Pay_Typ_Other_cash;
                                      var NetAmt = amt;
                                      // print(amt1);
                                      // print(amt2);
                                      // print(amt3);

                                      Pay_Typ_Tota_Amt_Controller.text =
                                          NetAmt.toStringAsFixed(3);
                                    });
                                  }
                                },
                                controller: Pay_Typ_Cash_Controller,
                                enabled: true,
                                validator: (v) {
                                  if (v!.isEmpty) return "Required";
                                  return null;
                                },
                                inputFormatters: <TextInputFormatter>[
                                  WhitelistingTextInputFormatter(
                                      RegExp(r"^\d+\.?\d{0,2}")),
                                ],
                                keyboardType: TextInputType.number,
                                cursorColor: Colors.black,
                                scrollPadding:
                                EdgeInsets.fromLTRB(0, 20, 20, 0),
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(color: Colors.red),
                                  errorText: Pay_Typ_Cash_Valid == true
                                      ? "Add Amount"
                                      : null,
                                  isDense: true,
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 10.0, 20.0, 16.0),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(14.0)),
                                  hintStyle: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                  labelText: "Cash",
                                ),
                              ),
                            ),

                            //------------------Other amt Txt Bx------------------
                            Visibility(
                              visible: Pay_Typ_OthAmt_TxtBx_Visible == true,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, bottom: 10, left: 5, right: 5),
                                child: TextFormField(
                                  onChanged: (a) {
                                    print(a.toString());
                                    if (Pay_Typ_OthAmt_Controller.text == "") {
                                      var TotAmt = TotalAmtController.text;
                                      var amt1 = (double.parse(TotAmt)) -
                                          ((Pay_Typ_Disamt));
                                      var amt2 = amt1 - Pay_Typ_RoundOff;
                                      var amt3 = amt2 - Pay_Typ_cash;
                                      Pay_Typ_Tota_Amt_Controller.text =
                                          amt3.toStringAsFixed(3);
                                      Pay_Typ_cash = 0.00;
                                      return;
                                    } else {
                                      setState(() {
                                        Pay_Typ_Other_cash = (double.parse(
                                            Pay_Typ_OthAmt_Controller.text));
                                        var TotAmt = TotalAmtController.text;

                                        print("Pay_Typ_Other_cash");
                                        // print(Pay_Typ_cash);
                                        // print(Pay_Typ_Disamt);
                                        // print(Pay_Typ_RoundOff);

                                        var amt1 = (double.parse(TotAmt)) -
                                            ((Pay_Typ_cash));
                                        var amt2 = amt1 - Pay_Typ_Disamt;
                                        var amt3 = amt2 - Pay_Typ_RoundOff;
                                        var amt = amt3 - Pay_Typ_Other_cash;
                                        var NetAmt = amt;
                                        // print(amt1);
                                        // print(amt2);
                                        // print(amt3);

                                        Pay_Typ_Tota_Amt_Controller.text =
                                            NetAmt.toStringAsFixed(3);
                                      });
                                    }
                                  },
                                  controller: Pay_Typ_OthAmt_Controller,
                                  enabled: true,
                                  validator: (v) {
                                    if (v!.isEmpty) return "Required";
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r"^\d+\.?\d{0,2}")),
                                  ],
                                  cursorColor: Colors.black,
                                  scrollPadding:
                                  EdgeInsets.fromLTRB(0, 20, 20, 0),
                                  decoration: InputDecoration(
                                    errorStyle: TextStyle(color: Colors.red),
                                    errorText: Pay_Typ_OthAmt_Valid == true
                                        ? "Invalid"
                                        : null,
                                    isDense: true,
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 10.0, 20.0, 16.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(14.0)),
                                    hintStyle: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                    labelText: "Other Amounts",
                                  ),
                                ),
                              ),
                            ),

                            //---------------Discount % And amt----------------------------
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, bottom: 10, right: 10, top: 10),
                                  child: Container(
                                    width:
                                    MediaQuery.of(context).size.width / 3.5,
                                    child: TextFormField(
                                      onChanged: (a) {
                                        if (a == "") {
                                          DisAmtController.text = "";
                                          var TotAmt = TotalAmtController.text;
                                          var amt1 = (double.parse(TotAmt)) -
                                              ((Pay_Typ_cash));
                                          var amt2 = amt1 - Pay_Typ_RoundOff;
                                          var amt3 = amt2 - Pay_Typ_Other_cash;
                                          Pay_Typ_Tota_Amt_Controller.text =
                                              amt3.toStringAsFixed(3);
                                          Pay_Typ_Disamt = 0.00;
                                          return;
                                        } else {
                                          setState(() {
                                            var TotAmt =
                                                TotalAmtController.text;
                                            Pay_Typ_Disamt =
                                                (double.parse(TotAmt) / 100) *
                                                    (double.parse(a));
                                            DisAmtController.text =
                                                Pay_Typ_Disamt.toString();
                                            print("Pay_Typ_Disamt");
                                            // print(Pay_Typ_cash);
                                            // print(Pay_Typ_Disamt);
                                            // print(Pay_Typ_RoundOff);

                                            var amt1 = (double.parse(TotAmt)) -
                                                ((Pay_Typ_cash));
                                            var amt2 = amt1 - Pay_Typ_Disamt;
                                            var amt3 = amt2 - Pay_Typ_RoundOff;
                                            var amt = amt3 - Pay_Typ_Other_cash;
                                            var NetAmt = amt;
                                            // print(amt1);
                                            // print(amt2);
                                            // print(amt3);

                                            Pay_Typ_Tota_Amt_Controller.text =
                                                NetAmt.toStringAsFixed(3);
                                          });
                                        }

                                        if (Pay_Typ_Cash_Controller.text !=
                                            "") {
                                          Pay_Typ_Cash_Valid = false;
                                        }

                                        if (Pay_Typ_OthAmt_Controller.text !=
                                            "") {
                                          Pay_Typ_OthAmt_Valid = false;
                                        }
                                      },
                                      controller: DisPerController,
                                      validator: (v) {
                                        if (v!.isEmpty) return "Required";
                                        return null;
                                      },
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r"^\d+\.?\d{0,2}")),
                                      ],
                                      cursorColor: Colors.black,
                                      scrollPadding:
                                      EdgeInsets.fromLTRB(0, 20, 20, 0),
                                      decoration: InputDecoration(
                                        errorStyle:
                                        TextStyle(color: Colors.red),
                                        isDense: true,
                                        contentPadding: EdgeInsets.fromLTRB(
                                            20.0, 10.0, 20.0, 16.0),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(14.0)),
                                        hintStyle: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                        labelText: "Disc %",
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, bottom: 10, right: 10, top: 10),
                                  child: Container(
                                    width:
                                    MediaQuery.of(context).size.width / 3,
                                    child: TextFormField(
                                      controller: DisAmtController,
                                      readOnly: true,
                                      enabled: false,
                                      validator: (v) {
                                        if (v!.isEmpty) return "Required";
                                        return null;
                                      },
                                      cursorColor: Colors.black,
                                      scrollPadding:
                                      EdgeInsets.fromLTRB(0, 20, 20, 0),
                                      decoration: InputDecoration(
                                        errorStyle:
                                        TextStyle(color: Colors.red),
                                        isDense: true,
                                        contentPadding: EdgeInsets.fromLTRB(
                                            20.0, 10.0, 20.0, 16.0),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(14.0)),
                                        hintStyle: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                        labelText: "Amount",
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            //---------------Round off and Total-----------------------------
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, bottom: 10, right: 10, top: 10),
                                  child: Container(
                                    width:
                                    MediaQuery.of(context).size.width / 3.5,
                                    child: TextFormField(
                                      onChanged: (a) {
                                        if (a == "") {
                                          var TotAmt = TotalAmtController.text;
                                          var amt1 = (double.parse(TotAmt)) -
                                              ((Pay_Typ_cash));
                                          var amt2 = amt1 - Pay_Typ_Disamt;
                                          var amt3 = amt2 - Pay_Typ_Other_cash;
                                          Pay_Typ_Tota_Amt_Controller.text =
                                              amt3.toStringAsFixed(3);
                                          RoundOffController.text = "";
                                          Pay_Typ_RoundOff = 0.00;
                                          return;
                                        } else {
                                          print("aa =$a");
                                          setState(() {
                                            var TotAmt =
                                                TotalAmtController.text;
                                            Pay_Typ_RoundOff =
                                            (double.parse(a));

                                            var amt1 = (double.parse(TotAmt)) -
                                                ((Pay_Typ_cash));
                                            var amt2 = amt1 - Pay_Typ_Disamt;
                                            var amt3 = amt2 - Pay_Typ_RoundOff;
                                            var amt = amt3 - Pay_Typ_Other_cash;
                                            var NetAmt = amt;
                                            // print(amt1);
                                            // print(amt2);
                                            // print(amt3);

                                            print("Pay_Typ_RoundOff");
                                            // print(Pay_Typ_cash);
                                            // print(Pay_Typ_Disamt);
                                            // print(Pay_Typ_RoundOff);
                                            Pay_Typ_Tota_Amt_Controller.text =
                                                NetAmt.toStringAsFixed(3);
                                          });
                                        }
                                      },
                                      onTap: () {
                                        if (Pay_Typ_Cash_Controller.text !=
                                            "") {
                                          Pay_Typ_Cash_Valid = false;
                                        }

                                        if (Pay_Typ_OthAmt_Controller.text !=
                                            "") {
                                          Pay_Typ_OthAmt_Valid = false;
                                        }
                                      },
                                      controller: RoundOffController,
                                      validator: (v) {
                                        if (v!.isEmpty) return "Required";
                                        return null;
                                      },
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        WhitelistingTextInputFormatter(
                                            RegExp(r"^\d+\.?\d{0,2}")),
                                      ],
                                      cursorColor: Colors.black,
                                      scrollPadding:
                                      EdgeInsets.fromLTRB(0, 20, 20, 0),
                                      decoration: InputDecoration(
                                        errorStyle:
                                        TextStyle(color: Colors.red),
                                        isDense: true,
                                        contentPadding: EdgeInsets.fromLTRB(
                                            20.0, 10.0, 20.0, 16.0),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(14.0)),
                                        hintStyle: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                        labelText: "Round Off",
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, bottom: 10, right: 10, top: 10),
                                  child: Container(
                                    width:
                                    MediaQuery.of(context).size.width /3,
                                    child: TextFormField(
                                      controller: Pay_Typ_Tota_Amt_Controller,
                                      readOnly: true,
                                      enabled: false,
                                      validator: (v) {
                                        if (v!.isEmpty) return "Required";
                                        return null;
                                      },
                                      cursorColor: Colors.black,
                                      scrollPadding:
                                      EdgeInsets.fromLTRB(0, 20, 20, 0),
                                      decoration: InputDecoration(
                                        errorStyle:
                                        TextStyle(color: Colors.red),
                                        isDense: true,
                                        contentPadding: EdgeInsets.fromLTRB(
                                            20.0, 10.0, 20.0, 16.0),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(14.0)),
                                        hintStyle: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                        labelText: "Balance",
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            //---------------ok  and Back Buttons-----------------------------
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 10),
                                      child: ElevatedButton(

                                        // color: Colors.blue,
                                        onPressed: () async {
                                          if (Pay_Typ_Cash_Controller.text ==
                                              "") {
                                            setState(() {
                                              Pay_Typ_Cash_Valid = true;
                                              return;
                                            });
                                          } else {
                                            setState(() {
                                              Pay_Typ_Cash_Valid = false;
                                              return;
                                            });
                                          }

                                          if (Pay_Typ_OthAmt_TxtBx_Visible ==
                                              true &&
                                              Pay_Typ_OthAmt_Controller.text ==
                                                  "") {
                                            setState(() {
                                              Pay_Typ_OthAmt_Valid = true;
                                              return;
                                            });
                                          } else {
                                            setState(() {
                                              Pay_Typ_OthAmt_Valid = false;
                                              return;
                                            });
                                          }

                                          setState(() {
                                            if (Pay_Typ_Tota_Amt_Controller
                                                .text ==
                                                "0.000") {
                                              setState(() {
                                                print("inn");
                                                TotalAmtController.text =
                                                "Amount paid";
                                                Itm_Tbl_DeleteBttn_Visible =
                                                false;
                                              });
                                            } else {}
                                          });
                                          var k = await PaymentCompleted();
                                          if (k == true) {
                                            Navigator.pop(context);
                                            IBSave(IBD);
                                          }
                                        },
                                        child: Text(
                                          (ButtonName), //OK
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),



                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, right: 10),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          print("  Back  ");
                                          setState(() {
                                            Pay_Frm_Reset();
                                            PaymentAmtPopupVisilbe = false;
                                            PaymentPopupVisilbe = true;
                                            Pay_Typ_OthAmt_TxtBx_Visible =
                                            false;
                                          });
                                          PaymentName = "";
                                        },
                                        child: Stack(
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5,
                                                    top: 5,
                                                    bottom: 5,
                                                    right: 5),
                                                child: Text(
                                                  ("BACK"),
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.white,
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ]),
                        ),

                        //-------------------Payment typ credit-----------------------------------

                        Visibility(
                            visible: Payment_Credit_Visilbe == true,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 60),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          child: TypeAheadField(
                                              textFieldConfiguration:
                                              TextFieldConfiguration(
                                                  style: TextStyle(),
                                                  controller:
                                                  customerController,
                                                  decoration:
                                                  InputDecoration(
                                                    errorStyle: TextStyle(
                                                        color: Colors.red),
                                                    errorText: customerSelect ==
                                                        true
                                                        ? "Please Select Customer ?"
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
                                                          customerController
                                                              .text = "";
                                                          customerId = 0;
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
                                                            14.0)),
                                                    // i need very low size height
                                                    labelText:
                                                    'customer search', // i need to decrease height
                                                  )),
                                              suggestionsBoxDecoration:
                                              SuggestionsBoxDecoration(
                                                  elevation: 90.0),
                                              suggestionsCallback: (pattern) {
                                                return users.where((user) =>
                                                    user.lhName
                                                        .toUpperCase()
                                                        .contains(pattern
                                                        .toUpperCase()));
                                              },
                                              itemBuilder:
                                                  (context, suggestion) {
                                                return Card(
                                                  color: Colors.blue,
                                                  // shadowColor: Colors.blue,
                                                  // So you upgraded flutter recently?
                                                  // i upgarded more times
                                                  // flutter cleaned
                                                  // get pubed
                                                  // outdated more times..try
                                                  // but now result to bad...
                                                  child: ListTile(
                                                    // focusColor: Colors.blue,
                                                    // hoverColor: Colors.red,
                                                    title: Text(
                                                      suggestion.lhName,
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                );
                                              },
                                              onSuggestionSelected:
                                                  (suggestion) {
                                                print(suggestion.lhName);
                                                print("selected");

                                                customerController.text =
                                                    suggestion.lhName;
                                                print("close.... $customerId");
                                                customerId = 0;
                                                Customername =
                                                    suggestion.lhName;
                                                print(suggestion.id);
                                                print(".......customerId");
                                                customerId = suggestion.id;
                                                print(customerId);
                                                print("...........");
                                              },
                                              errorBuilder: (BuildContext
                                              context,
                                                  Object error) =>
                                                  Text('$error',
                                                      style: TextStyle(
                                                          color:
                                                          Theme.of(context)
                                                              .errorColor)),
                                              transitionBuilder: (context,
                                                  suggestionsBox,
                                                  animationController) =>
                                                  FadeTransition(
                                                    child: suggestionsBox,
                                                    opacity: CurvedAnimation(
                                                        parent:
                                                        animationController,
                                                        curve:
                                                        Curves.elasticIn),
                                                  ))),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller:
                                          Pay_Typ_Credit_Ph_Controller,
                                          enabled: true,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r"^\d+\.?\d{0,2}")),
                                          ],
                                          keyboardType: TextInputType.number,
                                          cursorColor: Colors.black,
                                          scrollPadding:
                                          EdgeInsets.fromLTRB(0, 20, 20, 0),
                                          decoration: InputDecoration(
                                            errorStyle:
                                            TextStyle(color: Colors.red),
                                            errorText:
                                            Pay_Typ_Credit_Ph_Valid == true
                                                ? "Invalid PH Number"
                                                : null,
                                            isDense: true,
                                            contentPadding: EdgeInsets.fromLTRB(
                                                20.0, 10.0, 20.0, 16.0),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    14.0)),
                                            hintStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15),
                                            labelText: "PH Number",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        //------------credit---ok  and Back Buttons-----------------------------
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              setState(() {
                                                print(customerController.text);
                                                if (Pay_Typ_Credit_Ph_Controller
                                                    .text ==
                                                    "") {
                                                  Pay_Typ_Credit_Ph_Valid =
                                                  true;
                                                }
                                                if (customerController.text ==
                                                    "") {
                                                  customerSelect = true;
                                                  return;
                                                }
                                              });
                                              if (customerController.text !=
                                                  "" &&
                                                  Pay_Typ_Credit_Ph_Controller
                                                      .text !=
                                                      "") {
                                                TotalAmtController.text =
                                                "Credited";

                                                var k =
                                                await PaymentCompleted();
                                                if (k == true) {
                                                  Navigator.pop(context);
                                                  IBSave(IBD);
                                                }
                                              }
                                            },
                                            child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5,
                                                    top: 5,
                                                    bottom: 5,
                                                    right: 5),
                                                child: Text(
                                                  (ButtonName), //OK
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.white,
                                                  ),
                                                )),
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(

                                            onPressed: () {
                                              print(" Back ");
                                              setState(() {
                                                Pay_Frm_Reset();

                                                PaymentAmtPopupVisilbe = false;
                                                PaymentPopupVisilbe = true;
                                                Pay_Typ_OthAmt_TxtBx_Visible =
                                                false;
                                              });
                                              PaymentName = "";
                                            },
                                            child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5,
                                                    top: 5,
                                                    bottom: 5,
                                                    right: 5),
                                                child: Text(
                                                  ("BACK"),
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.white,
                                                  ),
                                                )),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ])),
                ],
              ),
            ]);
          });
        });
  }

//-------------------------Set--Payment Type--- End-----------------------------------------

//------------------------ Paymet Form Rest-------------
  Pay_Frm_Reset() {
    setState(() {
      PaymentPopupVisilbe = false;
      PaymentAmtPopupVisilbe = true;
      Pay_Typ_Cash_Valid = false;
      Pay_Typ_OthAmt_Valid = false;
      Pay_Typ_Cash_Controller.text = "";
      Pay_Typ_OthAmt_Controller.text = "";
      DisPerController.text = "";
      DisAmtController.text = "";
      Pay_Typ_Tota_Amt_Controller.text = TotalAmtController.text;
      Pay_Typ_cash = 0.00;
      Pay_Typ_Disamt = 0.00;
      Pay_Typ_RoundOff = 0.00;
      Pay_Typ_Other_cash = 0.00;
      Pay_Typ_OthAmt_Controller.text = "";
      RoundOffController.text = "";
      customerSelect = false;
      Pay_Typ_Credit_Ph_Valid = false;
      Pay_Typ_Credit_Ph_Controller.text = "";
      customerController.text = "";
      Payment_Credit_Visilbe = false;
    });
  }

//------------------------  Payment Completed-------------
  PaymentCompleted() {
    if (Pay_Typ_Tota_Amt_Controller.text == "0.000" &&
        Pay_Typ_OthAmt_TxtBx_Visible == false) {
      print("On Cash");
      // print("Pay_Typ_Cash_Controller.text");
      // print(Pay_Typ_Cash_Controller.text);

      // print("Pay_Typ_OthAmt_Controller.text");
      // print(Pay_Typ_OthAmt_Controller.text);

      // print("DisPerController.text");
      // print(DisPerController.text);

      // print(" DisAmtController ");
      // print(DisAmtController.text);

      print("Pay_Typ_cash  ");
      print(Pay_Typ_cash.toString());

      print(" Pay_Typ_Disamt ");
      print(Pay_Typ_Disamt.toString());

      print(" Pay_Typ_RoundOff ");
      print(Pay_Typ_RoundOff.toString());

      print(" Pay_Typ_Other_cash ");
      print(Pay_Typ_Other_cash.toString());
      Pay_Typ_Other_cash = 0.00;
      Customername = "xx";
      customerId = null;

      // print(" Pay_Typ_OthAmt_Controller ");
      // print(Pay_Typ_OthAmt_Controller.text);

      // print(" RoundOffController ");
      // print(RoundOffController.text);

      // print(" Pay_Typ_Credit_Ph_Controller ");
      // print(Pay_Typ_Credit_Ph_Controller.text);

      // print("customerController  ");
      // print(customerController.text);

      return true;
    } else if (Pay_Typ_Tota_Amt_Controller.text == "0.000" &&
        Pay_Typ_OthAmt_TxtBx_Visible == true &&
        Pay_Typ_OthAmt_Controller.text != "") {
      print("On Cash And other Amount");
      Customername = "xx";
      customerId = 0;
      return true;
    } else if (Pay_Typ_OthAmt_TxtBx_Visible == false &&
        Payment_Credit_Visilbe == true) {
      print("On Credit");
      Pay_Typ_cash = 0;
      Pay_Typ_Disamt = 0;
      Pay_Typ_RoundOff = 0;
      Pay_Typ_Other_cash = 0;
      return true;
    }

    print(" exit PaymentCompleted not satisfy");
  }

  //------------------------PaymentCompleted-------------



  //----------------------------- GetExisting_data_Of_Tablenum--adn Ordernum-----------------------------
  TextEditingController PerviousBillPrint_Controller=TextEditingController();
  TextEditingController PrinterIpOffline=TextEditingController();
  TextEditingController PrinterIpOfflineKot=TextEditingController();


  var  Perv_Bill_Id;

  AddPrinterPopup(){
    if(Perv_Bill_Id.toString()!="null"){
      setState(() {
        PerviousBillPrint_Controller.text= Perv_Bill_Id;
      });

    }
    bool PerviousBillPrint_Validation=false;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context)
        {
          return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title:Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text('Printer Ip')),

                      IconButton(icon: Icon(Icons.close,size: 30,), onPressed: (){ Navigator.pop(context);},color: Colors.red,)

                    ],),
                  actions: [
                    SizedBox(
                        width: 300,
                        child: Row(children: [
                          Expanded(child: cw.CUButton(name: "Ok",H: 40,color: Colors.lightGreen,W: 60,function: (){
                            setState(() {
                              printerIptoLocal();

                              GeneralSettings();
                              Navigator.pop(context);
                            });
                          })),
                          Spacer(),
                          Expanded(child: cw.CUButton(name: "CLEAR",H: 40,color: Colors.deepPurpleAccent,W: 60,function: (){
                            setState(() {
                              PrinterIpOffline.text="";
                              PrinterIpOfflineKot.text="";
                            });
                          }))
                        ],)) ],
                  content:SizedBox(height: 160,
                    width: 300,
                    child: Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: PrinterIpOfflineKot,
                              enabled: true,
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                if (v!.isEmpty) return "Required";
                                return null;
                              },
                              cursorColor: Colors.black,
                              scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                              decoration: InputDecoration(
                                //  isDense: true,
                                  contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14.0)),
                                  hintStyle: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                  labelText: "Enter KOTPrinter Ip",
                                  labelStyle: TextStyle(fontSize: 13)
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: PrinterIpOffline,
                              enabled: true,
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                if (v!.isEmpty) return "Required";
                                return null;
                              },
                              cursorColor: Colors.black,
                              scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                              decoration: InputDecoration(
                                  //  isDense: true,
                                  contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14.0)),
                                  hintStyle: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                  labelText: "Enter CounterPrinter Ip",
                                  labelStyle: TextStyle(fontSize: 13)
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),),
                );
              });
        });
}
  TabelNumDatapopup(){
    if(Perv_Bill_Id.toString()!="null"){
      setState(() {
        PerviousBillPrint_Controller.text= Perv_Bill_Id;
      });

    }
    bool PerviousBillPrint_Validation=false;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context)
        {
          return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title:Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text('Previous Bill Print')),

                      IconButton(icon: Icon(Icons.close,size: 30,), onPressed: (){ Navigator.pop(context);},color: Colors.red,)

                    ],),
                  actions: [
                    SizedBox(
                        width: 300,
                        child: Row(children: [
                          Expanded(child: cw.CUButton(name: "OK",H: 40,color: Colors.green,W: 60,function: (){
                            if(PerviousBillPrint_Controller.text==""){
                              setState((){
                                PerviousBillPrint_Validation=true;
                              });
                              return;
                            }
                            else{
                              setState((){
                                PerviousBillPrint_Validation=false;
                                GetPrintdatas(PerviousBillPrint_Controller.text,"Tax Invoide (Copy)");
                                Navigator.pop(context);

                              });

                            }
                          })),
                          Spacer(),
                          Expanded(child: cw.CUButton(name: "CLEAR",H: 40,color: Colors.deepPurpleAccent,W: 60,function: (){
                            setState(() {
                              PerviousBillPrint_Controller.text="";
                            });
                          }))
                        ],)) ],
                  content:SizedBox(height: 100,
                    width: 300,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: PerviousBillPrint_Controller,
                          enabled: true,
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v!.isEmpty) return "Required";
                            return null;
                          },
                          cursorColor: Colors.black,
                          scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                          inputFormatters: <TextInputFormatter>[],
                          decoration: InputDecoration(
                              errorStyle: TextStyle(color: Colors.red),
                              errorText: PerviousBillPrint_Validation == true ? "Invalid" : null,
                              //  isDense: true,
                              contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14.0)),
                              hintStyle: TextStyle(
                                  color: Colors.black, fontSize: 15),
                              labelText: "Bill Number",
                              labelStyle: TextStyle(fontSize: 13)
                          ),
                        ),
                      ),
                    ),) ,
                );
              });
        });
  }




  //-----Get Perviouse Bill Id---

  Get_PerviousBill_Id()async{

    try {
      print("Get_PerviousBill_Id  ");
      final res =
      await http.get("${Env.baseUrl}SalesHeaders" as Uri, headers: {
        "Authorization": user.user["token"],
      });
      if(res.statusCode<203){
        var Get_PerviousBill_Data =await jsonDecode(res.body);
        setState(() {
          print(Get_PerviousBill_Data[0]["voucherNo"].toString());
          setState(() {
            Perv_Bill_Id=Get_PerviousBill_Data[0]["voucherNo"].toString();
          });

          print( "on footerCaptions :" +footerCaptions.toString());
        });
      }


    } catch (e) {
      print(e);
    }


  }



  // GetTabelNumData(txtbox)async{
  //   print("text box");
  //   print(txtbox.toString());
  //   var res;
  //   print(TablenumController.text);
  //
  //
  //   if(txtbox=="Order No"){
  //     var Ordernum=OrderumController.text;
  //     res=await cw.CUget_With_Parm(api:"Soheader/$Ordernum/orderno",Token: token);
  //   }
  //   else if(txtbox=="Table No"){
  //     var Tablenum=TablenumController.text;
  //     res=await cw.CUget_With_Parm(api:"Soheader/$Tablenum/tableno",Token: token);
  //   }
  //   else{
  //     var Bill_No=Bill_No_Controller.text;
  //     res=await cw.CUget_With_Parm(api:"SalesHeaders/$Bill_No/billcopy",Token: token);
  //
  //   }
  //
  //   if(res!=false){
  //     setState(() {
  //       IBD.clear();
  //       TD.clear();
  //       TotalAmtController.text = "";
  //       TotalAmt=0.0;
  //
  //     });
  //     var TextBoxget=json.decode(res);
  //     print("get datas");
  //     print(TextBoxget.toString());
  //
  //     if(txtbox=="Bill No"){
  //       print("on Bill No:     "+TextBoxget.toString());
  //       print("on Bill No:     "+TextBoxget['salesHeader'][0]['id'].toString());
  //       setState(() {
  //         EditId=TextBoxget['salesHeader'][0]['id'];
  //         PaymentTypID=TextBoxget['salesHeader'][0]['paymentType'];
  //         Token_Num=TextBoxget['salesHeader'][0]['tokenNo'].toString();
  //         Customername=TextBoxget['salesHeader'][0]['partyName'].toString();
  //         // customerId=TextBoxget['salesHeader'][0]['voucherNo'];
  //         // OrderumController.text=TextBoxget['salesHeader'][0]['voucherNo'].toString();
  //         TokennumController.text=TextBoxget['salesHeader'][0]['tokenNo'].toString();
  //         TablenumController.text=TextBoxget['salesHeader'][0]['deliveryTo'].toString();
  //         // EditId=TextBoxget['id'];
  //         ButtonName="Update";
  //         // print("------------------------------------");
  //         // print("EditId");
  //         // print(EditId);
  //         // print("PaymentTypID");
  //         // print(PaymentTypID);
  //         // print("Token_Num");
  //         // print(Token_Num);
  //         // print("Customername");
  //         // print(Customername);
  //         TabelNumDataBinding(TextBoxget['salesDetails'],txtbox);
  //       });
  //     }
  //     else if(TextBoxget['data']['isSale']==null||TextBoxget['data']['isSale']==false)
  //     {
  //       EditId=null;
  //       print("TextBoxget: "+TextBoxget.toString());
  //       TabelNumDataBinding(TextBoxget['data']['sodetailed'],txtbox);
  //       setState(() {
  //         OrderumController.text=TextBoxget['data']['voucherNo'].toString();
  //         TokennumController.text=TextBoxget['data']['tokenNo'].toString();
  //         TablenumController.text=TextBoxget['data']['deliveryTo'].toString();
  //       });
  //
  //     }
  //     else{
  //       cw.MessagePopup(context, "Bill Already Generated", Colors.red.shade300);
  //       listabledataShow=false;
  //     }
  //   }
  //   else{
  //     TotalAmt=0.0;
  //     IBD.clear();
  //     TD.clear();
  //     listabledataShow=false;
  //     TotalAmtController.text=TotalAmt.toString();
  //     getTokenNo();
  //     //GetOrderNum();
  //     ButtonName="Save";
  //   }
  //
  // }




//   TabelNumDataBinding(a,typ){
//     print("aaaaa");
//     print(EditId.toString());
//
//     for(int i=0;i<a.length;i++){
//
//       // print(a[i]['itemName']);
//
//
//       ItmBLdata = ItmBillDetails(
//
//           ItemSlNo:i,
//           itemId: a[i]['itemId'],
//           qty: a[i]['qty'],
//           rate: a[i]['rate'],
//           disPercentage: discper,
//           cgstPercentage: a[i]['cgstPercentage'],
//           sgstPercentage: a[i]['sgstPercentage'],
//           cessPercentage: a[i]['cessPercentage'],
//           discountAmount: a[i]['discountAmount'],
//           cgstAmount: a[i]['CgstPercentage'] == null
//               ? "0"
//               : (total / 100) * a[i]['CgstPercentage'],
//           sgstAmount: a[i]['SgstPercentage'] == null
//               ? "0"
//               : (total / 100) * a[i]['SgstPercentage'],
//           cessAmount: 0,
//           igstPercentage: a[i]['Igstpercentage'],
//           igstAmount: a[i]['Igstpercentage'] == null
//               ? "0"
//               : (total / 100) * UomTableData['Igstpercentage'],
//           taxPercentage: a[i]['txPercentage'],
//           taxAmount: a[i]['taxAmount'],
//           taxInclusive: a[i]['taxInclusive'],
//           amountBeforeTax: a[i]['amountBeforeTax'],
//           amountIncludingTax: a[i]['amountIncludingTax'],
//           netTotal: a[i]['netTotal'],
//           hsncode: a[i]['hsncode'],
//           gdnId:null,// a[i]['itemid'],
//           taxId: a[i]['taxId'],
//           rackId:null,// a[i]['itemid'],
//           addTaxId: a[i]['addTaxId'],
//           unitId: a[i]['unitId'],
//           nosInUnit:null,// a[i]['itemid'],
//           //ele.Nos_In_Unit,
//           barcode:null,// a[i]['itemid'],
//           //
//           StockId: a[i]['stockId'],
//           BatchNo:null,// a[i]['unitId'],
//           ExpiryDate:null, //a[i]['unitId'],
//           Notes: a[i]['note'],
//           adlDiscAmount: a[i]['adlDiscAmount'],
//           adlDiscPercent: a[i]['adlDiscPercent'],
//           shid: EditId
//       );
//       setState(() {
//         IBD.add(ItmBLdata);
//       });
//       print("-----------------------------------");
//       print(json.encode(IBD));
//
//       TDdata = Del_Tabledata(
//
//         id: a[i]['itemid'],
//         ItemSlNo: i,
//         Name:typ=="Bill No"?a[i]['itmName']:a[i]['itemName'],
//         // Name: a[i]['itemName'],
//         Qty: a[i]['qty'],
//         rate: a[i]['rate'],
//         Total: a[i]['netTotal'],
//         UOM:typ=="Bill No"?a[i]['uom']:a[i]['description'],
//         //UOM: a[i]['description'],
//         AmtWithTax:a[i]['amountIncludingTax'],
//       );
//       setState(() {
//         TD.add(TDdata);
//       });
//
// // print("-----------------------------------");
// //   print(json.encode(ItmBLdata));
//       print("total amountt" + a[i]['amountIncludingTax']);
//       TotalAmt=a[i]['amountIncludingTax'];
//       setState(() {
//
//         TotalAmtController.text=TotalAmt.toString();
//       });
//       slnum=i;
//     }
//     listabledataShow = true;
//   }




  var ScreenSettings_Data;
  int ItemGrp_Column_Num=3;
  int Item_Column_Num=3;
  bool Item_TextBold=false;
  bool ItemGrp_TextBold=false;
  GetScreenSettings()async{


    String url = "${Env.baseUrl}RmsSettings";
    try {
      final res =
      await http.get(url as Uri, headers: {"Authorization": user.user["token"]});

      print("GetScreenSettings");
      print(res.body);

      print("json decoded");

      var tagsJson = json.decode(res.body);
      ScreenSettings_Data = tagsJson;
      print("ScreenSettings_Data");
      print(ScreenSettings_Data[0]["mobileBillItemGroupColumnCount"]);

      setState(() {
        ItemGrp_Column_Num=ScreenSettings_Data[0]["mobileBillItemGroupColumnCount"];
        Item_Column_Num=ScreenSettings_Data[0]["mobileBillItemColumnCount"];
        ItemGrp_TextBold =ScreenSettings_Data[0]["mobileBillItemGroupColumnFontBold"];
        Item_TextBold=ScreenSettings_Data[0]["mobileBillItemColumnFontBold"];
      });


    } catch (e) {
      print("error on GetScreenSettings $e");
    }

  }


  ///-----------------------------------------------------All functions End---------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width > 500
        ? WillPopScope(
      onWillPop: () async {

        BAckButton();


        return false;
      },
      child: SafeArea(
          child: Scaffold(
            //  resizeToAvoidBottomInset:false ,
            //-----------------bottomNavigationBar -----Save And Pay buttons------------------------

            appBar:  PreferredSize(
                preferredSize: Size.fromHeight(80.0),
                child: CustomAppbarForItemBill(
                  branch: branchName,
                  pref: pref,
                  title: "Items",
                  uname: userName,
                )
              // Appbarcustomwidget(
              //   branch: branchName,
              //   pref: pref,
              //   title: "Items",
              //   uname: userName,
              // )
            ),


            bottomNavigationBar:  Container(
              // color: Color(0xFFFDF4F4),
              child: Row(
                children: [
                  // Expanded(
                  //   child: Padding(
                  //     padding:
                  //     const EdgeInsets.only(left: 10, bottom: 2, top: 5),
                  //     child: RaisedButton(
                  //       color: Colors.blue,
                  //       onPressed: () {
                  //         print("onSave");
                  //         print(jsonEncode(IBD));
                  //         IBSave(IBD);
                  //       },
                  //       child: Stack(
                  //         children: [
                  //           Padding(
                  //               padding: EdgeInsets.only(
                  //                   left: 5, top: 5, bottom: 2, right: 5),
                  //               child: Text(
                  //                 ("Saves"),
                  //                 style: TextStyle(
                  //                   fontSize: 20.0,
                  //                   color: Colors.white,
                  //                 ),
                  //               )),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  Expanded(
                    child: Padding(
                      padding:
                      const EdgeInsets.only(left: 10, bottom: 2, top: 5),
                      child: ElevatedButton(
                        style:ButtonStyle(backgroundColor:MaterialStateProperty.all(Colors.green.shade800)) ,

                        onPressed: () async {
                          print("Payment Types");
                          PaymentName = "";
                          Get_DetailsSaveData();
                          Cust_Details=await Cu_Det.initialFunction(context, setState,Customer_ph_detils);
                          print("result of");
                          print(Cust_Details);
                          if(Cust_Details!=null){
                            if(Payment_TypShow==true){
                              SetPaymentType();
                            }
                            else {
                              TotalAmtController.text =
                              "Amount paid";
                              IBSave(IBD);
                            }
                          }
                          // SetPaymentType();
                          PaymentAmtPopupVisilbe = false;
                          Pay_Typ_Cash_Valid = false;
                        },
                        child: Stack(
                          children: [
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 5, top: 5, bottom: 5, right: 5),
                                child: Text(
                                  (ButtonName),
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10, bottom: 5, right: 5, top: 10),
                        child:
                        ElevatedButton(
                            style:ButtonStyle(backgroundColor:MaterialStateProperty.all(Colors.red.shade400)) ,
                            onPressed: () {
                              // TestReplace();
                              Reset();
                            }, child: Text("Reset", style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,

                        ),)),
                      )),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 5, bottom: 2, right: 2, top: 10),
                      child:
                      Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: TextFormField(
                          keyboardType:TextInputType.number,
                          controller: textController,
                          cursorColor: Colors.black,
                          scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              errorStyle: TextStyle(color: Colors.red),
                              isDense: true,
                              contentPadding:
                              EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 16.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14.0)),
                              hintStyle:
                              TextStyle(color: Colors.black, fontSize: 15),
                              labelText: "PrintNo"
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, bottom: 5, right: 5, top: 10),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: TextFormField(
                          controller: TotalAmtController,
                          readOnly: true,
                          enabled: false,
                          validator: (v) {
                            if (v!.isEmpty) return "Required";
                            return null;
                          },
                          cursorColor: Colors.black,
                          scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            errorStyle: TextStyle(color: Colors.red),
                            //  errorText:TokennumController  ? "Invalid" : null,
//                    suffixIcon: Icon(
//                      Icons.calendar_today,
//                      color: Colors.blue,
//                      size: 24,
//                    ),
                            isDense: true,

                            contentPadding:
                            EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 16.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.0)),
                            hintStyle:
                            TextStyle(color: Colors.black, fontSize: 15),
                            labelText: "Total",
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, bottom: 5, right: 5, top: 10),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: TextFormField(

                          controller: DiscTotalAmtController,
                          readOnly: true,
                          enabled: false,
                          validator: (v) {
                            if (v!.isEmpty) return "Required";
                            return null;
                          },
                          cursorColor: Colors.black,
                          scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            errorStyle: TextStyle(color: Colors.red),
                            isDense: true,
                            contentPadding:
                            EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 16.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.0)),
                            hintStyle:
                            TextStyle(color: Colors.black, fontSize: 15),
                            labelText: "DiscTotal",
                          ),
                        ),
                      ),
                    ),
                  ),
                   Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10, bottom: 5, right: 5, top: 10),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: TextFormField(
                            keyboardType:TextInputType.number ,
                            controller: DeliveryChargeController,
                            readOnly: false,
                            enabled: true,

                            // onTap: (){
                            //
                            //   showDialog(context: context, builder: (context) =>
                            //       StatefulBuilder(
                            //           builder: (context, setState) {
                            //             return AlertDialog(
                            //               content:TextFormField() ,
                            //             );
                            //           }
                            //       ));
                            // },

                            onChanged: (a){
                              double DelAmt;
                              a==""?DelAmt:DelAmt=double.parse(a);
                              setState(() {
                                if(DelAmt==null)
                                  {
                                    print("double don" + DelAmt.toString());
                                   var FinalAnt=TotalAmt;
                                   print("sasdfd " + discact.toString());


                                     TotalAmtController.text=FinalAnt.toString();
                                    if(discact==true){
                                      print("sdfsadfas " + discper.toString());
                                      DiscTotalAmtController.text=FinalAnt-((FinalAnt*discper)/100.00);
                                    }


                                  }
                                else{
                                  print("its a part of else");


                                    var FinalAnt=TotalAmt+DelAmt;
                                    TotalAmtController.text=FinalAnt.toString();
                                  if(discact==true){
                                    var FinalAnt=(TotalAmt - ((TotalAmt *discper)/100.00)) +DelAmt;
                                    DiscTotalAmtController.text=FinalAnt.toString();
                                  }

                                }
                              });
                            },
                            validator: (v) {
                              if (v!.isEmpty) return "Required";
                              return null;
                            },
                            cursorColor: Colors.black,
                            scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              errorStyle: TextStyle(color: Colors.red),
                              //  errorText:TokennumController  ? "Invalid" : null,
//                    suffixIcon: Icon(
//                      Icons.calendar_today,
//                      color: Colors.blue,
//                      size: 24,
//                    ),
                              isDense: true,

                              contentPadding:
                              EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 16.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14.0)),
                              hintStyle:
                              TextStyle(color: Colors.black, fontSize: 15),
                              labelText: "Delivery Charge",
                            ),
                          ),
                        ),
                      ),
                    ),






                ],
              ),
            ),




            body: ListView(
                shrinkWrap: true,
                //physics: NeverScrollableScrollPhysics(),
                children: [
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Column(
                            children: [
                              Row(children: [
                                SizedBox(
                                  height: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        print("uikuy");
                                        //print(MediaQuery.of(context).size.width.toString());
                                        // wifiprinting();
                                      },
                                      child: Text(
                                        "Item Group",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TypeAheadField(
                                          textFieldConfiguration:
                                          TextFieldConfiguration(
                                              style: TextStyle(),
                                              controller: ItemGrpController,
                                              decoration: InputDecoration(
                                                errorStyle: TextStyle(
                                                    color: Colors.red),
                                                errorText: itemSelectvalidate
                                                    ? "Please Select Item  Group?"
                                                    : null,
//                            errorText: _validateName ? "please enter name" : null,
//                            errorBorder:InputBorder.none ,
                                                suffixIcon: IconButton(
                                                  icon: Icon(
                                                      Icons.remove_circle),
                                                  color: Colors.blue,
                                                  onPressed: () {
                                                    setState(() {
                                                      print("cleared");
                                                      ItemGrpController
                                                          .text = "";
                                                      ItemGrpId = 0;
                                                      itmLstVsbl = false;
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
                                                        14.0)),
                                                labelText:
                                                'Item Group search',
                                              )),
                                          suggestionsBoxDecoration:
                                          SuggestionsBoxDecoration(
                                              elevation: 0.0),
                                          suggestionsCallback: (pattern) {
                                            return ItmGrp.where((user) => user.igDescription.trim().toLowerCase()
                                                .contains(pattern.trim().toLowerCase()));
                                          },
                                          itemBuilder: (context, suggestion) {
                                            return Card(
                                              margin: EdgeInsets.only(
                                                  top: 2, right: 2, left: 2),
                                              color: Colors.blue,
                                              child: ListTile(
                                                // focusColor: Colors.blue,
                                                // hoverColor: Colors.red,
                                                title: Text(
                                                  suggestion.igDescription,
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            );
                                          },
                                          onSuggestionSelected: (suggestion) {
                                            print(suggestion.igDescription);
                                            print("selected");
                                            setState(() {
                                              getItem(suggestion.id);
                                              ItemGrpController.text =
                                                  (suggestion.igDescription)
                                                      .toString();
                                              ItemLstController.text = "";
                                            });

                                            print("...........");
                                          },
                                          errorBuilder: (BuildContext context,
                                              Object error) =>
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
                                                    parent: animationController,
                                                    curve: Curves.elasticIn),
                                              )),
                                    )),
                                Text("Image"),
                                Checkbox(
                                  value:imageSetting,
                                  onChanged: (bool value) {
                                    setState(() {
                                      imageSetting = !imageSetting;
                                    });
                                  },
                                ),
                              ]),

                              Visibility(
                                visible: itmGrpVsbl == true,
                                // visible:ItmGrp.length>0 ,
                                child: Container(
                                  height: 280,
                                  child: imageSetting == false
                                      ?
                                  //----------------------Condition for button or image----------------------------

//  for text.....................

                                  GridView.builder(
                                    physics: ScrollPhysics(),
                                    itemCount: ItmGrp.length,
                                    shrinkWrap: true,
                                    gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: ItemGrp_Column_Num,//--------Dynaminc Button Wrap-ItemGrp------------
                                        mainAxisExtent: 65),
                                    itemBuilder: (c, i) {
                                      return Padding(
                                        padding:
                                        const EdgeInsets.all(
                                            8.0),
                                        child: RaisedButton(
                                          splashColor:
                                          Colors.blueAccent,
                                          hoverColor: Colors.black,
                                          color:ItemGrp_Selected_index==i?Colors.indigo:Colors.teal,
                                          onPressed: () {
                                            print("index 2:  " +
                                              (btnItmGrp[i][
                                              "igDescription"])
                                                  .toString());
                                          setState(() {
                                            Item_Selected_index = null;
                                                 ItemGrp_Selected_index = i;
                                                 TablenumValid = false;
                                            getItem((btnItmGrp[i]
                                            ["id"]));
                                            ItemLstController.text =
                                            "";
                                            ItemGrpController
                                                .text = (btnItmGrp[
                                            i][
                                            "igDescription"])
                                                .toString();
                                          });
                                          },
                                          child: Padding(
                                              padding: EdgeInsets
                                                  .only(
                                                  left: 0,
                                                  top: 5,
                                                  bottom: 5,
                                                  right: 0),
                                              child: Text(
                                                (btnItmGrp[i]["igDescription"]).toString(),
                                                style: TextStyle(
                                                    fontWeight:ItemGrp_TextBold==true ?FontWeight.bold: FontWeight.w500,
                                                    fontSize:17.0,
                                                    color: Colors.white),
                                                textAlign: TextAlign.center,

                                              )),
                                        ),
                                      );
                                    },
                                  )
                                      :
//  ---for image............
                                  GridView.builder(
                                    physics: ScrollPhysics(),
                                    itemCount: ItmGrp.length,
                                    shrinkWrap: true,
                                    gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisExtent: 80),
                                    itemBuilder: (c, i) {
                                      return Padding(
                                        padding:
                                        const EdgeInsets.all(5.0),
                                        child: RaisedButton(
                                          shape:
                                          RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius
                                                  .circular(
                                                  30)),
                                          splashColor:
                                          Colors.blueAccent,
                                          hoverColor: Colors.black,
                                          // color: Color.fromARGB(
                                          //     255, 255, 255, 255),
                                          onPressed: () {
                                            print("index 2:  " +
                                                (btnItmGrp[i][
                                                "igDescription"])
                                                    .toString());
                                            setState(() {
                                              getItem((btnItmGrp[i]
                                              ["id"]));
                                              ItemLstController.text =
                                              "";
                                              ItemGrpController
                                                  .text = (btnItmGrp[
                                              i][
                                              "igDescription"])
                                                  .toString();
                                            });
                                          },
                                       ),
                                      );
                                    },
                                  ),
                                ),
                              ),

                              //-------------------------------------Item Grp End-------------------------------------------

                              Visibility(
                                visible: itmLstVsbl == true,
                                child: Divider(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),

                              //------------------------------------Fot Item---------------------------------------------------------
                              Visibility(
                                visible: itmLstVsbl == true,
                                child: Row(children: [
                                  SizedBox(
                                    height: 50,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 10, right: 70),
                                      child: Text(
                                        "Item",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TypeAheadField(
                                            textFieldConfiguration:
                                            TextFieldConfiguration(
                                                style: TextStyle(),
                                                controller:
                                                ItemLstController,
                                                decoration: InputDecoration(
                                                  errorStyle: TextStyle(
                                                      color: Colors.red),
                                                  errorText: itemSelectvalidate
                                                      ? "Please Select Item ?"
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
                                                        ItemLstController
                                                            .text = "";
                                                        ItemGrpId = 0;
                                                        quantityController
                                                            .text = "1";
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
                                                          14.0)),
                                                  labelText: 'Item search',
                                                )),
                                            suggestionsBoxDecoration:
                                            SuggestionsBoxDecoration(
                                                elevation: 90.0),
                                            suggestionsCallback: (pattern) {
                                              return ItmLst.where((user) =>
                                                  user.itmName.trim().toLowerCase().contains(
                                                      pattern.trim().toLowerCase()));
                                            },
                                            itemBuilder: (context, suggestion) {
                                              return Card(
                                                margin: EdgeInsets.only(
                                                    top: 2, right: 2, left: 2),
                                                color: Colors.blue,
                                                child: ListTile(
                                                  // focusColor: Colors.blue,
                                                  // hoverColor: Colors.red,
                                                  title: Text(
                                                    suggestion.itmName,
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              );
                                            },
                                            onSuggestionSelected: (suggestion) {
                                              print(suggestion.itmName);
                                              print("selected");
                                              print(json
                                                  .encode(suggestion)
                                                  .toString());

                                              var itm_data =
                                              jsonEncode(suggestion);
                                              setState(() {
                                                ItemLstController.text =
                                                    (suggestion.itmName)
                                                        .toString();
                                                ListoTable(
                                                    jsonDecode(itm_data));
                                              });

                                              print("...........");
                                            },
                                            errorBuilder: (BuildContext context,
                                                Object error) =>
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
                                                      animationController,
                                                      curve: Curves.elasticIn),
                                                )),
                                      )),
                                ]), // headig of item grp
                              ),

                              Visibility(
                                visible: itmLstVsbl == true,
                                child: Container(
                                  height: 280,
                                  child: imageSetting == false
                                      ?
                                  //------------------------img or text----------------------------------

                                  GridView.builder(
                                    physics: ScrollPhysics(),
                                    itemCount: ItmLst.length,
                                    shrinkWrap: true,
                                    gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(

                                      crossAxisCount:Item_Column_Num??2,
                                      //ScreenSettings_Data[0]==true ?2: 3,//--------Dynaminc Button Wrap-Item item------------
                                      mainAxisExtent: 65,
                                    ),
                                    itemBuilder: (c, i) {
                                      return Padding(
                                        padding:
                                        const EdgeInsets.all(8.0),
                                        child: RaisedButton(
                                          splashColor:
                                          Colors.blueAccent,
                                          hoverColor: Colors.black,
                                          color:Item_Selected_index==i?Colors.indigo:Colors.teal,
                                          onPressed: () {
                                            print("index 3:  " +
                                                (btnItmLst[i]
                                                ["itmName"])
                                                    .toString());

                                            setState(() {

                                              Item_Selected_index=i;
                                              ItemLstController.text =
                                                  (btnItmLst[i]
                                                  ["itmName"])
                                                      .toString();
                                              ListoTable(
                                                  btnItmLst[i]);
                                              quantityController
                                                  .text = "1";
                                              setState(() {
                                                print("opop");
                                                1 == 1
                                                    ? itemTblHight =
                                                300
                                                    : itemTblHight =
                                                null;
                                              });
                                            });
                                          },
                                          child: Stack(
                                            children: [
                                              Padding(
                                                  padding:
                                                  EdgeInsets.only(
                                                      left: 0,
                                                      top: 5,
                                                      bottom: 5,
                                                      right: 2),
                                                  child: Text(
                                                    (btnItmLst[i][
                                                    "itmName"]
                                                        .toString()),
                                                    style: TextStyle(
                                                      fontWeight:ItemGrp_TextBold==true ?FontWeight.bold: FontWeight.w500,
                                                      fontSize: 17.0,
                                                      color: Colors
                                                          .white,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                      :
//...............img...............
                                  GridView.builder(
                                    physics: ScrollPhysics(),
                                    itemCount: ItmLst.length,
                                    shrinkWrap: true,
                                    gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisExtent: 70),
                                    itemBuilder: (c, i) {
                                      return Padding(
                                        padding:
                                        const EdgeInsets.all(5.0),
                                        child: RaisedButton(
                                          elevation: 7,
                                          shape:
                                          RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius
                                                  .circular(
                                                  30)),
                                          splashColor:
                                          Colors.blueAccent,
                                          hoverColor: Colors.black,
                                          // color: Color.fromARGB(
                                          //     255, 255, 255, 255),
                                          onPressed: () {
                                            print("index 4:  " +
                                                (btnItmLst[i]
                                                ["itmName"])
                                                    .toString());
                                            setState(() {
                                              ItemLstController.text =
                                                  (btnItmLst[i]
                                                  ["itmName"])
                                                      .toString();

                                              ListoTable(btnItmLst[i]);


                                            });
                                          },
                                          child: Stack(
                                            children: [
                                              // Image.network((btnItmLst[
                                              // i][
                                              // "itmImage"]) ==
                                              //     null ||
                                              //     (btnItmLst[i][
                                              //     "itmImage"]) ==
                                              //         ""
                                              //     ? "https://st4.depositphotos.com/14953852/24787/v/600/depositphotos_247872612-stock-illustration-no-image-available-icon-vector.jpg"
                                              // //"http://erptest.qizo.in/assets/gtItmMstr/gtItmMstrimg_1180.jpg"
                                              //     : (btnItmLst[i]
                                              // ["itmImage"]),
                                              //     errorBuilder:(context, error, stackTrace) =>  Image.network("https://st4.depositphotos.com/14953852/24787/v/600/depositphotos_247872612-stock-illustration-no-image-available-icon-vector.jpg")),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              //items button list

                              Visibility(
                                  visible: Noitem == true,
                                  child: Center(
                                      child: Text(
                                        "Item Not Found..!",
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 20),
                                      ))),

                              Divider(
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),




                        SizedBox(
                          width: 8,
                        ),






                        Expanded(
                          child: Column(children: [


                            Visibility(
                              visible: listabledataShow,
                              child: Row(
                                children: [
                                  // SizedBox(
                                  //   width: 10,
                                  // ),
                                  Container(
                                    height: MediaQuery.of(context).size.width-200,
                                    width:
                                    (MediaQuery.of(context).size.width /
                                        2) -
                                        20,
                                    child:  SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        physics: ScrollPhysics(),
                                        child: DataTable(

                                          columnSpacing: 15,
                                          onSelectAll: (b) {},
                                          sortAscending: true,
                                          columns: <DataColumn>[
                                            DataColumn(
                                              label: Text('NO'),
                                            ),
                                            DataColumn(
                                              label: Text('Name'),
                                            ),
                                            DataColumn(
                                              label: Text('UOM'),
                                            ),
                                            DataColumn(
                                              label: Text('QTY'),
                                            ),
                                            DataColumn(
                                              label: Text('Rate'),
                                            ),
                                            DataColumn(
                                              label: Text('Total'),
                                            ),
                                            DataColumn(
                                              label: Text(''),
                                            ),
                                          ],
                                          rows: TD
                                              .map(
                                                (itemRow) => DataRow(
                                              cells: [
                                                DataCell(
                                                  Visibility(
                                                      visible: true,
                                                      child: Text(
                                                          getItemIndex(
                                                              itemRow)
                                                              .toString())),
                                                  showEditIcon: false,
                                                  placeholder: false,
                                                ),
                                                DataCell(

                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        child: Text(itemRow.Name
                                                            .toString()),
                                                        onLongPress: () {
                                                          setState(() {
                                                            removeListElement(
                                                                itemRow.ItemSlNo,
                                                                itemRow.AmtWithTax,
                                                                itemRow.Item_Addon_Rate
                                                            );
                                                          });
                                                        },),

                                                      itemRow.Addon_Data.toString()=="[]"?Text(""):
                                                      PopupMenuButton<int>(
                                                          icon: Icon(Icons.add_box),
                                                          onSelected:(a){
                                                            print("saf $a");
                                                          } ,
                                                          // shape: RoundedRectangleBorder(
                                                          //
                                                          //   borderRadius: BorderRadius.circular(30.0),
                                                          //
                                                          // ),
                                                          color:theam.EditpopupClr,
                                                          itemBuilder: (context) => [
                                                            PopupMenuItem(height: 30,
                                                                child:
                                                                SingleChildScrollView(
                                                                  scrollDirection: Axis.vertical,
                                                                  child: Container(
                                                                    height: 80,
                                                                    width: 170,
                                                                    child: ListView.builder(
                                                                        shrinkWrap: true,
                                                                        itemCount:itemRow.Addon_Data.length ,
                                                                        itemBuilder: (context, index) {
                                                                          return Text("${index+1} . ${itemRow.Addon_Data[index].addonItemName} \n "
                                                                              "     ${itemRow.Addon_Data[index].qty} x ${itemRow.Addon_Data[index].addonRate} = ${itemRow.Addon_Data[index].qty * itemRow.Addon_Data[index].addonRate}".toString(),style: TextStyle(color: Colors.white,fontSize: 16),);
                                                                        }
                                                                    ),

                                                                  ),
                                                                )
                                                            )
                                                          ]),


                                                      itemRow.Item_notes.toString()=="[]"?Text(""):
                                                      PopupMenuButton<int>(
                                                          icon: Icon(Icons.library_books),
                                                          onSelected:(a){
                                                            print("saf $a");
                                                          } ,
                                                          // shape: RoundedRectangleBorder(
                                                          //
                                                          //   borderRadius: BorderRadius.circular(30.0),
                                                          //
                                                          // ),
                                                          color:theam.EditpopupClr,
                                                          itemBuilder: (context) => [
                                                            PopupMenuItem(height: 30,
                                                                child:
                                                                SingleChildScrollView(
                                                                  scrollDirection: Axis.vertical,
                                                                  child: Container(
                                                                    height: 80,
                                                                    width: 170,
                                                                    child: ListView.builder(
                                                                        shrinkWrap: true,
                                                                        itemCount:itemRow.Item_notes.length ,
                                                                        itemBuilder: (context, index) {
                                                                          return Text("${index+1} . ${itemRow.Item_notes[index]["notes"]} ".toString(),style: TextStyle(color: Colors.white,fontSize: 16),);
                                                                        }
                                                                    ),

                                                                  ),
                                                                )
                                                            )
                                                          ]),

                                                    ],
                                                  ),

                                                  showEditIcon: false,
                                                  placeholder: false,
                                                ),
                                                DataCell(
                                                  Text(itemRow.UOM
                                                      .toString()),
                                                  showEditIcon: false,
                                                  placeholder: false,
                                                ),
                                                DataCell(
                                                  Text(itemRow.Qty
                                                      .toString()),
                                                  showEditIcon: false,
                                                  placeholder: false,
                                                ),
                                                DataCell(
                                                  Text((itemRow.rate)
                                                      .toString()),
                                                  showEditIcon: false,
                                                  placeholder: false,
                                                ),
                                                DataCell(
                                                  Text((itemRow
                                                      .Total) !=
                                                      null
                                                      ? itemRow.Total
                                                      .toString()
                                                      : 0.0.toString()),
                                                  showEditIcon: false,
                                                  placeholder: false,
                                                ),
                                                DataCell(
                                                  InkWell(
                                                    splashColor:
                                                    Colors.green,
                                                    // splash color
                                                    onTap: () {
                                                      setState(() {
                                                        removeListElement(
                                                            itemRow.ItemSlNo,
                                                            itemRow.AmtWithTax,
                                                            itemRow.Item_Addon_Rate
                                                        );
                                                      });
                                                    },
                                                    // button pressed
                                                    child: Icon(
                                                      Icons.delete,color: Colors.red,),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //--------------------Table End--------------------------------

                            SizedBox(
                              height: 0,
                            ),
                            Visibility(
                              visible: listabledataShow == false,
                              child: Container(
                                  height:
                                  MediaQuery.of(context).size.height /
                                      2,
                                  child: Center(
                                      child: Text(
                                        "Item Not Fount",
                                        style: TextStyle(color: Colors.red),
                                      ))),
                            ),

                            // TextButton(onPressed: (){
                            //   GetPrintdata(118);
                            // }, child: Text("Print Test"))
                          ]),
                        ),
                      ]),
                  ///-----------Table Nested row ----------------------
                ]),

          )),
    )












    ///---------------------------------------Mob-----------------------------------------------------------





        :Scaffold(
      body:   WillPopScope(
        onWillPop: () async {

          BAckButton();


          return false;
        },
        child: Container(

          color: Colors.white,

          child:   Center(



              child: Row(
                mainAxisAlignment:MainAxisAlignment.center,
                children: [

                  Text("Please Rotate your Device"),
                  Icon(Icons.rotate_left),
                ],
              )),

        ),
      ),
    );
  }


  ///----------------------print part-----------------------

  GetFooterData() async {
    try {
      print("footer data decoded  ");
      final tagsJson =
      await http.get("${Env.baseUrl}SalesInvoiceFooters/" as Uri, headers: {
        "Authorization": user.user["token"],
      });
      var footerdata =await jsonDecode(tagsJson.body);
      setState(() {
        footerCaptions = footerdata;
        print( "on footerCaptions :" +footerCaptions.toString());
      });

    } catch (e) {
      print(e);
    }
  }


  GetCompantPro(id)async{
    print("GetCompantPro");
    print(id.toString());
    try {
      final tagsJson =
      await http.get("${Env.baseUrl}MCompanyProfiles/$id" as Uri, headers: {
        //Soheader //SalesHeaders
        "Authorization": user.user["token"],
      });
      if(tagsJson.statusCode==200) {
        Companydata = await jsonDecode(tagsJson.body);

      }
      print( "on GetCompantPro :" + Companydata.toString());
      print(  Companydata['companyProfileAddress1'].toString());
    }
    catch(e){
      print("error on GetCompantPro : $e");
    }
  }


  GetPrintdatas(id ,String type)async{
    print("the id is " + id.toString());
    var res=await cw.CUget_With_Parm(api:"SalesHeaders/$id/VoucherNumber" ,Token: token);
    if(res!=false){
      print("print data result");
      log("jhgjk" + res.toString());
      dataForTicket=json.decode(res);
      print("Valueofbillcount"+ Bill_Counter.toString());
      print(textController.text);

      ///-------------

        print("----GetPrintdata-$Counter_Printer----");

        await wifiprinting(Counter_Printer, type);
        // await wifiprinting(KOT_Printer, type);


      return dataForTicket;

    }
  }




  GetPrintdata(id ,String type)async{
    print("the id is " + id.toString());
    var res=await cw.CUget_With_Parm(api:"SalesHeaders/$id/VoucherNumber" ,Token: token);


    if(res!=false){
      print("print data result");
      print(res);
      dataForTicket=json.decode(res);
      print("Valueofbillcount"+ Bill_Counter.toString());
      print(textController.text);

      ///-------------
      Timer(Duration(milliseconds: 5), () async {
        print("----GetPrintdata-$Counter_Printer----");

            // await wifiprinting(Counter_Printer, "Tax Invoice (Copy)");
            await wifiprinting(KOT_Printer, type);

      });
      return dataForTicket;

    }
  }

  //----------printing ticket generate--------------------------
  PrinterNetworkManager _printerManager = PrinterNetworkManager();
  Future<Ticket> _ticket(PaperSize paper, PrintValue) async {
    print('in print Ticket' + PrintValue);
    final ticket = Ticket(paper);
    List<dynamic> DetailPart =dataForTicket["salesDetails"] as List;

    print("dataForTicket");
    print(dataForTicket.toString());
    print("DetailPart");
    print(DetailPart.toString());

    dynamic VchNo = (dataForTicket["salesHeader"][0]["voucherNo"]) == null
        ? "00": (dataForTicket["salesHeader"][0]["voucherNo"]).toString();

    dynamic date = (DateFormat("dd/MM/yyy hh:mm:ss a").format(DateTime.now()).toString());
    DateTime dt1 = DateTime.parse((dataForTicket["salesHeader"][0]["voucherDate"]).toString());
    dynamic billdate = (DateFormat("dd/MM/yyy").format(dt1).toString());
    print("dt1 " + (DateFormat("dd/MM/yyy").format(dt1).toString()));
    billdate= billdate.substring(0, 10);
    print("dt1 " + dt1.toString());
    print("billdate " + billdate.toString());

    dynamic partyName=(dataForTicket["salesHeader"][0]["partyName"]) == null ||
        (dataForTicket["salesHeader"][0]["partyName"])== ""
        ? ""
        : (dataForTicket["salesHeader"][0]["partyName"]).toString();

    dynamic partyAddres1=(dataForTicket["salesHeader"][0]["address1"]) == null ||
        (dataForTicket["salesHeader"][0]["address1"])== ""
        ? ""
        : (dataForTicket["salesHeader"][0]["address1"]).toString();

    dynamic partyAddres2=(dataForTicket["salesHeader"][0]["address2"]) == null ||
        (dataForTicket["salesHeader"][0]["address2"])== ""
        ? ""
        : (dataForTicket["salesHeader"][0]["address2"]).toString();

    dynamic partyphone=(dataForTicket["salesHeader"][0]["phone"]) == null ||
        (dataForTicket["salesHeader"][0]["phone"])== ""
        ? ""
        : (dataForTicket["salesHeader"][0]["phone"]).toString();

    dynamic OrderTyp=(dataForTicket["salesHeader"][0]["orderType"]) == null ||
        (dataForTicket["salesHeader"][0]["orderType"])== ""
        ? ""
        : (dataForTicket["salesHeader"][0]["orderType"]).toString();

    dynamic Totalvalue = await (dataForTicket["salesHeader"][0]["amount"].toDouble() -
        dataForTicket["salesHeader"][0]["taxAmt"].toDouble()) -
        dataForTicket["salesHeader"][0]["otherAmt"].toDouble();
    print("the total value is " + Totalvalue.toString());

    String pt= "";

  ///..................image part starts.....................................
    final ByteData data= await rootBundle.load('assets/gcn.jpg');
    final bytes=data.buffer.asUint8List();
    final image= decodeImage(bytes);
    ticket.image(image);
  ///..................image part ends.....................................

 pt = pt + ( Companydata["companyProfileAddress1"].toString() + "\n" );

    ticket.row([
      PosColumn(text: ' ', width: 1),
      PosColumn(
          text:(Companydata["companyProfileAddress1"]).toString(),
          // text:("Order Slip"),
          width: 10,
          styles:PosStyles(bold: false,
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,)),
      PosColumn(text: ' ', width: 1)
    ]);



    ///.........................commented for golden dhr.................

    pt = pt + ( Companydata["companyProfileAddress3"].toString() + "\n" );
    ticket.row([
      PosColumn(text: ' ', width: 1),
      PosColumn(
          text:  (Companydata["companyProfileAddress3"]).toString(),
          width: 10,
          styles:PosStyles(bold: false,
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(text: ' ', width: 1)
    ]);
    //
    ///.........................commented for golden dhr phone number.................
    pt = pt + ( Companydata["companyProfileEmail"].toString() + "\n" );
    ticket.row([

      PosColumn(text: ' ', width: 1),
      PosColumn(
          text:  (Companydata["companyProfileEmail"]).toString(),
          width: 10,
          styles:PosStyles(bold: false,underline: true,
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            //  fontType: PosFontType.fontA,
          )),
      PosColumn(text: ' ', width: 1)
    ]);
    pt = pt + (  Companydata["companyProfileGstNo"].toString() + "\n" );
    ticket.text(( Companydata["companyProfileGstNo"]).toString()+' ',
        styles: PosStyles(bold: false,
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ));
    ticket.text(' ');
    pt = pt + (  PrintValue.toString() + "\n" );

    print("the printed value is");
    print(PrintValue);

    ticket.row([
      PosColumn(text: ' ', width: 1),
      PosColumn(
          text: PrintValue ,
          width: 10,
          styles:PosStyles(bold: false,underline: true,
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,)),
      PosColumn(text: ' ', width: 1)
    ]);
    ticket.text(' ');
    if(partyName != "") {
      pt = pt + ( 'Customer: ' + partyName.toString() + "\n" );
      //_write(partyName.toString());
      print("partyNamessss");
      print(partyName);
      ticket.text('Customer:' + partyName.toString(),
          styles: PosStyles(width: PosTextSize.size1,
            height: PosTextSize.size2, align: PosAlign.left,));
    }

    ///..............................Delivery part.........................
    if(OrderTyp=="Delivery") {

     // _write(partyAddres1.toString());
      print("Delivery");
      if (partyAddres1 != "") {
        pt = pt + ( 'Address: ' + partyAddres1.toString() + "\n" );
        ticket.text('House No:  ' + partyAddres1.toString(),
            styles: PosStyles(width: PosTextSize.size1,
              height: PosTextSize.size2, align: PosAlign.left,));
      }
      if (partyAddres2 != "") {
       // _write(partyAddres2.toString());
        pt = pt + ( 'Address2: ' + partyAddres2.toString() + "\n" );
        ticket.text('Street No: ' + partyAddres2.toString(),
            styles: PosStyles(height: PosTextSize.size2,
              width: PosTextSize.size1, align: PosAlign.left,));
      }
    }

    ///..............................Delivery part ends.........................
    print("the order typ is " + OrderTyp);


    ///.............................Dining Starts.............................
    if(OrderTyp=="Dining") {
      pt = pt + ( 'Table Details' + partyAddres1.toString() + "\n" );
    //  _write(partyAddres1.toString());
      print("Dining part");
      ticket.text('Table Details: ' + partyAddres1.toString(),
          styles: PosStyles(width: PosTextSize.size1,
              height: PosTextSize.size2, align: PosAlign.left));
    }
    ///.............................Dining ends.............................
    if(partyphone != "") {
      pt = pt + ( 'Phone No: ' + partyphone.toString() + "\n" );
     // _write(partyphone.toString());
      print("partyphone");
      print(partyphone.toString());
      ticket.text('Phone No: ' + partyphone.toString(),
          styles: PosStyles(width: PosTextSize.size2, align: PosAlign.left,));
    }

    ticket.hr(ch: '=');
    pt = pt + ( 'ORDER NO: ' + VchNo.toString() + "\n" );
    ticket.text('ORDER NO: ' + VchNo.toString(),
        styles: PosStyles( width: PosTextSize.size2, align: PosAlign.left,));
    pt = pt + ('Date         : ' + billdate.toString() + "\n" );
    ticket.text('Date         : ' + billdate.toString(),
        styles: PosStyles(align: PosAlign.left));


    ticket.hr(ch: '=');


    ticket.row([
      PosColumn(
        text:'No',
        styles: PosStyles(align: PosAlign.left ),
        width:1,
      ),
      PosColumn(
        text:'Item',
        styles: PosStyles(align: PosAlign.left),
        width: 3,
      ),
      PosColumn(text: 'Rate', width: 3,styles:PosStyles(align: PosAlign.right)),
      PosColumn(text: 'Qty', width: 2,styles: PosStyles(align: PosAlign.right ),),
      PosColumn(text: ' Amount', width: 3,styles: PosStyles(align: PosAlign.center ),),
    ]);
    ticket.hr(ch: "_"); // for dot line or set ticket.hr(ch: 'charecter', linesAfter: 1);
    var snlnum=0;
    dynamic total = 0.000;
    for (var i = 0; i < DetailPart.length; i++) {
      pt = pt + (total.toString() + "\n" );
      total = DetailPart[i]["amountIncludingTax"] ?? 0 + total;
      snlnum = snlnum + 1;

      pt = pt + ((DetailPart[i]["itmName"].toString() + ("(" + DetailPart[i]["uom"].toString() + ")") + "\n" ));
      ticket.row([
        PosColumn(text: (snlnum.toString()), width: 1, styles: PosStyles(
          align: PosAlign.left,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        )),

        PosColumn(text:(DetailPart[i]["itmName"].toString() + ("(" + DetailPart[i]["uom"].toString() + ")")),
            width: 3, styles:
            PosStyles(align: PosAlign.left,
                height: PosTextSize.size1,
                width: PosTextSize.size2,
                fontType:DetailPart[i]["itmName"].toString().length<13? PosFontType.fontA:PosFontType.fontB,
                bold: true)),
        // for space
        PosColumn(
            text: ("    "),
            width: 3),
        PosColumn(
            text: ('    '),
            width: 2),
        PosColumn(
            text: ("      "),
            width: 3),
      ]);
      pt = pt + ( (((DetailPart[i]["rate"])).toStringAsFixed(2)).toString() + "\n" );
      pt = pt + ( (((DetailPart[i]["qty"])).toStringAsFixed(2)).toString() + "\n" );
      pt = pt + ( (((DetailPart[i]["amountIncludingTax"])).toStringAsFixed(2)).toString() + "\n" );

      print("dsasds " + (DetailPart[i]["qty"]*DetailPart[i]["rate"]).toString());
      ticket.row([
        PosColumn(text: ("     "), width: 1),
        PosColumn(text:  ("    "),
            width: 3),
        // for space
        PosColumn(
            text: (((DetailPart[i]["rate"])).toStringAsFixed(2)).toString(),
            width: 3,
            styles: PosStyles(
                align: PosAlign.right,
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                fontType: PosFontType.fontA
            )),
        PosColumn(
            text: (' ' + ((DetailPart[i]["qty"])).toStringAsFixed(0))
                .toString(),
            styles: PosStyles(align: PosAlign.right, height: PosTextSize.size1,
                width: PosTextSize.size2,bold: true),
            width: 2),
        PosColumn(
            text: ((DetailPart[i]["qty"]*DetailPart[i]["rate"])).toStringAsFixed(2),
            styles: PosStyles(align: PosAlign.center, height: PosTextSize.size1,
              width: PosTextSize.size1,),
            width: 3),
      ]);



      for (var k = 0; k < DetailPart[i]["addonItems"].length; k++) {

        pt = pt + ( (DetailPart[i]["addonItems"][k]["itmName"]).toString()  + "\n" );
        pt = pt + ( (DetailPart[i]["addonItems"][k]["addonItemRate"]).toString()  + "\n" );
        pt = pt + ( (DetailPart[i]["addonItems"][k]["addonItemQty"]).toString()  + "\n" );
        pt = pt + (  ((DetailPart[i]["addonItems"][k]["addonItemQty"]) *
            ((DetailPart[i]["addonItems"][k]["addonItemRate"])))
            .toStringAsFixed(2).toString()  + "\n" );



        ticket.row([
          PosColumn(text: ("   +"), width: 1, styles: PosStyles(
              align: PosAlign.left
          )),

          PosColumn(text: (DetailPart[i]["addonItems"][k]["itmName"] ?? ""),
              width: 3,
              styles:
              PosStyles(align: PosAlign.left)),


          PosColumn(
              text: (((DetailPart[i]["addonItems"][k]["addonItemRate"]))
                  .toStringAsFixed(2)).toString(),
              width: 3,
              styles: PosStyles(
                  align: PosAlign.right
              )),

          PosColumn(
              text: ('  ' + ((DetailPart[i]["addonItems"][k]["addonItemQty"]))
                  .toStringAsFixed(0)).toString(),
              styles: PosStyles(align: PosAlign.right),
              width: 2),

          PosColumn(
              text: ((DetailPart[i]["addonItems"][k]["addonItemQty"]) *
                  ((DetailPart[i]["addonItems"][k]["addonItemRate"])))
                  .toStringAsFixed(2)
              , styles: PosStyles(align: PosAlign.center),
              width: 3),


        ]);
      }

      for (var j = 0; j < DetailPart[i]["itemNotes"].length; j++) {

        pt = pt + (  (DetailPart[i]["itemNotes"][j]["notes"]["notes"]).toString()  + "\n" );
        ticket.row([

          PosColumn(text: ("    *"), width: 2, styles: PosStyles(
              align: PosAlign.right
          )),

          PosColumn(text: (DetailPart[i]["itemNotes"][j]["notes"]["notes"]), width: 10, styles: PosStyles(
              align: PosAlign.left
          )),
        ]);
      }

      i == (DetailPart.length-1)? ticket.hr(ch:"_"):ticket.hr(ch:"-");
    }

    ///......................total amount excluded vat.......................

    print("Total Amount Excluded VAT:" + TotalAmtTaxExcl.toString());
    print("Total Amount Excluded VAT:" + Totalvalue.toString());
    // if(Totalvalue==null)
    // {
    //   print("thotal amount is null");
    // }
    // else{
    //
    //   pt = pt + (  ('Total Amount Excluded VAT :   ' + Totalvalue.toStringAsFixed(2)).toString()  + "\n" );
    // ticket.row([
    //   PosColumn(
    //     text:' ',
    //     width: 1,),
    //
    // PosColumn(
    //
    //
    // text:'Total Amount Excluded VAT :   ' + Totalvalue.toStringAsFixed(2),
    // width: 10,
    // styles: PosStyles(height: PosTextSize.size1,
    // width: PosTextSize.size1,
    // bold: true,align: PosAlign.right,)),
    //
    //
    //   PosColumn(
    //     text:' ',
    //     width: 1,),
    // ]);
    // }

    pt = pt + (  (dataForTicket["salesHeader"][0]["taxAmt"].toStringAsFixed(2))  + "\n" );
    ///.................................total vat.........................


    var totalamount=(dataForTicket["salesHeader"][0]["amount"] +dataForTicket["salesHeader"][0]["discountAmt"])-dataForTicket["salesHeader"][0]["otherAmt"];


    ticket.row([
      PosColumn(
        text:' ',
        width: 1,),

      PosColumn(
          text:'Total Amt :   '  + (totalamount.toStringAsFixed(2)),
          width: 10,
          styles: PosStyles(height: PosTextSize.size1,
            width: PosTextSize.size1,
            bold: true,align: PosAlign.right,)),

      PosColumn(
        text:' ',
        width: 1,),
    ]);
    if(discact==true)ticket.row([
      PosColumn(
        text:' ',
        width: 1,),
      PosColumn(
          text:'Discount Amount(${discper.toStringAsFixed(0)}%):    '+(dataForTicket["salesHeader"][0]["discountAmt"].toStringAsFixed(2)),
          width: 10,
          styles: PosStyles(height: PosTextSize.size1,
            width: PosTextSize.size1,
            bold: true,align: PosAlign.right,)),
      PosColumn(
        text:' ',
        width: 1,),
    ]);
    ticket.row([
      PosColumn(
        text:' ',
        width: 1,),
      PosColumn(
          text:'Tax Amount(Incl) :    '+(dataForTicket["salesHeader"][0]["taxAmt"].toStringAsFixed(2)),
          width: 10,
          styles: PosStyles(height: PosTextSize.size1,
            width: PosTextSize.size1,
            bold: true,align: PosAlign.right,)),
      PosColumn(
        text:' ',
        width: 1,),
    ]);

    ///.................................deivery charge..............................
    pt = pt + (  'Delivery Charge :   '+(dataForTicket["salesHeader"][0]["otherAmt"].toStringAsFixed(2)) + "\n" );
    double DelAmt=double.parse(dataForTicket["salesHeader"][0]["otherAmt"].toString()) ;
    print('Delivery Charge :   '+(dataForTicket["salesHeader"][0]["otherAmt"].toStringAsFixed(2)));

    if(OrderTyp=="Delivery"){
      DelAmt>0?
      ticket.row([
        PosColumn(
          text:' ',
          width: 1,),
        PosColumn(
            text:'Delivery Charge :   '+(dataForTicket["salesHeader"][0]["otherAmt"].toStringAsFixed(2)),
            width: 10,
            styles: PosStyles(bold: true,align: PosAlign.right,)),
        PosColumn(
          text:' ',
          width: 1,
        ),
      ]):ticket.text("");

    }
    else{
      print("no delivery charge");
    }


    ///........................white space..........................................

    ticket.row([
      PosColumn(
        text:' ',
        width: 1,),

      PosColumn(
        text:' ' ,
        width: 10,),

      PosColumn(
        text:' ',
        width: 1,),
    ]);

    pt = pt + (  'Net Total: $currencyName '+(dataForTicket["salesHeader"][0]["amount"].toStringAsFixed(2)) + "\n" );


    /// ............................total ........................
    ticket.row([
      PosColumn(
        text:' ',
        width: 1,),
      PosColumn(
          text:'Net Total: $currencyName '+(dataForTicket["salesHeader"][0]["amount"].toStringAsFixed(2)),
          width: 10,
          styles: PosStyles(height: PosTextSize.size2,
            width: PosTextSize.size2,
            bold: true,align: PosAlign.right,)),
      PosColumn(
        text:' ',
        width: 1,),
    ]);
    print("total amound delivery" + DelAmt.toString() + "amount = " +TotalAmtTaxExcl.toString() +  "total vat" + dataForTicket["salesHeader"][0]["taxAmt"].toString()  +"   " + dataForTicket["salesHeader"][0]["amount"].toString());


    ///......................................for Discount ..............................................



    ticket.hr(
        ch: '_');


    ticket.feed(1);
    if(footerCaptions.toString()!="null"||footerCaptions!=[]||footerCaptions!="[]"){

      print("footerCaptions");
      print(footerCaptions);
      try {
        pt = pt + (  footerCaptions['footerText'].toString() + "\n" );
        ticket.text(footerCaptions['footerText'],
            //'Thank You...Visit again !!',
            styles: PosStyles(align: PosAlign.center, bold: true));
      }catch(e){};
    }

    pt = pt + (  dataForTicket["salesHeader"][0]["id"].toString() + "\n" );
    pt = pt + (  date.toString() + "\n" );

    _write(pt);


    List<dynamic> k=[] ;
    k.add(dataForTicket["salesHeader"][0]["voucherNo"].toString().padLeft(5, '0').split("") );
    print("zzzzzzzzzzzzzzzzzz");
    print(k[0].toString());
    print(k.toString());
    ticket.barcode(Barcode.code39(k[0]),height: 80);

    ticket.feed(2);

    ticket.text(date.toString(),styles: PosStyles(align: PosAlign.center ));
    ticket.text('User : $userName',styles: PosStyles(align: PosAlign.center ) );
    print("Finish");
    ticket.cut();
    return ticket;
  }
  //..................................................
  // ignore: non_constant_identifier_names
  wifiprinting(printerName, String type) async {
    // try {
    print("in print in 123");

    print(printerName.toString());

    _printerManager.selectPrinter(printerName);
    //  _printerManager.selectPrinter('192.168.0.100');
    try{
      await _printerManager.printTicket(await _ticket(PaperSize.mm80, type));
    }
   catch(e){
      // print("nothingisdsdf");
     showDialog(
         context: context,
         builder: (context) {
           Future.delayed(Duration(seconds: 10), () {
             Navigator.of(context).pop(true);
           });
           return AlertDialog(
             title: Text('The error is ' + e.toString()),
           );
         });
   }
    // final res1 = await _printerManager.printTicket(await _ticket(PaperSize.mm80));
    print("out print in");
   // _read();
  }

//----------------------Print part End-----------------------------------------

  Widget CustomAppbarForItemBill({
    @required uname,
    @required branch,
    @required pref,
    @required title,
    required Widget child,
  })
  {
    return
      Container(
        height: 80,
        decoration: BoxDecoration(
            color: Colors.teal
        ),
        width: double.maxFinite,
        child: Padding(
          padding: const EdgeInsets.only(
            //  bottom: 1,
              right: 10,
              left: 10),
          child:
          Row(mainAxisAlignment:
          MainAxisAlignment.start,
              children: [

                GestureDetector(
                    onTap: () {
                      print("hi");
                      setState(() {
                        print("yes");
                        print("yes");

                        Widget noButton = TextButton(
                          child: Text("No"),
                          onPressed: () {
                            setState(() {
                              print("No...");
                              Navigator.pop(
                                  context); // this is proper..it will only pop the dialog which is again a screen
                            });
                          },
                        );

                        Widget yesButton = TextButton(
                          child: Text("Yes"),
                          onPressed: () {
                            setState(() {
                              print("Logout...");
                              //  widget.pref.remove('loginUser');
                              pref.remove('userData');
                              Navigator.pop(context); //okk
//                              Navigator.pop(context);
                              //  Navigator.pushReplacementNamed(context, "/logout");

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => Login()),
                              );
                            });
                          },
                        );
                        showDialog(
                            context: context,
                            builder: (c) => AlertDialog(
                                content: Text("Do you really want to logout?"),
                                actions: [yesButton, noButton]));
                      });
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Center(
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40.0),
                                image: DecorationImage(
                                    image: AssetImage("assets/icon1.jpg"),
                                    fit: BoxFit.fill)),
                            margin: new EdgeInsets.only(
                                left: 0.0, top: 5.0, right: 0.0, bottom: 0.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: Center(
                                child: Text(
                                  "",
                                  style: TextStyle(fontSize: 10, color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )),
                Spacer(),
                Container(
                    margin: EdgeInsets.only(top: 10, bottom: 15),
                    child: Column(children: [
                      SizedBox(
                        height: 7,
                      ),
                      Expanded(
                        child: Text(
                          title??"",
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 7),
                          child: Text(
                            branch.toString(),
                            style: TextStyle(fontSize: 13, color: Colors.white),
                          ),
                        ),
                      ),
                    ])),
                Spacer(),
                IconButton(icon: Icon(Icons.print_outlined,color: Colors.white,), onPressed:() {

                  AddPrinterPopup();

                }),

                SizedBox(width: 20,),



                IconButton(icon: Icon(Icons.list_alt,color: Colors.white), onPressed:() {

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Del_Perv_Bill_Print(
                      Ftr_Data: footerCaptions,
                      Last_Bill_Id: Perv_Bill_Id,
                      Counter_Printer_id: Counter_Printer,
                      KOT_Printer_id: KOT_Printer,

                    )),
                  );

                }
                ),

                SizedBox(width: 20,),


                IconButton(icon: Icon(Icons.print,color: Colors.white,), onPressed:() {

                  TabelNumDatapopup();

                }),

                SizedBox(width: 20,),
                Container(
                  margin: new EdgeInsets.only(
                      left: 0.0, top: 25.0, right: 0.0, bottom: 0.0),
                  child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      InkWell(child: Icon(Icons.logout,color: Colors.white,size: 20,),
                        onTap: (){
                          print("hi");
                          setState(() {
                            print("yes");
                            print("yes");

                            Widget noButton = TextButton(
                              child: Text("No"),
                              onPressed: () {
                                setState(() {
                                  print("No...");
                                  Navigator.pop(
                                      context); // this is proper..it will only pop the dialog which is again a screen
                                });
                              },
                            );

                            Widget yesButton = TextButton(
                              child: Text("Yes"),
                              onPressed: () {
                                setState(() {
                                  print("Logout...");
                                  pref.remove('loginUser');
                                  Navigator.pop(context); //okk
//                              Navigator.pop(context);
                                  Navigator.pushNamedAndRemoveUntil(context, "/logout",
                                          (route) => false);

                                  //placementNamed(context, "/logout");

                                  // Navigator.pushReplacement(
                                  //   context,
                                  //   MaterialPageRoute(builder: (context) => Login()),
                                  // );
                                });
                              },
                            );
                            showDialog(
                                context: context,
                                builder: (c) => AlertDialog(
                                    content: Text("Do you really want to logout?"),
                                    actions: [yesButton, noButton]));
                          });
                        },),

                      SizedBox(height: 2,),
                      Text(
                        "${uname.toString()}",
                        style: TextStyle(fontSize: 13, color: Colors.white),
                      ),
                    ],
                  ),
                ),


              ]),
        ),
      );


  }


//----------------------------- GetExisting_data_Of_Tablenum--adn Ordernum-----------------------------

}



class Del_Tabledata {
  int id;
  dynamic ItemSlNo;
  dynamic Name;
  dynamic rate;
  dynamic Total;
  dynamic Qty;
  dynamic UOM;
  dynamic AmtWithTax;
  dynamic Addon_Data;
  dynamic Item_notes ;
  dynamic Item_Addon_Rate ;

  Del_Tabledata(
      {required this.id,
        this.Name,
        this.rate,
        this.Total,
        this.Qty,
        this.ItemSlNo,
        this.UOM,
        this.AmtWithTax,
        this.Addon_Data,
        this.Item_notes,
        this.Item_Addon_Rate,
      });

  Del_Tabledata.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    Name = json['Name'];
    rate = json['rate'];
    Total = json['Total'];
    Qty = json['Qty'];
    ItemSlNo = json['ItemSlNo'];
    UOM = json['UOM'];
    AmtWithTax = json['AmtWithTax'];
    Addon_Data = json['Addon_Data'];
    Item_notes = json['Item_notes'];
    Item_Addon_Rate = json['Item_Addon_Rate'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Name'] = this.Name;
    data['rate'] = this.rate;
    data['Total'] = this.Total;
    data['Qty'] = this.Qty;
    data['ItemSlNo'] = this.ItemSlNo;
    data['UOM'] = this.UOM;
    data['AmtWithTax'] = this.AmtWithTax;
    data['Addon_Data'] = this.Addon_Data;
    data['Item_notes'] = this.Item_notes;
    data['Item_Addon_Rate'] = this.Item_Addon_Rate;

    return data;
  }
}

class ItemGroup {
  int id;
  String igDescription;
  dynamic igDiplayImagepath;

  ItemGroup({required this.id, required this.igDescription, this.igDiplayImagepath});

  ItemGroup.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    igDescription = json['igDescription'];
    igDiplayImagepath = json['igDiplayImagepath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['igDescription'] = this.igDescription;
    data['igDiplayImagepath'] = this.igDiplayImagepath;

    return data;
  }
}

class ItemList {
  int id;
  String itmName;
  dynamic itmImage;
  bool itmTaxInclusive;
  bool showAddonItems;
  // ItemList({this.id, this.itmName, this.itmImage, this.itmTaxInclusive});
  ItemList({required this.id, required this.itmName, this.itmImage, required this.itmTaxInclusive, required this.showAddonItems});
  ItemList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itmName = json['itmName'];
    itmImage = json['itmImage'];
    itmTaxInclusive = json['itmTaxInclusive'];
    showAddonItems= json['activeAddonItems'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['itmName'] = this.itmName;
    data['itmImage'] = this.itmImage;
    data['itmTaxInclusive'] = this.itmTaxInclusive;
    data['activeAddonItems'] = this.showAddonItems;
    return data;
  }
}

class ItmBillDetails {
  dynamic ItemSlNo;
  int itemId;
  dynamic qty;
  dynamic rate;
  dynamic disPercentage;
  dynamic cgstPercentage;
  dynamic sgstPercentage;
  dynamic cessPercentage;
  dynamic discountAmount;
  dynamic cgstAmount;
  dynamic sgstAmount;
  dynamic cessAmount;
  dynamic igstPercentage;
  dynamic igstAmount;
  dynamic taxPercentage;
  dynamic taxAmount;
  dynamic taxInclusive;
  dynamic amountBeforeTax;
  dynamic amountIncludingTax;
  dynamic netTotal;
  dynamic hsncode;

  int gdnId;
  int taxId;
  int rackId;
  int addTaxId;
  int unitId;
  int nosInUnit;
  dynamic barcode;
  dynamic StockId;
  dynamic BatchNo;
  dynamic ExpiryDate;
  dynamic Notes;
  dynamic adlDiscAmount;
  dynamic adlDiscPercent;
  dynamic shid;
  dynamic AddOn_Data;
  dynamic Item_notes;


  ItmBillDetails({this.ItemSlNo,
    required this.itemId,
    this.qty,
    this.rate,
    this.disPercentage,
    this.cgstPercentage,
    this.sgstPercentage,
    this.cessPercentage,
    this.discountAmount,
    this.cgstAmount,
    this.sgstAmount,
    this.cessAmount,
    this.igstPercentage,
    this.igstAmount,
    this.taxPercentage,
    this.taxAmount,
    this.taxInclusive,
    this.amountBeforeTax,
    this.amountIncludingTax,
    this.netTotal,
    this.hsncode,
    required this.gdnId,
    required this.taxId,
    required this.rackId,
    required this.addTaxId,
    required this.unitId,
    required this.nosInUnit,
    this.barcode,
    this.StockId,
    this.BatchNo,
    this.ExpiryDate,
    this.Notes,
    this.adlDiscAmount,
    this.adlDiscPercent,
    this.shid,
    this.AddOn_Data,
    this.Item_notes
  });

  ItmBillDetails.fromJson(Map<String, dynamic> json) {
    ItemSlNo = json['ItemSlNo'];
    itemId = json['itemId'];
    qty = json['qty'];
    rate = json['rate'];
    disPercentage = json['disPercentage'];
    cgstPercentage = json['cgstPercentage'];
    sgstPercentage = json['sgstPercentage'];
    cessPercentage = json['cessPercentage'];
    discountAmount = json['discountAmount'];
    cgstAmount = json['cgstAmount'];
    sgstAmount = json['sgstAmount'];
    cessAmount = json['cessAmount'];
    igstPercentage = json['igstPercentage'];
    igstAmount = json['igstAmount'];
    taxPercentage = json['taxPercentage'];
    taxAmount = json['taxAmount'];
    taxInclusive = json['taxInclusive'];
    amountBeforeTax = json['amountBeforeTax'];
    amountIncludingTax = json['amountIncludingTax'];
    netTotal = json['netTotal'];
    hsncode = json['hsncode'];
    gdnId = json['gdnId'];
    taxId = json['taxId'];
    rackId = json['rackId'];
    addTaxId = json['addTaxId'];
    unitId = json['unitId'];
    nosInUnit = json['nosInUnit'];
    barcode = json['barcode'];
    StockId = json['StockId'];
    BatchNo = json['BatchNo'];
    ExpiryDate = json['ExpiryDate'];
    Notes = json['Notes'];
    adlDiscAmount = json['adlDiscAmount'];
    adlDiscPercent = json['adlDiscPercent'];
    shid = json['shid'];
    AddOn_Data = json['AddOn_Data'];
    Item_notes = json['Item_notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ItemSlNo'] = this.ItemSlNo;
    data['itemId'] = this.itemId;
    data['qty'] = this.qty;
    data['rate'] = this.rate;
    data['disPercentage'] = this.disPercentage;
    data['cgstPercentage'] = this.cgstPercentage;
    data['sgstPercentage'] = this.sgstPercentage;
    data['cessPercentage'] = this.cessPercentage;
    data['discountAmount'] = this.discountAmount;
    data['cgstAmount'] = this.cgstAmount;
    data['sgstAmount'] = this.sgstAmount;
    data['cessAmount'] = this.cessAmount;
    data['igstPercentage'] = this.igstPercentage;
    data['igstAmount'] = this.igstAmount;
    data['taxPercentage'] = this.taxPercentage;
    data['taxAmount'] = this.taxAmount;
    data['taxInclusive'] = this.taxInclusive;
    data['amountBeforeTax'] = this.amountBeforeTax;
    data['amountIncludingTax'] = this.amountIncludingTax;
    data['netTotal'] = this.netTotal;
    data['hsncode'] = this.hsncode;
    data['gdnId'] = this.gdnId;
    data['taxId'] = this.taxId;
    data['rackId'] = this.rackId;
    data['addTaxId'] = this.addTaxId;
    data['unitId'] = this.unitId;
    data['nosInUnit'] = this.nosInUnit;
    data['barcode'] = this.barcode;
    data['StockId'] = this.StockId;
    data['BatchNo'] = this.BatchNo;
    data['ExpiryDate'] = this.ExpiryDate;
    data['Notes'] = this.Notes;
    data['adlDiscAmount'] = this.adlDiscAmount;
    data['adlDiscPercent'] = this.adlDiscPercent;
    data['shid'] = this.shid;
    data['AddOn_Data'] = this.AddOn_Data;
    data['Item_notes'] = this.Item_notes;
    return data;
  }
}

_write(String text) async {
  final Directory? directory = await getExternalStorageDirectory();
  print("the paths is in" + directory!.path.toString());
  final File file = File('${directory?.path}/my_file.txt');
  await file.writeAsString(text);
}

Future<String> _read() async {
  String text;
  try {
    final Directory? directory = await getExternalStorageDirectory();
    final File file = File('${directory?.path}/my_file.txt');
    //text = await file.readAsString();
    text =await rootBundle.loadString('${directory?.path}/my_file.txt');
    print(text);
  } catch (e) {
    print("Couldn't read file");
  }
  return text;
}

Future<String> readFileContent() async {
  String response;

  response =
  await rootBundle.loadString('storage/fileList.txt');
  return response;
}