import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
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
import 'PDF_Printer.dart';

class New_Model_PdfPrint extends StatefulWidget {
  var Parm_Id;
  var Page_Type;
  New_Model_PdfPrint({this.Parm_Id,this.Page_Type});

  @override
  _New_Model_PdfPrintState createState() => _New_Model_PdfPrintState();
}

class _New_Model_PdfPrintState extends State<New_Model_PdfPrint> {

  Pdf_Two_Inch Pdf_2=Pdf_Two_Inch();

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
  String Datetime_Now = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());
  var Detailspart;
  var dataForTicket;
  var footerCaptions;
  var  Companydata;
  bool IsArabic=false;
  bool PgA4=true;
  bool Pg_2_Inch=false;
  String IsArabicChkBoxText="Arabic";
  var  TaxType;
  var  CountryName;
  var  currencyName;
  var  LedgerBalance=0.0;
  // double Pdf_Width=800.0;
  NumberToWord arabicAmount = NumberToWord();
bool LgrBalanceShow=false;
  var opType="";
  void initState() {
    setState(() {
      SharedPreferences.getInstance().then((value) {
        pref = value;
        print("the preference is " + pref.getString("userData").toString());
        read();
        GetdataPrint(widget.Parm_Id);
        footerdata();
        GetQrdata();
        GeneralSettings();
        widget.Page_Type==true? PgA4=true:PgA4=false;
        dropdownValue=widget.Page_Type==true?"Tax Invoice":"Invoice";
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
    var CD=await GetCompantPro(branchId);
  }




  GeneralSettings()async{


    final res =
    await http.get("${Env.baseUrl}generalSettings" as Uri, headers: {
      "Authorization": user.user["token"],
    });

    if(res.statusCode<210) {
      print(res);
      var GenSettingsData = json.decode(res.body);
      print(GenSettingsData[0]["applicationTaxTypeGst"]);
      setState(() {
        LgrBalanceShow=GenSettingsData[0]["printLedgerBalanceInInvoice"];
        GenSettingsData[0]["applicationTaxTypeGst"] ==true ?
        TaxType = "Gst.No" : TaxType = "Vat.No";
        print("TaxType");
        print(TaxType);

      });
    }
  }



  footerdata() async {
    try {
      print("footer data decoded  ");
      final tagsJson =
      await http.get("${Env.baseUrl}SalesInvoiceFooters/" as Uri, headers: {
        "Authorization": user.user["token"],
      });
      var footerdata =await jsonDecode(tagsJson.body);
      setState(() {
        footerCaptions = footerdata;
        // print( "on footerCaptions :" +footerCaptions.toString());
      });

    } catch (e) {
      print(e);
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
        print( "QR datas :" +Qrdata.toString());
      });

    } catch (e) {
      print(e);
    }
  }



  var BuyerDetails=[];
  GetBuyerDetails(id) async {
    try {
      print("GetBuyerDetails datas $id");
      final tagsJson =
      await http.get("${Env.baseUrl}MLedgerHeads/$id" as Uri, headers: {
        "Authorization": user.user["token"],
      });



      if(tagsJson.body.contains("errors")){
        print("Error on GetBuye");
        setState(() {
          BuyerDetails=[
            {
              "lhName": "", "nameLatin": null, "districtName": null, "areaName": null,
              "lhPincode": null, "lhGstno": null, "buildingNo": null,
              "buildingNoLatin": "","streetName": "", "streetNameLatin": "",
              "district": "", "districtLatin": " ", "city": " ", "cityLatin": "",
              "country": " ", "countryLatin": "", "pinNo": "","pinNoLatin": ""
            }];
        });

      }else {
        var Buyer =await jsonDecode(tagsJson.body);
        setState(() {
          BuyerDetails = Buyer["ledgerHeads"];
          print("GetBuyerDetails datas :" +BuyerDetails.toString());
          print(BuyerDetails[0]["lhName"]);

        });
      }
    } catch (e) {
      print("Error on GetBuyerDetails $e");
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
      print( "on GetCompantPro :" +Companydata.toString());
      print(  Companydata['companyProfileAddress1'].toString());
    }
    catch(e){
      print("error on GetCompantPro : $e");
    }
  }


  var  VchDate;
  var  InvTime;
  var TotalTax=0.0;
  var AmountBeforeTax=0.0;
  var TotalQty=0.0;

  GetdataPrint(id) async {
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
      var ParseDate=dataForTicket['salesHeader'][0]["entryDate"]??"2022-01-01T00:00:00";
      // DateTime tempDate = new DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(ParseDate);
      DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(ParseDate);
      print(dataForTicket['salesHeader'][0]["voucherDate"]);
      VchDate=DateTimeFormat.format(tempDate);
      print(VchDate.toString());


      var  tempTime=dataForTicket['salesHeader'][0]["entryDate"]??"2022-01-01T00:00:00";
      DateTime tempTimeFormate = new DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(tempTime);
      InvTime= DateFormat.jm().format(tempTimeFormate);
      // print("tempTime");
      // print(tempTime);
      // print("tempTimeFormate");
      // print(tempTimeFormate);
      // print("InvTime");
      // print(InvTime);

      GetBuyerDetails(dataForTicket['salesHeader'][0]["ledgerId"]);
      Detailspart = dataForTicket['salesDetails'];
      var  Pattern=Detailspart[0]['itmName'];


      print(Detailspart[0]['rate'].runtimeType);
      print(Detailspart[0]['taxPercentage'].runtimeType);
      for(int i = 0; i < Detailspart.length; i++)
      {

        double qty=Detailspart[i]['qty']==null?0.0:(Detailspart[i]['qty']);
        double rate=Detailspart[i]['rate']==null?0.0:(Detailspart[i]['rate']);
        double varTxPer=Detailspart[i]['taxPercentage']==null?0.0:(Detailspart[i]['taxPercentage']);
        double itemTaxrate=Detailspart[i]['taxAmount']??0.0;
        //  double itemTaxrate=await CalculateTaxAmt(rate,qty,varTxPer);
        TotalTax=TotalTax+itemTaxrate;
        TotalQty=TotalQty+qty;
        AmountBeforeTax=AmountBeforeTax+Detailspart[i]['amountBeforeTax'];
      }
      print("TotalTax");
      print(TotalTax.toString());
      // if (Pattern.contains(RegExp(r'[a-zA-Z]'))) {
      //   print("rtertre");
      //
      // }else{
      //   print("Nope, Other characters detected");
      //   IsArabic=true;
      // }

      GetArabicAmount(dataForTicket['salesHeader'][0]["amount"]);
      if(dataForTicket['salesHeader'][0]["ledgerId"]!=null) {
        LedgerBalance = await GetLedgerBalance(
            dataForTicket['salesHeader'][0]["ledgerId"], tempDate);
      }
      setState(() {
        IsArabic=true;
      });
    } catch (e) {
      print('error on databinding $e');
    }
  }

  //String dropdownValue = '3 Inch';
  String dropdownValue = 'Tax Invoice';


  var  AmtInWrds="";
  GetArabicAmount(Amount){
    //  AmtInWrds= arabicAmount.NumberInRiyals(Amount);

  }

  GetLedgerBalance(id,DateTime Vchdate)async{
    var _LgrBlnce=0.0;
    //  print(id);
    //  print("the given date is");
    print("GetLedgerBalance");
    final DateFormat formatter = DateFormat('MM-dd-yyy');
    final String formattedDate = formatter.format(Vchdate.add(Duration(hours: 24)));
    //   print("formattedDate"); // something like 2013-04-20
    //   print(formattedDate); // something like 2013-04-20


    var url = "${Env.baseUrl}TaccLedgers/${id.toInt()}/$formattedDate";
    //   print("url:" + url);
    try {
      final response = await http.get(url as Uri, headers: {
        "Authorization": user.user["token"],
      });
      // print("response.statusCode");
      //  print(response.statusCode.toString());
      //  print(response.body.toString());

      if (response.statusCode < 210) {
        print(response.body);
        var e = json.decode(response.body);
        // print("openingAmount");
        //  print(e["openingAmount"]);
        opType=e["opType"];
        _LgrBlnce=e["openingAmount"];
      }
      return _LgrBlnce;
    } catch (e) {
      print("error" + e.toString());
    }


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


GetTD() {
  var Tr = [ "",
    "Current Balance (AS on $VchDate)",
    "الرصيد الحالي (كمافي $VchDate)",
    "${dataForTicket['salesHeader'][0]["amount"] == null
        ? 0.toStringAsFixed(2)
        :
    dataForTicket['salesHeader'][0]["amount"].toStringAsFixed(
        2)} ${currencyName ?? ""}",
  ];

 var  Tr2= [ "",
   "Current Balance (AS on $VchDate)",
   "الرصيد الحالي (كمافي $VchDate)",
   "${dataForTicket['salesHeader'][0]["amount"] == null
   ? 0.toStringAsFixed(2)
       :
   dataForTicket['salesHeader'][0]["amount"].toStringAsFixed(
   2)} ${currencyName ?? ""}",
   ];
  //Tr.add(Tr2);


  return Tr ;
}


  ///---------------------------------------------

  @override
  Widget build(BuildContext context) {
    var ScreenSize=MediaQuery.of(context).size.width;
    var ScreenHeight=MediaQuery.of(context).size.height;

    return
      SafeArea(
        child: Scaffold(
          appBar: PreferredSize(preferredSize: Size.fromHeight(80),
            child: Appbarcustomwidget(uname: userName, branch:branchName, pref: pref, title:"Print"),),

          body: dataForTicket == null ? SizedBox(height: ScreenHeight,width: ScreenSize,
              child: Center(child: Text("Loading..."))) :
          Companydata == null ? SizedBox(height: ScreenSize,width: ScreenSize,
              child: Center(child: Text("Loading..."))) :
          BuyerDetails.isEmpty ? SizedBox(height: ScreenSize,width: ScreenSize,
              child: Center(child: Text("Loading..."))) :

          PdfPreview(
              initialPageFormat:PdfPageFormat.a4 ,
              allowPrinting: true,
              allowSharing: false,
              canChangePageFormat: false,
              useActions: true,
              build: (format) =>PgA4==true?_generatePdfForA4(format, ScreenSize,context):
              _generatePdf3Inch(format, ScreenSize,context)
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
            child:  DropdownButton(

              underline:Container(color: Colors.transparent),
              icon:Text("$dropdownValue  ▼",style: TextStyle(color: Colors.white),),

              items:[
                DropdownMenuItem<String>(
                  value: "Tax Invoice",
                  child: Text(
                    "Tax Invoice",style:TextStyle(fontSize: 13),
                  ),
                ),

                DropdownMenuItem<String>(
                  value: "Simplified",
                  child: Text(
                    "Simplified",style:TextStyle(fontSize: 13),
                  ),
                ),

                DropdownMenuItem<String>(
                  value: "A4",
                  child: Text(
                    "A4",style:TextStyle(fontSize: 13),
                  ),
                ),
                DropdownMenuItem<String>(
                  value: "3 Inch",
                  child: Text(
                    "3 Inch",style:TextStyle(fontSize: 13),
                  ),
                ),
                DropdownMenuItem<String>(
                  value: "2 Inch",
                  child: Text(
                    "2 Inch",style:TextStyle(fontSize: 13),
                  ),
                ),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                  Pagetype(dropdownValue);
                  if(dropdownValue== "2 Inch"){
                    Pg_2_Inch=true;
                  }
                });
              },

            ),
          ),



          // ] ),
        ),);
  }


  ///---------------------------------------A4------------------------------------------
  Future<Uint8List> _generatePdfForA4(PdfPageFormat format,
      ScreenSize,BuildContext context) async {
    final pdf = pw.Document(compress: true);
    final font = await rootBundle.load("assets/arial.ttf");
    final ttf = pw.Font.ttf(font);
    final Pdf_fontSize=6.7;
    final Pdf_Width=570.0;
    pdf.addPage(
      pw.MultiPage(


             footer:(pw.Context context) {

               return
               pw.Center(child:
                 pw.Text('Page ${context.pageNumber} of  ${context.pagesCount}',)
               );
             } ,

        textDirection:pw.TextDirection.rtl,
        margin:pw.EdgeInsets.only(top: 20,left: 10,bottom: 20,right: 10),
        //  pageFormat:PgA4==true? PdfPageFormat.a4:PdfPageFormat(80 * PdfPageFormat.mm,double.infinity, marginAll: 5 * PdfPageFormat.mm),
        pageFormat:PdfPageFormat.a4,
        build: (pw.Context context) {
          return <pw.Widget
          >[

            dataForTicket == null ? pw.Text('') :

            pw.Center(child:   pw.Text(PgA4==true?"فاتورة ضريبية":'فاتورة ضريبية مبسطة', textAlign: pw.TextAlign.center,
                textDirection: pw.TextDirection.rtl,
                style: pw.TextStyle(
                    font: ttf,fontSize:Pdf_fontSize)),),


            // pw.Center(child:pw.SizedBox(child: pw.Divider(),width: ScreenSize/9),heightFactor: 0),
            pw.SizedBox(height: 5),
            pw.Center(child:   pw.Text(PgA4==true?'TAX INVOICE':'Simplified Tax Invoice', textAlign: pw.TextAlign.center,
                //textDirection: pw.TextDirection.rtl,
                style: pw.TextStyle(fontSize:Pdf_fontSize,
                    decoration:pw.TextDecoration.underline)),),


            pw.SizedBox(height: 5),















            pw.SizedBox(height: 10),


            PgA4==true? pw.Row(  mainAxisAlignment:  pw.MainAxisAlignment.spaceBetween,
                children: [

                  pw.Column(
                      crossAxisAlignment:  pw.CrossAxisAlignment.start,
                      mainAxisAlignment:  pw.MainAxisAlignment.start,
                      children: [

                        pw.Container(

                            width: ScreenSize/1.45,
                            decoration: pw.BoxDecoration(border: pw.Border.all(
                                color: PdfColors.black) ),
                            child:pw.Padding(padding:pw.EdgeInsets.all(3),
                              child:
                              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    pw.Text('Invoice No              : ' +dataForTicket['salesHeader'][0]["voucherNo"].toString(),
                                        style:pw.TextStyle(fontSize:Pdf_fontSize)),



                                    pw.Text(" رقم الفاتورة ${dataForTicket['salesHeader'][0]["voucherNo"].toString()} :             ",
                                        textDirection: pw.TextDirection.rtl,
                                        style: pw.TextStyle(font: ttf,fontSize:Pdf_fontSize)),

                                  ] ),)
                        ),



                        pw.Container(

                            width: ScreenSize/1.45,
                            decoration: pw.BoxDecoration(border: pw.Border.all(
                                color: PdfColors.black) ),
                            child:pw.Padding(padding:pw.EdgeInsets.all(3),
                              child:
                              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    pw.Text('Invoice Issue Date : ' +VchDate.toString(),style:pw.TextStyle(fontSize:Pdf_fontSize)),


                                    pw.Text(" تاريخ إصدار الفاتورة ${VchDate.toString()} :  ",
                                        textDirection: pw.TextDirection.rtl,
                                        style: pw.TextStyle(font: ttf,fontSize:Pdf_fontSize)),

                                  ] ),)
                        ),


                        // pw.SizedBox(height: 10),

                        pw.Container(

                            width: ScreenSize/1.45,
                            decoration: pw.BoxDecoration(border: pw.Border.all(
                                color: PdfColors.black) ),
                            child:pw.Padding(padding:pw.EdgeInsets.all(3),
                              child:
                              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    pw.Text('Date of Supply       : ' +VchDate.toString(),style:pw.TextStyle(fontSize:Pdf_fontSize)),


                                    pw.Text(" تاريخ التوريد ${VchDate.toString()} :           ",
                                        textDirection: pw.TextDirection.rtl,
                                        style: pw.TextStyle(font: ttf,fontSize:Pdf_fontSize)),

                                  ] ),))

                      ]),



                  pw.Padding(padding:pw.EdgeInsets.only(bottom: 5),
                      child: pw.BarcodeWidget(
                        // data: widget.Parm_Id.toString(),
                          data: Qrdata.toString(),
                          barcode: pw.Barcode.qrCode(),
                          width: 50,
                          height: 50
                      ))




                ]):


            ///---------------------------------------pg 3inch-------------------------------

            pw.Container(

              child:
              pw.Column(
                  crossAxisAlignment:  pw.CrossAxisAlignment.start,
                  mainAxisAlignment:  pw.MainAxisAlignment.start,
                  children: [




                    pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Invoice No              : ' +dataForTicket['salesHeader'][0]["voucherNo"].toString(),
                              style:pw.TextStyle(fontSize:Pdf_fontSize)),



                          pw.Text(" رقم الفاتورة ${dataForTicket['salesHeader'][0]["voucherNo"].toString()} :             ",
                              textDirection: pw.TextDirection.rtl,
                              style: pw.TextStyle(font: ttf,fontSize:Pdf_fontSize)),

                        ] ),


                    pw.SizedBox(height: 2),


                    pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Invoice Issue Date : ' +VchDate.toString(),style:pw.TextStyle(fontSize:Pdf_fontSize)),
                          pw.Text(" تاريخ إصدار الفاتورة ${VchDate.toString()} :  ",
                              textDirection: pw.TextDirection.rtl,
                              style: pw.TextStyle(font: ttf,fontSize:Pdf_fontSize)),

                        ] ),


                    pw.SizedBox(height: 2),

                    pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Expanded(child:  pw.Text('VAT Number : ${Companydata['companyProfileGstNo']??""}',style:pw.TextStyle(fontSize:Pdf_fontSize)),),

                          pw.Text("ظريبه الشراء:  ${Companydata['companyProfileGstNo']??""} ",
                              textDirection: pw.TextDirection.rtl,
                              style: pw.TextStyle(font: ttf,fontSize:Pdf_fontSize)),

                        ] ),

                    //     pw.SizedBox(height: 10),



                  ]),
            ),

            ///---------------------------------------------------------------------------------




            PgA4==true?pw.Directionality(
              textDirection:pw.TextDirection.rtl,
              child:
              // pw.Expanded( child:
              pw.SizedBox(
                //color:PdfColors.red,
                child:pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Expanded(
                        //  height: 300,
                        //  width: Pdf_Width,
                          child:
                          pw.Table.fromTextArray(
                            cellAlignment:pw.Alignment.topRight,
                            cellAlignments:{0: pw.Alignment.topLeft,
                              1:pw.Alignment.topLeft,
                              3:pw.Alignment.topRight,
                              4: pw.Alignment.topLeft,
                              5: pw.Alignment.topLeft,

                            },
                            headerAlignment: pw.Alignment.centerLeft,
                            headerAlignments:{7: pw.Alignment.centerRight,} ,


                            columnWidths:{
                              1: pw.FixedColumnWidth(80),
                              2: pw.FixedColumnWidth(80),
                              5: pw.FixedColumnWidth(80),
                              6: pw.FixedColumnWidth(80),
                            },


                            headerDecoration: pw.BoxDecoration(
                              color:PdfColors.grey400,),
                            headers:
                            [
                              "Seller :",
                              "",
                              "",
                              "المورد:",

                              "Buyer :",
                              "",
                              "",
                              "عميل:",
                            ],

                            data: [
                              [
                                "Name",
                                "${Companydata['companyProfileName']??""}",
                                "${Companydata['companyProfileNameLatin']??""}",
                                "اسم",

                                "Name",
                                "${BuyerDetails[0]['lhName']??""}",
                                "${BuyerDetails[0]['nameLatin']??""}",
                                "اسم"
                              ],

                              [
                                "Building No",
                                "${Companydata['buildingNo']??""}",
                                "${Companydata['buildingNoLatin']??""}",
                                "لا للبناء",

                                "Building No",
                                "${BuyerDetails[0]['buildingNo']??""}",
                                "${BuyerDetails[0]['buildingNoLatin']??""}",
                                "لا للبناء"
                              ],

                              [
                                "Street Name",
                                "${Companydata['streetName']??""}",
                                "${Companydata['streetNameLatin']??""}",
                                "اسم الشارع",

                                "Street Name",
                                "${BuyerDetails[0]['streetName']??""}",
                                "${BuyerDetails[0]['streetNameLatin']??""}",
                                "اسم الشارع"
                              ],


                              [
                                "District",
                                "${Companydata['district']??""}",
                                "${Companydata['districtLatin']??""}",
                                "يصرف",

                                "District",
                                "${BuyerDetails[0]['district']??""}",
                                "${BuyerDetails[0]['districtLatin']??""}",
                                "يصرف",
                              ],


                              [
                                "City",
                                "${Companydata['city']??""}",
                                "${Companydata['cityLatin']??""}",
                                "مدينة",

                                "City",
                                "${BuyerDetails[0]['city']??""}",
                                "${BuyerDetails[0]['cityLatin']??""}",
                                "مدينة",
                              ],


                              // ["Country","$CountryName",
                              //   "$CountryName","دولة"],
                              [
                                "Country",
                                "${Companydata['country']??""}",
                                "${Companydata['countryLatin']??""}",
                                "دولة",

                                "Country",
                                "${BuyerDetails[0]['country']??""}",
                                "${BuyerDetails[0]['countryLatin']??""}",
                                "دولة",
                              ],


                              [
                                "Postal Code",
                                "${Companydata['pinNo']??""}",
                                "${Companydata['pinNoLatin']??""}",
                                "رمز بريدي",

                                "Postal Code",
                                "${BuyerDetails[0]['pinNo']??""}",
                                "${BuyerDetails[0]['pinNoLatin']??""}",
                                "رمز بريدي",
                              ],


                              [
                                "Additional No",
                                "",
                                "",
                                "رقم إضافي",

                                "Additional No",
                                "",
                                "",
                                "رقم إضافي",
                              ],


                              [
                                "VAT Number:",
                                "${Companydata['companyProfileGstNo']??""}",
                                "${Companydata['companyProfileGstNo']??""}",
                                "ظريبه الشراء",

                                "VAT Number:",
                                "${BuyerDetails[0]['lhGstno']??""}",
                                "${BuyerDetails[0]['lhGstno']??""}",
                                "ظريبه الشراء",
                              ],


                              [
                                "Other Seller ID:",
                                "",
                                "",
                                "معرف البائع الآخر",

                                "Other Seller ID:",
                                "",
                                "",
                                "معرف البائع الآخر",
                              ],

                            ],
                            headerStyle: pw.TextStyle (font: ttf, fontSize: Pdf_fontSize,color: PdfColors.black),
                            cellStyle: pw.TextStyle (font: ttf, fontSize: Pdf_fontSize,),
                          )),

                    ]),


                //  pw.SizedBox(width: 2),
                // pw.SizedBox(
                //   height: 400,
                //   width: Pdf_Width/2,
                //   child: pw.Table.fromTextArray(
                //     cellAlignment:pw.Alignment.topRight,
                //     cellAlignments:{0: pw.Alignment.topLeft,3:pw.Alignment.topRight},
                //     columnWidths:{0: pw.FixedColumnWidth(70),},
                //      cellHeight: 18.9,
                //
                //     headerDecoration: pw.BoxDecoration(
                //       color:PdfColors.grey400,),
                //     headers:
                //     ["Buyer:",
                //       "",
                //       "",
                //       "مشتر:"],
                //
                //     data: [
                //       ["Name",
                //         "مؤسسة وسائل",
                //         "مؤسسة وسائل",
                //         "اسم"],
                //
                //       ["Building No",
                //         "657",
                //         "657",
                //         "لا للبناء"],
                //
                //       ["Street Name",
                //         "حائل",
                //         "حائل",
                //         "اسم الشارع"],
                //
                //
                //       ["District",
                //         "حي المحطة",
                //         "حي المحطة",
                //         "يصرف"],
                //
                //
                //       ["City","",
                //         "","مدينة"],
                //
                //
                //       // ["Country","$CountryName",
                //       //   "$CountryName","دولة"],
                //       ["Country","المملكة العربية السعودية",
                //         "المملكة العربية السعودية","دولة"],
                //
                //
                //       ["Postal Code","",
                //         "","رمز بريدي"],
                //
                //
                //       ["Additional No","",
                //         "","رقم إضافي"],
                //
                //
                //       ["VAT Number:",
                //         "300312566500003",
                //         "300312566500003",
                //         "ظريبه الشراء"],
                //
                //
                //       ["Other Seller ID:","",
                //         "","معرف البائع الآخر"],
                //
                //     ],
                //     headerStyle: pw.TextStyle (font: ttf, fontSize: Pdf_fontSize,color: PdfColors.black),
                //     cellStyle: pw.TextStyle (font: ttf, fontSize: Pdf_fontSize,),
                //   ),
                //
                // ),
                //





              ),

            ):

            ///-------------------------------3 inc ---------------------------------------------------



            pw.Text(""),

            pw.SizedBox(height:PgA4==true?20:5),



            PgA4==true? pw.Container(
                decoration: pw.BoxDecoration(
                    color:PdfColors.grey400,
                    border: pw.Border.all(
                        color: PdfColors.black) ),
                child:pw.Padding(padding:pw.EdgeInsets.all(3),
                  child:
                  pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Line Items:",style: pw.TextStyle(fontSize: Pdf_fontSize,font: ttf,color: PdfColors.black)),
                        pw.Text("البنود:",style: pw.TextStyle(fontSize: Pdf_fontSize,font: ttf,color: PdfColors.black),
                          textDirection: pw.TextDirection.rtl,),
                      ]),
                )
            ): pw.Text(""),



            ///----------------------------------item Table-------------------------------
            // pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            //     children: [


            //   width: ScreenSize+(ScreenSize/8),
            //color:  PdfColors.red,

            // pw.Partition(
            //   child:
            pw.Table.fromTextArray(
                tableWidth:pw.TableWidth.max ,
                cellAlignment: pw.Alignment.topRight,
                cellAlignments:PgA4==true?{0: pw.Alignment.topLeft,}:{0: pw.Alignment.topRight,},
                columnWidths:PgA4==true?{7: pw.FixedColumnWidth(100)}:
                {0: pw.FixedColumnWidth(60),3: pw.FixedColumnWidth(60),},
                cellHeight:15 ,
                cellStyle: pw.TextStyle(font: ttf,fontSize: Pdf_fontSize),
                headerStyle: pw.TextStyle(fontWeight:pw.FontWeight.bold,font: ttf,fontSize:Pdf_fontSize,),
                headerAlignment:pw.Alignment.topRight,
                headerAlignments:PgA4==true?{} :{0: pw.Alignment.topLeft},
                headerDecoration: pw.BoxDecoration(border: pw
                    .Border(bottom: pw.BorderSide(
                    color: PdfColors.black)),
                    color:PgA4==true?PdfColors.white:PdfColors.grey400),

                cellPadding:pw.EdgeInsets.all(1),

                headers:TblHeader,
                data: TableGenerator()
            ),
            // ),











            pw.SizedBox(height:PgA4==true?20:5),




            PgA4==true?pw.Container(
                decoration: pw.BoxDecoration(
                    color:PdfColors.grey400,
                    border: pw.Border.all(
                        color: PdfColors.black) ),
                child:pw.Padding(padding:pw.EdgeInsets.all(3),
                  child:
                  pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Total amounts:",style: pw.TextStyle(fontSize: Pdf_fontSize,font: ttf,color: PdfColors.black)),
                        pw.Text("المبالغ الإجمالية:",style: pw.TextStyle(fontSize: Pdf_fontSize,font: ttf,color: PdfColors.black),
                          textDirection: pw.TextDirection.rtl,),
                      ]),
                )
            ):pw.Text(""),

            pw.Directionality(
              textDirection:IsArabic==true? pw.TextDirection.rtl: pw.TextDirection.ltr,
              child:
              pw.Table.fromTextArray(
                  headerAlignments:{1: pw.Alignment.topLeft,2:pw.Alignment.topRight,3:pw.Alignment.centerRight} ,
                  cellAlignments:{1: pw.Alignment.topLeft,2:pw.Alignment.topRight,3:pw.Alignment.centerRight},
                  columnWidths:{0: pw.FixedColumnWidth(100),},
                  headerStyle: pw.TextStyle (font: ttf, fontSize: 10,),
                  cellStyle: pw.TextStyle (font: ttf, fontSize: 10,),


                  headers:




                  ["",
                    "Total (Excluding VAT)",
                    "الإجمالي)باستثناء ضريبة القيمة المضافة(",
                    "${AmountBeforeTax.toStringAsFixed(2)} ${currencyName??""}",
                  ],

                  data: [

                    [   "",
                      "Discount",
                      "خصم",
                      "0.00 ${currencyName??""}",
                    ],

                    [   "",
                      "Total Taxable Amount (Excluding VAT)",
                      "إجمالي المبلغ الخاضع للضريبة )باستثناء ضريبة القيمة المضافة(",
                      "${AmountBeforeTax.toStringAsFixed(2)} ${currencyName??""}",
                    ],



                    [   "",
                      "Total VAT",
                      " ضريبة القيمة المضافة",
                      "${TotalTax==null?0.toStringAsFixed(2):
                      TotalTax.toStringAsFixed(2)} ${currencyName??""}",
                    ],


                    [   "",
                      "Total Amount Due",
                      "إجمالي المبلغ المستحق",
                      "${dataForTicket['salesHeader'][0]["amount"]==null?0.toStringAsFixed(2):
                      dataForTicket['salesHeader'][0]["amount"].toStringAsFixed(2)} ${currencyName??""}",
                    ],


                    // 1==2?
                    // [   "",
                    //   "Current Balance (AS on $VchDate)",
                    //   "الرصيد الحالي (كمافي $VchDate)",
                    //   "${dataForTicket['salesHeader'][0]["amount"]==null?0.toStringAsFixed(2):
                    //   dataForTicket['salesHeader'][0]["amount"].toStringAsFixed(2)} ${currencyName??""}",
                    // ]:
                    //    [''],

                    // GetTD()


                  ]
              ),
            ),


            LgrBalanceShow==true?    pw.Directionality(
              textDirection: pw.TextDirection.ltr,

                child: pw.Row(children: [

              pw.Container(
                height: 15,width: 103,
                decoration: pw.BoxDecoration(

                  border: pw.Border.all(
                    color:PdfColors.black,
                    width: 1,
                  ),
                ),
              ),

              pw.Container(
                height: 15,width: 191,
                decoration: pw.BoxDecoration(

                  border: pw.Border.all(
                    color:PdfColors.black,
                    width: 1,
                  ),
                ),
                child:pw.Text("  Current Balance (As on $VchDate)",style: pw.TextStyle (fontSize: 10,),)
              ),







              pw.Container(
                height: 15,width: 221,
                decoration: pw.BoxDecoration(

                  border: pw.Border.all(
                    color:PdfColors.black,
                    width: 1,
                  ),
                ),
                child:pw.Align(
                  alignment:pw.Alignment.topRight,
                  child:
                pw.Text(" الرصيد  الحالي )كمافي  ($VchDate  ",
                    style:pw.TextStyle (font: ttf, fontSize: 10,),textDirection:pw.TextDirection.rtl ),
                )


              ),
              pw.Container(

                child:

                pw.Align(
                  alignment:pw.Alignment.centerRight,
                    child:
                pw.Text("${opType ??""} ${LedgerBalance.toStringAsFixed(2)}  ",style: pw.TextStyle (fontSize: 10,),
                  )) ,
                height: 15,width: 61,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(
                    color:PdfColors.black,
                    width: 1,
                  ),
                ),
              )

            ])):
            pw.Text(""),

            ///---------------------------------3 inc -----------------------------------------------

