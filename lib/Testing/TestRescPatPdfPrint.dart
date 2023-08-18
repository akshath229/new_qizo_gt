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

import '../GT_Masters/Printing/PDF_2Inch_Print.dart';
import '../appbarWidget.dart';
import '../models/userdata.dart';
import '../urlEnvironment/urlEnvironment.dart';

class TestRec_Pay_Print extends StatefulWidget {
  var Parm_Id;
  var printType;
  TestRec_Pay_Print({this.Parm_Id,this.printType});

  @override
  _TestRec_Pay_PrintState createState() => _TestRec_Pay_PrintState();
}

class _TestRec_Pay_PrintState extends State<TestRec_Pay_Print> {

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
  String IsArabicChkBoxText="Arabic";
  String dropdownValue = 'A4';
  late bool RecTyp;
  var PrintHeading="";
  var PrintArabicHeading="";
  var HeaderSuffix;
  var DeteailSuffix;

  void initState() {
    setState(() {
      SharedPreferences.getInstance().then((value) {
        pref = value;
        read();
        // GetdataPrint(widget.Parm_Id);
        //  footerdata();
        TypeCheck(widget.Parm_Id);
      });
    });
  }

//------------------for appbar------------
  read() async {
    try {
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
        GetCompantPro(branchId);
      });

    }catch(e){
      print("Error on read : $e");
    }
  }

  //
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
  //
  // // var Qrdata;
  // // GetQrdata() async {
  // //   try {
  // //     print("QR datas");
  // //     final tagsJson =
  // //     await http.get("${Env.baseUrl}SalesHeaders/${widget.Parm_Id}/qrcode", headers: {
  // //       "Authorization": user.user["token"],
  // //     });
  // //     var footerdata =await jsonDecode(tagsJson.body);
  // //     setState(() {
  // //       Qrdata = footerdata[0]["qrString"];
  // //       print( "QR datas :" +Qrdata.toString());
  // //     });
  // //
  // //   } catch (e) {
  // //     print(e);
  // //   }
  // // }


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
  var TotalAmt=0.0;

  GetdataPrint(url) async {
    print("GetdataPrint : $url");
    double amount = 0.0;
    try {
      final tagsJson =
      await http.get("${Env.baseUrl}$url" as Uri, headers: {
        //Soheader //SalesHeaders
        "Authorization": user.user["token"],
      });


      var resdata = await jsonDecode(tagsJson.body);



      dataForTicket=resdata["header"][0];
      print("dataForTicket");
      print(dataForTicket);
      print(dataForTicket['${HeaderSuffix}VoucherNumber']);


      Detailspart=resdata["details"];

      print("Detailspart");
      print(Detailspart);

      for(int i = 0; i < Detailspart.length; i++) {
        TotalAmt=TotalAmt+ Detailspart[i]['${DeteailSuffix}Amount'];
      }


      var  tempTime=dataForTicket["pvhVoucherDate"]??"2022-01-01T00:00:00";
      DateTime tempTimeFormate = new DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(tempTime);

      setState(() {
        InvTime= DateFormat.jm().format(tempTimeFormate);
        VchDate=DateFormat.yMMMMd().format(tempTimeFormate);
      });

    } catch (e) {
      print('error on databinding : $e');
    }
  }



  TypeCheck(id){
    try {
      dataForTicket = [];
      Detailspart = [];
      TotalAmt = 0.0;
      if (widget.printType == "Rcpt") {
        setState(() {
          var api = "TaccReceiptHeaders/$id";
          RecTyp = true;
          PrintHeading = "Receipt ";
          PrintArabicHeading = "قسيمة الإيصال";
          GetdataPrint(api);
          HeaderSuffix = "rvh";
          DeteailSuffix = "rd";
        });
      } else {
        setState(() {
          var api = "taccpaymentheaders/$id";
          RecTyp = false;
          PrintHeading = "Payment ";
          PrintArabicHeading = " قسيمة دفع";
          HeaderSuffix = "pvh";
          DeteailSuffix = "pd";
          GetdataPrint(api);
        });
      }
    }
    catch(e){
      print("Error on TypeCheck : $e");
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

            allowPrinting: true,
            allowSharing: false,
            canChangePageFormat: false,
            useActions: true,
            build: (format) => _generatePdf(format, ScreenSize,context),
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
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                        Pagetype(dropdownValue);
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
            //  height:PgA4==true?double.infinity:ScreenSize,
            child: pw.FittedBox(fit: pw.BoxFit.fill,
              child: dataForTicket == null ? pw.Text('') : pw.ListView(
                children: [


                  pw.Text(branchName, textAlign: pw.TextAlign.center,
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
                  // pw.SizedBox(height: 15),
                  // pw.Text('TAX INVOICE', textAlign: pw.TextAlign.center,
                  //     //textDirection: pw.TextDirection.rtl,
                  //     style: pw.TextStyle(
                  //       // font: ttf,
                  //         decoration:pw.TextDecoration.underline)),
                  //
                  // pw.SizedBox(height: 5),
                  //
                  // pw.Text("فاتورة ضريبية", textAlign: pw.TextAlign.center,
                  //     textDirection: pw.TextDirection.rtl,
                  //     style: pw.TextStyle(
                  //       font: ttf, )),
                  // pw.Center(child:pw.SizedBox(child: pw.Divider(),width: ScreenSize/5.5),heightFactor: 0),
                  // pw.SizedBox(height: 5),





                  pw.SizedBox(height: 5),
                  pw.Text('$PrintHeading Voucher', textAlign: pw.TextAlign.center,
                      //textDirection: pw.TextDirection.rtl,
                      style: pw.TextStyle(
                        // font: ttf,
                          decoration:pw.TextDecoration.underline)),

                  pw.SizedBox(height: 2),

                  pw.Text(PrintArabicHeading, textAlign: pw.TextAlign.center,
                      textDirection: pw.TextDirection.rtl,
                      style: pw.TextStyle(
                        font: ttf, )),
                  pw.Center(child:pw.SizedBox(child: pw.Divider(),width: ScreenSize/5.5),heightFactor: 0),
                  pw.SizedBox(height: 2),
                  pw.SizedBox(
                    height: 5,),




                  pw.Container(
                    //color: PdfColors.black,
                    width:ScreenSize,
                    child:            pw.Column(
                        crossAxisAlignment:IsArabic==true ?pw.CrossAxisAlignment.end:pw.CrossAxisAlignment.start,
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [

                          ///-----------
                          IsArabic==true?  pw.Text("رقم القسيمة    ${dataForTicket['${HeaderSuffix}VoucherNumber'].toString()}  :     ",
                              textDirection: pw.TextDirection.rtl,
                              style: pw.TextStyle(font: ttf)):


                          pw.Text('  $PrintHeading No   : ' +dataForTicket['${HeaderSuffix}VoucherNumber'].toString(),
                              // textAlign: pw.TextAlign.left,
                              // textDirection: pw.TextDirection.rtl,
                              style: pw.TextStyle(font: ttf)),



                          ///-----------
                          // IsArabic==true? pw.Text("رقم الأمر${(dataForTicket['salesHeader'][0]["orderNo"].toString())=="null"?"         - "
                          //     :"           "+ dataForTicket['salesHeader'][0]["orderNo"].toString()} :       ",
                          //     textDirection: pw.TextDirection.rtl,
                          //     style: pw.TextStyle(font: ttf)):
                          //
                          // pw.Text(dataForTicket['salesHeader'][0]["orderNo"]==null?
                          // "  Order No     : -":
                          // '  Order No     : ' +
                          //     dataForTicket['salesHeader'][0]["orderNo"].toString()),


                          ///-----------
                          IsArabic==true? pw.Text("تاريخ${(VchDate.toString())=="null"?"       - "
                              :"                 "+ VchDate.toString()} :            ",
                              textDirection: pw.TextDirection.rtl,
                              style: pw.TextStyle(font: ttf)):

                          pw.Text(VchDate==null?
                          "  Date      : -":
                          '  Date      : ' + VchDate.toString(),
                              style: pw.TextStyle(font: ttf)),





                          ///-----------
                          IsArabic==true? pw.Text("زمن${(InvTime.toString())=="null"?"       - "
                              :"                 "+ InvTime.toString()} :             ",
                              textDirection: pw.TextDirection.rtl,
                              style: pw.TextStyle(font: ttf)):

                          pw.Text(InvTime==null?
                          "  Time       : -":
                          '  Time       : ' + InvTime.toString(),
                              style: pw.TextStyle(font: ttf)),
                          //
                          //
                          //
                          //
                          //
                          //
                          // IsArabic==true? pw.Text("تاريخ الطباعة ${(VchDate.toString())=="null"?"       - "
                          //     :"                 "+ VchDate.toString()} :  ",
                          //     textDirection: pw.TextDirection.rtl,
                          //     style: pw.TextStyle(font: ttf)):
                          //
                          // pw.Text(VchDate==null?
                          // "  Print Date   : -":
                          // '  Print Date   : ' + VchDate.toString(),
                          //     style: pw.TextStyle(font: ttf)),






                          ///-----------
                          IsArabic==true?pw.Text('نوع   ${dataForTicket["lhName"]} :             ',
                              textDirection: pw.TextDirection.rtl,
                              style: pw.TextStyle(font: ttf)):
                          pw.Text('  Type      : ' +
                              dataForTicket["lhName"],
                              style: pw.TextStyle(font: ttf)),

                        ]),



                  ),


                  pw.Container(
                    width:ScreenSize,
                    child:
                    pw.Padding(
                        padding: const pw.EdgeInsets.only(top: 10,bottom: 10),
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
                                columnWidths:IsArabic==true?
                                {5: pw.FixedColumnWidth(150), 0 :pw.FixedColumnWidth(50), 5 :pw.FixedColumnWidth(50)}:
                                {0: pw.FixedColumnWidth(150), 0 :pw.FixedColumnWidth(50), 5 :pw.FixedColumnWidth(50)},

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
                  ),


                  pw.Container(width:PgA4==true? ScreenSize/1.07:ScreenSize/1.5,
                      //color:  PdfColors.red,
                      child:
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [

                            IsArabic==false?pw.Column(
                                children: [
                                  pw.Text("Total Amt     : ",style: pw.TextStyle(fontSize: 15,font: ttf),  textDirection: pw.TextDirection.rtl,),
                                ]):

                            pw.Column(
                                crossAxisAlignment:pw.CrossAxisAlignment.end,
                                children: [
                                  pw.Text("${TotalAmt.toString()==null?0.00:
                                  TotalAmt.toStringAsFixed(2)} : ",style: pw.TextStyle(fontSize: 15,font: ttf),textDirection: pw.TextDirection.rtl,),

                                ]),



                            IsArabic==false? pw.Column(
                                crossAxisAlignment:pw.CrossAxisAlignment.end,
                                children: [

                                  pw.Text("${TotalAmt.toString()==null?0.00:
                                  TotalAmt.toStringAsFixed(2)}  ",style: pw.TextStyle(fontSize: 15,font: ttf),textDirection: pw.TextDirection.rtl,),


                                ]):

                            pw.Column(
                                crossAxisAlignment:pw.CrossAxisAlignment.end,
                                children: [
                                  pw.Text("المبلغ الإجمالي      ",style: pw.TextStyle(fontSize: 15,font: ttf),  textDirection: pw.TextDirection.rtl,),
                                ]),


                          ])

                  ),


                  pw.SizedBox(child: pw.Divider()  ,height: 10,width:ScreenSize),
                  pw.SizedBox( height: 10,),

                  pw.Container(width:ScreenSize,
                      //color:  PdfColors.red,
                      child:
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            RecTyp==true?  pw.Expanded(child:pw.Text("Received by   :  $userName",style: pw.TextStyle(fontSize: 15,font: ttf),  textDirection: pw.TextDirection.rtl,))
                                :
                              pw.Expanded(child:pw.Text("Prepaired by    :  $userName",style: pw.TextStyle(fontSize: 15,font: ttf),  textDirection: pw.TextDirection.rtl,)),
                         pw.SizedBox(width: 100),
                           pw.Expanded(child:  pw.Text("for   : $branchName ",style: pw.TextStyle(fontSize: 15,font: ttf)))
                          ]))


                  // pw.Row(
                  //     crossAxisAlignment: pw.CrossAxisAlignment.start,
                  //     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  //     children:[
                  //       pw.SizedBox(
                  //         height: 10,),
                  //
                  // pw.BarcodeWidget(
                  //   // data: widget.Parm_Id.toString(),
                  //     data: Qrdata.toString(),
                  //     barcode: pw.Barcode.qrCode(),
                  //     width: 100,
                  //     height: 50
                  // ),

                  // pw.SizedBox(
                  //   width: 20,),
                  // pw.SizedBox(height: 10),
                  // pw.BarcodeWidget(
                  //     data: widget.Parm_Id.toString(),
                  //     barcode: pw.Barcode.code39(),
                  //     width: 100,
                  //     height: 50
                  // ),
                  //
                  //     ]),

                  // pw.SizedBox(height: 10),
                  //  pw.Text(footerCaptions[0]['footerText']+"...",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,font: ttf))

                ],
              ),
            ),
          );
        },
      ),
    );

    return pdf.save();
  }


  List <dynamic> TblHeader=['Sl.No', 'Particulars', 'Amount', 'Narration'];
  TableGenerator() {
    if(IsArabic==true){
      TblHeader= ['Sl.No   عدد', 'Particulars  تفاصيل ', 'Amount مقدار', 'Narration  السرد',];
    }
    else{
      TblHeader = <dynamic>['Sl.No', 'Particulars', 'Amount', 'Narration'];

    }




    var purchasesAsMap;
    if(IsArabic==true){


      purchasesAsMap = <Map<String, String>>[
        for(int i = 0; i < Detailspart.length; i++)
          {

            "sssss": "${(i+1).toString()}",
            "ssss": "${Detailspart[i]['lhName'].toString()}",
            "sss": "${Detailspart[i]['${DeteailSuffix}Amount'].toString()}",
            "s": "  ${Detailspart[i]['${DeteailSuffix}SingleRemarks']??""}",


          },
      ];

    }else{


      purchasesAsMap = <Map<String, String>>[
        for(int i = 0; i < Detailspart.length; i++)
          {
            "sssss": "${(i+1).toString()}",
            "ssss": "${Detailspart[i]['lhName'].toString()}",
            "sss": "${Detailspart[i]['${DeteailSuffix}Amount'].toString()}",
            "s": "  ${Detailspart[i]['${DeteailSuffix}SingleRemarks']??""}",
          },
      ];
    }

    List<List<String>> listOfPurchases = [];
    for (int i = 0; i < purchasesAsMap.length; i++) {
      listOfPurchases.add(purchasesAsMap[i].values.toList());
    }
    return listOfPurchases;
  }




//['التفاصيل', 'معدل', 'الكمية', 'ضريبة', 'قيمة الضريبة', 'المجموع']


  Pagetype(pgTyp){
    setState(() {
      if (IsArabic==true) {
        TblHeader = <dynamic>['Sl.No \n عدد', 'Particulars \n تفاصيل', 'Amount \n مقدار', 'Narration \n السرد', ];
      }else{
        TblHeader = <dynamic>['Sl.No', 'Particulars', 'Amount', 'Narration'];

      }
    });
  }
}
