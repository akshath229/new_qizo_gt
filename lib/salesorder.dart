import 'dart:async';
import 'package:android_intent/android_intent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:new_qizo_gt/urlEnvironment/urlEnvironment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

// import 'package:esc_pos_utils/esc_pos_utils.dart';
// import 'package:esc_pos_printer/esc_pos_printer.dart';


import 'package:esc_pos_utils/esc_pos_utils.dart';

import 'GT_Masters/AppTheam.dart';
import 'GT_Masters/item_group.dart';
import 'Local_Db/Local_db_Model/Test_offline_Sales.dart';
import 'models/customersearch.dart';
import 'models/finishedgoods.dart';
import 'models/paymentcondition.dart';
import 'models/userdata.dart';
import 'models/usersession.dart';
BluetoothManager bluetoothManager = BluetoothManager.instance;
PrinterBluetoothManager _printerManager = PrinterBluetoothManager();

class SalesOrder extends StatefulWidget {
  final String url = "https://jsonplaceholder.typicode.com/users";

  int passvalue;
  dynamic passname;
  dynamic EditData;
  SalesOrder({required this.passvalue,this.passname,this.EditData});
  @override
  _SalesOrderState createState() => _SalesOrderState();
}

class _SalesOrderState extends State<SalesOrder> {
  bool ItemsAdd_Widget_Visible=false;
  late AutoCompleteTextField searchTextField;
  UserData? userData;
  String? branchName;
  dynamic userName;
  String? token;
  dynamic openingAmountBalance = 0.0;
  double grandTotal = 0;
  dynamic delivery = "";
  double itmtxper=0.0;
  double cessper=0.0;
  dynamic userArray;
  dynamic serverDate;
  UserSession? usr;
  String date = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());
  TextEditingController salesdeliveryController = new TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  bool autovalidate = false;
  // PrinterNetworkManager _printerManager = PrinterNetworkManager();
  dynamic user;
  int? branchId;
  int? userId;
  static List<FinishedGoods> goods = [];
  static List<PaymentCondition> payment = [];
  static List<UnitType> unit = [];

  int? customerSelectedId;
  String? customerSelectedEmail;
  String? customerSelectedName;
  List<PrinterBluetooth> _devices = [];
  TextEditingController controller = new TextEditingController();
  FocusNode field1FocusNode = FocusNode(); //Create first FocusNode

  String? selectedLetter;
  TextEditingController customerController = new TextEditingController();
  TextEditingController goodsController = new TextEditingController();
  TextEditingController quantityController = new TextEditingController();
  TextEditingController rateController = new TextEditingController();
  TextEditingController generalRemarksController = new TextEditingController();
  TextEditingController paymentController = new TextEditingController();
  TextEditingController UnitController = new TextEditingController();
  GlobalKey<AutoCompleteTextFieldState<Customer>> key =
  new GlobalKey(); //only one autocomplte
  String selectedPerson = "";
  CustomerAdd? customer;
  Salesorder? sale;
  int salesItemId = 0;
  int salesLedgerId = 0;
  int salesPaymentId = 0;
  int unitId=0;
  dynamic deliveryDate;
  var formatter = NumberFormat('#,##,##,##,##0.00');
//   validation variables
  bool customerSelect = false;
  bool itemSelect = false;
  bool paymentSelect = false;
  bool deliveryDateSelect = false;
  bool rateSelect = false;
  bool quantitySelect = false;
  bool unitSelect = false;
  var dataForTicket;
  static List<Salesorder> sales = [];
  static List<CustomerAdd> customerItemAdd = [];
  static List<Customer> users = [];

  bool loading = true;
  final letters = 'abcdefghijklmnopqrstuvwxyz'.split('');

  SharedPreferences? pref;
  var  _devicesMsg="";
  dynamic slsname;
  var Companydata;
  List<dynamic> batchdata = [];
  List<dynamic> multibatchdata = [];
  bool boxvisible=true;
  double? Srate;
  dynamic Edate;
  dynamic batchnum;
  dynamic nosunt;
  dynamic Brcode;
  dynamic StkId;
  dynamic Hsncode="";
  dynamic itmqty = "";
  double CgstPer=0.0;
  double SgstPer=0.0;
  double Igstper=0.0;
  int TaxId=0;
  // Inter_Net_And_Blutooth_Connection kart=Inter_Net_And_Blutooth_Connection();
  // Test(){
  // kart.internet_check();
  // }

  double TextBoxHeight=40;
  bool? TaxInOrExc;

  AppTheam theam=AppTheam();


//  get Token
  read() async {
    var v = pref?.getString("userData");
    print("USER DATA: $v");
    var c = json.decode(v!);
    user = UserData.fromJson(c); // token gets this code user.user["token"]

    setState(() {
      branchId =int.parse(c["BranchId"]) ;
      print("user data................");
      print(user.user["token"]);
      token = user.user["token"]; //  passes this user.user["token"]
      pref?.setString("customerToken", user.user["token"]);
      branchName = user.branchName;
      userName = user.user["userName"];
      print(".....");
      print(branchName);
      print(userName);
      userId=user.user["userId"];
      GetCompantPro(branchId);
    });
  }

  // get customer account
  getCustomer() async {
    try {
      final response =
      await http.get("${Env.baseUrl}${Env.CustomerURL}" as Uri, headers: {
        "Authorization": user.user["token"],
      });
      print(response.statusCode);

      if (response.statusCode == 200) {
        print('...................');
        Map<String, dynamic> data = json.decode(response.body);
        print("array is");
        print(data["lst"]); //used  this to autocomplete
        print("........");
        print(response.statusCode);
        print(data["lst"]);
        userArray = data["lst"];
        users = (data["lst"] as List)
            .map<Customer>((customer) =>
            Customer.fromJson(Map<String, dynamic>.from(customer)))
            .toList();
//        users=loadUsers(s.toString());
        return users;
      } else {
        print("Error getting users");
      }
    } catch (e) {
      print("Error on getting users : $e");
    }
  }

  //get customer ledger balance
  getCustomerLedgerBalance(int accountId) async {
    salesLedgerId = accountId;
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
        setState(() {
          serverDate = list[0]["workingDate"];
        });
        var formatter =
        new DateFormat('MM-dd-yyyy'); // this dd-MM-yyyy format i want

        String formattedDate = formatter
            .format(DateTime.parse(list[0]["workingDate"].substring(0, 10)));
        print(formattedDate);

        getLedger(accountId, formattedDate);
      } else {
        print("Error getting users");
      }
    } catch (e) {
      print("Error getting users" + e.toString());
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
//      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.body);
        var e = json.decode(response.body);
        print(e["openingAmount"]);
        setState(() {
          if (e["openingAmount"] > 0.0) {
            openingAmountBalance = e["openingAmount"];
          } else {
            print("opening amount is zero");
          }
        });
      }
    } catch (e) {
      print("error" + e.toString());
    }
  }
  GetUnit() async {
    String url = "${Env.baseUrl}GtUnits";
    try {
      final res =
      await http.get(url as Uri, headers: {"Authorization": user.user["token"]});
      print("Units");
      if(res.statusCode==200) {
        List <dynamic> tagsJson = json.decode(res.body)['gtunit'];
        List<UnitType> ut = tagsJson.map((tagsJson) =>
            UnitType.fromJson(tagsJson)).toList();
        print("uuuu : $ut");
        unit = ut;
      }
    } catch (e) {
      print("error on  unit= $e");
    }
  }

  getFinishedGoods() async {
    String url = "${Env.baseUrl}GtItemMasters/1/1";
    try {
      final res =
      await http.get(url as Uri, headers: {"Authorization": user.user["token"]});

      print("goods Condition");
      // print("statusCode"+res.statusCode.toString());
      if(res.statusCode==200) {
        // print(res.body);
        // print("json decoded");
        var tagsJson = json.decode(res.body);
        print("item list");
        print(tagsJson);
        List<dynamic> t = json.decode(res.body);
        List<FinishedGoods> p = t
            .map((t) => FinishedGoods.fromJson(t))
            .toList();

        // print(p);
        goods = p;
      }
    } catch (e) {print("error on getFinishedGoods : $e");}
  }

  // get finished goods
