
import 'dart:convert';
import 'dart:io';
import 'package:android_intent/android_intent.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:math' show cos, sqrt, asin;
// import 'package:location/location.dart' as loc;
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:new_qizo_gt/receiptcollection.dart';
import 'package:new_qizo_gt/sales.dart';
import 'package:new_qizo_gt/salesmanhome.dart';
import 'package:new_qizo_gt/salesorder.dart';
import 'package:new_qizo_gt/salesreturn.dart';
import 'package:new_qizo_gt/urlEnvironment/urlEnvironment.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';




//import 'package:flutter_app/newtestpage.dart';

import 'GT_Masters/AppTheam.dart';
import 'appbarWidget.dart';
import 'models/customersearch.dart';
import 'models/receiptCollection.dart';
import 'package:path_provider/path_provider.dart';

import 'models/shopvisitswithdate.dart';
import 'models/userdata.dart';
import 'newtestpage.dart';







  class shopvisited extends StatefulWidget {
    int passvalue;
  dynamic passname;
  shopvisited({required this.passvalue,this.passname});

  @override
  _shopvisitedState createState() => _shopvisitedState();
//   @override
//   _CustomerVisitedState createState() => _CustomerVisitedState();
}

class _shopvisitedState extends State<shopvisited> {
  final Permission permission = Permission.location;
  // Map<PermissionGroup, loc.PermissionStatus> permissions;
  dynamic longitude;
  dynamic latitude;
  bool RemarkSelect = false;
  late SharedPreferences pref;
  late bool regSelect;
  dynamic user;
  dynamic serverDate;
  TextEditingController generalRemarksController = new TextEditingController();
  dynamic branchName;
  dynamic userName;
  dynamic userArray;
  late double totalDistance;
  dynamic location;
  dynamic datas;
   dynamic CstName="";
  late bool visibilityTableRow ;
  //List<ShopVisitsDate> visitShop = new List<ShopVisitsDate>();
 List<dynamic>visitShop=[];
  bool inSelect = true;
  bool outSelect = true;
  static List<Customer> users = [];


  AppTheam theam= AppTheam();

  TextEditingController customerController = new TextEditingController();
  TextEditingController dateController = new TextEditingController();
  TextEditingController RemarkController = new TextEditingController();

  bool customerSelect = false;
  int salesLedgerId = 0;
  dynamic VisitInId = 0;
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  dynamic openingAmountBalance = 0.0;
  dynamic  textTitle2="";
  dynamic custValue;
  List<dynamic> dt = [];
  late bool rmrk;

  // ---------?----
  dynamic tagsJson=[];
  // ---------------

  bool showProgress = true;
  TextEditingController ControllerdateF = new TextEditingController();
  TextEditingController ControllerdateT = new TextEditingController();
  dynamic dateFrom;
  dynamic dateTO= DateTime.now();



