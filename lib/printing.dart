import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:intl/intl.dart';
import 'package:new_qizo_gt/urlEnvironment/urlEnvironment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/userdata.dart';

import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'dart:io';
// import 'package:flutter/src/widgets/framework.dart';

/// used only Sales order index
class flutter_printer {




  BluetoothManager bluetoothManager = BluetoothManager.instance;
  PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
  List<PrinterBluetooth> _devices = [];
//-----------------------------------------
  late SharedPreferences pref;
  dynamic data;
  dynamic branch;
  var res;
  dynamic user;
  late int branchId;
  late int userId;
  late UserData userData;
  String branchName = "";
  dynamic userName;
  late String token;
  int total = 0;
  var tabStats = "";
  var Companydata;
  var dataForTicket;
  var footerCaptions;
  var  _devicesMsg="";
// //----------------------------------
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
        Companydata = jsonDecode(tagsJson.body);
      }
      // print( "on GetCompantPro :" +Companydata.toString());
    }
    catch(e){
      print("error on GetCompantPro : $e");
    }
  }
//----------printing ticket generate--------------------------

  Future<Ticket> _ticket(PaperSize paper) async {
    // final ticket = Ticket(paper);
    print('in');
    // final profile = await CapabilityProfile.load();
    final ticket = Ticket(paper);
    List<dynamic> slsDet = await dataForTicket["data"]["sodetailed"] as List;
    dynamic VchNo = (dataForTicket["data"]["voucherNo"]) == null
        ? "00"
        : (dataForTicket["data"]["voucherNo"]).toString();
// dynamic date=(dataForTicket["data"]]["voucherDate"])==null?"-:-:-": DateFormat("yyyy-MM-dd hh:mm:ss").format((dataForTicket["data"][0]["voucherDate"]));
    dynamic date = (DateFormat("dd/MM/yyy hh:mm:ss a").format(DateTime.now()).toString());
    dynamic partyName=(dataForTicket["data"]["partyName"]) == null ||
        (dataForTicket["data"]["partyName"])== ""
        ? ""
        : (dataForTicket["data"]["partyName"]).toString();

    print(("dataForTicket amount"));
    print((dataForTicket["data"]["amount"]).toString());
    var netAmt=(dataForTicket["data"]["amount"]);


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
          width: 10,
          styles:PosStyles(bold: false,
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,)),
      PosColumn(text: ' ', width: 1)
    ]);



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





    ticket.text('GSTIN: ' +
        ( Companydata["companyProfileGstNo"]).toString()+' ',
        styles: PosStyles(bold: false,
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ));



    ticket.text('Order NO : ' + VchNo.toString(),
        styles: PosStyles(bold: true, width: PosTextSize.size1));
    //ticket.emptyLines(1);
    ticket.text('Date : $date');
    //---------------------------------------------------------
    if(partyName !="")
    {
      //ticket.emptyLines(1);
      ticket.text('Name : $partyName');
    }
    if((dataForTicket["data"]["gstNo"]) !=null)
    {
      // ticket.emptyLines(1);
      ticket.text('GST No :' +((dataForTicket["data"]["gstNo"])));
    }
    //---------------------------------------------------------

    ticket.hr(ch: '_');

    ticket.row([
      PosColumn(text:'No', width:1,styles:PosStyles(align: PosAlign.left)),
      PosColumn(
        text: 'Item',
        styles: PosStyles(bold: true),
        width: 2,
      ),
      PosColumn(text:'Qty', width: 2,styles: PosStyles(align: PosAlign.right ),),
      PosColumn(text:'Rate', width: 3,styles:PosStyles(align: PosAlign.center)),
      // PosColumn(text: 'Tax', width: 2,styles: PosStyles(align: PosAlign.center ),),
      PosColumn(text:'Amonunt', width: 4,styles: PosStyles(align: PosAlign.center ),),
    ]);
    ticket
        .hr(); // for dot line or set ticket.hr(ch: 'charecter', linesAfter: 1);

    dynamic NetTotal = 0.000;
    dynamic totalTax = 0.000;
    int snlnum=0;
    print(slsDet.toString());
    print(slsDet.length.toString());
    print(slsDet[0]["itemName"]);
    for (var i = 0; i < slsDet.length; i++) {
      //  double tax=((slsDet[i]["taxAmount"])==null?0.00:double.parse(slsDet[i]["taxAmount"]));
      // // total = tax + total;
      //  totalTax=tax+totalTax;
      var totalamt=((slsDet[i]["rate"])*(slsDet[i]["qty"]));
      NetTotal =totalamt + NetTotal;
      var qty=(slsDet[i]["qty"]);
      // ticket.emptyLines(1); // for space
      var oneitmtotal=qty*(slsDet[i]["rate"]);
      snlnum=snlnum+1;
      // print("iii");
      // print(i.toString());
      ticket.row([
        PosColumn(text: (snlnum.toString()),width: 1,styles: PosStyles(
        )),

        PosColumn(text: (slsDet[i]["itemName"]),
            width: 11,styles:
            PosStyles(align: PosAlign.left )),] );

      ticket.row([
        PosColumn(
            text: (""),
            width: 2,
            styles: PosStyles(

            )),
        PosColumn(
            text: (''+((slsDet[i]["qty"])).toStringAsFixed(0)).toString(),styles:PosStyles(align: PosAlign.center ),
            width: 2),
        PosColumn(
            text: (((slsDet[i]["rate"])).toStringAsFixed(2)).toString(),
            width: 4,
            styles: PosStyles(
                align: PosAlign.right
            )),
        // PosColumn(
        //     text: (' ' + tax.toStringAsFixed(2))
        //         ,styles:PosStyles(align: PosAlign.right ),
        //     width: 2),
        PosColumn(
            text:
            (oneitmtotal.toStringAsFixed(2)),
            styles:PosStyles(align: PosAlign.right ),
            width: 4),
      ]);
    }
    ticket.hr(
      ch: '=',
      // linesAfter: 1,
    );
    print("zzz");
    print(snlnum.toString());
    // print(totalTax.toStringAsFixed(2));
    // print((totalTax+NetTotal).toStringAsFixed(2));
    //ticket.hr();
    ticket.row([
      PosColumn(
          text: 'Total Tax',
          width: 5,
          styles: PosStyles(align: PosAlign.left,
            bold: true,
          )),
      PosColumn(
          text: 'Rs ' + ((netAmt-NetTotal).toStringAsFixed(2)).toString(),
          width: 7,
          styles: PosStyles(bold: true,align: PosAlign.right,)),
    ]);
    ticket.row([
      PosColumn(
          text: 'Total',
          width: 4,
          styles: PosStyles(align: PosAlign.left,
            bold: true,

          )),
      PosColumn(
          text: 'Rs ' + ((netAmt).toStringAsFixed(2)).toString(),
          width: 8,
          styles: PosStyles(bold: true,align: PosAlign.right,)),
    ]);
    ticket.hr(
      ch: '_',
      linesAfter: 1,
    );


    // print("Ttax= ${(netAmt-NetTotal).toString()}");
    // print("Totlamt= ${(netAmt).toString()}");



    // ticket.row([
    //   PosColumn(text: ' ', width: 1),
    //   PosColumn(
    //       text: footerCaptions[0]['footerCaption'],
    //       width: 10,
    //       styles: PosStyles(align: PosAlign.center)),
    //   PosColumn(text: ' ', width: 1)
    // ]);

    // ticket.row([
    //   PosColumn(text: '  ', width: 1),
    //   PosColumn(
    //       text: footerCaptions[0]['footerText'],
    //       width: 10,
    //       styles: PosStyles(align: PosAlign.center)),
    //   PosColumn(text: '  ', width: 1)
    // ]);

    ticket.feed(1);
    ticket.text('Thank You...Visit again !!',
        styles: PosStyles(align: PosAlign.center, bold: true));

    ticket.cut();
    return ticket;
  }
