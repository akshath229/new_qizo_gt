import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:android_intent/android_intent.dart';
import 'package:dio/dio.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';


import 'package:image_picker/image_picker.dart';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:new_qizo_gt/sales.dart';
import 'package:new_qizo_gt/shopvisited.dart';
import 'package:new_qizo_gt/urlEnvironment/urlEnvironment.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';

import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'GT_Masters/AppTheam.dart';
import 'GT_Masters/Masters_UI/cuWidgets.dart';
import 'GT_Masters/Printing/PDF_Rec_Pay_Print.dart';
import 'appbarWidget.dart';
import 'models/customersearch.dart';
import 'models/userdata.dart';
import 'newtestpage.dart';

class ReceiptCollections_Direct extends StatefulWidget {

  int passvalue;
  dynamic passname;
  ReceiptCollections_Direct({required this.passvalue,this.passname});



  @override
  _ReceiptCollections_DirectState createState() => _ReceiptCollections_DirectState();
}

@override
class _ReceiptCollections_DirectState extends State<ReceiptCollections_Direct> {
  List gender = ["Cash", "Bank"];

  String select = "Cash";
  // File _image;
  dynamic pickedFile;
  final picker = ImagePicker();
  late bool loadingResReceiptAdd;
  late int count;


  BluetoothManager bluetoothManager = BluetoothManager.instance;
  PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
  List<PrinterBluetooth> _devices = [];
  var Companydata;
  var dataForTicket;
  var  _devicesMsg="";

  AppTheam theam=AppTheam();
// images pick form gallery
  void getImageFromGallery() async {
    pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      // _image = File(pickedFile.path);
    });
  }

  // Capture Images From Camera
  void getImageFromCamera() async {
    pickedFile = await picker.getImage(source: ImageSource.camera);
    print(".......................");
    print(pickedFile);
    setState(() {
      // _image = File(pickedFile.path);
      // print(_image);
    });
  }

//  AutoCompleteTextField searchTextField;
  late UserData userData;
  late String branchName;
  var userId;
  dynamic userName;
  late String token;
  dynamic openingAmountBalance = 0.0;
  dynamic opAmtBlncPrnt = 0.0;
  bool customerSelect = false;
  bool remarkSelect = false;
  bool receivedAmountSelect = false;
  double receiptTotal = 0.0;
  late int branchId;
  dynamic userArray;
  dynamic serverDate;
  int? salesLedgerId = null;
  var  VchNum;

//  UserSession usr;
  //String date = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());

//  var _dobController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  bool autovalidate = false;

  dynamic user;


  dynamic RptDateTime;

  late int customerSelectedId;
  late String customerSelectedEmail;
  late String customerSelectedName;
  String noImage = "-No Image-";
  TextEditingController controller = new TextEditingController();
  FocusNode field1FocusNode = FocusNode(); //Create first FocusNode

  late String customerName;
  late String selectedLetter;
  TextEditingController customerController = new TextEditingController();
  TextEditingController amountController = new TextEditingController();
  TextEditingController receiptController = new TextEditingController();
  TextEditingController remarksController = new TextEditingController();
  TextEditingController Cheque_NoController = new TextEditingController();
  TextEditingController Cheque_DateController = new TextEditingController();



  List<Receipt_Payment_Add> customerReceipts = [];
  List<Receipt_Payment_Add> finalCustomerReceipts = [];

  late double longitude;
  late double latitude;


  CUWidgets cu=CUWidgets();

  late Receipt_Payment_Add customerReceipt;
  GlobalKey<AutoCompleteTextFieldState<Customer>> key =
  new GlobalKey(); //only one autocomplte
  String selectedPerson = "";
  static List<ReceiptCollection> receiptCollection =
  [];
  late ReceiptCollection receipt;

//   "Select Customer";
  static List<Customer> users = [];
  bool loading = true;
  final letters = 'abcdefghijklmnopqrstuvwxyz'.split('');

  late SharedPreferences pref;


  var Payment_Type;
  var Payment_Type_id;
  var BtnName="Save";

  void initState() {


    print('${Env.baseUrl}');
    // customerController.text = "";
    remarksController.text = "";
    SharedPreferences.getInstance().then((value) {
      pref = value;
      read();
      receiptCollection.clear();
      customerReceipts.clear();
      _getLocation();
      getCustomer();
      GetCompantPro(branchId);
      Priter_Initial_Part();
      GetVchnum();
      GetCash();
      if(widget.passname.toString()!= "null"){

        print("value rctptclln= "+widget.passname.toString());
        // customerController.text=widget.passname;
        // salesLedgerId =widget.passvalue;
        customerName=widget.passname;
        EditBinde(widget.passvalue);
        setState(() {
          BtnName="Update";
        });
      }else{
        setState(() {
          BtnName="Save";
        });
      }

    });
    // token get fun  this

    customerController.addListener(customerLedgerIdListener);

    super.initState();
  }

  validationRcvAmt() {
    if (amountController.text == "") {
      receivedAmountSelect = true;
      // validationRemarks();
    } else {
      receivedAmountSelect = false;
      // validationRemarks();
    }
  }


  GetVchnum()async{
    print("GetVchnum");
    try {
      final tagsJson =
      await http.get("${Env.baseUrl}getSettings/1/receiptvoucher" as Uri, headers: {
        "Authorization": user.user["token"],
      });
      if(tagsJson.statusCode==200) {
        setState(() {
          var res=json.decode(tagsJson.body);
          VchNum=res[0]['vocherNo'];
        });
      }

    }
    catch(e){
      print("error on GetCompantPro : $e");
    }


  }


  // Save Receipt Now
  receiptNow() {
    setState(() {
      if (BtnName == "Save" ) {
        customerSelect = false;
        correctValidateNow();
      } else {
        customerSelect = false;
        EditUpdate();
      }
    });
  }

  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Theme
              .of(context)
              .primaryColor,
          value: gender[btnValue],
          groupValue: select,
          onChanged: (value) {
            setState(() {
              print("Payment Type : ${value.toString()}");
              select = value;
              print("fuyutyutyu");
              print(select);
              if(select=="Cash"){
                GetCash();
              }else
              {
                GetBank();
              }

            });
          },
        ),
        Text(title)
      ],
    );
  }

  getIndexRows(dynamic item) {
    int i = customerReceipts.indexOf(item);
    return i + 1;
  }

  addCustomerReceipt() async {
    print("add...... ");
//     receiptCollection.clear();
//     customerReceipts.clear();
//     return;
    setState(() {
      if (salesLedgerId == null || customerController.text == "") {
        customerSelect = true;
        validationRcvAmt();
      } else {
        customerSelect = false;
        validationRcvAmt();
      }
    });

    if (amountController.text == "" || salesLedgerId == null) {
      print("check fields");
      print(salesLedgerId);
      showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text("check fields"),
              ));
      return;
    }
    if (amountController.text == "" || salesLedgerId == null) {
      return;
    }




    Widget cameraButton = FloatingActionButton(
      backgroundColor: Colors.lightBlueAccent,
      child: Icon(Icons.camera_alt),
      onPressed: () {
        setState(() {
          print("camera...");
          picImageFromCamera();
          Navigator.pop(context);
        });

//        alert.hide();
      },
    );
    Widget galleryButton = FloatingActionButton(
      backgroundColor: Colors.lightBlueAccent,
      child: Icon(
        Icons.camera,
      ),
      onPressed: () {
        setState(() {
          print("No image...");
          picImageFromGallery();
          Navigator.pop(context);
        });

//        alert.hide();
      },
    );

    Widget noImageButton = FloatingActionButton(
      backgroundColor: Colors.red,
      child: Icon(Icons.not_interested),
      onPressed: () {
        setState(() {
          print("No...");
          addingReceiptWithOutPhoto();
          Navigator.pop(context);
        });

//        alert.hide();
      },
    );


    AlertDialog alert = AlertDialog(
      title: Center(child: Text("Select Option")),
//      content: Text("This is my message."),
      actions: [cameraButton, galleryButton, noImageButton],
    );
    addingReceiptWithOutPhoto();///-----add amount without photo
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return alert;
    //   },
    // );
    return;
  }

  // image pic from camera
  picImageFromCamera() async {
    var Cheque_Date="";
    if(Cheque_DateController.text!="") {
      var formatter = new DateFormat('MM-dd-yyyy'); // this dd-MM-yyyy format
      var formattedDate = formatter
          .format(DateTime.parse(Cheque_DateController.text));
      print(formattedDate);
       Cheque_Date = formattedDate;
    }
    var amount = double.parse(amountController.text);
    print(amount);
    print(customerReceipts.length);
    print(amountController.text);
    print(remarksController.text);

    var pic = await picker.getImage(
        source: ImageSource.camera, imageQuality: 30); // reduce it

    print("path  is....not null");

    print("Hello: " + pic.path);
    setState(() {});
    int transtype;
    if (select == "Cash") {
      transtype = 0;
    } else {
      transtype = 1;
    }
    print("transaction type :${transtype.toString()}");

    customerReceipt = Receipt_Payment_Add(
        slNo: customerReceipts.length + 1,
        receivedAmount: double.parse(amountController.text),
        remarks: remarksController.text,
        rdtransactionType: transtype,
        image: await pic.readAsBytes(),
        Cheque_No:Cheque_NoController.text ,
        Cheque_Date:Cheque_Date);
    receiptTotal = receiptTotal + customerReceipt.receivedAmount;
    setState(() {
      customerReceipts.add(customerReceipt);
    });
//

//    print("Hello: "+pics.toString());

    remarksController.text = "";
    amountController.text = "";
    print("2nd array length");
    print(receiptCollection.length);
    print("1st array length");
    print(customerReceipts.length);
    Cheque_Date="";
    Cheque_NoController.text="";
    Cheque_DateController.text="";
    print(customerReceipts.length);
    print(salesLedgerId);
//
  }