//               pw.Directionality(
//                 textDirection:IsArabic==true? pw.TextDirection.rtl: pw.TextDirection.ltr,
//                 child:
//                 pw.Table.fromTextArray(
//                     headerAlignments:PgA4==true?{1: pw.Alignment.topLeft,2:pw.Alignment.topRight,3:pw.Alignment.centerRight} :
//                     {0: pw.Alignment.topRight,1:pw.Alignment.topRight,2:pw.Alignment.centerRight},
//                     cellAlignments:PgA4==true?{1: pw.Alignment.topLeft,2:pw.Alignment.topRight,3:pw.Alignment.centerRight}:
//                     {0: pw.Alignment.topLeft,1:pw.Alignment.topRight,2:pw.Alignment.centerRight},
//                     // columnWidths:{0: pw.FixedColumnWidth(100),},
//                     headerStyle: pw.TextStyle (font: ttf, fontSize: Pdf_fontSize,),
//                     cellStyle: pw.TextStyle (font: ttf, fontSize: Pdf_fontSize,),
//                     columnWidths:PgA4==true?{}:{2: pw.FixedColumnWidth(100),0: pw.FixedColumnWidth(150),},
//
// border:pw.TableBorder(left: pw.BorderSide.none,
//  bottom: pw.BorderSide(color: PdfColors.black),
// top: pw.BorderSide(color: PdfColors.black),),
//                     headers:
//                     [
//                       "TotalTaxable\tAmount\t(ExcludingVAT)",
//                       "إجمالي المبلغ الخاضع للضريبة (باستثناء ضريبة القيمة المضافة)",
//                       "${AmountBeforeTax.toStringAsFixed(2)}",
//                     ],
//
//                     data: [
//                       [
//                         "Total VAT",
//                         "إجمالي ضريبة القيمة المضافة",
//                         "${TotalTax==null?0.toStringAsFixed(2):
//                         TotalTax.toStringAsFixed(2)}",
//                       ],
//
//
//                       [
//                         "Total Amount Due",
//                         "إجمالي المبلغ المستحق",
//                         "${dataForTicket['salesHeader'][0]["amount"]==null?0.toStringAsFixed(2):
//                         dataForTicket['salesHeader'][0]["amount"].toStringAsFixed(2)}",
//                       ],
//
//
//                     ]
//                 ),
//               ),




            PgA4==true?pw.Text(""):pw.Divider(height: 1,thickness: 1,color: PdfColors.black),
            pw.SizedBox(height:3),
            PgA4==true?pw.Text(""):pw.Column(
                children: [
                  pw.Row(
                      mainAxisAlignment:pw.MainAxisAlignment.start,
                      // crossAxisAlignment:pw.CrossAxisAlignment.end,
                      children:[

                        pw.Expanded(child:pw.Text("Total Taxable Amount (Excluding VAT)",style: pw.TextStyle(fontSize: Pdf_fontSize,))),
                        pw. Spacer(),
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
                        pw. Spacer(),
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
                        pw. Spacer(),
                        pw.Expanded(child:pw.Text("إجمالي المبلغ المستحق",style: pw.TextStyle(fontSize: Pdf_fontSize,font: ttf,color: PdfColors.black),
                          textDirection: pw.TextDirection.rtl,)),

                        pw. Spacer(),
                        pw.Text("${dataForTicket['salesHeader'][0]["amount"].toStringAsFixed(2)} ${currencyName??""}",style: pw.TextStyle(fontSize: Pdf_fontSize,)), ]),








                ]),





            pw.SizedBox( height: 5,),

            PgA4==true?pw.Text("") : pw.Padding(padding:pw.EdgeInsets.only(bottom: 5),
                child: pw.BarcodeWidget(
                  // data: widget.Parm_Id.toString(),
                    data: Qrdata.toString(),
                    barcode: pw.Barcode.qrCode(),
                    width: 50,
                    height: 50
                )),


            pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children:[
                  pw.SizedBox(
                    height: 2,),


                  pw.SizedBox(
                    width: 20,),
                  pw.SizedBox(height: 2),


                  // pw.SizedBox(height: 50,width: 100,child:
                  // pw.BarcodeWidget(
                  //     data: widget.Parm_Id.toString(),
                  //     barcode: pw.Barcode.code39(),
                  //     width: 100,
                  //     height: 50
                  // ),
                  // )

                ]),

            //   pw.SizedBox(height: 2),
            //   pw.Text(footerCaptions[0]['footerText']+"...",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,font: ttf,fontSize: Pdf_fontSize))




          ];
        },

      ),
    );

    return pdf.save();
  }





  ///----------------------------------------3 Inch-----------------------------------------------

  Future<Uint8List> _generatePdf3Inch(PdfPageFormat format,
      ScreenSize,BuildContext context) async {
    final pdf = pw.Document(compress: true);
    final font = await rootBundle.load("assets/arial.ttf");
    final ttf = pw.Font.ttf(font);
    final Pdf_fontSize=6.7;
    final Pdf_Width=570.0;
    pdf.addPage(
      pw.Page(
        margin:pw.EdgeInsets.only(top: 20,left: 10,bottom: 20,right: 10),
        pageFormat:PdfPageFormat.roll80,
        build: (context) {
          return dataForTicket == null ? pw.Text('') : pw.ListView(
            children: [


              pw.Text(PgA4==true?"فاتورة ضريبية":'فاتورة ضريبية مبسطة', textAlign: pw.TextAlign.center,
                  textDirection: pw.TextDirection.rtl,
                  style: pw.TextStyle(
                      font: ttf,fontSize:Pdf_fontSize)),
              // pw.Center(child:pw.SizedBox(child: pw.Divider(),width: ScreenSize/9),heightFactor: 0),
              pw.SizedBox(height: 5),

              pw.Text(PgA4==true?'TAX INVOICE':'Simplified Tax Invoice', textAlign: pw.TextAlign.center,
                  //textDirection: pw.TextDirection.rtl,
                  style: pw.TextStyle(fontSize:Pdf_fontSize,
                      decoration:pw.TextDecoration.underline)),

              pw.SizedBox(height: 5),















              pw.SizedBox(height: 10),


              PgA4==true? pw.Row(  mainAxisAlignment:  pw.MainAxisAlignment.spaceBetween,
                  children: [

                    pw.Column(
                        crossAxisAlignment:  pw.CrossAxisAlignment.start,
                        mainAxisAlignment:  pw.MainAxisAlignment.start,
                        children: [

                          pw.Container(

                              width: ScreenSize/1.45,
                              decoration: pw.BoxDecoration(border: pw.Border.all(
                                  color: PdfColors.black) ),
                              child:pw.Padding(padding:pw.EdgeInsets.all(3),
                                child:
                                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                    children: [
                                      pw.Text('Invoice No              : ' +dataForTicket['salesHeader'][0]["voucherNo"].toString(),
                                          style:pw.TextStyle(fontSize:Pdf_fontSize)),



                                      pw.Text(" رقم الفاتورة ${dataForTicket['salesHeader'][0]["voucherNo"].toString()} :             ",
                                          textDirection: pw.TextDirection.rtl,
                                          style: pw.TextStyle(font: ttf,fontSize:Pdf_fontSize)),

                                    ] ),)
                          ),



                          pw.Container(

                              width: ScreenSize/1.45,
                              decoration: pw.BoxDecoration(border: pw.Border.all(
                                  color: PdfColors.black) ),
                              child:pw.Padding(padding:pw.EdgeInsets.all(3),
                                child:
                                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                    children: [
                                      pw.Text('Invoice Issue Date : ' +VchDate.toString(),style:pw.TextStyle(fontSize:Pdf_fontSize)),


                                      pw.Text(" تاريخ إصدار الفاتورة ${VchDate.toString()} :  ",
                                          textDirection: pw.TextDirection.rtl,
                                          style: pw.TextStyle(font: ttf,fontSize:Pdf_fontSize)),

                                    ] ),)
                          ),


                          // pw.SizedBox(height: 10),

                          pw.Container(

                              width: ScreenSize/1.45,
                              decoration: pw.BoxDecoration(border: pw.Border.all(
                                  color: PdfColors.black) ),
                              child:pw.Padding(padding:pw.EdgeInsets.all(3),
                                child:
                                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                    children: [
                                      pw.Text('Date of Supply       : ' +VchDate.toString(),style:pw.TextStyle(fontSize:Pdf_fontSize)),


                                      pw.Text(" تاريخ التوريد ${VchDate.toString()} :           ",
                                          textDirection: pw.TextDirection.rtl,
                                          style: pw.TextStyle(font: ttf,fontSize:Pdf_fontSize)),

                                    ] ),))

                        ]),



                    pw.Padding(padding:pw.EdgeInsets.only(bottom: 5),
                        child: pw.BarcodeWidget(
                          // data: widget.Parm_Id.toString(),
                            data: Qrdata.toString(),
                            barcode: pw.Barcode.qrCode(),
                            width: 50,
                            height: 50
                        ))




                  ]):


              ///---------------------------------------pg 3inch-------------------------------

              pw.Container(

                child:
                pw.Column(
                    crossAxisAlignment:  pw.CrossAxisAlignment.start,
                    mainAxisAlignment:  pw.MainAxisAlignment.start,
                    children: [




                      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Invoice No              : ' +dataForTicket['salesHeader'][0]["voucherNo"].toString(),
                                style:pw.TextStyle(fontSize:Pdf_fontSize)),



                            pw.Text(" رقم الفاتورة ${dataForTicket['salesHeader'][0]["voucherNo"].toString()} :             ",
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(font: ttf,fontSize:Pdf_fontSize)),

                          ] ),


                      pw.SizedBox(height: 2),


                      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Invoice Issue Date : ' +VchDate.toString(),style:pw.TextStyle(fontSize:Pdf_fontSize)),
                            pw.Text(" تاريخ إصدار الفاتورة ${VchDate.toString()} :  ",
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(font: ttf,fontSize:Pdf_fontSize)),

                          ] ),


                      pw.SizedBox(height: 2),

                      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Expanded(child:  pw.Text('VAT Number : ${Companydata['companyProfileGstNo']??""}',style:pw.TextStyle(fontSize:Pdf_fontSize)),),

                            pw.Text("ظريبه الشراء:  ${Companydata['companyProfileGstNo']??""} ",
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(font: ttf,fontSize:Pdf_fontSize)),

                          ] ),

                      //     pw.SizedBox(height: 10),



                    ]),
              ),

              ///---------------------------------------------------------------------------------




              PgA4==true?pw.Directionality(
                textDirection:pw.TextDirection.rtl,
                child:
                // pw.Expanded( child:
                pw.SizedBox(
                  //color:PdfColors.red,
                  child:pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.Expanded(
                          //  height: 300,
                          //  width: Pdf_Width,
                            child:
                            pw.Table.fromTextArray(
                              cellAlignment:pw.Alignment.topRight,
                              cellAlignments:{0: pw.Alignment.topLeft,
                                1:pw.Alignment.topLeft,
                                3:pw.Alignment.topRight,
                                4: pw.Alignment.topLeft,
                                5: pw.Alignment.topLeft,

                              },
                              headerAlignment: pw.Alignment.centerLeft,
                              headerAlignments:{7: pw.Alignment.centerRight,} ,


                              columnWidths:{
                                1: pw.FixedColumnWidth(80),
                                2: pw.FixedColumnWidth(80),
                                5: pw.FixedColumnWidth(80),
                                6: pw.FixedColumnWidth(80),
                              },


                              headerDecoration: pw.BoxDecoration(
                                color:PdfColors.grey400,),
                              headers:
                              [
                                "Seller :",
                                "",
                                "",
                                "المورد:",

                                "Buyer :",
                                "",
                                "",
                                "عميل:",
                              ],

                              data: [
                                [
                                  "Name",
                                  "${Companydata['companyProfileName']??""}",
                                  "${Companydata['companyProfileNameLatin']??""}",
                                  "اسم",

                                  "Name",
                                  "${BuyerDetails[0]['lhName']??""}",
                                  "${BuyerDetails[0]['nameLatin']??""}",
                                  "اسم"
                                ],

                                [
                                  "Building No",
                                  "${Companydata['buildingNo']??""}",
                                  "${Companydata['buildingNoLatin']??""}",
                                  "لا للبناء",

                                  "Building No",
                                  "${BuyerDetails[0]['buildingNo']??""}",
                                  "${BuyerDetails[0]['buildingNoLatin']??""}",
                                  "لا للبناء"
                                ],

                                [
                                  "Street Name",
                                  "${Companydata['streetName']??""}",
                                  "${Companydata['streetNameLatin']??""}",
                                  "اسم الشارع",

                                  "Street Name",
                                  "${BuyerDetails[0]['streetName']??""}",
                                  "${BuyerDetails[0]['streetNameLatin']??""}",
                                  "اسم الشارع"
                                ],


                                [
                                  "District",
                                  "${Companydata['district']??""}",
                                  "${Companydata['districtLatin']??""}",
                                  "يصرف",

                                  "District",
                                  "${BuyerDetails[0]['district']??""}",
                                  "${BuyerDetails[0]['districtLatin']??""}",
                                  "يصرف",
                                ],


                                [
                                  "City",
                                  "${Companydata['city']??""}",
                                  "${Companydata['cityLatin']??""}",
                                  "مدينة",

                                  "City",
                                  "${BuyerDetails[0]['city']??""}",
                                  "${BuyerDetails[0]['cityLatin']??""}",
                                  "مدينة",
                                ],


                                // ["Country","$CountryName",
                                //   "$CountryName","دولة"],
                                [
                                  "Country",
                                  "${Companydata['country']??""}",
                                  "${Companydata['countryLatin']??""}",
                                  "دولة",

                                  "Country",
                                  "${BuyerDetails[0]['country']??""}",
                                  "${BuyerDetails[0]['countryLatin']??""}",
                                  "دولة",
                                ],


                                [
                                  "Postal Code",
                                  "${Companydata['pinNo']??""}",
                                  "${Companydata['pinNoLatin']??""}",
                                  "رمز بريدي",

                                  "Postal Code",
                                  "${BuyerDetails[0]['pinNo']??""}",
                                  "${BuyerDetails[0]['pinNoLatin']??""}",
                                  "رمز بريدي",
                                ],


                                [
                                  "Additional No",
                                  "",
                                  "",
                                  "رقم إضافي",

                                  "Additional No",
                                  "",
                                  "",
                                  "رقم إضافي",
                                ],


                                [
                                  "VAT Number:",
                                  "${Companydata['companyProfileGstNo']??""}",
                                  "${Companydata['companyProfileGstNo']??""}",
                                  "ظريبه الشراء",

                                  "VAT Number:",
                                  "${BuyerDetails[0]['lhGstno']??""}",
                                  "${BuyerDetails[0]['lhGstno']??""}",
                                  "ظريبه الشراء",
                                ],


                                [
                                  "Other Seller ID:",
                                  "",
                                  "",
                                  "معرف البائع الآخر",

                                  "Other Seller ID:",
                                  "",
                                  "",
                                  "معرف البائع الآخر",
                                ],

                              ],
                              headerStyle: pw.TextStyle (font: ttf, fontSize: Pdf_fontSize,color: PdfColors.black),
                              cellStyle: pw.TextStyle (font: ttf, fontSize: Pdf_fontSize,),
                            )),

                      ]),


                  //  pw.SizedBox(width: 2),
                  // pw.SizedBox(
                  //   height: 400,
                  //   width: Pdf_Width/2,
                  //   child: pw.Table.fromTextArray(
                  //     cellAlignment:pw.Alignment.topRight,
                  //     cellAlignments:{0: pw.Alignment.topLeft,3:pw.Alignment.topRight},
                  //     columnWidths:{0: pw.FixedColumnWidth(70),},
                  //      cellHeight: 18.9,
                  //
                  //     headerDecoration: pw.BoxDecoration(
                  //       color:PdfColors.grey400,),
                  //     headers:
                  //     ["Buyer:",
                  //       "",
                  //       "",
                  //       "مشتر:"],
                  //
                  //     data: [
                  //       ["Name",
                  //         "مؤسسة وسائل",
                  //         "مؤسسة وسائل",
                  //         "اسم"],
                  //
                  //       ["Building No",
                  //         "657",
                  //         "657",
                  //         "لا للبناء"],
                  //
                  //       ["Street Name",
                  //         "حائل",
                  //         "حائل",
                  //         "اسم الشارع"],
                  //
                  //
                  //       ["District",
                  //         "حي المحطة",
                  //         "حي المحطة",
                  //         "يصرف"],
                  //
                  //
                  //       ["City","",
                  //         "","مدينة"],
                  //
                  //
                  //       // ["Country","$CountryName",
                  //       //   "$CountryName","دولة"],
                  //       ["Country","المملكة العربية السعودية",
                  //         "المملكة العربية السعودية","دولة"],
                  //
                  //
                  //       ["Postal Code","",
                  //         "","رمز بريدي"],
                  //
                  //
                  //       ["Additional No","",
                  //         "","رقم إضافي"],
                  //
                  //
                  //       ["VAT Number:",
                  //         "300312566500003",
                  //         "300312566500003",
                  //         "ظريبه الشراء"],
                  //
                  //
                  //       ["Other Seller ID:","",
                  //         "","معرف البائع الآخر"],
                  //
                  //     ],
                  //     headerStyle: pw.TextStyle (font: ttf, fontSize: Pdf_fontSize,color: PdfColors.black),
                  //     cellStyle: pw.TextStyle (font: ttf, fontSize: Pdf_fontSize,),
                  //   ),
                  //
                  // ),
                  //





                ),

              ):

              ///-------------------------------3 inc ---------------------------------------------------



              pw.Text(""),

              pw.SizedBox(height:PgA4==true?20:5),



              PgA4==true? pw.Container(
                  decoration: pw.BoxDecoration(
                      color:PdfColors.grey400,
                      border: pw.Border.all(
                          color: PdfColors.black) ),
                  child:pw.Padding(padding:pw.EdgeInsets.all(3),
                    child:
                    pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text("Line Items:",style: pw.TextStyle(fontSize: Pdf_fontSize,font: ttf,color: PdfColors.black)),
                          pw.Text("البنود:",style: pw.TextStyle(fontSize: Pdf_fontSize,font: ttf,color: PdfColors.black),
                            textDirection: pw.TextDirection.rtl,),
                        ]),
                  )
              ): pw.Text(""),



              ///----------------------------------item Table-------------------------------
              // pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              //     children: [

              pw.Container(
                //   width: ScreenSize+(ScreenSize/8),
                //color:  PdfColors.red,
                  child:  pw.Directionality(
                      textDirection:pw.TextDirection.rtl,
                      child:
                      pw.Table.fromTextArray(
                          tableWidth:pw.TableWidth.max ,
                          cellAlignment: pw.Alignment.topRight,
                          cellAlignments:PgA4==true?{0: pw.Alignment.topLeft,}:
                          {0: pw.Alignment.topLeft,},
                          columnWidths:PgA4==true?{7: pw.FixedColumnWidth(100)}:
                          {0: pw.FixedColumnWidth(80),3: pw.FixedColumnWidth(50),1: pw.FixedColumnWidth(40),},

                          cellStyle: pw.TextStyle(font: ttf,fontSize: Pdf_fontSize),
                          headerStyle: pw.TextStyle(fontWeight:pw.FontWeight.bold,font: ttf,fontSize:Pdf_fontSize,),
                          headerAlignment:pw.Alignment.topRight,
                          headerAlignments:PgA4==true?{} :{0: pw.Alignment.topLeft},
                          headerDecoration: pw.BoxDecoration(border: pw
                              .Border(bottom: pw.BorderSide(
                              color: PdfColors.black)),
                              color:PgA4==true?PdfColors.white:PdfColors.grey400),

                          cellPadding:pw.EdgeInsets.all(1),

                          headers:TblHeader,
                          data: TableGenerator()
                      )
                  )
              ),










              pw.SizedBox(height:PgA4==true?20:5),




              PgA4==true?pw.Container(
                  decoration: pw.BoxDecoration(
                      color:PdfColors.grey400,
                      border: pw.Border.all(
                          color: PdfColors.black) ),
                  child:pw.Padding(padding:pw.EdgeInsets.all(3),
                    child:
                    pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text("Total amounts:",style: pw.TextStyle(fontSize: Pdf_fontSize,font: ttf,color: PdfColors.black)),
                          pw.Text("المبالغ الإجمالية:",style: pw.TextStyle(fontSize: Pdf_fontSize,font: ttf,color: PdfColors.black),
                            textDirection: pw.TextDirection.rtl,),
                        ]),
                  )
              ):pw.Text(""),

              PgA4==true?  pw.Directionality(
                textDirection:IsArabic==true? pw.TextDirection.rtl: pw.TextDirection.ltr,
                child:
                pw.Table.fromTextArray(
                    headerAlignments:{1: pw.Alignment.topLeft,2:pw.Alignment.topRight,3:pw.Alignment.centerRight} ,
                    cellAlignments:{1: pw.Alignment.topLeft,2:pw.Alignment.topRight,3:pw.Alignment.centerRight},
                    columnWidths:{0: pw.FixedColumnWidth(100),},
                    headerStyle: pw.TextStyle (font: ttf, fontSize: 10,),
                    cellStyle: pw.TextStyle (font: ttf, fontSize: 10,),


                    headers:




                    ["",
                      "Total (Excluding VAT)",
                      "الإجمالي)باستثناء ضريبة القيمة المضافة(",
                      "${AmountBeforeTax.toStringAsFixed(2)} ${currencyName??""}",
                    ],

                    data: [

                      [   "",
                        "Discount",
                        "خصم",
                        "0.00 ${currencyName??""}",
                      ],

                      [   "",
                        "Total Taxable Amount (Excluding VAT)",
                        "إجمالي المبلغ الخاضع للضريبة )باستثناء ضريبة القيمة المضافة(",
                        "${AmountBeforeTax.toStringAsFixed(2)} ${currencyName??""}",
                      ],



                      [   "",
                        "Total VAT",
                        " ضريبة القيمة المضافة",
                        "${TotalTax==null?0.toStringAsFixed(2):
                        TotalTax.toStringAsFixed(2)} ${currencyName??""}",
                      ],


                      [   "",
                        "Total Amount Due",
                        "إجمالي المبلغ المستحق",
                        "${dataForTicket['salesHeader'][0]["amount"]==null?0.toStringAsFixed(2):
                        dataForTicket['salesHeader'][0]["amount"].toStringAsFixed(2)} ${currencyName??""}",
                      ],


                    ]
                ),
              ):

              ///---------------------------------3 inc -----------------------------------------------

