import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:charset_converter/charset_converter.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../GT_Masters/Masters_UI/cuWidgets.dart';
import '../appbarWidget.dart';
import '../models/userdata.dart';



class Testpage extends StatefulWidget {
  @override
  _TestpageState createState() => _TestpageState();
}
// List<PrinterBluetooth> _devices = [];
class _TestpageState extends State<Testpage> {
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
  dynamic password;
  late String token;
  dynamic total = 0;
  int slnum = 0;
  String dateNow = DateFormat("yyyy-MM-dd").format(DateTime.now());
  dynamic TotalAmt = 0.00;
  String PaymentName = ""; //for Add payment type name in heding
//----------------------------------

  // PrinterNetworkManager _printerManager = PrinterNetworkManager();
  var dataForTicket;
  var _devicesMsg = "";

  //-------------------------for notification------------------------
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  //-------------------------------------------------



  // flutter_printer _printerManager =flutter_printer();
  void initState() {
    setState(() {
      SharedPreferences.getInstance().then((value) {
        pref = value;
        read();
        if (Platform.isAndroid) {
          WebView.platform = SurfaceAndroidWebView();
        }
      });

      // Priter_Initial_Part();
      super.initState();
    });
    Timer(Duration(seconds: 2),() {
      setState(() {
        i=2;
      });
    });
  }

//------------------for appbar------------
  read() async {
    var v = pref.getString("userData");
    var c = json.decode(v!);
    user = UserData.fromJson(c); // token gets this code user.user["token"]
    setState(() {
      print(json.encode(user));
      branchId = int.parse(c["BranchId"]);
      token = user.user["token"];
      password = user.password;
      //  passes this user.user["token"]
      pref.setString("customerToken", user.user["token"]);
      branchName = user.branchName;
      userName = user.user["userName"];
      userId = user.user["userId"];

      print("branchName");
      print(branchName);
      print("userName");
      print(userName);
      print("userId");
      print(userId);
      print("userId");
      print(branchId);
    });
  }

  var num = 0;

  // test()  {
  //
  //
  //   // Timer(Duration(seconds: 1), () {
  //
  //     setState(() {
  //       num =  num + 1;
  //       print("tiu");
  //     });
  //   // }
  //   // );
  //
  //
  // }



  NotificationpayloadFun(){
    showDialog(
        context: context,
        builder: (c) => AlertDialog(
            content: Text(
                "Do you really want to logout?"),
           ));

  }



  int  i=1;
//-----------------------------------------------------All functions End---------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTertiaryTapCancel: (){       setState(() {
        print("tp");
        //print(a.toString());
      });
      }

      ,
      child: SafeArea(
          child: Scaffold(

              appBar: PreferredSize(
                  preferredSize: Size.fromHeight(160.0),
                  child:Appbarcustomwidget(branch: branchName,pref: pref,title:"Test",uname: userName,)
              ),

              body: ListView(shrinkWrap: true, physics: ScrollPhysics(), children: [
                //--------------------------------For Item Grp-----------------------------------------
                Row(children: [
                  SizedBox(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10),
                      child: GestureDetector(
                        onTap: () {
                         // print("uikuy");
                          setState(() {
                          //  print("Arabic print");
// UrlLaunch();
// wifiprinting();
                            GetdataPrint();

                          });
                        },
                        child: Text(
                          "print 1",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ),
                    ),
                  ),

                ]),

                SizedBox(
                  height: 50,
                  child: Padding(
                    padding:
                    const EdgeInsets.only(top: 10, left: 10, right: 70),
                    child: GestureDetector(
                      onTap: () {
                         // UrlLaunch();
                         // pdfcnv();
                        DynamicTblPrintData();
                      },
                      child: Text(
                        "print 2",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                    ),
                  ),
                ),
                // Container(height: 600, width: 60, child: _devices.isEmpty
                //     ? Center(child: Text(_devicesMsg ?? ''))
                //     : ListView.builder(
                //   itemCount: _devices.length,
                //   itemBuilder: (c, i) {
                //     return ListTile(
                //       leading: Icon(Icons.print),
                //       title: Text(_devices[i].name),
                //       subtitle: Text(_devices[i].address),
                //       onTap: () {
                //         // _startPrint(_devices[i]);
                //       },
                //     );
                //   },
                // ),),




                // FutureBuilder<Object>(
                //     future: test(),
                //     builder: (context, snapshot) {
                //       return Text(num.toString());
                //     }
                // ),


                Text("iopi"),


                DropdownButton(onTap: (){setState(() {

                });},
                  underline:Container(color: Colors.red),
                  icon:Center(child: Text(" fghfghfghh ▼",style: TextStyle(color: Colors.black),)),

                  items:[

                    DropdownMenuItem<String>(
                      value: "Tax Invoice",
                      child: Row(
                        children: [
                          Checkbox(
                            value: DefaltPage,
                            onChanged: (bool? value) {
                              setState(() {
                                DefaltPage = !DefaltPage;

                                print("GSTtyp $value");
                              });
                            },
                          ),
                          Text(
                            "Tax Invoice",
                          ),
                        ],
                      ),
                    ),

                    DropdownMenuItem<String>(
                      value: "Simplified Invoice",
                      child: Text(
                        "Simplified Invoice",
                      ),
                    ),


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
                      // dropdownValue = newValue;
                      // Pagetype(dropdownValue);
                      // if(dropdownValue== "2 Inch"){
                      //   Pg_2_Inch=true;
                      // }
                    });
                  },

                ),

              ]),
          )),
    );



  }