// //..................................................


  void initialFunction(id) {
      SharedPreferences.getInstance().then((value) {
        pref = value;
        read();
       // footerdata();
        GetdataPrint(id);
        Priter_Initial_Part();
    });
  }

//------------------for appbar------------
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

    GetCompantPro(userId);
  }



  GetdataPrint(id) async {

    print("sales for print : $id");
    double amount = 0.0;
    try {
      final tagsJson =
      await http.get("${Env.baseUrl}Soheader/$id" as Uri, headers: {
        //Soheader //SalesHeaders
        "Authorization": user.user["token"],
      });
      dataForTicket = await jsonDecode(tagsJson.body);
       print("sales for print");
      print(dataForTicket);

      Timer(Duration(milliseconds: 1), () async{
        // await wifiprinting();
       // blutoothprinting();
         //_ticket(PaperSize.mm58);
      });

    } catch (e) {
      print('error on databinding $e');
    }
  }



  footerdata() async {
    try {
      print("footer data decoded  ");
      final tagsJson =
      await http.get("${Env.baseUrl}SalesInvoiceFooters/" as Uri, headers: {
        "Authorization": user.user["token"],
      });


        footerCaptions = jsonDecode(tagsJson.body);
        print( "on footerCaptions :" +footerCaptions.toString());
        // wifiprinting();

    } catch (e) {
      print(e);
    }
  }



  Priter_Initial_Part(){
    if (Platform.isAndroid) {
      bluetoothManager.state.listen((val) {
        print('state = $val');
        if (val==null) return;
        if (val == 12) {
          print('on');
          searchPrinter();
        } else if (val == 10) {
          print('off');
          _devicesMsg = 'Bluetooth Disconnect!';
         //blutoothEnable();
        }
      });
    } else {
      searchPrinter();
    }


  }

  void searchPrinter() {
    try {
      _printerManager.startScan(Duration(seconds: 2));
      _printerManager.scanResults.listen((val) {
        if (val==null) return;
        _devices = val;
        if (_devices.isEmpty){_devicesMsg = 'No Devices';}
      });
    }
    catch(e){print("result for scan print $e");}
    Timer(Duration(seconds: 3),() {
      blutoothprinting();
      //_ticket(PaperSize.mm58);
    });
  }

  blutoothprinting(){
    print(" on blutoothprinting");
    for(int i=0;i<_devices.length;i++){
      if(_devices[i].address=="00:11:22:33:44:55"){
        print("find _devices");
        print(_devices.length.toString());
        print(_devices[i].address);
        print(_devices[i].name);
        print(i.toString());
        _startPrint(_devices[i]);
        // dispose();
        break;
      }
    }

    print("not find _devices");

  }

  Future<void> _startPrint(PrinterBluetooth printer) async {
    _printerManager.selectPrinter(printer);
    final result = await _printerManager.printTicket(await _ticket(PaperSize.mm58));
  }
}