//  getFinishedGoods() async {
//    String url = "${Env.baseUrl}MItemMasters/0/2";
//    try {
//      final res =
//          await http.get(url, headers: {"Authorization": user.user["token"]});
//
//      print("finshed goods");
//      print(res.body);
//
//      print("json decoded");
//
//      var tagsJson = json.decode(res.body);
//      print(tagsJson);
//      List<dynamic> t = json.decode(res.body);
//      List<FinishedGoods> g = t.map((t) => FinishedGoods.fromJson(t)).toList();
//
//      print(g);
//      goods = g;
//    } catch (e) {}
//  }

  // get payment Condition
  getPaymentCondition() async {
    String url = "${Env.baseUrl}Mconditions";
    try {
      final res =
      await http.get(url as Uri, headers: {"Authorization": user.user["token"]});

      print("payment Condition");
      if(res.statusCode==200) {
        print(res.body);

        print("json decoded");

        var tagsJson = json.decode(res.body);
        print(tagsJson);
        List<dynamic> t = json.decode(res.body);
        List<PaymentCondition> p =
        t.map((t) => PaymentCondition.fromJson(t)).toList();

        print(p);
        payment = p;
      }
    } catch (e) { print("error on getPaymentCondition: $e");}
  }

//  sales order

  salesOrder() async {
    final url = "${Env.baseUrl}Soheader";
    print("sales length");
    print(sales.length);
    print(jsonEncode(sales));
    // print("list length");
    // print(customerItemAdd.length);
    delivery = "";
    delivery = salesdeliveryController.text.toString();
    var remarks = generalRemarksController.text.toString();
//    print(sales[sales.length]);
//     print("sales ledger Id");
//     print(salesLedgerId);
//     print("sales Item Id");
//     print(salesItemId);
//     print("sales payment Id");
//     print(salesPaymentId);
//     print("server date");
//     print(serverDate);
//     print("delivery date");
//     print(deliveryDate);

    // print(salesdeliveryController.text);
    var req = {
      "voucherDate": serverDate.toString(),
      "expDate": serverDate.toString(),
      "ledgerId": salesLedgerId,
      "partyName": userName,
      "address1": null,
      "address2": null,
      "gstNo": null,
      "phone": null,
      "shipToName": null,
      "shipToAddress1": null,
      "shipToAddress2": null,
      "shipToPhone": null,
      "narration": remarks,
      "amount": grandTotal,
      "userId": userId,
      "branchId": branchId,
      // "sohAppMode":"Mobile",
      "ledgerName": branchName,
      "sodetailed": sales
    };
    print(req);
    // return;
    setState(() {
      if (salesLedgerId == 0 || customerController.text == "") {
        customerSelect = true;
      } else {
        customerSelect = false;
      }

      // if (salesPaymentId == 0 || paymentController.text == "") {
      //   paymentSelect = true;
      // } else {
      //   paymentSelect = false;
      // }
      if (delivery != "") {
        deliveryDateSelect = false;

        return;
      } else {
        deliveryDateSelect = true;
      }
    });
    // print(req);
    // return;
    setState(() {

    });
    if (customerSelect || deliveryDateSelect
        || customerItemAdd.length <= 0 ||sales.length <=0) {


      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "Please Check the fields",
              style: TextStyle(color: Colors.red),
            ),
//              content: Text("user data:   " + user.user["token"]),
          ));
    } else {
      var params = json.encode(req);
      print("after print");
      print(params);


      var res = await http.post(url as Uri,
          headers: {
            'accept': 'application/json',
            'content-type': 'application/json',
            'Authorization': user.user["token"],
            'deviceId': user.deviceId
          },
          body: params);

      print("save rsponse statusCode: "+res.statusCode.toString());
      if (res.statusCode == 200 ||
          res.statusCode == 201 &&
              customerItemAdd.length > 0 &&
              sales.length > 0 &&
              salesLedgerId > 0
      ) {
        print("save rsponse body : "+res.body.toString());
        var retunid = await jsonDecode(res.body);
        GetdataPrint(retunid['id']);
        setState(() {

          customerItemAdd.clear();
          sales.clear();
          customerController.text = "";
          salesdeliveryController.text = "";
          generalRemarksController.text = "";
          paymentController.text = "";

          salesLedgerId = 0;
          salesItemId = 0;
          salesPaymentId = 0;
          grandTotal = 0;
        });

        showDialog(
          barrierDismissible: false,
            context: context,
            builder: (context) => AlertDialog(
              title: Center(child: Text("Sales Order Saved")),
            ));
        rateSelect = false;
        quantitySelect = false;
        Timer(Duration(seconds: 1), () {
          print("Yeah, this line is printed after 2 seconds");
          Navigator.pop(context);
        });
      }
    }
//    customerItemAdd = [];
//    sales
  }

//  static List<Customer> loadUsers(String jsonString) {
//    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
//    return parsed
//        .map<Customer>((json) => Customer.fromJson(json))
//        .toList(); //return full data then see auto complte res ok asynchronous
//  }

  @override
  void initState() {
    // print("ddddd"+ widget.passvalue.toString() + widget.passname.toString());


    //print("ddddd"+ widget.passname);
    if(widget.passname!= "null" &&widget.EditData==null)  // Create New
        {

      print("value rctptclln= " + widget.passvalue.toString());
      customerController.text = widget.passname.toString();
      salesLedgerId = widget.passvalue;
      getCustomerLedgerBalance(salesLedgerId);
      slsname=widget.passname;
    }else if(widget.EditData!=null) // Edit
        {
      print("Edit");
      customerController.text = widget.passname.toString();
      salesLedgerId = widget.passvalue;
      getCustomerLedgerBalance(salesLedgerId);
      slsname=widget.passname;
    }

    print("url: ${Env.baseUrl}");
    print("......");
    // customerController.text = "";
    goodsController.text = "";
    SharedPreferences.getInstance().then((value) {
      pref = value;
      read();
      getCustomer();
      getFinishedGoods();
//      getFinishedGoods();
      getPaymentCondition();
      GetUnit();
      salesdeliveryController.text=DateFormat("dd-MM-yyyy").format(DateTime.now());
      Priter_Initial_Part();

      if(widget.EditData!=null){
        getDataEdit();
      }
    });
    // token get fun  this

    // auto compelete fun
//    getUsers();
    super.initState();
    customerController.addListener(customerLedgerIdListener);
    goodsController.addListener(itemIdListener);
    paymentController.addListener(paymentIdListener);
    UnitController.addListener(unitIdListener);
  }

  getItemIndex(dynamic item) {
    var index = customerItemAdd.indexOf(item);
    return index + 1;
  }

  customerLedgerIdListener() {
    setState(() {
      salesLedgerId = 0;
      openingAmountBalance = 0;
      print(customerController.text);
      print("item");
    });
  }

  itemIdListener() {
    setState(() {
      print("Item    .....................");
      salesItemId = 0;
      print(goodsController.text);
    });
  }

  paymentIdListener() {
    print("payment");
    salesPaymentId = 0;

    print(paymentController.text);
  }


  unitIdListener() {
    print("Unit");
    unitId = 0;
    print(UnitController.text);
  }

  validationQuantity() {
    if (quantityController.text == "") {
      quantitySelect = true;
      validationRate();
    } else {
      quantitySelect = false;
      validationRate();
    }
  }

  validationRate() {
    if (rateController.text == "") {
      rateSelect = true;
      validationUnit();
    } else {
      rateSelect = false;
      validationUnit();
    }
  }
  validationUnit() {
    if ( unitId <= 0) {
      unitSelect = true;

    } else {
      unitSelect = false;
    }
  }