// adding receipt with photo
  addingReceiptWithOutPhoto() {
    var Cheque_Date="";
    if(Cheque_DateController.text!="") {
      var formatter = new DateFormat('MM-dd-yyyy'); // this dd-MM-yyyy format
      var formattedDate = formatter
          .format(DateTime.parse(Cheque_DateController.text));
      print(formattedDate);
       Cheque_Date = formattedDate;
    }
    print("null....... path");
    var amount = double.parse(amountController.text);
    print(amount);
    print(customerReceipts.length);
    print(amountController.text);
    print(remarksController.text);
    setState(() {});
    int transtype;
    if (select == "Cash") {
      transtype = 0;
    } else {
      transtype = 1;
    }
    print("transaction type :${transtype.toString()}");

    customerReceipt = Receipt_Payment_Add(
        slNo: customerReceipts.length + 1,
        receivedAmount: amount,
        remarks: remarksController.text,
        rdtransactionType: transtype,
        image: null,
        LedgerAccount:customerController.text,
        LedgerAccount_id:salesLedgerId,
        Cheque_No:Cheque_NoController.text ,
        Cheque_Date:Cheque_Date);
    receiptTotal = receiptTotal + customerReceipt.receivedAmount;
    customerReceipts.add(customerReceipt);
//      print("Hello: "+pics.toString());

    remarksController.text = "";
    amountController.text = "";
    customerController.text="";
    salesLedgerId=null;
    print("2nd array length");
    print(receiptCollection.length);
    print("1st array length");
    print(customerReceipts.length);
    Cheque_Date="";
    Cheque_NoController.text="";
    Cheque_DateController.text="";
    print(customerReceipts.length);
    print(salesLedgerId);
  }

  // pic get from gallery
  picImageFromGallery() async {
    var Cheque_Date="";
    if(Cheque_DateController.text!="") {
      var formatter = new DateFormat('MM-dd-yyyy'); // this dd-MM-yyyy format
      var formattedDate = formatter
          .format(DateTime.parse(Cheque_DateController.text));
      print(formattedDate);
       Cheque_Date = formattedDate;
    }
    var amount = double.parse(amountController.text);
    print(amount);
    print(customerReceipts.length);
    print(amountController.text);
    print(remarksController.text);

    var pic = await picker.getImage(
        source: ImageSource.gallery, imageQuality: 30); // reduce it

    print("path  is....not null");

    print("Hello: " + pic.toString());
    setState(() {});
    int transtype;
    if (select == "Cash") {
      transtype = 0;
    } else {
      transtype = 1;
    }
    print("transaction type :${transtype.toString()} ");
    customerReceipt = Receipt_Payment_Add(
        slNo: customerReceipts.length + 1,
        receivedAmount: double.parse(amountController.text),
        remarks: remarksController.text,
        rdtransactionType: transtype,
        image: await pic.readAsBytes(),
        Cheque_No:Cheque_NoController.text ,
        Cheque_Date:Cheque_Date);
    receiptTotal = receiptTotal + customerReceipt.receivedAmount;
    setState(() {
      customerReceipts.add(customerReceipt);
    });
//

    remarksController.text = "";
    amountController.text = "";
    print("2nd array length");
    print(receiptCollection.length);
    print("1st array length");
    print(customerReceipts.length);
    Cheque_Date="";
    Cheque_NoController.text="";
    Cheque_DateController.text="";
    print(customerReceipts.length);
    print(salesLedgerId);
//
  }

  // remove customer items
  removeListElement(Receipt_Payment_Add item) {
    setState(() {
//      int i = customerReceipts.indexOf(item);
      customerReceipts.remove(item);

      receiptTotal = receiptTotal - item.receivedAmount;
      print("st array length");
      print(customerReceipts.length);
      print("2nd array length");
      print(receiptCollection.length);

//      customerReceipts.removeWhere((element) => element.slNo == item.slNo);
//      receiptTotal = receiptTotal - item.receivedAmount;
//      receiptCollection.removeWhere((element) => element == item);
    });
  }

  //  passing api to files and index
  correctValidateNow() {
    receiptCollection.clear();
    print(salesLedgerId);
    setState(() {
      if (customerReceipts.length <= 0) {
        receiptCollection.clear();
//      validationRcvAmt();
        showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(
                  title: Text(
                    "Please Add",
                    style: TextStyle(color: Colors.red),
                  ),
//            content: Text("$customerName"),
                ));
        return;
      }
      print(receiptCollection);
      loadingResReceiptAdd = true;
    });

    if (customerReceipts.length <= 0) {
      return;
    }

    var params = new Map<String, dynamic>();

    customerReceipts.asMap().forEach((i, rece) {
      print("...");
      // print(rece.image);
      print("...");
      //
      //   if (rece.image != null) {
      //     receipt = ReceiptCollection(
      //         rdAmount: rece.receivedAmount,
      //         rdRemarks: rece.remarks,
      //         rdImgPath: i,
      //         rdtransactionType: rece.rdtransactionType);
      //     print("$i");
      //     params["$i.jpg"] =
      //         MultipartFile.fromBytes(rece.image ?? [], filename: "$i.jpg"); //
      //
      //     receiptCollection.add(receipt);
      //   } else {
      receipt = ReceiptCollection(
          rdAmount: rece.receivedAmount,
          rdRemarks: rece.remarks,
          rdImgPath: "-",
          rdtransactionType: rece.rdtransactionType,
          lgr_id: rece.LedgerAccount_id,
          Cheque_Date:rece.Cheque_Date,
          Cheque_No:rece.Cheque_No);
      receiptCollection.add(receipt);
      // }
    });

    print("length of last List");
    print(receiptCollection.length);



    print("Payment_Type_id");
    print(Payment_Type_id.toString());


    var req = {
      //"lhName":customerController.text,
      "rvhVoucherNumber": VchNum,
      "rvhVoucherDate": RptDateTime,
      "rvhHeadOfAccount": Payment_Type_id,
      "rvhNarration": remarksController.text,
      "rvhEntryDate": RptDateTime,
      "rvhUserId": userId,
      "rvhBranchId": branchId,
      "taccReceiptDetails": [

        for(int i=0;i<receiptCollection.length;i++)
          {
            "rdLedgerAccount":receiptCollection[i].lgr_id,
            "rdAmount":receiptCollection[i].rdAmount,
            "rdSingleRemarks":receiptCollection[i].rdRemarks,
            "rdTranSerialNo":i,
            "rdMethodOfAdjust":null,
            "rdAdvanceRefNo":null,
            "rdChequeNo":receiptCollection[i].Cheque_No,
            "rdChequeDate": receiptCollection[i].Cheque_Date,


          }],
      "taccReceiptAgainstRef": []
    };



    var map = json.encode(req);
    print(map);
    // params["jsonString"] = map;
    // print(params);
    // FormData form = new FormData.fromMap(Map.from(params));
    // print(form);
    view(map);
  }

  view(dynamic form) async {
    // var prs = new ProgressDialog(
    //   context,
    //   type: ProgressDialogType.Normal,
    //   isDismissible: true,
    //   showLogs: true,
    // );
//     prs.style(
//       message: "Adding Receipt", //
// //      progress: 0.0,
// //      maxProgress: 100.0,
//     );
    // prs.show();
    // var dio = Dio();




    var res = await http.post("${Env.baseUrl}TaccReceiptHeaders" as Uri,
        headers: {
          'accept': 'application/json',
          'content-type': 'application/json',
          'Authorization': user.user["token"],
          'deviceId': user.deviceId
        },
        body:form);

    print(res.statusCode);
    print("res.statusCode");
    if (res.statusCode == 200 ||
        res.statusCode == 201 && receiptCollection.length > 0) {
      print(res.body);
      loadingResReceiptAdd = false;
      setState(() {
        //  prs.hide();
        receiptCollection.clear();
        customerReceipts.clear();
        remarksController.text = "";
        amountController.text = "";
        GetVchnum();
        showDialog(barrierDismissible: false,
            context: context,
            builder: (context) =>
                AlertDialog(
                  title: Text("Receipt Added Success"),
                  content: Text("$customerName"),
                ));
        Timer(Duration(seconds: 2), () {
          print("Yeah, this line is printed after 2 seconds");
          Navigator.pop(context);
          printfunction(res.body);
        });
        customerController.text = "";
        salesLedgerId = null;

        receiptTotal = 0;
      });
    }
    else{
      cu.FailePopup(context);

    }
  }

  // listener for customer select
  customerLedgerIdListener() {
    setState(() {
      salesLedgerId = null;

      openingAmountBalance = 0;
      print(customerController.text);
      print("item");
    });
  }