  @override
  void initState() {
    // TODO: implement initState

    internet_check();
    _checkGps();
    ControllerdateT.text= DateFormat("MM-dd-yyyy").format(dateTO);
    ControllerdateF.text= DateFormat("MM-01-yyyy").format(dateTO);


    SharedPreferences.getInstance().then((value) {
      pref = value;
      print('${Env.baseUrl}');
      read();
      getCustomer();
      _getLocation();


      if(widget.passname!= "null") {
        print("value rctptclln= " + widget.passname+"  "+widget.passvalue.toString());
        customerController.text = widget.passname;
        salesLedgerId = widget.passvalue;
        //regCustomerIn();
        getCustomerRegistered(salesLedgerId);
        custValue= widget.passname;
      }
      // else {
      //
      // }

      datas =widget.passvalue;
      print("fgnjghjgh $datas");
      if(datas == "0" || datas == null ||datas == "null")
      {
        print("fgnjghjgh");
        // print("visibilityTableRowtrue"+datas['ledgerId'].toString());
        visibilityTableRow=true;
        getLedger(0,null);

      // getCustomerRegistered(0);

      }
      else
      {
       // print("visibilityTableRowfalse"+datas['ledgerId'].toString());
       // getLedger(datas,null);
        getCustomerRegistered(datas);
        visibilityTableRow=false;
        CstName = widget.passname;
      }




      });

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

      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      print(placemarks[0].locality);
      print(placemarks[0].country);
      print(placemarks[0].administrativeArea);
      print(placemarks[0].subLocality);
      print(placemarks[0].subAdministrativeArea);
      print(placemarks[0].thoroughfare);

      print("user..................");
      print(user.branchId);
      print(user.branchName);
      print("user..................");
      print(placemarks[0].administrativeArea);
      print(placemarks[0].locality);
      print(placemarks[0].subLocality);
      print(placemarks[0].subAdministrativeArea);
      location = '${placemarks[0].locality}  ${placemarks[0].subAdministrativeArea}';
      print("longitude:");
      print(location);
      print(position.longitude);
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

    try {
      var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
      print("out calculateDistance");
      return 12742 * asin(sqrt(a));
    } catch(e) {
      print("error on calculate distance$e");
      return 0.0; // returning a default value in case of an exception
    }
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
      print("238 ="+(response.statusCode).toString());

      if (response.statusCode == 200) {
        print('...................');
        Map<String, dynamic> data = json.decode(response.body);
        print("array is");
        print(data["lst"]); //used  this to autocomplete
        print("........");
        print(response.body);
        print(response.statusCode);
        print("248 ="+(response.statusCode).toString());
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
        print("Error getting users");
      }
    } catch (e) {
      print("Error getting users");
    }
  }

  // current customer registered or not
  getCustomerRegistered(dynamic ledgerId) async {


    print("getCustomerRegistered");


      print( "http://erptestapi.qizo.in:811/api/RelMcustLedgerLocations/${ledgerId}/1");

    var res = await http.get(
        "${Env.baseUrl}RelMcustLedgerLocations/${ledgerId}/1" as Uri,
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
          getLedger(ledgerId, null);
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
           // dateController.text =
            //'Date On : ${formattedDate.toString()} - ${c.toString()}';
            print("272.....data...");
            // if (r['visitDetails'].length % 2 == 0) {
            if (r['visitDetails'][r['visitDetails'].length - 1]['tvhDateOut'] ==
                null ||
                r['visitDetails'][r['visitDetails'].length - 1]['tvhDateOut'] ==
                    "")
            { print(r['visitDetails'][r['visitDetails'].length - 1]['id']);
           VisitInId=r['visitDetails'][r['visitDetails'].length - 1]['id'];
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
  customerLedgerIdListener() async{


    print("customerLedgerIdListener");
    //internet_check();
    setState(() {
      print("listener");
      // inSelect = true;
      // outSelect = true;
      regSelect = false;
      // visitShop = [];

      if (salesLedgerId == 0) {
        visitShop = [];

        regSelect = false;
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
      print("387 ="+(response.statusCode).toString());

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
          print("formattedDate : "+formattedDate);
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
                  action: 'android.settings.LOCATION_SOURCE_SETTINGS'
              );
              intent.launch();
              Navigator.of(context, rootNavigator: true).pop();
              // _gpsService();
            },
          )

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
    internet_check();
    _checkGps();
    print("regCustomerIn $salesLedgerId");

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
        VisitInId = u;
        print(u);
        print("480 data..............");

        getCustomerRegistered(b);
      }
    });
  }







  // registered customer out
  regCustomerOut() async {
    dynamic rmrkval=RemarkController.text;
    if( rmrkval==""){
      showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text("Add Remarks"),
              ));
      return;
    }

    //inSelect = false;
    print("regCustomerOut.");

    setState(() {
      if (inSelect == false) {
        outSelect = true;
        return;
      }
    });
    print("509-func");
    getServerDate();

    var date = serverDate;

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
      "tvhDateOut": date,
      "TvhRemarks":rmrkval
    };
    // print("526-................");
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
      if (res.statusCode == 200 || res.statusCode == 201 ||
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
    RemarkController.text="";
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
    }
    else {
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
      print("670 ="+(response.statusCode).toString());

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
        print(formattedDate);

        getLedger(accountId, formattedDate);
      } else {
        print("Error getting users");
      }
    } catch (e) {
      print("Error getting users" + e.toString());
    }
    print("customer Id is");
    print(accountId);
  }