// add customer item
  addCustomerItem() {
    var nettotal=0.00;
    print("add...... ");
    setState(() {
      if (salesItemId == 0 || goodsController.text == "") {
        itemSelect = true;
        validationQuantity();
//      validationRate();
      } else {
        itemSelect = false;
        validationQuantity();
//      validationRate();
      }
    });

    if (rateController.text == "" ||
        quantityController.text == "" ||unitId <= 0||
        salesItemId <= 0) {
      print("check fields");
      print(salesItemId);
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("check fields"),
//              content: Text("user data:   " + user.user["token"]),
          ));
      return;
    }
    var amount = double.parse(quantityController.text) *
        double.parse(rateController.text);


    print(amount);
    print(customerItemAdd.length);
    print(goodsController.text);
    print(quantityController.text);
    print(rateController.text);

    setState(() {
      // grandTotal= ((amount/100)*(itmtxper+cessper))+grandTotal+amount; // with tax
      //
      // nettotal= ((amount/100)*(itmtxper+cessper))+amount;



      ///--------test calc with tax----------------

      var rate= double.parse(rateController.text);
      dynamic Igst=double.parse(((rate/100)*Igstper).toStringAsFixed(2));

      print("amount $amount");
      dynamic  aftertax=0;
      dynamic  befortax=0;
      var igst=0.00;
      var taxOneItm;
      var taxAmtOfCgst;
      var taxAmtOfSgst;
      var  ToatalTax;


      if(TaxInOrExc==true){

        var WithOutTaxamt=((itmtxper+100)/100);
        print("in inclusive");
        print(WithOutTaxamt.toString());
        taxOneItm=rate/WithOutTaxamt;
        taxAmtOfCgst=(WithOutTaxamt/2);
        taxAmtOfSgst=(WithOutTaxamt/2);
        // ToatalTax =taxOneItm*double.parse(quantityController.text);
        grandTotal = grandTotal + amount;
        aftertax= amount;
        befortax=taxOneItm*double.parse(quantityController.text);
        print("aftertax $aftertax");
        print("befortax $befortax");
        print("grandTotal $grandTotal");
      }
      else{
        print("in Exclusive");
        taxOneItm =((rate/100)*(itmtxper+cessper));
        taxAmtOfCgst=(taxOneItm/2);
        taxAmtOfSgst=(taxOneItm/2);
        ToatalTax =taxOneItm*double.parse(quantityController.text);
        grandTotal = grandTotal + ToatalTax + amount;
        aftertax=ToatalTax + amount;
        befortax=amount;
      }


      // if(GSTtyp==true){
      //   igst= Igst*double.parse(quantityController.text);
      //   taxAmtOfCgst=0;
      //   taxAmtOfSgst=0;
      // }



      print("grandTotal $grandTotal");
      var Shid=0;
      if(widget.EditData==[]||widget.EditData==null){

        Shid=0;

      }else{
        Shid= widget.EditData["id"].toInt();
      }
      sale = Salesorder(
        id: Shid,
        itemId: salesItemId,
        qty: double.parse(quantityController.text),
        rate: aftertax,//double.parse(rateController.text),
        note: null,
        unitId: unitId,
        StockId:StkId,
      );

      sales.add(sale!);
      print(".............");
      print(sale?.itemId);
      print(sale?.qty);
      print(sale?.rate);
      print(sales);
      print("............");


      customer = CustomerAdd(
          id: salesItemId,
          slNo: customerItemAdd.length + 1,
          item: goodsController.text,
          quantity: double.parse(quantityController.text),
          rate: double.parse(rateController.text),
          txper:itmtxper,
          cess:cessper,
          amount: aftertax,
          NetAmt: grandTotal);
      // amount: ((amount/100)*(itmtxper+cessper))+amount);
      print(customer.item);
    });
    setState(() {
      customerItemAdd.add(customer!);
      ItemsAdd_Widget_Visible=false;
    });
    print(customerItemAdd);
    goodsController.text = "";
    quantityController.text = "";
    rateController.text = "";
    UnitController.text = "";
  }

  // remove customer items
  removeListElement(int id, int sl, double amount) {
    print(sl);
    print("sl");
    print("grandTotal $grandTotal");
    print(amount.toString());
    sales.removeWhere((element) => element.itemId == id);
    customerItemAdd.removeWhere((element) => element.slNo == sl);
    // customerItemAdd.removeWhere((element) => element.id == id);
    grandTotal = grandTotal - amount;

    print("deleted $grandTotal");
//   customerItemAdd.indexOf(sl);

//    print('item:$name  rate: $price');
  }

//-------------------------------item-----Batch Check--------------------------------------------

  getbatch(id)async
  {
    String url = "${Env.baseUrl}GtStocks/$id/1/";
    try {
      final res =
      await http.get(url as Uri, headers: {"Authorization": user.user["token"]});
      print("batch data GtStocks/$id/1/");
      // print(res);
      var tagsJson = json.decode(res.body);

      batchdata = tagsJson['stockBatch'] as List;
      batchdata.forEach(print);
      print("batchdata length");
      print(batchdata.length);
      print(batchdata);



      if (batchdata.length >1) {
        boxvisible =true;

        showDialog(
            context: context,
            builder: (context) =>
                Visibility(
                  visible:boxvisible,
                  child: AlertDialog(
                    actions: [
                      Container(
                        height: 300,
                        width: 350,
                        child: Row(
//            verticalDirection: VerticalDirection.down,
//            crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            SizedBox(
                              width: 3,
                            ),

                            Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: DataTable(showCheckboxColumn: false,
                                      columnSpacing: 17,
                                      onSelectAll: (b) {},
                                      sortAscending: true,
                                      columns: <DataColumn>[
                                        DataColumn(
                                          label: Text('Name'),
                                        ),
                                        DataColumn(
                                          label: Text('Rate'),
                                        ),
                                        DataColumn(
                                          label: Text('Expiry Date'),
                                        ),
                                        DataColumn(
                                          label: Text('Batch No'),
                                        ),
                                        // DataColumn(
                                        //   label: Text('Amount'),
                                        // ),
                                        // DataColumn(
                                        //   label: Text('Add'),
                                        // ),
                                      ],
                                      rows: batchdata
                                          .map(
                                            (itemRow) => DataRow(
                                          onSelectChanged:(a){
                                            print(itemRow['id']);
                                            // id: 21
                                            multibatchitembinding(itemRow);

                                            Navigator.pop(context);
                                          } ,
                                          cells: [
                                            DataCell(
                                              Text(
                                                  '${itemRow['itmName'].toString()}'),
                                              showEditIcon: false,
                                              placeholder: false,
                                            ),
                                            DataCell(
                                              Text(
                                                  '${itemRow['prate'].toString()}'),
                                              showEditIcon: false,
                                              placeholder: false,
                                            ),
                                            DataCell(
                                              GestureDetector(
                                                onTap: () {},
                                                child:
                                                //Text( '${DateFormat("dd-MM-yyyy").format(DateTime.parse(itemRow['expiryDate']))}'),
                                                Text((itemRow['expiryDate'])==null?"-:-:":(DateFormat("dd-MM-yyyy").format(DateTime.parse(itemRow['expiryDate'])))),
                                              ),
                                              showEditIcon: false,
                                              placeholder: false,
                                            ),
                                            DataCell(
                                              GestureDetector(
                                                onTap: () {},
                                                child: Text('${itemRow['batchNo']??"-"}'),

                                              ),
                                              showEditIcon: false,
                                              placeholder: false,
                                            ),
                                            // DataCell(
                                            //   GestureDetector(
                                            //       onTap: () {print(itemRow['id']);
                                            //       // id: 21
                                            //       multibatchitembinding(itemRow);
                                            //
                                            //       Navigator.pop(context);
                                            //       },
                                            //       child: Icon(Icons.add_circle_outline_sharp)),
                                            // ),
                                          ],
                                        ),
                                      )
                                          .toList(),
                                    ),
                                  ),
                                )),
                            SizedBox(
                              width: 3,
                            )
                          ],
                        ),
                      )
                    ],
//              content: Text("user data:   " + user.user["token"]),
                  ),
                ));
      }

      else if(batchdata.length ==0) {
        print("with one Stock");


        dynamic j = [];
        j = {
          "id":0,
          "itemId": id,
          "expiryDate": null,
          "srate": 0,
          "batchNo":0,
          "nos":0,
          "barcode":0
        };
        print(j);
        multibatchitembinding(j);

        //   showDialog(
        //     context: context,
        //     builder: (context) =>
        //         AlertDialog(
        //           actions: [
        //             Container(
        //                 height: 60,
        //                 width: 350,
        //                 child:  Center(
        //                     child: Text("Stock Not Available...!",style:TextStyle(color: Colors.redAccent,fontSize: 20),)
        //                 )),
        //
        //           ],
        //         ),
        //   );
        //   Timer(Duration(seconds: 1), () {
        //     Navigator.pop(context);
        //   });
        // }
      }
      else{
        print("with one data") ;
        print(batchdata[0]["itmName"]) ;

        dynamic j=[];
        j={
          "id":batchdata[0]["id"],
          "itemId":id,
          "expiryDate":batchdata[0]["expiryDate"],
          "srate":0,
          "batchNo":batchdata[0]["batchNo"],
          "nos":batchdata[0]["nos"],
          "barcode":batchdata[0]["barcode"]
        };
        print(j);
        multibatchitembinding(j);
      }


    } catch (e) {
      print("error on  batch = $e");
    }

  }




  //-------------------------------Set selected item details--------------------------------------
  multibatchitembinding(rowdata)async {
    print(rowdata);
    print("888888 data bind");
    Edate=rowdata['expiryDate'];
    //Srate=rowdata['srate'];
    batchnum=rowdata['batchNo'];
    nosunt=rowdata['nos'];
    Brcode=rowdata['barcode'];
    StkId=rowdata['id'];
    // rateController.text=Srate.toString();
    int id=rowdata['itemId'];
    salesItemId =id;
    print(id.toString());
    String url = "${Env.baseUrl}GtItemMasters/$salesItemId";
    try {
      final res =
      await http.get(url, headers: {"Authorization": user.user["token"]});
      print("batch data");
      print(res.statusCode);
      var tagsJson = jsonDecode(res.body)["result"][0];


      // print("555555");
      print(tagsJson);
      print(tagsJson['description']);

      //goodsController.text =name;

      print("close.... $salesItemId");



      // salesItemId = tagsJson["id"];
      goodsController.text = tagsJson["itmName"];


      // print("nnnnn $salesItemId");
      // print("nnnnn "+goodsController.text);


      (tagsJson["txPercentage"] == null ||tagsJson["txPercentage"] == "null") ? itmtxper=0.0:itmtxper =tagsJson["txPercentage"];
      (tagsJson["atPercentage"] == null ||tagsJson["atPercentage"] == "null") ? cessper=0.0:cessper =tagsJson["atPercentage"];
      (tagsJson["description"] == null ||tagsJson["description"] == "null") ?  UnitController.text="": UnitController.text =tagsJson["description"];
      (tagsJson["itmUnitId"] == null ||tagsJson["itmUnitId"] == "null") ? unitId=null: unitId =tagsJson["itmUnitId"];
      (tagsJson["itmHsn"] == null ||tagsJson["itmHsn"]  == "null") ?  Hsncode ="": Hsncode =tagsJson["itmHsn"];
      (tagsJson["txCgstPercentage"] == null ||tagsJson["txCgstPercentage"] == "null") ?  CgstPer =0: CgstPer =tagsJson["txCgstPercentage"];
      (tagsJson["txSgstPercentage"] == null ||tagsJson["txSgstPercentage"] == "null") ?  SgstPer =0: SgstPer =tagsJson["txSgstPercentage"];
      (tagsJson["txIgstpercentage"] == null ||tagsJson["txIgstpercentage"] == "null") ?  Igstper =0: Igstper =tagsJson["txIgstpercentage"];
      (tagsJson["itmTaxId"] == null ||tagsJson["itmTaxId"]  == "null") ?  TaxId=0: TaxId =tagsJson["itmTaxId"];
      (tagsJson["itmSalesRate"] == null ||tagsJson["itmSalesRate"]  == "null") ?  Srate=0: Srate =tagsJson["itmSalesRate"];
      rateController.text=Srate.toString();
      //Srate=rowdata['itmSalesRate'];
      print("11111111$SgstPer");
      print(tagsJson["description"]);
      print  ("11111$Hsncode");
      TaxInOrExc=tagsJson["itmTaxInclusive"];
    }
    catch (e) {
      print("error on  batch = $e");
    }
  }
  //----------------------------------------------------------------------
  Future<bool> _onBackPressed() {
    //  // Navigator.pop(context,salesLedgerId);
    ResetFun();
    Navigator.pop(context);



    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => CustomerVisited(a:salesLedgerId.toString(),b:slsname.toString(),)),  );
    //


  }




  //--------------reset functions------------------------
  ResetFun(){
    ItemsAdd_Widget_Visible=false;
    customerSelect = false;
    deliveryDateSelect = false;
    rateSelect = false;
    quantitySelect = false;
    itemSelect = false;
    unitSelect = false;
    paymentSelect = false;
    customerItemAdd.clear();
    sales.clear();
    customerController.text = "";
    salesdeliveryController.text = "";
    generalRemarksController.text = "";
    paymentController.text = "";
    grandTotal = 0;
    salesPaymentId = 0;
    salesItemId = 0;
    salesLedgerId = 0;
    goodsController.text="";
    quantityController.text="";
    rateController.text="";
    UnitController.text="";
    unitId=0;

  }


  //------------------------------------






  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