//  get location longitute and latitude
  _getLocation() async {
    print("location");
    Geolocator geolocator = Geolocator()
      ..forceAndroidLocationManager = true;
    print(geolocator);
    Position position = await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    debugPrint('location: ${position.latitude}');
    print("latitude :");
    print(position.latitude);
//    showDialog(
//        context: context,
//        builder: (context) => AlertDialog(
//              title: Text("longitude:   " + position.longitude.toString()),
//              content: Text("latitude:   " + position.latitude.toString()),
//            ));

    print("longitude:");
    print(position.longitude);
    longitude = position.longitude;
    latitude = position.latitude;
//    showAboutDialog();

//    final coordinates = new Coordinates(position.latitude, position.longitude);
//    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
//    var first = addresses.first;
//    print(first);
//    print("${first.featureName} : ${first.addressLine}");
  }

//get token
  read() async {
    var v = pref.getString("userData");
    print("USER DATA: $v");
    var c = json.decode(v);
    //
    user = UserData.fromJson(c); // token gets this code user.user["token"]

    setState(() {
      branchId =int.parse(c["BranchId"]) ;
      print("user data................");
      print(user.user["token"]);
      token = user.user["token"]; //  passes this user.user["token"]
      pref.setString("customerToken", user.user["token"]);
      branchName = user.branchName;
      userName = user.user["userName"];
      userId=user.user["userId"];
      print(".....");
      print(branchName);
      print(userName);
    }); //  passes this user.user["token"]
    pref.setString("customerToken", user.user["token"]);
  }

// get customer account
  getCustomer() async {
    try {
      final response =
      await http.get("${Env.baseUrl}${Env.CustomerURL}" as Uri, headers: {
        "Authorization": user.user["token"],
      });
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        print('...................');
        Map<String, dynamic> data = json.decode(response.body);
        print("array is");
        print(data["list"]); //used  this to autocomplete
        print("........");
        print(response.statusCode);
        print(data["lst"]);
        userArray = data["lst"];
        users = (data["lst"] as List)
            .map<Customer>((customer) =>
            Customer.fromJson(Map<String, dynamic>.from(customer)))
            .toList();
//        users=loadUsers(s.toString());

      } else {
        print("Error getting users");
      }
    } catch (e) {
      print("Error getting users");
    }
  }

