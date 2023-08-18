import 'dart:convert';
import 'dart:io';
import 'package:android_intent/android_intent.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:math' show cos, sqrt, asin;
// import 'package:location/location.dart' as loc;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_qizo_gt/receiptcollection_Direct.dart';
import 'package:new_qizo_gt/receiptcollectionindex_Direct.dart';
import 'package:new_qizo_gt/sales.dart';
import 'package:new_qizo_gt/salesindex.dart';
import 'package:new_qizo_gt/salesmanhome.dart';
import 'package:new_qizo_gt/salesorder.dart';
import 'package:new_qizo_gt/salesorderindexpage.dart';
import 'package:new_qizo_gt/salesreturn.dart';
import 'package:new_qizo_gt/shopvisited.dart';
import 'package:new_qizo_gt/urlEnvironment/urlEnvironment.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'AQizo_RMS/RMS_HomePage.dart';
import 'CustomerDetails.dart';
import 'GT_Masters/AppTheam.dart';
import 'PaymentVoucherIndex_Direct.dart';
import 'PaymentVoucher_Direct.dart';
import 'Purchase.dart';
import 'Purchase_Index.dart';
import 'Testing/Testpage.dart';
import 'appbarWidget.dart';
import 'ledgerBalanceCreate.dart';
import 'models/customersearch.dart';
import 'models/shopvisitswithdate.dart';
import 'models/userdata.dart';
import 'newtestpage.dart';

class CustomerVisited extends StatefulWidget {
  // final a;
  // dynamic b;
  // CustomerVisited({this.a,this.b});

  @override
  _CustomerVisitedState createState() => _CustomerVisitedState();
}

class _CustomerVisitedState extends State<CustomerVisited> {
  final PermissionHandler permissionHandler = PermissionHandler();
  // Map<PermissionGroup, loc.PermissionStatus> permissions;
  dynamic longitude;
  dynamic latitude;

  late SharedPreferences pref;
  late bool regSelect;
  dynamic user;
  dynamic serverDate;
  TextEditingController generalRemarksController = new TextEditingController();
  TextEditingController RemarksTxtController = new TextEditingController();

  dynamic branchName;
  dynamic userName;
  dynamic userArray;
  late double totalDistance;
  dynamic location;
  List<ShopVisitsDate> visitShop = [];
  bool inSelect = true;
  bool outSelect = true;
  static List<Customer> users =[];
  TextEditingController customerController = new TextEditingController();
  TextEditingController dateController = new TextEditingController();
  bool customerSelect = false;
  dynamic salesLedgerId = 0;
  dynamic VisitInId = 0;

  // final oCcy = new NumberFormat("#,##0.00", "en_US");
  var formatter = NumberFormat('#,##,000.00');
  dynamic openingAmountBalance = 0.0;
  dynamic textTitle = "Ledger Balance ";
  dynamic textTitle2 = "";

  // dynamic passvalue;
  dynamic custValue;
  List<dynamic> dt = [];

  dynamic routjson = [];

  dynamic lgrBlns;
  dynamic rmrks;
  late bool rmrk;
  dynamic AppTyp;
  // ---------?----
  dynamic strval = "";

  dynamic tagsJson = [];
  dynamic lgramt = "nill";
  late bool visiblestate;
  dynamic ShopVst = "nill";
  dynamic SalsOrd = "nill";
  dynamic RcptCll = "nill";
  dynamic SlRtn = "nill";
  dynamic LgrTyp = "nill";

  // ---------------

  bool showProgress = true;
  List<dynamic> SlsRD = [];
  List<dynamic> Rcpt = [];
  List<dynamic> SOD = [];
  List<dynamic> SlsH = [];
  List<dynamic> SlsHD = [];
  List<dynamic> SlsRtnH = [];

  TextEditingController ControllerdateF = new TextEditingController();
  TextEditingController ControllerdateT = new TextEditingController();
  dynamic dateFrom;
  dynamic dateTO = DateTime.now();
AppTheam theam=AppTheam();
  @override
  void initState() {
    // TODO: implement initState
    internet_check();

    SharedPreferences.getInstance().then((value) {
      pref = value;
      print('${Env.baseUrl}');
      read();
      _getLocation();
      getCustomer();
      getLedger(null, null);
      //  Refresh();
    });

    ControllerdateT.text = DateFormat("MM-dd-yyyy").format(dateTO);
    ControllerdateF.text = DateFormat("MM-01-yyyy").format(dateTO);
    // print("ins null widget.retval : a "+widget.a.toString());
    // print("ins null widget.retval : b "+widget.b.toString());
    //
    // if(widget.a == null||widget.a == 0) {
    //   print("ins null widget.retval"+widget.a.toString());
    //   getLedger(null,null);
    // }else
    // {
    //   print("ins widget.b"+widget.b.toString());
    //   setState(() {
    //    dynamic tst=widget.b;
    //     customerController.text =tst;
    //     salesLedgerId = widget.a;
    //     getLedger(widget.a,null);
    //   });
    //
    // }

    //  getLedger(null, null);

    super.initState();
    customerController.addListener(customerLedgerIdListener);
  }

//get current location
  _getLocation() async {
    print("_getLocation");

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      print(permission);

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      debugPrint('location: ${position.latitude}');
      print("latitude :");
      print(position.latitude);
      longitude = position.longitude;
      latitude = position.latitude;

      double totalDistance = calculateDistance(position.latitude, position.longitude, position.latitude, position.longitude);

      print("total Distance : " + totalDistance.toString());

      List<Placemark> placeMark = await placemarkFromCoordinates(latitude, longitude); // Use this line instead of using Geolocator().placemarkFromCoordinates
      print(placeMark[0].locality);
      // ... [rest of your code remains unchanged]

    } catch (e) {
      print("exception : " + e.toString());
    }
  }


  // calculate distance
  double calculateDistance(lat1, lon1, lat2, lon2) {
    print("calculateDistance");
    var p = 0.017453292519943295;
    var c = cos;
    print("IN calculateDistance");

    print("lat1$lat1");
    print("lon1$lon1");
    print("lat2$lat2");
    print("lon2$lon2");

    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;

    print("out calculateDistance");
    return 12742 * asin(sqrt(a));
  }

  //get token
  read() async {
    print("read");
//    SharedPreferences pref = await SharedPreferences.getInstance();
    var v = pref.getString("userData");
    print("USER DATA: $v");
    var c = json.decode(v!);
    user = UserData.fromJson(
        c); // token gets this code user.user["token"] okk??? user res

    setState(() {
      print("user data................");
      print(user.user["token"]);
      pref.setString("customerToken", user.user["token"]);
      branchName = user.branchName;
      userName = user.user["userName"];
      print(".....");
      print(branchName);
      print(userName);
      regSelect = false;
      AppTyp=user.appType;

    });
//    getCustomer();
//    showDialog(
//        context: context,
//        builder: (context) => AlertDialog(
//              title: Text("data:   " + user.branchName),
//              content: Text("user data:   " + user.user["token"]),
//            ));
  }