//      key: scaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(190.0),
          child:  Appbarcustomwidget(uname: userName, branch: branchName, pref: pref, title: "Sales Order")
        ),



        body: ListView(
          //scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(height: 10),
            SizedBox(height:customerSelect==true?60: TextBoxHeight,
              child: Row(
                children: [
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
//                            errorText: _validateName ? "please enter name" : null,
//                            errorBorder:InputBorder.none ,
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.remove_circle),
                                  color: Colors.blue,
                                  onPressed: () {
                                    setState(() {
                                      print("cleared");
                                      customerController.text = "";
                                      salesLedgerId = 0;
                                      openingAmountBalance = 0;
                                    });
                                  },
                                ),

                                isDense: true,
                                contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14.0)),
                                // i need very low size height
                                labelText:
                                'customer search', // i need to decrease height
                              )),
                          suggestionsBoxDecoration: SuggestionsBoxDecoration(elevation: 90.0),
                          suggestionsCallback: (pattern) {
                            return users.where((user) =>
                                user.lhName.toUpperCase().contains(pattern.toUpperCase()));
                          },
                          itemBuilder: (context, suggestion) {
                            return Card(
                              color:theam.DropDownClr,
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
                            print("close.... $salesLedgerId");
                            salesLedgerId = 0;
                            slsname = suggestion.lhName;
                            print(suggestion.id);
                            print(".......sales Ledger id");
                            salesLedgerId = suggestion.id;
                            if (suggestion.id != null) {
                              getCustomerLedgerBalance(suggestion.id);
                            }
                            print(salesLedgerId);
                            print("...........");
                          },
                          errorBuilder: (BuildContext context, Object error) =>
                              Text('$error',
                                  style: TextStyle(
                                      color: Theme.of(context).errorColor)),
                          transitionBuilder:
                              (context, suggestionsBox, animationController) =>
                              FadeTransition(
                                child: suggestionsBox,
                                opacity: CurvedAnimation(
                                    parent: animationController,
                                    curve: Curves.elasticIn),
                              ))),
                  SizedBox(
                    width: 10,
                  )
                ],
              ),
            ),
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

            SizedBox(height: TextBoxHeight,
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      style: TextStyle(fontSize: 15),
                      showCursor: true,
                      controller: salesdeliveryController,
                      enabled: true,
                      validator: (v) {
                        if (v.isEmpty) return "Required";
                        return null;
                      },
//
                      // will disable paste operation
                      focusNode: field1FocusNode,
                      cursorColor: Colors.black,

                      scrollPadding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                      keyboardType: TextInputType.datetime,
                      readOnly: true,

                      onTap: () async {
                        final DateTime now = DateTime.now();
                        DateTime date = await showDatePicker(
                            context: context,
                            initialDatePickerMode: DatePickerMode.day,
                            initialDate: now,
                            firstDate: now.subtract(Duration(days: 1)),
                            lastDate: DateTime(2080),
                            builder: (BuildContext context, Widget child) {
                              return Theme(
                                data: ThemeData.light(),
                                child: child,
                              );
                            });

                        if (date != null) {
                          print(date);
                          if (date.day < DateTime.now().day) {
                            print("invalid date select");

                            salesdeliveryController.text = "";
                            return;
                          } else {
                            deliveryDate = date;
                            var d = DateFormat("yyyy-MM-d").format(date);
                            salesdeliveryController.text = d;
                          }
                        }
                      },
                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.red),
                        errorText: deliveryDateSelect ? "invalid date " : null,
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          color: Colors.blue,
                          size: 24,
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0)),
                        // curve brackets object
                        hintText: "Delivery Date:dd/mm/yy",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                        labelText: "Delivery Date",
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
            SizedBox(
              height: 6,
            ),





            AddItemWidgets(ItemsAdd_Widget_Visible),



            SizedBox(height: paymentSelect==true?60:TextBoxHeight,
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                      child: TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                              style: TextStyle(),
                              controller: paymentController,
                              decoration: InputDecoration(
                                errorStyle: TextStyle(color: Colors.red),
                                errorText: paymentSelect
                                    ? "Invalid Payment Selected"
                                    : null,
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.remove_circle),
                                  color: Colors.blue,
                                  onPressed: () {
                                    setState(() {
                                      print("cleared");
                                      paymentController.text = "";
                                      salesPaymentId = 0;
                                    });
                                  },
                                ),

                                isDense: true,
                                contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14.0)),
                                // i need very low size height
                                labelText:
                                'Payment Condition', // i need to decrease height
                              )),
                          suggestionsBoxDecoration:
                          SuggestionsBoxDecoration(elevation: 90.0),
                          suggestionsCallback: (pattern) {
//                        print(payment);
                            return payment
//                            .where((user) => goods.itmName == pattern);
                                .where((us) => us.conDescription.contains(pattern));
                          },
                          itemBuilder: (context, suggestion) {
                            return Card(
                              color:theam.DropDownClr,
                              // shadowColor: Colors.blue,
                              child: ListTile(
                                // focusColor: Colors.blue,
                                // hoverColor: Colors.red,
                                title: Text(
                                  suggestion.conDescription,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            print(suggestion.conDescription);
                            print("Item selected");

                            paymentController.text = suggestion.conDescription;
                            print("close.... $salesPaymentId");
                            salesPaymentId = 0;

                            print(suggestion.id);
                            print(".......sales Item id");
                            salesPaymentId = suggestion.id;
                            print(salesPaymentId);
                            print("...........");
                          },
                          errorBuilder: (BuildContext context, Object error) =>
                              Text('$error',
                                  style: TextStyle(
                                      color: Theme.of(context).errorColor)),
                          transitionBuilder:
                              (context, suggestionsBox, animationController) =>
                              FadeTransition(
                                child: suggestionsBox,
                                opacity: CurvedAnimation(
                                    parent: animationController,
                                    curve: Curves.elasticIn),
                              ))),
//              SizedBox(height: 10),
                  Visibility(visible:!ItemsAdd_Widget_Visible,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10,right: 10),
                      child:   ElevatedButton(style: ButtonStyle( backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),),
                          onPressed: (){
                            setState(() {
                              ItemsAdd_Widget_Visible=!ItemsAdd_Widget_Visible;
                            });
                          }, child:Text("ADD ITEMS",style: TextStyle(fontSize: 17),)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 6,
            ),
            SizedBox(height: TextBoxHeight,
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: generalRemarksController,
                      enabled: true,
                      validator: (v) {
                        if (v.isEmpty) return "Required";
                        return null;
                      },
//
//                  focusNode: field1FocusNode,
                      cursorColor: Colors.black,

                      scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                      keyboardType: TextInputType.text,

                      decoration: InputDecoration(
//                    suffixIcon: Icon(
//                      Icons.calendar_today,
//                      color: Colors.blue,
//                      size: 24,
//                    ),
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 16.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0)),
                        // curve brackets object
