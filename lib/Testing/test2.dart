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

import '../GT_Masters/Printing/PDF_2Inch_Print.dart';
import '../appbarWidget.dart';
import '../models/userdata.dart';
import '../urlEnvironment/urlEnvironment.dart';

class Test2 extends StatefulWidget {
  var Parm_Id;
  Test2({this.Parm_Id});

  @override
  Test2State createState() => Test2State();
}

class Test2State extends State<Test2> {

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
  var DateTimeFormat = new DateFormat('dd-MM-yyyy hh a');
  String Datetime_Now = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());
  var Detailspart;
  var dataForTicket;
  var footerCaptions;
  var  Companydata;
  bool IsArabic=false;
  bool PgA4=false;
  bool Pg_2_Inch=false;
  String IsArabicChkBoxText="Arabic";
  void initState() {
    setState(() {
      SharedPreferences.getInstance().then((value) {
        pref = value;
        read();
        GetdataPrint(widget.Parm_Id);
        footerdata();
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

     var ParseDate=dataForTicket['salesHeader'][0]["voucherDate"]??"2022-01-10T00:00:00";
      DateTime tempDate = new DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(ParseDate);
      print(dataForTicket['salesHeader'][0]["voucherDate"]);
       VchDate=DateTimeFormat.format(tempDate);
      print(VchDate.toString());



      Detailspart = dataForTicket['salesDetails'];
      String  Pattern=Detailspart[0]['itmName'];
      if (Pattern.contains(RegExp(r'[a-zA-Z]'))) {
        IsArabic=false;
      }else{
        print("Nope, Other characters detected");
        IsArabic=true;
      }
      setState(() {

      });
    } catch (e) {
      print('error on databinding $e');
    }
  }

  String dropdownValue = '3 Inch';

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
          PdfPreview(

            allowPrinting: true,
            allowSharing: false,
            canChangePageFormat: false,
            useActions: true,
            build: (format) =>Pg_2_Inch==true? Pdf_2.generatePdf(format, ScreenSize, context, IsArabic, dataForTicket, Companydata, branchName, widget.Parm_Id, footerCaptions, Detailspart):
            _generatePdf(format, ScreenSize,context),
          ),


          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20,left: 10,right: 20),
                child: Container(height: 30,
                  child:  DropdownButton(
                    underline:Container(color: Colors.transparent),
                    icon:Center(child: Text("Paper : $dropdownValue  ▼",style: TextStyle(color: Colors.white),)),

                    items:[
                      DropdownMenuItem<String>(
                        value: "A4",
                        child: Text(
                          "A4",
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: "3 Inch",
                        child: Text(
                          "3 Inch",
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: "2 Inch",
                        child: Text(
                          "2 Inch",
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
              ),


              InkWell(
                onTap: (){
                  setState(() {
                    IsArabic = !IsArabic;
                    IsArabic==false?IsArabicChkBoxText="Arabic":IsArabicChkBoxText="English";
                    TableGenerator();
                  });
                },

                  child: Container(height: 30,width: 100,
                      child: Align(alignment: Alignment.bottomLeft,
                          child: Text(IsArabicChkBoxText,style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                               fontSize: 20),)))),


            ],
          ),

        ),);
  }




  Future<Uint8List> _generatePdf(PdfPageFormat format,
      ScreenSize,BuildContext context) async {
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
        pageFormat:PgA4==true? PdfPageFormat.a4:PdfPageFormat.roll80,
        build: (context) {
          return pw.SizedBox(
            width: double.infinity,
            child: pw.FittedBox(
              child: dataForTicket == null ? pw.Text('') : pw.ListView(
                children: [


                  pw.Text(branchName, textAlign: pw.TextAlign.center,
                      textDirection: pw.TextDirection.rtl,
                      style: pw.TextStyle(
                        // font: ttf
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




pw.Container(
  //color: PdfColors.black,
  width:PgA4==true? ScreenSize/1.07:ScreenSize/1.5,
child:            pw.Column(
    crossAxisAlignment:IsArabic==true ?pw.CrossAxisAlignment.end:pw.CrossAxisAlignment.start,
    mainAxisAlignment: pw.MainAxisAlignment.start,
    children: [
      ///-----------
      IsArabic==true?  pw.Text("رقم رمزي    ${dataForTicket['salesHeader'][0]["voucherNo"].toString()}  :      ",
          textDirection: pw.TextDirection.rtl,
          style: pw.TextStyle(font: ttf)):


      pw.Text('  Invoice No   : ' +dataForTicket['salesHeader'][0]["voucherNo"].toString(),
          // textAlign: pw.TextAlign.left,
          // textDirection: pw.TextDirection.rtl,
          style: pw.TextStyle(font: ttf)),



      ///-----------
      IsArabic==true? pw.Text("رقم الأمر${(dataForTicket['salesHeader'][0]["orderNo"].toString())=="null"?"         - "
          :"           "+ dataForTicket['salesHeader'][0]["orderNo"].toString()} :       ",
          textDirection: pw.TextDirection.rtl,
          style: pw.TextStyle(font: ttf)):

      pw.Text(dataForTicket['salesHeader'][0]["orderNo"]==null?
      "  Order No     : -":
      '  Order No     : ' +
          dataForTicket['salesHeader'][0]["orderNo"].toString()),


      ///-----------
      IsArabic==true? pw.Text("تاريخ${(VchDate.toString())=="null"?"       - "
          :"                 "+ VchDate.toString()} :            ",
          textDirection: pw.TextDirection.rtl,
          style: pw.TextStyle(font: ttf)):

      pw.Text(VchDate==null?
      "  Inv.Date      : -":
      '  Inv.Date      : ' + VchDate.toString()),





      ///-----------
      IsArabic==true? pw.Text("تاريخ الطباعة ${(VchDate.toString())=="null"?"       - "
          :"                 "+ VchDate.toString()} :  ",
          textDirection: pw.TextDirection.rtl,
          style: pw.TextStyle(font: ttf)):

      pw.Text(VchDate==null?
      "  Print Date    : -":
      '  Print Date    : ' + VchDate.toString()),






      ///-----------
      IsArabic==true?pw.Text('توصيل   ${dataForTicket['salesHeader'][0]["partyName"]} :          ',
          textDirection: pw.TextDirection.rtl,
          style: pw.TextStyle(font: ttf)):
      pw.Text('  Delivery       : ' +
          dataForTicket['salesHeader'][0]["partyName"],
          style: pw.TextStyle(font: ttf)),

    ]),



),




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
                                    columnWidths:IsArabic==true?{5: pw.FixedColumnWidth(150)}:{0: pw.FixedColumnWidth(150)},
                                    cellStyle: pw.TextStyle(font: ttf,),
                                    headerStyle: pw.TextStyle(font: ttf),
                                    headerAlignment:pw.Alignment.topRight,
                                    headerDecoration: pw.BoxDecoration(border: pw
                                        .Border(bottom: pw.BorderSide(
                                        color: PdfColors.black))),
                                    headers:TblHeader,
                                    data: TableGenerator()
                                )
                            )

                        ),





                  pw.SizedBox( height: 10,),

                  pw.Container(width:PgA4==true? ScreenSize/1.07:ScreenSize/1.5,
                      //color:  PdfColors.red,
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


                  pw.SizedBox(child: pw.Divider()  ,height: 10,width:PgA4==true?ScreenSize-35:ScreenSize-90),
                  pw.SizedBox( height: 10,),




                  pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children:[
                        pw.SizedBox(
                          height: 10,),

                        pw.BarcodeWidget(
                            data: widget.Parm_Id.toString(),
                            barcode: pw.Barcode.qrCode(),
                            width: 100,
                            height: 50
                        ),

                        pw.SizedBox(
                          width: 20,),
                        pw.SizedBox(height: 10),
                        pw.BarcodeWidget(
                            data: widget.Parm_Id.toString(),
                            barcode: pw.Barcode.code39(),
                            width: 100,
                            height: 50
                        ),

                      ]),

                  pw.SizedBox(height: 10),
                  pw.Text(footerCaptions[2]['footerText']+"...",style: pw.TextStyle(fontWeight: pw.FontWeight.bold))

                ],
              ),
            ),
          );
        },
      ),
    );

    return pdf.save();
  }


  var TblHeader;
  TableGenerator() {
    if(IsArabic==true){
       PgA4==true?TblHeader= ['مقدار', 'مبلغ الضريبة', 'ضريبة', 'كمية', 'معدل', 'اسم']:
       TblHeader= ['مقدار', 'ضريبة', 'كمية', 'معدل', 'اسم'];
    }
    else{
      PgA4==true? TblHeader = <dynamic>['Name', 'Rate', 'Qty', 'Tax', 'Tax Amt', 'Amount']
          : TblHeader = <dynamic>['Name', 'Rate', 'Qty', 'Tax', 'Amount'];

    }




    var purchasesAsMap;
    if(IsArabic==true){

      if(PgA4==true) {

        purchasesAsMap = <Map<String, String>>[
          for(int i = 0; i < Detailspart.length; i++)
            {

              "ssss": "${Detailspart[i]['amountIncludingTax'].toStringAsFixed(2)}",
              "sssf": "${Detailspart[i]['taxAmount'].toStringAsFixed(2)}",
              "sss": "${Detailspart[i]['taxPercentage']}",
              "ssshhs": "${Detailspart[i]['qty']}",
              "ss": "${Detailspart[i]['rate'].toStringAsFixed(2)}",
              "s": "  ${Detailspart[i]['itmName']??""} ${Detailspart[i]['itmArabicName']??""}",


            },
        ];
      }  else{
        purchasesAsMap = <Map<String, String>>[
          for(int i = 0; i < Detailspart.length; i++)
            {
              "ssss": "${Detailspart[i]['amountIncludingTax'].toStringAsFixed(2)}",
              "sss": "${Detailspart[i]['taxPercentage']}",
              "ssshhs": "${Detailspart[i]['qty']}",
              "ss": "${Detailspart[i]['rate'].toStringAsFixed(2)}",
              "s": "${Detailspart[i]['itmName']}",
            },
        ];
      }



    }else{

      if(PgA4==true) {
        purchasesAsMap = <Map<String, String>>[
          for(int i = 0; i < Detailspart.length; i++)
            {
              "s": "${Detailspart[i]['itmName']}",
              "ss": "${Detailspart[i]['rate'].toStringAsFixed(2)}",
              "ssshhs": "${Detailspart[i]['qty']}",
              "sss": "${Detailspart[i]['taxPercentage']}",
              "sssf": "${Detailspart[i]['taxAmount'].toStringAsFixed(2)}",
              "ssss": "${Detailspart[i]['amountIncludingTax'].toStringAsFixed(2)}",
            },
        ];
      }  else{
        purchasesAsMap = <Map<String, String>>[
          for(int i = 0; i < Detailspart.length; i++)
            {
              "s": "${Detailspart[i]['itmName']}",
              "ss": "${Detailspart[i]['rate'].toStringAsFixed(2)}",
              "ssshhs": "${Detailspart[i]['qty']}",
              "sss": "${Detailspart[i]['taxPercentage']}",
              "ssss": "${Detailspart[i]['amountIncludingTax'].toStringAsFixed(2)}",
            },
        ];
      }




    }

    // if(PgA4==true) {
    //   purchasesAsMap = <Map<String, String>>[
    //     for(int i = 0; i < Detailspart.length; i++)
    //       {
    //         "s": "${Detailspart[i]['itmName']}",
    //         "ss": "${Detailspart[i]['rate'].toStringAsFixed(2)}",
    //         "ssshhs": "${Detailspart[i]['qty']}",
    //         "sss": "${Detailspart[i]['taxPercentage']}",
    //         "sssf": "${Detailspart[i]['taxAmount'].toStringAsFixed(2)}",
    //         "ssss": "${Detailspart[i]['amountIncludingTax'].toStringAsFixed(2)}",
    //       },
    //   ];
    // }
    // else{
    //   purchasesAsMap = <Map<String, String>>[
    //     for(int i = 0; i < Detailspart.length; i++)
    //       {
    //         "s": "${Detailspart[i]['itmName']}",
    //         "ss": "${Detailspart[i]['rate'].toStringAsFixed(2)}",
    //         "ssshhs": "${Detailspart[i]['qty']}",
    //         "sss": "${Detailspart[i]['taxPercentage']}",
    //         "ssss": "${Detailspart[i]['amountIncludingTax'].toStringAsFixed(2)}",
    //       },
    //   ];
    // }

    List<List<String>> listOfPurchases = [];
    for (int i = 0; i < purchasesAsMap.length; i++) {
      listOfPurchases.add(purchasesAsMap[i].values.toList());
    }
    return listOfPurchases;
  }




//['اسم', 'معدل', 'الكمية', 'ضريبة', 'قيمة الضريبة', 'مقدار']


  Pagetype(pgTyp){
    setState(() {
      Pg_2_Inch=false;
      if (IsArabic==true) {
        pgTyp == "A4" ? PgA4 = true : PgA4 = false;
        PgA4 == true ?
        TblHeader = <dynamic>['مقدار', 'مبلغ الضريبة', 'ضريبة', 'كمية', 'معدل', 'اسم']
            : TblHeader = <dynamic>['مقدار', 'ضريبة', 'كمية', 'معدل', 'اسم'];
        print("PgA4");
        print(PgA4);
      }else{

        pgTyp == "A4" ? PgA4 = true : PgA4 = false;
        PgA4 == true ?
        TblHeader = <dynamic>['Name', 'Rate', 'Qty', 'Tax', 'Tax Amt', 'Amount']
            : TblHeader = <dynamic>['Name', 'Rate', 'Qty', 'Tax', 'Amount'];
        print("PgA4");
        print(PgA4);
      }
    });
  }
}