///----------------------------Number in word part----------------------------------------------------------
//   TextEditingController NumberController = new TextEditingController();
//
//   CUWidgets cw=CUWidgets();
//   NumberToWord numWrd = NumberToWord();
//
//   NumberInWordss(numer){
//
//     print("uiopuipui");
// var numver1=double.parse(numer);
//
// var test=5.0;
// print(test??0.toStringAsFixed(3));
//
//
//
//   var s= numver1.toString().split('.');
//   print(s.toString());
//
//     var num1=numWrd.convert( Locale.en_ind, int.parse(s[0].trim()));
//     var num2=numWrd.convert( Locale.en_ind, int.parse(s[1].trim()));
//
//
//     var FinaString="";
//     if(num1==""){
//       FinaString="$num2 halalas";
//     }
//     else if(num2==""){
//
//       FinaString= "$num1 riyals";
//
//     }else{
//
//       FinaString="$num1 riyals and $num2 halalas";
//
//     }
//
//
//
//     print(FinaString);
//
//   }
//   NumberInWords(numer){
//
//     var s= numWrd.NumberInRiyals(numer);
//     print("iopipi");
//     print(s);
//   }


///-------------------------------------------------------------------------------------


var DefaltPage=false;
  CUWidgets cw=CUWidgets();
var Detailspart=[];
  GetdataPrint() async {
    print("sales for print :");
    double amount = 0.0;
    try {
      var parsData={

        "crntStatus": 2,
        "dateFrom":  "2022-02-08",
        "godownId": 0
      };
      var jsonParse=json.encode(parsData);
      print(jsonParse);
      var jsonres = await cw.post(api:"GTStock/1", Token: token,body:jsonParse);
      if (jsonres != false) {
        var res = jsonDecode(jsonres);
        //  print("ItemList = $res");
        setState(() {
          var StockData = res["details"]["data"];
          print(StockData);

      dataForTicket = StockData;
          Detailspart=StockData;
        });
      }

     // Detailspart = dataForTicket['salesDetails'];
    }catch(e){}

  }



DynamicTblPrintData(){

 print("DynamicTblPrintData") ;
 // print(Detailspart) ;
 print(Detailspart.runtimeType) ;


var ss=[];
 dataForTicket[0].remove('Id');
  ss = dataForTicket;

  //ss.remove('Id');

print("ss");
 print(ss);

  List<List<dynamic>> listOfPurchases = [];
  for (int i = 0; i < ss.length; i++) {
    listOfPurchases.add(ss[i].values.toList());
  }

  print(listOfPurchases[0][0]);
 listOfPurchases.remove("${listOfPurchases[0][0]}");
  print("DataKey");
  print(listOfPurchases);
  print(listOfPurchases.runtimeType);
 return;
  List<List<dynamic>> mmm = [ss];
print(mmm.runtimeType);
print(mmm);
// purchasesAsMap = <Map<String, String>>[



}


//-------------------------for notification------------------------

  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    final InitializationSettings initializationSettings =
    InitializationSettings(
        initializationSettingsAndroid,initializationSettingsIOS
        );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  showNotification() async {
    print("showNotification");
    var android = AndroidNotificationDetails(
        'channel id',
        'channel NAME',
        'CHANNEL DESCRIPTION',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',icon: "ic_launcher",

style: AndroidNotificationStyle.bigText,
        largeIcon: 'ic_launcher',
        largeIconBitmapSource: BitmapSource.Drawable,
       // vibrationPattern: vibrationPattern,
        color: const Color.fromARGB(255, 255, 0, 0));

    var ios = IOSNotificationDetails();
    var platform = NotificationDetails(android: android, iOS: ios);
    await flutterLocalNotificationsPlugin.show(0, "New Notification", " fghfhfghfhfgdfdsgsggdfgdhdhdhhfghfhfghfghfghfhgfI'm notification",
        platform, payload:"uiii");
   }

  Future selectNotification(String payload) async {
    //
    print("Handle notification tapped logic here");
  }





  //---------------------------printer part-----------------------------------