//                    hintText: "Quantity",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                        labelText: "General Remarks",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Row(mainAxisAlignment:MainAxisAlignment.center,
              children: [
                // SizedBox(
                //   width: 10,
                // ),
                GestureDetector(
                    onTap: () {
                      print(widget.passvalue.toString());
                      if(widget.passvalue==null ||widget.passvalue==0){
                        print("for Save");
                        print("Save");
                        salesOrder();
                      }else{
                        print("from edit");
                        UpdateEdit();
                      }

                    },
                    child:Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:theam.saveBtn_Clr,
                        ),
                        width: 100,
                        height: 40,
                        child: Center(
                          child: Text(widget.passvalue==0?
                            "Save":"Update",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )

                ),
                Spacer(),
                //SizedBox(width: 185,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                      onTap: () {
                        print("Reset");
                        setState(() {
                          ResetFun();
                        });
                      },
                      child:Container(
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
                      )

                  ),
                ),


                // GestureDetector(child: Text("ddddddddd"),
                // onTap: (){
                //   GetdataPrint(31);
                // },)

                // Padding(
                //   padding: EdgeInsets.only(left: 164.0, right: 0.0),
                //   child: RaisedButton(
                //     textColor: Colors.white,
                //     color: Colors.lightBlueAccent,
                //     child: Text("Reset"),
                //     onPressed: () {
                //       setState(() {
                //         customerSelect = false;
                //         deliveryDateSelect = false;
                //         rateSelect = false;
                //         quantitySelect = false;
                //         itemSelect = false;
                //         paymentSelect = false;
                //         customerItemAdd.clear();
                //         sales.clear();
                //         customerController.text = "";
                //         salesdeliveryController.text = "";
                //         generalRemarksController.text = "";
                //         paymentController.text = "";
                //         grandTotal = 0;
                //         salesPaymentId = 0;
                //         salesItemId = 0;
                //         salesLedgerId = 0;
                //       });
                //     },
                //     shape: new RoundedRectangleBorder(
                //       borderRadius: new BorderRadius.circular(14.0),
                //     ),
                //   ),
                // ),
              ],
            ),
            GestureDetector(onTap: (){
              // GetdataPrint(4);
              //  Test();
            },
              child: Text(""),),
            Visibility(
              visible: customerItemAdd.length > 0,
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
                        columnSpacing: 17,
                        onSelectAll: (b) {},
                        sortAscending: true,
                        columns: <DataColumn>[
                          DataColumn(
                            label: Text('No'),
                          ),
                          DataColumn(
                            label: Text('Item'),
                          ),
                          DataColumn(
                            label: Text('Quantity'),
                          ),
                          DataColumn(
                            label: Text('Rate'),
                          ),
                          DataColumn(
                            label: Text(''),//label: Text('Tax %'),
                          ),
                          DataColumn(
                            label: Text(''),// label: Text('Cess %'),
                          ),
                          DataColumn(
                            label: Text('Amount'),
                          ),
                          DataColumn(
                            label: Text(' '),
                          ),
                        ],
                        rows: customerItemAdd
                            .map(
                              (itemRow) => DataRow(
                            cells: [
                              DataCell(
                                Text(getItemIndex(itemRow).toString()),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Text(itemRow.item),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Text(itemRow.quantity.toString()),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Text(itemRow.rate.toString()),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Text(''),  //  Text((itemRow.txper)!=null?itemRow.txper.toString():0.0.toString()),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Text(''),//   Text((itemRow.cess)!=null?itemRow.cess.toString():0.0.toString()),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Text(formatter.format(itemRow.amount).toString()),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                FlatButton(
                                  padding:
                                  const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      removeListElement(itemRow.id,
                                          itemRow.slNo, itemRow.amount);
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
                    width: 10,
                  )
                ],
              ),
            ),


            Visibility(
                visible:grandTotal > 0,
                child: Divider(color: Colors.black,endIndent: 10,indent: 10,)),

            Visibility(
              visible: grandTotal > 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 90,
                  ),
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      controller: controller,
                      style: TextStyle(
                          color: Colors.lightBlue,
//                      fontFamily: Font.AvenirLTProMedium.value,
                          fontSize: 17),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Total Amt : ${grandTotal.toStringAsFixed(3)}',
                        hintStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          backgroundColor: Colors.white10,
//                          fontFamily: Font.AvenirLTProBook.value)
                        )
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

            //SizedBox(height: 500),


          ],

        ),
        bottomSheet: Visibility(
          visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
          child: Padding(
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
        ),
        floatingActionButton:Visibility(
          visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
          child: SpeedDial(
              animatedIcon:AnimatedIcons.menu_arrow,overlayColor: Colors.blue,
              children: [

                SpeedDialChild(
                    child: Icon(Icons.add_shopping_cart_sharp),
                    backgroundColor: Colors.blue,
                    label: "Sales",
                    onTap:(){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>Newsalespage(passvalue:salesLedgerId,passname:slsname.toString(),)));
                    } ),


                SpeedDialChild(
                    child: Icon(Icons.request_quote_outlined),
                    backgroundColor: Colors.blue,
                    label: "Ledger Balance",
                    onTap:(){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Newtestpage(passvalue:slsname.toString(),Shid:salesLedgerId)),  );
                    } ),
                SpeedDialChild(
                    child: Icon(Icons.remove_shopping_cart_rounded),
                    backgroundColor: Colors.blue,
                    label: "Sales Return",
                    onTap:(){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SalesReturn(passvalue:salesLedgerId,passname:slsname.toString(),)));
                    } ),
                SpeedDialChild(
                    child: Icon(Icons.description_outlined),
                    backgroundColor: Colors.blue,
                    label: "Receipt Collection",
                    onTap:(){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>ReceiptCollections(passvalue:salesLedgerId.hashCode,passname: slsname.toString(),)));
                    } ),

                SpeedDialChild(
                    child: Icon(Icons.remove_red_eye_outlined),
                    backgroundColor: Colors.blue,
                    label: "Shop Visited",
                    onTap:(){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => shopvisited(passvalue:salesLedgerId,passname:slsname.toString(),)));
                    } ),
              ]),
        ),
      ),
    );
  }

  Visibility AddItemWidgets(bool visibility) {
    return Visibility(visible: visibility,
child:   Column(children: [

  SizedBox(height:itemSelect==true?60: TextBoxHeight,
    child: Row(
      children: [
        SizedBox(width: 10),
        Expanded(
            child: TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                    style: TextStyle(),
                    controller: goodsController,
                    decoration: InputDecoration(
                      errorStyle: TextStyle(color: Colors.red),
                      errorText: itemSelect
                          ? "Please Select product Item ?"
                          : null,
//                            errorText: _validateName ? "please enter name" : null,
//                            errorBorder:InputBorder.none ,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.remove_circle),
                        color: Colors.blue,
                        onPressed: () {
                          setState(() {
                            print("cleared");
                            goodsController.text = "";
                            salesItemId = 0;
                            openingAmountBalance = 0;
                          });
                        },
                      ),

                      isDense: true,
                      contentPadding:
                      EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0)),
                      // i need very low size height
                      labelText:
                      'Item search', // i need to decrease height
                    )),
                suggestionsBoxDecoration:
                SuggestionsBoxDecoration(elevation: 90.0),
                suggestionsCallback: (pattern) {
                  return goods.where((user) =>
                      user.itmName.contains(pattern.toUpperCase()));
                },
                itemBuilder: (context, suggestion) {
                  return Card(
                    color:theam.DropDownClr,
                    // shadowColor: Colors.blue,
                    child: ListTile(
                      // focusColor: Colors.blue,
                      // hoverColor: Colors.red,
                      title: Text(
                        suggestion.itmName,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  print(suggestion.itmName);
                  print("selected");

                  goodsController.text = suggestion.itmName;
                  print("close.... $salesItemId");
                  salesItemId = 0;
                  // getbatch(suggestion.id);// for batch selection
                  ///----------------------------------for with out batch ------update on 20-10-21-------------------------------------
                  var j = {
                    "id":0,
                    "itemId": suggestion.id,
                    "expiryDate": null,
                    "srate": 0,
                    "batchNo":0,
                    "nos":0,
                    "barcode":0
                  };
                  multibatchitembinding(j);
                  ///-----------------------------------------------------------------------------
                  print(suggestion.id);
                  print(".......sales items");
                  print(json.encode(suggestion).toString());
                  // print(suggestion.description);
                  // print(suggestion.itmUnitId);

                  salesItemId = suggestion.id;

                  //  (suggestion.txPercentage == null ||suggestion.txPercentage == "null") ? itmtxper=0.0:itmtxper =suggestion.txPercentage;
                  //  (suggestion.atPercentage == null ||suggestion.atPercentage == "null") ? cessper=0.0:cessper =suggestion.atPercentage;
                  //
                  //  (suggestion.itmSalesRate == null ||suggestion.itmSalesRate == "null") ? rateController.text="":rateController.text =suggestion.itmSalesRate.toString();
                  //  (suggestion.description == null ||suggestion.description == "null") ? UnitController.text="":UnitController.text =suggestion.description;
                  //  (suggestion.itmUnitId == null ||suggestion.itmUnitId == "null") ? unitId=null:unitId =suggestion.itmUnitId;
                  // // (suggestion.atPercentage == null ||suggestion.atPercentage == "null") ? cessper=0.0:cessper =suggestion.atPercentage;


                  print(salesItemId);
                  print("...........");
                },
                errorBuilder: (BuildContext context, Object error) =>
                    Text('$error',
                        style: TextStyle(
                            color: Theme.of(context).errorColor)),
                transitionBuilder:
                    (context, suggestionsBox, animationController) =>
                    FadeTransition(
                      child: suggestionsBox,
                      opacity: CurvedAnimation(
                          parent: animationController,
                          curve: Curves.elasticIn),
                    ))),
        SizedBox(
          width: 10,
          height: 5,
        )
      ],
    ),
  ),
  SizedBox(
    height: 6,
  ),
  SizedBox(height:quantitySelect==true?60: TextBoxHeight,
    child: Row(
      children: [
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextFormField(
            controller: quantityController,

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
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter(RegExp(r"^\d+\.?\d{0,2}")),
            ],
            decoration: InputDecoration(
              errorStyle: TextStyle(color: Colors.red),
              errorText: quantitySelect ? "Invalid quantity" : null,
//                    suffixIcon: Icon(
//                      Icons.calendar_today,
//                      color: Colors.blue,
//                      size: 24,
//                    ),
              isDense: true,
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 16.0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.0)),

              // curve brackets object
//                    hintText: "Quantity",
              hintStyle: TextStyle(color: Colors.black, fontSize: 15),

              labelText: "Quantity",
            ),
          ),
        ),
        SizedBox(
          width: 4,
        ),

        //----------------unit-------------------
        Expanded(
            child: TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller:UnitController ,
                  style: TextStyle(),
                  decoration: InputDecoration(
                    errorStyle: TextStyle(color: Colors.red),
                    errorText: unitSelect
                        ? "Invalid Unit Selected"
                        : null,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.remove_circle),
                      color: Colors.blue,
                      onPressed: () {
                        setState(() {
                          print("cleared");
                          UnitController.text = "";
                          //  salesPaymentId = 0;
                        });
                      },
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 16.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0)),

                    hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                    labelText: "Unit",
                  ),
                ),

                suggestionsBoxDecoration:
                SuggestionsBoxDecoration(elevation: 90.0),
                suggestionsCallback: (pattern) {
//                        print(payment);
                  return unit.where((unt) => unt.description.contains(pattern));
                },
                itemBuilder: (context, suggestion) {
                  return Card(
                    color: Colors.white,
                    child: ListTile(
                      title: Text(
                        suggestion.description,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  print(suggestion.description);
                  print("Unit selected");

                  UnitController.text = suggestion.description;
                  print("close.... $unitId");
                  unitId = 0;

                  print(suggestion.id);
                  print(".......Unit id");
                  unitId = suggestion.id;
                  print(unitId);
                  print("...........");
                },
                errorBuilder: (BuildContext context, Object error) =>
                    Text('$error',
                        style: TextStyle(
                            color: Theme.of(context).errorColor)),
                transitionBuilder:
                    (context, suggestionsBox, animationController) =>
                    FadeTransition(
                      child: suggestionsBox,
                      opacity: CurvedAnimation(
                          parent: animationController,
                          curve: Curves.elasticIn),
                    ))),
        //----------------unit-------------------


        SizedBox(
          width: 4,
        ),

        Expanded(
          child: TextFormField(
            controller: rateController,
            enabled: true,
            validator: (v) {
              if (v.isEmpty) return "Required";
              return null;
            },
//
            cursorColor: Colors.black,
            scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter(RegExp(r"^\d+\.?\d{0,2}")),
            ],
            decoration: InputDecoration(
//                    suffixIcon: Icon(
//                      Icons.calendar_today,
//                      color: Colors.blue,
//                      size: 24,
//                    ),
              errorStyle: TextStyle(color: Colors.red),
              errorText: rateSelect ? "Invalid Rate" : null,
              isDense: true,
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 18.0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.0)),
              // curve brackets object
//                    hintText: "Quantity",
              hintStyle: TextStyle(color: Colors.black, fontSize: 15),

              labelText: "Rate",
            ),
          ),
        ),
        SizedBox(width: 4),
        SizedBox.fromSize(
          size: Size(45, 45), // button width and height
          child: ClipOval(
            child: Material(
              color: Colors.lightBlueAccent, // button color
              child: InkWell(
                splashColor: Colors.green, // splash color
                onTap: addCustomerItem,
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
  ),

  SizedBox(
    height: 6,
  ),

],),
);
  }

  //--------------------Print part-------------------------------------------

  GetdataPrint(id) async {
    print("sales for print : $id");
    double amount = 0.0;
    try {
      final tagsJson =
      await http.get("${Env.baseUrl}Soheader/$id", headers: {
        //Soheader //SalesHeaders
        "Authorization": user.user["token"],
      });
      dataForTicket = await jsonDecode(tagsJson.body);
      print("sales for print");
      print(dataForTicket.toString());

      Timer(Duration(milliseconds: 1,), () async{
        // await wifiprinting();
        await blutoothprinting();
        //   _ticket(PaperSize.mm58);
      });

    } catch (e) {
      print('error on GetdataPrint $e');
    }
  }



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
  //
  GetCompantPro(id)async{
    try {
      final tagsJson =
      await http.get("${Env.baseUrl}MCompanyProfiles/$id", headers: {
        //Soheader //SalesHeaders
        "Authorization": user.user["token"],
      });
      if(tagsJson.statusCode==200) {
        Companydata = jsonDecode(tagsJson.body);
      }
      print( "on GetCompantPro :" +Companydata.toString());
    }
    catch(e){
      print("error on GetCompantPro : $e");
    }
  }
