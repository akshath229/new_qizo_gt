import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:image/image.dart';

import '../../models/userdata.dart';
import '../../urlEnvironment/urlEnvironment.dart';



class Rms_SimPrint{
  PrinterNetworkManager _printerManager = PrinterNetworkManager();
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


  var KotPrint;
  var Counter_Print;

  var TblHeader = [
    'services         \n goods or       .    \tNature of       \n'+' طبيعة السلع  أو الخدمات',
    'Price\tUnit\n سعر الوحدة',
    'Quantity\n كمية',
    // '(Including Vat) Subtotal Item المجموع )شامل ضریبة القیمة المضافة('
    '(Including Vat) Item Subtotal المجموع )شامل ضریبة القیمة المضافة('
  ];




  void IntialFunctions({var Parm_Id,var Kot,var CntPrint }) {

    SharedPreferences.getInstance().then((value) {
      pref = value;
      read();
      GeneralSettings();
      GetQrdata(Parm_Id);
      GetdataPrint(Parm_Id);

      KotPrint=Kot;
      Counter_Print=CntPrint;
    });
  }


  read() async {
    var v = pref.getString("userData");
    var c = json.decode(v!);
    user = UserData.fromJson(c); // token gets this code user.user["token"]

    branchId = int.parse(c["BranchId"]);
    token = user.user["token"]; //  passes this user.user["token"]
    pref.setString("customerToken", user.user["token"]);
    branchName = user.branchName;
    userName = user.user["userName"];
    userId = user.user["userId"];
    CountryName = user.user["countryName"];
    currencyName = user.user["currencyName"];
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

      GenSettingsData[0]["applicationTaxTypeGst"] == true ?
      TaxType = "Gst.No" : TaxType = "Vat.No";
      print("TaxType");
      print(TaxType);

    }
  }


  var Qrdata;
  GetQrdata(id) async {
    try {
      print("QR datas");
      final tagsJson =
      await http.get("${Env.baseUrl}SalesHeaders/$id/qrcode" as Uri, headers: {
        "Authorization": user.user["token"],
      });
      var footerdata =await jsonDecode(tagsJson.body);

      Qrdata = footerdata[0]["qrString"];
      print( "QR datas :" +Qrdata.toString());


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
      await http.get("${Env.baseUrl}SalesHeaders/$id" as Uri, headers: {
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
      // if (Pattern.contains(RegExp(r'[a-zA-Z]'))) {
      //   print("rtertre");
      //
      // }else{ Dr
      //   print("Nope, Other characters detected");
      //   IsArabic=true;
      // }

      //  GetArabicAmount(dataForTicket['salesHeader'][0]["amount"]);

      // setState(() {
      //   IsArabic = true;
      // });

      var KotData=[];
      var CounterData=[];

      for (int i = 0; i < Detailspart.length; i++) {

        if(Detailspart[i]['igKotPrinter'].toString().contains("Kitchen")){

          KotData.add(Detailspart[i]);

        }else
          {
            CounterData.add(Detailspart[i]);
          }

        print("KotData");
        print(KotData);
        print("CounterData");
        print(CounterData);

      }

      Timer(Duration(milliseconds: 2), () async{
        wifiprinting(KotPrint);
      });
      Timer(Duration(milliseconds: 5), () async{
        wifiprinting(Counter_Print);
      });

    } catch (e) {
      print('error on databinding $e');
    }
  }






  wifiprinting(PrntName) async {
    print(" print in");
    // _printerManager.selectPrinter(PrntName);
    _printerManager.selectPrinter('192.168.0.100');




    // final ByteData data = await rootBundle.load(
    //     '/storage/emulated/0/Android/data/com.example.ErpAapp/files/exampleNew.jpg');
    //final Uint8List bytes =await GetImageFromDevice();
    final Uint8List bytes =await SetToImmg();
    final image = decodeImage(bytes);
    // FinalImage=  File.fromRawPath(bytes);



    // print("image.runtimeType");
    // print(image.runtimeType);
    File(
        '/storage/emulated/0/Android/data/com.example.ErpAapp/files/exampleNew.jpg')
        .writeAsBytes(bytes);
    final res =
    await _printerManager.printTicket(await _ticket(PaperSize.mm80, image));
    print(" print in");
    // } catch (e) {
    // }
  }



  Future<Ticket> _ticket(PaperSize paper, image) async {
    print('in print Ticket');
    final ticket = Ticket(paper);


    ticket.image(image);
    // ticket.imageRaster(image);

    print("Finish");
    ticket.cut();
    return ticket;
  }

  Future<Uint8List> SetToImmg() async {
    // await Printing.layoutPdf(
    //     onLayout: (PdfPageFormat format) async => pdf.save());

    await for (var page in Printing.raster(
        await _generatePdf(), pages: [0], dpi: 180)) {
      final image = await page.toPng();
      print(image);
      print(image.runtimeType);
      return image;
    }

    // Throw an exception if the loop completes without returning an image.
    throw Exception("Failed to generate the image");
  }



  // Future<Uint8List> DisplayPdf()async{
  // IntialFunctions(Parm_Id: 1);
  //   var s=await _generatePdf();
  //   return s;
  // }


  Future<Uint8List> _generatePdf() async {
    final pdf = pw.Document(compress: true);
    final font = await rootBundle.load("assets/arial.ttf");
    final Boldfont = await rootBundle.load("assets/FontsFree-Net-arial-bold.ttf");
    final ttf = pw.Font.ttf(font);
    final ttf_Bold = pw.Font.ttf(Boldfont);
    final Pdf_fontSize = 9.0;
    final Pdf_Width = 570.0;
    final Logoimage = pw.MemoryImage(
      (await rootBundle.load('assets/icon1.jpg')).buffer.asUint8List(),
    );


    pdf.addPage(
      pw.Page(
        margin: pw.EdgeInsets.only(top: 1, left: 1, bottom: 1, right: 1),
        pageFormat: PdfPageFormat.roll80,
        build: (context) {
          return dataForTicket == null ? pw.Text('Loading...') : pw.ListView(
            children: [

              pw.Center(
                child: pw.Image(Logoimage),
              ),

              pw.SizedBox(height: 5),
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
                          headerAlignments:{2: pw.Alignment.center,3:pw.Alignment.center},
                          cellAlignments: {2: pw.Alignment.centerLeft,},
                          columnWidths: {
                            0: pw.FixedColumnWidth(70),
                            3: pw.FixedColumnWidth(70),
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






              pw.SizedBox(height: 5),

              pw.Column(
                  children: [
                    pw.Row(
                        mainAxisAlignment:pw.MainAxisAlignment.start,
                        // crossAxisAlignment:pw.CrossAxisAlignment.end,
                        children:[

                          pw.Expanded(child:pw.Text("Total Taxable Amount (Excluding VAT)",style: pw.TextStyle(fontSize: Pdf_fontSize,fontWeight:pw.FontWeight.bold))),
                          //pw. Spacer(),
                          pw.SizedBox(width: 10),
                          pw.Expanded(child:pw.Text("الإجمالي الخاضع للضریبة )غیر شامل ضریبة القیمة المضافة(",style: pw.TextStyle(fontSize: Pdf_fontSize,font: ttf_Bold,color: PdfColors.black),
                            textDirection: pw.TextDirection.rtl,)),

                          pw. Spacer(),

                          pw.Text("${AmountBeforeTax.toStringAsFixed(2)} ${currencyName??""}",style: pw.TextStyle(fontSize: Pdf_fontSize,fontWeight: pw.FontWeight.bold)),
                        ]),



                    pw.SizedBox(height:5),

                    pw.Row(
                        mainAxisAlignment:pw.MainAxisAlignment.spaceBetween,
                        children:[

                          pw.Expanded(child:pw.Text("Total VAT",style: pw.TextStyle(fontSize: Pdf_fontSize,fontWeight:pw.FontWeight.bold))),
                          // pw. Spacer(),
                          pw.SizedBox(width: 10),
                          pw.Expanded(child:pw.Text(" ضريبة القيمة المضافة",style: pw.TextStyle(fontSize: Pdf_fontSize,font: ttf_Bold,color: PdfColors.black),
                            textDirection: pw.TextDirection.rtl,)),

                          pw. Spacer(),

                          pw.Text("  ${TotalTax==null?0.toStringAsFixed(2):
                          TotalTax.toStringAsFixed(2)} ${currencyName??""}",style: pw.TextStyle(fontSize: Pdf_fontSize,fontWeight: pw.FontWeight.bold)),
                        ]),





                    pw.SizedBox(height:5),





                    pw.Row(
                        mainAxisAlignment:pw.MainAxisAlignment.spaceAround,
                        children:[

                          pw.Expanded(child:pw.Text("Total Amount Due",style: pw.TextStyle(fontSize: Pdf_fontSize,fontWeight:pw.FontWeight.bold))),
                          // pw. Spacer(),
                          pw.SizedBox(width: 10),
                          pw.Expanded(child:pw.Text("إجمالي المبلغ المستحق",style: pw.TextStyle(fontSize: Pdf_fontSize,font: ttf_Bold,color: PdfColors.black),
                            textDirection: pw.TextDirection.rtl,)),

                          pw. Spacer(),
                          // pw.Text("${dataForTicket["amount"].toStringAsFixed(2)} ${currencyName??""}",style: pw.TextStyle(fontSize: Pdf_fontSize,)), ]),
                          pw.Text("${(TotalTax+AmountBeforeTax).toStringAsFixed(2)} ${currencyName??""}",style: pw.TextStyle(fontSize: Pdf_fontSize,fontWeight: pw.FontWeight.bold)), ]),
                  ]),



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



  TableGenerator() {


    var purchasesAsMap;


    var Slnum = 0;

    purchasesAsMap = <Map<String, String>>[
      for(int i = 0; i < Detailspart.length; i++)
        {
          "ItemName": "${Detailspart[i]['itmName']??
              ""}  ${Detailspart[i]['itmArabicName'] ?? ""}",
          "Rate": "${Detailspart[i]['rate'].toStringAsFixed(2)} ",
          "Qty": " (${Detailspart[i]['uom']})             ${Detailspart[i]['qty']} ",
          "NetAmt": "${Detailspart[i]['amountIncludingTax'].toStringAsFixed(2)} ",
        },
    ];


    List<List<String>> listOfPurchases = [];
    for (int i = 0; i < purchasesAsMap.length; i++) {
      listOfPurchases.add(purchasesAsMap[i].values.toList());
    }
    return listOfPurchases;
  }

}
