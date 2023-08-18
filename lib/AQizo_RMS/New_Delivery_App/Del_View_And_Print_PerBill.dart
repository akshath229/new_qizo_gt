import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';

import '../../GT_Masters/Masters_UI/cuWidgets.dart';
import '../../appbarWidget.dart';
import '../../models/userdata.dart';
import '../../urlEnvironment/urlEnvironment.dart';


class Del_Perv_Bill_Print extends StatefulWidget {

  var Ftr_Data;
  var Last_Bill_Id;
  var Counter_Printer_id;
  var KOT_Printer_id;

  Del_Perv_Bill_Print({this.Ftr_Data,this.Last_Bill_Id,this.Counter_Printer_id,this.KOT_Printer_id});

  @override
  _Del_Perv_Bill_PrintState createState() => _Del_Perv_Bill_PrintState();
}

class _Del_Perv_Bill_PrintState extends State<Del_Perv_Bill_Print> {

  late SharedPreferences pref;
  dynamic branch;
  dynamic user;
  late int branchId;
  late int userId;
  late UserData userData;
  String branchName = "";
  dynamic userName;
  late String token;
  String dateNow = DateFormat("yyyy-MM-dd").format(DateTime.now());
  var EmpId;
  var currencyName ;
  var Companydata;
  var dataForTicket;
  var footerCaptions;
  var Perv_Bill_Id;
  List<dynamic> DetailPart=[];
  List<dynamic> AddonData=[];
  CUWidgets _cw=CUWidgets();

  TextEditingController PerviousBillPrint_Controller=TextEditingController();
  bool PerviousBillPrint_Validation=false;

