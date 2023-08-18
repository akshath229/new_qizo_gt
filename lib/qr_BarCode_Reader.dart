import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http ;
import 'package:intl/intl.dart';
import 'package:new_qizo_gt/urlEnvironment/urlEnvironment.dart';
import 'package:shared_preferences/shared_preferences.dart';
 import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'appbarWidget.dart';
import 'models/userdata.dart';
class Qr_BarCode_Reader extends StatefulWidget {
  @override
  _Qr_BarCode_ReaderState createState() => _Qr_BarCode_ReaderState();
}
class _Qr_BarCode_ReaderState extends State<Qr_BarCode_Reader> {
  static List<Tabledata> TblDt = [];
 var goods;
  TextEditingController ItemNameController= TextEditingController();
  TextEditingController QTYController= TextEditingController();
  TextEditingController RateController= TextEditingController();
  TextEditingController NetAmtController= TextEditingController();
  TextEditingController SalesManController= TextEditingController();
  TextEditingController CustomerNameController= TextEditingController();
  TextEditingController PhoneNumController= TextEditingController();
// //-----------------------------------------
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
  var DeviceId;
var net_Amt=0.0;
  dynamic serverDate;
var dataForTicket;
  void initState() {
    setState(() {
      SharedPreferences.getInstance().then((value) {
        pref = value;
        read();
        TblDt.clear();
        print(TblDt.length.toString());
        qr_Barcode_Readfunction();
        GetEmployees();
        getCustomerLedgerBalance();
      });
    });
  }
var slnum=0;
  bool salesManSelect=false;
  dynamic salesManId=null;
  var SalesManList=[];
  getCustomerLedgerBalance() async {
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
          var formatter =
          new DateFormat('MM-dd-yyyy'); // this dd-MM-yyyy format i want

          String formattedDate = formatter
              .format(DateTime.parse(list[0]["workingDate"].substring(0, 10)));
          print(formattedDate);
          serverDate=formattedDate;
        });
      } else {
        print("Error getting users");
      }
    } catch (e) {
      print("Error getting users" + e);
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
  qr_Barcode_Readfunction() async {
    try {
      print("in qr_Barcode_Readfunction ");
      var result = await BarcodeScanner.scan();
      print("type");
      print(result.type);
      print("rawContent");
      print(result.rawContent);
      print("format");
      print(result.format);
      print("formatNote");
      print(result.formatNote);
      print(result.formatNote);
setState(() {
 var  barcodeReslt=result.rawContent.toString();
  getFinishedGoods(barcodeReslt);
});
    }
     catch(e) {  print("Error on qr_Barcode_Readfunction $e");}

  }
  //------------------------
  Validation(){
if(TblDt.isEmpty){

  showDialog(context: context, builder: (c){

    return AlertDialog(
      title: Center(child: Text("ADD ITEMS...",style: TextStyle(color: Colors.red),)),
    );

  });

}
else if(SalesManController.text==""||salesManId==null){

  setState(() {
    salesManSelect=true;
    return;
  });
}else{
  salesManSelect=false;
  Save();
}


  }
//----------------------------------------------
  GetEmployees()async {
// print("${Env.baseUrl}MemployeeMasters/1/10");
    String url = "${Env.baseUrl}MemployeeMasters/1/10";
 var res  = await http.get(url as Uri,
        headers: {"Authorization": user.user["token"]});

   // print(res.body);
    print("Employees");
    if (res.statusCode == 200) {
      //print(res.body);
      print("json decoded");
      var tagsJson = json.decode(res.body)['employeeMaster'];
      setState(() {
        SalesManList = tagsJson ;
        // print(SalesManList.toString());
        // print(SalesManList[0]['emEmployeeName'].toString());
      });
    }
  }
//------------------------------------------------------
  Save()async {
    final url = "${Env.baseUrl}Soheader";

    // var DtlsPart;
    // DtlsPart = json.encode(TblDt);
    // var Dtls = json.decode(DtlsPart);
   // print(DtlsPart);


    var req = {
      "voucherNo": 1,
      "voucherDate": serverDate,
      "expDate": serverDate,
      "partyName":CustomerNameController.text,
      "phone": PhoneNumController.text,
      "amount": net_Amt,
      "userId": userId,
      "branchId": branchId,
      "entryDate": serverDate,
      "slesManId": salesManId,
      "sodetailed":TblDt
    };
   // print(req.toString());

    var params = json.encode(req);
    print(params.toString());

return;
    var res = await http.post(url as Uri,
        headers: {
          'accept': 'application/json',
          'content-type': 'application/json',
          'Authorization': user.user["token"],
          'deviceId': user.deviceId
        },
        body: params);

    print("save rsponse statusCode: " + res.statusCode.toString());
    if (res.statusCode == 200 || res.statusCode == 201) {
      print("save rsponse body : " + res.body.toString());
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Center(child: Text("Order Saved")),
              ));
    }
  }
