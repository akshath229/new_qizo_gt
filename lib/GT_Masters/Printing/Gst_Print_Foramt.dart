// import 'dart:convert';
// import 'dart:developer';
// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_app/GT_Masters/Printing/CurrencyWordConverter.dart';
// import 'package:flutter_app/GT_Masters/Printing/PDF_2Inch_Print.dart';
// import 'package:flutter_app/appbarWidget.dart';
// import 'package:flutter_app/models/userdata.dart';
// import 'package:flutter_app/urlEnvironment/urlEnvironment.dart';
// import 'package:intl/intl.dart';
// import 'package:printing/printing.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:pdf/widgets.dart' as pw;
// import 'package:pdf/pdf.dart';
//
// class GST_Print_Format extends StatefulWidget {
//   var Parm_Id;
//   var Details_Data;
//   var title;
//   GST_Print_Format({this.Parm_Id,this.Details_Data,this.title});
//
//   @override
//   _GST_Print_FormatState createState() => _GST_Print_FormatState();
// }
//
// class _GST_Print_FormatState extends State<GST_Print_Format> {
//
//   Pdf_Two_Inch Pdf_2=Pdf_Two_Inch();
//
//   SharedPreferences pref;
//   dynamic branch;
//   var res;
//   dynamic user;
//   int branchId;
//   int userId;
//   String currencyName;
//   String currencyCoinName;
//   UserData userData;
//   String branchName = "";
//   dynamic userName;
//   String token;
//   // var DateTimeFormat = new DateFormat('dd-MM-yyyy hh a');
//   var DateTimeFormat = new DateFormat('dd-MM-yyyy');
//   String Datetime_Now = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());
//   var Detailspart;
//   var Headerpart;
//   var dataForTicket;
//   var  Companydata;
//
//   NumberToWord Amonut_To_CharConverter=NumberToWord();
//
//   String IsArabicChkBoxText="Arabic";
//   var Pdf_fontSize=9.0;
//   var  TaxType;
//   var  TableKeys=[];
//   bool Contain_ID=false;
//
//   // NumberToWord arabicAmount = NumberToWord();
//
//
//   void initState() {
//
//     setState(() {
//       // Detailspart= widget.Details_Data;
//       // dataForTicket= widget.Details_Data;
//       SharedPreferences.getInstance().then((value) {
//         pref = value;
//         read();
//         GetQrdata();
//         GeneralSettings();
//         // DynamicDatakey();
//         GetdataPrint(widget.Parm_Id);
//         GetCompantPro();
//       });
//     });
//   }
//
// //------------------for appbar------------
//   read() async {
//     var v = pref.getString("userData");
//     var c = json.decode(v);
//     user = UserData.fromJson(c); // token gets this code user.user["token"]
//     setState(() {
//       branchId = int.parse(c["BranchId"]);
//       token = user.user["token"]; //  passes this user.user["token"]
//       pref.setString("customerToken", user.user["token"]);
//       branchName = user.branchName;
//       userName = user.user["userName"];
//       userId = user.user["userId"];
//       currencyCoinName = user.user["currencyCoinName"];
//       currencyName = user.user["currencyName"];
//     });
//     print(" the coint ah" + branchId.toString() + " " + currencyCoinName + " " +  currencyName);
//     print("the value is " + Amonut_To_CharConverter.toString());
//   }
//
//
//   GetdataPrint(id) async {
//     try {
//       //   print("sales for print : $id");
//       double amount = 0.0;
//
//       final tagsJson =
//       await http.get("${Env.baseUrl}SalesHeaders/$id", headers: {
//         //Soheader //SalesHeaders
//         "Authorization": user.user["token"],
//       });
//       if (tagsJson.statusCode < 205) {
//         var respRes = await jsonDecode(tagsJson.body);
//         setState(() {
//           log("ttttttttttt${respRes.toString()}");
//           Headerpart = respRes["salesHeader"][0];
//           Detailspart = respRes;
//           // print("ttttttttttt${Detailspart.toString()}");
//           // print("llllll${Detailspart.length.toString()}");
//
//           GetBuyerDetails(Headerpart["ledgerId"]);
//           GetToatlAmts();
//         });
//       }
//     }catch(e){ print("error ..................$e.... ");}
//
//   }
//
//   GeneralSettings()async{
//     try {
//       final res =
//       await http.get("${Env.baseUrl}generalSettings", headers: {
//         "Authorization": user.user["token"],
//       });
//
//       if (res.statusCode < 210) {
//         // print(res);
//         var GenSettingsData = json.decode(res.body);
//         // print(GenSettingsData[0]["applicationTaxTypeGst"]);
//         setState(() {
//           GenSettingsData[0]["applicationTaxTypeGst"] == true ?
//           TaxType = "Gst.No" : TaxType = "Vat.No";
//           print("TaxType");
//           //print(TaxType);
//
//         });
//       }
//     }catch(e){print("GeneralSettings error on $e");}
//   }
//
//
//   var BuyerDetails;
//   GetBuyerDetails(id) async {
//     try {
//       //  print("GetBuyerDetails datas $id");
//       final tagsJson =
//       await http.get("${Env.baseUrl}MLedgerHeads/$id", headers: {
//         "Authorization": user.user["token"],
//       });
//
// // print("BuyerDetailssssssssssss");
// // print(tagsJson.statusCode.toString());
// // print(tagsJson.body.toString());
//       if(tagsJson.statusCode<205) {
//         if (tagsJson.body.contains("errors")) {
//           print("Error on GetBuye");
//           setState(() {
//             BuyerDetails = [
//               {
//                 "lhName": "",
//                 "nameLatin": null,
//                 "districtName": null,
//                 "areaName": null,
//                 "lhPincode": null,
//                 "lhGstno": null,
//                 "buildingNo": null,
//                 "buildingNoLatin": "",
//                 "streetName": "",
//                 "streetNameLatin": "",
//                 "district": "",
//                 "districtLatin": " ",
//                 "city": " ",
//                 "cityLatin": "",
//                 "country": " ",
//                 "countryLatin": "",
//                 "pinNo": "",
//                 "pinNoLatin": ""
//               }
//             ];
//           });
//         } else {
//           var Buyer = await jsonDecode(tagsJson.body);
//           setState(() {
//             BuyerDetails = Buyer["ledgerHeads"];
//             //  print("GetBuyerDetails datas :" + BuyerDetails.toString());
//             // print(BuyerDetails[0]["lhName"]);
//
//           });
//         }
//       }
//     } catch (e) {
//       print("Error on GetBuyerDetails $e");
//     }
//   }
//
//
//   var Qrdata;
//   GetQrdata() async {
//     try {
//       print("QR datas");
//       final tagsJson =
//       await http.get("${Env.baseUrl}SalesHeaders/${widget.Parm_Id}/qrcode", headers: {
//         "Authorization": user.user["token"],
//       });
//       var footerdata =await jsonDecode(tagsJson.body);
//       setState(() {
//         Qrdata = footerdata[0]["qrString"];
//         //  print( "QR datas :" +Qrdata.toString());
//       });
//
//     } catch (e) {
//       print(e);
//     }
//   }
//
//
//   GetCompantPro()async{
//     // print("GetCompantPro");
//     // print(id.toString());
//     try {
//       final tagsJson =
//       await http.get("${Env.baseUrl}MCompanyProfiles/$branchId", headers: {
//         //Soheader //SalesHeaders
//         "Authorization": user.user["token"],
//       });
//       if(tagsJson.statusCode==200) {
//         var resdata=await jsonDecode(tagsJson.body);
//         setState(() {
//           Companydata = resdata;
//         });
//
//         // print(  Companydata['companyProfileAddress1'].toString());
//       }
//       //log( "on GetCompantPro :" +Companydata.toString());
//
//     }
//     catch(e){
//       print("error on GetCompantPro : $e");
//     }
//   }
//
//
//
//
//
//
//
//
//   TopTblPart(width){
//
//     return pw.Column(children: [
//     pw.Column(children: [
//     pw.Table.fromTextArray(
//     cellAlignments:{0: pw.Alignment.topLeft,1: pw.Alignment.topLeft,},
//     data: [
//     [ "Details of Supplyer:"
//     "\n${Companydata['companyProfileName']??""}"
//     "\n${Companydata['companyProfileNameLatin']??""} "
//     "\n${Companydata['companyProfileAddress1']??""} "
//     "\n${Companydata['companyProfileAddress2']??""} "
//     "\n${Companydata['companyProfileAddress3']??""} "
//     "\n${Companydata['companyProfileEmail']??""} "
//     "\n${Companydata['companyProfileGstNo']??""} ",
//     "Details Of Invoice:"
//     "\n Invoice Date: ${Headerpart["voucherDate"]}"
//     "\n Invoice No: ${Headerpart["voucherNo"]}"
//     "\n Payment type: ${Headerpart["paymentCondition"]}"
//     "\n Invoice Amount: ${Total_Invoice.toStringAsFixed(2)}",
//     ],
//
//
//
//     [  "Details of Buyer(Bill To):"
//     "\n${BuyerDetails[0]["lhName"]??""}"
//     "\n${BuyerDetails[0]["lhMailingAddress1"]??""} "
//     "\n${BuyerDetails[0]["lhMailingAddress2"]??""}"
//     "\n${BuyerDetails[0]["lhPincode"]??""}"
//     "\n${"Ph: "+BuyerDetails[0]["lhContactNo"]??""}"
//     "\n${BuyerDetails[0]["lhEmail"]??""}",
//
//     "Details of Buyer(Shipped To):"
//
//     "\n${BuyerDetails[0]["lhName"]??""}"
//     "\n${BuyerDetails[0]["lhMailingAddress1"]??""} "
//     "\n${BuyerDetails[0]["lhMailingAddress2"]??""}"
//     "\n${BuyerDetails[0]["lhPincode"]??""}"
//     "\n${"Ph: "+BuyerDetails[0]["lhContactNo"]??""}"
//     "\n${BuyerDetails[0]["lhEmail"]??""}"
//     ],
//
//
//     ],
//     cellHeight: 50,
//     columnWidths:{0: pw.FixedColumnWidth(width-50)},
//     ),
//     ]),
//
//
//
//
//     ]) ;
//
//
//
// }
//
//
//
//   BottomTblPart(width){
//
//     return pw.Row(children: [
//
//       pw.SizedBox(
//         width: width-50,
//         child:
//       pw.Column(children: [
//
//         pw.Table.fromTextArray(
//           data: [["Tot Qty", "InvoiceTotal"," CGST.Total", "SGST.Total"],
//             ["${Tot_Qty.toString()}",
//               "${(Total_InvoiceWithoutTax).toStringAsFixed(2)}",
//               "${(Total_GST/2).toStringAsFixed(2)}",
//               "${(Total_GST/2).toStringAsFixed(2)}"]],
//           // columnWidths:{0: pw.FixedColumnWidth(width-50)},
//         ),
//
// // pw.Expanded(child:
// pw.Table.fromTextArray(
//   cellHeight: 47,
//   data: [["Notes"]],),
//
// // ),
//
//         pw.Table.fromTextArray(
//           data: [["${Amonut_To_CharConverter.convert(Locale.en_ind, Total_Invoice.floor())}"]],
//
//           // columnWidths:{0: pw.FixedColumnWidth(width-50)},
//         ),
//       ],),
//           ),
//
//
//
//         pw.Expanded(
//           child:pw.Table.fromTextArray(
//               cellAlignments:{0: pw.Alignment.topLeft,1: pw.Alignment.topLeft,},
//             data: [
//               ["Total Invoice","${(Total_InvoiceWithoutTax).toStringAsFixed(2)}"],
//               ["Total GST","${Total_GST.toStringAsFixed(2)}"],
//               ["Freight",""],
//               ["Discount","${Toatal_DiscountAmt.toStringAsFixed(2)}"],
//              ["Net Amount","${Total_Invoice.toStringAsFixed(2)}"],
//             ]
//         ),
//
//         ),
//       ]);
//
//
//
//
//
//
//   }
//
//
//   isDataLoaded(){
//     if(Headerpart==null||Companydata==null||Qrdata==null||BuyerDetails==null){
//
//       return false;
//     }else {
//       // print(Headerpart.toString());
//       // print(Companydata.toString());
//       // print(Qrdata.toString());
//      // print(BuyerDetails.toString());
//       return true;
//     }
//   }
//
//   ///---------------------------------------------
//
//   @override
//   Widget build(BuildContext context) {
//     var ScreenSize=MediaQuery.of(context).size.width;
//
//     return
//       SafeArea(
//         child: Scaffold(
//           appBar: PreferredSize(preferredSize: Size.fromHeight(80),
//             child: Appbarcustomwidget(uname: userName, branch:branchName, pref: pref, title:"Print"),),
//
//           body: isDataLoaded()==false?SizedBox(height: ScreenSize,width: ScreenSize,
//         child: Center(child: Text("Loading..."))):
//           // Headerpart == null ? SizedBox(height: ScreenSize,width: ScreenSize,
//           //     child: Center(child: Text("Loading..."))) :
//           // Companydata == null ? SizedBox(height: ScreenSize,width: ScreenSize,
//           //     child: Center(child: Text("Loading..."))) :
//
//
//           PdfPreview(
//             initialPageFormat:PdfPageFormat.a4 ,
//             allowPrinting: true,
//             allowSharing: false,
//             canChangePageFormat: false,
//             useActions: true,
//             build: (format) =>_generatePdf(format, ScreenSize,context),
//           ),
//
//
//
//         ),);
//   }
//
//
//
//
//   Future<Uint8List> _generatePdf(PdfPageFormat format,
//       ScreenSize,BuildContext context) async {
//     final pdf = pw.Document(compress: true);
//     final font = await rootBundle.load("assets/arial.ttf");
//     final ttf = pw.Font.ttf(font);
//
//
//
//
//     pdf.addPage(
//       pw.MultiPage(
//         footer:(pw.Context context) {
//
//           return
//             pw.Center(child:
//             pw.Text('Page ${context.pageNumber} of  ${context.pagesCount}',)
//             );
//         } ,
//
//
//         margin:pw.EdgeInsets.only(top: 20,left: 20,bottom: 20,right: 20),
//         pageFormat:PdfPageFormat.a4,
//
//         build: (pw.Context context) {
//           return <pw.Widget
//           >[
//
//
//             Headerpart == null ? pw.Text('') :
//             pw.Center(child:
//
//
//                 pw.Row(
//                   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                     children: [
//
//
//           pw.BarcodeWidget(
//                               // data: widget.Parm_Id.toString(),
//                                 data:Qrdata.toString(),
//                                 barcode: pw.Barcode.code128(),
//                                 width: 50,
//                                 height: 50,
//                                  drawText: false
//                             ),
//
//             pw.Column(
//
//                 mainAxisAlignment:pw.MainAxisAlignment.center,
//                 crossAxisAlignment:pw.CrossAxisAlignment.center,
//                 children: [
//
//                   pw.Text(Companydata['companyProfileName']??"", textAlign: pw.TextAlign.center,
//                       textDirection: pw.TextDirection.rtl,
//                       style: pw.TextStyle(
//                           fontSize: Pdf_fontSize,
//                           font: ttf,
//                           fontWeight: pw.FontWeight.bold
//                       )),
//
//                   pw.Text(Companydata['companyProfileNameLatin']??"", textAlign: pw.TextAlign.center,
//                       textDirection: pw.TextDirection.rtl,
//                       style: pw.TextStyle(
//                           fontSize: Pdf_fontSize,
//                           font: ttf,
//                           fontWeight: pw.FontWeight.bold
//                       )),
//
//                   pw.Text(Companydata['companyProfileAddress1']??"", textAlign: pw.TextAlign.center,
//                       textDirection: pw.TextDirection.rtl,
//                       style: pw.TextStyle(
//                           fontSize: Pdf_fontSize,
//                           font: ttf)),
//
//                   pw.Text(Companydata['companyProfileAddress2']??"", textAlign: pw.TextAlign.center,
//                       textDirection: pw.TextDirection.rtl,
//                       style: pw.TextStyle(
//                           fontSize: Pdf_fontSize,
//                           font: ttf)),
//
//                   pw.Text(Companydata['companyProfileAddress3']??"", textAlign: pw.TextAlign.center,
//                       textDirection: pw.TextDirection.rtl,
//                       style: pw.TextStyle(
//                           fontSize: Pdf_fontSize,
//                           font: ttf)),
//
//                   pw.Text(Companydata['companyProfileEmail']??"", textAlign: pw.TextAlign.center,
//                       textDirection: pw.TextDirection.rtl,
//                       style: pw.TextStyle(
//                           fontSize: Pdf_fontSize,
//                           font: ttf
//                       )),
//
//                         pw.Text(Companydata['companyProfileGstNo']??"", textAlign: pw.TextAlign.center,
//                         textDirection: pw.TextDirection.rtl,
//                         style: pw.TextStyle(
//                         fontSize: Pdf_fontSize,
//                         font: ttf
//                         )),
//                   pw.SizedBox(height: 5),
//                //   pw.Text('${(widget.title)??"Report"}', textAlign: pw.TextAlign.center,
//                       //textDirection: pw.TextDirection.rtl,
//                       // style: pw.TextStyle(
//                       //     fontSize: Pdf_fontSize,
//                       //     // font: ttf,
//                       //     decoration:pw.TextDecoration.underline)),
//
//                   pw.SizedBox(height: 5),
//
//                 ]),
//
//
//                       pw.Text(""),
//
//                 ]),
//             ),
//
//             pw.SizedBox(
//               height: 2,),
//
// ///---------------------------------------------------------
//
//             TopTblPart(ScreenSize),
//
// pw.SizedBox(height: 7),
//
//
//
//
//             pw.SizedBox(height: 20),
//
//             pw.Partition(
//                 child:
//                 pw.Table.fromTextArray(
//                     tableWidth:pw.TableWidth.max ,
//                     cellAlignment: pw.Alignment.topRight,
//                     cellAlignments:{0: pw.Alignment.topLeft,1: pw.Alignment.topLeft,},
//                     // columnWidths:TableKeys.length>5? {0:pw.FixedColumnWidth(15)}:{0:pw.FixedColumnWidth(5),},
//
//                     cellStyle: pw.TextStyle(font: ttf,fontSize: Pdf_fontSize),
//                     headerStyle: pw.TextStyle(fontWeight:pw.FontWeight.bold,font: ttf,fontSize: 11,),
//                     headerAlignment:pw.Alignment.topRight,
//                     headerAlignments:{0: pw.Alignment.topLeft,1: pw.Alignment.topLeft},
//                     headerDecoration: pw.BoxDecoration(border: pw
//                         .Border(bottom: pw.BorderSide(
//                         color: PdfColors.black))),
//                     cellPadding:pw.EdgeInsets.all(1),
//                     headers:TblHeader,//TblHeader,
//                     data:TableGenerator()
//                   // data: [Detailspart]
//                 )
//             ),
//
//             pw.SizedBox( height: 30,),
//
//             BottomTblPart(ScreenSize),
//
//             pw.SizedBox( height: 10,),
//
//             pw.Container(
//           decoration: pw.BoxDecoration(
//
//           // color: pw.Colors.white,
//           border: pw.Border.all( )),
//
//               child:pw.Column(children: [
//                 pw.SizedBox(height: 8),
//                 pw.Row(children: [
//                   pw.Text("      Prepared by :  ${BuyerDetails[0]['lhName']}") ,
//                   pw.SizedBox(width: 50),
//                   pw.Text("For ${Companydata['companyProfileName']}")
//                 ],),
//                 pw.Row(children: [
//                   pw.Text("      Printed on    : ${ DateFormat("dd:MM:yyyy h:mm:a").format(DateTime.now())}") ,
//
//                 ],),
//                 pw.SizedBox(height: 8),
//               ]),
//
//             )
//
//           ];
//         },
//       ),
//     );
//
//     return pdf.save();
//   }
//
//
//
//
//  var TblHeader= [
//    'Sl',
//    'Item' ,
//    'HSN' ,
//    'Rate',
//    'Qty',
//    "Disc" ,
//    "Net Value ",
//    "GST %",
//    " GST AMT",
//     "G. Total",
//  ];
//
//
//   TableGenerator() {
//     var purchasesAsMap;
//    // print(Detailspart["salesDetails"]);
//    // print(Detailspart["salesDetails"][0]["rate"]);
//     purchasesAsMap = <Map<String, String>>[
//     for (int i = 0; i < Detailspart["salesDetails"].length; i++) {
//
//       "sl": "${"${i+1}"}",
//       "ItemName": "${Detailspart["salesDetails"][i]['itmName']??""}",
//       "hsncode": "${Detailspart["salesDetails"][i]['hsncode']??""}",
//     "Rate": "${Detailspart["salesDetails"][i]['rate'].toStringAsFixed(2)} ",
//     "Qty": "${Detailspart["salesDetails"][i]['qty']} ",
//     "discount": "${(Detailspart["salesDetails"][i]['discountAmount']??0.00).toStringAsFixed(2)}",
//       "total": "${((Detailspart["salesDetails"][i]['qty']??0.0)*(((Detailspart["salesDetails"][i]['rate']??0.0))-Detailspart["salesDetails"][i]['discountAmount']??0.00)).toStringAsFixed(2)} ",
//     "TaxPer": "${Detailspart["salesDetails"][i]['taxPercentage']==null?"0.00":Detailspart["salesDetails"][i]['taxPercentage'].toStringAsFixed(2)} ",
//     "TaxAmt": "${Detailspart["salesDetails"][i]['taxAmount'].toStringAsFixed(2)=="0.00"?"":Detailspart["salesDetails"][i]['taxAmount'].toStringAsFixed(2)} ",
//     "NetAmt": "${Detailspart["salesDetails"][i]['amountIncludingTax'].toStringAsFixed(2)} ",
//     }
//     ];
//     List<List<String>> listOfPurchases = List();
//     for (int i = 0; i < purchasesAsMap.length; i++) {
//       listOfPurchases.add(purchasesAsMap[i].values.toList());
//     }
//     return listOfPurchases;
//     // print(purchasesAsMap);
//     // return purchasesAsMap;
//   }
//
//
//
//
//
//   var Total_InvoiceWithoutTax=0.0;
//   var Total_Invoice=0.0;
//   var Tot_Qty=0.0;
//   var Total_GST=0.0;
//   var Toatal_DiscountAmt=0.0;
//   GetToatlAmts(){
//
// var TotalAmtBfrTax=0.0;
// var G_Total=0.0;
//
//     for (int i = 0; i < Detailspart["salesDetails"].length; i++) {
//
//       TotalAmtBfrTax=TotalAmtBfrTax+Detailspart["salesDetails"][i]['amountBeforeTax']??0.0;
//       G_Total=G_Total+Detailspart["salesDetails"][i]['amountIncludingTax']??0.0;
//       Tot_Qty=Tot_Qty+Detailspart["salesDetails"][i]['qty']??0.0;
//
//     }
//     setState(() {
//       Total_GST=G_Total-TotalAmtBfrTax;
//       Total_InvoiceWithoutTax=Headerpart["amount"]??0.0;
//       Total_Invoice=Headerpart["balanceAmount"]??0.0;
//       Toatal_DiscountAmt=Headerpart['discountAmt']??0.0;
//     });
//
//   }
//
//
// }

