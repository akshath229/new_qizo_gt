import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'dart:io';
import 'package:image/image.dart';

import '../../GT_Masters/Printing/CurrencyWordConverter.dart';
import '../../GT_Masters/Printing/PDF_2Inch_Print.dart';
import '../../appbarWidget.dart';
import '../../models/userdata.dart';
import '../../urlEnvironment/urlEnvironment.dart';

class Rms_TestSimpPrint extends StatefulWidget {
  var Parm_Id;

  Rms_TestSimpPrint({this.Parm_Id,});

  @override
  _Rms_TestSimpPrintState createState() => _Rms_TestSimpPrintState();
}

class _Rms_TestSimpPrintState extends State<Rms_TestSimpPrint> {

  Pdf_Two_Inch Pdf_2 = Pdf_Two_Inch();

  late SharedPreferences pref;
  dynamic branch;
  var res;
  dynamic user;
  late int branchId;
  late int userId;
  late UserData userData;
  String branchName = "";
  dynamic userName;
  late String token;

  // var DateTimeFormat = new DateFormat('dd-MM-yyyy hh a');
  var DateTimeFormat = new DateFormat('dd-MM-yyyy');
  String Datetime_Now = DateFormat("yyyy-MM-dd hh:mm:ss").format(
      DateTime.now());
  var Detailspart;
  var dataForTicket;
  var footerCaptions;
  var Companydata;
  bool IsArabic = false;

  // bool PgA4=true;
  bool Pg_2_Inch = false;
  String IsArabicChkBoxText = "Arabic";
  var TaxType;
  var CountryName;
  var currencyName;

  // double Pdf_Width=800.0;
  NumberToWord arabicAmount = NumberToWord();