//get customer ledger balance
  getCustomerLedgerBalance(int accountId) async {
    try {
      final response = await http.get("${Env.baseUrl}getsettings" as Uri,
          headers: {"accept": "application/json"});
      print(response.statusCode);

      if (response.statusCode == 200) {
        print('...................');

        print(response.body);

        List<dynamic> list = json.decode(response.body);
        print(list[0]["workingDate"] +
            "....................." +
            list[0]["workingTime"]);
        var formatter = new DateFormat('MM-dd-yyyy'); // this dd-MM-yyyy format
        var formattedDate = formatter
            .format(DateTime.parse(list[0]["workingDate"].substring(0, 10)));
        print(formattedDate);
        RptDateTime=formattedDate;
        getLedger(accountId, formattedDate);
      } else {
        print("Error getting users");
      }
    } catch (e) {
      print("Error getting users" + e);
    }
    print("customer Id is");
    print(accountId);
  }

  getLedger(dynamic acId, dynamic date) async {
    print(acId);
    print("the given date is");
    print(date);
    var url = "${Env.baseUrl}TaccLedgers/$acId/$date";
    print("url:" + url);
    try {
      final response = await http.get(url as Uri, headers: {
        "Authorization": user.user["token"],
      });

      if (response.statusCode == 200) {
        print(response.body);
        var e = json.decode(response.body);
        print(e["openingAmount"]);
        setState(() {
          if (e["openingAmount"] > 0.0) {
            openingAmountBalance = e["openingAmount"];
            opAmtBlncPrnt= e["openingAmount"];
          } else {
            print("opening amount is zero");
          }
        });
      }
    } catch (e) {
      print("error" + e.toString());
    }
  }



  Future<bool> _onBackPressed() async {
    Navigator.pop(context);
    return true;  // This means that the back action is allowed by the app
  }