// var arabicext="اختبارات";
  PrinterNetworkManager _printerManager = PrinterNetworkManager();

    wifiprinting() async {
    // try {
      print(" print in");
     // _printerManager.selectPrinter('192.168.0.100');
     _printerManager.selectPrinter(null);
      final res =
      await _printerManager.printTicket(await _ticket(PaperSize.mm80));
      print(" print in");
    // } catch (e) {
    //   print("error on print $e");
    // }
  }

    var title5 = utf8.encode('فاتورة ضريبية');

  Future<Ticket> _ticket(PaperSize paper) async {
    //final profile = await CapabilityProfile.load();
    final ticket = Ticket(paper);
    print('in');
    ticket.text("-----------");

    // Uint8List encoded =
    // await CharsetConverter.encode('ISO-8859-6', "فاتورة ضريبة فاتورة ضريبة فاتورة ضريبة"); //
    //
    // ticket.textEncoded(encoded,
    //     styles: PosStyles(codeTable:PosCodeTable.arabic));
    //
    // Uint8List encoded2 =
    // await CharsetConverter.encode('cp864', 'مابيقرا شي وهو بيستخدم');
    //
    // ticket.textEncoded(encoded2,
    //     styles: PosStyles(codeTable:PosCodeTable.pc1001_1) );
    //
    // ticket.textEncoded(encoded2,
    //     styles: PosStyles(align: PosAlign.right,width: PosTextSize.size1 ) );

     Uint8List title = await CharsetConverter.encode('ISO-8859-6', "فاتورة ضريبية");
    ticket.textEncoded(title,styles:  PosStyles(codeTable:PosCodeTable.arabic) );
    ticket.textEncoded(title,styles:  PosStyles(codeTable:PosCodeTable.pc864_2) );
    ticket.textEncoded(title,styles:  PosStyles(codeTable:PosCodeTable.pc1001_2) );
    ticket.textEncoded(title,styles:  PosStyles(codeTable:PosCodeTable.wp1256) );
    ticket.textEncoded(title,styles:  PosStyles(codeTable:PosCodeTable.pc720) );
    ticket.textEncoded(title,styles:  PosStyles(codeTable:PosCodeTable.pc850) );
    ticket.textEncoded(title,styles:  PosStyles(codeTable:PosCodeTable.pc858_2) );


    // ticket.textEncoded(title,styles:  PosStyles(codeTable:PosCodeTable(22)) );
    // ticket.textEncoded(title,styles:  PosStyles(codeTable:PosCodeTable(63)) );
    // ticket.textEncoded(title,styles:  PosStyles(codeTable:PosCodeTable(82)) );
    // ticket.textEncoded(title,styles:  PosStyles(codeTable:PosCodeTable(92)) );
    // ticket.textEncoded(title,styles:  PosStyles(codeTable:PosCodeTable(93)) );
   // ticket.textEncoded(title);
   //  ticket.hr();
   //  ticket.textEncoded(encoded2,styles:  PosStyles(codeTable:PosCodeTable(22)) );
   //  ticket.textEncoded(encoded2,styles:  PosStyles(codeTable:PosCodeTable(63)) );
   //  ticket.textEncoded(encoded2,styles:  PosStyles(codeTable:PosCodeTable(82)) );
   //  ticket.textEncoded(encoded2,styles:  PosStyles(codeTable:PosCodeTable(92)) );
   //  ticket.textEncoded(encoded2,styles:  PosStyles(codeTable:PosCodeTable(93)) );
    //ticket.textEncoded(encoded2);
    // ticket.text(title);
    // ticket.hr();
    // ticket.textEncoded(title5,styles:  PosStyles(codeTable:PosCodeTable(22)) );
    // ticket.textEncoded(title5,styles:  PosStyles(codeTable:PosCodeTable(63)) );
    // ticket.textEncoded(title5,styles:  PosStyles(codeTable:PosCodeTable(82)) );
    // ticket.textEncoded(title5,styles:  PosStyles(codeTable:PosCodeTable(92)) );
    // ticket.textEncoded(title5,styles:  PosStyles(codeTable:PosCodeTable(93)) );
    // print(title.toString());
// var s=await CharsetConverter.decode('UTF-8',title);
// print(s.toString());

// ticket.hr();
    // Uint8List title2 = await CharsetConverter.encode('windows-1256', "فاتورة ضريبة فاتورة ضريبة فاتورة ضريبة");
    // ticket.textEncoded(title2,styles:  PosStyles(codeTable:PosCodeTable.arabic) );
    // ticket.textEncoded(title2,styles:  PosStyles(codeTable:PosCodeTable.pc864_2) );
    // ticket.textEncoded(title2,styles:  PosStyles(codeTable:PosCodeTable.pc1001_2) );
    // ticket.textEncoded(title2,styles:  PosStyles(codeTable:PosCodeTable.wp1256) );
    // ticket.textEncoded(title2,styles:  PosStyles(codeTable:PosCodeTable.pc720) );

    //
    // var w=await CharsetConverter.decode('ISO-8859-3',title2);
    // print(w.toString());

    //  Uint8List encArabic = await CharsetConverter.encode("windows-1256",arabicext);
    // ticket.textEncoded(encArabic,
    //     styles: PosStyles(codeTable: PosCodeTable.arabic));
    //
    // Uint8List ncArabic = await CharsetConverter.encode("windows-1256",arabicext);
    // ticket.textEncoded(ncArabic,
    //     styles: PosStyles(codeTable: PosCodeTable.pc864_1));
    //

    // ticket.textEncoded(ncArabic,styles: PosStyles(codeTable: PosCodeTable.pc1001_1));
    // ticket.textEncoded(ncArabic,styles: PosStyles(codeTable: PosCodeTable.pc1001_1));
    // ticket.textEncoded(ncArabic,styles: PosStyles(codeTable: PosCodeTable.wp1256));

   // ticket.text(arabicext,styles:PosStyles(codeTable:PosCodeTable.arabic));
    // ticket.feed(1);
    // ticket.text('Thank You...Visit again !!',
    //     styles: PosStyles(align: PosAlign.center, bold: true));

    ticket.cut();
    return ticket;
  }





  //----------------------pdf printer------------------------


  pdfcnv()async {
    try {

      final doc = pw.Document();
      final font = await rootBundle.load("assets/arial.ttf");
      final ttf = pw.Font.ttf(font);

      doc.addPage(pw.Page(
          pageFormat: PdfPageFormat.roll57,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Text('dfdf',style: pw.TextStyle(font:ttf )),
            ); // Center
          }));


      final Directory? directory = await getExternalStorageDirectory();
      //final output = await getTemporaryDirectory();
      print("directory.path");
      print((directory?.path).toString());
     final file = File('${directory?.path}/example.pdf');
     // final file = File('sdk_gphone_x86_arm/DCIM/example.pdf');


      //await file.writeAsBytes(await pdf.save());
      await file.writeAsBytesSync(await doc.save());
      file.open();
    //   new File('${directory.path}/example.pdf').readAsString().then((String contents) {
    //     print(contents);
    // });
          }
    catch(e){print("error in pdfcnv $e");}

  }



  // pdfprinr() async {
  //   final Directory directory = await getExternalStorageDirectory();
  //   final pdf = await rootBundle.load('${directory.path}/example.pdf');
  //   await Printing.layoutPdf(onLayout: (_) => pdf.buffer.asUint8List());
  // }
  // Future<void> _startPrint( printer) async {
  //   _printerManager.selectPrinter(printer);
  //   final result = await _printerManager.printTicket(await _ticket(PaperSize.mm80));
  //   showDialog(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       content: Text(result.msg),
  //     ),
  //   );
  // }



  // String _url = 'http://gterpdemo.qizo.in';
  //String _url ='http://gterpdemo.qizo.in/GtMoblieSalesPrint?Sid=1&uBr=9&uNm=admin&uP=admin';