// get customer account
  getCustomer() async {
    print("getCustomer");
    getServerDate();

    try {
      // http://testcoreapi.qizo.in:809/api/
      final response =
          await http.get("${Env.baseUrl}${Env.CustomerURL}" as Uri, headers: {
        "Authorization": user.user["token"],
      });
      print("238 =" + (response.statusCode).toString());

      if (response.statusCode == 200) {
        print('...................');
        Map<String, dynamic> data = json.decode(response.body);
        print("array is");
        print(data["lst"]); //used  this to autocomplete
        print("........");
        print(response.body);
        print(response.statusCode);
        print("248 =" + (response.statusCode).toString());
        print(data["lst"]);
        userArray = data["lst"];
        users = (data["lst"] as List)
            .map<Customer>((customer) =>
                Customer.fromJson(Map<String, dynamic>.from(customer)))
            .toList();
        print(users[0]);
//        users=loadUsers(s.toString());
        // s must be string or json  that will works it the loading will false okk??????  mustneed a function that will return to users okk??
//        users=loadUsers(s.toString());// s  to convert json ,now s is not in json okkk??
//        setState(() {
//          loading = false;
//        });
      } else {
        print("Error getting");
      }
    } catch (e) {
      print("Error getting user");
    }
  }

  // current customer registered or not
  getCustomerRegistered(dynamic ledgerId) async {
    print("getCustomerRegistered");

    //  print( "http://erptestapi.qizo.in:811/api/RelMcustLedgerLocations/${ledgerId}/1");

    var res = await http.get(
        "${Env.baseUrl}RelMcustLedgerLocations/${ledgerId.toString()}/1" as Uri,
        headers: {'Authorization': user.user['token']});

    print("226-reg");
    print(ledgerId);
    print(res.statusCode);
    print(res.body);
    setState(() {
      if (res.statusCode == 200 || res.statusCode == 201) {
        var r = json.decode(res.body);
        print("........");
        print(r['custRegisterDetails'][0]['cllLatitude']);
        print(r['custRegisterDetails'][0]['cllLongitude']);
        print(r['custRegisterDetails'][0]['cllLocation']);
        var lo = double.parse(r['custRegisterDetails'][0]['cllLongitude']);
        var la = double.parse(r['custRegisterDetails'][0]['cllLatitude']);
        //  print("EERRor la"+latitude);
        // print("EERRor la"+longitude);

        // print("EERRor la$la");

        totalDistance = calculateDistance(la, lo, latitude, longitude);
        print("........     user");
        print("Location Distance : " + totalDistance.toString());

        print("246........     user");
        print(r['visitDetails'].length);
        setState(() {
          List<dynamic> t = r['visitDetails'];
          print(t);
          visitShop = [];
          visitShop = t.map((t) => ShopVisitsDate.fromJson(t)).toList();
        });
        setState(() {
          if (r['visitDetails'].length > 0) {
            print("256.....data...");
            print(visitShop[0].tvhDateIn);
            print(visitShop[0].tvhDateOut);
            var c = DateFormat.EEEE().format(DateTime.now());
            print(c);
            var v = DateFormat.EEEE().format(DateTime.now());
            print(v);

            var formatter =
                new DateFormat('MM-dd-yyyy'); // this dd-MM-yyyy format i want

            String formattedDate = formatter
                .format(DateTime.parse(visitShop[0].tvhDate.substring(0, 10)));
            print(formattedDate);
            dateController.text =
                'Date On : ${formattedDate.toString()} - ${c.toString()}';
            print("272.....data...");
            // if (r['visitDetails'].length % 2 == 0) {
            if (r['visitDetails'][r['visitDetails'].length - 1]['tvhDateOut'] ==
                    null ||
                r['visitDetails'][r['visitDetails'].length - 1]['tvhDateOut'] ==
                    "") {
              print("278 hi.. even");
              print(
                  r['visitDetails'][r['visitDetails'].length - 1]['tvhDateIn']);
              outSelect = false;
              inSelect = true;
            } else {
              print("data is odd ");
              outSelect = true;
              inSelect = false;
            }
          } else {
            outSelect = true;
            inSelect = false;
            print("no result List");
          }
        });
      } else {
        regSelect = true;
      }
    });
  }

  // Register  listener
  customerLedgerIdListener() {
    print("customerLedgerIdListener");

    setState(() {
      print("listener");
      // inSelect = true;
      // outSelect = true;
      regSelect = false;
      // visitShop = [];

      if (salesLedgerId == 0) {
        visitShop = [];

        regSelect = false;
        clear();
      }
    });
  }

  //get current server date
  getServerDate() async {
    print("getServerDate");

    try {
      final response = await http.get("${Env.baseUrl}getsettings" as Uri,
          headers: {"accept": "application/json"});
      print(response.statusCode);
      print("387 =" + (response.statusCode).toString());

      setState(() {
        if (response.statusCode == 200) {
          print('327...................');

          print(response.body);

          List<dynamic> list = json.decode(response.body);
          print(list[0]["workingDate"] +
              "....................." +
              list[0]["workingTime"]);
          serverDate = list[0]["workingDate"];
          var formatter =
              new DateFormat('MM-dd-yyyy'); // this dd-MM-yyyy format i want

          String formattedDate = formatter
              .format(DateTime.parse(list[0]["workingDate"].substring(0, 10)));
          print("formattedDate : " + formattedDate);
        } else {
          print("Error getting users");
        }
      });
    } catch (e) {
      print("Error getting users" + e.toString());
    }
  }

  // register new customer
  customerRegisterNow() async {
    print("customerRegisterNow");
    if (latitude == null ||
        longitude == null ||
        latitude == 0.0 ||
        longitude == 0.0) {
      print("hi");
      AlertDialog(
        title: Text(
          "Can't get current location",
          style: TextStyle(color: Colors.red),
        ),
        content: const Text('Please make sure you enable GPS and try again'),
        actions: <Widget>[
          TextButton(
              child: Text('Activate GPS'),
              onPressed: () {
                final AndroidIntent intent = AndroidIntent(
                    action: 'android.settings.LOCATION_SOURCE_SETTINGS');
                intent.launch();
                Navigator.of(context, rootNavigator: true).pop();
                // _gpsService();
              })
        ],
      );
      return;
    }
    print("func");
    var req = {
      "cllLedgerId": salesLedgerId,
      "cllLatitude": latitude.toString(),
      "cllLongitude": longitude.toString(),
      "cllLocation": location.toString(),
      "cllRemarks": generalRemarksController.text
    };
    var params = json.encode(req);
    print(params);
    print("${Env.baseUrl}RelMcustLedgerLocations");
    var res = await http.post("${Env.baseUrl}RelMcustLedgerLocations" as Uri,
        headers: {
          'accept': 'application/json',
          'content-type': 'application/json',
          'Authorization': user.user['token'],
          'deviceId': user.deviceId
        },
        body: params);
    print(res.statusCode);
    print(res.body);
    var u = json.decode(res.body);
    print(u['cllLedgerId'].round());
    setState(() {
      if (res.statusCode == 200 || res.statusCode == 201) {
        regSelect = false;
        generalRemarksController.text = "";
        var b = u['cllLedgerId'].round();
        getCustomerRegistered(b);
      }
    });
  }

  // registered customer in
  regCustomerIn() async {
    print("regCustomerIn");

    setState(() {
      getServerDate();
    });
    // setState(() {
    //   if (inSelect == true) {
    //     outSelect = false;
    //     return;
    //   }
    // });
    // http://erptestapi.qizo.in:811/api/TcustomerVisitHistories
    print("func");
    /*Rajesh commented..............................................................................
    if (totalDistance > 1.0) {
      print("Location distance to large");
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "Your current location is not matching with Selected Customer",
              style: TextStyle(color: Colors.red),
            ),
          ));
      return;
    }*/
    var req = {
      "tvhCustId": salesLedgerId,
      "tvhLatitudeIn": latitude.toString(),
      "tvhLongitudeIn": longitude.toString(),
      "tvhLocationIn": location.toString(),
      "tvhDateIn": serverDate,
      "tvhLatitudeOut": null,
      "tvhLongitudeOut": null,
      "tvhLocationOut": null,
      "tvhDateOut": null
    };
    var params = json.encode(req);
    print(req['tvhDateIn']);

    print("${Env.baseUrl}TcustomerVisitHistories");
    // return;

    var res = await http.post("${Env.baseUrl}TcustomerVisitHistories" as Uri,
        headers: {
          'accept': 'application/json',
          'content-type': 'application/json',
          'Authorization': user.user['token']
        },
        body: params);
    setState(() {
      print(res.statusCode);
      print(res.body);
      var u = json.decode(res.body);
      print(u['tvhCustId'].round());
      // setState(() {
      //   if (res.statusCode == 200 || res.statusCode == 201) {
      //     regSelect = false;
      //
      //   }
      // });
      if (res.statusCode == 200 || res.statusCode == 201) {
        inSelect = false;
        var b = u['tvhCustId'].round();
        print("476data..............");
        print(u);
        VisitInId = 0;
        VisitInId = u['id'];
        print("480 data..............");

        getCustomerRegistered(b);
      }
    });
  }

