
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:convert' show utf8;
import 'dart:typed_data';
import 'package:charset_converter/charset_converter.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../appbarWidget.dart';
import '../models/userdata.dart';
class TestArabicTermalPrint extends StatefulWidget {
  @override
  _TestArabicTermalPrintState createState() => _TestArabicTermalPrintState();
}
// List<PrinterBluetooth> _devices = [];
class _TestArabicTermalPrintState extends State<TestArabicTermalPrint> {
//-----------------------------------------
  late SharedPreferences pref;
  dynamic branch;
  var res;
  dynamic user;
  late int branchId;
  late int userId;
  late UserData userData;
  String branchName = "";
  dynamic userName;
  dynamic password;
  late String token;
  dynamic total = 0;
  int slnum = 0;
  String dateNow = DateFormat("yyyy-MM-dd").format(DateTime.now());
  dynamic TotalAmt = 0.00;
  String PaymentName = ""; //for Add payment type name in heding
//----------------------------------

  // PrinterNetworkManager _printerManager = PrinterNetworkManager();
  var dataForTicket;
  var _devicesMsg = "";


  // flutter_printer _printerManager =flutter_printer();
  void initState() {
    setState(() {
      SharedPreferences.getInstance().then((value) {
        pref = value;
        read();
        if (Platform.isAndroid) {
          WebView.platform = SurfaceAndroidWebView();
        }
      });

      // Priter_Initial_Part();
      super.initState();
    });
    Timer(Duration(seconds: 2), () {
      setState(() {
        i = 2;
      });
    });
  }

//------------------for appbar------------
  read() async {
    var v = pref.getString("userData");
    var c = json.decode(v);
    user = UserData.fromJson(c); // token gets this code user.user["token"]
    setState(() {
      print(json.encode(user));
      branchId = int.parse(c["BranchId"]);
      token = user.user["token"];
      password = user.password;
      //  passes this user.user["token"]
      pref.setString("customerToken", user.user["token"]);
      branchName = user.branchName;
      userName = user.user["userName"];
      userId = user.user["userId"];

      print("branchName");
      print(branchName);
      print("userName");
      print(userName);
      print("userId");
      print(userId);
      print("userId");
      print(branchId);
    });
  }

  var num = 0;

  // test()  {
  //
  //
  //   // Timer(Duration(seconds: 1), () {
  //
  //     setState(() {
  //       num =  num + 1;
  //       print("tiu");
  //     });
  //   // }
  //   // );
  //
  //
  // }


  NotificationpayloadFun() {
    showDialog(
        context: context,
        builder: (c) =>
            AlertDialog(
              content: Text(
                  "Do you really want to logout?"),
            ));
  }


  int i = 1;

//-----------------------------------------------------All functions End---------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(

            appBar: PreferredSize(
                preferredSize: Size.fromHeight(160.0),
                child: Appbarcustomwidget(
                  branch: branchName,
                  pref: pref,
                  title: "Test",
                  uname: userName,)
            ),

            body: PdfPreview(
              // initialPageFormat: PdfPageFormat.a4,
              allowPrinting: false,
              allowSharing: false,
              canChangePageFormat: false,
              useActions: true,
              build: (format) => _generatePdf(format, context),
            )