//----------printing ticket generate--------------------------

  Future<Ticket> _ticket(PaperSize paper) async {
    // final ticket = Ticket(paper);
    print('in');
    // final profile = await CapabilityProfile.load();
    final ticket = Ticket(paper);
    List<dynamic> slsDet = await dataForTicket["data"]["sodetailed"] as List;
    dynamic VchNo = (dataForTicket["data"]["voucherNo"]) == null
        ? "00"
        : (dataForTicket["data"]["voucherNo"]).toString();
// dynamic date=(dataForTicket["data"]]["voucherDate"])==null?"-:-:-": DateFormat("yyyy-MM-dd hh:mm:ss").format((dataForTicket["data"][0]["voucherDate"]));
    dynamic date = (DateFormat("dd/MM/yyy hh:mm:ss a").format(DateTime.now()).toString());
    dynamic partyName=(dataForTicket["data"]["partyName"]) == null ||
        (dataForTicket["data"]["partyName"])== ""
        ? ""
        : (dataForTicket["data"]["partyName"]).toString();

    print(("dataForTicket amount"));
    print((dataForTicket["data"]["amount"]).toString());
    var netAmt=(dataForTicket["data"]["amount"]);


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





    ticket.text('GSTIN: ' +
        ( Companydata["companyProfileGstNo"]).toString()+' ',
        styles: PosStyles(bold: false,
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ));



    ticket.text('Order NO : ' + VchNo.toString(),
        styles: PosStyles(bold: true, width: PosTextSize.size1));
    //ticket.emptyLines(1);
    ticket.text('Date : $date');
    //---------------------------------------------------------
    if(partyName !="")
    {
      //ticket.emptyLines(1);
      ticket.text('Name : $partyName');
    }
    if((dataForTicket["data"]["gstNo"]) !=null)
    {
      // ticket.emptyLines(1);
      ticket.text('GST No :' +((dataForTicket["data"]["gstNo"])));
    }
    //---------------------------------------------------------

    ticket.hr(ch: '_');

    ticket.row([
      PosColumn(text:'No', width:1,styles:PosStyles(align: PosAlign.left)),
      PosColumn(
        text: 'Item',
        styles: PosStyles(bold: true),
        width: 2,
      ),
      PosColumn(text:'Qty', width: 2,styles: PosStyles(align: PosAlign.right ),),
      PosColumn(text:'Rate', width: 3,styles:PosStyles(align: PosAlign.center)),
      // PosColumn(text: 'Tax', width: 2,styles: PosStyles(align: PosAlign.center ),),
      PosColumn(text:'Amonunt', width: 4,styles: PosStyles(align: PosAlign.center ),),
    ]);
    ticket
        .hr(); // for dot line or set ticket.hr(ch: 'charecter', linesAfter: 1);

    dynamic NetTotal = 0.000;
    dynamic totalTax = 0.000;
    int snlnum=0;
    print(slsDet.toString());
    print(slsDet.length.toString());
    print(slsDet[0]["itemName"]);
    for (var i = 0; i < slsDet.length; i++) {
      //  double tax=((slsDet[i]["taxAmount"])==null?0.00:double.parse(slsDet[i]["taxAmount"]));
      // // total = tax + total;
      //  totalTax=tax+totalTax;
      var totalamt=((slsDet[i]["rate"])*(slsDet[i]["qty"]));
      NetTotal =totalamt + NetTotal;
      var qty=(slsDet[i]["qty"]);
      // ticket.emptyLines(1); // for space
      var oneitmtotal=qty*(slsDet[i]["rate"]);
      snlnum=snlnum+1;
      print("iii");
      print(i.toString());
      ticket.row([
        PosColumn(text: (snlnum.toString()),width: 1,styles: PosStyles(
        )),

        PosColumn(text: (slsDet[i]["itemName"]),
            width: 11,styles:
            PosStyles(align: PosAlign.left )),] );

      ticket.row([
        PosColumn(
            text: (""),
            width: 2,
            styles: PosStyles(

            )),
        PosColumn(
            text: (''+((slsDet[i]["qty"])).toStringAsFixed(0)).toString(),styles:PosStyles(align: PosAlign.center ),
            width: 2),
        PosColumn(
            text: (((slsDet[i]["rate"])).toStringAsFixed(2)).toString(),
            width: 4,
            styles: PosStyles(
                align: PosAlign.right
            )),

        // PosColumn(
        //     text: (' ' + tax.toStringAsFixed(2))
        //         ,styles:PosStyles(align: PosAlign.right ),
        //     width: 2),
        PosColumn(
            text:
            (oneitmtotal.toStringAsFixed(2)),
            styles:PosStyles(align: PosAlign.right ),
            width: 4),
      ]);
    }
    ticket.hr(
      ch: '=',
      // linesAfter: 1,
    );
    print("zzz");
    print(snlnum.toString());
    // print(totalTax.toStringAsFixed(2));
    // print((totalTax+NetTotal).toStringAsFixed(2));
    //ticket.hr();
    ticket.row([
      PosColumn(
          text: 'Total Tax',
          width: 5,
          styles: PosStyles(align: PosAlign.left,
            bold: true,
          )),
      PosColumn(
          text: 'Rs ' + ((netAmt-NetTotal).toStringAsFixed(2)).toString(),
          width: 7,
          styles: PosStyles(bold: true,align: PosAlign.right,)),
    ]);
    ticket.row([
      PosColumn(
          text: 'Total',
          width: 4,
          styles: PosStyles(align: PosAlign.left,
            bold: true,

          )),
      PosColumn(
          text: 'Rs ' + ((netAmt).toStringAsFixed(2)).toString(),
          width: 8,
          styles: PosStyles(bold: true,align: PosAlign.right,)),
    ]);
    ticket.hr(
      ch: '_',
      linesAfter: 1,
    );


    // print("Ttax= ${(netAmt-NetTotal).toString()}");
    // print("Tamt= ${(totalTax+NetTotal).toString()}");



    // ticket.row([
    //   PosColumn(text: ' ', width: 1),
    //   PosColumn(
    //       text: footerCaptions[0]['footerCaption'],
    //       width: 10,
    //       styles: PosStyles(align: PosAlign.center)),
    //   PosColumn(text: ' ', width: 1)
    // ]);

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
//..................................................

  // wifiprinting() async {
  //   try {
  //     print(" print in");
  //  // _printerManager.selectPrinter('192.168.0.100');
  //    // _printerManager.selectPrinter(null);
  //     final res =
  //    // await _printerManager.printTicket(await _ticket(PaperSize.mm58));
  //     print(" print in");
  //   } catch (e) {
  //     print("error on print $e");
  //   }
  // }



//----------------------------blutoothprinting---------------------------------

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


  //--------------------------print Part--------------------------

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


  /*Show dialog if blutooth not enabled and open settings blutooth*/
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
                      FlatButton(
                          child: Text('Cancel',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      Spacer(),
                      FlatButton(
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
// @override
// void dispose() {
//   _printerManager.stopScan();
//   super.dispose();
// }
//----------------------Print part End-----------------------------------------



//----------------------------Edit part---------------------------------------

  getDataEdit()async{
    print("print on edit part");
    print(widget.EditData.toString());
    try{

      var id =widget.EditData["id"].toInt();

      print("Soh edit id $id");

      var jsondata=await http.get("${Env.baseUrl}Soheader/$id/3",
          headers:{
            "Authorization": user.user["token"],
          });
      print("get DataEdit all data  "+jsondata.body);

      var DatasForEdit=jsonDecode(jsondata.body) ;
      print(DatasForEdit["data"]);
      generalRemarksController.text=DatasForEdit["data"]["narration"];

      List<dynamic> EditDetailPrt=DatasForEdit["data"]["sodetailed"];
      print(EditDetailPrt.length.toString());
      print("EditDetailPrt EditDetailPrt");

      for(int i=0;i<EditDetailPrt.length;i++){

        print(EditDetailPrt[i]["itemName"]);
        print(EditDetailPrt[i]["id"]);

        setState(() {
          double amount =0.0;
          var igst=0.00;
          var aftertax;
          /// tax calc...........
          var rate=(EditDetailPrt[i]["rate"]);
          amount=((EditDetailPrt[i]["rate"]))*((EditDetailPrt[i]["qty"]));
          dynamic Igst=double.parse(((rate/100)*(EditDetailPrt[i]["txIgstpercentage"])).toStringAsFixed(2));

          var taxOneItm =((rate/100)*(itmtxper));
          var taxAmtOfCgst;
          var taxAmtOfSgst;
          var  ToatalTax;
          dynamic  befortax=0;

          if(EditDetailPrt[i]["itmTaxInclusive"]==true){

            var WithOutTaxamt=(((EditDetailPrt[i]["txPercentage"])+100)/100);
            print("WithOutTaxamt in inclusive of edit bind");
            print(WithOutTaxamt.toString());
            taxOneItm=rate/WithOutTaxamt;
            taxAmtOfCgst=(WithOutTaxamt/2);
            taxAmtOfSgst=(WithOutTaxamt/2);
            // ToatalTax =taxOneItm*double.parse(quantityController.text);
            grandTotal = grandTotal + amount;
            aftertax= amount;
            befortax=taxOneItm*(EditDetailPrt[i]["qty"]);
          }
          else {

            taxOneItm =((rate/100)*(EditDetailPrt[i]["txPercentage"]));
            taxAmtOfCgst=(taxOneItm/2);
            taxAmtOfSgst=(taxOneItm/2);
            ToatalTax =taxOneItm*(EditDetailPrt[i]["qty"]);
            grandTotal = grandTotal + ToatalTax + amount;
            aftertax=ToatalTax + amount;
            befortax=amount;

          }







          sale = Salesorder(
              id: id,
              itemId: EditDetailPrt[i]["itemId"],
              qty: EditDetailPrt[i]["qty"],
              rate:aftertax,//EditDetailPrt[i]["rate"],
              note:EditDetailPrt[i]["note"],
              unitId: EditDetailPrt[i]["unitId"],
              StockId: EditDetailPrt[i]["stockId"]);

          sales.add(sale);


          print(".....addto so table........");

          // var amount=EditDetailPrt[i]["rate"]* EditDetailPrt[i]["qty"];
          // var taxper=EditDetailPrt[i]["txCgstPercentage"]+EditDetailPrt[i]["txCgstPercentage"];
          // var OneItmTax=(EditDetailPrt[i]["rate"]/100)*taxper;
          // var TotlTax=OneItmTax* EditDetailPrt[i]["qty"];
          // var netAmt=(EditDetailPrt[i]["rate"]* EditDetailPrt[i]["qty"])+TotlTax;
          // grandTotal=netAmt+grandTotal;

          customer = CustomerAdd(
              //id: EditDetailPrt[i]["id"],
            id: int.parse(EditDetailPrt[i]["id"]),
              slNo: EditDetailPrt.length + 1,
              item: EditDetailPrt[i]["itemName"],
              quantity: EditDetailPrt[i]["qty"],
              rate: EditDetailPrt[i]["rate"],
              txper:EditDetailPrt[i]["txPercentage"],
              cess:0,
              amount:amount,
              NetAmt:aftertax);
          print(customer.item);
        });
        setState(() {
          customerItemAdd.add(customer);
        });
        print("---------so edit add to table--------");
        print(customerItemAdd);
        print("-----------------");
      }


    }catch(e){print("error on getDataEdit $e");}

  }



  //-------------update data-----------------
  UpdateEdit()async{

      final url = "";
      print("Update sales length");
      print(sales.length);
      print(jsonEncode(sales));
      delivery = "";
      delivery = salesdeliveryController.text.toString();
      var remarks = generalRemarksController.text.toString();
      ;
      var req = {
        "voucherDate": serverDate.toString(),
        "expDate": serverDate.toString(),
        "ledgerId": salesLedgerId,
        "partyName": userName,
        "address1": null,
        "address2": null,
        "gstNo": null,
        "phone": null,
        "shipToName": null,
        "shipToAddress1": null,
        "shipToAddress2": null,
        "shipToPhone": null,
        "narration": remarks,
        "amount": grandTotal,
        "userId": userId,
        "branchId": branchId,
        // "sohAppMode":"Mobile",
        "ledgerName": branchName,
        "sodetailed": sales
      };
      print(req);
      // return;
      setState(() {
        if (salesLedgerId == 0 || customerController.text == "") {
          customerSelect = true;
        } else {
          customerSelect = false;
        }

        // if (salesPaymentId == 0 || paymentController.text == "") {
        //   paymentSelect = true;
        // } else {
        //   paymentSelect = false;
        // }
        if (delivery != "") {
          deliveryDateSelect = false;

          return;
        } else {
          deliveryDateSelect = true;
        }
      });
      // print(req);
      // return;
      setState(() {

      });
      if (customerSelect || deliveryDateSelect
          || customerItemAdd.length <= 0 ||sales.length <=0) {


        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                "Please Check the fields",
                style: TextStyle(color: Colors.red),
              ),
//              content: Text("user data:   " + user.user["token"]),
            ));
      } else {
        var params = json.encode(req);
        print("after print");
        print(params);



        //---------------olny for tst update api not available---------------------
        showDialog(
          barrierDismissible: false,
            context: context,
            builder: (context) => AlertDialog(
              title: Container(child: Text("    Update Faild.....")),
            ));
        rateSelect = false;
        quantitySelect = false;
        Timer(Duration(seconds: 2), () {
          print("Yeah, this line is printed after 2 seconds");
          Navigator.pop(context);
        });
        //---------------olny for tst update api not available---------------------
return;
        var res = await http.post(url,
            headers: {
              'accept': 'application/json',
              'content-type': 'application/json',
              'Authorization': user.user["token"],
              'deviceId': user.deviceId
            },
            body: params);

        print("save rsponse statusCode: "+res.statusCode.toString());
        if (res.statusCode == 200 ||
            res.statusCode == 201 &&
                customerItemAdd.length > 0 &&
                sales.length > 0 &&
                salesLedgerId > 0
        ) {
          print("save rsponse body : "+res.body.toString());
          var retunid = await jsonDecode(res.body);
          GetdataPrint(retunid['id']);
          setState(() {

            customerItemAdd.clear();
            sales.clear();
            customerController.text = "";
            salesdeliveryController.text = "";
            generalRemarksController.text = "";
            paymentController.text = "";

            salesLedgerId = 0;
            salesItemId = 0;
            salesPaymentId = 0;
            grandTotal = 0;
          });

          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Sales Order Updated"),
              ));
          rateSelect = false;
          quantitySelect = false;
          Timer(Duration(seconds: 2), () {
            print("Yeah, this line is printed after 2 seconds");
            Navigator.pop(context);
          });
        }
      }