// --------------------Net Connection Checking-------------------------------------------------------
  internet_check() async {
    var i;
    var result = await (Connectivity().checkConnectivity());
    {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        // var i=true;
        // iptestfun();
        return true;
      } else if (result == ConnectivityResult.none) {
        // print("Net not Connected");
        // i=false;
        showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('No Internet Connection !'),
            content: new Text('Check Internet Connection...'),
          ),
        );
        return false;
      }
    }
  }

  // iptestfun() async{
  //   dynamic wifi =await (Connectivity().getWifiBSSID());
  //   print("476data......$wifi........");
  //
  // }
//-------------------------------------------------------------------------------------------------------

  // registered customer out
  regCustomerOut() async {
    print("regCustomerOut.");

//     if (totalDistance > 0.2) {
//       print("distance to large");
//       showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: Text(
//               "Your current location is not matching with Selected Customer",
//               style: TextStyle(color: Colors.red),
//             ),
// //              content: Text("user data:   " + user.user["token"]),
//           ));
//       return;
//     }
    setState(() {
      if (inSelect == false) {
        outSelect = true;
        return;
      }
    });
    // http://erptestapi.qizo.in:811/api/TcustomerVisitHistories
    print("509-func");
    getServerDate();

    var date = serverDate;
    //VisitInId =0;
    //VisitInId = u['id'];
    print("513-................");
    var req = {
      "id": VisitInId,
      "tvhCustId": salesLedgerId,
      "tvhLatitudeIn": null,
      "tvhLongitudeIn": null,
      "tvhLocationIn": null,
      "tvhDateIn": null,
      "tvhLatitudeOut": latitude.toString(),
      "tvhLongitudeOut": longitude.toString(),
      "tvhLocationOut": location.toString(),
      "tvhDateOut": date
    };
    print("526-................");
    var params = json.encode(req);
    print(params);
    print("529-................");
    print("${Env.baseUrl}TcustomerVisitHistories/${VisitInId.toString()}/1");
    var res = await http.put(
        "${Env.baseUrl}TcustomerVisitHistories/${VisitInId.toString()}/1/1" as Uri,
        headers: {
          'accept': 'application/json',
          'content-type': 'application/json',
          'Authorization': user.user['token'],
          'deviceId': user.deviceId
        },
        body: params);
    print("539-................");
    print(res.statusCode);
    print("541-................");
    // print(res.body);
    // var u = json.decode(res.body);
    // print(u);
    // print(u['tvhCustId'].round());
    setState(() {
      if (res.statusCode == 200 ||
          res.statusCode == 201 ||
          res.statusCode == 204) {
        print("548-................");
        print(res.body);
        // visitShop.indexWhere((e)=>e.)
        inSelect = true;
        // var b = u['tvhCustId'].round();
        print("553-................");
        getCustomerRegistered(salesLedgerId);
        print("555-................");
      }
    });
  }

  getItemIndex(item) {
    int index = visitShop.indexOf(item);
    print(index);
    return index + 1;
  }

  getTime(dynamic date) {
    // var formatter =
    // new DateFormat('HH:mm');
    // String formattedDate = formatter
    //     .format(DateTime.parse(date));
    if (date == null) {
      return "       -     ";
    } else {
      var formattedDate = DateFormat.jm().format(DateTime.parse(date));

      // print(formattedDate);
      return formattedDate;
    }
  }

  //get customer ledger balance
  getCustomerLedgerBalance(int accountId) async {
    print("getCustomerLedgerBalance");
    salesLedgerId = accountId;
    try {
      final response = await http.get("${Env.baseUrl}getsettings" as Uri,
          headers: {"accept": "application/json"});
      print(response.statusCode);
      print("670 =" + (response.statusCode).toString());

      if (response.statusCode == 200) {
        print('...................');

        print(response.body);

        List<dynamic> list = json.decode(response.body);
        print(list[0]["workingDate"] +
            "....................." +
            list[0]["workingTime"]);
        setState(() {
          serverDate = list[0]["workingDate"];
        });
        var formatter =
            new DateFormat('MM-dd-yyyy'); // this dd-MM-yyyy format i want

        String formattedDate = formatter
            .format(DateTime.parse(list[0]["workingDate"].substring(0, 10)));
        print("----formattedDate------" + formattedDate);
// if(accountId==null)
// {
        getLedger(accountId, formattedDate);
//
//
// }
// else{
//   namefunction(accountId, formattedDate);
//      }

      } else {
        print("Error getting users");
      }
    } catch (e) {
      print("Error getting users" + e.toString());
    }
    print("customer Id is");
    print(accountId);
  }