//               pw.Directionality(
//                 textDirection:IsArabic==true? pw.TextDirection.rtl: pw.TextDirection.ltr,
//                 child:
//                 pw.Table.fromTextArray(
//                     headerAlignments:PgA4==true?{1: pw.Alignment.topLeft,2:pw.Alignment.topRight,3:pw.Alignment.centerRight} :
//                     {0: pw.Alignment.topRight,1:pw.Alignment.topRight,2:pw.Alignment.centerRight},
//                     cellAlignments:PgA4==true?{1: pw.Alignment.topLeft,2:pw.Alignment.topRight,3:pw.Alignment.centerRight}:
//                     {0: pw.Alignment.topLeft,1:pw.Alignment.topRight,2:pw.Alignment.centerRight},
//                     // columnWidths:{0: pw.FixedColumnWidth(100),},
//                     headerStyle: pw.TextStyle (font: ttf, fontSize: Pdf_fontSize,),
//                     cellStyle: pw.TextStyle (font: ttf, fontSize: Pdf_fontSize,),
//                     columnWidths:PgA4==true?{}:{2: pw.FixedColumnWidth(100),0: pw.FixedColumnWidth(150),},
//
// border:pw.TableBorder(left: pw.BorderSide.none,
//  bottom: pw.BorderSide(color: PdfColors.black),
// top: pw.BorderSide(color: PdfColors.black),),
//                     headers:
//                     [
//                       "TotalTaxable\tAmount\t(ExcludingVAT)",
//                       "إجمالي المبلغ الخاضع للضريبة (باستثناء ضريبة القيمة المضافة)",
//                       "${AmountBeforeTax.toStringAsFixed(2)}",
//                     ],
//
//                     data: [
//                       [
//                         "Total VAT",
//                         "إجمالي ضريبة القيمة المضافة",
//                         "${TotalTax==null?0.toStringAsFixed(2):
//                         TotalTax.toStringAsFixed(2)}",
//                       ],
//
//
//                       [
//                         "Total Amount Due",
//                         "إجمالي المبلغ المستحق",
//                         "${dataForTicket['salesHeader'][0]["amount"]==null?0.toStringAsFixed(2):
//                         dataForTicket['salesHeader'][0]["amount"].toStringAsFixed(2)}",
//                       ],
//
//
//                     ]
//                 ),
//               ),




              PgA4==true?pw.Text(""):pw.Divider(height: 1,thickness: 1,color: PdfColors.black),
              pw.SizedBox(height:3),
              PgA4==true?pw.Text(""):pw.Column(
                  children: [
                    pw.Row(
                        mainAxisAlignment:pw.MainAxisAlignment.start,
                        // crossAxisAlignment:pw.CrossAxisAlignment.end,
                        children:[

                          pw.Expanded(child:pw.Text("Total Taxable Amount (Excluding VAT)",style: pw.TextStyle(fontSize: Pdf_fontSize,))),
                          pw. Spacer(),
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
                          pw. Spacer(),
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
                          pw. Spacer(),
                          pw.Expanded(child:pw.Text("إجمالي المبلغ المستحق",style: pw.TextStyle(fontSize: Pdf_fontSize,font: ttf,color: PdfColors.black),
                            textDirection: pw.TextDirection.rtl,)),

                          pw. Spacer(),
                          pw.Text("${dataForTicket['salesHeader'][0]["amount"].toStringAsFixed(2)} ${currencyName??""}",style: pw.TextStyle(fontSize: Pdf_fontSize,)), ]),


                    pw.SizedBox(height:5),

                    LgrBalanceShow==true?
                             pw.Row(
                        mainAxisAlignment:pw.MainAxisAlignment.spaceAround,
                        children:[

                          pw.Expanded(child:pw.Text("Current Balance (As on $VchDate)",style: pw.TextStyle(fontSize: Pdf_fontSize,))),
                          pw. Spacer(),
                          pw.Expanded(child:pw.Text(" الرصيد  الحالي )كمافي  ($VchDate  ",style: pw.TextStyle(fontSize: Pdf_fontSize,font: ttf,color: PdfColors.black),
                            textDirection: pw.TextDirection.rtl,)),

                          pw. Spacer(),
                          pw.Text(" $opType ${LedgerBalance.toStringAsFixed(2)}",style: pw.TextStyle(fontSize: Pdf_fontSize,)), ])




              : pw.Text("")


                  ]),





              pw.SizedBox( height: 5,),

              PgA4==true?pw.Text("") : pw.Padding(padding:pw.EdgeInsets.only(bottom: 5),
                  child: pw.BarcodeWidget(
                    // data: widget.Parm_Id.toString(),
                      data: Qrdata.toString(),
                      barcode: pw.Barcode.qrCode(),
                      width: 50,
                      height: 50
                  )),


              pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children:[
                    pw.SizedBox(
                      height: 2,),


                    pw.SizedBox(
                      width: 20,),
                    pw.SizedBox(height: 2),


                    // pw.SizedBox(height: 50,width: 100,child:
                    // pw.BarcodeWidget(
                    //     data: widget.Parm_Id.toString(),
                    //     barcode: pw.Barcode.code39(),
                    //     width: 100,
                    //     height: 50
                    // ),
                    // )

                  ]),

              //   pw.SizedBox(height: 2),
              //   pw.Text(footerCaptions[0]['footerText']+"...",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,font: ttf,fontSize: Pdf_fontSize))

            ],


          );
        },
      ),
    );

    return pdf.save();
  }



















  var TblHeader;
  TableGenerator() {
    //   PgA4==true?TblHeader= ['Amount\n المجموع', 'TaxAmt\n مبلغ الضريبة', 'Tax%\n  الضريبة٪',"Total\n مجموع", 'Qty\n كمية', 'Price\n  معدل\n','Unit\n وحدة', 'name\tItem\n التفاصيل','No\n عدد']:
    PgA4==true?TblHeader= [
      'طبيعة السلع  أو الخدمات  Nature of goods or services ',

      'Price\tUnit\n سعر الوحدة',

      'Quantity\n كمية',

      "Amount\tTaxable\n المبلغ الخاضع للضريبة",

      'Discount\n خصم',

      'Rate\tTax\n معدل الضريبة',

      'Amount\tTax\n قيمة الضريبة',

      'ItemSubtotal\n (Including VAT)   البند المجموع الفرعي )متضمنًا ضريبة القيمة المضافة(',
    ]:
    TblHeader= [
      // 'طبيعة السلع  أو الخدمات  Nature of goods or services ',
      //'طبيعة السلع  أو الخدمات   Nature of goods or services',
      'or\tgoods\tof\tNature\tservices\n'+' طبيعة السلع  أو الخدمات',
      'Price\tUnit\n سعر الوحدة',
      'Quantity\n كمية',
      '(Including VAT) Item Subtotal  المجموع )شامل ضریبة القیمة المضافة('


      //'(IncludingVAT)\n  ItemSubtotal    (بما في ذلك ضريبة القيمة المضافة)  المجموع الفرعي للعنصر  ',
    ];





    var purchasesAsMap;

    if(PgA4==true) {
      var Slnum=0;
      purchasesAsMap = <Map<String, String>>[
        for(int i = 0; i < Detailspart.length; i++)
          {

            "ItemName": "${Detailspart[i]['itmArabicName']??""} ${Detailspart[i]['itmName']??""} ",
            "Rate": "${Detailspart[i]['rate'].toStringAsFixed(2)} ",
            "Qty": "${Detailspart[i]['qty']} ",
            "total": "${(Detailspart[i]['qty']??0.0)*(Detailspart[i]['rate']??0.0)} ",
            "discount": "0.0",
            "TaxPer": "${Detailspart[i]['taxPercentage']==null?"0.00":Detailspart[i]['taxPercentage'].toStringAsFixed(2)} ",
            "TaxAmt": "${Detailspart[i]['taxAmount'].toStringAsFixed(2)=="0.00"?"":Detailspart[i]['taxAmount'].toStringAsFixed(2)} ",
            "NetAmt": "${Detailspart[i]['amountIncludingTax'].toStringAsFixed(2)} ",





            // "NetAmt": "${Detailspart[i]['amountIncludingTax'].toStringAsFixed(2)} ",
            // //"sssf": "${CalculateTaxAmt((Detailspart[i]['rate']),(Detailspart[i]['qty']),(Detailspart[i]['taxPercentage']))} ",
            // "TaxAmt": "${Detailspart[i]['taxAmount'].toStringAsFixed(2)=="0.00"?"":Detailspart[i]['taxAmount'].toStringAsFixed(2)} ",
            // "TaxPer": "${Detailspart[i]['taxPercentage']==null?"0.00":Detailspart[i]['taxPercentage'].toStringAsFixed(2)} ",
            // "total": "${(Detailspart[i]['qty']??0.0)*(Detailspart[i]['rate']??0.0)} ",
            // "Qty": "${Detailspart[i]['qty']} ",
            // "Rate": "${Detailspart[i]['rate'].toStringAsFixed(2)} ",
            // "Unit": "${Detailspart[i]['uom']??""} ",
            // "ItemName": "${Detailspart[i]['itmName']??""} ${Detailspart[i]['itmArabicName']??""}",
            // "No": "${(++Slnum).toString()} ",

          },
      ];
    }  else{
      purchasesAsMap = <Map<String, String>>[
        for(int i = 0; i < Detailspart.length; i++)
          {
            "ItemName": "${Detailspart[i]['itmArabicName']??""} ${Detailspart[i]['itmName']??""}  ",
            "Rate": "${Detailspart[i]['rate'].toStringAsFixed(2)} ",
            // "total": "${(Detailspart[i]['qty']??0.0)*(Detailspart[i]['rate']??0.0)} ",
            "Qty": "${Detailspart[i]['qty']} ",
            "NetAmt": "${Detailspart[i]['amountIncludingTax'].toStringAsFixed(2)} ",
          },
      ];
    }



    List<List<String>> listOfPurchases = [];
    for (int i = 0; i < purchasesAsMap.length; i++) {
      listOfPurchases.add(purchasesAsMap[i].values.toList());
    }
    return listOfPurchases;
  }




  // ['Amount المجموع', 'TaxAmt\n مبلغ الضريبة', 'Tax% الضريبة٪', 'Qty\n كمية', 'Price معدل', 'name\tItem\n التفاصيل']


  Pagetype(pgTyp){
    if(pgTyp=="3 Inch"|| pgTyp=="A4"){

      Navigator.of(context,rootNavigator: true).pop();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Pdf_Print(Parm_Id:widget.Parm_Id,Page_Type:pgTyp=="A4"?"A4":"3 Inch")));


    }else{


      setState(() {
        Pg_2_Inch=false;
        pgTyp == "Tax Invoice" ? PgA4 = true : PgA4 = false;
        PgA4 == true ?
        TblHeader = <dynamic>  [
          'طبيعة السلع  أو الخدمات  Nature of goods or services ',

          'Price\tUnit\n سعر الوحدة',

          'Quantity\n كمية',

          "Amount\tTaxable\n المبلغ الخاضع للضريبة",

          'Discount\n خصم',

          'Rate\tTax\n معدل الضريبة',

          'Amount\tTax\n قيمة الضريبة',

          'ItemSubtotal\n (Including VAT)   البند المجموع الفرعي )متضمنًا ضريبة القيمة المضافة(',
        ]:
        TblHeader = <dynamic>
        [
          'or\tgoods\tof\tNature\tservices\n'+' طبيعة السلع  أو الخدمات',
          'Price\tUnit\n سعر الوحدة',
          'Quantity\n كمية',
          '(Including VAT) Item Subtotal  المجموع )شامل ضریبة القیمة المضافة('
        ];
        print("PgA4");
        print(PgA4);

      });

    }



  }




}
