///,,,,,,,,.......................................................


import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import '../../appbarWidget.dart';
import '../../models/userdata.dart';
import '../../urlEnvironment/urlEnvironment.dart';
import 'CurrencyWordConverter.dart';
import 'PDF_2Inch_Print.dart';

class GST_Print_Format extends StatefulWidget {
  var Parm_Id;
  var Details_Data;
  var title;
  GST_Print_Format({this.Parm_Id,this.Details_Data,this.title});

  @override
  _GST_Print_FormatState createState() => _GST_Print_FormatState();
}

class _GST_Print_FormatState extends State<GST_Print_Format> {

  Pdf_Two_Inch Pdf_2=Pdf_Two_Inch();

  late SharedPreferences pref;
  dynamic branch;
  var res;
  dynamic user;
  late int branchId;
  late int userId;
  late String currencyName;
  late String currencyCoinName;
  late UserData userData;
  String branchName = "";
  dynamic userName;
  late String token;
  // var DateTimeFormat = new DateFormat('dd-MM-yyyy hh a');
  var DateTimeFormat = new DateFormat('dd-MM-yyyy');
  String Datetime_Now = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());
  var Detailspart;
  var Headerpart;
  var dataForTicket;
  var  Companydata;

  NumberToWord Amonut_To_CharConverter=NumberToWord();

  String IsArabicChkBoxText="Arabic";
  var Pdf_fontSize=9.0;
  var  TaxType;
  var  TableKeys=[];
  bool Contain_ID=false;

  // NumberToWord arabicAmount = NumberToWord();


  void initState() {

    setState(() {
      // Detailspart= widget.Details_Data;
      // dataForTicket= widget.Details_Data;
      SharedPreferences.getInstance().then((value) {
        pref = value;
        read();
        GetQrdata();
        GeneralSettings();
        // DynamicDatakey();
        GetdataPrint(widget.Parm_Id);
        GetCompantPro();
      });
    });
  }