// --------------------current balance-------------------------------------------------------

  //
  // getLedgers(dynamic acId, dynamic date) async {
  //   print(acId);
  //   print("the given date is");
  //   print(date);
  //   var url = "${Env.baseUrl}TaccLedgers/$acId/$date";
  //   print("url:" + url);
  //   try {
  //     final response = await http.get(url, headers: {
  //       "Authorization": user.user["token"],
  //     });
  //     print(response.statusCode);
  //     if (response.statusCode == 200) {
  //       print(response.body);
  //       var e = json.decode(response.body);
  //       print(e["openingAmount"]);
  //       setState(() {
  //         if (e["openingAmount"] > 0.0) {
  //           openingAmountBalance = e["openingAmount"];
  //         } else {
  //           print("opening amount is zero");
  //         }
  //       });
  //     }
  //   } catch (e) {
  //     print("error" + e);
  //   }
  //
  //   namefunction(openingAmountBalance);
  // }
  //

// ---------------------------------New Fn---------------------------------------------------

  getLedger(dynamic acId, dynamic date) async {
    print("dddd : " + acId.toString());

    // if(acId==null||acId==0) {
    print("..........getLedger.....in null........");
    dynamic dtfrm;
    dynamic dtto = DateFormat("MM-dd-yyyy").format(dateTO);

    if (dateFrom == null) {
      dtfrm = DateFormat("MM-01-yyyy").format(dateTO);
    } else {
      dtfrm = DateFormat("MM-dd-yyyy").format(dateFrom);
    }

    // print("----------Daate from out -----------------------------$dtfrm");
    // print("---------date to-out ---------- ----------------------$dtto");

    //  var url = "${Env.baseUrl}TcustomerVisitHistories/$acId/1/1";
    // print("url:" + url);

    //api/api-----rptSalesmanCustomerHistoy-----
    final url = "${Env.baseUrl}rptSalesmanCustomerHistory";
    print("url==$url");
    var req = {"dtFrom": dtfrm, "dtTo": dtto, "ledgerId": acId};
    print("req==  $req");

    var params = json.encode(req);
    print("Json==  $params");
    var res = await http.post(url as Uri,
        headers: {
          'accept': 'application/json',
          'content-type': 'application/json',
          'Authorization': user.user["token"],
          'deviceId': user.deviceId
        },
        body: params);

    print(res.statusCode);
    if (res.statusCode == 200 || res.statusCode == 201 && salesLedgerId > 0) {
      //  print("ord data=" + res.body);
      var tagsJso = jsonDecode(res.body);

      print("result data is : $tagsJso");

      setState(() {
        tagsJson = tagsJso;

        if ((tagsJson['ledgerBalance']) == 0.0 ||
            (tagsJson['ledgerBalance']) == Null) {
          lgramt = "nill";
        } else {
          lgramt = (formatter.format(tagsJson['ledgerBalance']));
        }

        if ((tagsJson['totalSalesReturn']) == 0.0 ||
            (tagsJson['totalSalesReturn']) == Null) {
          SlRtn = "nill";
        } else {
          SlRtn = (formatter.format(tagsJson['totalSalesReturn'])).toString();
        }

        if ((tagsJson['totalReceiptCollection']) == 0.0 ||
            (tagsJson['totalReceiptCollection']) == Null) {
          RcptCll = "nill";
        } else {
          RcptCll =
              (formatter.format(tagsJson['totalReceiptCollection'])).toString();
        }

        if ((tagsJson['totalSalesOrder']) == 0.0 ||
            (tagsJson['totalSalesOrder']) == Null) {
          SalsOrd = "nill";
        } else {
          SalsOrd = (formatter.format(tagsJson['totalSalesOrder'])).toString();
        }

        if ((tagsJson['totalShopVisited']) == "" ||
            (tagsJson['totalShopVisited']) == Null) {
          ShopVst = "nill";
        } else {
          ShopVst = tagsJson['totalShopVisited'].toString();
        }

        if ((tagsJson['customerRemarks']) == "" ||
            (tagsJson['customerRemarks']) == null ||
            (tagsJson['customerRemarks']) == "null") {
          textTitle2 = "nill";
          rmrk = false;
        } else {
          RemarksTxtController.text = tagsJson['customerRemarks'].toString();
          rmrk = true;
        }

        LgrTyp = tagsJson['ledgerBalanceType'].toString();
        visiblestate = true;
        showProgress = false;

        //routjson=req;
      });

      print("----------------ledgerBalance------------------------------- " +
          lgramt.toString());
    } else {
      print('error ocure');
    }
    print("______out  function__null___");
    routjson = req;
  }

  // ---------------------------------New-Fn------------------------------------------

  // dynamic namefunction(dynamic acId, dynamic date){
  //   strval="Last";
  //  visiblestate=true;
  //
  //   print("namefunction$lbname");
  //   textTitle =lbname;
  // textTitle = "Current Balance:  " +lbname;

  // if(lbname2=="null"){
  //   print("in");
  //   rmrk=false;
  //   textTitle2 ="";
  // }else{
  //   rmrk=true;
  //   textTitle2 ="Remarks : ${lbname2.toString()}}";
  //
  // }

  //toStringAsFixed(2);

  //  }

  clear() {
    print("in clear function");
    customerController.text = "";
    salesLedgerId = 0;
    inSelect = true;
    outSelect = true;
    openingAmountBalance = 0;

    textTitle = "Ledger Balance ";

    salesLedgerId = null;
    custValue = null;
    visiblestate = false;

    lgramt = "nill";
    ShopVst = "nill";
    SalsOrd = "nill";
    RcptCll = "nill";
    SlRtn = "nill";
    LgrTyp = "nill";
    routjson = {
      "dtFrom": DateFormat("MM-01-yyyy").format(dateTO),
      "dtTo": DateFormat("MM-dd-yyyy").format(dateTO),
      "ledgerId": null
    };
  }

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      Refresh();
    });
    return null;
  }

  // ------------------------All Function End--------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(190.0),
          child:Appbarcustomwidget(uname: userName, branch: branchName, pref: pref, title: "INDEX")
        ),


        body: RefreshIndicator(
          key: refreshKey,
          child: ListView(shrinkWrap: true,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(children: [
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                            style: TextStyle(),
                            controller: customerController,
                            decoration: InputDecoration(
                              errorStyle: TextStyle(color: Colors.red),
                              errorText: customerSelect
                                  ? "Please Select Customer ?"
                                  : null,
                              suffixIcon: IconButton(
                                icon: Icon(Icons.remove_circle),
                                color: Colors.blue,
                                onPressed: () {
                                  clear();
                                  // print("cleared");
                                },
                              ),
                              isDense: true,
                              contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14.0)),
                              labelText: 'customer search',
                            )),
                        suggestionsBoxDecoration:
                        SuggestionsBoxDecoration(elevation: 90.0),
                        suggestionsCallback: (pattern) {
                          //return users.where((user) =>
                          //  user.lhName.contains(pattern.toUpperCase()));
                          return users.where((user) => user.lhName
                              .toUpperCase()
                              .contains(pattern.toUpperCase()));
                        },
                        itemBuilder: (context, suggestion) {
                          return Card(
                            color: Colors.white,
                            // shadowColor: Colors.blue,
                            child: ListTile(
                              tileColor:theam.DropDownClr,
                              // focusColor: Colors.blue,
                              // hoverColor: Colors.red,
                              title: Text(
                                suggestion.lhName,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          print(suggestion.lhName);
                          print("selected");
                          print(suggestion);

                          // print("close.... $salesLedgerId");
                          salesLedgerId = 0;

                          print(suggestion.id);
                          print("738-.......sales Ledger id");
                          print(suggestion.id);
                          print("740-.......sales Ledger id");
                          print(customerSelect);
                          salesLedgerId = suggestion.id;

                          if (suggestion.id != null) {
                            customerController.text = suggestion.lhName;
                            custValue = suggestion.lhName;
                            inSelect = true;
                            outSelect = true;
                            print(customerController.text);
                            getCustomerRegistered(salesLedgerId);
                            getCustomerLedgerBalance(suggestion.id);
                          }

                          print(salesLedgerId);
                          print("750...........");
                        },
                        errorBuilder: (BuildContext context, Object? error) =>
                            Text('$error',
                                style: TextStyle(
                                    color: Theme.of(context).errorColor)),
                        transitionBuilder:
                            (context, suggestionsBox, animationController) =>
                            FadeTransition(
                              child: suggestionsBox,
                              opacity: CurvedAnimation(
                                  parent: animationController!,
                                  curve: Curves.elasticIn),
                            ))),
                SizedBox(
                  width: 10,
                ),
              ]),

              SizedBox(
                height: 10,
              ),
              // ----------------------------------------
              Visibility(
                visible: regSelect == true,
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        textAlign: TextAlign.left,
                        // textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        minLines: 3,
                        maxLines: null,
                        controller: generalRemarksController,
                        enabled: true,
                        validator: (v) {
                          if (v!.isEmpty) return "Required";
                          return null;
                        },
//
//                  focusNode: field1FocusNode,
                        cursorColor: Colors.black,

                        scrollPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        decoration: InputDecoration(
//                    suffixIcon: Icon(
//                      Icons.calendar_today,
//                      color: Colors.blue,
//                      size: 24,
//                    ),
                          isDense: true,
                          // contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 16.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.0)),
                          // curve brackets object
//                    hintText: "Quantity",
                          hintStyle:
                          TextStyle(color: Colors.black, fontSize: 15),

                          labelText: "Remarks",
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),



              Visibility(
                  visible: regSelect == true,
                  child: Row(
                    children: [
                      SizedBox(
                        height: 70,
                        width: 10,
                      ),
                      GestureDetector(
                          onTap: () {
                            print("Register");
                            customerRegisterNow();
                          },
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * (0.95),
                            height: 50,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.lightBlue,
                              ),

                              width: 100,
                              // height: 50,
                              child: Center(
                                child: Text(
                                  "Register",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          )),
                    ],
                  )),




              // -------------------------------date from - to------------------------------------------

              Padding(
                padding: const EdgeInsets.only(left: 1, right: 1),
                child: Row(children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: TextFormField(
                      style: TextStyle(fontSize: 15),
                      showCursor: true,
                      controller: ControllerdateF,
                      enabled: true,
                      validator: (v) {
                        if (v!.isEmpty) return "Required";
                        return null;
                      },
//
                      // will disable paste operation
                      // focusNode: field1FocusNode,
                      cursorColor: Colors.black,

                      scrollPadding: EdgeInsets.fromLTRB(0, 5, 5, 0),
                      keyboardType: TextInputType.datetime,
                      readOnly: true,

                      onTap: () async {
                        final DateTime now = DateTime.now();
                        DateTime? date = await showDatePicker(
                            context: context,
                            initialDatePickerMode: DatePickerMode.day,
                            initialDate: now,
                            firstDate: DateTime(1980),
                            lastDate: DateTime(2080),
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: ThemeData.light(),
                                child: child!,
                              );
                            });

                        if (date != null) {
                          ControllerdateF.text =
                              DateFormat("MM-01-yyyy").format(dateTO);
                          // return false;
                          //  } else {
                          dateFrom = date;
                          var d = DateFormat("d-MM-yyyy").format(date);
                          ControllerdateF.text = d;
                          getCustomerLedgerBalance(salesLedgerId);
                        }
                      },
                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.red),
                        //'' errorText: deliveryDateSelect ? "invalid date " : null,
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          color: Colors.blue,
                          size: 24,
                        ),
                        isDense: true,
                        contentPadding:
                        EdgeInsets.fromLTRB(27.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0)),
                        // curve brackets object
                        hintText: "From:",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                        labelText: "From",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: TextFormField(
                      style: TextStyle(fontSize: 15),
                      showCursor: true,
                      controller: ControllerdateT,
                      enabled: true,
                      validator: (v) {
                        if (v!.isEmpty) return "Required";
                        return null;
                      },
//
                      // will disable paste operation
                      // '' focusNode: field2FocusNode,
                      cursorColor: Colors.black,

                      scrollPadding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                      keyboardType: TextInputType.datetime,
                      readOnly: true,

                      onTap: () async {
                        final DateTime now = DateTime.now();
                        DateTime? date = await showDatePicker(
                            context: context,
                            initialDatePickerMode: DatePickerMode.day,
                            initialDate: now,
                            firstDate: DateTime(1980),
                            lastDate: DateTime(2080),
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: ThemeData.light(),
                                child: child!,
                              );
                            });

                        // if (date != null) {
                        print("Date TO=$date");
                        if (date != null) {
                          //   if (date != null && date.day < DateTime.now().day) {
                          // showDialog(
                          // context: context,
                          // builder: (context) => new AlertDialog(
                          // title: new Text('invalid date select !'),
                          // content: new Text('select a Valid date ...'),
                          // ),
                          // );
                          // print("Date=$date");   // //if (date.day > DateTime.now().day) {
                          //   print("invalid date select");
                          ControllerdateT.text =
                              DateFormat("MM-dd-yyyy").format(DateTime.now());
                          // return false;
                          // } else {
                          // if (date.day < DateTime.now().day) {
                          //   print("invalid date select");
                          //
                          //   testController2.text = "";
                          //   return;
                          // } else {
                          dateTO = date;
                          var dt = DateFormat("d-MM-yyyy").format(date);
                          ControllerdateT.text = dt;
                          getCustomerLedgerBalance(salesLedgerId);
                        }
                      },
                      decoration: InputDecoration(
                        // errorStyle: TextStyle(color: Colors.red),
                        // errorText: deliveryDateSelect ? "invalid date " : null,
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          color: Colors.blue,
                          size: 24,
                        ),
                        isDense: true,
                        contentPadding:
                        EdgeInsets.fromLTRB(27.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0)),
                        // curve brackets object
                        hintText: "To",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                        labelText: "To",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ]),
              ),

              // --------------------------------date from - to end--------------------------------------
              SizedBox(
                height: 20,
              ),