//--------------------------Edit part----------------------------------

  EditBinde(id)async{
    var Cheque_Date="";
    if(Cheque_DateController.text!="") {
      var formatter = new DateFormat('MM-dd-yyyy'); // this dd-MM-yyyy format
      var formattedDate = formatter
          .format(DateTime.parse(Cheque_DateController.text));
      print(formattedDate);
       Cheque_Date = formattedDate;
    }
    print("uiouiouioiu");
    print(id.toString());
    var res = await http.get("${Env.baseUrl}TaccReceiptHeaders/$id" as Uri,
        headers: {
          'accept': 'application/json',
          'content-type': 'application/json',
          'Authorization': user.user["token"],
          'deviceId': user.deviceId
        });
    print("EditBinde");
    print(res.statusCode.toString());
    if(res.statusCode<210){
      var Editresdata=json.decode(res.body);
      print("Editresdata");
      print(Editresdata);
      var  rdtransactionType=0;
      setState(() {
        RptDateTime=Editresdata['header'][0]['rvhVoucherDate'];
        VchNum=Editresdata['header'][0]['rvhVoucherNumber'];
      });

      if (Editresdata['header'][0]['lhName'].toString().toLowerCase().contains('cash')) {


        print("contains  cash");
        var s=await GetCash();
        setState(() {
          select = "Cash";
        });
      } else {

        print("contains  bank");
        var s=await GetBank();
        setState(() {
          rdtransactionType=1;
          select ='Bank';
        });
      }



      var Detailpart=[];
      Detailpart= Editresdata["details"];


      Detailpart.forEach((element) {

        customerReceipt = Receipt_Payment_Add(
            slNo: customerReceipts.length + 1,
            receivedAmount: element["rdAmount"],
            remarks: element["rdSingleRemarks"],
            //rdtransactionType: rdtransactionType,
            LedgerAccount: element["lhName"],
            LedgerAccount_id:element["ledgerDetId"],
            Cheque_No:Cheque_NoController.text ,
            Cheque_Date:Cheque_Date);
        receiptTotal = receiptTotal + customerReceipt.receivedAmount;
        customerReceipts.add(customerReceipt);

      });

    }
  }

  GetCash()async {
    var res = await http.get("${Env.baseUrl}MLedgerHeads/1/3" as Uri,
        headers: {
          'accept': 'application/json',
          'content-type': 'application/json',
          'Authorization': user.user["token"],
          'deviceId': user.deviceId
        });
    print("GetCash");
    print(res.statusCode.toString());
    if (res.statusCode < 210) {
      var Editresdata = json.decode(res.body);
      print("Editresdata Bank");
      print(Editresdata['acListCashBank']);
      var resdata=Editresdata['acListCashBank'];
      setState(() {
        Payment_Type=resdata[0]['lhName'];
        Payment_Type_id=resdata[0]['id'];
        print(Payment_Type_id);
      });
    }
  }



  GetBank()async {
    var res = await http.get("${Env.baseUrl}MLedgerHeads/1/4" as Uri,
        headers: {
          'accept': 'application/json',
          'content-type': 'application/json',
          'Authorization': user.user["token"],
          'deviceId': user.deviceId
        });
    print("GetBank");
    print(res.statusCode.toString());
    if (res.statusCode < 210) {
      var Editresdata = json.decode(res.body);
      print("Editresdata Bank");
      print(Editresdata['acListCashBank']);
      var resdata=Editresdata['acListCashBank'];
      setState(() {
        Payment_Type=resdata[0]['lhName'];
        Payment_Type_id=resdata[0]['id'];
        print(Payment_Type_id);
      });
    }
  }



  EditUpdate()async{
    print("on update");
    receiptCollection.clear();
    print(salesLedgerId);
    setState(() {
      if (customerReceipts.length <= 0) {
        receiptCollection.clear();
//      validationRcvAmt();
        showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(
                  title: Text(
                    "Please Add",
                    style: TextStyle(color: Colors.red),
                  ),
//            content: Text("$customerName"),
                ));
        return;
      }
      print(receiptCollection);
      loadingResReceiptAdd = true;
    });

    if (customerReceipts.length <= 0) {
      return;
    }



    customerReceipts.asMap().forEach((i, rece) {
      receipt = ReceiptCollection(
          rdAmount: rece.receivedAmount,
          rdRemarks: rece.remarks,
          rdImgPath: "-",
          rdtransactionType: rece.rdtransactionType,
          lgr_id: rece.LedgerAccount_id);
      receiptCollection.add(receipt);
    });

    print("length of last List");
    print(receiptCollection.length);




    var req = {
      "id":widget.passvalue,
      "rvhVoucherNumber": VchNum,
      "rvhVoucherDate": RptDateTime,
      "rvhHeadOfAccount": Payment_Type_id,
      "rvhNarration": remarksController.text,
      "rvhEntryDate": RptDateTime,
      "rvhUserId": userId,
      "rvhBranchId": branchId,
      "taccReceiptDetails": [

        for(int i=0;i<receiptCollection.length;i++)
          {
            "rdRvHid":widget.passvalue,
            "rdLedgerAccount":receiptCollection[i].lgr_id,
            "rdAmount": receiptCollection[i].rdAmount,
            "rdSingleRemarks": receiptCollection[i].rdRemarks,
            "rdTranSerialNo": i,
            "rdMethodOfAdjust": null,
            "rdAdvanceRefNo": null,
            "rdChequeNo": null,
            "rdChequeDate": RptDateTime,
            "taccReceiptAgainstRef": []
          }],

    };

    var map = json.encode(req);
    print(map);
    var res = await http.put("${Env.baseUrl}TaccReceiptHeaders/${widget.passvalue}" as Uri,
        headers: {
          'accept': 'application/json',
          'content-type': 'application/json',
          'Authorization': user.user["token"],
          'deviceId': user.deviceId
        },
        body:map);

    print(res.statusCode);
    print("res.statusCode");
    if (res.statusCode <210) {
      print(res.body);
      printfunction(res.body);
      loadingResReceiptAdd = false;
      setState(() {
        //  prs.hide();
        receiptCollection.clear();
        customerReceipts.clear();
        remarksController.text = "";
        amountController.text = "";
        GetVchnum();
        showDialog(barrierDismissible: false,
            context: context,
            builder: (context) =>
                AlertDialog(
                  title: Text("Payment Update Success"),
                  content: Text("$customerName"),
                ));
        Timer(Duration(seconds: 2), () {
          print("Yeah, this line is printed after 2 seconds");

          Navigator.pop(context);
        });
        customerController.text = "";
        salesLedgerId = null;

        receiptTotal = 0;
      });
    }
    else{
      cu.FailePopup(context);

    }


  }


  ///---------------------------------------------------------------
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(190.0),

              child: Appbarcustomwidget(uname: userName, branch: branchName, pref: pref, title: "Receipt Collection")
          ),
          body: ListView(
            children: [
              SizedBox(height: 10),
              Row(children: [
                SizedBox(width: 10),
                Expanded(
                    child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                            style: TextStyle(),
                            controller: customerController,
                            decoration: InputDecoration(
                              errorStyle: TextStyle(color: Colors.red),
                              errorText: customerSelect
                                  ? "Please Select Customer ?"
                                  : null,
                              suffixIcon: IconButton(
                                icon: Icon(Icons.remove_circle),
                                color: Colors.blue,
                                onPressed: () {
                                  setState(() {
                                    print("cleared");
                                    customerController.text = "";
                                    salesLedgerId = null;
                                    openingAmountBalance = 0;
                                  });
                                },
                              ),

                              isDense: true,
                              contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14.0)),
                              labelText:
                              'customer search', // i need to decrease height
                            )),
                        suggestionsBoxDecoration:
                        SuggestionsBoxDecoration(elevation: 90.0),
                        suggestionsCallback: (pattern) {
                          return users.where((user) =>
                              user.lhName.toUpperCase().contains(pattern.toUpperCase()));
                        },
                        itemBuilder: (context, suggestion) {
                          return Card(
                            color: theam.DropDownClr,
                            // shadowColor: Colors.blue,
                            child: ListTile(
                              // focusColor: Colors.blue,
                              // hoverColor: Colors.red,
                              title: Text(
                                suggestion.lhName,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          print(suggestion.lhName);
                          print("selected");

                          customerController.text = suggestion.lhName;
                          customerName = suggestion.lhName;
                          print("close.... $salesLedgerId");
                          salesLedgerId = null;

                          print(suggestion.id);
                          print(".......sales Ledger id");
                          salesLedgerId = suggestion.id;
                          if (suggestion.id != null) {
                            getCustomerLedgerBalance(suggestion.id);
                          }
                          print(salesLedgerId);
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
                            ))),
                SizedBox(
                  width: 10,
                ),
              ]),
              Visibility(
                visible: openingAmountBalance > 0,
                child: SizedBox(
                  height: 15,
                ),
              ),
              Visibility(
                visible: openingAmountBalance > 0,
                child: Row(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(width: 30),
                    Expanded(
                      child: Text(
                        "Current Balance:  " + openingAmountBalance.toString(),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Visibility(
                visible: openingAmountBalance > 0,
                child: SizedBox(
                  height: 9,
                ),
              ),
              // SizedBox(
              //   height: 6,
              // ),
              // Row(
              //   children: [
              //     Text("Payment Type")
              //   ],
              // ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    "Payment Type",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  addRadioButton(0, 'Cash'),
                  SizedBox(
                    width: 10,
                  ),
                  addRadioButton(1, 'Bank'),
                  // addRadioButton(2, 'Others'),
                ],
              ),

              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: amountController,

                      enabled: true,
                      validator: (v) {
                        var t = v.runtimeType;
                        if (v!.isEmpty || t == double || t == int)
                          return "Required";
                        return null;
                      },
//
                      // will disable paste operation
//                  focusNode: field1FocusNode,
                      cursorColor: Colors.black,

                      scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                      keyboardType: TextInputType.number,

                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.red),
                        errorText: receivedAmountSelect
                            ? "Invalid amount"
                            : null,
//                    suffixIcon: Icon(
//                      Icons.calendar_today,
//                      color: Colors.blue,
//                      size: 24,
//                    ),
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(
                            20.0, 10.0, 20.0, 16.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0)),

                        // curve brackets object
//                    hintText: "Quantity",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                        labelText: "Received Amount",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  SizedBox(width: 4),
                  SizedBox.fromSize(
                    size: Size(45, 45), // button width and height
                    child: ClipOval(
                      child: Material(
                        color: Colors.lightBlueAccent, // button color
                        child: InkWell(
                          splashColor: Colors.green, // splash color
                          onTap: addCustomerReceipt,
//                      onPressed: ,
                          // button pressed
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              ), // icon
//                          Text("Call"), // text
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: remarksController,
                      enabled: true,
                      validator: (v) {
                        if (v!.isEmpty) return "Required";
                        return null;
                      },
//
                      // will disable paste operation
//                  focusNode: field1FocusNode,
                      cursorColor: Colors.black,

                      scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                      keyboardType: TextInputType.text,

                      decoration: InputDecoration(
                        // errorStyle: TextStyle(color: Colors.red),
                        // errorText: remarkSelect ? "Please Enter Remarks" : null,
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(
                            20.0, 10.0, 20.0, 16.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0)),
                        hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                        labelText: "Remarks",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),

              Visibility(
                visible:select!="Cash" ,
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        style: TextStyle(fontSize: 15),
                        showCursor: true,
                        controller: Cheque_DateController,
                        enabled: true,
                        validator: (v) {
                          if (v!.isEmpty) return "Required";
                          return null;
                        },
//
                        // will disable paste operation

                        cursorColor: Colors.black,

                        scrollPadding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                        keyboardType: TextInputType.datetime,
                        readOnly: true,

                        onTap: () async {
                          final DateTime now = DateTime.now();
                          DateTime? date = await showDatePicker(
                            context: context,
                            initialDatePickerMode: DatePickerMode.day,
                            initialDate: now,
                            firstDate: DateTime(1999),
                            lastDate: DateTime(2080),
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: ThemeData.light(),
                                child: child!,
                              );
                            },
                          );

                          if (date != null) {
                            print(date);
                            if (date.isBefore(DateTime.now())) {
                              print("invalid date select");
                              Cheque_DateController.text = "";
                              return;
                            } else {
                              var d = DateFormat("yyyy-MM-d").format(date);
                              Cheque_DateController.text = d;
                            }
                          }
                        },

                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.calendar_today,
                            color: Colors.blue,
                            size: 24,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          // curve brackets object
                          hintText: "Delivery Date:dd/mm/yy",
                          hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                          labelText: "Cheque Date",
                        ),
                      ),
                    ),

                    SizedBox(width: 10),

                  ],
                ), ),
              SizedBox(
                height: 10,
              ),

              Visibility(
                visible:select!="Cash" ,
                child:      Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: Cheque_NoController,
                        enabled: true,
                        validator: (v) {
                          if (v.isEmpty) return "Required";
                          return null;
                        },
//
                        // will disable paste operation
//                  focusNode: field1FocusNode,
                        cursorColor: Colors.black,

                        scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                        keyboardType: TextInputType.text,

                        decoration: InputDecoration(
                          // errorStyle: TextStyle(color: Colors.red),
                          // errorText: remarkSelect ? "Please Enter Remarks" : null,
                          isDense: true,
                          contentPadding: EdgeInsets.fromLTRB(
                              20.0, 10.0, 20.0, 16.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.0)),
                          hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                          labelText: "Cheque No",
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ), ),




              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                        onTap: () {
                          print("Save");
                          receiptNow();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:theam.saveBtn_Clr,
                          ),
                          width: 100,
                          height: 40,
                          child: Center(
                            child: Text(
                              BtnName,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )),
                  ),


                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                        onTap: () {
                          print("Reset");
                          setState(() {
                            customerController.text = "";
                            remarksController.text = "";
                            amountController.text = "";
                            customerSelect = false;
                            receivedAmountSelect = false;
                            remarkSelect = false;
                            salesLedgerId = null;
                            customerReceipts.clear();
                            receiptTotal = 0;
                            Cheque_NoController.text="";
                            Cheque_DateController.text="";
                            GetVchnum();
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.indigo,
                          ),
                          width: 100,
                          height: 40,
                          child: Center(
                            child: Text(
                              "Reset",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )),
                  ),

                ],
              ),



              SizedBox(
                height: 6,
              ),
              Visibility(
                visible: customerReceipts.length > 0,
                child: Row(
//            verticalDirection: VerticalDirection.down,
//            crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          //  columnSpacing: 17,
                          onSelectAll: (b) {},
                          sortAscending: true,
                          columns: <DataColumn>[
                            DataColumn(
                              label: Text('#'),
                            ),
                            DataColumn(
                              label: Text('Account'),
                            ),
                            DataColumn(
                              label: Text('Received Amt'),
                            ),
                            DataColumn(
                              label: Text('Transaction Type'),
                            ),
                            DataColumn(
                              label: Text('Remarks'),
                            ),
                            // DataColumn(
                            //   label: Text('images'),
                            // ),
                            DataColumn(
                              label: Text(' '),
                            ),
                          ],
                          rows: customerReceipts
                              .map(
                                (itemRow) =>
                                DataRow(
                                  cells: [
                                    DataCell(
                                      Text(getIndexRows(itemRow).toString()),
                                      showEditIcon: false,
                                      placeholder: false,
                                    ),
                                    DataCell(
                                      Text(itemRow.LedgerAccount.toString()),
                                      showEditIcon: false,
                                      placeholder: false,
                                    ),
                                    DataCell(
                                      Container(
                                          alignment: Alignment.centerRight,
                                          child: Text(itemRow.receivedAmount.toString())),
                                      showEditIcon: false,
                                      placeholder: false,
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 50,
                                        // height: 150,
                                        child: itemRow.rdtransactionType == 0
                                            ? Text("Cash")
                                            : Text("Bank"),
                                      ),
                                      showEditIcon: false,
                                      placeholder: false,
                                    ),
                                    DataCell(
                                      Text(itemRow.remarks??""),
                                      showEditIcon: false,
                                      placeholder: false,
                                    ),
                                    // DataCell(
                                    //   SizedBox(
                                    //     width: 50,
                                    //     height: 150,
                                    //     child: itemRow.image != null
                                    //         ? Image.memory(itemRow.image,
                                    //         fit: BoxFit.cover)
                                    //         : Text(
                                    //       noImage.toString(),
                                    //       style: TextStyle(height: 10),
                                    //     ),
                                    //   ),
                                    //   showEditIcon: false,
                                    //   placeholder: false,
                                    // ),
                                    DataCell(
                                      FlatButton(
                                        padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: Icon(Icons.delete),
                                        onPressed: () {
                                          setState(() {
                                            removeListElement(itemRow);
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                          )
                              .toList(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                    )
                  ],
                ),
              ),
              Visibility(
                visible: receiptTotal > 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 90,
                    ),
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        controller: receiptController,
                        style: TextStyle(
                            color: Colors.lightBlue,
//                      fontFamily: Font.AvenirLTProMedium.value,
                            fontSize: 17),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Total Amount : $receiptTotal',
                          hintStyle: TextStyle(
                            fontSize: 17,
                            color: Colors.red,
                            backgroundColor: Colors.white10,
//                          fontFamily: Font.AvenirLTProBook.value)
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              WillPopScope(

                onWillPop: _onBackPressed,
                child: Text(""),
              ),

              //           GestureDetector(child: Text("gyiky"),
              //           onTap: (){
              //             var j={"id": 2, "rhCustId": 194.0, "rhLatitude": 37.421998333333335,
              //             "rhLongitude": -122.084, "rhDate": 2021-09-28,
              // "rhUserId": 1, "rhBranchId": 1, "rhTrnType": null, "rhCancel": null,
              // "rhCancelRemarks": null, "rhCanelUserId": null, "rhCancelDate": null,
              // "rhCust": null, "mobSmrctCollectionDetails":[{"id": 2, "rdHid": 2, "rdAmount": 30.0,
              //   "rdRemarks": "test", "rdImgPath": "-","rdTransactionType": 0, "rdReceiptHeaderId": null,
              // "rdReceiptHeader": null}]};
              //   printfunction(j);
              //           },
              //           ),

            ],
          ),bottomSheet: Padding(
          padding: const EdgeInsets.only(left: 15,bottom: 15),
          child: FloatingActionButton(

              backgroundColor: Colors.blue,
              hoverColor: Colors.red,  elevation: 5,

              child: Icon(Icons.home_filled),


              onPressed: (){
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder:(context) =>
                        SalesManHome()), (route) => false);
              }),

        ),

          floatingActionButton:SpeedDial(
            animatedIcon:AnimatedIcons.menu_arrow,overlayColor: Colors.blue,
            children: [

              SpeedDialChild(
                  child: Icon(Icons.shopping_cart),
                  backgroundColor: Colors.blue,
                  label: "Sales",
                  onTap:(){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>Newsalespage(passvalue:salesLedgerId,passname:customerName.toString(),)));
                  } ),

              SpeedDialChild(
                  child: Icon(Icons.request_quote_outlined),
                  backgroundColor: Colors.blue,
                  label: "Ledger Balance",
                  onTap:(){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Newtestpage(passvalue:customerName.toString(),Shid:salesLedgerId)),  );
                  } ),


              SpeedDialChild(
                  child: Icon(Icons.remove_shopping_cart_rounded),
                  backgroundColor: Colors.blue,
                  label: "Sales Return",
                  onTap:(){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SalesReturn(passvalue:salesLedgerId,passname:customerName.toString(),)));
                  } ),

              SpeedDialChild(
                  child: Icon(Icons.shopping_cart),
                  backgroundColor: Colors.blue,
                  label: "Sales Order",
                  onTap:(){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>SalesOrder(passvalue:salesLedgerId,passname:customerName.toString(),)));
                  } ),

              SpeedDialChild(
                  child: Icon(Icons.remove_red_eye_outlined),
                  backgroundColor: Colors.blue,
                  label: "Shop Visited",
                  onTap:(){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => shopvisited(passvalue:salesLedgerId,passname:customerName.toString(),)));
                  } ),

            ],
          ),



        ));
  }