//------------------for appbar------------
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
      currencyCoinName = user.user["currencyCoinName"];
      currencyName = user.user["currencyName"];
    });
    print(" the coint ah" + branchId.toString() + " " + currencyCoinName + " " +  currencyName);
    print("the value is " + Amonut_To_CharConverter.toString());
  }


  GetdataPrint(id) async {
    try {
      //   print("sales for print : $id");
      double amount = 0.0;

      final tagsJson =
      await http.get("${Env.baseUrl}SalesHeaders/$id" as Uri, headers: {
        //Soheader //SalesHeaders
        "Authorization": user.user["token"],
      });
      if (tagsJson.statusCode < 205) {
        var respRes = await jsonDecode(tagsJson.body);
        setState(() {
          log("ttttttttttt${respRes.toString()}");
          Headerpart = respRes["salesHeader"][0];
          Detailspart = respRes;
          // print("ttttttttttt${Detailspart.toString()}");
          // print("llllll${Detailspart.length.toString()}");

          GetBuyerDetails(Headerpart["ledgerId"]);
          GetToatlAmts();
        });
      }
    }catch(e){ print("error ..................$e.... ");}

  }

  GeneralSettings()async{
    try {
      final res =
      await http.get("${Env.baseUrl}generalSettings" as Uri, headers: {
        "Authorization": user.user["token"],
      });

      if (res.statusCode < 210) {
        // print(res);
        var GenSettingsData = json.decode(res.body);
        // print(GenSettingsData[0]["applicationTaxTypeGst"]);
        setState(() {
          GenSettingsData[0]["applicationTaxTypeGst"] == true ?
          TaxType = "Gst.No" : TaxType = "Vat.No";
          print("TaxType");
          //print(TaxType);

        });
      }
    }catch(e){print("GeneralSettings error on $e");}
  }


  var BuyerDetails;
  GetBuyerDetails(id) async {
    try {
      //  print("GetBuyerDetails datas $id");
      final tagsJson =
      await http.get("${Env.baseUrl}MLedgerHeads/$id" as Uri, headers: {
        "Authorization": user.user["token"],
      });

// print("BuyerDetailssssssssssss");
// print(tagsJson.statusCode.toString());
// print(tagsJson.body.toString());
      if(tagsJson.statusCode<205) {
        if (tagsJson.body.contains("errors")) {
          print("Error on GetBuye");
          setState(() {
            BuyerDetails = [
              {
                "lhName": "",
                "nameLatin": null,
                "districtName": null,
                "areaName": null,
                "lhPincode": null,
                "lhGstno": null,
                "buildingNo": null,
                "buildingNoLatin": "",
                "streetName": "",
                "streetNameLatin": "",
                "district": "",
                "districtLatin": " ",
                "city": " ",
                "cityLatin": "",
                "country": " ",
                "countryLatin": "",
                "pinNo": "",
                "pinNoLatin": ""
              }
            ];
          });
        } else {
          var Buyer = await jsonDecode(tagsJson.body);
          setState(() {
            BuyerDetails = Buyer["ledgerHeads"];
            print("GetBuyerDetails datas :" + BuyerDetails.toString());
            print(BuyerDetails[0]["lhName"]);

          });
        }
      }
    } catch (e) {
      print("Error on GetBuyerDetails $e");
    }
  }


  var Qrdata;
  GetQrdata() async {
    try {
      print("QR datas");
      final tagsJson =
      await http.get("${Env.baseUrl}SalesHeaders/${widget.Parm_Id}/qrcode" as Uri, headers: {
        "Authorization": user.user["token"],
      });
      var footerdata =await jsonDecode(tagsJson.body);
      setState(() {
        Qrdata = footerdata[0]["qrString"];
        //  print( "QR datas :" +Qrdata.toString());
      });

    } catch (e) {
      print(e);
    }
  }


  GetCompantPro()async{
    // print("GetCompantPro");
    // print(id.toString());
    try {
      final tagsJson =
      await http.get("${Env.baseUrl}MCompanyProfiles/$branchId" as Uri, headers: {
        //Soheader //SalesHeaders
        "Authorization": user.user["token"],
      });
      if(tagsJson.statusCode==200) {
        var resdata=await jsonDecode(tagsJson.body);
        setState(() {
          Companydata = resdata;
        });
        print("dfsddfs" + Companydata.toString());
        print(  Companydata['companyProfileAddress1'].toString());
      }
      //log( "on GetCompantPro :" +Companydata.toString());

    }
    catch(e){
      print("error on GetCompantPro : $e");
    }
  }









  TopTblPart(width){

    print("the wifgggdth is " + width.toString());



    return pw.Column(children: [
      pw.Column(children: [

        pw.Table.fromTextArray(
          cellAlignments:{0: pw.Alignment.topLeft,1: pw.Alignment.topLeft,},
          data: [
            [ "Details of Supplyer:"
                "\n${Companydata['companyProfileName'].toString()??""}"
                "\n${Companydata['companyProfileNameLatin'].toString()??""} "
                "\n${Companydata['companyProfileAddress1'].toString()??""} "
                "\n${Companydata['companyProfileAddress2'].toString()??""} "
                "\n${Companydata['companyProfileAddress3'].toString()??""} "
                "\n${Companydata['companyProfileEmail'].toString()??""} "
                "\n${Companydata['companyProfileGstNo'].toString()??""} ",
              "Details Of Invoice:"
                  "\n Invoice Date: ${Headerpart["voucherDate"].toString()??""}"
                  "\n Invoice No: ${Headerpart["voucherNo"].toString()??""}"
                  "\n Payment type: ${Headerpart["paymentCondition"].toString()??""}"
                  "\n Invoice Amount: ${Total_Invoice.toStringAsFixed(2).toString()??""}",
            ],



            [  "Details of Buyyer(Bill To):"
                "\n${BuyerDetails[0]["lhName"].toString()??""}"
                "\n${BuyerDetails[0]["lhMailingAddress1"].toString()??""} "
                "\n${BuyerDetails[0]["lhMailingAddress2"].toString()??""}"
                "\n${BuyerDetails[0]["lhPincode"].toString()??""}"
                "\n${"Ph: "+BuyerDetails[0]["lhContactNo"].toString()??""}"
                "\n${BuyerDetails[0]["lhEmail"].toString()??""}",

              "Details of Buyyer(Shipped To):"

                  "\n${BuyerDetails[0]["lhName"].toString()??""}"
                  "\n${BuyerDetails[0]["lhMailingAddress1"].toString()??""} "
                  "\n${BuyerDetails[0]["lhMailingAddress2"].toString()??""}"
                  "\n${BuyerDetails[0]["lhPincode"].toString()??""}"
                  "\n${"Ph: "+BuyerDetails[0]["lhContactNo"].toString()??""}"
                  "\n${BuyerDetails[0]["lhEmail"].toString()??""}"
            ],


          ],
          cellHeight: 50,
          columnWidths:{0: pw.FixedColumnWidth(width-50)},
        ),
      ]),
    ]);
  }





  BottomTblPart(width){
    print("the length of the currency");
    var length = "$currencyName  ${Amonut_To_CharConverter.convert(Locale.en_ind, Total_Invoice.floor())} &"
        " ${Amonut_To_CharConverter.convert(Locale.en_ind, Total_Decimal.floor())}"
        "$currencyCoinName only".length;
    print("$currencyName  ${Amonut_To_CharConverter.convert(Locale.en_ind, Total_Invoice.floor())} &"
        " ${Amonut_To_CharConverter.convert(Locale.en_ind, Total_Decimal.floor())}"
        "$currencyCoinName only".length);
    if(length>61){
      return pw.Row(children: [

        pw.SizedBox(
          width: width +10,
          child:
          pw.Column(children: [
            pw.Table.fromTextArray(
              data: [["Tot Qty", "InvoiceTotal", " CGST.Total", "SGST.Total"],
                ["${Tot_Qty.toString()}",
                  "${(Total_InvoiceWithoutTax).toStringAsFixed(2)}",
                  "${(Total_GST / 2).toStringAsFixed(2)}",
                  "${(Total_GST / 2).toStringAsFixed(2)}"]
              ],
              // columnWidths:{0: pw.FixedColumnWidth(width-50)},
            ),

// pw.Expanded(child:
            pw.Table.fromTextArray(
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.center,
              },
              cellHeight: 47,
              data: [["Notes: $Remarks"]],),

// ),

            pw.Table.fromTextArray(
              data: [
                [
                  "$currencyName  ${Amonut_To_CharConverter.convert(
                      Locale.en_ind,
                      Total_Invoice.floor())} & ${Amonut_To_CharConverter
                      .convert(Locale.en_ind,
                      Total_Decimal.floor())}$currencyCoinName only"
                ]
              ],

              // columnWidths:{0: pw.FixedColumnWidth(width-50)},
            ),
          ],),
        ),


        pw.Expanded(
          child: pw.Table.fromTextArray(
              cellAlignments: {
                0: pw.Alignment.topLeft,
                1: pw.Alignment.topRight,
              },
              data: [
                [
                  "Total Invoice",
                  "${(Total_InvoiceWithoutTax).toStringAsFixed(2)}"
                ],
                ["Total GST", "${Total_GST.toStringAsFixed(2)}"],
                ["Freight", ""],
                ["Discount", "${Toatal_DiscountAmt.toStringAsFixed(2)}"],
                ["Net Amount", "${Total_InvoiceWithoutTax.toStringAsFixed(2)}"],
              ]
          ),

        ),
      ]);



    }

    else {

      return pw.Row(children: [

        pw.SizedBox(
          width: width+10,
          child:
          pw.Column(children: [
            pw.Table.fromTextArray(
              data: [["Tot Qty", "InvoiceTotal", " CGST.Total", "SGST.Total"],
                ["${Tot_Qty.toString()}",
                  "${(Total_InvoiceWithoutTax).toStringAsFixed(2)}",
                  "${(Total_GST / 2).toStringAsFixed(2)}",
                  "${(Total_GST / 2).toStringAsFixed(2)}"]
              ],
              // columnWidths:{0: pw.FixedColumnWidth(width-50)},
            ),

// pw.Expanded(child:
            pw.Table.fromTextArray(
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.center,
              },
              cellHeight: 47,
              data: [["Notes: $Remarks"]],),

// ),

            pw.Table.fromTextArray(
              data: [
                [
                  "$currencyName  ${Amonut_To_CharConverter.convert(
                      Locale.en_ind,
                      Net_Toatal.floor())} & ${Amonut_To_CharConverter
                      .convert(Locale.en_ind,
                      Total_Decimal.floor())}$currencyCoinName only"
                ]
              ],

              // columnWidths:{0: pw.FixedColumnWidth(width-50)},
            ),
          ],),
        ),

        pw.Expanded(
          child: pw.Table.fromTextArray(
              cellAlignments: {
                0: pw.Alignment.topLeft,
                1: pw.Alignment.topRight,
              },
              data: [
                [
                  "Total Invoice",
                  "${(Total_InvoiceWithoutTax).toStringAsFixed(2)}"
                ],
                ["Total GST", "${Total_GST.toStringAsFixed(2)}"],
                ["Freight", ""],
                ["Discount", "${Toatal_DiscountAmt.toStringAsFixed(2)}"],
                // ["Net Amount", "${Total_Invoice.toStringAsFixed(2)}"],
                ["Net Amount", "${Net_Toatal.toStringAsFixed(2)}"],
              ]
          ),

        ),
      ]);
    }
  }
  isDataLoaded(){
    if(Headerpart==null||Companydata==null||Qrdata==null||BuyerDetails==null){

      return false;
    }else {
      // print(Headerpart.toString());
      // print(Companydata.toString());
      // print(Qrdata.toString());
      // print(BuyerDetails.toString());
      return true;
    }
  }

  ///---------------------------------------------

  @override
  Widget build(BuildContext context) {
    var ScreenSize=MediaQuery.of(context).size.width;

    return
      SafeArea(
        child: Scaffold(
          appBar: PreferredSize(preferredSize: Size.fromHeight(80),
            child: Appbarcustomwidget(uname: userName, branch:branchName, pref: pref, title:"Print"),),

          body: isDataLoaded()==false?SizedBox(height: ScreenSize,width: ScreenSize,
              child: Center(child: Text("Loading..."))):
          // Headerpart == null ? SizedBox(height: ScreenSize,width: ScreenSize,
          //     child: Center(child: Text("Loading..."))) :
          // Companydata == null ? SizedBox(height: ScreenSize,width: ScreenSize,
          //     child: Center(child: Text("Loading..."))) :


          PdfPreview(
            initialPageFormat:PdfPageFormat.a4 ,
            allowPrinting: true,
            allowSharing: false,
            canChangePageFormat: false,
            useActions: true,
            build: (format) =>_generatePdf(format, ScreenSize,context),
          ),



        ),);
  }




  Future<Uint8List> _generatePdf(PdfPageFormat format,
      ScreenSize,BuildContext context) async {
    final pdf = pw.Document(compress: true);
    final font = await rootBundle.load("assets/arial.ttf");
    final ttf = pw.Font.ttf(font);




    pdf.addPage(
      pw.MultiPage(
        footer:(pw.Context context) {

          return
            pw.Center(child:
            pw.Text('Page ${context.pageNumber} of  ${context.pagesCount}',)
            );
        } ,


        margin:pw.EdgeInsets.only(top: 20,left: 20,bottom: 20,right: 20),
        pageFormat:PdfPageFormat.a4,

        build: (pw.Context context) {
          return <pw.Widget
          >[


            Headerpart == null ? pw.Text('') :
            pw.Center(child:


            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [


                  pw.BarcodeWidget(
                    // data: widget.Parm_Id.toString(),
                      data:Qrdata.toString(),
                      barcode: pw.Barcode.code128(),
                      width: 50,
                      height: 50,
                      drawText: false
                  ),

                  pw.Column(

                      mainAxisAlignment:pw.MainAxisAlignment.center,
                      crossAxisAlignment:pw.CrossAxisAlignment.center,
                      children: [

                        pw.Text("Tax Invoice", textAlign: pw.TextAlign.center,
                            textDirection: pw.TextDirection.rtl,
                            style: pw.TextStyle(
                                fontSize:20,
                                font: ttf,
                                fontWeight: pw.FontWeight.bold
                            )),

                      ]),


                  pw.Text(""),

                ]),
            ),

            pw.SizedBox(
              height: 2,),

            ///---------------------------------------------------------

            TopTblPart(ScreenSize),

            pw.SizedBox(height: 10),


            pw.Partition(
                child:
                pw.Table.fromTextArray(
                    tableWidth:pw.TableWidth.max ,
                    cellAlignment: pw.Alignment.topRight,
                    cellAlignments:{0: pw.Alignment.topLeft,1: pw.Alignment.topLeft,},
                    // columnWidths:TableKeys.length>5? {0:pw.FixedColumnWidth(15)}:{0:pw.FixedColumnWidth(5),},

                    cellStyle: pw.TextStyle(font: ttf,fontSize: Pdf_fontSize),
                    headerStyle: pw.TextStyle(fontWeight:pw.FontWeight.bold,font: ttf,fontSize: 11,),
                    headerAlignment:pw.Alignment.topRight,
                    headerAlignments:{0: pw.Alignment.topLeft,1: pw.Alignment.topLeft},
                    headerDecoration: pw.BoxDecoration(border: pw
                        .Border(bottom: pw.BorderSide(
                        color: PdfColors.black))),
                    cellPadding:pw.EdgeInsets.all(1),
                    headers:TblHeader,//TblHeader,
                    data:TableGenerator()
                  // data: [Detailspart]
                )
            ),

            pw.SizedBox( height: 10),

            BottomTblPart(ScreenSize),

            pw.SizedBox( height: 10,),

            pw.Container(
              decoration: pw.BoxDecoration(

                // color: pw.Colors.white,
                  border: pw.Border.all( )),

              child:pw.Column(children: [
                pw.SizedBox(height: 8),
                pw.Row(children: [
                  pw.Text("      Prepared by :  ${userName}\t") ,
                  pw.SizedBox(height: 10),
                  pw.Text("                                                 For ${Companydata['companyProfileName']}")
                ],),
                pw.Row(children: [
                  pw.Text("      Printed on    : ${ DateFormat("dd:MM:yyyy h:mm:a").format(DateTime.now())}") ,

                ],),
                pw.SizedBox(height: 8),
              ]),

            )

          ];
        },
      ),
    );

    return pdf.save();
  }




  var TblHeader= [
    'Sl',
    'Item' ,
    'HSN' ,
    'Rate',
    'Qty',
    "Disc" ,
    "Net Value ",
    "GST %",
    " GST AMT",
    "G. Total",
  ];


  TableGenerator() {
    var purchasesAsMap;
    // print(Detailspart["salesDetails"]);
    // print(Detailspart["salesDetails"][0]["rate"]);
    purchasesAsMap = <Map<String, String>>[
      for (int i = 0; i < Detailspart["salesDetails"].length; i++) {

        "sl": "${"${i+1}"}",
        "ItemName": "${Detailspart["salesDetails"][i]['itmName']??""}",
        "hsncode": "${Detailspart["salesDetails"][i]['hsncode']??""}",
        "Rate": "${Detailspart["salesDetails"][i]['rate'].toStringAsFixed(2)} ",
        "Qty": "${Detailspart["salesDetails"][i]['qty']} ",
        "discount": "${(Detailspart["salesDetails"][i]['discountAmount']??0.00).toStringAsFixed(2)}",
        "total": "${((Detailspart["salesDetails"][i]['qty']??0.0)*(((Detailspart["salesDetails"][i]['rate']??0.0))-Detailspart["salesDetails"][i]['discountAmount']??0.00)).toStringAsFixed(2)} ",
        "TaxPer": "${Detailspart["salesDetails"][i]['taxPercentage']==null?"0.00":Detailspart["salesDetails"][i]['taxPercentage'].toStringAsFixed(2)} ",
        "TaxAmt": "${Detailspart["salesDetails"][i]['taxAmount'].toStringAsFixed(2)=="0.00"?"":Detailspart["salesDetails"][i]['taxAmount'].toStringAsFixed(2)} ",
        "NetAmt": "${Detailspart["salesDetails"][i]['amountIncludingTax'].toStringAsFixed(2)} ",
      }
    ];
    List<List<String>> listOfPurchases =[];
    for (int i = 0; i < purchasesAsMap.length; i++) {
      listOfPurchases.add(purchasesAsMap[i].values.toList());
    }
    return listOfPurchases;
    // print(purchasesAsMap);
    // return purchasesAsMap;
  }





  var Total_InvoiceWithoutTax=0.0;
  var Net_Toatal =0.0;
  var Total_Invoice=0.0;
  int Total_Decimal=0;
  var Remarks = " ";
  var Tot_Qty=0.0;
  var Total_GST=0.0;
  var Toatal_DiscountAmt=0.0;
  GetToatlAmts(){

    var TotalAmtBfrTax=0.0;
    var G_Total=0.0;

    for (int i = 0; i < Detailspart["salesDetails"].length; i++) {

      TotalAmtBfrTax=TotalAmtBfrTax+Detailspart["salesDetails"][i]['amountBeforeTax']??0.0;
      G_Total=G_Total+Detailspart["salesDetails"][i]['amountIncludingTax']??0.0;
      Tot_Qty=Tot_Qty+Detailspart["salesDetails"][i]['qty']??0.0;

    }
    setState(() {

      Total_GST=G_Total-TotalAmtBfrTax;
      Total_InvoiceWithoutTax=Headerpart["amount"]??0.0;
      Total_Invoice=Headerpart["balanceAmount"]??0.0;
      Toatal_DiscountAmt=Headerpart['discountAmt']??0.0;
      Remarks=Headerpart['narration']??" ";
      Net_Toatal= Total_InvoiceWithoutTax + Toatal_DiscountAmt;

      print("the totadfgl value is " + Net_Toatal.toString() + " remarks " + Remarks.toString() + " Total Invoice " + Total_Invoice.toString() );
      print("the totgdfal value is dfdf" + Total_InvoiceWithoutTax.toString() + " remarks " + Toatal_DiscountAmt.toString() + " Total Invoice " + Total_GST.toString() );
      var Temproryvar = Net_Toatal * 100;
      Total_Decimal = Temproryvar.toInt() - Net_Toatal.toInt()*100;
    });
  }
}