///---------------------------------- strt------------------------------

                  /// --------------------------------- Puchase -----------------------------
                  Visibility(visible: false,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 0.7),
                                color: Color.fromARGB(255, 175, 211, 246),
                                borderRadius: BorderRadius.circular(15)),
                            child: Stack(children: [
                              GestureDetector(
                                onTap: () async {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => salesindex()));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.add_business,
                                        color: Colors.blue,
                                        size: 30,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Puchase",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 25,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 103,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Purchase(
                                          passvalue: salesLedgerId,
                                          passname: custValue.toString(),
                                        )),
                                  );
                                },
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                          color: Colors.black,
                                          width: 0.7,
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: new Icon(
                                        Icons.add,
                                        size: 30,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: Visibility(
                                  visible:false,// visiblestate == true,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(14),
                                          bottomLeft: Radius.circular(14)),
                                      border: Border.all(width: 0.5),
                                    ),
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 30, bottom: 2),
                                    alignment: Alignment(-1, 0.0),
                                    child: Text(
                                      "nill",
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ]),
                          ),
                        ),
                    SizedBox(
                      height: 10,
                    ),


/// --------------------------------- Sales -----------------------------
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 0.7),
                            color: Color.fromARGB(255, 175, 211, 246),
                            borderRadius: BorderRadius.circular(15)),
                        child: Stack(children: [
                          GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => salesindex()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.shopping_cart,
                                    color: Colors.blue,
                                    size: 30,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Sales",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 103,
                          ),
                          GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Newsalespage(
                                      passvalue: salesLedgerId,
                                      passname: custValue.toString(),
                                    )),
                              );
                            },
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      color: Colors.black,
                                      width: 0.7,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: new Icon(
                                    Icons.add,
                                    size: 30,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Visibility(
                              visible:false,// visiblestate == true,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(14),
                                      bottomLeft: Radius.circular(14)),
                                  border: Border.all(width: 0.5),
                                ),
                                padding: const EdgeInsets.only(
                                    top: 10, left: 30, bottom: 2),
                                alignment: Alignment(-1, 0.0),
                                child: Text(
                                  "nill",
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ]),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),



                    /// --------------------------------- Puchase Return -----------------------------
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 0.7),
                            color: Color.fromARGB(255, 175, 211, 246),
                            borderRadius: BorderRadius.circular(15)),
                        child: Stack(children: [
                          GestureDetector(
                            onTap: () async {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => salesindex()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add_business,
                                    color: Colors.blue,
                                    size: 30,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Purchase Return",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 103,
                          ),
                          GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Purchase(
                                      passvalue: salesLedgerId,
                                      passname: custValue.toString(),
                                    )),
                              );
                            },
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      color: Colors.black,
                                      width: 0.7,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: new Icon(
                                    Icons.add,
                                    size: 30,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Visibility(
                              visible:false,// visiblestate == true,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(14),
                                      bottomLeft: Radius.circular(14)),
                                  border: Border.all(width: 0.5),
                                ),
                                padding: const EdgeInsets.only(
                                    top: 10, left: 30, bottom: 2),
                                alignment: Alignment(-1, 0.0),
                                child: Text(
                                  "nill",
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ]),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),


