import 'dart:convert';
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

class Dynamic_Pdf_Print extends StatefulWidget {
  var Parm_Id;
  var Details_Data;
  var title;
  Dynamic_Pdf_Print({this.Parm_Id,this.Details_Data,this.title});

  @override
  _Dynamic_Pdf_PrintState createState() => _Dynamic_Pdf_PrintState();
}

class _Dynamic_Pdf_PrintState extends State<Dynamic_Pdf_Print> {

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
  var  Companydata;


  String IsArabicChkBoxText="Arabic";
  var Pdf_fontSize=9.0;
  var  TaxType;
  var  TableKeys=[];
 bool Contain_ID=false;

  NumberToWord arabicAmount = NumberToWord();


  void initState() {
    setState(() {
      SharedPreferences.getInstance().then((value) {
        pref = value;
        read();

       Detailspart= widget.Details_Data;
        dataForTicket= widget.Details_Data;

        GetQrdata();
        GeneralSettings();
        DynamicDatakey();
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
        GenSettingsData[0]["applicationTaxTypeGst"] ==true ?
        TaxType = "Gst.No" : TaxType = "Vat.No";
        print("TaxType");
        print(TaxType);

      });
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













  ///---------------------------------------------

  @override
  Widget build(BuildContext context) {
    var ScreenSize=MediaQuery.of(context).size.width;

    return
      SafeArea(
        child: Scaffold(
          appBar: PreferredSize(preferredSize: Size.fromHeight(80),
            child: Appbarcustomwidget(uname: userName, branch:branchName, pref: pref, title:"Print"),),

          body: dataForTicket == null ? SizedBox(height: ScreenSize,width: ScreenSize,
              child: Center(child: Text("Loading..."))) :
          Companydata == null ? SizedBox(height: ScreenSize,width: ScreenSize,
              child: Center(child: Text("Loading..."))) :


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


             Detailspart == null ? pw.Text('') :
                 pw.Center(child:


                 pw.Column(

            mainAxisAlignment:pw.MainAxisAlignment.center,
            crossAxisAlignment:pw.CrossAxisAlignment.center,
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
            pw.Text('${(widget.title)??"Report"}', textAlign: pw.TextAlign.center,
            //textDirection: pw.TextDirection.rtl,
            style: pw.TextStyle(
            fontSize: Pdf_fontSize,
            // font: ttf,
            decoration:pw.TextDecoration.underline)),

            pw.SizedBox(height: 5),

            ]),
                 ),

                  pw.SizedBox(
                    height: 2,),



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
                                    headers:TblHeader,
                                    data:TableGenerator()
                                   // data: [Detailspart]
                                )
                            ),

                  pw.SizedBox( height: 2,),


            ];
        },
      ),
    );

    return pdf.save();
  }


  DynamicDatakey(){


    var ss=  Detailspart[0].keys.forEach((key){
      TableKeys.add(key);
      return key;
    });

    print("ssssssssssss");
    if(TableKeys.contains("Id")){
      print(TableKeys.remove("Id"));
      TableKeys.insert(0, "No");
      Contain_ID=true;
    }


    var s= TableKeys.map((headingdata) {

      String jsonTex =headingdata;
      return jsonTex;
    });

    print("DynamicDatakey");
    print(s);

   var  purchasesAsMap=Detailspart as List;


   print(purchasesAsMap);
  }


  getItemIndex(dynamic item) {
    var index = Detailspart.indexOf(item);
    return index + 1;
  }
  var TblHeader;
  TableGenerator() {
    TblHeader=TableKeys;
    print("TblHeader");
    List<List<dynamic>> listOfPurchases = [];
    for (int i = 0; i < Detailspart.length; i++) {
      listOfPurchases.add(Detailspart[i].values.toList());
      if(Contain_ID==true){
        listOfPurchases[i].removeAt(0);
        listOfPurchases[i].insert(0, "${i+1}");
      }

    }
    print(listOfPurchases);
    return listOfPurchases;
  }

}






