  @override
  void initState() {
    // TODO: implement initState
    SharedPreferences.getInstance().then((value) {
      pref = value;
      read();
      footerCaptions=widget.Ftr_Data;
      Perv_Bill_Id=widget.Last_Bill_Id;
      GetBill_Data(Perv_Bill_Id);
      PerviousBillPrint_Controller.text=widget.Last_Bill_Id.toString();
    });
  }



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
      currencyName = user.user["currencyName"];
      GetCompantPro(branchId);
      EmpId=user.user["loginedEmployeeId"];
      print("uiuiouioiuouio");
      print(EmpId);
    });
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

  GetBill_Datas(Bill_No)async {
    print("error on GetCompantPro : $Bill_No");
    var res = await _cw.CUget_With_Parm(
        api: "SalesHeaders/$Bill_No/VoucherNumber", Token: token);
    if (res != false) {

      setState(() {
        dataForTicket = json.decode(res);
        DetailPart =dataForTicket["salesDetails"] as List;
        AddonData=dataForTicket["AddonData"];
        print("res");
        log(res);
      });
    }
  }

  GetBill_Data(Bill_No)async {
    var res = await _cw.CUget_With_Parm(
        api: "SalesHeaders/$Bill_No", Token: token);
    if (res != false) {

      setState(() {
        dataForTicket = json.decode(res);
        DetailPart =dataForTicket["salesDetails"] as List;
        AddonData=dataForTicket["AddonData"];
        print("res");
        log(res);
      });

    }
  }


  //-----Table Index no-----------------
  getItemIndex(dynamic item) {
    var index = DetailPart.indexOf(item);
    return index + 1;
  }
  ///-----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(child:  Appbarcustomwidget(

          branch: branchName,
          pref: pref,
          title: "Bill Print",
          uname: userName,

        ), preferredSize: Size.fromHeight(80)),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [

                SizedBox(height: 50,),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // height:PerviousBillPrint_Validation==true? 80:50,
                      width: 200,

                      child: TextFormField(
                        controller: PerviousBillPrint_Controller,
                        enabled: true,
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v!.isEmpty) return "Required";
                          return null;
                        },
                        cursorColor: Colors.black,
                        // scrollPadding: EdgeInsets.fromLTRB(0, 1, 1, 0),
                        inputFormatters: <TextInputFormatter>[],
                        decoration: InputDecoration(
                            errorStyle: TextStyle(color: Colors.red),
                            errorText: PerviousBillPrint_Validation == true ? "Invalid" : null,
                            //  isDense: true,
                            contentPadding:
                            EdgeInsets.fromLTRB(15.0, 1.0, 5.0, 1.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.0)),
                            hintStyle: TextStyle(
                                color: Colors.black, fontSize: 15),
                            labelText: "Bill Number",
                            labelStyle: TextStyle(fontSize: 13)
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    InkWell(
                      onTap: (){
                        if(PerviousBillPrint_Controller.text==""){
                          setState((){
                            PerviousBillPrint_Validation=true;
                          });
                          return;
                        }
                        else{
                          setState((){
                            PerviousBillPrint_Validation=false;

                            GetBill_Datas(PerviousBillPrint_Controller.text);
                          });

                        }
                      },
                      child: Container(
                        height: 45,
                        width: 80,
                        color: Colors.indigo,
                        child: Center(child: Text('OK',style: TextStyle(color: Colors.white,fontSize: 20),)),
                      ),
                    ),

                    //
                    // SizedBox(width: 10,),
                    // InkWell(
                    //   onTap: (){
                    //     _tickets(PaperSize.mm80);
                    //   },
                    //   child: Container(
                    //     height: 45,
                    //     width: 80,
                    //     color: Colors.indigo,
                    //     child: Center(child: Text('Test Print',style: TextStyle(color: Colors.white,fontSize: 20),)),
                    //   ),
                    // ),

                  ],
                ),



                DetailPart.length>0?
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: ScrollPhysics(),
                  child: Row(
                    children: [
                      Expanded(
                        child: DataTable(

                          columnSpacing: 15,
                          onSelectAll: (b) {},
                          sortAscending: true,
                          columns: <DataColumn>[
                            DataColumn(
                              label: Text('NO'),
                            ),
                            DataColumn(
                              label: Text('Name'),
                            ),
                            DataColumn(
                              label: Text('UOM'),
                            ),
                            DataColumn(
                              label: Text('QTY'),
                            ),
                            DataColumn(
                              label: Text('Rate'),
                            ),
                            DataColumn(
                              label: Text('Total'),
                            ),
                          ],
                          rows: DetailPart
                              .map(
                                (itemRow) => DataRow(
                              cells: [
                                DataCell(
                                  Visibility(
                                      visible: true,
                                      child: InkWell(
                                        child: Text(getItemIndex(itemRow).toString()),
                                        onTap: (){
                                          print(itemRow['itemNotes'].length.toString());
                                        },
                                      )),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(

                                  Row(
                                    children: [

                                      Text(itemRow["itmName"]
                                          .toString()),

                                      itemRow['addonItems'].toString()=="[]"?Text(""):
                                      PopupMenuButton<int>(
                                          icon: Icon(Icons.add_box),
                                          onSelected:(a){
                                            print("saf $a");
                                          } ,
                                          color:Colors.teal,
                                          itemBuilder: (context) => [
                                            PopupMenuItem(height: 30,
                                                child:
                                                SingleChildScrollView(
                                                  scrollDirection: Axis.vertical,
                                                  child: Container(
                                                    height: 80,
                                                    width: 170,
                                                    child: ListView.builder(

                                                        shrinkWrap: true,
                                                        itemCount:itemRow['addonItems'].length ,
                                                        itemBuilder: (context, index) {
                                                          return Text("${index+1} . ${itemRow['addonItems'][index]['addonItemName']} \n "
                                                              "     ${itemRow['addonItems'][index].qty} x ${itemRow['addonItems'][index]['addonRate']} = ${itemRow['addonItems'][index].qty * itemRow['addonItems'][index]['addonRate']}".toString(),style: TextStyle(color: Colors.white,fontSize: 16),);
                                                        }
                                                    ),

                                                  ),
                                                )
                                            )
                                          ]),


                                      itemRow['itemNotes'].toString()=="[]"?Text(""):
                                      PopupMenuButton<int>(
                                          icon: Icon(Icons.library_books),
                                          onSelected:(a){
                                            print("saf $a");
                                          } ,

                                          color:Colors.teal,
                                          itemBuilder: (context) => [
                                            PopupMenuItem(height: 30,
                                                child:
                                                SingleChildScrollView(
                                                  scrollDirection: Axis.vertical,
                                                  child: Container(
                                                    height: 80,
                                                    width: 170,
                                                    child: ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount:itemRow['itemNotes'].length ,
                                                        itemBuilder: (context, index) {
                                                          return Text("${index+1} . ${itemRow['itemNotes'][index]["notes"]["notes"]} ".toString(),style: TextStyle(color: Colors.white,fontSize: 16),);
                                                        }
                                                    ),

                                                  ),
                                                )
                                            )
                                          ]),

                                    ],
                                  ),

                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text( itemRow["uom"]
                                      .toString()),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(itemRow["qty"]
                                      .toString()),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text((itemRow["rate"])
                                      .toString()),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text((itemRow
                                  ["amountIncludingTax"]) !=
                                      null
                                      ? itemRow["amountIncludingTax"]
                                      .toString()
                                      : 0.0.toString()),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                              ],
                            ),
                          )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                )

                    :
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Text("InValid Bill Number !",
                    style: TextStyle(color: Colors.red,fontSize: 22),),
                )
              ],
            ),
          ),
        ),

        bottomSheet: Padding(
          padding: const EdgeInsets.all(5.0),
          child: SizedBox(height: 60,child: Row(
            children: [
              // Expanded(
              //   child: InkWell(
              //     onTap: (){
              //       wifiprinting(widget.Counter_Printer_id);
              //       Timer(Duration(seconds: 1), (){
              //         widget.KOT_Printer_id.toString()=="null"?
              //         wifiprinting(widget.Counter_Printer_id):
              //         wifiprinting(widget.KOT_Printer_id);
              //       });
              //     },
              //     child: Container(
              //       color: Colors.indigoAccent,
              //       child: Center(child: Text('Print',style: TextStyle(color: Colors.white,fontSize: 25),)),
              //     ),
              //   ),
              // ),
              SizedBox(width: 5,),

              Expanded(
                child: InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    color: Colors.indigo,
                    child: Center(child: Text('Back',style: TextStyle(color: Colors.white,fontSize: 25),)),
                  ),
                ),
              ),
            ],
          ),),
        ),
      ),
    );
  }


  ///-----------------------print Pert-------------------------------------


  PrinterNetworkManager _printerManager = PrinterNetworkManager();
  Future<Ticket> _ticket(PaperSize paper) async {
    print('in print Ticket');
    final ticket = Ticket(paper);


    print("dataForTicket");
    print(dataForTicket.toString());
    print("DetailPart");
    print(DetailPart.toString());

    dynamic VchNo = (dataForTicket["salesHeader"][0]["voucherNo"]) == null
        ? "00": (dataForTicket["salesHeader"][0]["voucherNo"]).toString();

    dynamic date = (DateFormat("dd/MM/yyy hh:mm:ss a").format(DateTime.now()).toString());


    dynamic partyName=(dataForTicket["partyName"]) == null ||
        (dataForTicket["partyName"])== ""
        ? ""
        : (dataForTicket["partyName"]).toString();



    ticket.row([
      PosColumn(text: ' ', width: 1),
      PosColumn(
          text:branchName.toString(),
          width: 10,
          styles: PosStyles(bold: true,
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
      PosColumn(text: ' ', width: 1)
    ]);




    ticket.row([
      PosColumn(text: ' ', width: 1),
      PosColumn(
          text:(Companydata["companyProfileAddress1"]).toString(),
          // text:("Order Slip"),
          width: 10,
          styles:PosStyles(bold: false,
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,)),
      PosColumn(text: ' ', width: 1)
    ]);


// ticket.text("اختبار",styles: );

    //
    ticket.row([
      PosColumn(text: ' ', width: 1),
      PosColumn(
          text: (Companydata["companyProfileAddress2"]).toString(),
          width: 10,
          styles:PosStyles(bold: false,
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(text: ' ', width: 1)
    ]);
    //
    ticket.row([
      PosColumn(text: ' ', width: 1),
      PosColumn(
          text:  (Companydata["companyProfileAddress3"]).toString(),
          width: 10,
          styles:PosStyles(bold: false,
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(text: ' ', width: 1)
    ]);
    //
    //
    //
    ticket.row([
      PosColumn(text: ' ', width: 1),
      PosColumn(
          text:(Companydata["companyProfileMobile"]).toString(),
          width: 10,
          styles:PosStyles(bold: false,
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(text: ' ', width: 1)
    ]);
    //
    //
    //
    //
    ticket.row([
      PosColumn(text: ' ', width: 1),
      PosColumn(
          text:  (Companydata["companyProfileEmail"]).toString(),
          width: 10,
          styles:PosStyles(bold: false,underline: true,
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(text: ' ', width: 1)
    ]);
    //
    //
    //
    //
    //
    ticket.text('GSTIN: ' +
        ( Companydata["companyProfileGstNo"]).toString()+' ',
        styles: PosStyles(bold: false,
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ));



    ticket.hr(ch: '=');

    ticket.text('ORDER NO . ' + VchNo.toString(),
        styles: PosStyles( width: PosTextSize.size2, align: PosAlign.center,));
    //ticket.emptyLines(1);
    //  ticket.text(dataForTicket["salesHeader"][0]["orderType"], styles: PosStyles(width: PosTextSize.size2, align: PosAlign.center,));

    ticket.hr(ch: '=');

    // ticket.text('Bill NO : ' + VchNo.toString(),
    //     styles: PosStyles(bold: true, width: PosTextSize.size1));
    // //ticket.emptyLines(1);
    // ticket.text('Date    : $date');

    //---------------------------------------------------------
    // if(partyName !="")
    // {
    //   //ticket.emptyLines(1);
    //   ticket.text('Name : $partyName');
    // }
    // if((dataForTicket["gstNo"]) !=null)
    // {
    //   // ticket.emptyLines(1);
    //   ticket.text('GST No :' +((dataForTicket["gstNo"])));
    // }
    //---------------------------------------------------------


    ticket.row([
      PosColumn(
        text:'No',
        styles: PosStyles(align: PosAlign.left ),
        width:1,
      ),
      PosColumn(
        text:'Item',
        styles: PosStyles(align: PosAlign.left),
        width: 3,
      ),
      PosColumn(text: 'Rate', width: 3,styles:PosStyles(align: PosAlign.right)),
      PosColumn(text: 'Qty', width: 2,styles: PosStyles(align: PosAlign.right ),),
      // PosColumn(text: 'Tax', width: 2,styles: PosStyles(align: PosAlign.center ),),
      PosColumn(text: ' Amount', width: 3,styles: PosStyles(align: PosAlign.center ),),
    ]);
    ticket.hr(ch: "_"); // for dot line or set ticket.hr(ch: 'charecter', linesAfter: 1);
    var snlnum=0;
    dynamic total = 0.000;
    for (var i = 0; i < DetailPart.length; i++) {
      total = DetailPart[i]["amountIncludingTax"] ?? 0 + total;
      // ticket.emptyLines(1);
      snlnum = snlnum + 1;
      ticket.row([
        PosColumn(text: (snlnum.toString()), width: 1, styles: PosStyles(
          align: PosAlign.left,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        )),

        PosColumn(text: ((

            DetailPart[i]["itmName"].toString().length>39?
            DetailPart[i]["itmName"].toString().replaceRange(19,19,"\n").replaceRange(38, 38, '\n'):
            DetailPart[i]["itmName"].toString().length>19?
            DetailPart[i]["itmName"].toString().replaceRange(19,19,"\n"):
            DetailPart[i]["itmName"]
            // DetailPart[i]["itmName"].toString().length>19?
            // (DetailPart[i]["itmName"]).toString().replaceRange(19,19,"\n"):
            // (DetailPart[i]["itmName"])
        ) ?? ""),
            width: 3, styles:
            PosStyles(align: PosAlign.left,
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                //fontType:DetailPart[i]["itmName"].toString().length<13? PosFontType.fontA:PosFontType.fontB,
                bold: true)),


        // for space
        PosColumn(
            text: (((DetailPart[i]["rate"])).toStringAsFixed(2)).toString(),
            width: 3,
            styles: PosStyles(
              align: PosAlign.right,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              // fontType: PosFontType.fontA
            )),
        PosColumn(
            text: (' ' + ((DetailPart[i]["qty"])).toStringAsFixed(0))
                .toString(),
            styles: PosStyles(align: PosAlign.right, height: PosTextSize.size1,
              width: PosTextSize.size1,),
            width: 2),
        // PosColumn(
        //     text: (' ' + ((DetailPart[i]["taxAmount"])).toStringAsFixed(2))
        //         .toString(),styles:PosStyles(align: PosAlign.right ),
        //     width: 2),
        PosColumn(
            text: ((DetailPart[i] ["amountIncludingTax"])).toStringAsFixed(2)
            ,
            styles: PosStyles(align: PosAlign.center, height: PosTextSize.size1,
              width: PosTextSize.size1,),
            width: 3),
      ]);

      for (var k = 0; k < DetailPart[i]["addonItems"].length; k++) {
        ticket.row([


          PosColumn(text: (" +"), width: 1, styles: PosStyles(
              align: PosAlign.left
          )),

          PosColumn(text: (DetailPart[i]["addonItems"][k]["itmName"] ?? ""),
              width: 3,
              styles:
              PosStyles(align: PosAlign.left)),


          PosColumn(
              text: (((DetailPart[i]["addonItems"][k]["addonItemRate"]))
                  .toStringAsFixed(2)).toString(),
              width: 3,
              styles: PosStyles(
                  align: PosAlign.right
              )),

          PosColumn(
              text: (' ' + ((DetailPart[i]["addonItems"][k]["addonItemQty"]))
                  .toStringAsFixed(0)).toString(),
              styles: PosStyles(align: PosAlign.right),
              width: 2),

          PosColumn(
              text: ((DetailPart[i]["addonItems"][k]["addonItemQty"]) *
                  ((DetailPart[i]["addonItems"][k]["addonItemRate"])))
                  .toStringAsFixed(2)
              , styles: PosStyles(align: PosAlign.center),
              width: 3),


        ]);
      }


      for (var j = 0; j < DetailPart[i]["itemNotes"].length; j++) {
        ticket.row([

          PosColumn(text: ("   *"), width: 2, styles: PosStyles(
              align: PosAlign.right
          )),

          PosColumn(text: (DetailPart[i]["itemNotes"][j]["notes"]["notes"]), width: 10, styles: PosStyles(
              align: PosAlign.left
          )),
        ]);

      }



      i == (DetailPart.length-1)? ticket.hr(ch:"_"):ticket.hr(ch:"-");
    }



    double DelAmt=double.parse(dataForTicket["salesHeader"][0]["otherAmt"].toString()) ;

    DelAmt>0?
    ticket.row([
      PosColumn(
        text:' ',
        width: 1,),
      PosColumn(
          text:'Delivery Charge : $currencyName '+(dataForTicket["salesHeader"][0]["otherAmt"].toStringAsFixed(2)),
          width: 10,
          styles: PosStyles(bold: true,align: PosAlign.right,)),
      PosColumn(
        text:' ',
        width: 1,),
    ]):ticket.text("");


    ticket.row([
      PosColumn(
        text:' ',
        width: 1,),
      PosColumn(
          text:'Total : $currencyName '+(dataForTicket["salesHeader"][0]["amount"].toStringAsFixed(2)),
          width: 10,
          styles: PosStyles(bold: true,align: PosAlign.right,)),
      PosColumn(
        text:' ',
        width: 1,),
    ]);
    ticket.hr(
        ch: '_');

    // ticket.row([
    //   PosColumn(text: ' ', width: 1),
    //   PosColumn(
    //       text: footerCaptions[0]['footerCaption'],
    //       width: 10,
    //       styles: PosStyles(align: PosAlign.center)),
    //   PosColumn(text: ' ', width: 1)
    // ]);
    //
    // ticket.row([
    //   PosColumn(text: '  ', width: 1),
    //   PosColumn(
    //       text: footerCaptions[0]['footerText'],
    //       width: 10,
    //       styles: PosStyles(align: PosAlign.center)),
    //   PosColumn(text: '  ', width: 1)
    // ]);

    ticket.feed(1);
    if(footerCaptions.toString()!="null"||footerCaptions!=[]||footerCaptions!="[]"){
      print("footerCaptions");
      print(footerCaptions);
      try {
        ticket.text(footerCaptions['footerText'],
            //'Thank You...Visit again !!',
            styles: PosStyles(align: PosAlign.center, bold: true));
      }catch(e){};
    }




    List<dynamic> k=[] ;
    k.add(dataForTicket["salesHeader"][0]["id"].toString().padLeft(5, '0').split("") );
    print("zzzzzzzzzzzzzzzzzz");
    print(k[0].toString());
    print(k.toString());
    ticket.barcode(Barcode.code39(k[0]),height: 80);

    ticket.feed(2);

    ticket.text(date.toString(),styles: PosStyles(align: PosAlign.center ));
    ticket.text('User : $userName',styles: PosStyles(align: PosAlign.center ) );
    print("Finish");
    ticket.cut();
    return ticket;
  }
  //..................................................
  wifiprinting(printerName) async {
    // try {

    print("in print in 123");
    print(printerName.toString());

    _printerManager.selectPrinter(printerName);

    //  _printerManager.selectPrinter('192.168.0.100');

    final res =
    await _printerManager.printTicket(await _ticket(PaperSize.mm80));
    print("out print in");
    // } catch (e) {
    //   print("error on print $e");
    // }
  }





///-------------------------------------



}