///---------------Total Sales Return----------------

                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 0.7),
                            color: Color.fromARGB(255, 175, 211, 246),
                            borderRadius: BorderRadius.circular(15)),
                        child: Stack(children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.remove_shopping_cart_rounded,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "$strval Sales Return",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    // color: Colors.blue,
                                    fontSize: 23,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //  SizedBox(width: 103,),
                          GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SalesReturn(
                                      passvalue: salesLedgerId,
                                      passname: custValue.toString(),
                                    )),
                              );
                            },
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      color: Colors.black,
                                      width: 0.7,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: new Icon(
                                    Icons.add,
                                    size: 30,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Visibility(
                              visible:false,// visiblestate == true,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(14),
                                        bottomLeft: Radius.circular(14)),
                                    border: Border.all(width: 0.5)),
                                padding: const EdgeInsets.only(
                                    top: 10, left: 30, bottom: 2),
                                alignment: Alignment(-1, 0.0),
                                child: Text(
                                  SlRtn.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ]),
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),
//
                      ],
                    ),
                  ),


 ///---------------Total Sales Order----------------
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.teal, width: 0.7),
                          //color: Color.fromARGB(255, 175, 211, 246),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Stack(children: [
                        GestureDetector(
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SalesOrderIndexPageView(
                                            passvalue: routjson)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add_shopping_cart_sharp,
                                  color: Colors.teal,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "$strval Sales Order",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.teal,
                                    fontSize: 23,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //  SizedBox(width: 103,),

                        GestureDetector(
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SalesOrder(
                                    passvalue: salesLedgerId,
                                    passname: custValue.toString(),
                                  )),
                            );
                          },
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: Colors.teal,
                                    width: 0.7,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: new Icon(
                                  Icons.add,
                                  size: 30,
                                  color: Colors.teal,
                                ),
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Visibility(
                            visible:false,// visiblestate == true,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(14),
                                    bottomLeft: Radius.circular(14)),
                                border: Border.all(width: 0.5),
                              ),
                              padding: const EdgeInsets.only(
                                  top: 10, left: 30, bottom: 2),
                              alignment: Alignment(-1, 0.0),
                              child: Text(
                                "nill",
                                // SalsOrd.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        )
                      ]),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

 ///---------------------Receipt Collection--------------------------
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.teal, width: 0.7),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Stack(children: [
                        GestureDetector(
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ReceiptCollectionIndex_Direct(
                                            passvalue: routjson)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.description_outlined,
                                  color: Colors.teal,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "$strval Receipt Collection",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.teal,
                                    fontSize: 23,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        //  SizedBox(width: 103,),
                        GestureDetector(
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReceiptCollections_Direct(
                                    passvalue: salesLedgerId,
                                    passname: custValue.toString(),
                                  )),
                            );
                          },
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: Colors.teal,
                                    width: 0.7,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: new Icon(
                                  Icons.add,
                                  size: 30,
                                  color: Colors.teal,
                                ),
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Visibility(
                            visible:false,// visiblestate == true,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(14),
                                      bottomLeft: Radius.circular(14)),
                                  border: Border.all(
                                      color: Colors.black, width: 0.5)),
                              padding: const EdgeInsets.only(
                                  top: 10, left: 30, bottom: 2),
                              alignment: Alignment(-1, 0.0),
                              child: Text(
                                RcptCll.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        )
                      ]),
                    ),
                  ),

              SizedBox(
                height: 10,
              ),
              ///---------------------Payment Voucher--------------------------
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.teal, width: 0.7),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Stack(children: [
                    GestureDetector(
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                   Payment_VoucherIndex_Direct(
                                        passvalue: routjson)));
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.description_outlined,
                              color: Colors.teal,
                              size: 30,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "$strval Payment Voucher",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.teal,
                                fontSize: 23,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //  SizedBox(width: 103,),
                    GestureDetector(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Payment_Voucher_Direct(
                                passvalue: salesLedgerId,
                                passname: custValue.toString(),
                              )),
                        );
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Colors.teal,
                                width: 0.7,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: new Icon(
                              Icons.add,
                              size: 30,
                              color: Colors.teal,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Visibility(
                        visible:false,// visiblestate == true,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(14),
                                  bottomLeft: Radius.circular(14)),
                              border: Border.all(
                                  color: Colors.black, width: 0.5)),
                          padding: const EdgeInsets.only(
                              top: 10, left: 30, bottom: 2),
                          alignment: Alignment(-1, 0.0),
                          child: Text(
                            RcptCll.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    )
                  ]),
                ),
              ),




              IndexButtons(context,"Purchase Index",Icons.featured_play_list_outlined,
              Purchase_Index()),

              IndexButtons(context,"Sales Index",Icons.featured_play_list_outlined,
              salesindex()),


              IndexButtons(context,"Ledger Balance",Icons.request_page_outlined,
              Newtestpage( passvalue: custValue.toString(),Shid: salesLedgerId)),



              IndexButtons(context,"Shop Visited",Icons.remove_red_eye,
              shopvisited(passvalue: salesLedgerId,passname: custValue.toString())),


              IndexButtons(context,"Customer Details",Icons.account_circle,
              Customer_Details()),