  void initState() {
    setState(() {
      SharedPreferences.getInstance().then((value) {
        pref = value;
        read();
        GetdataPrint(widget.Parm_Id);
        // footerdata();
        GetQrdata();
        GeneralSettings();
        //widget.Page_Type==true? PgA4=true:PgA4=false;
        dropdownValue="Invoice";
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
      CountryName = user.user["countryName"];
      currencyName = user.user["currencyName"];
    });
    var CD = await GetCompantPro(branchId);
  }


  GeneralSettings() async {
    final res =
    await http.get("${Env.baseUrl}generalSettings" as Uri, headers: {
      "Authorization": user.user["token"],
    });

    if (res.statusCode < 210) {
      print(res);
      var GenSettingsData = json.decode(res.body);
      print(GenSettingsData[0]["applicationTaxTypeGst"]);
      setState(() {
        GenSettingsData[0]["applicationTaxTypeGst"] == true ?
        TaxType = "Gst.No" : TaxType = "Vat.No";
        print("TaxType");
        print(TaxType);
      });
    }
  }


  // footerdata() async {
  //   try {
  //     print("footer data decoded  ");
  //     final tagsJson =
  //     await http.get("${Env.baseUrl}SalesInvoiceFooters/", headers: {
  //       "Authorization": user.user["token"],
  //     });
  //     var footerdata =await jsonDecode(tagsJson.body);
  //     setState(() {
  //       footerCaptions = footerdata;
  //       // print( "on footerCaptions :" +footerCaptions.toString());
  //     });
  //
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  var Qrdata;
  GetQrdata() async {
    try {
      print("QR datas");
      final tagsJson =
      await http.get("${Env.baseUrl}SalesHeaders/${widget.Parm_Id}/qrcode" as Uri, headers: {
        "Authorization": user.user["token"],
      });
      var Qr_data =await jsonDecode(tagsJson.body);
      setState(() {
        Qrdata = Qr_data[0]["qrString"];
        print( "QR datas :" +Qrdata.toString());
      });

    } catch (e) {
      print(e);
    }
  }




  GetCompantPro(id) async {
    print("GetCompantPro");
    print(id.toString());
    try {
      final tagsJson =
      await http.get("${Env.baseUrl}MCompanyProfiles/$id" as Uri, headers: {
        //Soheader //SalesHeaders
        "Authorization": user.user["token"],
      });
      if (tagsJson.statusCode == 200) {
        Companydata = await jsonDecode(tagsJson.body);
      }
      print("on GetCompantPro :" + Companydata.toString());
      print(Companydata['companyProfileAddress1'].toString());
    }
    catch (e) {
      print("error on GetCompantPro : $e");
    }
  }


  var VchDate;
  var InvTime;
  var TotalTax = 0.0;
  var AmountBeforeTax = 0.0;
  var TotalQty = 0.0;

  GetdataPrint(id) async {
    AmountBeforeTax=0.0;
    print("sales for print : $id");
    double amount = 0.0;
    try {
      final tagsJson =
      await http.get("${Env.baseUrl}SalesHeaders/1" as Uri, headers: {
        //Soheader //SalesHeaders
        "Authorization": user.user["token"],
      });


      dataForTicket = await jsonDecode(tagsJson.body);

      // var ParseDate=dataForTicket['salesHeader'][0]["voucherDate"]??"2022-01-01T00:00:00";
      var ParseDate = dataForTicket['salesHeader'][0]["entryDate"] ??
          "2022-01-01T00:00:00";
      // DateTime tempDate = new DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(ParseDate);
      DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(ParseDate);
      print(dataForTicket['salesHeader'][0]["voucherDate"]);
      VchDate = DateTimeFormat.format(tempDate);
      print(VchDate.toString());
      print(dataForTicket.toString());


      var tempTime = dataForTicket['salesHeader'][0]["entryDate"] ??
          "2022-01-01T00:00:00";
      DateTime tempTimeFormate = new DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(
          tempTime);
      InvTime = DateFormat.jm().format(tempTimeFormate);
      // print("tempTime");
      // print(tempTime);
      // print("tempTimeFormate");
      // print(tempTimeFormate);
      // print("InvTime");
      // print(InvTime);

      //GetBuyerDetails(dataForTicket['salesHeader'][0]["ledgerId"]);
      Detailspart = dataForTicket['salesDetails'];
      var Pattern = Detailspart[0]['itmName'];


      print(Detailspart[0]['rate'].runtimeType);
      print(Detailspart[0]['taxPercentage'].runtimeType);
      for (int i = 0; i < Detailspart.length; i++) {
        double qty = Detailspart[i]['qty'] == null
            ? 0.0
            : (Detailspart[i]['qty']);
        double rate = Detailspart[i]['rate'] == null
            ? 0.0
            : (Detailspart[i]['rate']);
        double varTxPer = Detailspart[i]['taxPercentage'] == null
            ? 0.0
            : (Detailspart[i]['taxPercentage']);
        double itemTaxrate = Detailspart[i]['taxAmount'] ?? 0.0;
        //  double itemTaxrate=await CalculateTaxAmt(rate,qty,varTxPer);
        TotalTax = TotalTax + itemTaxrate;
        TotalQty = TotalQty + qty;
        AmountBeforeTax = AmountBeforeTax + Detailspart[i]['amountBeforeTax'];
      }
      print("TotalTax");
      print(TotalTax.toString());
      ///-------------------------sort printer -------------------------
var Kitchen_Items=[];
var Counter_Items=[];
      for (int i = 0; i < Detailspart.length; i++) {

        if ( Detailspart[i]['igKotPrinter'].toString().contains("Kitchen")) {
             print("Kitchen Item");
          Kitchen_Items.add(Detailspart[i]);
        }else{
          print("Kitchen Item");
          Counter_Items.add(Detailspart[i]);
        }

      }

      print("Kitchen Item Final-----${Kitchen_Items.length.toString()}---");
      print(Kitchen_Items);
      print("Counter Item Final--------------${Counter_Items.length.toString()}-----------");
      print(Counter_Items);

      // if (Pattern.contains(RegExp(r'[a-zA-Z]'))) {
      //   print("rtertre");
      //
      // }else{
      //   print("Nope, Other characters detected");
      //   IsArabic=true;
      // }

      GetArabicAmount(dataForTicket['salesHeader'][0]["amount"]);

      setState(() {
        IsArabic = true;
      });
    } catch (e) {
      print('error on databinding $e');
    }
  }

  //String dropdownValue = '3 Inch';
  String dropdownValue = 'Tax Invoice';


  var AmtInWrds = "";

  GetArabicAmount(Amount) {
    //  AmtInWrds= arabicAmount.NumberInRiyals(Amount);

  }


  //
  // CalculateTaxAmt(double rate,double qty,double taxper){
  //
  //   double  _rate=rate??0.0;
  //   double  _qty=qty??0.0;
  //   double  _taxper=taxper??0.0;
  //
  //
  //   double Tax=((_rate/100)*_taxper);
  //   double  TotTax=(Tax*_qty);
  //   return TotTax;
  // }
  ///---------------------------------------------

  @override
  Widget build(BuildContext context) {
    var ScreenSize = MediaQuery
        .of(context)
        .size
        .width;
    var ScreenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return
      SafeArea(
        child: Scaffold(
          appBar: PreferredSize(preferredSize: Size.fromHeight(80),
            child: Appbarcustomwidget(uname: userName,
                branch: branchName,
                pref: pref,
                title: "Print"),),

          body:
          // dataForTicket == null ? SizedBox(height: ScreenHeight,width: ScreenSize,
          //     child: Center(child: Text("Loading..."))) :
          // Companydata == null ? SizedBox(height: ScreenSize,width: ScreenSize,
          //     child: Center(child: Text("Loading..."))) :
          // BuyerDetails.isEmpty ? SizedBox(height: ScreenSize,width: ScreenSize,
          //     child: Center(child: Text("Loading..."))) :

          PdfPreview(
            initialPageFormat: PdfPageFormat.a4,
            allowPrinting: true,
            allowSharing: false,
            canChangePageFormat: false,
            useActions: true,
            build: (format) => _generatePdf(),
          ),

          floatingActionButton:
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          Container(
            //color: Colors.red,
            height: 30,
            //width: 100,
            child: DropdownButton(

              underline: Container(color: Colors.transparent),
              icon: Text(
                "$dropdownValue  ▼", style: TextStyle(color: Colors.white),),

              items: [
                DropdownMenuItem<String>(
                    value: "path",
                    child: InkWell(
                        onTap: () {
                          // SetToImmg();
                          // Getpath();
                          GetImageFromDevice();
                        },
                        child: Text(
                          "path", style: TextStyle(fontSize: 13),))),

                DropdownMenuItem<String>(
                  value: "print",
                  child: InkWell(
                    onTap: () {
                      wifiprinting();
                    },
                    child: Text(
                      "print", style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
                DropdownMenuItem<String>(
                  value: "Simplified",
                  child: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(builder: (context,
                                setState) {
                              return AlertDialog(
                                content: Container(
                                  height: 100,
                                  width: 100,
                                  // child: Text(FinalImage.absolute.toString()),
                                  //  decoration:  BoxDecoration(
                                  //          borderRadius: BorderRadius.circular(40.0),
                                  //        image: DecorationImage(
                                  //            image:FileImage(''),
                                  //            fit: BoxFit.fill)),
                                  //    margin: new EdgeInsets.only(
                                  //    left: 0.0, top: 5.0, right: 0.0, bottom: 0.0),
                                  //   Text(FinalImage.toString()),
                                ),
                              );
                            });
                          });
                    },
                    child: Text(
                      "popup", style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),

                DropdownMenuItem<String>(
                  value: "A4",
                  child: Text(
                    "A4", style: TextStyle(fontSize: 13),
                  ),
                ),
                DropdownMenuItem<String>(
                  value: "3 Inch",
                  child: Text(
                    "3 Inch", style: TextStyle(fontSize: 13),
                  ),
                ),
                DropdownMenuItem<String>(
                  value: "2 Inch",
                  child: Text(
                    "2 Inch", style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                  //    Pagetype(dropdownValue);
                  if (dropdownValue == "2 Inch") {
                    Pg_2_Inch = true;
                  }
                });
              },

            ),
          ),


          // ] ),
        ),);
  }


  Future<Uint8List> _generatePdf() async {
    final pdf = pw.Document(compress: true);
    final font = await rootBundle.load("assets/arial.ttf");
    final ttf = pw.Font.ttf(font);
    final Pdf_fontSize = 9.0;
    final Pdf_Width = 570.0;
    pdf.addPage(
      pw.Page(
        margin: pw.EdgeInsets.only(top: 1, left: 1, bottom: 1, right: 1),
        pageFormat: PdfPageFormat.roll80,
        build: (context) {
          return dataForTicket == null ? pw.Text('Loading...') : pw.ListView(
            children: [



              pw.Text(Companydata['companyProfileName']??"", textAlign: pw.TextAlign.center,
                  textDirection: pw.TextDirection.rtl,
                  style: pw.TextStyle(
                      fontSize: Pdf_fontSize,
                      font: ttf,
                      fontWeight: pw.FontWeight.bold
                  )),

              pw.Text(Companydata['companyProfileNameLatin']??"", textAlign: pw.TextAlign.center,
                  textDirection: pw.TextDirection.rtl,
                  style: pw.TextStyle(
                      fontSize: Pdf_fontSize,
                      font: ttf,
                      fontWeight: pw.FontWeight.bold
                  )),

              pw.Text(Companydata['companyProfileAddress1']??"", textAlign: pw.TextAlign.center,
                  textDirection: pw.TextDirection.rtl,
                  style: pw.TextStyle(
                      fontSize: Pdf_fontSize,
                      font: ttf)),

              pw.Text(Companydata['companyProfileAddress2']??"", textAlign: pw.TextAlign.center,
                  textDirection: pw.TextDirection.rtl,
                  style: pw.TextStyle(
                      fontSize: Pdf_fontSize,
                      font: ttf)),

              pw.Text(Companydata['companyProfileAddress3']??"", textAlign: pw.TextAlign.center,
                  textDirection: pw.TextDirection.rtl,
                  style: pw.TextStyle(
                      fontSize: Pdf_fontSize,
                      font: ttf)),


              pw.Text(Companydata['companyProfileEmail']??"", textAlign: pw.TextAlign.center,
                  textDirection: pw.TextDirection.rtl,
                  style: pw.TextStyle(
                      fontSize: Pdf_fontSize,
                      font: ttf
                  )),
              pw.SizedBox(height: 5),


              pw.Text('فاتورة ضريبية مبسطة', textAlign: pw.TextAlign.center,
                  textDirection: pw.TextDirection.rtl,
                  style: pw.TextStyle(
                      font: ttf, fontSize: 10)),
              pw.SizedBox(height: 3),

              pw.Text('Simplified Tax Invoice', textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(fontSize: 10,
                      decoration: pw.TextDecoration.underline)),
              pw.SizedBox(height: 10),



              // pw.Column(
              //   // crossAxisAlignment:  pw.CrossAxisAlignment.start,
              //   // mainAxisAlignment:  pw.MainAxisAlignment.start,
              //     children: [
              //
              //
              //       pw.Row(
              //           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              //           children: [
              //             pw.Text('Invoice No              : ' +
              //                 dataForTicket['salesHeader'][0]["voucherNo"]
              //                     .toString(),
              //                 style: pw.TextStyle(fontSize: Pdf_fontSize)),
              //
              //
              //
              //             pw.Text(
              //                 " رق ${dataForTicket['salesHeader'][0]["voucherNo"]
              //                     .toString()} :             ",
              //                 textDirection: pw.TextDirection.rtl,
              //                 style: pw.TextStyle(
              //                     font: ttf, fontSize: Pdf_fontSize)),
              //
              //           ]),
              //
              //
              //       pw.SizedBox(height: 2),
              //
              //
              //       pw.Row(
              //           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              //           children: [
              //             pw.Text(
              //                 'Invoice Issue Date : ' + "VchDate".toString(),
              //                 style: pw.TextStyle(fontSize: Pdf_fontSize)),
              //
              //             pw.Text("  إصدار ${"VchDate".toString()} :  ",
              //                 textDirection: pw.TextDirection.rtl,
              //                 style: pw.TextStyle(
              //                     font: ttf, fontSize: Pdf_fontSize)),
              //
              //           ]),
              //
              //
              //       pw.SizedBox(height: 2),
              //
              //       pw.Row(
              //           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              //           children: [
              //             pw.Expanded(child: pw.Text(
              //                 'VAT Number : ${Companydata['companyProfileGstNo'] ??
              //                     ""}', style: pw.TextStyle(
              //                 fontSize: Pdf_fontSize)),),
              //
              //             pw.Text(
              //                 "ظريبه الشراء:  ${Companydata['companyProfileGstNo'] ??
              //                     ""} ",
              //                 textDirection: pw.TextDirection.rtl,
              //                 style: pw.TextStyle(
              //                     font: ttf, fontSize: Pdf_fontSize)),
              //
              //           ]),
              //
              //
              //
              //
              //     ]),




              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text('Invoice No /  ', style: pw.TextStyle(
                        font: ttf, fontSize: 10)),
                    pw.Text('تاريخ إصدار الفاتورة',textDirection: pw.TextDirection.rtl,
                        style: pw.TextStyle(
                            font: ttf, fontSize: 10)),

                    pw.Text('   : ${dataForTicket['salesHeader'][0]["voucherNo"].toString()}',
                        style: pw.TextStyle(fontSize: 10))

                  ]),



              pw.SizedBox(height: 2),



              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text('Invoice Issue Date /  ', style: pw.TextStyle(
                        font: ttf, fontSize: 10,fontWeight:pw.FontWeight.bold)),
                    pw.Text('رقم الفاتورة',textDirection: pw.TextDirection.rtl,
                        style: pw.TextStyle(
                            font: ttf, fontSize: 10)),

                    pw.Text(' : ${VchDate.toString()}',
                        style: pw.TextStyle(fontSize: 10))

                  ]),



              pw.SizedBox(height: 2),



              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text('VAT Number /  ', style: pw.TextStyle(
                        font: ttf, fontSize: 10)),
                    pw.Text('ظريبه الشراء',textDirection: pw.TextDirection.rtl,
                        style: pw.TextStyle(
                            font: ttf, fontSize: 10)),

                    pw.Text('        : ${Companydata['companyProfileGstNo'].toString()}',
                        style: pw.TextStyle(fontSize: 10))

                  ]),


              pw.SizedBox(height: 5),


              ///----------------------------------item Table-------------------------------


              pw.Container(
                //   width: ScreenSize+(ScreenSize/8),
                //color:  PdfColors.red,
                  child: pw.Directionality(
                      textDirection: pw.TextDirection.rtl,
                      child:
                      pw.Table.fromTextArray(
                          tableWidth: pw.TableWidth.max,
                          cellAlignment: pw.Alignment.topRight,
                          cellAlignments: {2: pw.Alignment.topLeft,},
                          columnWidths: {
                            0: pw.FixedColumnWidth(60),
                            3: pw.FixedColumnWidth(60),
                          },

                          cellStyle: pw.TextStyle(font: ttf, fontSize: Pdf_fontSize),
                          headerStyle: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            font: ttf,
                            fontSize: Pdf_fontSize,),
                          headerAlignment: pw.Alignment.center,
                          //headerAlignments:{0: pw.Alignment.center},
                          headerDecoration: pw.BoxDecoration(border: pw
                              .Border(bottom: pw.BorderSide(
                              color: PdfColors.black))),

                          cellPadding: pw.EdgeInsets.all(1),

                          headers: TblHeader,
                          data: TableGenerator()
                      )
                  )
              ),


// pw.Table(
//   children: [
//     pw.TableRow(
//       children: [
//
//         pw.Column(
//           children: [
//             pw.Text("Nature of goods or services",style: pw.TextStyle(fontSize:7)),
//             pw.Text("تفاصیل السلع أو الخدما",style: pw.TextStyle(font: ttf,fontSize:7), ),
//           ]
//         ),
//
//
//         pw.Column(
//             children: [
//               pw.Text("Unit Price",style: pw.TextStyle(fontSize:7)),
//               pw.Text("سعر الوحدة",style: pw.TextStyle(font: ttf,fontSize:7), ),
//             ]
//         ),
//
//
//         pw.Column(
//             children: [
//               pw.Text("Quantity",style: pw.TextStyle(fontSize:7)),
//               pw.Text("كمية",style: pw.TextStyle(font: ttf,fontSize:7), ),
//             ]
//         ),
//
//         pw.Column(
//             children: [
//               pw.Text("Item Subtotal (Including VAT)",style: pw.TextStyle(fontSize:7)),
//               pw.Text("المجموع (شامل ضریبة القیمة المضافة)",style: pw.TextStyle(font: ttf,fontSize:7), ),
//             ]
//         ),
//
//       ]
//     ),
//
//             pw.TableRow(children: [
//
//             ] ),
//   ]
// ),


//
//               pw.SizedBox(height:5),
//
//
// //               ///---------------------------------3 inc -----------------------------------------------
// //
//               pw.Directionality(
//                 textDirection:IsArabic==true? pw.TextDirection.rtl: pw.TextDirection.ltr,
//                 child:
//                 pw.Table.fromTextArray(
//                     headerAlignments: {0: pw.Alignment.topRight,1:pw.Alignment.topRight,2:pw.Alignment.centerRight},
//                     cellAlignments:{0: pw.Alignment.topRight,1:pw.Alignment.topLeft,2:pw.Alignment.centerRight},
//
//                     headerStyle: pw.TextStyle (font: ttf, fontSize: 10,),
//                     cellStyle: pw.TextStyle (font: ttf, fontSize: 10,),
//                     columnWidths:{2: pw.FixedColumnWidth(100),0: pw.FixedColumnWidth(150)},
//
// border:pw.TableBorder(left: pw.BorderSide.none,
//  bottom: pw.BorderSide(color: PdfColors.black),
// top: pw.BorderSide(color: PdfColors.black),),
//                     headers:
//                     [
//                       //"Total Taxable\tAmount\t(ExcludingVAT)",
//                       "  (ExcludingVat)   Amount          \n Total  Taxable",
//                       "إجمالي المبلغ الخاضع للضريبة (باستثناء ضريبة القيمة المضافة(",
//                       "${AmountBeforeTax.toStringAsFixed(2)}",
//                     ],
//
//                     data: [
//                       [
//                         "Total VAT      ",
//                         "إجمالي ضريبة القيمة المضافة",
//                         "${TotalTax==null?0.toStringAsFixed(2):
//                         TotalTax.toStringAsFixed(2)}",
//                       ],
//
//
//                       [
//                         "Due Total Amount",
//                         "إجمالي المبلغ المستحق         ",
//                         "${dataForTicket['salesHeader'][0]["amount"]==null?0.toStringAsFixed(2):
//                         dataForTicket['salesHeader'][0]["amount"].toStringAsFixed(2)}",
//                       ],
//
//
//                     ]
//                 ),
//               ),









              pw.SizedBox(height: 5),

              pw.Column(
                  children: [
                    pw.Row(
                        mainAxisAlignment:pw.MainAxisAlignment.start,
                        // crossAxisAlignment:pw.CrossAxisAlignment.end,
                        children:[

                          pw.Expanded(child:pw.Text("Total Taxable Amount (Excluding VAT)",style: pw.TextStyle(fontSize: Pdf_fontSize,))),
                          //pw. Spacer(),
                          pw.SizedBox(width: 10),
                          pw.Expanded(child:pw.Text("الإجمالي الخاضع للضریبة )غیر شامل ضریبة القیمة المضافة(",style: pw.TextStyle(fontSize: Pdf_fontSize,font: ttf,color: PdfColors.black),
                            textDirection: pw.TextDirection.rtl,)),

                          pw. Spacer(),

                          pw.Text("${AmountBeforeTax.toStringAsFixed(2)} ${currencyName??""}",style: pw.TextStyle(fontSize: Pdf_fontSize,)),
                        ]),



                    pw.SizedBox(height:5),

                    pw.Row(
                        mainAxisAlignment:pw.MainAxisAlignment.spaceBetween,
                        children:[

                          pw.Expanded(child:pw.Text("Total VAT",style: pw.TextStyle(fontSize: Pdf_fontSize,))),
                          // pw. Spacer(),
                          pw.SizedBox(width: 10),
                          pw.Expanded(child:pw.Text(" ضريبة القيمة المضافة",style: pw.TextStyle(fontSize: Pdf_fontSize,font: ttf,color: PdfColors.black),
                            textDirection: pw.TextDirection.rtl,)),

                          pw. Spacer(),

                          pw.Text("  ${TotalTax==null?0.toStringAsFixed(2):
                          TotalTax.toStringAsFixed(2)} ${currencyName??""}",style: pw.TextStyle(fontSize: Pdf_fontSize,)),
                        ]),





                    pw.SizedBox(height:5),





                    pw.Row(
                        mainAxisAlignment:pw.MainAxisAlignment.spaceAround,
                        children:[

                          pw.Expanded(child:pw.Text("Total Amount Due",style: pw.TextStyle(fontSize: Pdf_fontSize,))),
                          // pw. Spacer(),
                          pw.SizedBox(width: 10),
                          pw.Expanded(child:pw.Text("إجمالي المبلغ المستحق",style: pw.TextStyle(fontSize: Pdf_fontSize,font: ttf,color: PdfColors.black),
                            textDirection: pw.TextDirection.rtl,)),

                          pw. Spacer(),
                          // pw.Text("${dataForTicket["amount"].toStringAsFixed(2)} ${currencyName??""}",style: pw.TextStyle(fontSize: Pdf_fontSize,)), ]),
                          pw.Text("${(TotalTax+AmountBeforeTax).toStringAsFixed(2)} ${currencyName??""}",style: pw.TextStyle(fontSize: Pdf_fontSize,)), ]),
                  ]),
































//
//
// pw.Table(
//   children: [
//     pw.TableRow(
//       children: [
//
//         pw.Column(
//           crossAxisAlignment:pw.CrossAxisAlignment.start,
//           children: [
//             pw.Text("Total Taxable Amount (ExcludingVAT)",style: pw.TextStyle(fontSize:7)),
//             pw.Text("Total VAT",style: pw.TextStyle(fontSize:7)),
//             pw.Text("Total Amount Due",style: pw.TextStyle(fontSize:7)),
//           ]
//         ),
//
//
//         pw.Column(
//              crossAxisAlignment:pw.CrossAxisAlignment.end,
//             children: [
//               pw.Text("إجمالي المبلغ الخاضع للضريبة (باستثناء ضريبة القيمة المضافة)",
//                 style: pw.TextStyle(font: ttf,fontSize:7),textDirection:pw.TextDirection.rtl),
//
//               pw.Text("إجمالي ضريبة القيمة المضافة",
//                 style: pw.TextStyle(font: ttf,fontSize:7),textDirection:pw.TextDirection.rtl),
//
//               pw.Text("إجمالي المبلغ المستحق",
//                 style: pw.TextStyle(font: ttf,fontSize:7),textDirection:pw.TextDirection.rtl ),
//             ]
//         ),
//
//
//         pw.SizedBox(width: 30),
//
//         pw.Column(
//             // crossAxisAlignment:pw.CrossAxisAlignment.start,
//             // mainAxisAlignment: pw.MainAxisAlignment.start,
//             children: [
//               pw.Text("${AmountBeforeTax.toStringAsFixed(2)}",
//                 style: pw.TextStyle(fontSize:7),textAlign: pw.TextAlign.right ),
//
//
//               pw.Text("${TotalTax==null?0.toStringAsFixed(2):
//                TotalTax.toStringAsFixed(2)}",style: pw.TextStyle(fontSize:7),textAlign: pw.TextAlign.right),
//
//
//               pw.Text("${dataForTicket['salesHeader'][0]["amount"]==null?0.toStringAsFixed(2):
//                          dataForTicket['salesHeader'][0]["amount"].toStringAsFixed(2)}",
//                 style: pw.TextStyle(fontSize:7),textAlign: pw.TextAlign.right),
//             ]
//         ),
//
//             ])
//             ]),




              pw.Divider(thickness: 1),

              pw.SizedBox( height: 2,),

              pw.Padding(padding:pw.EdgeInsets.only(bottom: 5),
                  child: pw.BarcodeWidget(
                    // data: widget.Parm_Id.toString(),
                      data: Qrdata.toString(),
                      barcode: pw.Barcode.qrCode(),
                      width: 50,
                      height: 50
                  )),

//

            ],


          );
        },
      ),
    );


    return pdf.save();
  }

  pw.Container Seller_Buyer_Table({
    required double Pdf_fontSize,
    required pw.Font ttf,
    required String Arabic_Label,
    required String Label,
    dynamic dataValue
  }) {
    return pw.Container(
        decoration: pw.BoxDecoration(border: pw.Border.all(
            color: PdfColors.black)),
        child: pw.Padding(padding: pw.EdgeInsets.all(3),
          child:
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Text(
                    '$Label : ', style: pw.TextStyle(fontSize: Pdf_fontSize)),


                pw.Text(" : $Arabic_Label${dataValue.toString()}",
                    textDirection: pw.TextDirection.rtl,
                    style: pw.TextStyle(font: ttf, fontSize: Pdf_fontSize)),

              ]),)
    );
  }


  var TblHeader;

  TableGenerator() {
    TblHeader = [
      // 'or services  or goods of Nature',
      //
      // //  ' of goods or services  تفاصیل السلع أو الخدمات',
      //  'or\tgoods\tof\tNature\tservices\n'+' طبيعة السلع  أو الخدمات',
      'services         \n goods or       .    \tNature of       \n'+' طبيعة السلع  أو الخدمات',
      'Price\tUnit\n سعر الوحدة',
      'Quantity\n كمية',
      '(Including Vat) Item Subtotal  المجموع )شامل ضریبة القیمة المضافة('
    ];


    var purchasesAsMap;


    var Slnum = 0;

    purchasesAsMap = <Map<String, String>>[
      for(int i = 0; i < Detailspart.length; i++)
        {
          "ItemName": "${Detailspart[i]['itmName']??
              ""}  ${Detailspart[i]['itmArabicName'] ?? ""}",
          "Rate": "${Detailspart[i]['rate'].toStringAsFixed(2)} ",
          "Qty": "(${Detailspart[i]['uom']})         ${Detailspart[i]['qty']} ",
          "NetAmt": "${Detailspart[i]['amountIncludingTax'].toStringAsFixed(2)} ",
        },
    ];


    List<List<String>> listOfPurchases = [];
    for (int i = 0; i < purchasesAsMap.length; i++) {
      listOfPurchases.add(purchasesAsMap[i].values.toList());
    }
    return listOfPurchases;
  }


  // ['Amount المجموع', 'TaxAmt\n مبلغ الضريبة', 'Tax% الضريبة٪', 'Qty\n كمية', 'Price معدل', 'name\tItem\n التفاصيل']

  Future<Uint8List?> SetToImmg() async {
    try {
      await for (var page in Printing.raster(
          await _generatePdf(), pages: [0], dpi: 180)) {
        final image = await page.toPng();
        print('Image length: ${image.length}');
        print('Image runtime type: ${image.runtimeType}');
        return image;
      }
    } catch (e) {
      print('Error while converting PDF to Image: $e');
      return null;
    }
  }



  Future<File> FinalImage;

  wifiprinting() async {
    print(" print in");
    // _printerManager.selectPrinter('null');
    _printerManager.selectPrinter('192.168.0.100');




    // final ByteData data = await rootBundle.load(
    //     '/storage/emulated/0/Android/data/com.example.ErpAapp/files/exampleNew.jpg');
    //final Uint8List bytes =await GetImageFromDevice();
    final Uint8List bytes =await SetToImmg();
    final image = decodeImage(bytes);
    // FinalImage=  File.fromRawPath(bytes);



    print("image.runtimeType");
    print(image.runtimeType);
    File(
        '/storage/emulated/0/Android/data/com.example.ErpAapp/files/exampleNew.jpg')
        .writeAsBytes(bytes);
    final res =
    await _printerManager.printTicket(await _ticket(PaperSize.mm80, image));
    print(" print in");
    // } catch (e) {
    print("FinalImage $FinalImage");
    // }
    setState(() {
      //FinalImage=image;
    });
  }

  PrinterNetworkManager _printerManager = PrinterNetworkManager();

  Future<Ticket> _ticket(PaperSize paper, image) async {
    print('in print Ticket');
    final ticket = Ticket(paper);


    ticket.image(image);
    // ticket.imageRaster(image);

    print("Finish");
    ticket.cut();
    return ticket;
  }


  var path;

  Getpath() async {
    final Directory? directory = await getExternalStorageDirectory();
    //final output = await getTemporaryDirectory();
    print("directory.path");
    print((directory?.path).toString());
    var targetPath = directory?.path;
    setState(() {
      path = (directory!.path + "/exampleNew.jpg")!;
    });
    print(path);
    //final file = File("$targetPath/exampleNew.pdf");
    // await file.writeAsBytes(await pdf.save());
  }


  GetImageFromDevice() async {
    dynamic _image;
    ImagePicker picker = ImagePicker();

    print("on getImage");
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = pickedFile.readAsBytes();
        print("image selected $_image");
      } else {
        print('No image selected.');
      }
    });

    return _image;
  }









}