///----------------------------------------------------------------------


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
// class Dynamic_Pdf_Print extends StatefulWidget {
//   var Parm_Id;
//   var Details_Data;
//   var title;
//   Dynamic_Pdf_Print({this.Parm_Id,this.Details_Data,this.title});
//
//   @override
//   _Dynamic_Pdf_PrintState createState() => _Dynamic_Pdf_PrintState();
// }
//
// class _Dynamic_Pdf_PrintState extends State<Dynamic_Pdf_Print> {
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
//   var Pdf_fontSize=9.0;
//   var  TaxType;
//   var  TableKeys=[];
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
//         //   GetdataPrint(widget.Parm_Id);
//         Detailspart= widget.Details_Data;
//         dataForTicket= widget.Details_Data;
//         footerdata();
//         GetQrdata();
//         GeneralSettings();
//         DynamicDatakey();
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
//         IsArabic=false;
//       });
//
//
//
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
//     AmtInWrds= arabicAmount.NumberInRiyals(Amount,"riyals","halala");
//
//   }
//
//
//
//
//
//
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
//           body: dataForTicket == null ? SizedBox(height: ScreenSize,width: ScreenSize,
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
//
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
//         build: (pw.Context context) {
//           return <pw.Widget
//           >[
//
//
//             Detailspart == null ? pw.Text('') :
//             pw.Center(child:
//
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
//
//                   pw.Text(Companydata['companyProfileEmail']??"", textAlign: pw.TextAlign.center,
//                       textDirection: pw.TextDirection.rtl,
//                       style: pw.TextStyle(
//                           fontSize: Pdf_fontSize,
//                           font: ttf
//                       )),
//                   pw.SizedBox(height: 5),
//                   pw.Text('${(widget.title)??"Report"}', textAlign: pw.TextAlign.center,
//                       //textDirection: pw.TextDirection.rtl,
//                       style: pw.TextStyle(
//                           fontSize: Pdf_fontSize,
//                           // font: ttf,
//                           decoration:pw.TextDecoration.underline)),
//
//                   pw.SizedBox(height: 5),
//                   //
//                   // pw.Text("فاتورة ضريبية", textAlign: pw.TextAlign.center,
//                   //     textDirection: pw.TextDirection.rtl,
//                   //     style: pw.TextStyle(
//                   //       fontSize: Pdf_fontSize,
//                   //       font: ttf, )),
//                   // pw.Center(child:pw.SizedBox(child: pw.Divider(),width: ScreenSize/9),heightFactor: 0),
//                   // pw.SizedBox(height: 5),
//
//                 ]),
//             ),
//
//
//             pw.SizedBox(
//               height: 2,),
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
//             // pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//             //     children: [
//             //
//             //
//             //       IsArabic==true ?pw.Padding(padding:pw.EdgeInsets.only(bottom: 5),
//             //           child: pw.BarcodeWidget(
//             //             // data: widget.Parm_Id.toString(),
//             //               data: Qrdata.toString(),
//             //               barcode: pw.Barcode.qrCode(),
//             //               width: 50,
//             //               height: 50
//             //           )):
//             //       pw.Text(""),
//             //
//             //
//             //       // pw.Container(
//             //       //   //color: PdfColors.black,
//             //       //   width:ScreenSize,
//             //       //   child:            pw.Column(
//             //       //       crossAxisAlignment:IsArabic==true ?pw.CrossAxisAlignment.end:pw.CrossAxisAlignment.start,
//             //       //       mainAxisAlignment: pw.MainAxisAlignment.start,
//             //       //       children: [
//             //       //
//             //       //         ///-----------
//             //       //         IsArabic==true?  pw.Text("رقم الفاتورة    ${dataForTicket['salesHeader'][0]["voucherNo"].toString()}  :     ",
//             //       //             textDirection: pw.TextDirection.rtl,
//             //       //             style: pw.TextStyle(font: ttf, fontSize: Pdf_fontSize,)):
//             //       //
//             //       //
//             //       //         pw.Text('Invoice No   : ' +dataForTicket['salesHeader'][0]["voucherNo"].toString(),
//             //       //             // textAlign: pw.TextAlign.left,
//             //       //             // textDirection: pw.TextDirection.rtl,
//             //       //             style: pw.TextStyle(font: ttf, fontSize: Pdf_fontSize,)),
//             //       //
//             //       //
//             //       //
//             //       //         ///-----------
//             //       //         // IsArabic==true? pw.Text("رقم الأمر${(dataForTicket['salesHeader'][0]["orderNo"].toString())=="null"?"         - "
//             //       //         //     :"           "+ dataForTicket['salesHeader'][0]["orderNo"].toString()} :       ",
//             //       //         //     textDirection: pw.TextDirection.rtl,
//             //       //         //     style: pw.TextStyle(font: ttf)):
//             //       //         //
//             //       //         // pw.Text(dataForTicket['salesHeader'][0]["orderNo"]==null?
//             //       //         // "  Order No     : -":
//             //       //         // '  Order No     : ' +
//             //       //         //     dataForTicket['salesHeader'][0]["orderNo"].toString()),
//             //       //
//             //       //
//             //       //         ///-----------
//             //       //         IsArabic==true? pw.Text("تاريخ${(VchDate.toString())=="null"?"       - "
//             //       //             :"                 "+ VchDate.toString()} :            ",
//             //       //             textDirection: pw.TextDirection.rtl,
//             //       //             style: pw.TextStyle(font: ttf, fontSize: Pdf_fontSize,)):
//             //       //
//             //       //         pw.Text(VchDate==null?
//             //       //         "Inv.Date      : -":
//             //       //         'Inv.Date      : ' + VchDate.toString(),
//             //       //             style: pw.TextStyle(font: ttf, fontSize: Pdf_fontSize,)),
//             //       //
//             //       //
//             //       //
//             //       //
//             //       //
//             //       //         ///-----------
//             //       //         IsArabic==true? pw.Text("زمن${(InvTime.toString())=="null"?"       - "
//             //       //             :"                 "+ InvTime.toString()} :             ",
//             //       //             textDirection: pw.TextDirection.rtl,
//             //       //             style: pw.TextStyle(font: ttf, fontSize: Pdf_fontSize,)):
//             //       //
//             //       //         pw.Text(InvTime==null?
//             //       //         "Time            : -":
//             //       //         'Time            : ' + InvTime.toString(),
//             //       //             style: pw.TextStyle(font: ttf, fontSize: Pdf_fontSize,)),
//             //       //         //
//             //       //         //
//             //       //         //
//             //       //         //
//             //       //         //
//             //       //         //
//             //       //         // IsArabic==true? pw.Text("تاريخ الطباعة ${(VchDate.toString())=="null"?"       - "
//             //       //         //     :"                 "+ VchDate.toString()} :  ",
//             //       //         //     textDirection: pw.TextDirection.rtl,
//             //       //         //     style: pw.TextStyle(font: ttf)):
//             //       //         //
//             //       //         // pw.Text(VchDate==null?
//             //       //         // "  Print Date   : -":
//             //       //         // '  Print Date   : ' + VchDate.toString(),
//             //       //         //     style: pw.TextStyle(font: ttf)),
//             //       //
//             //       //
//             //       //
//             //       //
//             //       //         ///-----------
//             //       //         IsArabic==true?pw.Text('توصيل   ${"    ${dataForTicket['salesHeader'][0]["lhContactNo"]??""}     "+dataForTicket['salesHeader'][0]["partyName"]} :     ',
//             //       //             textDirection: pw.TextDirection.rtl,
//             //       //             style: pw.TextStyle(font: ttf)):
//             //       //         pw.Text('Customer    : ${dataForTicket['salesHeader'][0]["partyName"]}  ${dataForTicket['salesHeader'][0]["lhContactNo"]??""}',
//             //       //             style: pw.TextStyle(font: ttf, fontSize: Pdf_fontSize,)),
//             //       //
//             //       //
//             //       //
//             //       //
//             //       //
//             //       //         ///----------------------------
//             //       //
//             //       //         dataForTicket['salesHeader'][0]["lhGstno"]!=null?
//             //       //         IsArabic==true? pw.Text("ظريبه الشراء ${dataForTicket['salesHeader'][0]["lhGstno"].toString()=="null"?"":dataForTicket['salesHeader'][0]["lhGstno"].toString()} :  ",
//             //       //             textDirection: pw.TextDirection.rtl,
//             //       //             style: pw.TextStyle(font: ttf,fontSize: Pdf_fontSize,)):
//             //       //
//             //       //         pw.Text(
//             //       //             TaxType+"         :${dataForTicket['salesHeader'][0]["lhGstno"].toString()=="null"?"":dataForTicket['salesHeader'][0]["lhGstno"].toString()}",style: pw.TextStyle(font: ttf,fontSize: Pdf_fontSize,)):
//             //       //         pw.Text("")
//             //       //
//             //       //
//             //       //
//             //       //
//             //       //
//             //       //       ]),
//             //       // ),
//             //       //
//             //       //
//             //       //
//             //
//             //
//             //
//             //
//             //
//             //
//             //
//             //
//             //
//             //
//             //       IsArabic==false ?pw.Padding(padding:pw.EdgeInsets.only(bottom: 5),
//             //           child: pw.BarcodeWidget(
//             //             // data: widget.Parm_Id.toString(),
//             //               data: Qrdata.toString(),
//             //               barcode: pw.Barcode.qrCode(),
//             //               width: 50,
//             //               height: 50
//             //           )):
//             //       pw.Text("")
//             //
//             //     ]),
//
//
//
//
//
//
//
//
//
//             pw.Partition(
//                 child:
//                 pw.Table.fromTextArray(
//                     tableWidth:pw.TableWidth.max ,
//                     // border:pw.TableBorder(
//                     //   top: pw.BorderSide(
//                     //       color: PdfColors.black),
//                     //
//                     //   bottom: pw.BorderSide(
//                     //       color: PdfColors.black),),
//
//
//
//                     cellAlignment: pw.Alignment.topRight,
//                     cellAlignments:IsArabic==true? {1: pw.Alignment.topRight,7:pw.Alignment.topRight}: {1: pw.Alignment.topLeft,},
//                     columnWidths:IsArabic==true?
//                     {7: pw.FixedColumnWidth(150),1:pw.FixedColumnWidth(60),0:pw.FixedColumnWidth(50),8:pw.FixedColumnWidth(20),}:
//                     {0:pw.FixedColumnWidth(15),},
//
//                     cellStyle: pw.TextStyle(font: ttf,fontSize: Pdf_fontSize),
//                     headerStyle: pw.TextStyle(fontWeight:pw.FontWeight.bold,font: ttf,fontSize: 11,),
//                     headerAlignment:pw.Alignment.topRight,
//                     headerAlignments:IsArabic==true? {1: pw.Alignment.topRight,7:pw.Alignment.topRight}: {1: pw.Alignment.topLeft},
//                     headerDecoration: pw.BoxDecoration(border: pw
//                         .Border(bottom: pw.BorderSide(
//                         color: PdfColors.black))),
//
//                     cellPadding:pw.EdgeInsets.all(1),
//
//
//                     headers:TblHeader,
//                     data:TableGenerator()
//                   // data: [Detailspart]
//                 )
//             ),
//
//
//
//
//
//
//
//             //pw.SizedBox( height: 2,),
//
//             //  pw.Container(width:PgA4==true? ScreenSize/1.07:ScreenSize/1.5,
//             // pw.Container(width:ScreenSize+(ScreenSize/8),
//             //     //color:  PdfColors.red,
//             //     child:
//             //     pw.Row(
//             //         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//             //         children: [
//             //
//             //           IsArabic==true?pw.Expanded(child:
//             //           pw.Align(alignment: pw.Alignment.topLeft,
//             //             child:pw.Flex(crossAxisAlignment: pw.CrossAxisAlignment.start,
//             //                 direction: pw.Axis.vertical,
//             //                 children: [
//             //                   pw.Text("          :   $TotalQty الكمية الإجمالية",style: pw.TextStyle(fontSize: Pdf_fontSize,font: ttf),
//             //                     textDirection: pw.TextDirection.rtl,),
//             //
//             //                   pw.Text(" : $AmtInWrds المبلغ الصافي بالكلمات",style: pw.TextStyle(fontSize: Pdf_fontSize,font: ttf),
//             //                     textDirection: pw.TextDirection.rtl,),
//             //
//             //                 ]),),
//             //
//             //
//             //
//             //
//             //
//             //
//             //           ):
//             //           pw.Expanded(child:
//             //           pw.Text("Total Quantity             :  $TotalQty \nNet Amount in Words : $AmtInWrds",style: pw.TextStyle(fontSize: Pdf_fontSize))),
//             //
//             //
//             //
//             //
//             //
//             //
//             //           IsArabic==false?pw.Column(
//             //               children: [
//             //                 pw.SizedBox(height: 5),
//             //                 pw.Text("Total Amount Exc Vat  :  ",style: pw.TextStyle(fontSize: 10,font: ttf),  textDirection: pw.TextDirection.rtl,),
//             //                 pw.Text("Vat Amount                 :  ",style: pw.TextStyle(fontSize: 10,font: ttf) , textDirection: pw.TextDirection.rtl,),
//             //                 pw.Text("Net Amount     :  ", style: pw.TextStyle(fontSize: 15,fontWeight: pw.FontWeight.bold,font: ttf),  textDirection: pw.TextDirection.rtl,)
//             //               ]):
//             //
//             //           pw.Column(
//             //               crossAxisAlignment:pw.CrossAxisAlignment.end,
//             //               children: [
//             //                 pw.SizedBox(height: 5),
//             //
//             //
//             //                 pw.Text("${AmountBeforeTax.toStringAsFixed(2)} : ",style: pw.TextStyle(fontSize: 10,font: ttf),textDirection: pw.TextDirection.rtl,),
//             //                 // pw.Text("${dataForTicket['salesHeader'][0]["amount"]==null?0.toStringAsFixed(2):
//             //                 // dataForTicket['salesHeader'][0]["amount"].toStringAsFixed(2)} : ",style: pw.TextStyle(fontSize: 10,font: ttf),textDirection: pw.TextDirection.rtl,),
//             //
//             //
//             //                 pw.Text("${TotalTax==null?0.0.toStringAsFixed(2):
//             //                 TotalTax.toStringAsFixed(2)} : ",style: pw.TextStyle(fontSize: 10,font: ttf),textDirection: pw.TextDirection.rtl),
//             //
//             //
//             //
//             //                 pw.Text("${dataForTicket['salesHeader'][0]["amount"]==null?0.toStringAsFixed(2):
//             //                 dataForTicket['salesHeader'][0]["amount"].toStringAsFixed(2)} : ", style: pw.TextStyle(font: ttf,fontSize: 15,fontWeight: pw.FontWeight.bold),textDirection: pw.TextDirection.rtl),
//             //               ]),
//             //
//             //
//             //
//             //           IsArabic==false? pw.Column(
//             //               crossAxisAlignment:pw.CrossAxisAlignment.end,
//             //               children: [
//             //                 pw.SizedBox(height: 5),
//             //
//             //                 pw.Text("${AmountBeforeTax.toStringAsFixed(2)} ",style: pw.TextStyle(fontSize: 10,font: ttf),textDirection: pw.TextDirection.rtl,),
//             //
//             //                 // pw.Text("${dataForTicket['salesHeader'][0]["taxAmt"]==null?0.toStringAsFixed(2):
//             //                 // dataForTicket['salesHeader'][0]["taxAmt"].toStringAsFixed(2)}",style: pw.TextStyle(fontSize: 15,font: ttf),textDirection: pw.TextDirection.rtl),
//             //                 pw.Text("${TotalTax==null?0.toStringAsFixed(2):
//             //                 TotalTax.toStringAsFixed(2)} ",style: pw.TextStyle(fontSize: 10,font: ttf),textDirection: pw.TextDirection.rtl),
//             //
//             //                 // pw.Text("${dataForTicket['salesHeader'][0]["discountAmt"]==null?0.toStringAsFixed(2):
//             //                 // dataForTicket['salesHeader'][0]["discountAmt"].toStringAsFixed(2)}",style: pw.TextStyle(fontSize: 15,font: ttf),textDirection: pw.TextDirection.rtl),
//             //
//             //                 pw.Text(" ${dataForTicket['salesHeader'][0]["amount"]==null?0.toStringAsFixed(2):
//             //                 dataForTicket['salesHeader'][0]["amount"].toStringAsFixed(2)} ", style: pw.TextStyle(fontSize: 10,fontWeight: pw.FontWeight.bold),textDirection: pw.TextDirection.rtl),
//             //               ]):
//             //
//             //           pw.Column(
//             //               crossAxisAlignment:pw.CrossAxisAlignment.end,
//             //               children: [
//             //                 pw.SizedBox(height: 5),
//             //                 pw.Text("إجمالي الفاتورة مع      ",style: pw.TextStyle(fontSize: 10,font: ttf),  textDirection: pw.TextDirection.rtl,),
//             //                 pw.Text("إجمالي الضرائب      ",style: pw.TextStyle(fontSize: 10,font: ttf) , textDirection: pw.TextDirection.rtl,),
//             //                 pw.Text("اجمالى المبيعات   ", style: pw.TextStyle(fontSize: 15,fontWeight: pw.FontWeight.bold,font: ttf),  textDirection: pw.TextDirection.rtl,)
//             //               ]),
//             //
//             //
//             //         ])
//             //
//             // ),
//
//
//             // pw.SizedBox(
//             //   height: 10,width:ScreenSize+(ScreenSize/8),
//             //   child:pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end,
//             //       children: [
//             //         pw.SizedBox(height:2 ,child: pw.Divider(),width:ScreenSize+(ScreenSize/8))
//             //
//             //       ]),
//             // ),
//
//
//
//
//             pw.SizedBox( height: 2,),
//
//
//             //
//             // pw.Row(
//             //     crossAxisAlignment: pw.CrossAxisAlignment.start,
//             //     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//             //     children:[
//             //       pw.SizedBox(
//             //         height: 2,),
//             //
//             //
//             //       pw.SizedBox(
//             //         width: 20,),
//             //       pw.SizedBox(height: 2),
//             //
//             //
//             //
//             //
//             //     ]),
//
//             pw.SizedBox(height: 2),
//             pw.Center( child:
//             pw.Text(footerCaptions[0]['footerText']+"...",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,font: ttf,fontSize: Pdf_fontSize))
//             ) ,
//
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
//
//
//
//   DynamicDatakey(){
//
//
//     var ss=  Detailspart[0].keys.forEach((key){
//       TableKeys.add(key);
//       return key;
//     });
//
//     print("ssssssssssss");
//     print(TableKeys.remove("Id"));
//
//     TableKeys.insert(0, "No");
//
//     var s= TableKeys.map((headingdata) {
//
//       String jsonTex =headingdata;
//       return jsonTex;
//     });
//
//     print("DynamicDatakey");
//     print(s);
//
//     var  purchasesAsMap=Detailspart as List;
//
//
//     print(purchasesAsMap);
//   }
//
//
//   getItemIndex(dynamic item) {
//     var index = Detailspart.indexOf(item);
//     return index + 1;
//   }
//
//   var TblHeader;
//   TableGenerator() {
//
//     TblHeader=TableKeys;
//
//     print("TblHeader");
//
//
//     List<List<dynamic>> listOfPurchases = List();
//     for (int i = 0; i < Detailspart.length; i++) {
//       listOfPurchases.add(Detailspart[i].values.toList());
//       listOfPurchases[i].removeAt(0);
//       listOfPurchases[i].insert(0, "${i+1}");
//     }
//
//     // print(listOfPurchases);
//     // print("listOfPurchases");
//
//     // print(listOfPurchases.removeWhere((element) => listOfPurchases[0][0]));
//     print(listOfPurchases);
//     return listOfPurchases;
//   }
//
//
//
//
//
//   Pagetype(pgTyp){
//     setState(() {
//       Pg_2_Inch=false;
//       if (IsArabic==true) {
//         pgTyp == "A4" ? PgA4 = true : PgA4 = false;
//         PgA4 == true ?
//         TblHeader = <dynamic>  ['Amount\n المجموع', 'TaxAmt\n مبلغ الضريبة', 'Tax%\n  الضريبة٪','Total\n مجموع', 'Qty\n كمية', 'Price\n  معدل\n','Unit\n وحدة', 'name\tItem\n التفاصيل','No\n عدد']:
//         TblHeader = <dynamic>['Amount المجموع', 'Tax% الضريبة٪', 'Qty كمية', 'Price معدل', 'Item name التفاصيل'];
//         print("PgA4");
//         print(PgA4);
//       }else{
//
//         pgTyp == "A4" ? PgA4 = true : PgA4 = false;
//         PgA4 == true ?
//         TblHeader = <dynamic>['No ',' Item Name', 'Unit ','Rate ', 'Qty ','Total ' 'Tax% ', 'Tax Amt ', 'Amount ']
//             : TblHeader = <dynamic>['Item Name', 'Rate', 'Qty', 'Tax%', 'Amount'];
//         print("PgA4");
//         print(PgA4);
//       }
//     });
//   }
// }
//