// import 'dart:convert';
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
// class New_Model_PdfPrint extends StatefulWidget {
//   var Parm_Id;
//   New_Model_PdfPrint({this.Parm_Id});
//
//   @override
//   _New_Model_PdfPrintState createState() => _New_Model_PdfPrintState();
// }
//
// class _New_Model_PdfPrintState extends State<New_Model_PdfPrint> {
//
//   Pdf_Two_Inch Pdf_2=Pdf_Two_Inch();
//
//   SharedPreferences pref;
//   dynamic branch;
//   var res;
//   dynamic user;
//   int branchId;
//   int userId;
//   UserData userData;
//   String branchName = "";
//   dynamic userName;
//   String token;
//   // var DateTimeFormat = new DateFormat('dd-MM-yyyy hh a');
//   var DateTimeFormat = new DateFormat('dd-MM-yyyy');
//   String Datetime_Now = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());
//   var Detailspart;
//   var dataForTicket;
//   var footerCaptions;
//   var  Companydata;
//   bool IsArabic=false;
//   bool PgA4=true;
//   bool Pg_2_Inch=false;
//   String IsArabicChkBoxText="Arabic";
//   var  TaxType;
//
//   // double Pdf_Width=800.0;
//   NumberToWord arabicAmount = NumberToWord();
//
//
//   void initState() {
//     setState(() {
//       SharedPreferences.getInstance().then((value) {
//         pref = value;
//         read();
//         GetdataPrint(widget.Parm_Id);
//         footerdata();
//         GetQrdata();
//         GeneralSettings();
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
//
//     });
//     var CD=await GetCompantPro(branchId);
//   }
//
//
//
//
//   GeneralSettings()async{
//
//
//     final res =
//     await http.get("${Env.baseUrl}generalSettings", headers: {
//       "Authorization": user.user["token"],
//     });
//
//     if(res.statusCode<210) {
//       print(res);
//       var GenSettingsData = json.decode(res.body);
//       print(GenSettingsData[0]["applicationTaxTypeGst"]);
//       setState(() {
//         GenSettingsData[0]["applicationTaxTypeGst"] ==true ?
//         TaxType = "Gst.No" : TaxType = "Vat.No";
//         print("TaxType");
//         print(TaxType);
//
//       });
//     }
//   }
//
//
//
//   footerdata() async {
//     try {
//       print("footer data decoded  ");
//       final tagsJson =
//       await http.get("${Env.baseUrl}SalesInvoiceFooters/", headers: {
//         "Authorization": user.user["token"],
//       });
//       var footerdata =await jsonDecode(tagsJson.body);
//       setState(() {
//         footerCaptions = footerdata;
//         // print( "on footerCaptions :" +footerCaptions.toString());
//       });
//
//     } catch (e) {
//       print(e);
//     }
//   }
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
//         print( "QR datas :" +Qrdata.toString());
//       });
//
//     } catch (e) {
//       print(e);
//     }
//   }
//
//
//   GetCompantPro(id)async{
//     print("GetCompantPro");
//     print(id.toString());
//     try {
//       final tagsJson =
//       await http.get("${Env.baseUrl}MCompanyProfiles/$id", headers: {
//         //Soheader //SalesHeaders
//         "Authorization": user.user["token"],
//       });
//       if(tagsJson.statusCode==200) {
//         Companydata = await jsonDecode(tagsJson.body);
//       }
//       print( "on GetCompantPro :" +Companydata.toString());
//       print(  Companydata['companyProfileAddress1'].toString());
//     }
//     catch(e){
//       print("error on GetCompantPro : $e");
//     }
//   }
//
//
//   var  VchDate;
//   var  InvTime;
//   var TotalTax=0.0;
//   var AmountBeforeTax=0.0;
//   var TotalQty=0.0;
//
//   GetdataPrint(id) async {
//     print("sales for print : $id");
//     double amount = 0.0;
//     try {
//       final tagsJson =
//       await http.get("${Env.baseUrl}SalesHeaders/$id", headers: {
//         //Soheader //SalesHeaders
//         "Authorization": user.user["token"],
//       });
//
//
//       dataForTicket = await jsonDecode(tagsJson.body);
//
//       var ParseDate=dataForTicket['salesHeader'][0]["voucherDate"]??"2022-01-01T00:00:00";
//       // DateTime tempDate = new DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(ParseDate);
//       DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(ParseDate);
//       print(dataForTicket['salesHeader'][0]["voucherDate"]);
//       VchDate=DateTimeFormat.format(tempDate);
//       print(VchDate.toString());
//
//
//       var  tempTime=dataForTicket['salesHeader'][0]["entryDate"]??"2022-01-01T00:00:00";
//       DateTime tempTimeFormate = new DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(tempTime);
//       InvTime= DateFormat.jm().format(tempTimeFormate);
//       // print("tempTime");
//       // print(tempTime);
//       // print("tempTimeFormate");
//       // print(tempTimeFormate);
//       // print("InvTime");
//       // print(InvTime);
//
//
//       Detailspart = dataForTicket['salesDetails'];
//       var  Pattern=Detailspart[0]['itmName'];
//
//
//       print(Detailspart[0]['rate'].runtimeType);
//       print(Detailspart[0]['taxPercentage'].runtimeType);
//       for(int i = 0; i < Detailspart.length; i++)
//       {
//
//         double qty=Detailspart[i]['qty']==null?0.0:(Detailspart[i]['qty']);
//         double rate=Detailspart[i]['rate']==null?0.0:(Detailspart[i]['rate']);
//         double varTxPer=Detailspart[i]['taxPercentage']==null?0.0:(Detailspart[i]['taxPercentage']);
//         double itemTaxrate=Detailspart[i]['taxAmount']??0.0;
//         //  double itemTaxrate=await CalculateTaxAmt(rate,qty,varTxPer);
//         TotalTax=TotalTax+itemTaxrate;
//         TotalQty=TotalQty+qty;
//         AmountBeforeTax=AmountBeforeTax+Detailspart[i]['amountBeforeTax'];
//       }
//       print("TotalTax");
//       print(TotalTax.toString());
//       // if (Pattern.contains(RegExp(r'[a-zA-Z]'))) {
//       //   print("rtertre");
//       //
//       // }else{
//       //   print("Nope, Other characters detected");
//       //   IsArabic=true;
//       // }
//
//       GetArabicAmount(dataForTicket['salesHeader'][0]["amount"]);
//
//       setState(() {
//         IsArabic=true;
//       });
//     } catch (e) {
//       print('error on databinding $e');
//     }
//   }
//
//   //String dropdownValue = '3 Inch';
//   String dropdownValue = 'A4';
//
//
//   var  AmtInWrds="";
//   GetArabicAmount(Amount){
//   //  AmtInWrds= arabicAmount.NumberInRiyals(Amount);
//
//   }
//
//
//
//   //
//   // CalculateTaxAmt(double rate,double qty,double taxper){
//   //
//   //   double  _rate=rate??0.0;
//   //   double  _qty=qty??0.0;
//   //   double  _taxper=taxper??0.0;
//   //
//   //
//   //   double Tax=((_rate/100)*_taxper);
//   //   double  TotTax=(Tax*_qty);
//   //   return TotTax;
//   // }
//   ///---------------------------------------------
//
//   @override
//   Widget build(BuildContext context) {
//     var ScreenSize=MediaQuery.of(context).size.width;
//     var ScreenHeight=MediaQuery.of(context).size.height;
//
//     return
//       SafeArea(
//         child: Scaffold(
//           appBar: PreferredSize(preferredSize: Size.fromHeight(80),
//             child: Appbarcustomwidget(uname: userName, branch:branchName, pref: pref, title:"Print"),),
//
//           body: dataForTicket == null ? SizedBox(height: ScreenHeight,width: ScreenSize,
//               child: Center(child: Text("Loading..."))) :
//           Companydata == null ? SizedBox(height: ScreenSize,width: ScreenSize,
//               child: Center(child: Text("Loading..."))) :
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
//           floatingActionButton: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(top: 20,left: 10,right: 20),
//                 child: Container(height: 30,
//                   child:  DropdownButton(
//                     underline:Container(color: Colors.transparent),
//                     icon:Center(child: Text("Paper : $dropdownValue  ▼",style: TextStyle(color: Colors.white),)),
//
//                     items:[
//                       DropdownMenuItem<String>(
//                         value: "A4",
//                         child: Text(
//                           "A4",
//                         ),
//                       ),
//                       DropdownMenuItem<String>(
//                         value: "3 Inch",
//                         child: Text(
//                           "3 Inch",
//                         ),
//                       ),
//                       DropdownMenuItem<String>(
//                         value: "2 Inch",
//                         child: Text(
//                           "2 Inch",
//                         ),
//                       ),
//                     ],
//                     onChanged: (String newValue) {
//                       setState(() {
//                         dropdownValue = newValue;
//                         Pagetype(dropdownValue);
//                         if(dropdownValue== "2 Inch"){
//                           Pg_2_Inch=true;
//                         }
//                       });
//                     },
//
//                   ),
//                 ),
//               ),
//
//
//               InkWell(
//                   onTap: (){
//                     setState(() {
//                       IsArabic = !IsArabic;
//                       IsArabic==false?IsArabicChkBoxText="Arabic":IsArabicChkBoxText="English";
//                       TableGenerator();
//                     });
//                   },
//
//                   child: Container(height: 30,width: 100,
//                       child: Align(alignment: Alignment.bottomLeft,
//                           child: Text(IsArabicChkBoxText,style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 20),)))),
//
//
//             ],
//           ),
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
//     final Pdf_fontSize=6.7;
//     final Pdf_Width=570.0;
//     pdf.addPage(
//       pw.Page(
//         margin:pw.EdgeInsets.only(top: 20,left: 10,bottom: 20,right: 10),
//         pageFormat:PgA4==true? PdfPageFormat.a4:PdfPageFormat.roll80,
//         build: (context) {
//           return dataForTicket == null ? pw.Text('') : pw.ListView(
//                 children: [
//
//
//                   pw.Text("فاتورة ضريبية", textAlign: pw.TextAlign.center,
//                       textDirection: pw.TextDirection.rtl,
//                       style: pw.TextStyle(
//                         font: ttf,fontSize:Pdf_fontSize)),
//                  // pw.Center(child:pw.SizedBox(child: pw.Divider(),width: ScreenSize/9),heightFactor: 0),
//                   pw.SizedBox(height: 5),
//
//                   pw.Text('TAX INVOICE', textAlign: pw.TextAlign.center,
//                       //textDirection: pw.TextDirection.rtl,
//                       style: pw.TextStyle(fontSize:Pdf_fontSize,
//                           decoration:pw.TextDecoration.underline)),
//
//                   pw.SizedBox(height: 5),
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
// pw.SizedBox(height: 10),
//
//
//       pw.Row(  mainAxisAlignment:  pw.MainAxisAlignment.spaceBetween,
//           children: [
//
//           pw.Column(
//               crossAxisAlignment:  pw.CrossAxisAlignment.start,
//               mainAxisAlignment:  pw.MainAxisAlignment.start,
//               children: [
//
//                 pw.Container(
//
//                     width: ScreenSize/1.2,
//                     decoration: pw.BoxDecoration(border: pw.Border.all(
//                         color: PdfColors.black) ),
//                     child:pw.Padding(padding:pw.EdgeInsets.all(3),
//                       child:
//                       pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                           children: [
//                             pw.Text('Invoice No              : ' +dataForTicket['salesHeader'][0]["voucherNo"].toString(),
//                                 style:pw.TextStyle(fontSize:Pdf_fontSize)),
//
//
//
//                             pw.Text(" رقم الفاتورة ${dataForTicket['salesHeader'][0]["voucherNo"].toString()} :             ",
//                                 textDirection: pw.TextDirection.rtl,
//                                 style: pw.TextStyle(font: ttf,fontSize:Pdf_fontSize)),
//
//                           ] ),)
//                 ),
//
//
//
//                 pw.Container(
//
//             width: ScreenSize/1.2,
//             decoration: pw.BoxDecoration(border: pw.Border.all(
//                 color: PdfColors.black) ),
//             child:pw.Padding(padding:pw.EdgeInsets.all(3),
//               child:
//               pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                   children: [
//                     pw.Text('Invoice Issue Date : ' +VchDate.toString(),style:pw.TextStyle(fontSize:Pdf_fontSize)),
//
//
//                     pw.Text(" تاريخ إصدار الفاتورة ${VchDate.toString()} :  ",
//                         textDirection: pw.TextDirection.rtl,
//                         style: pw.TextStyle(font: ttf,fontSize:Pdf_fontSize)),
//
//                   ] ),)
//         ),
//
//
//         // pw.SizedBox(height: 10),
//
//         pw.Container(
//
//             width: ScreenSize/1.2,
//             decoration: pw.BoxDecoration(border: pw.Border.all(
//                 color: PdfColors.black) ),
//             child:pw.Padding(padding:pw.EdgeInsets.all(3),
//               child:
//               pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                   children: [
//                     pw.Text('Date of Supply       : ' +VchDate.toString(),style:pw.TextStyle(fontSize:Pdf_fontSize)),
//
//
//                     pw.Text(" تاريخ التوريد ${VchDate.toString()} :           ",
//                         textDirection: pw.TextDirection.rtl,
//                         style: pw.TextStyle(font: ttf,fontSize:Pdf_fontSize)),
//
//                   ] ),))
//
//       ]),
//
//
//
//         pw.Padding(padding:pw.EdgeInsets.only(bottom: 5),
//             child: pw.BarcodeWidget(
//               // data: widget.Parm_Id.toString(),
//                 data: Qrdata.toString(),
//                 barcode: pw.Barcode.qrCode(),
//                 width: 50,
//                 height: 50
//             ))
//
//
//
//
//       ]),
//
//
//
//
//           pw.Directionality(
//           textDirection:pw.TextDirection.rtl,
//           child:  pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               children: [
//
//           pw.SizedBox(
//             width: Pdf_Width/2,
//             child: pw.Table.fromTextArray(
//               cellAlignments:{0: pw.Alignment.topLeft,3:pw.Alignment.topRight},
// columnWidths:{0: pw.FixedColumnWidth(70),},
//
//
// headerDecoration: pw.BoxDecoration(
//   color:PdfColors.grey400,),
//               headers:
//               ["Seller :",
//                 "",
//                 "",
//                 "تاجر:",
//                 ],
//
//                 data: [
//                 ["Name",
//                 "${Companydata['companyProfileName']??""}",
//                 "${Companydata['companyProfileName']??""}",
//                 "اسم"],
//
//                 ["Building No",  "${Companydata['companyProfileAddress1']??""}",
//                   "${Companydata['companyProfileAddress1']??""}",
//                   "لا للبناء"],
//
//                 ["Street Name",  "${Companydata['companyProfileAddress2']??""}",
//                   "${Companydata['companyProfileAddress2']??""}","اسم الشارع"],
//
//
//                 ["District",  "${Companydata['companyProfileAddress3']??""}",
//                   "${Companydata['companyProfileAddress3']??""}","يصرف"],
//
//
//                 ["City","","","مدينة"],
//
//
//                 ["Country","",
//                   "","دولة"],
//
//
//                 ["Postal Code","",
//                   "","رمز بريدي"],
//
//
//                 ["Additional No","",
//                   "","رقم إضافي"],
//
//
//                 ["VAT Number:","${Companydata['companyProfileGstNo']??""}",
//                   "${Companydata['companyProfileGstNo']??""}","ظريبه الشراء"],
//
//
//                 ["Other Seller ID:","",
//                   "","معرف البائع الآخر"],
//
//                 ],
//               headerStyle: pw.TextStyle (font: ttf, fontSize: Pdf_fontSize,color: PdfColors.black),
//               cellStyle: pw.TextStyle (font: ttf, fontSize: Pdf_fontSize,),
//             ),
//
//           ),
//
//
//         //  pw.SizedBox(width: 2),
//
//
//           pw.SizedBox(
//             width: Pdf_Width/2,
//             child: pw.Table.fromTextArray(
//               cellAlignments:{0: pw.Alignment.topLeft,3:pw.Alignment.centerRight},
//               columnWidths:{0: pw.FixedColumnWidth(70),},
// headerDecoration: pw.BoxDecoration(
//           color:PdfColors.grey400,),
//
//               headers:
//
//
//
//
//               ["Buyer:",
//                 "",
//                 "",
//                 "مشتر:"],
//
//               data: [
//                 ["Name",
//                   "${Companydata['companyProfileName']??""}",
//                   "${Companydata['companyProfileName']??""}",
//                   "اسم"],
//
//                 ["Building No",  "${Companydata['companyProfileAddress1']??""}",
//                   "${Companydata['companyProfileAddress1']??""}",
//                   "لا للبناء"],
//
//                 ["Street Name",  "${Companydata['companyProfileAddress2']??""}",
//                   "${Companydata['companyProfileAddress2']??""}","اسم الشارع"],
//
//
//                 ["District",  "${Companydata['companyProfileAddress3']??""}",
//                   "${Companydata['companyProfileAddress3']??""}","يصرف"],
//
//
//                 ["City","","","مدينة"],
//
//
//                 ["Country","",
//                   "","دولة"],
//
//
//                 ["Postal Code","",
//                   "","رمز بريدي"],
//
//
//                 ["Additional No","",
//                   "","رقم إضافي"],
//
//
//                 ["VAT Number:","${Companydata['companyProfileGstNo']??""}",
//                   "${Companydata['companyProfileGstNo']??""}","ظريبه الشراء"],
//
//
//                 ["Other Seller ID:","",
//                   "","معرف البائع الآخر"],
//
//               ],
//               headerStyle: pw.TextStyle (font: ttf, fontSize: Pdf_fontSize,color: PdfColors.black),
//               cellStyle: pw.TextStyle (font: ttf, fontSize: Pdf_fontSize,),
//
//             ),
//
//           )
//
//
//
//
//         ]),
//
//           ),
//
//
//                   pw.SizedBox(height: 20),
//
//
//
//                   pw.Container(
//                       decoration: pw.BoxDecoration(
//                         color:PdfColors.grey400,
//                           border: pw.Border.all(
//                           color: PdfColors.black) ),
//                       child:pw.Padding(padding:pw.EdgeInsets.all(3),
//                         child:
//                         pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                             children: [
//                               pw.Text("Line Items:",style: pw.TextStyle(fontSize: Pdf_fontSize,font: ttf,color: PdfColors.black)),
//                               pw.Text("البنود:",style: pw.TextStyle(fontSize: Pdf_fontSize,font: ttf,color: PdfColors.black),
//                                 textDirection: pw.TextDirection.rtl,),
//                             ]),
//                       )
//                   ),
//
//
//
// ///----------------------------------item Table-------------------------------
//                   // pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                   //     children: [
//
//                         pw.Container(
//                          //   width: ScreenSize+(ScreenSize/8),
//                             //color:  PdfColors.red,
//                             child:  pw.Directionality(
//                                 textDirection:pw.TextDirection.rtl,
//                                 child:
//                                 pw.Table.fromTextArray(
//                                     tableWidth:pw.TableWidth.max ,
//                                     cellAlignment: pw.Alignment.topRight,
//                                      cellAlignments:{0: pw.Alignment.topLeft,},
//                                      columnWidths:{7: pw.FixedColumnWidth(100)},
//
//
//                                     cellStyle: pw.TextStyle(font: ttf,fontSize: Pdf_fontSize),
//                                     headerStyle: pw.TextStyle(fontWeight:pw.FontWeight.bold,font: ttf,fontSize:Pdf_fontSize,),
//                                     headerAlignment:pw.Alignment.topRight,
//                                    // headerAlignments: {7: pw.Alignment.center},
//                                     headerDecoration: pw.BoxDecoration(border: pw
//                                         .Border(bottom: pw.BorderSide(
//                                         color: PdfColors.black))),
//
//                                     cellPadding:pw.EdgeInsets.all(1),
//
//
//                                     headers:TblHeader,
//                                     data: TableGenerator()
//                                 )
//                             )
//                         ),
//
//
//
//
//
//
//
//
//
//
//                   pw.SizedBox(height: 20),
//
//
//
//                   pw.Container(
//                       decoration: pw.BoxDecoration(
//                           color:PdfColors.grey400,
//                           border: pw.Border.all(
//                           color: PdfColors.black) ),
//                       child:pw.Padding(padding:pw.EdgeInsets.all(3),
//                         child:
//                         pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                             children: [
//                               pw.Text("Total amounts:",style: pw.TextStyle(fontSize: Pdf_fontSize,font: ttf,color: PdfColors.black)),
//                               pw.Text("المبالغ الإجمالية:",style: pw.TextStyle(fontSize: Pdf_fontSize,font: ttf,color: PdfColors.black),
//                                 textDirection: pw.TextDirection.rtl,),
//                             ]),
//                       )
//                   ),
//
//           pw.Directionality(
//           textDirection:IsArabic==true? pw.TextDirection.rtl: pw.TextDirection.ltr,
//           child:
//            pw.Table.fromTextArray(
//          headerAlignments:{1: pw.Alignment.topLeft,2:pw.Alignment.topRight,3:pw.Alignment.centerRight} ,
//           cellAlignments:{1: pw.Alignment.topLeft,2:pw.Alignment.topRight,3:pw.Alignment.centerRight},
//           columnWidths:{0: pw.FixedColumnWidth(100),},
//           headerStyle: pw.TextStyle (font: ttf, fontSize: 10,),
//           cellStyle: pw.TextStyle (font: ttf, fontSize: 10,),
//
//
//           headers:
//
//
//
//
//           ["",
//             "Total (Excluding VAT):",
//           "الإجمالي)باستثناء ضريبة القيمة المضافة(",
//           "${AmountBeforeTax.toStringAsFixed(2)}",
//          ],
//
//           data: [
//
//             [   "",
//               "Discount",
//               "خصم",
//               "0.00",
//             ],
//
//             [   "",
//               "Total Taxable Amount (Excluding VAT)",
//               "إجمالي المبلغ الخاضع للضريبة )باستثناء ضريبة القيمة المضافة(",
//               "${AmountBeforeTax.toStringAsFixed(2)}",
//             ],
//
//
//
//             [   "",
//                "Total VAT",
//              "إجمالي ضريبة القيمة المضافة",
//              "${TotalTax==null?0.toStringAsFixed(2):
//              TotalTax.toStringAsFixed(2)}",
//              ],
//
//
//             [   "",
//                "Total Amount Due",
//              "إجمالي المبلغ المستحق",
//              "${dataForTicket['salesHeader'][0]["amount"]==null?0.toStringAsFixed(2):
//              dataForTicket['salesHeader'][0]["amount"].toStringAsFixed(2)}",
//              ],
//
//
//           ]
//            ),
//           ),
//
//
//
//         //  pw.Divider(height: 2,thickness: 2),
//
//
//
//
//
//
//
//                   pw.SizedBox( height: 2,),
//
//
//
//
//                   pw.Row(
//                       crossAxisAlignment: pw.CrossAxisAlignment.start,
//                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                       children:[
//                         pw.SizedBox(
//                           height: 2,),
//
//
//                         pw.SizedBox(
//                           width: 20,),
//                         pw.SizedBox(height: 2),
//
//
//                         // pw.SizedBox(height: 50,width: 100,child:
//                         // pw.BarcodeWidget(
//                         //     data: widget.Parm_Id.toString(),
//                         //     barcode: pw.Barcode.code39(),
//                         //     width: 100,
//                         //     height: 50
//                         // ),
//                         // )
//
//                       ]),
//
//                   pw.SizedBox(height: 2),
//                   pw.Text(footerCaptions[0]['footerText']+"...",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,font: ttf,fontSize: Pdf_fontSize))
//
//                 ],
//
//
//           );
//         },
//       ),
//     );
//
//     return pdf.save();
//   }
//
//   pw.Container Seller_Buyer_Table({
//     double Pdf_fontSize,
//     pw.Font ttf,
//     String Arabic_Label,
//     String Label,
//     dynamic dataValue
//   })
//   {
//     return pw.Container(
//     decoration: pw.BoxDecoration(border: pw.Border.all(
//         color: PdfColors.black) ),
//     child:pw.Padding(padding:pw.EdgeInsets.all(3),
//       child:
//       pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end,
//           children: [
//             pw.Text('$Label : ',style:pw.TextStyle(fontSize:Pdf_fontSize)),
//
//
//             pw.Text(" : $Arabic_Label${dataValue.toString()}",
//                 textDirection: pw.TextDirection.rtl,
//                 style: pw.TextStyle(font: ttf,fontSize:Pdf_fontSize)),
//
//           ] ),)
// );
//   }
//
//
//
// var b="";
// var a="";
//
//
//   var TblHeader;
//   TableGenerator() {
//    //   PgA4==true?TblHeader= ['Amount\n المجموع', 'TaxAmt\n مبلغ الضريبة', 'Tax%\n  الضريبة٪',"Total\n مجموع", 'Qty\n كمية', 'Price\n  معدل\n','Unit\n وحدة', 'name\tItem\n التفاصيل','No\n عدد']:
//       PgA4==true?TblHeader= [
//         'طبيعة السلع  أو الخدمات  Nature of goods or services ',
//
//         'Price\tUnit\n سعر الوحدة',
//
//         'Quantity\n كمية',
//
//         "Amount\tTaxable\n المبلغ الخاضع للضريبة",
//
//         'Discount\n خصم',
//
//         'Rate\tTax\n معدل الضريبة',
//
//         'Amount\tTax\n قيمة الضريبة',
//
//         'ItemSubtotal\n (Including VAT)   البند المجموع الفرعي )متضمنًا ضريبة القيمة المضافة(',
//       ]:
//       TblHeader= ['Amount  المجموع', 'Tax% الضريبة٪', 'Qty كمية', 'Price معدل', 'Item name التفاصيل\n'];
//
//
//
//
//
//     var purchasesAsMap;
//
//       if(PgA4==true) {
//         var Slnum=0;
//         purchasesAsMap = <Map<String, String>>[
//           for(int i = 0; i < Detailspart.length; i++)
//             {
//
//                "ItemName": "${Detailspart[i]['itmName']??""} ${Detailspart[i]['itmArabicName']??""}",
//               "Rate": "${Detailspart[i]['rate'].toStringAsFixed(2)} ",
//               "Qty": "${Detailspart[i]['qty']} ",
//               "total": "${(Detailspart[i]['qty']??0.0)*(Detailspart[i]['rate']??0.0)} ",
//               "discount": "0.0",
//               "TaxPer": "${Detailspart[i]['taxPercentage']==null?"0.00":Detailspart[i]['taxPercentage'].toStringAsFixed(2)} ",
//               "TaxAmt": "${Detailspart[i]['taxAmount'].toStringAsFixed(2)=="0.00"?"":Detailspart[i]['taxAmount'].toStringAsFixed(2)} ",
//               "NetAmt": "${Detailspart[i]['amountIncludingTax'].toStringAsFixed(2)} ",
//
//
//
//
//
//               // "NetAmt": "${Detailspart[i]['amountIncludingTax'].toStringAsFixed(2)} ",
//               // //"sssf": "${CalculateTaxAmt((Detailspart[i]['rate']),(Detailspart[i]['qty']),(Detailspart[i]['taxPercentage']))} ",
//               // "TaxAmt": "${Detailspart[i]['taxAmount'].toStringAsFixed(2)=="0.00"?"":Detailspart[i]['taxAmount'].toStringAsFixed(2)} ",
//               // "TaxPer": "${Detailspart[i]['taxPercentage']==null?"0.00":Detailspart[i]['taxPercentage'].toStringAsFixed(2)} ",
//               // "total": "${(Detailspart[i]['qty']??0.0)*(Detailspart[i]['rate']??0.0)} ",
//               // "Qty": "${Detailspart[i]['qty']} ",
//               // "Rate": "${Detailspart[i]['rate'].toStringAsFixed(2)} ",
//               // "Unit": "${Detailspart[i]['uom']??""} ",
//               // "ItemName": "${Detailspart[i]['itmName']??""} ${Detailspart[i]['itmArabicName']??""}",
//               // "No": "${(++Slnum).toString()} ",
//
//             },
//         ];
//       }  else{
//         purchasesAsMap = <Map<String, String>>[
//           for(int i = 0; i < Detailspart.length; i++)
//             {
//               "ssss":"${Detailspart[i]['amountIncludingTax'].toStringAsFixed(2)}",
//               "sss":"${Detailspart[i]['taxPercentage']==null?"0.00":Detailspart[i]['taxPercentage'].toStringAsFixed(2)}",
//               "ssshhs":"${Detailspart[i]['qty']}",
//               "ss":"${Detailspart[i]['rate'].toStringAsFixed(2)}",
//               "s":"${Detailspart[i]['itmName']}",
//             },
//         ];
//       }
//
//
//
//     List<List<String>> listOfPurchases = List();
//     for (int i = 0; i < purchasesAsMap.length; i++) {
//       listOfPurchases.add(purchasesAsMap[i].values.toList());
//     }
//     return listOfPurchases;
//   }
//
//
//
//
//   // ['Amount المجموع', 'TaxAmt\n مبلغ الضريبة', 'Tax% الضريبة٪', 'Qty\n كمية', 'Price معدل', 'name\tItem\n التفاصيل']
//
//
//   Pagetype(pgTyp){
//     setState(() {
//       Pg_2_Inch=false;
//         pgTyp == "A4" ? PgA4 = true : PgA4 = false;
//         PgA4 == true ?
//         TblHeader = <dynamic>  [
//           'طبيعة السلع  أو الخدمات  Nature of goods or services ',
//
//           'Price\tUnit\n سعر الوحدة',
//
//           'Quantity\n كمية',
//
//           "Amount\tTaxable\n المبلغ الخاضع للضريبة",
//
//           'Discount\n خصم',
//
//           'Rate\tTax\n معدل الضريبة',
//
//           'Amount\tTax\n قيمة الضريبة',
//
//           'ItemSubtotal\n (Including VAT)   البند المجموع الفرعي )متضمنًا ضريبة القيمة المضافة(',
//         ]:
//         TblHeader = <dynamic>
//         ['Amount المجموع', 'Tax% الضريبة٪', 'Qty كمية', 'Price معدل', 'Item name التفاصيل'];
//         print("PgA4");
//         print(PgA4);
//
//     });
//   }
//
//
//
//
// }




