//--------------------------------------------------------
  getFinishedGoods(brcode) async {
    String url = "${Env.baseUrl}GtItemMasters/1/$brcode/barcode";
    try {
      final res =
      await http.get(url as Uri, headers: {"Authorization": user.user["token"]});

      print(res.body);
      print("goods Condition");
      if(res.statusCode==200) {
        //print(res.body);
        print("json decoded");

        var tagsJson = json.decode(res.body);
        //  print(tagsJson);
         goods = tagsJson;
        setState(() {
        ItemNameController.text = (goods["result"][0]["itmName"]);
        RateController.text = (goods["result"][0]["itmMrp"]).toString();
      });

      }
      else{
        showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(builder: (context, setState) {
                return AlertDialog(actions: [
                  Container(
                    height: 50,
                    width: 300,
                    child: Center(
                        child: Text("Stock Not Found",
                            style: TextStyle(color: Colors.brown, fontSize: 20,))),
                  )
                ]);
              });
            });

      }
    } catch (e) {
      print("error on getFinishedGoods : $e");
      showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(actions: [
                Container(
                  height: 50,
                  width: 300,
                  child: Center(
                      child: Text("Stock Not Found..!",
                          style: TextStyle(color: Colors.brown, fontSize: 20,))),
                )
              ]);
            });
          });



    }
  }
  //-----Table no-----------------
  getItemIndex(dynamic item) {
    var index = TblDt.indexOf(item);
    return index + 1;
  }
  bindToTable(bindData){
    print("in bindToTable");
    print(bindData);
    print(bindData["result"][0]["itmName"]);
   slnum=slnum+1;
   var QTY=double.parse(QTYController.text);
    print(QTY.runtimeType);
var data= Tabledata(
   itmName: bindData["result"][0]["itmName"],
  itemId:bindData["result"][0]["id"],
  qty:double.parse(QTYController.text),
  rate:bindData["result"][0]["itmMrp"],
  unitId:bindData["result"][0]["itmUnitId"],
  netTotal:(bindData["result"][0]["itmMrp"]*QTY),
  barcode:bindData["result"][0]["itmBarCode"],
  ItemSlNo:slnum,
  hsncode:bindData["result"][0]["itmHsn"],
  taxId:bindData["result"][0]["itmTaxId"],

  // cgstPercentage:bindData["result"][0]["txCgstPercentage"],
  // sgstPercentage:bindData["result"][0]["txSgstPercentage"],
  // //cessPercentage:bindData["result"][0]["itmName"],
  // cgstAmount:bindData["result"][0]["itmName"],
  // sgstAmount:bindData["result"][0]["itmName"],
  // cessAmount:bindData["result"][0]["itmName"],
  // taxPercentage:bindData["result"][0]["itmName"],
  // taxAmount:bindData["result"][0]["itmName"],
  // taxInclusive:bindData["result"][0]["itmName"],
  // amountBeforeTax:bindData["result"][0]["itmName"],
  // amountIncludingTax:bindData["result"][0]["itmName"],



 );
setState(() {
  TblDt.add(data);
  ItemNameController.text = "";
  RateController.text ="";
  QTYController.text="";
  net_Amt=((bindData["result"][0]["itmMrp"])*QTY)+net_Amt;
  print("-------");
  print(net_Amt.toString());
  NetAmtController.text=net_Amt.toString();
  // SalesManController.text="";
  // salesManId=null;
});

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
    child: Scaffold(
         appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Appbarcustomwidget(
            uname: branchName , branch: userName, pref: pref, title: "Sanner"),
          ),


       body: ListView(children: [

             SizedBox(height: 5,),


         Row(
             children: [
               SizedBox(width: 9),
               Expanded(
                   child: TypeAheadField(
                       textFieldConfiguration: TextFieldConfiguration(
                           style: TextStyle(),
                           controller: SalesManController,
                           decoration: InputDecoration(
                             errorStyle: TextStyle(color: Colors.red),
                             errorText: salesManSelect
                                 ? "Please Select Sales Man !"
                                 : null,
//                            errorText: _validateName ? "please enter name" : null,
//                            errorBorder:InputBorder.none ,
                             suffixIcon: IconButton(
                               icon: Icon(Icons.remove_circle),
                               color: Colors.blue,
                               onPressed: () {
                                 setState(() {
                                   print("cleared");
                                   SalesManController.text = "";
                                   salesManId = 0;
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
                             'Search Sales Man', // i need to decrease height
                           )),
                       suggestionsBoxDecoration:
                       SuggestionsBoxDecoration(elevation: 90.0),
                       suggestionsCallback: (pattern) {
                         return SalesManList.where((user) =>
                             user['emEmployeeName'].toUpperCase().contains(pattern.toUpperCase()));
                       },
                       itemBuilder: (context, suggestion) {
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
                               suggestion['emEmployeeName'],
                               style: TextStyle(color: Colors.black),
                             ),
                           ),
                         );
                       },
                       onSuggestionSelected: (suggestion) {
                         print(suggestion['emEmployeeName']);
                         print("selected");
                         setState(() {
                           SalesManController.text = suggestion['emEmployeeName'];
                           print(suggestion['id']);
                           print(".......sales Ledger id");
                           salesManId = suggestion['id'];
                           print("...........");
                         });
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
                           ))),
               SizedBox(width: 10),
             ]),


         Padding(
           padding: const EdgeInsets.all(8.0),
           child: Container(height: 50,
             child: TextFormField(
               controller:CustomerNameController,
               decoration: InputDecoration(
                   contentPadding:EdgeInsets.fromLTRB(20,10,10,10),
                   labelText: "Customer Name",
                   border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10))),
             ),
           ),
         ),



         Padding(
           padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
           child: Container(height: 50,
             child: TextFormField(maxLength: 12,
               controller:PhoneNumController,
               keyboardType: TextInputType.number,
               inputFormatters: <TextInputFormatter>[
                 FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}")),
               ],
               decoration: InputDecoration(
                   counterText: "",
                   contentPadding:EdgeInsets.fromLTRB(20,10,10,10),
                   labelText: "Phone Num",
                   border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10))),
             ),
           ),
         ),





         Container(
           width: MediaQuery.of(context).size.width,
           height: 60,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 2, 8),
                        child: TextFormField(
                  controller: ItemNameController,
                  enabled: false,

                  decoration: InputDecoration(
                         contentPadding:EdgeInsets.fromLTRB(20,10,10,10),
                         labelText: "Item Name",
                         border: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(10))),
          ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                      child: IconButton(icon: Icon(Icons.qr_code_sharp,color: Colors.deepPurple,size: 35,), onPressed: (){
                        print("Scann");
                      qr_Barcode_Readfunction();
                      }),
                    ),


                  ],
                ),
              ),

            Container(
          child: Row(children: [

             Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(height: 50,
                  child: TextFormField(
                    controller:RateController,
                    enabled: false,
                    decoration: InputDecoration(
                      contentPadding:EdgeInsets.fromLTRB(20,10,10,10),
                        labelText: "Rate",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(height: 50,
                  child: TextFormField(
                    controller: QTYController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r"^\d+\.?\d{0,2}")),
                    ],
                    decoration: InputDecoration(
                        contentPadding:EdgeInsets.fromLTRB(20,10,10,10) ,
                        labelText: "QTY",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
              ),
            ),

            IconButton(icon:
            Icon(Icons.add_shopping_cart,color: Colors.indigo,size: 35,), onPressed: (){

              if(QTYController.text=="")
                {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return AlertDialog(actions: [
                            Container(
                              height: 50,
                              width: 300,
                              child: Center(
                                  child: Text("Add QTY",
                                      style: TextStyle(color: Colors.red, fontSize: 20,))),
                            )
                          ]);
                        });
                      });
                }else if(goods==null||goods=="null"||ItemNameController.text==""){

                showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder: (context, setState) {
                        return AlertDialog(actions: [
                          Container(
                            height: 50,
                            width: 300,
                            child: Center(
                                child: Text("Add Item",
                                    style: TextStyle(color: Colors.red, fontSize: 20))),
                          )
                        ]);
                      });
                    });

              }else
                {
                bindToTable(goods);
              }


            }),
          ])),
             SizedBox(height: 5,),




         Column(children: [
           Visibility(
             visible: TblDt.length>0,
             child: Row(
               children: [
                 // SizedBox(
                 //   width: 10,
                 // ),
                 Container(
                   height: 440,
                   width:MediaQuery.of(context).size.width,
                   child: SingleChildScrollView(
                     scrollDirection: Axis.horizontal,
                     child: SingleChildScrollView(
                       scrollDirection: Axis.vertical,
                       physics: ScrollPhysics(),
                       child: DataTable(
                         columnSpacing: 17,
                         onSelectAll: (b) {},
                         sortAscending: true,
                         columns: <DataColumn>[
                           DataColumn(
                             label: Text('NO'),
                           ),

                           DataColumn(
                             label: Text('Bar Code'),
                           ),

                           DataColumn(
                             label: Text('Name'),
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
                         rows: TblDt
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
                                 Text(itemRow.barcode
                                     .toString()),
                                 showEditIcon: false,
                                 placeholder: false,
                               ),

                               DataCell(
                                 Text(itemRow.itmName
                                     .toString()),
                                 showEditIcon: false,
                                 placeholder: false,
                               ),

                               DataCell(
                                 Text(itemRow.qty
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
                                     .netTotal) !=
                                     null
                                     ? itemRow.netTotal
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
                                           itemRow.ItemSlNo,itemRow.itemId,itemRow.netTotal
                                       );
                                     });
                                   },
                                   // button pressed
                                   child: Icon(
                                       Icons.delete),
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

         ]),


    ]),



       bottomNavigationBar:
       Padding(
         padding: const EdgeInsets.all(5.0),
         child: Container(height: 60,width: MediaQuery.of(context).size.width,
           child: Row(crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisAlignment:MainAxisAlignment.start,
             children: [
               Padding(
                 padding: const EdgeInsets.fromLTRB(1,8,8,5),
                 child: GestureDetector(
                   onTap: (){
                     print(" savee");
                    Validation();
                   },
                   child: Container(height: 60,color: Colors.deepPurple,width: MediaQuery.of(context).size.width/2.5,
                     child: Row(mainAxisAlignment:MainAxisAlignment.center,
                       children: [
                       Text(" Save",style: TextStyle(fontSize: 28),),
                      Icon(Icons.save_alt,size: 40)
                     ],),
                   ),
                 ),
               ),


               Expanded(
                 child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Container(height: 50,
                     child: TextFormField(
                       controller:NetAmtController,
                       enabled: false,
                       decoration: InputDecoration(
                           contentPadding:EdgeInsets.fromLTRB(20,10,10,10),
                           labelText: "NET AMT",
                           border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10))),
                     ),
                   ),
                 ),
               ),


             ],
           ),
         ),
       ) ,
       )
    );
  }
  removeListElement(sl, totl,Netamt) {
    print(totl);
    print("Netamt");
    print(Netamt);
    TblDt .removeWhere((element) => element.ItemSlNo == sl);
    TblDt.removeWhere((element) => element.ItemSlNo == sl);
    setState(() {
      net_Amt=net_Amt-Netamt;
      NetAmtController.text=net_Amt.toString();
    });


    // if (TblDt.isEmpty) {
    //
    // }
  }
  ///----------------------print part-----------------------
  //   wifiprinting() async {
  //   try {
  //     print(" print in");
  //    _printerManager.selectPrinter('192.168.0.100');
  //    //_printerManager.selectPrinter(null);
  //     final res =
  //     await _printerManager.printTicket(await _ticket(PaperSize.mm80));
  //     print(" print in");
  //   } catch (e) {
  //     print("error on print $e");
  //   }
  // }





  //----------printing ticket generate--------------------------
  Future<Ticket> _ticket(PaperSize paper) async {
    print('in print Ticket');
    final ticket = Ticket(paper);
    List<dynamic> DetailPart = dataForTicket["sodetailed"] as List;

    print("dataForTicket");
    print(dataForTicket.toString());
    print("DetailPart");
    print(DetailPart.toString());

    dynamic VchNo = (dataForTicket["voucherNo"]) == null
        ? "00": (dataForTicket["voucherNo"]).toString();

    // dynamic date = (DateFormat("dd/MM/yyy hh:mm:ss a").format(DateTime.now()).toString());


    dynamic partyName=(dataForTicket["partyName"]) == null ||
        (dataForTicket["partyName"])== ""
        ? ""
        : (dataForTicket["partyName"]).toString();



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
        // text:(Companydata["companyProfileAddress1"]).toString(),
          text:("Order Slip"),
          width: 10,
          styles:PosStyles(bold: false,
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,)),
      PosColumn(text: ' ', width: 1)
    ]);


    //
    // ticket.row([
    //   PosColumn(text: ' ', width: 1),
    //   PosColumn(
    //       text: (Companydata["companyProfileAddress2"]).toString(),
    //       width: 10,
    //       styles:PosStyles(bold: false,
    //         align: PosAlign.center,
    //         height: PosTextSize.size1,
    //         width: PosTextSize.size1,
    //       )),
    //   PosColumn(text: ' ', width: 1)
    // ]);
    //
    // ticket.row([
    //   PosColumn(text: ' ', width: 1),
    //   PosColumn(
    //       text:  (Companydata["companyProfileAddress3"]).toString(),
    //       width: 10,
    //       styles:PosStyles(bold: false,
    //         align: PosAlign.center,
    //         height: PosTextSize.size1,
    //         width: PosTextSize.size1,
    //       )),
    //   PosColumn(text: ' ', width: 1)
    // ]);
    //
    //
    //
    // ticket.row([
    //   PosColumn(text: ' ', width: 1),
    //   PosColumn(
    //       text:(Companydata["companyProfileMobile"]).toString(),
    //       width: 10,
    //       styles:PosStyles(bold: false,
    //         align: PosAlign.center,
    //         height: PosTextSize.size1,
    //         width: PosTextSize.size1,
    //       )),
    //   PosColumn(text: ' ', width: 1)
    // ]);
    //
    //
    //
    //
    // ticket.row([
    //   PosColumn(text: ' ', width: 1),
    //   PosColumn(
    //       text:  (Companydata["companyProfileEmail"]).toString(),
    //       width: 10,
    //       styles:PosStyles(bold: false,underline: true,
    //         align: PosAlign.center,
    //         height: PosTextSize.size1,
    //         width: PosTextSize.size1,
    //       )),
    //   PosColumn(text: ' ', width: 1)
    // ]);
    //
    //
    //
    //
    //
    // ticket.text('GSTIN: ' +
    //     ( Companydata["companyProfileGstNo"]).toString()+' ',
    //     styles: PosStyles(bold: false,
    //       align: PosAlign.center,
    //       height: PosTextSize.size1,
    //       width: PosTextSize.size1,
    //     ));
    //
    //
    // ticket.text('Token NO : ' + VchNo.toString(),
    //     styles: PosStyles(bold: true, width: PosTextSize.size1));
    // //ticket.emptyLines(1);
    // ticket.text('Date : $date');

    //---------------------------------------------------------
    if(partyName !="")
    {
      //ticket.emptyLines(1);
      ticket.text('Name : $partyName');
    }
    if((dataForTicket["gstNo"]) !=null)
    {
      // ticket.emptyLines(1);
      ticket.text('GST No :' +((dataForTicket["gstNo"])));
    }
    //---------------------------------------------------------

    ticket.hr(ch: '_');
    ticket.row([
      PosColumn(
        text:'No',
        styles: PosStyles(align: PosAlign.left ),
        width:1,
      ),
      PosColumn(
        text:'Item',
        styles: PosStyles(bold: true,align: PosAlign.center),
        width: 2,
      ),
      PosColumn(text: 'Rate', width: 3,styles:PosStyles(align: PosAlign.right)),
      PosColumn(text: 'Qty', width: 2,styles: PosStyles(align: PosAlign.right ),),
      // PosColumn(text: 'Tax', width: 2,styles: PosStyles(align: PosAlign.center ),),
      PosColumn(text: ' Amonunt', width: 4,styles: PosStyles(align: PosAlign.center ),),
    ]);
    ticket
        .hr(); // for dot line or set ticket.hr(ch: 'charecter', linesAfter: 1);
    var snlnum=0;
    dynamic total = 0.000;
    for (var i = 0; i < DetailPart.length; i++) {
      total = DetailPart[i]["amountIncludingTax"] + total;
      ticket.emptyLines(1);
      snlnum=snlnum+1;
      ticket.row([
        PosColumn(text: (snlnum.toString()),width: 1,styles: PosStyles(
            fontType: PosFontType.fontB,align: PosAlign.left
        )),

        PosColumn(text: (DetailPart[i]["itemName"]),
            width: 11,styles:
            PosStyles( fontType: PosFontType.fontB,align: PosAlign.left )),] );

      // for space
      ticket.row([
        PosColumn(
            text: (''),
            width: 2,
            styles: PosStyles(
                fontType: PosFontType.fontB,align: PosAlign.right
            )),
        PosColumn(
            text: (((DetailPart[i]["rate"])).toStringAsFixed(2)).toString(),
            width: 4,
            styles: PosStyles(
                fontType: PosFontType.fontB,align: PosAlign.right
            )),
        PosColumn(
            text: (' '+((DetailPart[i]["qty"])).toStringAsFixed(0)).toString(),styles:PosStyles(align: PosAlign.right ),
            width: 2),
        // PosColumn(
        //     text: (' ' + ((DetailPart[i]["taxAmount"])).toStringAsFixed(2))
        //         .toString(),styles:PosStyles(align: PosAlign.right ),
        //     width: 2),
        PosColumn(
            text: ((DetailPart[i] ["amountIncludingTax"])).toStringAsFixed(2)
            ,styles:PosStyles(align:PosAlign.center ),
            width:4),
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
          width: 7,
          styles: PosStyles(bold: true,align: PosAlign.center,)),
      PosColumn(
        text:' ',
        width: 1,),
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
    print("Finish");
    ticket.cut();
    return ticket;
  }
}
// class Tabledata {
//   int id;
//   dynamic ItemSlNo;
//   dynamic Name;
//   dynamic rate;
//   dynamic Total;
//   dynamic Qty;
//   dynamic unitId;
//   dynamic StkId;
//
//
//   Tabledata(
//       {this.id,
//         this.Name,
//         this.rate,
//         this.Total,
//         this.Qty,
//         this.ItemSlNo,
//         this.StkId,
//         this.unitId,
//
//      });
//
//   Tabledata.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     Name = json['Name'];
//     rate = json['rate'];
//     Total = json['Total'];
//     Qty = json['Qty'];
//     ItemSlNo = json['ItemSlNo'];
//     StkId = json['StkId'];
//     unitId = json['unitId'];
//
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['Name'] = this.Name;
//     data['rate'] = this.rate;
//     data['Total'] = this.Total;
//     data['Qty'] = this.Qty;
//     data['ItemSlNo'] = this.ItemSlNo;
//     data['StkId'] = this.StkId;
//     data['unitId'] = this.unitId;
//     return data;
//   }
// }
class Tabledata {
  String itmName;
  int ItemSlNo;
  int shid;
  int itemId;
  double qty;
  double rate;
  double disPercentage;
  double cgstPercentage;
  double sgstPercentage;
  double cessPercentage;
  double discountAmount;
  double cgstAmount;
  double sgstAmount;
  double cessAmount;
  double igstPercentage;
  double igstAmount;
  double taxPercentage;
  double taxAmount;
  bool taxInclusive;
  double amountBeforeTax;
  double amountIncludingTax;
  double netTotal;
  // dynamic hsncode;
  int gdnId;
  int taxId;
  int rackId;
  int addTaxId;
  int unitId;
  dynamic nosInUnit;
  dynamic barcode;
  dynamic StockId;
  dynamic BatchNo;
  dynamic ExpiryDate;
  dynamic Notes;
  dynamic hsncode;
  dynamic itmBarCode;
  dynamic itemSlNo;
  Tabledata({
    required this.itmName,
    required this.ItemSlNo,
    required this.shid,
    required this.itemId,
    required this.qty,
    required this.rate,
    required this.disPercentage,
    required this.cgstPercentage,
    required this.sgstPercentage,
    required this.cessPercentage,
    required this.discountAmount,
    required this.cgstAmount,
    required this.sgstAmount,
    required this.cessAmount,
    required  this.igstPercentage,
    required this.igstAmount,
    required this.taxPercentage,
    required this.taxAmount,
    required this.taxInclusive,
    required this.amountBeforeTax,
    required this.amountIncludingTax,
    required this.netTotal,
    this.hsncode,
    required this.gdnId,
    required this.taxId,
    required this.rackId,
    required this.addTaxId,
    required this.unitId,
    this.nosInUnit,
    this.barcode,
    this.StockId,
    this.BatchNo,
    this.ExpiryDate,
    this.Notes,
    this.itmBarCode,
    this.itemSlNo
  });



  Tabledata.fromJson(Map<String, dynamic> json) {
    itmName = json['itmName'];
    ItemSlNo = json['ItemSlNo'];
    //  shid = json['shid'];
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
    itmBarCode = json['itmBarCode'];
    itemSlNo = json['itemSlNo'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itmName'] = this.itmName;
    data['ItemSlNo'] = this.ItemSlNo;
    // data['shid'] = this.shid;
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
    data['itmBarCode'] = this.itmBarCode;
    data['itemSlNo'] = this.itemSlNo;
    return data;
  }
}
