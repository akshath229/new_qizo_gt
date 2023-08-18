import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:flutter/services.dart';

class Pdf_Two_Inch{


  Future<Uint8List> generatePdf(
       PdfPageFormat format,
      ScreenSize,
      BuildContext context,
      bool IsArabic,
      var dataForTicket ,
      var Companydata,
      var branchName,
      var id,
      var footerCaptions,
      var Detailspart) async {
    final pdf = pw.Document(compress: true);
    final font = await rootBundle.load("assets/arial.ttf");
    final ttf = pw.Font.ttf(font);

    // var Total;
    // var Vat;
    // var Discount;
    // var Net_Amount;
    //
    // if(IsArabic==true){
    //   Total="Total";
    //   Vat="Vat";
    //   Discount="Discount";
    //   Net_Amount="Net Amount";
    // }else{
    //
    //   Total="مجموع";
    //   Vat="ضريبة";
    //   Discount="خصم";
    //   Net_Amount="كمية الشبكة";
    // }


    pdf.addPage(
      pw.Page(
        pageFormat:PdfPageFormat.roll57,
        build: (context) {
          return pw.SizedBox(
            width: double.infinity,
            child: pw.FittedBox(
              child: dataForTicket == null ? pw.Text('') : pw.ListView(
                children: [


                  pw.Text(Companydata['companyProfileName'], textAlign: pw.TextAlign.center,
                      textDirection: pw.TextDirection.rtl,
                      style: pw.TextStyle(
                          font: ttf,
                          fontWeight: pw.FontWeight.bold
                      )),

                  pw.Text(Companydata['companyProfileNameLatin'], textAlign: pw.TextAlign.center,
                      textDirection: pw.TextDirection.rtl,
                      style: pw.TextStyle(
                          font: ttf,
                          fontWeight: pw.FontWeight.bold
                      )),

                  pw.Text(Companydata['companyProfileAddress1'], textAlign: pw.TextAlign.center,
                      textDirection: pw.TextDirection.rtl,
                      style: pw.TextStyle(
                          font: ttf)),

                  pw.Text(Companydata['companyProfileAddress2'], textAlign: pw.TextAlign.center,
                      textDirection: pw.TextDirection.rtl,
                      style: pw.TextStyle(
                          font: ttf)),


                  pw.Text(Companydata['companyProfileEmail'], textAlign: pw.TextAlign.center,
                      textDirection: pw.TextDirection.rtl,
                      style: pw.TextStyle(
                          font: ttf
                      )),

                  pw.SizedBox(height: 5),

                  // pw.Text(
                  //     'Order Slip', textAlign: pw.TextAlign.center,
                  //     textDirection: pw.TextDirection.rtl,
                  //     style: pw.TextStyle(font: ttf),
                  //
                  // ),
                  pw.SizedBox(
                    height: 10,),

                  pw.Column(
                      crossAxisAlignment:IsArabic==true ?pw.CrossAxisAlignment.end:pw.CrossAxisAlignment.start,
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        ///-----------
                        IsArabic==true?  pw.Text("رقم رمزي    ${dataForTicket['salesHeader'][0]["voucherNo"].toString()}  :      ",
                            textDirection: pw.TextDirection.rtl,
                            style: pw.TextStyle(font: ttf)):


                        pw.Text('  Token No   : ' +dataForTicket['salesHeader'][0]["voucherNo"].toString(),
                            style: pw.TextStyle(font: ttf)),



                        ///-----------
                        IsArabic==true? pw.Text("رقم الأمر${(dataForTicket['salesHeader'][0]["orderNo"].toString())=="null"?"         - "
                            :"           "+ dataForTicket['salesHeader'][0]["orderNo"].toString()} :       ",
                            textDirection: pw.TextDirection.rtl,
                            style: pw.TextStyle(font: ttf)):

                        pw.Text(dataForTicket['salesHeader'][0]["orderNo"]==null?
                        "  Order No    : -":
                        '  Order No    : ' +
                            dataForTicket['salesHeader'][0]["orderNo"].toString()),


                        ///-----------
                        IsArabic==true? pw.Text("تاريخ${(dataForTicket['salesHeader'][0]["voucherDate"].toString())=="null"?"       - "
                            :"                 "+ dataForTicket['salesHeader'][0]["voucherDate"].toString()} :            ",
                            textDirection: pw.TextDirection.rtl,
                            style: pw.TextStyle(font: ttf)):

                        pw.Text(dataForTicket['salesHeader'][0]["voucherDate"]==null?
                        "  Date           : -":
                        '  Date           : ' + dataForTicket['salesHeader'][0]["voucherDate"].toString()),





                        ///-----------
                        IsArabic==true? pw.Text("تاريخ الطباعة ${(dataForTicket['salesHeader'][0]["voucherDate"].toString())=="null"?"       - "
                            :"                 "+ dataForTicket['salesHeader'][0]["voucherDate"].toString()} :  ",
                            textDirection: pw.TextDirection.rtl,
                            style: pw.TextStyle(font: ttf)):

                        pw.Text(dataForTicket['salesHeader'][0]["voucherDate"]==null?
                        "  Print Date   : -":
                        '  Print Date   : ' + dataForTicket['salesHeader'][0]["voucherDate"].toString()),
                        ///-----------
                        IsArabic==true?pw.Text('توصيل   ${dataForTicket['salesHeader'][0]["partyName"]} :          ',
                            textDirection: pw.TextDirection.rtl,
                            style: pw.TextStyle(font: ttf)):
                        pw.Text('  Delivery     : ' +
                            dataForTicket['salesHeader'][0]["partyName"],
                            style: pw.TextStyle(font: ttf)),

                        pw.SizedBox(
                          height: 5,),


                        pw.Padding(
                            padding: const pw.EdgeInsets.only(
                                left: 10, right: 10),
                            child:pw.Directionality(
                                textDirection:IsArabic==true? pw.TextDirection.rtl: pw.TextDirection.ltr,
                                child:
                                pw.Table.fromTextArray(
                                    border: pw.TableBorder(top: pw.BorderSide(
                                        color: PdfColors.black),
                                      bottom: pw.BorderSide(
                                          color: PdfColors.black),),
                                    cellAlignment: pw.Alignment.topRight,
                                    cellAlignments:IsArabic==true? {0: pw.Alignment.topRight}: {0: pw.Alignment.topLeft},
                                    columnWidths: {0: pw.FixedColumnWidth(150)},
                                    cellStyle: pw.TextStyle(font: ttf,),
                                    headerStyle: pw.TextStyle(font: ttf,),
                                    headerDecoration: pw.BoxDecoration(border: pw
                                        .Border(bottom: pw.BorderSide(
                                        color: PdfColors.black))),
                                    headers:TblHeader(IsArabic),
                                    data: TableGenerator(IsArabic,Detailspart)
                                )
                            )

                        ),

                      ]),



                  pw.SizedBox( height: 10,),

                  pw.Container(width: ScreenSize/1.4,
                      child:
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [

                            IsArabic==false?pw.Column(
                                children: [
                                  pw.Text("Total           : ",style: pw.TextStyle(fontSize: 15,font: ttf),  textDirection: pw.TextDirection.rtl,),
                                  pw.Text("Vat              : ",style: pw.TextStyle(fontSize: 15,font: ttf) , textDirection: pw.TextDirection.rtl,),
                                  pw.Text("Discount     : ",style: pw.TextStyle(fontSize: 15,font: ttf),  textDirection: pw.TextDirection.rtl,),
                                  pw.Text("Net Amt : ", style: pw.TextStyle(fontSize: 20,fontWeight: pw.FontWeight.bold,font: ttf),  textDirection: pw.TextDirection.rtl,)
                                ]):

                            pw.Column(
                                crossAxisAlignment:pw.CrossAxisAlignment.end,
                                children: [
                                  pw.Text("${dataForTicket['salesHeader'][0]["amount"]==null?0.toStringAsFixed(2):
                                  dataForTicket['salesHeader'][0]["amount"].toStringAsFixed(2)} : ",style: pw.TextStyle(fontSize: 15,font: ttf),textDirection: pw.TextDirection.rtl,),

                                  pw.Text("${dataForTicket['salesHeader'][0]["taxAmt"]==null?0.toStringAsFixed(2):
                                  dataForTicket['salesHeader'][0]["taxAmt"].toStringAsFixed(2)} : ",style: pw.TextStyle(fontSize: 15,font: ttf),textDirection: pw.TextDirection.rtl),

                                  pw.Text("${dataForTicket['salesHeader'][0]["discountAmt"]==null?0.toStringAsFixed(2):
                                  dataForTicket['salesHeader'][0]["discountAmt"].toStringAsFixed(2)} : ",style: pw.TextStyle(fontSize: 15,font: ttf),textDirection: pw.TextDirection.rtl),

                                  pw.Text("${dataForTicket['salesHeader'][0]["amount"]==null?0.toStringAsFixed(2):
                                  dataForTicket['salesHeader'][0]["amount"].toStringAsFixed(2)} : ", style: pw.TextStyle(font: ttf,fontSize: 20,fontWeight: pw.FontWeight.bold),textDirection: pw.TextDirection.rtl),
                                ]),



                            IsArabic==false? pw.Column(
                                crossAxisAlignment:pw.CrossAxisAlignment.end,
                                children: [
                                  pw.Text("${dataForTicket['salesHeader'][0]["amount"]==null?0.toStringAsFixed(2):
                                  dataForTicket['salesHeader'][0]["amount"].toStringAsFixed(2)}",style: pw.TextStyle(fontSize: 15,font: ttf),textDirection: pw.TextDirection.rtl,),

                                  pw.Text("${dataForTicket['salesHeader'][0]["taxAmt"]==null?0.toStringAsFixed(2):
                                  dataForTicket['salesHeader'][0]["taxAmt"].toStringAsFixed(2)}",style: pw.TextStyle(fontSize: 15,font: ttf),textDirection: pw.TextDirection.rtl),

                                  pw.Text("${dataForTicket['salesHeader'][0]["discountAmt"]==null?0.toStringAsFixed(2):
                                  dataForTicket['salesHeader'][0]["discountAmt"].toStringAsFixed(2)}",style: pw.TextStyle(fontSize: 15,font: ttf),textDirection: pw.TextDirection.rtl),

                                  pw.Text("${dataForTicket['salesHeader'][0]["amount"]==null?0.toStringAsFixed(2):
                                  dataForTicket['salesHeader'][0]["amount"].toStringAsFixed(2)}", style: pw.TextStyle(font: ttf,fontSize: 20,fontWeight: pw.FontWeight.bold),textDirection: pw.TextDirection.rtl),
                                ]):

                            pw.Column(
                                crossAxisAlignment:pw.CrossAxisAlignment.end,
                                children: [
                                  pw.Text("مجموع      ",style: pw.TextStyle(fontSize: 15,font: ttf),  textDirection: pw.TextDirection.rtl,),
                                  pw.Text("ضريبة      ",style: pw.TextStyle(fontSize: 15,font: ttf) , textDirection: pw.TextDirection.rtl,),
                                  pw.Text("خصم      ",style: pw.TextStyle(fontSize: 15,font: ttf),  textDirection: pw.TextDirection.rtl,),
                                  pw.Text("كمية الشبكة   ", style: pw.TextStyle(fontSize: 20,fontWeight: pw.FontWeight.bold,font: ttf),  textDirection: pw.TextDirection.rtl,)
                                ]),


                          ])

                  ),


                 //pw.SizedBox(child: pw.Divider()),
                  pw.SizedBox( height: 10,),




                  pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children:[
                        pw.SizedBox(
                          height: 10,),

                        pw.BarcodeWidget(
                            data: id.toString(),
                            barcode: pw.Barcode.qrCode(),
                            width: 100,
                            height: 50
                        ),

                        pw.SizedBox(
                          width: 20,),
                        pw.SizedBox(height: 10),
                        pw.BarcodeWidget(
                            data: id.toString(),
                            barcode: pw.Barcode.code39(),
                            width: 100,
                            height: 50
                        ),

                      ]),

                  pw.SizedBox(height: 10),
                  pw.Text(footerCaptions[0]['footerText']+"...",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,font: ttf))

                ],
              ),
            ),
          );
        },
      ),
    );

    return pdf.save();
  }




  TableGenerator(arabic,Detailspart,) {
    var purchasesAsMap;
      purchasesAsMap = <Map<String, String>>[
        for(int i = 0; i < Detailspart.length; i++)
          {
            "s": "${Detailspart[i]['itmName']}",
            "ss": "${Detailspart[i]['rate'].toStringAsFixed(2)}",
            "ssshhs": "${Detailspart[i]['qty']}",
           // "sss": "${Detailspart[i]['taxPercentage']}",
            "ssss": "${Detailspart[i]['amountIncludingTax'].toStringAsFixed(2)}",
          },
      ];


    List<List<String>> listOfPurchases = [];
    for (int i = 0; i < purchasesAsMap.length; i++) {
      listOfPurchases.add(purchasesAsMap[i].values.toList());
    }
    return listOfPurchases;
  }






  TblHeader(arabic) {
    if(arabic==true){
     var TblHeader = <dynamic>['اسم', 'معدل', 'الكمية', 'مقدار'];
      return TblHeader;
    }
    else{
      var TblHeader = <dynamic>['Name', 'Rate', 'Qty', 'Total',];
      return TblHeader;
    }

  }






}