//    customerItemAdd = [];
//    sales
    }



//---------------------------Edit part---END------------------------------------
}




class Salesorder {
  int id;
  int itemId;
  dynamic note;
  double qty;
  double rate;
  int  unitId;
  int StockId;


  Salesorder({this.itemId, this.qty, this.rate,this.note,this.unitId,this.StockId,this.id});



  Salesorder.fromJson(Map<String, dynamic> json) {
    itemId = json['itemId'];
    qty = json['qty'];
    rate = json['rate'];
    note =json['note'];
    unitId =json['unitId'];
    StockId = json['StockId'];
    id = json['id'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemId'] = this.itemId;
    data['qty'] = this.qty;
    data['rate'] = this.rate;
    data['note'] = this.note;
    data['unitId'] = this.unitId;
    data['StockId'] = this.StockId;
    data['id'] = this.id;

    return data;
  }
}


//
// class  UnitType {
//   // "id": 2,
//   // "description": "Box 10s",
//   // "nos": 10.0,
//   // "formalName": "Box 10",
//   // "unitUnder": 1,
//   // "isSimple": true,
//   // "groupUnder": "Number"
//
//   int id;
//   dynamic description;
//   double nos;
//   dynamic formalName;
//   int unitUnder;
//   bool isSimple;
//   dynamic groupUnder;
//
//
//
//   UnitType(
//       {
//         this.id,
//         this.description,
//         this.nos,
//         this.formalName,
//         this.unitUnder,
//         this.isSimple,
//         this.groupUnder,
//       });
//
//   UnitType.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     description = json['description'];
//     nos = json['nos'];
//     formalName = json['formalName'];
//     unitUnder = json['unitUnder'];
//     isSimple = json['isSimple'];
//     groupUnder = json['groupUnder'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['description'] = this.description;
//     data['nos'] = this.nos;
//     data['formalName'] = this.formalName;
//     data['unitUnder'] = this.unitUnder;
//     data['isSimple'] = this.isSimple;
//     data['groupUnder'] = this.groupUnder;
//
//     return data;
//   }
// }