// import 'dart:convert';
// import 'dart:typed_data';
// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_app/GT_Masters/Printing/CurrencyWordConverter.dart';
// import 'package:flutter_app/GT_Masters/Printing/PDF_2Inch_Print.dart';
// import 'package:flutter_app/GT_Masters/Printing/PDF_Printer.dart';
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
// class Test4 extends StatefulWidget {
//   var Parm_Id;
//   var Page_Type;
//   Test4({this.Parm_Id,this.Page_Type});
//
//   @override
//   _Test4State createState() => _Test4State();
// }
//
// class _Test4State extends State<Test4> {
//
//   Pdf_Two_Inch Pdf_2=Pdf_Two_Inch();
//
//   SharedPreferences pref;
//   dynamic branch;
//   var res;
//   dynamic user;
//   int branchId;
//   int userId;
//   UserData userData;
//   String branchName = "";
//   dynamic userName;
//   String token;
//   // var DateTimeFormat = new DateFormat('dd-MM-yyyy hh a');
//   var DateTimeFormat = new DateFormat('dd-MM-yyyy');
//   String Datetime_Now = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());
//   var Detailspart;
//   var dataForTicket;
//   var footerCaptions;
//   var  Companydata;
//   bool IsArabic=false;
//   bool PgA4=true;
//   bool Pg_2_Inch=false;
//   String IsArabicChkBoxText="Arabic";
//   var  TaxType;
//   var  CountryName;
//   var  currencyName;
//
//   // double Pdf_Width=800.0;
//   NumberToWord arabicAmount = NumberToWord();
//
//
//   void initState() {
//     setState(() {
//       SharedPreferences.getInstance().then((value) {
//         pref = value;
//         read();
//         GetdataPrint(widget.Parm_Id);
//         footerdata();
//         GetQrdata();
//         GeneralSettings();
//         PgA4=true;
//         // widget.Page_Type==true? PgA4=true:PgA4=false;
//         dropdownValue=widget.Page_Type==true?"Tax Invoice":"Invoice";
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
//       CountryName = user.user["countryName"];
//       currencyName = user.user["currencyName"];
//
//     });
//     var CD=await GetCompantPro(branchId);
//   }
//
//
//
//
//   GeneralSettings()async{
//
//
//     final res =
//     await http.get("${Env.baseUrl}generalSettings", headers: {
//       "Authorization": user.user["token"],
//     });
//
//     if(res.statusCode<210) {
//       print(res);
//       var GenSettingsData = json.decode(res.body);
//       print(GenSettingsData[0]["applicationTaxTypeGst"]);
//       setState(() {
//         GenSettingsData[0]["applicationTaxTypeGst"] ==true ?
//         TaxType = "Gst.No" : TaxType = "Vat.No";
//         print("TaxType");
//         print(TaxType);
//
//       });
//     }
//   }
//
//
//
//   footerdata() async {
//     try {
//       print("footer data decoded  ");
//       final tagsJson =
//       await http.get("${Env.baseUrl}SalesInvoiceFooters/", headers: {
//         "Authorization": user.user["token"],
//       });
//       var footerdata =await jsonDecode(tagsJson.body);
//       setState(() {
//         footerCaptions = footerdata;
//         // print( "on footerCaptions :" +footerCaptions.toString());
//       });
//
//     } catch (e) {
//       print(e);
//     }
//   }
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
//         print( "QR datas :" +Qrdata.toString());
//       });
//
//     } catch (e) {
//       print(e);
//     }
//   }
//
//
//
//   var BuyerDetails=[];
//   GetBuyerDetails(id) async {
//     try {
//       print("GetBuyerDetails datas $id");
//       final tagsJson =
//       await http.get("${Env.baseUrl}MLedgerHeads/$id", headers: {
//         "Authorization": user.user["token"],
//       });
//
//
//
//       if(tagsJson.body.contains("errors")){
//         print("Error on GetBuye");
//         setState(() {
//           BuyerDetails=[
//             {
//               "lhName": "", "nameLatin": null, "districtName": null, "areaName": null,
//               "lhPincode": null, "lhGstno": null, "buildingNo": null,
//               "buildingNoLatin": "","streetName": "", "streetNameLatin": "",
//               "district": "", "districtLatin": " ", "city": " ", "cityLatin": "",
//               "country": " ", "countryLatin": "", "pinNo": "","pinNoLatin": ""
//             }];
//         });
//
//       }else {
//         var Buyer =await jsonDecode(tagsJson.body);
//         setState(() {
//           BuyerDetails = Buyer["ledgerHeads"];
//           print("GetBuyerDetails datas :" +BuyerDetails.toString());
//           print(BuyerDetails[0]["lhName"]);
//
//         });
//       }
//     } catch (e) {
//       print("Error on GetBuyerDetails $e");
//     }
//   }
//
//
//
//   GetCompantPro(id)async{
//     print("GetCompantPro");
//     print(id.toString());
//     try {
//       final tagsJson =
//       await http.get("${Env.baseUrl}MCompanyProfiles/$id", headers: {
//         //Soheader //SalesHeaders
//         "Authorization": user.user["token"],
//       });
//       if(tagsJson.statusCode==200) {
//         Companydata = await jsonDecode(tagsJson.body);
//       }
//       print( "on GetCompantPro :" +Companydata.toString());
//       print(  Companydata['companyProfileAddress1'].toString());
//     }
//     catch(e){
//       print("error on GetCompantPro : $e");
//     }
//   }
//
//
//   var  VchDate;
//   var  InvTime;
//   var TotalTax=0.0;
//   var AmountBeforeTax=0.0;
//   var TotalQty=0.0;
//
//   GetdataPrint(id) async {
//     print("sales for print : $id");
//     double amount = 0.0;
//     try {
//       final tagsJson =
//       await http.get("${Env.baseUrl}SalesHeaders/$id", headers: {
//         //Soheader //SalesHeaders
//         "Authorization": user.user["token"],
//       });
//
//
//       dataForTicket = await jsonDecode(tagsJson.body);
//
//       // var ParseDate=dataForTicket['salesHeader'][0]["voucherDate"]??"2022-01-01T00:00:00";
//       var ParseDate=dataForTicket['salesHeader'][0]["entryDate"]??"2022-01-01T00:00:00";
//       // DateTime tempDate = new DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(ParseDate);
//       DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(ParseDate);
//       print(dataForTicket['salesHeader'][0]["voucherDate"]);
//       VchDate=DateTimeFormat.format(tempDate);
//       print(VchDate.toString());
//
//
//       var  tempTime=dataForTicket['salesHeader'][0]["entryDate"]??"2022-01-01T00:00:00";
//       DateTime tempTimeFormate = new DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(tempTime);
//       InvTime= DateFormat.jm().format(tempTimeFormate);
//       GetBuyerDetails(dataForTicket['salesHeader'][0]["ledgerId"]);
//       Detailspart = dataForTicket['salesDetails'];
//       var  Pattern=Detailspart[0]['itmName'];
//
//
//       print(Detailspart[0]['rate'].runtimeType);
//       print(Detailspart[0]['taxPercentage'].runtimeType);
//       for(int i = 0; i < Detailspart.length; i++)
//       {
//
//         double qty=Detailspart[i]['qty']==null?0.0:(Detailspart[i]['qty']);
//         double rate=Detailspart[i]['rate']==null?0.0:(Detailspart[i]['rate']);
//         double varTxPer=Detailspart[i]['taxPercentage']==null?0.0:(Detailspart[i]['taxPercentage']);
//         double itemTaxrate=Detailspart[i]['taxAmount']??0.0;
//         //  double itemTaxrate=await CalculateTaxAmt(rate,qty,varTxPer);
//         TotalTax=TotalTax+itemTaxrate;
//         TotalQty=TotalQty+qty;
//         AmountBeforeTax=AmountBeforeTax+Detailspart[i]['amountBeforeTax'];
//       }
//       print("TotalTax");
//       print(TotalTax.toString());
//
//       GetArabicAmount(dataForTicket['salesHeader'][0]["amount"]);
//
//       setState(() {
//         IsArabic=true;
//       });
//     } catch (e) {
//       print('error on databinding $e');
//     }
//   }
//
//
//   String dropdownValue = 'Tax Invoice';
//
//
//   var  AmtInWrds="";
//   GetArabicAmount(Amount){
//     //  AmtInWrds= arabicAmount.NumberInRiyals(Amount);
//
//   }
//
//
//
//   ///---------------------------------------------
//
//   @override
//   Widget build(BuildContext context) {
//     var ScreenSize=MediaQuery.of(context).size.width;
//     var ScreenHeight=MediaQuery.of(context).size.height;
//
//     return
//       SafeArea(
//         child: Scaffold(
//           appBar: PreferredSize(preferredSize: Size.fromHeight(80),
//             child: Appbarcustomwidget(uname: userName, branch:branchName, pref: pref, title:"Print"),),
//
//           body: dataForTicket == null ? SizedBox(height: ScreenHeight,width: ScreenSize,
//               child: Center(child: Text("Loading..."))) :
//           Companydata == null ? SizedBox(height: ScreenSize,width: ScreenSize,
//               child: Center(child: Text("Loading..."))) :
//           BuyerDetails.isEmpty ? SizedBox(height: ScreenSize,width: ScreenSize,
//               child: Center(child: Text("Loading..."))) :
//
//         SizedBox(
//           width: ScreenHeight,
//           child: PdfPreview(
//                 initialPageFormat:PdfPageFormat.a4 ,
//                 allowPrinting: true,
//                 allowSharing: false,
//                 canChangePageFormat: false,
//                 useActions: true,
//                 build: (format) =>_generatePdf(format, ScreenSize,context),
//               ),
//         ),
//
//
//
//           floatingActionButton:
//           // Row(
//           //   mainAxisAlignment: MainAxisAlignment.start,
//           //   crossAxisAlignment: CrossAxisAlignment.start,
//           //   children: [
//           Container(
//             //color: Colors.red,
//             height: 30,
//             //width: 100,
//             child:  DropdownButton(
//
//               underline:Container(color: Colors.transparent),
//               icon:Text("$dropdownValue  ▼",style: TextStyle(color: Colors.white),),
//
//               items:[
//                 DropdownMenuItem<String>(
//                   value: "Tax Invoice",
//                   child: Text(
//                     "Tax Invoice",style:TextStyle(fontSize: 13),
//                   ),
//                 ),
//
//                 DropdownMenuItem<String>(
//                   value: "Simplified",
//                   child: Text(
//                     "Simplified",style:TextStyle(fontSize: 13),
//                   ),
//                 ),
//
//                 DropdownMenuItem<String>(
//                   value: "A4",
//                   child: Text(
//                     "A4",style:TextStyle(fontSize: 13),
//                   ),
//                 ),
//                 DropdownMenuItem<String>(
//                   value: "3 Inch",
//                   child: Text(
//                     "3 Inch",style:TextStyle(fontSize: 13),
//                   ),
//                 ),
//                 DropdownMenuItem<String>(
//                   value: "2 Inch",
//                   child: Text(
//                     "2 Inch",style:TextStyle(fontSize: 13),
//                   ),
//                 ),
//               ],
//               onChanged: (String newValue) {
//                 setState(() {
//                   dropdownValue = newValue;
//                   Pagetype(dropdownValue);
//                   if(dropdownValue== "2 Inch"){
//                     Pg_2_Inch=true;
//                   }
//                 });
//               },
//
//             ),
//           ),
//
//
//
//           // ] ),
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
//     final Pdf_fontSize = 6.7;
//     final Pdf_Width = 570.0;
//     pdf.addPage(
//         pw.MultiPage(
//           margin: pw.EdgeInsets.only(top: 20, left: 10, bottom: 20, right: 10),
//           pageFormat: PdfPageFormat.a4,
//           //PdfPageFormat(PdfPageFormat.inch, 20 * PdfPageFormat.cm, marginAll: 0.5 * PdfPageFormat.cm),
//           // PdfPageFormat(21 * PdfPageFormat.cm,  13.5 * PdfPageFormat.cm, marginAll: 1 * PdfPageFormat.cm),
//           //   pageFormat:PgA4==true? PdfPageFormat.a4:PdfPageFormat.roll80,
//
//           textDirection: pw.TextDirection.rtl,
//           build: (pw.Context context) {
//             return <pw.Widget
//             >[
//             dataForTicket == null ? pw.Text('') :
//
//
//             pw.Text(PgA4==true?"فاتورة ضريبية":'فاتورة ضريبية مبسطة', textAlign: pw.TextAlign.center,
//             textDirection: pw.TextDirection.rtl,
//             style: pw.TextStyle(
//             font: ttf,fontSize:Pdf_fontSize)),
//             // pw.Center(child:pw.SizedBox(child: pw.Divider(),width: ScreenSize/9),heightFactor: 0),
//             pw.SizedBox(height: 5),
//
//             pw.Text(PgA4==true?'TAX INVOICE':'Simplified Tax Invoice', textAlign: pw.TextAlign.center,
//             //textDirection: pw.TextDirection.rtl,
//             style: pw.TextStyle(fontSize:Pdf_fontSize,
//             decoration:pw.TextDecoration.underline)),
//
//             pw.SizedBox(height: 12),
//
//
//             PgA4==true? pw.Row( mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//             children: [
//
//             pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             mainAxisAlignment: pw.MainAxisAlignment.start,
//             children: [
//
//             pw.Container(
//
//             width: ScreenSize/1.45,
//             decoration: pw.BoxDecoration(border: pw.Border.all(
//             color: PdfColors.black) ),
//             child:pw.Padding(padding:pw.EdgeInsets.all(3),
//             child:
//             pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//             children: [
//             pw.Text('Invoice No              : ' +dataForTicket['salesHeader'][0]["voucherNo"].toString(),
//             style:pw.TextStyle(fontSize:Pdf_fontSize)),
//
//
//             pw.Text(" رقم الفاتورة ${dataForTicket['salesHeader'][0]["voucherNo"].toString()} :             ",
//             textDirection: pw.TextDirection.rtl,
//             style: pw.TextStyle(font: ttf,fontSize:Pdf_fontSize)),
//
//             ] ),)
//             ),
//
//
//             pw.Container(
//
//             width: ScreenSize/1.45,
//             decoration: pw.BoxDecoration(border: pw.Border.all(
//             color: PdfColors.black) ),
//             child:pw.Padding(padding:pw.EdgeInsets.all(3),
//             child:
//             pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//             children: [
//             pw.Text('Invoice Issue Date : ' +VchDate.toString(),style:pw.TextStyle(fontSize:Pdf_fontSize)),
//
//
//             pw.Text(" تاريخ إصدار الفاتورة ${VchDate.toString()} :  ",
//             textDirection: pw.TextDirection.rtl,
//             style: pw.TextStyle(font: ttf,fontSize:Pdf_fontSize)),
//
//             ] ),)
//             ),
//
//
//             // pw.SizedBox(height: 10),
//
//             pw.Container(
//
//             width: ScreenSize/1.45,
//             decoration: pw.BoxDecoration(border: pw.Border.all(
//             color: PdfColors.black) ),
//             child:pw.Padding(padding:pw.EdgeInsets.all(3),
//             child:
//             pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//             children: [
//             pw.Text('Date of Supply       : ' +VchDate.toString(),style:pw.TextStyle(fontSize:Pdf_fontSize)),
//
//
//             pw.Text(" تاريخ التوريد ${VchDate.toString()} :           ",
//             textDirection: pw.TextDirection.rtl,
//             style: pw.TextStyle(font: ttf,fontSize:Pdf_fontSize)),
//
//             ] ),))
//
//             ]),
//
//
//             pw.Padding(padding:pw.EdgeInsets.only(bottom: 5),
//             child: pw.BarcodeWidget(
//             // data: widget.Parm_Id.toString(),
//             data: Qrdata.toString(),
//             barcode: pw.Barcode.qrCode(),
//             width: 50,
//             height: 50
//             ))
//
//
//             ]):
//
//
//             ///---------------------------------------pg 3inch-------------------------------
//
//             pw.Container(
//
//             child:
//             pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             mainAxisAlignment: pw.MainAxisAlignment.start,
//             children: [
//
//
//             pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//             children: [
//             pw.Text('Invoice No              : ' +dataForTicket['salesHeader'][0]["voucherNo"].toString(),
//             style:pw.TextStyle(fontSize:Pdf_fontSize)),
//
//
//             pw.Text(" رقم الفاتورة ${dataForTicket['salesHeader'][0]["voucherNo"].toString()} :             ",
//             textDirection: pw.TextDirection.rtl,
//             style: pw.TextStyle(font: ttf,fontSize:Pdf_fontSize)),
//
//             ] ),
//
//
//             pw.SizedBox(height: 2),
//
//
//             pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//             children: [
//             pw.Text('Invoice Issue Date : ' +VchDate.toString(),style:pw.TextStyle(fontSize:Pdf_fontSize)),
//             pw.Text(" تاريخ إصدار الفاتورة ${VchDate.toString()} :  ",
//             textDirection: pw.TextDirection.rtl,
//             style: pw.TextStyle(font: ttf,fontSize:Pdf_fontSize)),
//
//             ] ),
//
//
//             pw.SizedBox(height: 2),
//
//             pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//             children: [
//             pw.Expanded(child: pw.Text('VAT Number : ${Companydata['companyProfileGstNo']??""}',style:pw.TextStyle(fontSize:Pdf_fontSize)),),
//
//             pw.Text("ظريبه الشراء:  ${Companydata['companyProfileGstNo']??""} ",
//             textDirection: pw.TextDirection.rtl,
//             style: pw.TextStyle(font: ttf,fontSize:Pdf_fontSize)),
//
//             ] ),
//
//
//             ]),
//             ),
//
//             ///---------------------------------------------------------------------------------
//
//
//             PgA4==true?pw.Directionality(
//             textDirection:pw.TextDirection.rtl,
//             child:
//
//             pw.SizedBox(
//
//             child:pw.Row(
//             mainAxisAlignment: pw.MainAxisAlignment.start,
//             children: [
//             pw.Expanded(
//
//             child:
//             pw.Table.fromTextArray(
//             cellAlignment:pw.Alignment.topRight,
//             cellAlignments:{0: pw.Alignment.topLeft,
//             1:pw.Alignment.topLeft,
//             3:pw.Alignment.topRight,
//             4: pw.Alignment.topLeft,
//             5: pw.Alignment.topLeft,
//
//             },
//             headerAlignment: pw.Alignment.centerLeft,
//             headerAlignments:{7: pw.Alignment.centerRight,} ,
//
//
//             columnWidths:{
//             1: pw.FixedColumnWidth(80),
//             2: pw.FixedColumnWidth(80),
//             5: pw.FixedColumnWidth(80),
//             6: pw.FixedColumnWidth(80),
//             },
//
//
//             headerDecoration: pw.BoxDecoration(
//             color:PdfColors.grey400,),
//             headers:
//             [
//             "Seller :",
//             "",
//             "",
//             "المورد:",
//
//             "Buyer :",
//             "",
//             "",
//             "عميل:",
//             ],
//
//             data: [
//             [
//             "Name",
//             "${Companydata['companyProfileName']??""}",
//             "${Companydata['companyProfileNameLatin']??""}",
//             "اسم",
//
//             "Name",
//             "${BuyerDetails[0]['lhName']??""}",
//             "${BuyerDetails[0]['nameLatin']??""}",
//             "اسم"
//             ],
//
//             [
//             "Building No",
//             "${Companydata['buildingNo']??""}",
//             "${Companydata['buildingNoLatin']??""}",
//             "لا للبناء",
//
//             "Building No",
//             "${BuyerDetails[0]['buildingNo']??""}",
//             "${BuyerDetails[0]['buildingNoLatin']??""}",
//             "لا للبناء"
//             ],
//
//             [
//             "Street Name",
//             "${Companydata['streetName']??""}",
//             "${Companydata['streetNameLatin']??""}",
//             "اسم الشارع",
//
//             "Street Name",
//             "${BuyerDetails[0]['streetName']??""}",
//             "${BuyerDetails[0]['streetNameLatin']??""}",
//             "اسم الشارع"
//             ],
//
//
//             [
//             "District",
//             "${Companydata['district']??""}",
//             "${Companydata['districtLatin']??""}",
//             "يصرف",
//
//             "District",
//             "${BuyerDetails[0]['district']??""}",
//             "${BuyerDetails[0]['districtLatin']??""}",
//             "يصرف",
//             ],
//
//
//             [
//             "City",
//             "${Companydata['city']??""}",
//             "${Companydata['cityLatin']??""}",
//             "مدينة",
//
//             "City",
//             "${BuyerDetails[0]['city']??""}",
//             "${BuyerDetails[0]['cityLatin']??""}",
//             "مدينة",
//             ],
//
//
//             // ["Country","$CountryName",
//             //   "$CountryName","دولة"],
//             [
//             "Country",
//             "${Companydata['country']??""}",
//             "${Companydata['countryLatin']??""}",
//             "دولة",
//
//             "Country",
//             "${BuyerDetails[0]['country']??""}",
//             "${BuyerDetails[0]['countryLatin']??""}",
//             "دولة",
//             ],
//
//
//             [
//             "Postal Code",
//             "${Companydata['pinNo']??""}",
//             "${Companydata['pinNoLatin']??""}",
//             "رمز بريدي",
//
//             "Postal Code",
//             "${BuyerDetails[0]['pinNo']??""}",
//             "${BuyerDetails[0]['pinNoLatin']??""}",
//             "رمز بريدي",
//             ],
//
//
//             [
//             "Additional No",
//             "",
//             "",
//             "رقم إضافي",
//
//             "Additional No",
//             "",
//             "",
//             "رقم إضافي",
//             ],
//
//
//             [
//             "VAT Number:",
//             "${Companydata['companyProfileGstNo']??""}",
//             "${Companydata['companyProfileGstNo']??""}",
//             "ظريبه الشراء",
//
//             "VAT Number:",
//             "${BuyerDetails[0]['lhGstno']??""}",
//             "${BuyerDetails[0]['lhGstno']??""}",
//             "ظريبه الشراء",
//             ],
//
//
//             [
//             "Other Seller ID:",
//             "",
//             "",
//             "معرف البائع الآخر",
//
//             "Other Seller ID:",
//             "",
//             "",
//             "معرف البائع الآخر",
//             ],
//
//             ],
//             headerStyle: pw.TextStyle (font: ttf, fontSize: Pdf_fontSize,color: PdfColors.black),
//             cellStyle: pw.TextStyle (font: ttf, fontSize: Pdf_fontSize,),
//             )),
//
//             ]),
//
//
//             ),
//
//             ):
//
//             ///-------------------------------3 inc ---------------------------------------------------
//
//
//             pw.Text(""),
//
//             pw.SizedBox(height:PgA4==true?20:5),
//
//
//             PgA4==true? pw.Container(
//             decoration: pw.BoxDecoration(
//             color:PdfColors.grey400,
//             border: pw.Border.all(
//             color: PdfColors.black) ),
//             child:pw.Padding(padding:pw.EdgeInsets.all(3),
//             child:
//             pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//             children: [
//             pw.Text("Line Items:",style: pw.TextStyle(fontSize: Pdf_fontSize,font: ttf,color: PdfColors.black)),
//             pw.Text("البنود:",style: pw.TextStyle(fontSize: Pdf_fontSize,font: ttf,color: PdfColors.black),
//             textDirection: pw.TextDirection.rtl,),
//             ]),
//             )
//             ): pw.Text(""),
//
//
//
//             pw.Partition(child:
//             pw.Table.fromTextArray(
//             tableWidth:pw.TableWidth.max ,
//             cellAlignment: pw.Alignment.topRight,
//             cellAlignments:PgA4==true?{0: pw.Alignment.topLeft,}:{0: pw.Alignment.topRight,},
//             columnWidths:PgA4==true?{7: pw.FixedColumnWidth(100)}:
//             {0: pw.FixedColumnWidth(60),3: pw.FixedColumnWidth(60),},
//
//             cellStyle: pw.TextStyle(font: ttf,fontSize: Pdf_fontSize),
//             headerStyle: pw.TextStyle(fontWeight:pw.FontWeight.bold,font: ttf,fontSize:Pdf_fontSize,),
//             headerAlignment:pw.Alignment.topRight,
//             headerAlignments:PgA4==true?{} :{0: pw.Alignment.topLeft},
//             headerDecoration: pw.BoxDecoration(border: pw
//                 .Border(bottom: pw.BorderSide(
//             color: PdfColors.black)),
//             color:PgA4==true?PdfColors.white:PdfColors.grey400),
//
//             cellPadding:pw.EdgeInsets.all(1),
//
//             headers:TblHeader,
//             data: TableGenerator()
//             )
//             ),
//             // )
//
//
//             pw.SizedBox(height:PgA4==true?20:5),
//
//
//             PgA4==true?pw.Container(
//             decoration: pw.BoxDecoration(
//             color:PdfColors.grey400,
//             border: pw.Border.all(
//             color: PdfColors.black) ),
//             child:pw.Padding(padding:pw.EdgeInsets.all(3),
//             child:
//             pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//             children: [
//             pw.Text("Total amounts:",style: pw.TextStyle(fontSize: Pdf_fontSize,font: ttf,color: PdfColors.black)),
//             pw.Text("المبالغ الإجمالية:",style: pw.TextStyle(fontSize: Pdf_fontSize,font: ttf,color: PdfColors.black),
//             textDirection: pw.TextDirection.rtl,),
//             ]),
//             )
//             ):pw.Text(""),
//
//             PgA4==true? pw.Directionality(
//             textDirection:IsArabic==true? pw.TextDirection.rtl: pw.TextDirection.ltr,
//             child:
//             pw.Table.fromTextArray(
//             headerAlignments:{1: pw.Alignment.topLeft,2:pw.Alignment.topRight,3:pw.Alignment.centerRight} ,
//             cellAlignments:{1: pw.Alignment.topLeft,2:pw.Alignment.topRight,3:pw.Alignment.centerRight},
//             columnWidths:{0: pw.FixedColumnWidth(100),},
//             headerStyle: pw.TextStyle (font: ttf, fontSize: 10,),
//             cellStyle: pw.TextStyle (font: ttf, fontSize: 10,),
//
//
//             headers:
//
//
//             ["",
//             "Total (Excluding VAT)",
//             "الإجمالي)باستثناء ضريبة القيمة المضافة(",
//             "${AmountBeforeTax.toStringAsFixed(2)} ${currencyName??""}",
//             ],
//
//             data: [
//
//             [ "",
//             "Discount",
//             "خصم",
//             "0.00 ${currencyName??""}",
//             ],
//
//             [ "",
//             "Total Taxable Amount (Excluding VAT)",
//             "إجمالي المبلغ الخاضع للضريبة )باستثناء ضريبة القيمة المضافة(",
//             "${AmountBeforeTax.toStringAsFixed(2)} ${currencyName??""}",
//             ],
//
//
//             [ "",
//             "Total VAT",
//             " ضريبة القيمة المضافة",
//             "${TotalTax==null?0.toStringAsFixed(2):
//             TotalTax.toStringAsFixed(2)} ${currencyName??""}",
//             ],
//
//
//             [ "",
//             "Total Amount Due",
//             "إجمالي المبلغ المستحق",
//             "${dataForTicket['salesHeader'][0]["amount"]==null?0.toStringAsFixed(2):
//             dataForTicket['salesHeader'][0]["amount"].toStringAsFixed(2)} ${currencyName??""}",
//             ],
//
//
//             ]
//             ),
//             ):
//
//             ///---------------------------------3 inc -----------------------------------------------
//
//
//             PgA4==true?pw.Text(""):pw.Divider(height: 1,thickness: 1,color: PdfColors.black),
//             pw.SizedBox(height:3),
//             PgA4==true?pw.Text(""):pw.Column(
//             children: [
//             pw.Row(
//             mainAxisAlignment:pw.MainAxisAlignment.start,
//             // crossAxisAlignment:pw.CrossAxisAlignment.end,
//             children:[
//
//             pw.Expanded(child:pw.Text("Total Taxable Amount (Excluding VAT)",style: pw.TextStyle(fontSize: Pdf_fontSize,))),
//             pw. Spacer(),
//             pw.Expanded(child:pw.Text("الإجمالي الخاضع للضریبة )غیر شامل ضریبة القیمة المضافة(",style: pw.TextStyle(fontSize: Pdf_fontSize,font: ttf,color: PdfColors.black),
//             textDirection: pw.TextDirection.rtl,)),
//
//             pw. Spacer(),
//
//             pw.Text("${AmountBeforeTax.toStringAsFixed(2)} ${currencyName??""}",style: pw.TextStyle(fontSize: Pdf_fontSize,)),
//             ]),
//
//
//             pw.SizedBox(height:5),
//
//             pw.Row(
//             mainAxisAlignment:pw.MainAxisAlignment.spaceBetween,
//             children:[
//
//             pw.Expanded(child:pw.Text("Total VAT",style: pw.TextStyle(fontSize: Pdf_fontSize,))),
//             pw. Spacer(),
//             pw.Expanded(child:pw.Text(" ضريبة القيمة المضافة",style: pw.TextStyle(fontSize: Pdf_fontSize,font: ttf,color: PdfColors.black),
//             textDirection: pw.TextDirection.rtl,)),
//
//             pw. Spacer(),
//
//             pw.Text("  ${TotalTax==null?0.toStringAsFixed(2):
//             TotalTax.toStringAsFixed(2)} ${currencyName??""}",style: pw.TextStyle(fontSize: Pdf_fontSize,)),
//             ]),
//
//
//             pw.SizedBox(height:5),
//
//
//             pw.Row(
//             mainAxisAlignment:pw.MainAxisAlignment.spaceAround,
//             children:[
//
//             pw.Expanded(child:pw.Text("Total Amount Due",style: pw.TextStyle(fontSize: Pdf_fontSize,))),
//             pw. Spacer(),
//             pw.Expanded(child:pw.Text("إجمالي المبلغ المستحق",style: pw.TextStyle(fontSize: Pdf_fontSize,font: ttf,color: PdfColors.black),
//             textDirection: pw.TextDirection.rtl,)),
//
//             pw. Spacer(),
//             pw.Text("${dataForTicket['salesHeader'][0]["amount"].toStringAsFixed(2)} ${currencyName??""}",style: pw.TextStyle(fontSize: Pdf_fontSize,)), ]),
//
//             pw.SizedBox( height: 5,),
//
//             PgA4==true?pw.Text("") : pw.Padding(padding:pw.EdgeInsets.only(bottom: 5),
//             child: pw.BarcodeWidget(
//             // data: widget.Parm_Id.toString(),
//             data: Qrdata.toString(),
//             barcode: pw.Barcode.qrCode(),
//             width: 50,
//             height: 50
//             )),
//
//
//             pw.Row(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//             children:[
//             pw.SizedBox(
//             height: 2,),
//
//             pw.SizedBox(
//             width: 20,),
//             pw.SizedBox(height: 2),
//
//
//             ]),
//             ])
//             ];
//           },
//         )
//
//     );
//
//
//
//
//
//
//     return pdf.save();
//   }
//
//   pw.Container Seller_Buyer_Table({
//     double Pdf_fontSize,
//     pw.Font ttf,
//     String Arabic_Label,
//     String Label,
//     dynamic dataValue
//   })
//   {
//     return pw.Container(
//         decoration: pw.BoxDecoration(border: pw.Border.all(
//             color: PdfColors.black) ),
//         child:pw.Padding(padding:pw.EdgeInsets.all(3),
//           child:
//           pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end,
//               children: [
//                 pw.Text('$Label : ',style:pw.TextStyle(fontSize:Pdf_fontSize)),
//
//
//                 pw.Text(" : $Arabic_Label${dataValue.toString()}",
//                     textDirection: pw.TextDirection.rtl,
//                     style: pw.TextStyle(font: ttf,fontSize:Pdf_fontSize)),
//
//               ] ),)
//     );
//   }
//
//
//
//
//   var TblHeader;
//   TableGenerator() {
//     //   PgA4==true?TblHeader= ['Amount\n المجموع', 'TaxAmt\n مبلغ الضريبة', 'Tax%\n  الضريبة٪',"Total\n مجموع", 'Qty\n كمية', 'Price\n  معدل\n','Unit\n وحدة', 'name\tItem\n التفاصيل','No\n عدد']:
//     PgA4==true?TblHeader= [
//       'طبيعة السلع  أو الخدمات  Nature of goods or services ',
//
//       'Price\tUnit\n سعر الوحدة',
//
//       'Quantity\n كمية',
//
//       "Amount\tTaxable\n المبلغ الخاضع للضريبة",
//
//       'Discount\n خصم',
//
//       'Rate\tTax\n معدل الضريبة',
//
//       'Amount\tTax\n قيمة الضريبة',
//
//       'ItemSubtotal\n (Including VAT)   البند المجموع الفرعي )متضمنًا ضريبة القيمة المضافة(',
//     ]:
//     TblHeader= [
//       // 'طبيعة السلع  أو الخدمات  Nature of goods or services ',
//       //'طبيعة السلع  أو الخدمات   Nature of goods or services',
//       'or\tgoods\tof\tNature\tservices\n'+' طبيعة السلع  أو الخدمات',
//       'Price\tUnit\n سعر الوحدة',
//       'Quantity\n كمية',
//       '(Including VAT) Item Subtotal  المجموع )شامل ضریبة القیمة المضافة('
//
//
//       //'(IncludingVAT)\n  ItemSubtotal    (بما في ذلك ضريبة القيمة المضافة)  المجموع الفرعي للعنصر  ',
//     ];
//
//
//
//
//
//     var purchasesAsMap;
//
//     if(PgA4==true) {
//       var Slnum=0;
//       purchasesAsMap = <Map<String, String>>[
//         for(int i = 0; i < Detailspart.length; i++)
//           {
//
//             "ItemName": "${Detailspart[i]['itmName']??""} ${Detailspart[i]['itmArabicName']??""}",
//             "Rate": "${Detailspart[i]['rate'].toStringAsFixed(2)} ",
//             "Qty": "${Detailspart[i]['qty']} ",
//             "total": "${(Detailspart[i]['qty']??0.0)*(Detailspart[i]['rate']??0.0)} ",
//             "discount": "0.0",
//             "TaxPer": "${Detailspart[i]['taxPercentage']==null?"0.00":Detailspart[i]['taxPercentage'].toStringAsFixed(2)} ",
//             "TaxAmt": "${Detailspart[i]['taxAmount'].toStringAsFixed(2)=="0.00"?"":Detailspart[i]['taxAmount'].toStringAsFixed(2)} ",
//             "NetAmt": "${Detailspart[i]['amountIncludingTax'].toStringAsFixed(2)} ",
//
//
//
//
//
//             // "NetAmt": "${Detailspart[i]['amountIncludingTax'].toStringAsFixed(2)} ",
//             // //"sssf": "${CalculateTaxAmt((Detailspart[i]['rate']),(Detailspart[i]['qty']),(Detailspart[i]['taxPercentage']))} ",
//             // "TaxAmt": "${Detailspart[i]['taxAmount'].toStringAsFixed(2)=="0.00"?"":Detailspart[i]['taxAmount'].toStringAsFixed(2)} ",
//             // "TaxPer": "${Detailspart[i]['taxPercentage']==null?"0.00":Detailspart[i]['taxPercentage'].toStringAsFixed(2)} ",
//             // "total": "${(Detailspart[i]['qty']??0.0)*(Detailspart[i]['rate']??0.0)} ",
//             // "Qty": "${Detailspart[i]['qty']} ",
//             // "Rate": "${Detailspart[i]['rate'].toStringAsFixed(2)} ",
//             // "Unit": "${Detailspart[i]['uom']??""} ",
//             // "ItemName": "${Detailspart[i]['itmName']??""} ${Detailspart[i]['itmArabicName']??""}",
//             // "No": "${(++Slnum).toString()} ",
//
//           },
//       ];
//     }  else{
//       purchasesAsMap = <Map<String, String>>[
//         for(int i = 0; i < Detailspart.length; i++)
//           {
//             "ItemName": "${Detailspart[i]['itmName']??""}  ${Detailspart[i]['itmArabicName']??""}",
//             "Rate": "${Detailspart[i]['rate'].toStringAsFixed(2)} ",
//             // "total": "${(Detailspart[i]['qty']??0.0)*(Detailspart[i]['rate']??0.0)} ",
//             "Qty": "${Detailspart[i]['qty']} ",
//             "NetAmt": "${Detailspart[i]['amountIncludingTax'].toStringAsFixed(2)} ",
//           },
//       ];
//     }
//
//
//
//     List<List<String>> listOfPurchases = List();
//     for (int i = 0; i < purchasesAsMap.length; i++) {
//       listOfPurchases.add(purchasesAsMap[i].values.toList());
//     }
//     return listOfPurchases;
//   }
//
//
//
//
//   // ['Amount المجموع', 'TaxAmt\n مبلغ الضريبة', 'Tax% الضريبة٪', 'Qty\n كمية', 'Price معدل', 'name\tItem\n التفاصيل']
//
//
//   Pagetype(pgTyp){
//     if(pgTyp=="3 Inch"|| pgTyp=="A4"){
//
//       Navigator.of(context,rootNavigator: true).pop();
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) =>
//                   Pdf_Print(Parm_Id:widget.Parm_Id,Page_Type:pgTyp=="A4"?"A4":"3 Inch")));
//
//
//     }else{
//
//
//       setState(() {
//         Pg_2_Inch=false;
//         pgTyp == "Tax Invoice" ? PgA4 = true : PgA4 = false;
//         PgA4 == true ?
//         TblHeader = <dynamic>  [
//           'طبيعة السلع  أو الخدمات  Nature of goods or services ',
//
//           'Price\tUnit\n سعر الوحدة',
//
//           'Quantity\n كمية',
//
//           "Amount\tTaxable\n المبلغ الخاضع للضريبة",
//
//           'Discount\n خصم',
//
//           'Rate\tTax\n معدل الضريبة',
//
//           'Amount\tTax\n قيمة الضريبة',
//
//           'ItemSubtotal\n (Including VAT)   البند المجموع الفرعي )متضمنًا ضريبة القيمة المضافة(',
//         ]:
//         TblHeader = <dynamic>
//         [
//           'or\tgoods\tof\tNature\tservices\n'+' طبيعة السلع  أو الخدمات',
//           'Price\tUnit\n سعر الوحدة',
//           'Quantity\n كمية',
//           '(Including VAT) Item Subtotal  المجموع )شامل ضریبة القیمة المضافة('
//         ];
//         print("PgA4");
//         print(PgA4);
//
//       });
//
//     }
//
//
//
//   }
//
//
//
//
// }

























