            // ListView(
            //     shrinkWrap: true, physics: ScrollPhysics(), children: [
            //   //--------------------------------For Item Grp-----------------------------------------
            //   Row(children: [
            //     SizedBox(
            //       height: 50,
            //       child: Padding(
            //         padding: const EdgeInsets.only(top: 10, left: 10),
            //         child: GestureDetector(
            //           onTap: () {
            //             setState(() {
            //               GetdataPrint();
            //             });
            //           },
            //           child: Text(
            //             "print 1",
            //             style: TextStyle(
            //                 fontWeight: FontWeight.bold, fontSize: 25),
            //           ),
            //         ),
            //       ),
            //     ),
            //
            //   ]),
            //
            //   SizedBox(
            //     height: 50,
            //     child: Padding(
            //       padding:
            //       const EdgeInsets.only(top: 10, left: 10, right: 70),
            //       child: GestureDetector(
            //         onTap: () {
            //
            //         },
            //         child: Text(
            //           "print 2",
            //           style: TextStyle(
            //               fontWeight: FontWeight.bold, fontSize: 25),
            //         ),
            //       ),
            //     ),
            //   ),
            //
            //   SizedBox(
            //     height: 400,width: 300,
            //     child:
            //   PdfPreview(
            //    // initialPageFormat: PdfPageFormat.a4,
            //     allowPrinting: false,
            //     allowSharing: false,
            //     canChangePageFormat: false,
            //     useActions: true,
            //     build: (format) => _generatePdf(format, context),
            //   )),
            //
            //
            // ])
        )
    );
  }


  wifiprinting() async {
    print(" print in");
    _printerManager.selectPrinter('192.168.0.100');

    final res =
    await _printerManager.printTicket(await _ticket(PaperSize.mm80));
    print(" print in");
    // } catch (e) {
    //   print("error on print $e");
    // }
  }


  GetdataPrint() {
    dataForTicket = {
      "salesHeader": [
        {
          "id": 54,
          "voucherNo": 54,
          "voucherDate": "2022-02-14T00:00:00",
          "orderHeadId": null,
          "orderDate": null,
          "orderNo": null,
          "expDate": null,
          "ledgerId": null,
          "lhName": null,
          "lhContactNo": null,
          "lhGstno": null,
          "partyName": "xx",
          "address1": null,
          "address2": null,
          "msStateCode": null,
          "msName": null,
          "gstNo": null,
          "phone": null,
          "shipToName": null,
          "shipToAddress1": null,
          "shipToAddress2": null,
          "shipToPhone": null,
          "narration": null,
          "amount": 10.0000,
          "taxAmt": null,
          "roundOff": null,
          "otherAmt": 0.0000,
          "discountAmt": 0.0000,
          "creditPeriod": null,
          "paymentCondition": null,
          "paymentType": 0,
          "invoiceType": null,
          "invoicePrefix": null,
          "invoiceSuffix": null,
          "cancelFlg": null,
          "entryDate": "2022-02-14T16:39:05.07",
          "slesManId": null,
          "emEmployeeName": null,
          "branchUpdated": false,
          "userId": 17,
          "branchId": 12,
          "saleTypeInterState": true,
          "adlDiscPercent": null,
          "adlDiscAmount": null,
          "cashReceived": 10.0000,
          "balanceAmount": 10.0000,
          "adjustAmount": 0.0000,
          "otherAmountReceived": null,
          "deliveryType": "true",
          "deliveryTo": "",
          "tokenNo": 5
        }
      ],
      "salesDetails": [
        {
          "id": 160,
          "shid": 54,
          "itemId": 45,
          "itmName": "Code Red + Blueberry",
          "itmArabicName": "اختبار",
          "itmCode": "156",
          "itmBatchEnabled": null,
          "itmExpirtyEnabled": null,
          "qty": 1.00,
          "rate": 10.0000,
          "mrp": null,
          "prate": null,
          "disPercentage": null,
          "cgstPercentage": null,
          "sgstPercentage": null,
          "cessPercentage": null,
          "discountAmount": 0.0000,
          "cgstAmount": 0.0000,
          "sgstAmount": 0.0000,
          "cessAmount": 0.0000,
          "igstPercentage": null,
          "igstAmount": 0.0000,
          "taxPercentage": 15.0000,
          "taxAmount": 1.5000,
          "taxInclusive": true,
          "amountBeforeTax": 8.5000,
          "amountIncludingTax": 10.0000,
          "netTotal": 10.0000,
          "hsncode": null,
          "gdnId": null,
          "taxId": 1,
          "txDescription": "VAT 15  %",
          "rackId": null,
          "addTaxId": null,
          "unitId": 3,
          "uom": "LRG",
          "uomArabic": null,
          "barcode": null,
          "nosInUnit": null,
          "stockId": 0,
          "batchNo": null,
          "expiryDate": null,
          "notes": "",
          "itmIsTaxAplicable": true,
          "itemSlNo": 2,
          "adlDiscAmount": null,
          "adlDiscPercent": null,
          "salesManIdDet": null,
          "igKotPrinter": "\\\\fruit-nectar2\\Kitchen"
        }
      ],
      "salesExpense": []
    };


    _ticket(PaperSize.mm80);
    wifiprinting();
  }

  ///----------------------print part-----------------------
  final arabicText = utf8.encode('اختبار');