//----------------------------------------------------------
//--------------------Print part-------------------------------------------


  GetPrintData()async{



      var res = await http.get("${Env.baseUrl}TaccReceiptHeaders/6" as Uri,
          headers: {
            'accept': 'application/json',
            'content-type': 'application/json',
            'Authorization': user.user["token"],
            'deviceId': user.deviceId
          });

      if(res.statusCode<210){


       // print(res.body);
        printfunction(json.decode(res.body));




      }



  }


  printfunction(datas) async{
    try {
      print("items in printfunction");
      dataForTicket= await json.decode(datas);
      print("dataForTicket");
      print(dataForTicket.toString());
      // print(dataForTicket["id"].toString());
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Rec_Pay_Print(Parm_Id: dataForTicket["id"],printType: "Rcpt")));

      // Timer(Duration(milliseconds: 1), () async {
      //  // blutoothprinting();
      //  //_ticket(PaperSize.mm58);
      //   //PDF_Rec
      //
      // });
    } catch (e) {
      print('error on printfunction $e');
    }
  }


  // GetdataPrint(id) async {
  //   print("sales for print : $id");
  //   double amount = 0.0;
  //   try {
  //     final tagsJson =
  //     await http.get("${Env.baseUrl}SalesHeaders/$id", headers: {
  //       //Soheader //SalesHeaders
  //       "Authorization": user.user["token"],
  //     });
  //     dataForTicket = await jsonDecode(tagsJson.body);
  //     // print("sales for print");
  //     print(dataForTicket);
  //
  //     Timer(Duration(milliseconds: 1), () async{
  //       // await wifiprinting();
  //       blutoothprinting();
  //       // _ticket(PaperSize.mm58);
  //     });
  //
  //   } catch (e) {
  //     print('error on databinding $e');
  //   }
  // }



  // footerdata() async {
  //   try {
  //     print("footer data decoded  ");
  //     final tagsJson =
  //     await http.get("${Env.baseUrl}SalesInvoiceFooters/", headers: {
  //       "Authorization": user.user["token"],
  //     });
  //
  //     setState(() {
  //       footerCaptions = jsonDecode(tagsJson.body);
  //       print( "on footerCaptions :" +footerCaptions.toString());
  //       // wifiprinting();
  //     });
  //
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  GetCompantPro(id)async{
    print("GetCompantPro id is $id");
    print(id.toString());
    try {
      final tagsJson =
      await http.get("${Env.baseUrl}MCompanyProfiles/$id" as Uri, headers: {
        //Soheader //SalesHeaders
        "Authorization": user.user["token"],
      });
      if(tagsJson.statusCode==200) {
        Companydata = jsonDecode(tagsJson.body);
      }
      // print( "on GetCompantPro :" +Companydata.toString());
    }
    catch(e){
      print("error on GetCompantPro : $e");
    }
  }