// import 'dart:convert';
// import 'dart:typed_data';
// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_app/GT_Masters/Printing/CurrencyWordConverter.dart';
// import 'package:flutter_app/GT_Masters/Printing/PDF_2Inch_Print.dart';
// import 'package:flutter_app/GT_Masters/Printing/PDF_Printer.dart';
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
// class New_Model_PdfPrint extends StatefulWidget {
//   var Parm_Id;
//   var Page_Type;
//   New_Model_PdfPrint({this.Parm_Id,this.Page_Type});
//
//   @override
//   _New_Model_PdfPrintState createState() => _New_Model_PdfPrintState();
// }
//
// class _New_Model_PdfPrintState extends State<New_Model_PdfPrint> {
//
//   Pdf_Two_Inch Pdf_2=Pdf_Two_Inch();
//
//   SharedPreferences pref;
//   dynamic branch;
//   var res;
//   dynamic user;
//   int branchId;
//   int userId;
//   UserData userData;
//   String branchName = "";
//   dynamic userName;
//   String token;
//   // var DateTimeFormat = new DateFormat('dd-MM-yyyy hh a');
//   var DateTimeFormat = new DateFormat('dd-MM-yyyy');
//   String Datetime_Now = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());
//   var Detailspart;
//   var dataForTicket;
//   var footerCaptions;
//   var  Companydata;
//   bool IsArabic=false;
//   bool PgA4=true;
//   bool Pg_2_Inch=false;
//   String IsArabicChkBoxText="Arabic";
//   var  TaxType;
//   var  CountryName;
//   var  currencyName;
//
//   // double Pdf_Width=800.0;
//   NumberToWord arabicAmount = NumberToWord();
//
//
//   void initState() {
//     setState(() {
//       SharedPreferences.getInstance().then((value) {
//         pref = value;
//         read();
//         GetdataPrint(widget.Parm_Id);
//         footerdata();
//         GetQrdata();
//         GeneralSettings();
//         widget.Page_Type==true? PgA4=true:PgA4=false;
//         dropdownValue=widget.Page_Type==true?"Tax Invoice":"Invoice";
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
//       CountryName = user.user["countryName"];
//       currencyName = user.user["currencyName"];
//
//     });
//     var CD=await GetCompantPro(branchId);
//   }
//
//
//
//
//   GeneralSettings()async{
//
//
//     final res =
//     await http.get("${Env.baseUrl}generalSettings", headers: {
//       "Authorization": user.user["token"],
//     });
//
//     if(res.statusCode<210) {
//       print(res);
//       var GenSettingsData = json.decode(res.body);
//       print(GenSettingsData[0]["applicationTaxTypeGst"]);
//       setState(() {
//         GenSettingsData[0]["applicationTaxTypeGst"] ==true ?
//         TaxType = "Gst.No" : TaxType = "Vat.No";
//         print("TaxType");
//         print(TaxType);
//
//       });
//     }
//   }
//
//
//
//   footerdata() async {
//     try {
//       print("footer data decoded  ");
//       final tagsJson =
//       await http.get("${Env.baseUrl}SalesInvoiceFooters/", headers: {
//         "Authorization": user.user["token"],
//       });
//       var footerdata =await jsonDecode(tagsJson.body);
//       setState(() {
//         footerCaptions = footerdata;
//         // print( "on footerCaptions :" +footerCaptions.toString());
//       });
//
//     } catch (e) {
//       print(e);
//     }
//   }
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
//         print( "QR datas :" +Qrdata.toString());
//       });
//
//     } catch (e) {
//       print(e);
//     }
//   }
//
//
//
// var BuyerDetails=[];
//   GetBuyerDetails(id) async {
//     try {
//       print("GetBuyerDetails datas $id");
//       final tagsJson =
//       await http.get("${Env.baseUrl}MLedgerHeads/$id", headers: {
//         "Authorization": user.user["token"],
//       });
//
//
//
//         if(tagsJson.body.contains("errors")){
//           print("Error on GetBuye");
//           setState(() {
//             BuyerDetails=[
//               {
//                 "lhName": "", "nameLatin": null, "districtName": null, "areaName": null,
//                 "lhPincode": null, "lhGstno": null, "buildingNo": null,
//                 "buildingNoLatin": "","streetName": "", "streetNameLatin": "",
//                 "district": "", "districtLatin": " ", "city": " ", "cityLatin": "",
//                 "country": " ", "countryLatin": "", "pinNo": "","pinNoLatin": ""
//             }];
//           });
//
//         }else {
//           var Buyer =await jsonDecode(tagsJson.body);
//           setState(() {
//           BuyerDetails = Buyer["ledgerHeads"];
//           print("GetBuyerDetails datas :" +BuyerDetails.toString());
//           print(BuyerDetails[0]["lhName"]);
//
//               });
//         }
//     } catch (e) {
//       print("Error on GetBuyerDetails $e");
//     }
//   }
//
//
//
//   GetCompantPro(id)async{
//     print("GetCompantPro");
//     print(id.toString());
//     try {
//       final tagsJson =
//       await http.get("${Env.baseUrl}MCompanyProfiles/$id", headers: {
//         //Soheader //SalesHeaders
//         "Authorization": user.user["token"],
//       });
//       if(tagsJson.statusCode==200) {
//         Companydata = await jsonDecode(tagsJson.body);
//       }
//       print( "on GetCompantPro :" +Companydata.toString());
//       print(  Companydata['companyProfileAddress1'].toString());
//     }
//     catch(e){
//       print("error on GetCompantPro : $e");
//     }
//   }
//
//
//   var  VchDate;
//   var  InvTime;
//   var TotalTax=0.0;
//   var AmountBeforeTax=0.0;
//   var TotalQty=0.0;
//
//   GetdataPrint(id) async {
//     print("sales for print : $id");
//     double amount = 0.0;
//     try {
//       final tagsJson =
//       await http.get("${Env.baseUrl}SalesHeaders/$id", headers: {
//         //Soheader //SalesHeaders
//         "Authorization": user.user["token"],
//       });
//
//
//       dataForTicket = await jsonDecode(tagsJson.body);
//
//      // var ParseDate=dataForTicket['salesHeader'][0]["voucherDate"]??"2022-01-01T00:00:00";
//       var ParseDate=dataForTicket['salesHeader'][0]["entryDate"]??"2022-01-01T00:00:00";
//       // DateTime tempDate = new DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(ParseDate);
//       DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(ParseDate);
//       print(dataForTicket['salesHeader'][0]["voucherDate"]);
//       VchDate=DateTimeFormat.format(tempDate);
//       print(VchDate.toString());
//
//
//       var  tempTime=dataForTicket['salesHeader'][0]["entryDate"]??"2022-01-01T00:00:00";
//       DateTime tempTimeFormate = new DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(tempTime);
//       InvTime= DateFormat.jm().format(tempTimeFormate);
//       // print("tempTime");
//       // print(tempTime);
//       // print("tempTimeFormate");
//       // print(tempTimeFormate);
//       // print("InvTime");
//       // print(InvTime);
//
//       GetBuyerDetails(dataForTicket['salesHeader'][0]["ledgerId"]);
//       Detailspart = dataForTicket['salesDetails'];
//       var  Pattern=Detailspart[0]['itmName'];
//
//
//       print(Detailspart[0]['rate'].runtimeType);
//       print(Detailspart[0]['taxPercentage'].runtimeType);
//       for(int i = 0; i < Detailspart.length; i++)
//       {
//
//         double qty=Detailspart[i]['qty']==null?0.0:(Detailspart[i]['qty']);
//         double rate=Detailspart[i]['rate']==null?0.0:(Detailspart[i]['rate']);
//         double varTxPer=Detailspart[i]['taxPercentage']==null?0.0:(Detailspart[i]['taxPercentage']);
//         double itemTaxrate=Detailspart[i]['taxAmount']??0.0;
//         //  double itemTaxrate=await CalculateTaxAmt(rate,qty,varTxPer);
//         TotalTax=TotalTax+itemTaxrate;
//         TotalQty=TotalQty+qty;
//         AmountBeforeTax=AmountBeforeTax+Detailspart[i]['amountBeforeTax'];
//       }
//       print("TotalTax");
//       print(TotalTax.toString());
//       // if (Pattern.contains(RegExp(r'[a-zA-Z]'))) {
//       //   print("rtertre");
//       //
//       // }else{
//       //   print("Nope, Other characters detected");
//       //   IsArabic=true;
//       // }
//
//       GetArabicAmount(dataForTicket['salesHeader'][0]["amount"]);
//
//       setState(() {
//         IsArabic=true;
//       });
//     } catch (e) {
//       print('error on databinding $e');
//     }
//   }
//
//   //String dropdownValue = '3 Inch';
//   String dropdownValue = 'Tax Invoice';
//
//
//   var  AmtInWrds="";
//   GetArabicAmount(Amount){
//     //  AmtInWrds= arabicAmount.NumberInRiyals(Amount);
//
//   }
//
//
//
//   //
//   // CalculateTaxAmt(double rate,double qty,double taxper){
//   //
//   //   double  _rate=rate??0.0;
//   //   double  _qty=qty??0.0;
//   //   double  _taxper=taxper??0.0;
//   //
//   //
//   //   double Tax=((_rate/100)*_taxper);
//   //   double  TotTax=(Tax*_qty);
//   //   return TotTax;
//   // }
//   ///---------------------------------------------
//
//   @override
//   Widget build(BuildContext context) {
//     var ScreenSize=MediaQuery.of(context).size.width;
//     var ScreenHeight=MediaQuery.of(context).size.height;
//
//     return
//       SafeArea(
//         child: Scaffold(
//           appBar: PreferredSize(preferredSize: Size.fromHeight(80),
//             child: Appbarcustomwidget(uname: userName, branch:branchName, pref: pref, title:"Print"),),
//
//           body: dataForTicket == null ? SizedBox(height: ScreenHeight,width: ScreenSize,
//               child: Center(child: Text("Loading..."))) :
//           Companydata == null ? SizedBox(height: ScreenSize,width: ScreenSize,
//               child: Center(child: Text("Loading..."))) :
//           BuyerDetails.isEmpty ? SizedBox(height: ScreenSize,width: ScreenSize,
//               child: Center(child: Text("Loading..."))) :
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
//           floatingActionButton:
//           // Row(
//           //   mainAxisAlignment: MainAxisAlignment.start,
//           //   crossAxisAlignment: CrossAxisAlignment.start,
//           //   children: [
//               Container(
//                 //color: Colors.red,
//                 height: 30,
//                 //width: 100,
//                 child:  DropdownButton(
//
//                   underline:Container(color: Colors.transparent),
//                   icon:Text("$dropdownValue  ▼",style: TextStyle(color: Colors.white),),
//
//                   items:[
//                     DropdownMenuItem<String>(
//                       value: "Tax Invoice",
//                       child: Text(
//                         "Tax Invoice",style:TextStyle(fontSize: 13),
//                       ),
//                     ),
//
//                     DropdownMenuItem<String>(
//                       value: "Simplified",
//                       child: Text(
//                         "Simplified",style:TextStyle(fontSize: 13),
//                       ),
//                     ),
//
//                     DropdownMenuItem<String>(
//                       value: "A4",
//                       child: Text(
//                         "A4",style:TextStyle(fontSize: 13),
//                       ),
//                     ),
//                     DropdownMenuItem<String>(
//                       value: "3 Inch",
//                       child: Text(
//                         "3 Inch",style:TextStyle(fontSize: 13),
//                       ),
//                     ),
//                     DropdownMenuItem<String>(
//                       value: "2 Inch",
//                       child: Text(
//                         "2 Inch",style:TextStyle(fontSize: 13),
//                       ),
//                     ),
//                   ],
//                   onChanged: (String newValue) {
//                     setState(() {
//                       dropdownValue = newValue;
//                       Pagetype(dropdownValue);
//                       if(dropdownValue== "2 Inch"){
//                         Pg_2_Inch=true;
//                       }
//                     });
//                   },
//
//                 ),
//               ),
//
//
//
//             // ] ),
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
//     final Pdf_fontSize=6.7;
//     final Pdf_Width=570.0;
//     pdf.addPage(
//       pw.Page(
//         margin:pw.EdgeInsets.only(top: 20,left: 10,bottom: 20,right: 10),
//         pageFormat:PgA4==true? PdfPageFormat.a4:PdfPageFormat.roll80,
//         build: (context) {
//           return dataForTicket == null ? pw.Text('') : pw.ListView(
//             children: [
//
//
//               pw.Text(PgA4==true?"فاتورة ضريبية":'فاتورة ضريبية مبسطة', textAlign: pw.TextAlign.center,
//                   textDirection: pw.TextDirection.rtl,
//                   style: pw.TextStyle(
//                       font: ttf,fontSize:Pdf_fontSize)),
//               // pw.Center(child:pw.SizedBox(child: pw.Divider(),width: ScreenSize/9),heightFactor: 0),
//               pw.SizedBox(height: 5),
//
//               pw.Text(PgA4==true?'TAX INVOICE':'Simplified Tax Invoice', textAlign: pw.TextAlign.center,
//                   //textDirection: pw.TextDirection.rtl,
//                   style: pw.TextStyle(fontSize:Pdf_fontSize,
//                       decoration:pw.TextDecoration.underline)),
//
//               pw.SizedBox(height: 5),
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//               pw.SizedBox(height: 10),
//
//
//               PgA4==true? pw.Row(  mainAxisAlignment:  pw.MainAxisAlignment.spaceBetween,
//                   children: [
//
//                     pw.Column(
//                         crossAxisAlignment:  pw.CrossAxisAlignment.start,
//                         mainAxisAlignment:  pw.MainAxisAlignment.start,
//                         children: [
//
//                           pw.Container(
//
//                               width: ScreenSize/1.45,
//                               decoration: pw.BoxDecoration(border: pw.Border.all(
//                                   color: PdfColors.black) ),
//                               child:pw.Padding(padding:pw.EdgeInsets.all(3),
//                                 child:
//                                 pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       pw.Text('Invoice No              : ' +dataForTicket['salesHeader'][0]["voucherNo"].toString(),
//                                           style:pw.TextStyle(fontSize:Pdf_fontSize)),
//
//
//
//                                       pw.Text(" رقم الفاتورة ${dataForTicket['salesHeader'][0]["voucherNo"].toString()} :             ",
//                                           textDirection: pw.TextDirection.rtl,
//                                           style: pw.TextStyle(font: ttf,fontSize:Pdf_fontSize)),
//
//                                     ] ),)
//                           ),
//
//
//
//                           pw.Container(
//
//                               width: ScreenSize/1.45,
//                               decoration: pw.BoxDecoration(border: pw.Border.all(
//                                   color: PdfColors.black) ),
//                               child:pw.Padding(padding:pw.EdgeInsets.all(3),
//                                 child:
//                                 pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       pw.Text('Invoice Issue Date : ' +VchDate.toString(),style:pw.TextStyle(fontSize:Pdf_fontSize)),
//
//
//                                       pw.Text(" تاريخ إصدار الفاتورة ${VchDate.toString()} :  ",
//                                           textDirection: pw.TextDirection.rtl,
//                                           style: pw.TextStyle(font: ttf,fontSize:Pdf_fontSize)),
//
//                                     ] ),)
//                           ),
//
//
//                           // pw.SizedBox(height: 10),
//
//                           pw.Container(
//
//                               width: ScreenSize/1.45,
//                               decoration: pw.BoxDecoration(border: pw.Border.all(
//                                   color: PdfColors.black) ),
//                               child:pw.Padding(padding:pw.EdgeInsets.all(3),
//                                 child:
//                                 pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       pw.Text('Date of Supply       : ' +VchDate.toString(),style:pw.TextStyle(fontSize:Pdf_fontSize)),
//
//
//                                       pw.Text(" تاريخ التوريد ${VchDate.toString()} :           ",
//                                           textDirection: pw.TextDirection.rtl,
//                                           style: pw.TextStyle(font: ttf,fontSize:Pdf_fontSize)),
//
//                                     ] ),))
//
//                         ]),
//
//
//
//                     pw.Padding(padding:pw.EdgeInsets.only(bottom: 5),
//                         child: pw.BarcodeWidget(
//                           // data: widget.Parm_Id.toString(),
//                             data: Qrdata.toString(),
//                             barcode: pw.Barcode.qrCode(),
//                             width: 50,
//                             height: 50
//                         ))
//
//
//
//
//                   ]):
//
//
//               ///---------------------------------------pg 3inch-------------------------------
//
//               pw.Container(
//
//                 child:
//                 pw.Column(
//                     crossAxisAlignment:  pw.CrossAxisAlignment.start,
//                     mainAxisAlignment:  pw.MainAxisAlignment.start,
//                     children: [
//
//
//
//
//                       pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                           children: [
//                             pw.Text('Invoice No              : ' +dataForTicket['salesHeader'][0]["voucherNo"].toString(),
//                                 style:pw.TextStyle(fontSize:Pdf_fontSize)),
//
//
//
//                             pw.Text(" رقم الفاتورة ${dataForTicket['salesHeader'][0]["voucherNo"].toString()} :             ",
//                                 textDirection: pw.TextDirection.rtl,
//                                 style: pw.TextStyle(font: ttf,fontSize:Pdf_fontSize)),
//
//                           ] ),
//
//
//                       pw.SizedBox(height: 2),
//
//
//                       pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                           children: [
//                             pw.Text('Invoice Issue Date : ' +VchDate.toString(),style:pw.TextStyle(fontSize:Pdf_fontSize)),
//                             pw.Text(" تاريخ إصدار الفاتورة ${VchDate.toString()} :  ",
//                                 textDirection: pw.TextDirection.rtl,
//                                 style: pw.TextStyle(font: ttf,fontSize:Pdf_fontSize)),
//
//                           ] ),
//
//
//                       pw.SizedBox(height: 2),
//
//                       pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                           children: [
//                             pw.Expanded(child:  pw.Text('VAT Number : ${Companydata['companyProfileGstNo']??""}',style:pw.TextStyle(fontSize:Pdf_fontSize)),),
//
//                             pw.Text("ظريبه الشراء:  ${Companydata['companyProfileGstNo']??""} ",
//                                 textDirection: pw.TextDirection.rtl,
//                                 style: pw.TextStyle(font: ttf,fontSize:Pdf_fontSize)),
//
//                           ] ),
//
//                    //     pw.SizedBox(height: 10),
//
//
//
//                     ]),
//               ),
//
//               ///---------------------------------------------------------------------------------
//
//
//
//
//               PgA4==true?pw.Directionality(
//                 textDirection:pw.TextDirection.rtl,
//                 child:
//                // pw.Expanded( child:
//                 pw.SizedBox(
//                   //color:PdfColors.red,
//                   child:pw.Row(
//                     mainAxisAlignment: pw.MainAxisAlignment.start,
//                     children: [
//                      pw.Expanded(
//                       //  height: 300,
//                       //  width: Pdf_Width,
//                         child:
//                         pw.Table.fromTextArray(
//                           cellAlignment:pw.Alignment.topRight,
//                           cellAlignments:{0: pw.Alignment.topLeft,
//                             1:pw.Alignment.topLeft,
//                             3:pw.Alignment.topRight,
//                             4: pw.Alignment.topLeft,
//                             5: pw.Alignment.topLeft,
//
//                           },
//                       headerAlignment: pw.Alignment.centerLeft,
//                         headerAlignments:{7: pw.Alignment.centerRight,} ,
//
//
//                           columnWidths:{
//                             1: pw.FixedColumnWidth(80),
//                             2: pw.FixedColumnWidth(80),
//                             5: pw.FixedColumnWidth(80),
//                             6: pw.FixedColumnWidth(80),
//                           },
//
//
//                           headerDecoration: pw.BoxDecoration(
//                             color:PdfColors.grey400,),
//                           headers:
//                           [
//                             "Seller :",
//                             "",
//                             "",
//                             "المورد:",
//
//                             "Buyer :",
//                             "",
//                             "",
//                             "عميل:",
//                           ],
//
//                           data: [
//                             [
//                               "Name",
//                               "${Companydata['companyProfileName']??""}",
//                               "${Companydata['companyProfileNameLatin']??""}",
//                               "اسم",
//
//                               "Name",
//                               "${BuyerDetails[0]['lhName']??""}",
//                               "${BuyerDetails[0]['nameLatin']??""}",
//                               "اسم"
//                             ],
//
//                             [
//                               "Building No",
//                               "${Companydata['buildingNo']??""}",
//                               "${Companydata['buildingNoLatin']??""}",
//                               "لا للبناء",
//
//                               "Building No",
//                               "${BuyerDetails[0]['buildingNo']??""}",
//                               "${BuyerDetails[0]['buildingNoLatin']??""}",
//                               "لا للبناء"
//                             ],
//
//                             [
//                               "Street Name",
//                               "${Companydata['streetName']??""}",
//                               "${Companydata['streetNameLatin']??""}",
//                               "اسم الشارع",
//
//                               "Street Name",
//                               "${BuyerDetails[0]['streetName']??""}",
//                               "${BuyerDetails[0]['streetNameLatin']??""}",
//                               "اسم الشارع"
//                             ],
//
//
//                             [
//                               "District",
//                               "${Companydata['district']??""}",
//                               "${Companydata['districtLatin']??""}",
//                               "يصرف",
//
//                               "District",
//                               "${BuyerDetails[0]['district']??""}",
//                               "${BuyerDetails[0]['districtLatin']??""}",
//                               "يصرف",
//                             ],
//
//
//                             [
//                               "City",
//                               "${Companydata['city']??""}",
//                               "${Companydata['cityLatin']??""}",
//                               "مدينة",
//
//                               "City",
//                               "${BuyerDetails[0]['city']??""}",
//                               "${BuyerDetails[0]['cityLatin']??""}",
//                               "مدينة",
//                             ],
//
//
//                             // ["Country","$CountryName",
//                             //   "$CountryName","دولة"],
//                             [
//                               "Country",
//                               "${Companydata['country']??""}",
//                               "${Companydata['countryLatin']??""}",
//                               "دولة",
//
//                               "Country",
//                               "${BuyerDetails[0]['country']??""}",
//                               "${BuyerDetails[0]['countryLatin']??""}",
//                               "دولة",
//                             ],
//
//
//                             [
//                               "Postal Code",
//                               "${Companydata['pinNo']??""}",
//                               "${Companydata['pinNoLatin']??""}",
//                               "رمز بريدي",
//
//                               "Postal Code",
//                               "${BuyerDetails[0]['pinNo']??""}",
//                               "${BuyerDetails[0]['pinNoLatin']??""}",
//                               "رمز بريدي",
//                             ],
//
//
//                             [
//                               "Additional No",
//                               "",
//                               "",
//                               "رقم إضافي",
//
//                               "Additional No",
//                               "",
//                               "",
//                               "رقم إضافي",
//                             ],
//
//
//                             [
//                               "VAT Number:",
//                               "${Companydata['companyProfileGstNo']??""}",
//                               "${Companydata['companyProfileGstNo']??""}",
//                               "ظريبه الشراء",
//
//                               "VAT Number:",
//                               "${BuyerDetails[0]['lhGstno']??""}",
//                               "${BuyerDetails[0]['lhGstno']??""}",
//                               "ظريبه الشراء",
//                             ],
//
//
//                             [
//                               "Other Seller ID:",
//                               "",
//                               "",
//                               "معرف البائع الآخر",
//
//                               "Other Seller ID:",
//                               "",
//                               "",
//                               "معرف البائع الآخر",
//                             ],
//
//                           ],
//                           headerStyle: pw.TextStyle (font: ttf, fontSize: Pdf_fontSize,color: PdfColors.black),
//                           cellStyle: pw.TextStyle (font: ttf, fontSize: Pdf_fontSize,),
//                         )),
//
//                       ]),
//
//
//                       //  pw.SizedBox(width: 2),
//                       // pw.SizedBox(
//                       //   height: 400,
//                       //   width: Pdf_Width/2,
//                       //   child: pw.Table.fromTextArray(
//                       //     cellAlignment:pw.Alignment.topRight,
//                       //     cellAlignments:{0: pw.Alignment.topLeft,3:pw.Alignment.topRight},
//                       //     columnWidths:{0: pw.FixedColumnWidth(70),},
//                       //      cellHeight: 18.9,
//                       //
//                       //     headerDecoration: pw.BoxDecoration(
//                       //       color:PdfColors.grey400,),
//                       //     headers:
//                       //     ["Buyer:",
//                       //       "",
//                       //       "",
//                       //       "مشتر:"],
//                       //
//                       //     data: [
//                       //       ["Name",
//                       //         "مؤسسة وسائل",
//                       //         "مؤسسة وسائل",
//                       //         "اسم"],
//                       //
//                       //       ["Building No",
//                       //         "657",
//                       //         "657",
//                       //         "لا للبناء"],
//                       //
//                       //       ["Street Name",
//                       //         "حائل",
//                       //         "حائل",
//                       //         "اسم الشارع"],
//                       //
//                       //
//                       //       ["District",
//                       //         "حي المحطة",
//                       //         "حي المحطة",
//                       //         "يصرف"],
//                       //
//                       //
//                       //       ["City","",
//                       //         "","مدينة"],
//                       //
//                       //
//                       //       // ["Country","$CountryName",
//                       //       //   "$CountryName","دولة"],
//                       //       ["Country","المملكة العربية السعودية",
//                       //         "المملكة العربية السعودية","دولة"],
//                       //
//                       //
//                       //       ["Postal Code","",
//                       //         "","رمز بريدي"],
//                       //
//                       //
//                       //       ["Additional No","",
//                       //         "","رقم إضافي"],
//                       //
//                       //
//                       //       ["VAT Number:",
//                       //         "300312566500003",
//                       //         "300312566500003",
//                       //         "ظريبه الشراء"],
//                       //
//                       //
//                       //       ["Other Seller ID:","",
//                       //         "","معرف البائع الآخر"],
//                       //
//                       //     ],
//                       //     headerStyle: pw.TextStyle (font: ttf, fontSize: Pdf_fontSize,color: PdfColors.black),
//                       //     cellStyle: pw.TextStyle (font: ttf, fontSize: Pdf_fontSize,),
//                       //   ),
//                       //
//                       // ),
//                       //
//
//
//
//
//
//                     ),
//
//               ):
//
//               ///-------------------------------3 inc ---------------------------------------------------
//
//
//
//               pw.Text(""),
//
//               pw.SizedBox(height:PgA4==true?20:5),
//
//
//
//              PgA4==true? pw.Container(
//                   decoration: pw.BoxDecoration(
//                       color:PdfColors.grey400,
//                       border: pw.Border.all(
//                           color: PdfColors.black) ),
//                   child:pw.Padding(padding:pw.EdgeInsets.all(3),
//                     child:
//                     pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                         children: [
//                           pw.Text("Line Items:",style: pw.TextStyle(fontSize: Pdf_fontSize,font: ttf,color: PdfColors.black)),
//                           pw.Text("البنود:",style: pw.TextStyle(fontSize: Pdf_fontSize,font: ttf,color: PdfColors.black),
//                             textDirection: pw.TextDirection.rtl,),
//                         ]),
//                   )
//               ): pw.Text(""),
//
//
//
//               ///----------------------------------item Table-------------------------------
//               // pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               //     children: [
//
//               pw.Container(
//                 //   width: ScreenSize+(ScreenSize/8),
//                 //color:  PdfColors.red,
//                   child:  pw.Directionality(
//                       textDirection:pw.TextDirection.rtl,
//                       child:
//                       pw.Table.fromTextArray(
//                           tableWidth:pw.TableWidth.max ,
//                           cellAlignment: pw.Alignment.topRight,
//                           cellAlignments:PgA4==true?{0: pw.Alignment.topLeft,}:{0: pw.Alignment.topRight,},
//                           columnWidths:PgA4==true?{7: pw.FixedColumnWidth(100)}:
//                            {0: pw.FixedColumnWidth(60),3: pw.FixedColumnWidth(60),},
//
//                           cellStyle: pw.TextStyle(font: ttf,fontSize: Pdf_fontSize),
//                           headerStyle: pw.TextStyle(fontWeight:pw.FontWeight.bold,font: ttf,fontSize:Pdf_fontSize,),
//                           headerAlignment:pw.Alignment.topRight,
//                           headerAlignments:PgA4==true?{} :{0: pw.Alignment.topLeft},
//                           headerDecoration: pw.BoxDecoration(border: pw
//                               .Border(bottom: pw.BorderSide(
//                               color: PdfColors.black)),
//                           color:PgA4==true?PdfColors.white:PdfColors.grey400),
//
//                           cellPadding:pw.EdgeInsets.all(1),
//
//                           headers:TblHeader,
//                           data: TableGenerator()
//                       )
//                   )
//               ),
//
//
//
//
//
//
//
//
//
//
//               pw.SizedBox(height:PgA4==true?20:5),
//
//
//
//
//               PgA4==true?pw.Container(
//                   decoration: pw.BoxDecoration(
//                       color:PdfColors.grey400,
//                       border: pw.Border.all(
//                           color: PdfColors.black) ),
//                   child:pw.Padding(padding:pw.EdgeInsets.all(3),
//                     child:
//                     pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                         children: [
//                           pw.Text("Total amounts:",style: pw.TextStyle(fontSize: Pdf_fontSize,font: ttf,color: PdfColors.black)),
//                           pw.Text("المبالغ الإجمالية:",style: pw.TextStyle(fontSize: Pdf_fontSize,font: ttf,color: PdfColors.black),
//                             textDirection: pw.TextDirection.rtl,),
//                         ]),
//                   )
//               ):pw.Text(""),
//
//               PgA4==true?  pw.Directionality(
//                 textDirection:IsArabic==true? pw.TextDirection.rtl: pw.TextDirection.ltr,
//                 child:
//                 pw.Table.fromTextArray(
//                     headerAlignments:{1: pw.Alignment.topLeft,2:pw.Alignment.topRight,3:pw.Alignment.centerRight} ,
//                     cellAlignments:{1: pw.Alignment.topLeft,2:pw.Alignment.topRight,3:pw.Alignment.centerRight},
//                     columnWidths:{0: pw.FixedColumnWidth(100),},
//                     headerStyle: pw.TextStyle (font: ttf, fontSize: 10,),
//                     cellStyle: pw.TextStyle (font: ttf, fontSize: 10,),
//
//
//                     headers:
//
//
//
//
//                     ["",
//                       "Total (Excluding VAT)",
//                       "الإجمالي)باستثناء ضريبة القيمة المضافة(",
//                       "${AmountBeforeTax.toStringAsFixed(2)} ${currencyName??""}",
//                     ],
//
//                     data: [
//
//                       [   "",
//                         "Discount",
//                         "خصم",
//                         "0.00 ${currencyName??""}",
//                       ],
//
//                       [   "",
//                         "Total Taxable Amount (Excluding VAT)",
//                         "إجمالي المبلغ الخاضع للضريبة )باستثناء ضريبة القيمة المضافة(",
//                         "${AmountBeforeTax.toStringAsFixed(2)} ${currencyName??""}",
//                       ],
//
//
//
//                       [   "",
//                         "Total VAT",
//                         " ضريبة القيمة المضافة",
//                         "${TotalTax==null?0.toStringAsFixed(2):
//                         TotalTax.toStringAsFixed(2)} ${currencyName??""}",
//                       ],
//
//
//                       [   "",
//                         "Total Amount Due",
//                         "إجمالي المبلغ المستحق",
//                         "${dataForTicket['salesHeader'][0]["amount"]==null?0.toStringAsFixed(2):
//                         dataForTicket['salesHeader'][0]["amount"].toStringAsFixed(2)} ${currencyName??""}",
//                       ],
//
//
//                     ]
//                 ),
//               ):
//
//               ///---------------------------------3 inc -----------------------------------------------
//
// //               pw.Directionality(
// //                 textDirection:IsArabic==true? pw.TextDirection.rtl: pw.TextDirection.ltr,
// //                 child:
// //                 pw.Table.fromTextArray(
// //                     headerAlignments:PgA4==true?{1: pw.Alignment.topLeft,2:pw.Alignment.topRight,3:pw.Alignment.centerRight} :
// //                     {0: pw.Alignment.topRight,1:pw.Alignment.topRight,2:pw.Alignment.centerRight},
// //                     cellAlignments:PgA4==true?{1: pw.Alignment.topLeft,2:pw.Alignment.topRight,3:pw.Alignment.centerRight}:
// //                     {0: pw.Alignment.topLeft,1:pw.Alignment.topRight,2:pw.Alignment.centerRight},
// //                     // columnWidths:{0: pw.FixedColumnWidth(100),},
// //                     headerStyle: pw.TextStyle (font: ttf, fontSize: Pdf_fontSize,),
// //                     cellStyle: pw.TextStyle (font: ttf, fontSize: Pdf_fontSize,),
// //                     columnWidths:PgA4==true?{}:{2: pw.FixedColumnWidth(100),0: pw.FixedColumnWidth(150),},
// //
// // border:pw.TableBorder(left: pw.BorderSide.none,
// //  bottom: pw.BorderSide(color: PdfColors.black),
// // top: pw.BorderSide(color: PdfColors.black),),
// //                     headers:
// //                     [
// //                       "TotalTaxable\tAmount\t(ExcludingVAT)",
// //                       "إجمالي المبلغ الخاضع للضريبة (باستثناء ضريبة القيمة المضافة)",
// //                       "${AmountBeforeTax.toStringAsFixed(2)}",
// //                     ],
// //
// //                     data: [
// //                       [
// //                         "Total VAT",
// //                         "إجمالي ضريبة القيمة المضافة",
// //                         "${TotalTax==null?0.toStringAsFixed(2):
// //                         TotalTax.toStringAsFixed(2)}",
// //                       ],
// //
// //
// //                       [
// //                         "Total Amount Due",
// //                         "إجمالي المبلغ المستحق",
// //                         "${dataForTicket['salesHeader'][0]["amount"]==null?0.toStringAsFixed(2):
// //                         dataForTicket['salesHeader'][0]["amount"].toStringAsFixed(2)}",
// //                       ],
// //
// //
// //                     ]
// //                 ),
// //               ),
//
//
//
//
//               PgA4==true?pw.Text(""):pw.Divider(height: 1,thickness: 1,color: PdfColors.black),
//               pw.SizedBox(height:3),
//               PgA4==true?pw.Text(""):pw.Column(
//     children: [
//   pw.Row(
//       mainAxisAlignment:pw.MainAxisAlignment.start,
//    // crossAxisAlignment:pw.CrossAxisAlignment.end,
//       children:[
//
//     pw.Expanded(child:pw.Text("Total Taxable Amount (Excluding VAT)",style: pw.TextStyle(fontSize: Pdf_fontSize,))),
//         pw. Spacer(),
//           pw.Expanded(child:pw.Text("الإجمالي الخاضع للضریبة )غیر شامل ضریبة القیمة المضافة(",style: pw.TextStyle(fontSize: Pdf_fontSize,font: ttf,color: PdfColors.black),
//           textDirection: pw.TextDirection.rtl,)),
//
//          pw. Spacer(),
//
//           pw.Text("${AmountBeforeTax.toStringAsFixed(2)} ${currencyName??""}",style: pw.TextStyle(fontSize: Pdf_fontSize,)),
//   ]),
//
//
//
//       pw.SizedBox(height:5),
//
//  pw.Row(
//     mainAxisAlignment:pw.MainAxisAlignment.spaceBetween,
//       children:[
//
//         pw.Expanded(child:pw.Text("Total VAT",style: pw.TextStyle(fontSize: Pdf_fontSize,))),
//        pw. Spacer(),
//         pw.Expanded(child:pw.Text(" ضريبة القيمة المضافة",style: pw.TextStyle(fontSize: Pdf_fontSize,font: ttf,color: PdfColors.black),
//           textDirection: pw.TextDirection.rtl,)),
//
//          pw. Spacer(),
//
//         pw.Text("  ${TotalTax==null?0.toStringAsFixed(2):
//                        TotalTax.toStringAsFixed(2)} ${currencyName??""}",style: pw.TextStyle(fontSize: Pdf_fontSize,)),
//       ]),
//
//
//
//
//
//       pw.SizedBox(height:5),
//
//
//
//
//
//   pw.Row(
//     mainAxisAlignment:pw.MainAxisAlignment.spaceAround,
//       children:[
//
//         pw.Expanded(child:pw.Text("Total Amount Due",style: pw.TextStyle(fontSize: Pdf_fontSize,))),
//         pw. Spacer(),
//         pw.Expanded(child:pw.Text("إجمالي المبلغ المستحق",style: pw.TextStyle(fontSize: Pdf_fontSize,font: ttf,color: PdfColors.black),
//           textDirection: pw.TextDirection.rtl,)),
//
//         pw. Spacer(),
//         pw.Text("${dataForTicket['salesHeader'][0]["amount"].toStringAsFixed(2)} ${currencyName??""}",style: pw.TextStyle(fontSize: Pdf_fontSize,)), ]),
//
//
//
//
//
//
//
//
// ]),
//
//
//
//
//
//               pw.SizedBox( height: 5,),
//
//               PgA4==true?pw.Text("") : pw.Padding(padding:pw.EdgeInsets.only(bottom: 5),
//                   child: pw.BarcodeWidget(
//                     // data: widget.Parm_Id.toString(),
//                       data: Qrdata.toString(),
//                       barcode: pw.Barcode.qrCode(),
//                       width: 50,
//                       height: 50
//                   )),
//
//
//               pw.Row(
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                   children:[
//                     pw.SizedBox(
//                       height: 2,),
//
//
//                     pw.SizedBox(
//                       width: 20,),
//                     pw.SizedBox(height: 2),
//
//
//                     // pw.SizedBox(height: 50,width: 100,child:
//                     // pw.BarcodeWidget(
//                     //     data: widget.Parm_Id.toString(),
//                     //     barcode: pw.Barcode.code39(),
//                     //     width: 100,
//                     //     height: 50
//                     // ),
//                     // )
//
//                   ]),
//
//               //   pw.SizedBox(height: 2),
//               //   pw.Text(footerCaptions[0]['footerText']+"...",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,font: ttf,fontSize: Pdf_fontSize))
//
//             ],
//
//
//           );
//         },
//       ),
//     );
//
//     return pdf.save();
//   }
//
//   pw.Container Seller_Buyer_Table({
//     double Pdf_fontSize,
//     pw.Font ttf,
//     String Arabic_Label,
//     String Label,
//     dynamic dataValue
//   })
//   {
//     return pw.Container(
//         decoration: pw.BoxDecoration(border: pw.Border.all(
//             color: PdfColors.black) ),
//         child:pw.Padding(padding:pw.EdgeInsets.all(3),
//           child:
//           pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end,
//               children: [
//                 pw.Text('$Label : ',style:pw.TextStyle(fontSize:Pdf_fontSize)),
//
//
//                 pw.Text(" : $Arabic_Label${dataValue.toString()}",
//                     textDirection: pw.TextDirection.rtl,
//                     style: pw.TextStyle(font: ttf,fontSize:Pdf_fontSize)),
//
//               ] ),)
//     );
//   }
//
//
//
//
//   var TblHeader;
//   TableGenerator() {
//     //   PgA4==true?TblHeader= ['Amount\n المجموع', 'TaxAmt\n مبلغ الضريبة', 'Tax%\n  الضريبة٪',"Total\n مجموع", 'Qty\n كمية', 'Price\n  معدل\n','Unit\n وحدة', 'name\tItem\n التفاصيل','No\n عدد']:
//     PgA4==true?TblHeader= [
//       'طبيعة السلع  أو الخدمات  Nature of goods or services ',
//
//       'Price\tUnit\n سعر الوحدة',
//
//       'Quantity\n كمية',
//
//       "Amount\tTaxable\n المبلغ الخاضع للضريبة",
//
//       'Discount\n خصم',
//
//       'Rate\tTax\n معدل الضريبة',
//
//       'Amount\tTax\n قيمة الضريبة',
//
//       'ItemSubtotal\n (Including VAT)   البند المجموع الفرعي )متضمنًا ضريبة القيمة المضافة(',
//     ]:
//     TblHeader= [
//       // 'طبيعة السلع  أو الخدمات  Nature of goods or services ',
//      //'طبيعة السلع  أو الخدمات   Nature of goods or services',
//       'or\tgoods\tof\tNature\tservices\n'+' طبيعة السلع  أو الخدمات',
//       'Price\tUnit\n سعر الوحدة',
//       'Quantity\n كمية',
//     '(Including VAT) Item Subtotal  المجموع )شامل ضریبة القیمة المضافة('
//
//
//       //'(IncludingVAT)\n  ItemSubtotal    (بما في ذلك ضريبة القيمة المضافة)  المجموع الفرعي للعنصر  ',
//     ];
//
//
//
//
//
//     var purchasesAsMap;
//
//     if(PgA4==true) {
//       var Slnum=0;
//       purchasesAsMap = <Map<String, String>>[
//         for(int i = 0; i < Detailspart.length; i++)
//           {
//
//             "ItemName": "${Detailspart[i]['itmName']??""} ${Detailspart[i]['itmArabicName']??""}",
//             "Rate": "${Detailspart[i]['rate'].toStringAsFixed(2)} ",
//             "Qty": "${Detailspart[i]['qty']} ",
//             "total": "${(Detailspart[i]['qty']??0.0)*(Detailspart[i]['rate']??0.0)} ",
//             "discount": "0.0",
//             "TaxPer": "${Detailspart[i]['taxPercentage']==null?"0.00":Detailspart[i]['taxPercentage'].toStringAsFixed(2)} ",
//             "TaxAmt": "${Detailspart[i]['taxAmount'].toStringAsFixed(2)=="0.00"?"":Detailspart[i]['taxAmount'].toStringAsFixed(2)} ",
//             "NetAmt": "${Detailspart[i]['amountIncludingTax'].toStringAsFixed(2)} ",
//
//
//
//
//
//             // "NetAmt": "${Detailspart[i]['amountIncludingTax'].toStringAsFixed(2)} ",
//             // //"sssf": "${CalculateTaxAmt((Detailspart[i]['rate']),(Detailspart[i]['qty']),(Detailspart[i]['taxPercentage']))} ",
//             // "TaxAmt": "${Detailspart[i]['taxAmount'].toStringAsFixed(2)=="0.00"?"":Detailspart[i]['taxAmount'].toStringAsFixed(2)} ",
//             // "TaxPer": "${Detailspart[i]['taxPercentage']==null?"0.00":Detailspart[i]['taxPercentage'].toStringAsFixed(2)} ",
//             // "total": "${(Detailspart[i]['qty']??0.0)*(Detailspart[i]['rate']??0.0)} ",
//             // "Qty": "${Detailspart[i]['qty']} ",
//             // "Rate": "${Detailspart[i]['rate'].toStringAsFixed(2)} ",
//             // "Unit": "${Detailspart[i]['uom']??""} ",
//             // "ItemName": "${Detailspart[i]['itmName']??""} ${Detailspart[i]['itmArabicName']??""}",
//             // "No": "${(++Slnum).toString()} ",
//
//           },
//       ];
//     }  else{
//       purchasesAsMap = <Map<String, String>>[
//         for(int i = 0; i < Detailspart.length; i++)
//           {
//             "ItemName": "${Detailspart[i]['itmName']??""}  ${Detailspart[i]['itmArabicName']??""}",
//              "Rate": "${Detailspart[i]['rate'].toStringAsFixed(2)} ",
//             // "total": "${(Detailspart[i]['qty']??0.0)*(Detailspart[i]['rate']??0.0)} ",
//             "Qty": "${Detailspart[i]['qty']} ",
//             "NetAmt": "${Detailspart[i]['amountIncludingTax'].toStringAsFixed(2)} ",
//           },
//       ];
//     }
//
//
//
//     List<List<String>> listOfPurchases = List();
//     for (int i = 0; i < purchasesAsMap.length; i++) {
//       listOfPurchases.add(purchasesAsMap[i].values.toList());
//     }
//     return listOfPurchases;
//   }
//
//
//
//
//   // ['Amount المجموع', 'TaxAmt\n مبلغ الضريبة', 'Tax% الضريبة٪', 'Qty\n كمية', 'Price معدل', 'name\tItem\n التفاصيل']
//
//
//   Pagetype(pgTyp){
//     if(pgTyp=="3 Inch"|| pgTyp=="A4"){
//
// Navigator.of(context,rootNavigator: true).pop();
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) =>
//               Pdf_Print(Parm_Id:widget.Parm_Id,Page_Type:pgTyp=="A4"?"A4":"3 Inch")));
//
//
//     }else{
//
//
//       setState(() {
//         Pg_2_Inch=false;
//         pgTyp == "Tax Invoice" ? PgA4 = true : PgA4 = false;
//         PgA4 == true ?
//         TblHeader = <dynamic>  [
//           'طبيعة السلع  أو الخدمات  Nature of goods or services ',
//
//           'Price\tUnit\n سعر الوحدة',
//
//           'Quantity\n كمية',
//
//           "Amount\tTaxable\n المبلغ الخاضع للضريبة",
//
//           'Discount\n خصم',
//
//           'Rate\tTax\n معدل الضريبة',
//
//           'Amount\tTax\n قيمة الضريبة',
//
//           'ItemSubtotal\n (Including VAT)   البند المجموع الفرعي )متضمنًا ضريبة القيمة المضافة(',
//         ]:
//         TblHeader = <dynamic>
//         [
//           'or\tgoods\tof\tNature\tservices\n'+' طبيعة السلع  أو الخدمات',
//           'Price\tUnit\n سعر الوحدة',
//           'Quantity\n كمية',
//           '(Including VAT) Item Subtotal  المجموع )شامل ضریبة القیمة المضافة('
//         ];
//         print("PgA4");
//         print(PgA4);
//
//       });
//
//     }
//
//
//
//   }
//
//
//
//
// }
//
//
//