//---------------------------------------Location accecss checking-----------------------------------------------------
  Future _checkGps() async {
    if (!(await Geolocator.isLocationServiceEnabled())) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  "Can't get current location",
                  style: TextStyle(color: Colors.red),
                ),
                content:
                const Text('Please make sure you enable GPS and try again'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Enable GPS'),
                    onPressed: () {
                      AndroidIntent intent = AndroidIntent(
                        action: 'android.settings.LOCATION_SOURCE_SETTINGS',
                      );
                      intent.launch();

                      Navigator.of(context, rootNavigator: true).pop();
                      // _gpsService();
                    },
                  )


                ],
              );
            });
      } else {
        print("gps is ok ...........");
      }
    }
  }


  //------------------------------------------------------------------------------------


// --------------------Net Connection Checking-------------------------------------------------------
  internet_check() async{
    var i;
    var result = await (Connectivity().checkConnectivity()); {
      if(result==ConnectivityResult.mobile ||result== ConnectivityResult.wifi) {
        // var i=true;
        return true;

      }
      else if (result==ConnectivityResult.none){
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

//-------------------------------------------------------------------------------------------------------


// ---------------------------------New Fn---------------------------------------------------
  getLedger(dynamic acId, dynamic date) async {
    // print("dddd"+acId.toString());
    print("..........getLedger.............");
    dynamic dtfrm;
    dynamic dtto= DateFormat("MM-dd-yyyy").format(dateTO);


    if(dateFrom == null)
    {
      dtfrm= DateFormat("MM-01-yyyy").format(dateTO);

    }else{dtfrm= DateFormat("MM-dd-yyyy").format(dateFrom);}


    print("----------Daate from out -----------------------------$dtfrm");
    print("---------date to-out ---------- ----------------------$dtto");





    //  var url = "${Env.baseUrl}TcustomerVisitHistories/$acId/1/1";
    // print("url:" + url);


   // final url = "${Env.baseUrl}rptSalesmanCustomerHistoy";
    final url = "${Env.baseUrl}TcustomerVisitHistories/1";
    print("url==$url");
    var req = {
      "dtFrom": dtfrm,
      "dtTo": dtto,
      "ledgerId": salesLedgerId,
    };
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
    if (res.statusCode == 200 ||
        res.statusCode == 201 && salesLedgerId > 0) {
      //  print("ord data=" + res.body);
      var tagsJson =   json.decode(res.body);

     // print("result data is : $tagsJso");

     //  print("result data is 11"+tagsJson['visitDetails']['data'][0]['Customer']);
      //
      //
      setState(() {
      List<dynamic> tJson = tagsJson['visitDetails']['data'];
      print(tJson);
      visitShop = [];
      visitShop = tJson.map((tJson) => ShopVisitsDate.fromJson(tJson)).toList();
      });
     // print("ddd"+visitShop[0].tvhDateIn.toString());
      // setState(() {
      //
      //   if (r['visitDetails'].length > 0) {
      //     print("256.....data...");
      //     print(visitShop[0].tvhDateIn);
      //     print(visitShop[0].tvhDateOut);
      //     var c = DateFormat.EEEE().format(DateTime.now());
      //     print(c);
      //     var v = DateFormat.EEEE().format(DateTime.now());
      //     print(v);
      //
      //     var formatter =
      //     new DateFormat('MM-dd-yyyy'); // this dd-MM-yyyy format i want
      //
      //     String formattedDate = formatter
      //         .format(DateTime.parse(visitShop[0].tvhDate.substring(0, 10)));
      //     print(formattedDate);
      //     dateController.text =
      //     'Date On : ${formattedDate.toString()} - ${c.toString()}';
      //     print("272.....data...");
      //     // if (r['visitDetails'].length % 2 == 0) {
      //     if (r['visitDetails'][r['visitDetails'].length - 1]['tvhDateOut'] ==
      //         null ||
      //         r['visitDetails'][r['visitDetails'].length - 1]['tvhDateOut'] ==
      //             "")
      //     {
      //       print("278 hi.. even");
      //       print(
      //           r['visitDetails'][r['visitDetails'].length - 1]['tvhDateIn']);
      //       outSelect = false;
      //       inSelect = true;
      //     } else {
      //       print("data is odd ");
      //       outSelect = true;
      //       inSelect = false;
      //     }
      //   } else {
      //     outSelect = true;
      //     inSelect = false;
      //     print("no result List");
      //   }
      // });


    }else
    {print('error ocure');}

  }
  // ---------------------------------New-Fn------------------------------------------



  clear(){
    print("in clear function");
    customerController.text = "";
    salesLedgerId = 0;
    inSelect = true;
    outSelect = true;
    openingAmountBalance = 0;
    salesLedgerId=0;
    custValue=null;


  }


 // ---------------------------------------

  // ------------------------All Function End--------------------------------------------------------------


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(190.0),
          child: Appbarcustomwidget(uname: userName, branch: branchName, pref: pref, title: "Shop Visited")
        ),
        body: ListView(
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
                        return users.where((user) =>
                            user.lhName.toUpperCase().contains(pattern
                                .toUpperCase()));
                      },
                      itemBuilder: (context, suggestion) {
                        return Card(
                          color: theam.DropDownClr,
                          // shadowColor: Colors.blue,
                          child: ListTile(
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
                        internet_check();
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
                          custValue=suggestion.lhName;
                          inSelect = true;
                          outSelect = true;
                          print(customerController.text);
                          getCustomerRegistered(salesLedgerId);
                          getCustomerLedgerBalance(suggestion.id);
                          CstName =suggestion.lhName ;
                        }
                        print(salesLedgerId);
                        print("750...........");
                      },
                      errorBuilder: (BuildContext context, Object? error) =>
                          Text(
                            error.toString(),
                            style: TextStyle(color: Theme.of(context).errorColor),
                          ),

                      transitionBuilder:
                          (context, suggestionsBox, animationController) =>
                          FadeTransition(
                            child: suggestionsBox,
                            opacity: CurvedAnimation(
                                parent: animationController ?? AnimationController(vsync: NavigatorState()),
                                curve: Curves.elasticIn),
                          ))),
              SizedBox(
                width: 10,
              ),
            ]),
            // SizedBox(
            //   height: 6,
            // ),

            // ----------------------------------------
            // Visibility(
            //   visible: openingAmountBalance > 0,
            //   child: SizedBox(
            //     height: 15,
            //   ),
            // ),
            // Visibility(
            //   visible: openingAmountBalance > 0,
            //   child: Row(
            //     children: [
            //       SizedBox(
            //         height: 20,
            //       ),
            //       SizedBox(width: 30),
            //
            //
            //
            //       Expanded(
            //         child: Text(
            //           "Current Balance:  " + openingAmountBalance.toString(),
            //
            //           style: TextStyle(fontSize: 16),
            //         ),
            //       ),
            //
            //
            //
            //     ],
            //   ),
            // ),
            SizedBox(
              height: 3,
            ),
            // Visibility(
            //   visible: openingAmountBalance > 0,
            //   child: SizedBox(
            //     height: 9,
            //   ),
            // ),

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
                        hintStyle: TextStyle(color: Colors.black, fontSize: 15),

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
            //SizedBox(
            //   height: 6,
            // ),
            Visibility(
                visible: regSelect == true,
                child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onTap: () {
                            print("Register");
                            customerRegisterNow();
                          },
                          child: SizedBox(
                            width: 350,
                            height: 50,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
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
                    ),

                  ],
                )),
            // SizedBox(
            //   height: 7,
            // ),