///------------------------------------------------------------------------------
              Visibility(
                visible: rmrk == true,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                  child: TextField(
                    controller: RemarksTxtController,
                    maxLines: null,
                    enabled: true,
                    cursorColor: Colors.black,
                    scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding:
                      EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 16.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0)),
                      hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                      labelText: "Remarks",
                    ),
                  ),
                ),
              ),

              WillPopScope(
                onWillPop: _onBackPressed,
                child: Text(""),
              ),

            ],
          ),
          onRefresh: refreshList,
        ),


      ),
    );
  }





  ///--------------------------Buttons----------------------------------
  Padding IndexButtons(BuildContext context,String Name,IconData routicon,RoutPage) {
    return Padding(
              padding: const EdgeInsets.only(left: 10,top: 10,right: 10),
              child: GestureDetector(
                onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RoutPage));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 47,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                 // color:  Color.fromARGB(255, 175, 211, 246),
                  color:  Colors.white,
                    border: Border.all(width: 0.5,color:Colors.teal),
                  ),
                  child: Row(
                   children: [
                     SizedBox(width: 18,),
                     Icon( routicon,color: Colors.teal, size: 30, ),
                     SizedBox(width: 10,),
                     Text("$Name",style: TextStyle(
                       color: Colors.teal,
                       fontSize: 25,
                     ),),
                   ],
                  ),
                ),
              ),
            );
  }







  Future<bool> _onBackPressed() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => AppTyp=="RMS" ? Rms_Homes() : SalesManHome()
      ),
    );

    // If you need to return a boolean value after the navigation:
    return Future.value(true); // You can return either true or false based on your requirement
  }


  Refresh() {
    print("function in $salesLedgerId");
    getLedger(salesLedgerId, null);
  }



}
