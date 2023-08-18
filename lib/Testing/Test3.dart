// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import '../Local_Db/Local_db_Model/Test_offline_Sales.dart';
import '../models/userdata.dart';
import '../urlEnvironment/urlEnvironment.dart';

class Test3 extends StatefulWidget {
  @override
  _Test3State createState() => _Test3State();
}
 List<Saless> sales = [];
class _Test3State extends State<Test3> {
  var title = "Test";
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
  late String token;

  var arabic1="اختبار";
  var arabic2="اختبار الحروف العربية";

  void initState() {
    setState(() {
      SharedPreferences.getInstance().then((value) {
        pref = value;
        read();
        GetdataPrint(20);
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
  }
var path;
Save() async {


  final Directory? directory = await getExternalStorageDirectory();
  //final output = await getTemporaryDirectory();
  print("directory.path");
  print((directory?.path).toString());
 var targetPath=directory?.path;
 setState(() {
   path="${directory?.path}/exampleNew.pdf";
 });

  final file = File("$targetPath/exampleNew.pdf");
 // await file.writeAsBytes(await pdf.save());
}


  printedpart() async {

    final pdf = await rootBundle.load('document.pdf');
    await Printing.layoutPdf(onLayout: (_) => pdf.buffer.asUint8List());

  }
// var images;
// ToImage() async {
//   await for (var page in Printing.raster(await pdf.save(), pages: [0, 1], dpi: 72)) {
//   final image =await page.toPng(); // ...or page.toPng()
//   print(image);
//   setState(() {
//     images=image;
//   });
//   }
// }
///----------------------------------------------
  @override
  Widget build(BuildContext context) {
    var ScreenSize= MediaQuery.of(context).size.width;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: ElevatedButton(onPressed: (){
           Save();
        }, child: Text("save"),)),
        body:Detailspart==null?Text("u"): PdfPreview(
          allowPrinting: true,
          allowSharing: false,
          canChangePageFormat: false,
          useActions: true,
          build: (format) =>_generatePdf(format, title,ScreenSize),
        ),
bottomNavigationBar:   Container(color: Colors.red,
  child:path==null?Text("s"):
  PDFView(filePath: path,
    autoSpacing: false,
    fitEachPage: false,
    enableSwipe: false,
    swipeHorizontal: false,
    pageFling: false,
  ),
  height: 100,width: 30,
)
    ));
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title,ScreenSize) async {
    final pdf = pw.Document(compress: true);
    final font = await rootBundle.load("assets/arial.ttf");
    final ttf = pw.Font.ttf(font);



    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return  pw.SizedBox(
                width: double.infinity,
                child: pw.FittedBox(
                    child: dataForTicket==null?pw.Text(''):  pw.ListView(
                        children: [

                          pw.Text("title",textAlign: pw.TextAlign.center,textDirection:pw.TextDirection.rtl,
                    style: pw.TextStyle(font:ttf )),

                          pw.Text("shopName", textAlign: pw.TextAlign.center,textDirection:pw.TextDirection.rtl,
                          style: pw.TextStyle(font:ttf )),

                          pw.Text(
                              "BranchName",textAlign: pw.TextAlign.center,textDirection:pw.TextDirection.rtl,
                             style: pw.TextStyle(font:ttf )
                          ),
                          pw.Text(
                              arabic2,textAlign: pw.TextAlign.center,textDirection:pw.TextDirection.rtl,
                           style: pw.TextStyle(font:ttf)
                          ),
                          pw.Text(
                              arabic2,textAlign: pw.TextAlign.center,textDirection:pw.TextDirection.rtl,
                              style: pw.TextStyle(font:ttf )
                          ),
                          pw.SizedBox(
                            height: 10,),

                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              mainAxisAlignment:pw.MainAxisAlignment.start,
                              children: [

                                pw.Text('  Token No   : '+dataForTicket['salesHeader'][0]["partyName"]
                                    .toString(),
                                    textAlign: pw.TextAlign.left,textDirection:pw.TextDirection.rtl,
                                    style: pw.TextStyle(font:ttf )),


                                pw.Text('  Order No    : ' +
                                    dataForTicket['salesHeader'][0]["partyName"],textDirection:pw.TextDirection.rtl,
                                    style: pw.TextStyle(font:ttf )),

                                pw.Text('  Date       : ' +
                                    dataForTicket['salesHeader'][0]["partyName"],textDirection:pw.TextDirection.rtl,
                                    style: pw.TextStyle(font:ttf )),

                                //Text('Print Date : ' + systemdate.toString());
                                pw.Text('  Print Date : ' +
                                    dataForTicket['salesHeader'][0]["partyName"],textDirection:pw.TextDirection.rtl,
                                    style: pw.TextStyle(font:ttf )),

                                pw.Text('  Delivery   : ' +
                                    dataForTicket['salesHeader'][0]["partyName"],textDirection:pw.TextDirection.rtl,
                                    style: pw.TextStyle(font:ttf )),

                                pw.SizedBox(
                                  height: 5,),


                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(left: 10,right: 10),
                                  child:pw.Table.fromTextArray(
                                    border: pw.TableBorder(top: pw.BorderSide(color:PdfColors.black),bottom:pw.BorderSide(color:PdfColors.black),  ),
                                    cellAlignment: pw.Alignment.bottomRight,
                                      cellAlignments: {0: pw.Alignment.centerLeft},
                                      cellStyle:pw.TextStyle(font:ttf,) ,
                                      headerStyle:pw.TextStyle(font:ttf,),
                                      headerDecoration: pw.BoxDecoration(border:pw.Border(bottom: pw.BorderSide(color: PdfColors.black))),
                                      headers: <dynamic>['Name', 'Rate' ,'Qty','Tax', 'Amount'],
                                      data:test()
                                  )
                                ),


                                pw.Container(
                                    //color: PdfColors.blue,
                                   width: 300,
                                  height: 25,
                                  child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                                    children: [
                                      pw.Text(""),

                                      pw.Text("Total : ${dataForTicket['salesHeader'][0]["amount"].toStringAsFixed(2)}",style: pw.TextStyle(fontSize: 20)),
                                    ]))

                                // pw.SizedBox(
                                //   width: 300,
                                //   child: pw.Divider(color: PdfColors.black, thickness: 1.5),
                                // ),
                              ]),

                          pw.SizedBox(
                            height: 10,),

                          pw.BarcodeWidget(
                              data: "1",
                              barcode: pw.Barcode.qrCode(),
                              width: 100,
                              height: 50
                          ),

                          pw.SizedBox(height: 10),
                          pw.BarcodeWidget(
                              data: "1",
                              barcode: pw.Barcode.code39(),
                              width: 100,
                              height: 50
                          ),


                        ],
                      ),
                    ),
                  );



        },
      ),
    );

    return pdf.save();
  }



  test (){
    var purchasesAsMap = <Map<String, String>>[
      for(int i = 0; i < Detailspart.length; i++)
        {
          "s": "${Detailspart[i]['itmName']}",
          "ss": "${Detailspart[i]['rate']}",
          "ssshhs": "${Detailspart[i]['qty']}",
          "sss": "${Detailspart[i]['taxPercentage']}",
          "ssss": "${Detailspart[i]['amountIncludingTax']}",
        },
    ];

    List<List<String>> listOfPurchases=[];
    for(int i=0;i<purchasesAsMap.length;i++)
    {
      listOfPurchases.add(purchasesAsMap[i].values.toList());
    }
return listOfPurchases;
  }