// -----------------------------strt-----------------------------------------
//             Row(
//               children: [
//                 SizedBox(
//                   width: 10,
//                 ),
//                 Expanded(
//                   child: IgnorePointer(
//                     ignoring: inSelect,
//                     child: GestureDetector(
//                       onTap: () {
//                         print("in");
//                         regCustomerIn();
//                       },
//                       child: inSelect
//                           ? Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: Colors.grey,
//                         ),
//                         width: 165,
//                         height: 50,
//                         child: Center(
//                           child: Text(
//                             "in",
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       )
//                           : Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: Colors.lightBlue,
//                         ),
//                         width: 165,
//                         height: 50,
//                         child: Center(
//                           child: inSelect
//                               ? Text(
//                             "in",
//                             style: TextStyle(color: Colors.red),
//                           )
//                               : Text(
//                             "in",
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 4,
//                 ),
//                 Expanded(
//                     child: IgnorePointer(
//                       ignoring: outSelect,
//                       child: GestureDetector(
//                           onTap: () {
//                             regCustomerOut();
//                             print("out1");
//                           },
//                           child: outSelect
//                               ? Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               color: Colors.grey,
//                             ),
//                             width: 170,
//                             height: 50,
//                             child: Center(
//                               child: Text(
//                                 "out2",
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           )
//                               : Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               color: Colors.lightBlue,
//                             ),
//                             width: 170,
//                             height: 50,
//                             child: Center(
//                               child: outSelect
//                                   ? Text(
//                                 "out3",
//                                 style: TextStyle(color: Colors.red),
//                               )
//                                   : Text(
//                                 "out4",
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           )),
//                     )),
//                 SizedBox(
//                   width: 10,
//                 ),
//               ],
//             ),