UrlLaunch()async{
var  _url ='http://gterpdemo.qizo.in/#/GtMoblieSalesPrint?Sid=1&uBr=$branchId&uNm=$userName&uP=admin';
if (!await launch(_url)) throw 'Could not launch $_url';

}

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
Widget PrintWebView() {
    return
  WebView(
    initialUrl: 'http://gterpdemo.qizo.in/#/GtMoblieSalesPrint?Sid=1&uBr=$branchId&uNm=$userName&uP=admin',
    // onWebViewCreated: (WebViewController webViewController) {
    //   _controller.complete(webViewController);
    // },
    // onProgress: (int progress) {
    //   print('WebView is loading (progress : $progress%)');
    // },
    javascriptChannels: <JavascriptChannel>{
      _toasterJavascriptChannel(context),
    },
    navigationDelegate: (NavigationRequest request) {
      if (request.url.startsWith('http://gterpdemo.qizo.in/#/GtMoblieSalesPrint?Sid=1&uBr=$branchId&uNm=$userName&uP=admin')) {
        print('blocking navigation to $request}');
        return NavigationDecision.prevent;
      }
      print('allowing navigation to $request');
      return NavigationDecision.navigate;
    },
    onPageStarted: (String url) {
      print('Page started loading: $url');
    },
    onPageFinished: (String url) {
      print('Page finished loading: $url');
    },
    gestureNavigationEnabled: true,
  );


}

}