var phNum="";

  Future<Uint8List> HtmlPrint(PdfPageFormat format, String title) async {
  await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async =>
      await Printing.convertHtml(
        format: format,
       // html: '<html><body><p>Hello!</p></body></html>',
        html:await GetHtmlContent()
    ));
  return Uint8List(0); // Placeholder empty byte list
}



  var dataForTicket;
  var Detailspart;
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
      // print("sales for print");
      print(dataForTicket.toString());
      Detailspart =dataForTicket['salesDetails'];
      List<dynamic> t = Detailspart;
      List<Saless> p = t.map((t) => Saless.fromJson(t))
          .toList();

      //print(p);
      sales = p;

      Timer(Duration(milliseconds: 1), () async{
setState(() {

});
      });

    } catch (e) {
      print('error on databinding $e');
    }
  }

  var htmlContent =null;



  GetHtmlContent(){
    var phNum=dataForTicket['salesHeader'][0]['phone']??"";
    // int LoopI=0;
    var DetlPrt=dataForTicket['salesDetails'];
    print(DetlPrt[1]);

    return htmlContent="""

<!DOCTYPE html>
<html>
<head>
  <style>
  table, th, td {
    border: 1px solid white;
    border-collapse: collapse;
  }
  th, td, p {
    padding: 5px;
    text-align: left;
  }
  </style>
</head>
  <body>
  <div style=" width: 250px;">
  <div style="text-align:center;">

    <!---- <img [src]="html_print.Company_Logo" style="  margin: auto; width: 80%;" > <br>--->

    <span *ngIf="html_print.Company_Name"
      style=" font-size: 13px;font-family: 'Calibri'; font-weight: bold; text-transform: uppercase;letter-spacing: 1px;">
      $branchName</span> <br>

    <!---- <span *ngIf="html_print.Company_Addr1"
       style=" font-size: 12px;font-family: 'Calibri';">${dataForTicket['salesHeader'][0]['address1']}</span><br>
     <span *ngIf="html_print.Company_Addr2"
       style=" font-size: 12px;font-family: 'Calibri';">${dataForTicket['salesHeader'][0]['address2']}</span><br>
     <span *ngIf="html_print.Company_Addr3"
       style=" font-size: 12px;font-family: 'Calibri';">${dataForTicket['salesHeader'][0]['amount']}</span><br>
     <span *ngIf="html_print.Company_Mobile" style=" font-size: 12px;font-family: 'Calibri';">Mobile:
       ${dataForTicket['salesHeader'][0]['amount']}</span><br>
     <span *ngIf="html_print.Company_GST" style=" font-size: 12px;font-family: 'Calibri';">GST:
       ${dataForTicket['salesHeader'][0]['amount']}</span><br>
----->


    <h4 style="margin: 0; text-decoration: underline;">TAX INVOICE</h4>

  </div>

  <div>
    <div style="display: flex;justify-content: space-between;height: fit-content;">
      <p *ngIf="html_print.Invoice_no" style="font-size: 13px;font-family: 'Calibri';font-weight: bold;">Inv No:
        ${dataForTicket['salesHeader'][0]['voucherNo']} </p>
 <p style="font-size: 11px;font-family: 'Calibri';font-weight:bold;">
 Date: ${dataForTicket['salesHeader'][0]['voucherDate']}</p>
    </div>


<div>
    <div style="display: flex;justify-content: space-between;height: fit-content;">
      <p *ngIf="html_print.Invoice_no" style="font-size: 13px;font-family: 'Calibri';">Cust   :
        ${dataForTicket['salesHeader'][0]['partyName']} </p>
 <p style="font-size: 11px;font-family: 'Calibri';font-weight:bold;">
 Ph:$phNum</p>
    </div>


 <p *ngIf="html_print.GstNo" style="margin: 0; font-size: 11px;font-family: 'Calibri';">Emp  :
 ${dataForTicket['salesHeader'][0]['emEmployeeName']??"--"}
 
    </p> <p *ngIf="html_print.GstNo" style="margin: 0; font-size: 11px;font-family: 'Calibri';">User :
 $userName
    </p>





    <p *ngIf="html_print.GstNo" style="margin: 0; font-size: 11px;font-family: 'Calibri';">GST:${dataForTicket['salesHeader'][0]['gstNo']??"--"}
    </p>

    <!-- <p style="margin: 1;">----------------------------</p> -->
    <hr>
    <table style=" border-collapse: collapse;">
      <tbody>
        <tr>
          <td style=" border-bottom: 1px solid black;font-size: 11px; font-family: 'Calibri';  font-weight: bold;">
            Item</td>
          <td
            style=" width: 15%; border-bottom: 1px solid black; text-align: right;font-size: 11px; font-family: 'Calibri';  font-weight: bold;">
            Rate</td>
          <td
            style=" width: 9%; border-bottom: 1px solid black;text-align: right;font-size: 11px; font-family: 'Calibri';  font-weight: bold; ">
            Qty</td>
          <td
            style=" width: 15%; border-bottom: 1px solid black;font-size: 11px; font-family: 'Calibri';  font-weight: bold;">
            Tax%</td>
          <td
            style=" width: 15%; border-bottom: 1px solid black;text-align: right;font-size: 11px; font-family: 'Calibri';  font-weight: bold;">
            Amount</td>   
  </tr>



 
<script language="javascript" type="text/javascript">
  var Loop=0;

for (var a=0; a <3 ; a++) {
document.write("<tr>");



document.write("<td>"+(a)+"</td>");

Loop++;

document.write("</tr>");
}

  


</script>



      







      </tbody>

    </table>
    <!-- <p style="margin: 1px;">----------------------------------------------</p> -->
<hr>

    <table>
      <tbody>
      
        <tr *ngIf="html_print.ttl_Discount!=0">
          <td></td>
          <td style="width: 40%;text-align: right;font-size: 11px; font-family: 'Calibri';  ">Discount</td>
          <td style="width: 3%;text-align: right;">:</td>
          <td style="width: 20%;text-align: right;font-size: 11px; font-family: 'Calibri'; ">
            ${dataForTicket['salesHeader'][0]['discountAmt']??"0.00"}</td>
        </tr>

        <tr *ngIf="html_print.ttl_CGST!=0">
          <td></td>
          <td style="width: 40%;text-align: right;font-size: 11px; font-family: 'Calibri';  ">CGST(Incl)</td>
          <td style="width: 3%;text-align: right;">:</td>
          <td style="width: 20%;text-align: right;font-size: 11px; font-family: 'Calibri'; ">
          ${dataForTicket['salesDetails'][0]['cgstAmount']??"0.00"}</td>
        </tr>

        <tr *ngIf="html_print.ttl_SGST!=0">
          <td></td>
          <td style="width: 40%;text-align: right;font-size: 11px; font-family: 'Calibri';  ">SGST(Incl)</td>
          <td style="width: 3%;text-align: right;">:</td>
          <td style="width: 20%;text-align: right;font-size: 11px; font-family: 'Calibri'; ">
          ${dataForTicket['salesDetails'][0]['sgstAmount']??"0.00"}</td>
        </tr>

         <!-- <tr *ngIf="html_print.ttl_Other_Amt!=0">
          <td></td>
          <td style="width: 30%;text-align: right;font-size: 11px; font-family: 'Calibri';  ">Other Amount
          </td>
          <td style="width: 3%;text-align: right;">:</td>
          <td style="width: 20%;text-align: right;font-size: 11px; font-family: 'Calibri'; ">
            {{html_print.ttl_Other_Amt| number : '1.2-2'}}</td>
        </tr>

         <tr *ngIf="html_print.ttl_Adj!=0">
          <td></td>
          <td style="width: 40%;text-align: right;font-size: 11px; font-family: 'Calibri';  ">Adjust</td>
          <td style="width: 3%;text-align: right;">:</td>
          <td style="width: 20%;text-align: right;font-size: 11px; font-family: 'Calibri'; "></td>
        </tr>-->
        
      </tbody>
    </table>



    <!-- <p style="margin: 1px;">----------------------------------------------</p> -->
<hr>
  <!--   <span *ngIf="html_print.you_Saved>0 && GTS_service.mrp_Required"
      style="font-size: 14px;font-family: 'Calibri';font-weight: bold;">
      You Saved Rs. {{html_print.you_Saved| number : '1.2-2'}} </span>-->

    <table>

      <tr>
        <td></td>
        <th style="width: 40%;text-transform: uppercase; text-align: right;font-size: 22px; font-family: 'Calibri'; ">
          NET </th>
        <td style="width: 3%;text-align: right;">:</td>
        <td style="width: 45%;text-align: right;font-size: 22px; font-family: 'Calibri';font-weight: bold;">
           ${dataForTicket['salesHeader'][0]['amount']}</td>
      </tr>
    </table>

   <!--  <small> {{html_print.net_Total_In_Words}}</small>
    <p style="margin: 1px;">---------------------------------------------</p> -->
    <hr>
    <!-- <p style="margin: 1px;">---------------------------------------------</p> -->
  
            <!------------------- BARCODEEEE -------------->
            <div style="text-align: center;" *ngIf="html_print.PrintQrinSales">
              <ngx-barcode [bc-value]="html_print.Invoice_no" [bc-display-value]="true" [bc-width]="width"
                  [bc-height]="height" [bc-font-size]="fontSize"></ngx-barcode>
  
          </div>
          <!------------------- BARCODEEEE -------------->
  
          <!------------------- QR code -------------->
          <div style="text-align: center;" *ngIf="html_print.PrintQrinSales">
              <!-- {{html_print.QRcode}} -->
              <qrcode [qrdata]=html_print.QRcode [width]="80" [allowEmptyString]="true" [errorCorrectionLevel]="'M'" [elementType]="'svg'">
              </qrcode>
          </div>
          <!------------------- QR code -------------->


    <div style="border-bottom: 0.2px solid white;"></div>

   
  <!----   <div *ngFor="let FTR of html_print.bill_footer" style="font-size: 12px; font-family: 'Times New Roman'; ">
      <div [ngStyle]="FTR.footerCaptionBold?{'font-weight': 'bold'} : {'font-weight': 300}">{{FTR.footerCaption}}</div>
      <br>
      <div [ngStyle]="FTR.footerTextBold?{'font-weight': 'bold'} : {'font-weight': 300}">{{FTR.footerText}}</div>

    </div>--->

  </div>
</div>
  </body>
</html>
""";}
}