// -----------------------------end-----------------------------------------
            Row(
              children: [
                SizedBox(
                  width: 30,
                ),
                IgnorePointer(
                  ignoring: inSelect,
                  child: GestureDetector(
                    onTap: () {
                      print("in");
                      regCustomerIn();
                    },
                    child: inSelect
                        ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey,
                      ),
                      width: 165,
                      height: 50,
                      child: Center(
                        child: Text(
                          "in",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                        : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.lightBlue,
                      ),
                      width: 165,
                      height: 50,
                      child: Center(
                        child: inSelect
                            ? Text(
                          "in",
                          style: TextStyle(color: Colors.red),
                        )
                            : Text(
                          "in",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                IgnorePointer(
                  ignoring: outSelect,
                  child: GestureDetector(
                      onTap: () {
                        regCustomerOut();
                        print("out");
                      },
                      child: outSelect
                          ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey,
                        ),
                          width:  MediaQuery.of(context).size.width*(0.42),
                        height: 50,
                        child: Center(
                          child: Text(
                            "out",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                          : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.lightBlue,
                        ),
                        width:  MediaQuery.of(context).size.width*(0.42),
                        height: 50,
                        child: Center(
                          child: outSelect
                              ? Text(
                            "out",
                            style: TextStyle(color: Colors.red),
                          )
                              : Text(
                            "out",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )),
                ),
                SizedBox(
                  width: 30,
                ),
              ],
            ),

            // -----------------------lbl Text------------------------------------------------

             SizedBox( height: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(10,2,10,2),
              child: TextFormField(
                controller: RemarkController,

                enabled: true,
                validator: (v) {
                  if (v!.isEmpty) return "Required";
                  return null;
                },
//
                // will disable paste operation
//                  focusNode: field1FocusNode,
                cursorColor: Colors.black,

                scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
               // keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  errorStyle: TextStyle(color: Colors.red),
                  errorText: RemarkSelect ? "Invalid Remark" : null,
//                    suffixIcon: Icon(
//                      Icons.calendar_today,
//                      color: Colors.blue,
//                      size: 24,
//                    ),
                  isDense: true,
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 16.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),

                  hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                  labelText: "Remark",
                ),
              ),
            ),
            SizedBox( height: 10),
            // -------------------------------date from - to------------------------------------------

            Padding(
              padding: const EdgeInsets.only(left: 8,right: 8),
              child: Row(
                  children : <Widget>[
                    SizedBox(
                      width: 1,
                    ),
                    Flexible(child:  TextFormField(
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
                                child: child ?? Container(),
                              );
                            }

                        );

                        if (date != null) {
                          // print("Date=$date");
                          // if (date.day > DateTime.now().day) {
                          //   print("invalid date select");
                          //
                          //  ControllerdateF.text = "";
                          //   return;
                          // } else {
                          dateFrom = date;
                          var d = DateFormat("MM-dd-yyyy").format(date);
                          ControllerdateF.text = d;
                          getLedger(salesLedgerId,null);
                          // }
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
                        contentPadding: EdgeInsets.fromLTRB(27.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0)),
                        // curve brackets object
                        hintText: "From:",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                        labelText: "From",
                      ),
                    ),),






                    SizedBox(
                      width: 10,
                    ),




                    Flexible(child:  TextFormField(
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
                                child: child ?? SizedBox.shrink(),  // provide a default in case child is null
                              );
                            }
                        );

                        if (date != null) {
                          print("Date TO=$date");
                          // if (date.day < DateTime.now().day) {
                          //   print("invalid date select");
                          //
                          //   testController2.text = "";
                          //   return;
                          // } else {
                          dateTO = date;
                          var dt = DateFormat("MM-dd-yyyy").format(date);
                         ControllerdateT.text = dt;
                          getLedger(salesLedgerId,null);
                          // }
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
                        contentPadding: EdgeInsets.fromLTRB(27.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0)),
                        // curve brackets object
                        hintText: "To",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                        labelText: "To",
                      ),
                    ),),




                    SizedBox(
                      width: 1,
                    ),
                  ]),
            ),

            // --------------------------------date from - to end--------------------------------------
            SizedBox(
              height: 10,
            ),

            Visibility(
              visible: rmrk ==true,
              child:
              Padding(
                padding: const EdgeInsets.fromLTRB(15.0,0.0,0.0,0.0),
                child: Text(textTitle2),

              ),),


            SizedBox(
              height: 10,
            ),
                // Container(child: Text(CstName.toString()),),