//----------printing ticket generate--------------------------
  PrinterNetworkManager _printerManager = PrinterNetworkManager();

  Future<Ticket> _ticket(PaperSize paper) async {
    print('in print Ticket');
    final ticket = Ticket(paper);


    // Uint8List title = await CharsetConverter.encode('ISO-8859-6', "فاتورة ضريبية");
    // ticket.textEncoded(title,styles:  PosStyles(codeTable:PosCodeTable.arabic) );
    // ticket.textEncoded(title,styles:  PosStyles(codeTable:PosCodeTable.pc864_2) );
    // ticket.textEncoded(title,styles:  PosStyles(codeTable:PosCodeTable.pc1001_2) );
    // ticket.textEncoded(title,styles:  PosStyles(codeTable:PosCodeTable.wp1256) );
    // ticket.textEncoded(title,styles:  PosStyles(codeTable:PosCodeTable.pc720) );
    // ticket.textEncoded(title,styles:  PosStyles(codeTable:PosCodeTable.pc850) );
    // ticket.textEncoded(title,styles:  PosStyles(codeTable:PosCodeTable.pc858_2) );


    ticket.textEncoded(arabicText);
    //  ticket.text('اختبار',styles:  PosStyles(codeTable:PosCodeTable.arabic,) );


//     List<dynamic> DetailPart = dataForTicket["salesDetails"] as List;
//
//     print("dataForTicket");
//     print(dataForTicket.toString());
//     print("DetailPart");
//     print(DetailPart.toString());
//
//     dynamic VchNo = (dataForTicket["voucherNo"]) == null
//         ? "00": (dataForTicket["voucherNo"]).toString();
//
//     // dynamic date = (DateFormat("dd/MM/yyy hh:mm:ss a").format(DateTime.now()).toString());
//
//
//     dynamic partyName=(dataForTicket["partyName"]) == null ||
//         (dataForTicket["partyName"])== ""
//         ? ""
//         : (dataForTicket["partyName"]).toString();
//
//
//
//     ticket.row([
//       PosColumn(text: ' ', width: 1),
//       PosColumn(
//           text:branchName.toString(),
//           width: 10,
//           styles: PosStyles(bold: true,
//             align: PosAlign.center,
//             height: PosTextSize.size2,
//             width: PosTextSize.size2,
//           )),
//       PosColumn(text: ' ', width: 1)
//     ]);
//
//
//
//
//     ticket.row([
//       PosColumn(text: ' ', width: 1),
//       PosColumn(
//         // text:(Companydata["companyProfileAddress1"]).toString(),
//           text:("Order Slip"),
//           width: 10,
//           styles:PosStyles(bold: false,
//             align: PosAlign.center,
//             height: PosTextSize.size1,
//             width: PosTextSize.size1,)),
//       PosColumn(text: ' ', width: 1)
//     ]);
//
// // ticket.text(arabicText.toString());
// print("arabicText.toString()");
//     ticket.textEncoded(
//        arabicText, styles: PosStyles(codeTable: PosCodeTable.arabic));
//
// // print('${
// //   ticket.textEncoded(
// //       arabicText, styles: PosStyles(codeTable: PosCodeTable.arabic))
// // }');
//
//     //
//     // ticket.row([
//     //   PosColumn(text: ' ', width: 1),
//     //   PosColumn(
//     //       text: (Companydata["companyProfileAddress2"]).toString(),
//     //       width: 10,
//     //       styles:PosStyles(bold: false,
//     //         align: PosAlign.center,
//     //         height: PosTextSize.size1,
//     //         width: PosTextSize.size1,
//     //       )),
//     //   PosColumn(text: ' ', width: 1)
//     // ]);
//     //
//     // ticket.row([
//     //   PosColumn(text: ' ', width: 1),
//     //   PosColumn(
//     //       text:  (Companydata["companyProfileAddress3"]).toString(),
//     //       width: 10,
//     //       styles:PosStyles(bold: false,
//     //         align: PosAlign.center,
//     //         height: PosTextSize.size1,
//     //         width: PosTextSize.size1,
//     //       )),
//     //   PosColumn(text: ' ', width: 1)
//     // ]);
//     //
//     //
//     //
//     // ticket.row([
//     //   PosColumn(text: ' ', width: 1),
//     //   PosColumn(
//     //       text:(Companydata["companyProfileMobile"]).toString(),
//     //       width: 10,
//     //       styles:PosStyles(bold: false,
//     //         align: PosAlign.center,
//     //         height: PosTextSize.size1,
//     //         width: PosTextSize.size1,
//     //       )),
//     //   PosColumn(text: ' ', width: 1)
//     // ]);
//     //
//     //
//     //
//     //
//     // ticket.row([
//     //   PosColumn(text: ' ', width: 1),
//     //   PosColumn(
//     //       text:  (Companydata["companyProfileEmail"]).toString(),
//     //       width: 10,
//     //       styles:PosStyles(bold: false,underline: true,
//     //         align: PosAlign.center,
//     //         height: PosTextSize.size1,
//     //         width: PosTextSize.size1,
//     //       )),
//     //   PosColumn(text: ' ', width: 1)
//     // ]);
//     //
//     //
//     //
//     //
//     //
//     // ticket.text('GSTIN: ' +
//     //     ( Companydata["companyProfileGstNo"]).toString()+' ',
//     //     styles: PosStyles(bold: false,
//     //       align: PosAlign.center,
//     //       height: PosTextSize.size1,
//     //       width: PosTextSize.size1,
//     //     ));
//     //
//     //
//     // ticket.text('Token NO : ' + VchNo.toString(),
//     //     styles: PosStyles(bold: true, width: PosTextSize.size1));
//     // //ticket.emptyLines(1);
//     // ticket.text('Date : $date');
//
//     //---------------------------------------------------------
//     if(partyName !="")
//     {
//       //ticket.emptyLines(1);
//       ticket.text('Name : $partyName');
//     }
//     if((dataForTicket["gstNo"]) !=null)
//     {
//       // ticket.emptyLines(1);
//       ticket.text('GST No :' +((dataForTicket["gstNo"])));
//     }
//     //---------------------------------------------------------
//
//     ticket.hr(ch: '_');
//     ticket.row([
//       PosColumn(
//         text:'No',
//         styles: PosStyles(align: PosAlign.left ),
//         width:1,
//       ),
//       PosColumn(
//         text:'Item',
//         styles: PosStyles(bold: true,align: PosAlign.center),
//         width: 2,
//       ),
//       PosColumn(text: 'Rate', width: 3,styles:PosStyles(align: PosAlign.right)),
//       PosColumn(text: 'Qty', width: 2,styles: PosStyles(align: PosAlign.right ),),
//       // PosColumn(text: 'Tax', width: 2,styles: PosStyles(align: PosAlign.center ),),
//       PosColumn(text: ' Amonunt', width: 4,styles: PosStyles(align: PosAlign.center ),),
//     ]);
//     ticket
//         .hr(); // for dot line or set ticket.hr(ch: 'charecter', linesAfter: 1);
//     var snlnum=0;
//     dynamic total = 0.000;
//     for (var i = 0; i < DetailPart.length; i++) {
//       total = DetailPart[i]["amountIncludingTax"] ??0+ total;
//       // ticket.emptyLines(1);
//       snlnum=snlnum+1;
//       ticket.row([
//         PosColumn(text: (snlnum.toString()),width: 1,styles: PosStyles(
//             fontType: PosFontType.fontB,align: PosAlign.left
//         )),
//
//         PosColumn(text: (DetailPart[i]["item"]??""),
//             width: 3,styles:
//             PosStyles( fontType: PosFontType.fontB,align: PosAlign.left )),
//
//         // for space
//
//         PosColumn(
//             text: (((DetailPart[i]["rate"])).toStringAsFixed(2)).toString(),
//             width: 3,
//             styles: PosStyles(
//                 fontType: PosFontType.fontB,align: PosAlign.right
//             )),
//         PosColumn(
//             text: (' '+((DetailPart[i]["qty"])).toStringAsFixed(0)).toString(),styles:PosStyles(align: PosAlign.right ),
//             width: 2),
//         // PosColumn(
//         //     text: (' ' + ((DetailPart[i]["taxAmount"])).toStringAsFixed(2))
//         //         .toString(),styles:PosStyles(align: PosAlign.right ),
//         //     width: 2),
//         PosColumn(
//             text: ((DetailPart[i] ["amountIncludingTax"])).toStringAsFixed(2)
//             ,styles:PosStyles(align:PosAlign.center ),
//             width:3),
//       ]);
//     }
//
//
//     ticket.hr(ch:"=");
//     ticket.row([
//       PosColumn(
//           text: 'Total',
//           width: 4,
//           styles: PosStyles(
//             bold: true,align:PosAlign.left,
//           )),
//       PosColumn(
//           text:'Rs '+(total.toStringAsFixed(2)).toString(),
//           width: 7,
//           styles: PosStyles(bold: true,align: PosAlign.center,)),
//       PosColumn(
//         text:' ',
//         width: 1,),
//     ]);
//     ticket.hr(
//         ch: '_');
//
//     // ticket.row([
//     //   PosColumn(text: ' ', width: 1),
//     //   PosColumn(
//     //       text: footerCaptions[0]['footerCaption'],
//     //       width: 10,
//     //       styles: PosStyles(align: PosAlign.center)),
//     //   PosColumn(text: ' ', width: 1)
//     // ]);
//     //
//     // ticket.row([
//     //   PosColumn(text: '  ', width: 1),
//     //   PosColumn(
//     //       text: footerCaptions[0]['footerText'],
//     //       width: 10,
//     //       styles: PosStyles(align: PosAlign.center)),
//     //   PosColumn(text: '  ', width: 1)
//     // ]);
//
//     ticket.feed(1);
//     ticket.text('Thank You...Visit again !!',
//         styles: PosStyles(align: PosAlign.center, bold: true));
    print("Finish");
    ticket.cut();
    return ticket;
  }

//..................................................
//   wifiprinting(printerName) async {
//     // try {
//
//     print("in print in 123");
//
//     //_printerManager.selectPrinter(printerName);
//
//    // _printerManager.selectPrinter('192.168.0.100');
//
//     final res =
//     await _printerManager.printTicket(await _ticket(PaperSize.mm80));
//     print("out print in");
//     // } catch (e) {
//     //   print("error on print $e");
//     // }
//   }

//----------------------Print part End-----------------------------------------


  Future<Uint8List> _generatePdf(PdfPageFormat format,
      BuildContext context) async {
   //final pdf = pw.Document(compress: true);
    final pdf = pw.Document(compress: true);
    final font = await rootBundle.load("assets/arial.ttf");
    final ttf = pw.Font.ttf(font);

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text("Hello World"),
          ); // Center
        }));
  }

}