//----------printing ticket generate--------------------------

  Future<Ticket> _ticket(PaperSize paper) async {
    // final ticket = Ticket(paper);
    print('in');
    final ticket = Ticket(paper);

    List<dynamic> slsDet = dataForTicket["mobSmrctCollectionDetails"] as List;

    dynamic date = (DateFormat("dd/MM/yyy hh:mm:ss a").format(DateTime.now()).toString());
    // dynamic partyName=(dataForTicket["salesHeader"][0]["partyName"]) == null ||
    //     (dataForTicket["salesHeader"][0]["partyName"])== ""
    //     ? ""
    //     : (dataForTicket["salesHeader"][0]["partyName"]).toString();



    ticket.row([
      PosColumn(text: ' ', width: 1),
      PosColumn(
          text:branchName.toString(),
          width: 10,
          styles: PosStyles(bold: true,
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
      PosColumn(text: ' ', width: 1)
    ]);




    ticket.row([
      PosColumn(text: ' ', width: 1),
      PosColumn(
          text:(Companydata["companyProfileAddress1"]).toString(),
          width: 10,
          styles:PosStyles(bold: false,
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,)),
      PosColumn(text: ' ', width: 1)
    ]);



    ticket.row([
      PosColumn(text: ' ', width: 1),
      PosColumn(
          text: (Companydata["companyProfileAddress2"]).toString(),
          width: 10,
          styles:PosStyles(bold: false,
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(text: ' ', width: 1)
    ]);

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



    ticket.row([
      PosColumn(text: ' ', width: 1),
      PosColumn(
          text:(Companydata["companyProfileMobile"]).toString(),
          width: 10,
          styles:PosStyles(bold: false,
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(text: ' ', width: 1)
    ]);




    ticket.row([
      PosColumn(text: ' ', width: 1),
      PosColumn(
          text:  (Companydata["companyProfileEmail"]).toString(),
          width: 10,
          styles:PosStyles(bold: false,underline: true,
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(text: ' ', width: 1)
    ]);








    ticket.text('Token NO : ' + dataForTicket["id"].toString(),
        styles: PosStyles(bold: true, width: PosTextSize.size1));
    if((Companydata["companyProfileGstNo"])!=null) {
      ticket.text('GSTIN : ' +
          (Companydata["companyProfileGstNo"]).toString() + ' ',
          styles: PosStyles(bold: false,
            align: PosAlign.left,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ));
    }

    ticket.text('Date : $date');
    ticket.text('User : $userName');
    ticket.text('Customer : $customerName');

    //---------------------------------------------------------

    //---------------------------------------------------------

    ticket.hr(ch: '_');
    ticket.row([
      PosColumn(
        text:'No',
        styles: PosStyles(align: PosAlign.left),
        width:2,
      ),
      PosColumn(
        text:'Type',
        styles: PosStyles(align: PosAlign.left),
        width: 5,
      ),
      PosColumn(text: 'Received Amt', width: 5,styles:PosStyles(align: PosAlign.right)),
      // PosColumn(text: 'Qty', width: 2,styles: PosStyles(align: PosAlign.right ),),
      // // PosColumn(text: 'Tax', width: 2,styles: PosStyles(align: PosAlign.center ),),
      // PosColumn(text: ' Amonunt', width: 4,styles: PosStyles(align: PosAlign.center ),),
    ]);
    ticket.hr(); // for dot line or set ticket.hr(ch: 'charecter', linesAfter: 1);
    var snlnum=0;
    String type="";
    dynamic total = 0.000;
    for (var i = 0; i < slsDet.length; i++) {
      // total = slsDet[i]["amountIncludingTax"] + total;
      //  ticket.emptyLines(1);
      snlnum=snlnum+1;
      total=total+(slsDet[i]["rdAmount"]);
      (slsDet[i]["rdTransactionType"])==0? type="cash":type="Bank";
      ticket.row([
        PosColumn(text: (snlnum.toString()),width: 2,styles: PosStyles(
            align: PosAlign.left
        )),

        PosColumn(text: (type),
            width: 5,styles:
            PosStyles(align:PosAlign.left )),
        PosColumn(
            text: (((slsDet[i]["rdAmount"])).toStringAsFixed(2)).toString(),
            width: 5,
            styles: PosStyles(align: PosAlign.right
            )),
      ]);
    }


    ticket.hr(ch:"=",len: 32);
    ticket.row([
      PosColumn(
          text: 'Total',
          width: 4,
          styles: PosStyles(
            bold: true,align:PosAlign.left,
          )),
      PosColumn(
          text:'Rs '+(total.toStringAsFixed(2)).toString(),
          width: 8,
          styles: PosStyles(bold: true,align: PosAlign.right,)),
    ]);




    ticket.hr(ch: '_',len: 32 );

    ticket.row([
      PosColumn(
          text: 'OP.Balance',
          width: 4,
          styles: PosStyles(
            bold: true,align:PosAlign.left,
          )),
      PosColumn(
          text:'Rs '+(opAmtBlncPrnt.toStringAsFixed(2)).toString(),
          width: 8,
          styles: PosStyles(bold: true,align: PosAlign.right,)),
    ]);


    ticket.row([
      PosColumn(
          text: 'Rec.Amount',
          width: 4,
          styles: PosStyles(
            bold: true,align:PosAlign.left,
          )),
      PosColumn(
          text:'Rs '+(total.toStringAsFixed(2)).toString(),
          width: 8,
          styles: PosStyles(bold: true,align: PosAlign.right,)),
    ]);

    ticket.hr(
        ch: '=',len: 32 );

    ticket.row([
      PosColumn(
          text: 'Net Balance',
          width: 4,
          styles: PosStyles(
            bold: true,align:PosAlign.left,
          )),
      PosColumn(
          text:'Rs '+((opAmtBlncPrnt-total).toStringAsFixed(2)).toString(),
          width: 8,
          styles: PosStyles(bold: true,align: PosAlign.right,)),
    ]);
    ticket.hr(
        ch: '_',len: 32 );

    // ticket.row([
    //   PosColumn(text: ' ', width: 1),
    //   PosColumn(
    //       text: footerCaptions[0]['footerCaption'],
    //       width: 10,
    //       styles: PosStyles(align: PosAlign.center)),
    //   PosColumn(text: ' ', width: 1)
    // ]);
    //
    // ticket.row([
    //   PosColumn(text: '  ', width: 1),
    //   PosColumn(
    //       text: footerCaptions[0]['footerText'],
    //       width: 10,
    //       styles: PosStyles(align: PosAlign.center)),
    //   PosColumn(text: '  ', width: 1)
    // ]);

    ticket.feed(1);
    ticket.text('Thank You...Visit again !!',
        styles: PosStyles(align: PosAlign.center, bold: true));

    ticket.cut();
    return ticket;
  }
// //..................................................
//
//   wifiprinting() async {
//     try {
//       print(" print in");
//      _printerManager.selectPrinter('192.168.0.100');
//      //_printerManager.selectPrinter(null);
//       final res =
//       await _printerManager.printTicket(await _ticket(PaperSize.mm80));
//       print(" print in");
//     } catch (e) {
//       print("error on print $e");
//     }
//   }



  Priter_Initial_Part(){
    if (Platform.isAndroid) {
      bluetoothManager.state.listen((val) {
        print('state = $val');
        if (!mounted) return;
        if (val == 12) {
          print('on');
          searchPrinter();
        } else if (val == 10) {
          print('off');
          setState(() => _devicesMsg = 'Bluetooth Disconnect!');
          blutoothEnable();
        }
      });
    } else {
      searchPrinter();
    }


  }

  void searchPrinter() {
    try {
      _printerManager.startScan(Duration(seconds: 2));
      _printerManager.scanResults.listen((val) {
        if (!mounted) return;
        setState(() =>_devices = val);
        if (_devices.isEmpty) setState(() => _devicesMsg = 'No Devices');
      });
    }
    catch(e){print("result for scan print $e");}
  }

  blutoothprinting(){
    print(" on blutoothprinting");
    for(int i=0;i<_devices.length;i++){
      if(_devices[i].address=="00:11:22:33:44:55"){
        print("find _devices");
        print(_devices.length.toString());
        print(_devices[i].address);
        print(_devices[i].name);
        print(i.toString());
        _startPrint(_devices[i]);
        // dispose();
        break;
      }
    }

    print("not find _devices");

  }

  Future<void> _startPrint(PrinterBluetooth printer) async {
    _printerManager.selectPrinter(printer);
    final result = await _printerManager.printTicket(await _ticket(PaperSize.mm58));
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(result.msg),
      ),
    );
  }




  Future blutoothEnable() async {
    if (Theme.of(context).platform == TargetPlatform.android) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Blutooth is Off ?",
                style: TextStyle(color: Colors.red),
              ),
              content:
              const Text('Please make sure you enabled Blutooth for Printing'),
              actions: <Widget>[

                SizedBox(width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      TextButton(
                          child: Text('Cancel',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      Spacer(),
                      TextButton(
                          child: Text('Enable',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                          onPressed: () {
                            final AndroidIntent intent = AndroidIntent(
                                action:
                                'android.settings.BLUETOOTH_SETTINGS');
                            intent.launch();
                            Navigator.of(context, rootNavigator: true).pop();
                            // _gpsService();
                          }),
                    ],
                  ),
                )
              ],
            );
          });
    }
  }

//----------------------Print part End-----------------------------------------



}





class Receipt_Payment_Add {
  dynamic slNo;
  double receivedAmount;
  String remarks;
  dynamic image;
  dynamic rdtransactionType;
  dynamic LedgerAccount;
  dynamic LedgerAccount_id;
  dynamic Cheque_No;
  dynamic Cheque_Date;


  Receipt_Payment_Add({this.slNo,required this.receivedAmount,
    required this.remarks,this.image,this.rdtransactionType,
    this.LedgerAccount,this.LedgerAccount_id,
    this.Cheque_Date,this.Cheque_No});

  factory Receipt_Payment_Add.fromJson(Map<String, dynamic> parsedJson){
    return Receipt_Payment_Add(

        slNo: parsedJson["slNo"],
        receivedAmount:parsedJson["receivedAmount"].toDouble(),
        remarks: parsedJson["remarks"].toString(),
        image:parsedJson["image"],
        rdtransactionType: parsedJson['rdtransactionType'],
        LedgerAccount: parsedJson['LedgerAccount'],
        LedgerAccount_id: parsedJson['LedgerAccount_id'],
        Cheque_Date: parsedJson['Cheque_Date'],
        Cheque_No: parsedJson['Cheque_No']

    );
  }
}



class ReceiptCollection {

  double rdAmount;
  String rdRemarks;
  dynamic rdImgPath;
  dynamic rdtransactionType;
  dynamic lgr_id;
  dynamic Cheque_No;
  dynamic Cheque_Date;

  ReceiptCollection({required this.rdAmount,required this.rdRemarks,this.rdImgPath,
    this.rdtransactionType,this.lgr_id,this.Cheque_Date,this.Cheque_No});

  Map<String, dynamic> toJson()=>Map.from({
    "rdAmount": rdAmount, // double -> String
    "rdRemarks": rdRemarks,
    "rdImgPath": rdImgPath,
    "rdtransactionType":rdtransactionType,
    "lgr_id":lgr_id,
    "Cheque_Date":Cheque_Date,
    "Cheque_No":Cheque_No
  });

  factory ReceiptCollection.fromJson(Map<String, dynamic> parsedJson){
    return ReceiptCollection(

        rdAmount: parsedJson["rdAmount"].toDouble(), // String -> double
        rdRemarks:parsedJson["rdRemarks"].toString(),
        rdImgPath:parsedJson["rdImgPath"],
        rdtransactionType: parsedJson['rdtransactionType'],
        lgr_id: parsedJson['lgr_id'],
        Cheque_Date: parsedJson['Cheque_Date'],
        Cheque_No: parsedJson['Cheque_No']

    );
  }
}