// ------------------------------------------------------------------------------------------------------
            Visibility(
              visible: visitShop.length > 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:10),
                    child: Text(CstName,style: TextStyle(color: Colors.blueAccent,fontSize: 15),),
                  ),
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      controller: dateController,
                      style: TextStyle(
                          color: Colors.red,
//                      fontFamily: Font.AvenirLTProMedium.value,
                          fontSize: 17),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      //  hintText: 'Date On : ${dateController.text}',
                        hintStyle: TextStyle(
                          fontSize: 17,
                          color: Colors.red,
                          backgroundColor: Colors.white10,
//                          fontFamily: Font.AvenirLTProBook.value)
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Visibility(
              visible: visitShop.length > 0,
              child: visitShop.length > 0
                  ? Row(
//            verticalDirection: VerticalDirection.down,
//            crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10,
                    height: 60,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Visibility(
                        visible: visitShop.length > 0,
                        child: DataTable(
                          columnSpacing: 30,
                          dataRowHeight: 35.0,
                          onSelectAll: (b) {},
                          sortAscending: true,
                          columns: <DataColumn>[
                            DataColumn(
                              label: Text('#'),
                            ),
                            visibilityTableRow ? DataColumn(
                              label: Text('Shop Name'),
                            ):
                            DataColumn(
                              label: Text(''),
                            ),
                            DataColumn(
                              label: Text('Date'),
                            ),
                            DataColumn(
                              label: Text('Time In'),
                            ),
                            DataColumn(
                              label: Text('Time Out'),
                            ),
                            DataColumn(
                              label: Text('Remark'),
                            ),
                          ],
                          rows: visitShop
                              .map(
                                (itemRow) =>
                                DataRow(
                                  //   selected: true,
                                  // onSelectChanged: (bool selected) {
                                  //   if (selected) {
                                  //     print("Onselect :" +
                                  //         salesOrdRes.indexOf(itemRow).toString());
                                  //   }
                                  // },

                                  cells: [
                                    DataCell(
                                      Text(
                                        getItemIndex(itemRow).toString(),
                                      ),
                                      onTap: () {
                                        print("hi" +
                                            visitShop
                                                .indexOf(itemRow)
                                                .toString());
                                      },
                                      // Text(getItemIndex(itemRow).toString()),
                                      showEditIcon: false,
                                      placeholder: false,
                                    ),
                                    visibilityTableRow ?  DataCell(
                                      Text(
                                          ' ${(itemRow.Customer)
                                              .toString()}'),

                                      showEditIcon: false,
                                      placeholder: false,
                                    ):
                                    DataCell(
                                      Text(''),),
                                    DataCell(
                                      Text(
                                          ' ${(itemRow.tvhDate)
                                              .toString()}'),

                                      showEditIcon: false,
                                      placeholder: false,
                                    ),
                                    DataCell(
                                      Text(
                                          ' ${(itemRow.tvhDateIn)
                                              .toString()}'),
                                      onTap: () {
                                        // do whatever you want
                                        print("hi :" +
                                            itemRow.tvhDateIn.toString());
                                      },
                                      showEditIcon: false,
                                      placeholder: false,
                                    ),
                                    DataCell(
                                      Text(

                                        '${(itemRow.tvhDateOut)
                                            .toString()}',
                                        style: TextStyle(),
                                      ),
                                      onTap: () {
                                        // do whatever you want
                                        print("hi :" +
                                            itemRow.tvhDateIn.toString());
                                      },
                                      showEditIcon: false,
                                      placeholder: false,
                                    ),



                                    DataCell(
                                      Text(

                                        (itemRow.tvhRemarks==null ? '-':itemRow.tvhRemarks)
                                            .toString(),
                                        style: TextStyle(),
                                      ),
                                      onTap: () {

                                        print("hi :" +
                                            itemRow.tvhRemarks.toString());
                                      },
                                      showEditIcon: false,
                                      placeholder: false,
                                    ),
                                    // DataCell(
                                    //   FlatButton(
                                    //     padding:
                                    //     const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    //     child: Icon(Icons.delete),
                                    //     onPressed: () {
                                    //       setState(() {
                                    //         removeListElement(itemRow,
                                    //             );
                                    //       });
                                    //     },
                                    //   ),
                                    // ),
                                  ],
                                ),
                          )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 0,
                  ),
                ],
              )
                  : Row(
                children: [
                  SizedBox(
                    height: 60,
                    width: 150,
                  ),
                  Container(
                    child: Center(
                      // SizedBox(
                      //   width: 90,
                      // ),
                      child: Visibility(
                        visible: visitShop.length <= 0,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      // SizedBox(
                      //   width: 20,
                      // ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
                height: 20),





//-----------------------------------test---------------------------------------

// ---------------------------------testing end -----------------------------



          ],
        ),





        bottomSheet: Padding(
          padding: const EdgeInsets.only(left: 15,bottom: 15),
          child: FloatingActionButton(

              backgroundColor: Colors.blue,
              hoverColor: Colors.red,  elevation: 5,

              child: Icon(Icons.home_filled),


              onPressed: (){
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder:(context) =>
                        SalesManHome()), (route) => false);
              }),

        ),

        floatingActionButton:SpeedDial(
          animatedIcon:AnimatedIcons.menu_arrow,overlayColor: Colors.blue,
          children: [

            SpeedDialChild(
                child: Icon(Icons.add_shopping_cart_sharp),
                backgroundColor: Colors.blue,
                label: "Sales",
                onTap:(){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>Newsalespage(passvalue:salesLedgerId,passname:custValue.toString(),)));
                } ),

            SpeedDialChild(
                child: Icon(Icons.request_quote_outlined),
                backgroundColor: Colors.blue,
                label: "Ledger Balance",
                onTap:(){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Newtestpage(passvalue:custValue.toString(),Shid:salesLedgerId)),  );
                } ),


            SpeedDialChild(
                child: Icon(Icons.remove_shopping_cart_rounded),
                backgroundColor: Colors.blue,
                label: "Sales Return",
                onTap:(){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SalesReturn(passvalue:salesLedgerId,passname:custValue.toString(),)));
                } ),



            SpeedDialChild(
                child: Icon(Icons.description_outlined),
                backgroundColor: Colors.blue,
                label: "Receipt Collection",
                onTap:(){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>ReceiptCollections(passvalue:salesLedgerId.hashCode,passname:custValue.toString(),)));
                } ),

            SpeedDialChild(
                child: Icon(Icons.shopping_cart),
                backgroundColor: Colors.blue,
                label: "Sales Order",
                onTap:(){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>SalesOrder(passvalue:salesLedgerId,passname: custValue.toString(),)));
                } ),
          ],
        ),
      ),
    );
  }
}


