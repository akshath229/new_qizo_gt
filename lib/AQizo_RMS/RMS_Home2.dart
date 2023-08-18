import 'dart:convert';
import 'dart:io';


import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
// import 'package:location/location.dart' as loc;
import 'package:android_intent/android_intent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../AudioRecorde.dart';
import '../GT_Masters/Masters_HomePage.dart';
import '../Local_Db/Local_db_Model/Test_offline_Sales2.dart';
import '../PaymentVoucherIndex_Direct.dart';
import '../PaymentVoucher_Direct.dart';
import '../Purchase.dart';
import '../Purchase_Index.dart';
import '../Purchase_Return.dart';
import '../Purchase_Rtn_Index.dart';
import '../ReceiptCollections_Direct2.dart';
import '../Reports/Report_Home.dart';
import '../Sales_Rtn_Index.dart';
import '../Salesreturn2.dart';
import '../Utility/General_Setting.dart';
import '../appbarWidget.dart';
import '../documentmovementindex.dart';
import '../expensesheetindexpage.dart';
import '../indexpage.dart';
import '../models/userdata.dart';
import '../receiptcollectionindex_Direct.dart';
import '../salesindex.dart';
import '../set_CustomerLocation2.dart';
import '../urlEnvironment/urlEnvironment.dart';
import 'Rms_ItemBill_Index.dart';
import 'Rms_MakeOrder.dart';
import 'itemBill.dart';

class Rms_Homes2 extends StatefulWidget {
  var username;
  Rms_Homes2({this.username});





@override
  _Rms_Homes2State createState() => _Rms_Homes2State();
}
class _Rms_Homes2State extends State<Rms_Homes2> {
  late SharedPreferences pref;
  dynamic user;
  dynamic token;
  dynamic req;
  dynamic longitude;
  dynamic latitude;
  dynamic branchName;
  dynamic userName;
  dynamic location;
  dynamic locality;
  late bool gpsCheck;
  dynamic prog;

  bool _hasBeenPressed = false;
  String textTitle = "Mark Attendance";
  Color txtclr = Colors.black;
  Color btnclr = Color.fromARGB(255, 133, 188, 243);
  final PermissionHandler permissionHandler = PermissionHandler();
  // Map<PermissionGroup, loc.PermissionStatus> permissions;

  bool imageShow = false;
  bool isSwitched = false;
  dynamic theamname = "Normal";

  dynamic hight;
  dynamic width;
  dynamic AppTyp;

  @override
  void initState() {


    print("the value issss s " + widget.username.toString().toLowerCase());
    internet_check();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    setState(() {
      print("Sales man Home...............");
      SharedPreferences.getInstance().then((value) {

        pref = value;
        read();
        AppTyp??"GT";
      });
      super.initState();
    });
  }

  @override
  void dispose() {
    // TODO: Add code here
    super.dispose();
  }



  getVersion() async {
    var res = await http.get('${Env.baseUrl}MobVersion' as Uri,
        headers: {'Authorization': user.user['token']});
    print(res.body);

    var v = json.decode(res.body);
    print(v['details']['data'][0]['mobVersion']);
    var version = "24092020";
    if (version == v['details']['data'][0]['mobVersion']) {
      print("new version");
    } else {
      print("Old version");

      Widget yesButton = TextButton(
        child: Text("Ok"),
        onPressed: () {
          setState(() {
            print("yes...");
            pref.remove('userData');
            Navigator.pop(context); //okk
//                              Navigator.pop(context);
            Navigator.pushReplacementNamed(context, "/logout");

//                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()),);
          });
        },
      );
      // showDialog(
      //
      //     context: context,
      //     builder: (BuildContext context) {(
      //       child: AlertDialog(
      //
      //           content: Text("Do You Want Update New Version?"),
      //           actions: [yesButton]),
      //     ));

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () async => false,

              child: new AlertDialog(title: new Text("Update New Version?"),
                  // content: new Text('This is Demo'),
                  actions: <Widget>[yesButton]

              ),
            );
          });
      // if()
//
    }

    // http://erptestapi.qizo.in:811/api/
  }


  read() async {
    var v = pref.getString("userData");
    print("USER DATA: $v");

    var c = json.decode(v!);
    req = c;
    user = UserData.fromJson(c); // token gets this code user.user["token"] res
    setState(() {
      print("user data................");
      print(user.user["token"]);
      token = user.user["token"]; //  passes this user.user["token"]
      pref.setString("customerToken", user.user["token"]);
      print(user.deviceId);
      branchName = user.branchName;
      userName = user.user["userName"];
      var godwonid = user.user["godownid"];
      print(".....");
      print(branchName);
      print(userName);
      print(godwonid.toString());
      print("AppTyp");
      print(user.appType);
      AppTyp=user.appType;
    });



  }









  late int count;
  List<String> options = [
    //'Shop Visited',
    'Index',
    'Expense Sheet',
    'Product Cataloge',
    'Document',

  ];


  List<dynamic> icon = [
    Icons.shopping_cart_outlined,
    Icons.request_page_outlined,
    Icons.chat_bubble_outline_sharp,
    Icons.description_outlined

  ];


  // List<dynamic> imageslide = [
  //  'assets/Home_image.jpg'
  //  "https://www.impactbnd.com/hubfs/Marketing_Sales_integration-2.png"
  //  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRyZYS3saKEBgZsHBvmfoBQEAl2gR7bxZfkbQ&usqp=CAU'
  //  'https://cdn.ymaws.com/www.export.org.uk/resource/resmgr/images/Resources_Images/Reaching_Customers/Fotolia_112338128_Subscripti.jpg'
  // ];

  Object _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) =>
      new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit application'),
        actions: <Widget>[
          SizedBox(height: 30),
          new GestureDetector(
            //onTap: () => Navigator.of(context).pop(true),
            onTap: () => exit(0),
            child: Container(height: 50,
                width: 50,
                child: Center(
                    child: Text("YES", style: TextStyle(color: Colors.blue),))),
          ),
          SizedBox(width: 20),
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Container(height: 50,
                width: 50,
                child: Center(
                    child: Text("NO", style: TextStyle(color: Colors.blue),))),

          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    ) ??
        false;
  }

  dynamic testfunction() {
    textTitle = "Attendance Marked";
    //txtclr = Colors.black;
    txtclr = Colors.white;
    btnclr = Colors.green;
  }


  Size screenSize() {
    return MediaQuery
        .of(context)
        .size;
  }


// -------------------------------------------------------------------------------------------------------


  Widget build(BuildContext context) {
    var ScreenSize = MediaQuery
        .of(context)
        .size;
    return new WillPopScope(
      // onWillPop: () async => false,
        onWillPop: _onBackPressed,
        child: FractionallySizedBox(
          heightFactor: 1.0,
          widthFactor: 1.0,
          child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize: Size.fromHeight(80.0),
                  child: Appbarcustomwidget(uname: userName,
                      branch: branchName,
                      pref: pref,
                      title: "Qizo $AppTyp") //Appbarold(context),
              ),
              body: ListView(shrinkWrap: true,
                children: [
                  // NewHomePage(ScreenSize.width, ScreenSize.height),
                  SizedBox(
                    height: 1,
                  ),


///....................hjjjj................................................................

                  if(widget.username.toString().toLowerCase()=="super admin")NewHomePage(ScreenSize.width, ScreenSize.height),
                  if(widget.username.toString().toLowerCase()=="admin")NewHomePage(ScreenSize.width, ScreenSize.height),

                  ///.....................hjjjjjjjjjjjj...................................................................

                  CircleButtonNavigate(),



                  Center(
                      child: Text(
                        "${Env.baseUrl}",
                        style: TextStyle(
                            fontSize: 10,
                            backgroundColor: Colors.white,
                            color: Colors.brown),
                      )),

                ],
              ),

            ),
          ),
        ));
  }


  /*Checking if your App has been Given Permission*/
  Future<bool> requestLocationPermission({Function onPermissionDenied}) async {
    var granted = await _requestPermission(PermissionGroup.location);
    if (granted != true) {
      requestLocationPermission();
    }
    debugPrint('requestContactsPermission $granted');
    return granted;
  }


  Future<bool> _requestPermission(PermissionGroup permission) async {
    final PermissionHandler _permissionHandler = PermissionHandler();
    var result = await _permissionHandler.requestPermissions([permission]);

    print(".................");
    print(result[permission]);
    // print(loc.PermissionStatus.granted);
    print(".........");
    // if (result[permission] == loc.PermissionStatus.granted) {
    //   return true;
    // }
    return false;
  }


/*Check if gps service is enabled or not //rout to shop visit*/
  Future _gpsService() async {
    if (!(await Geolocator.isLocationServiceEnabled())) {
      _checkGps();
      print("Not ok _gpsService");

      return null;
    } else
      print("ok");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CustomerVisited()),
    );
    return true;
  }


/*Show dialog if GPS not enabled and open settings location*/
  Future _checkGps() async {
    if (!(await Geolocator.isLocationServiceEnabled())) {
      if (Theme
          .of(context)
          .platform == TargetPlatform.android) {
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
                        final AndroidIntent intent = AndroidIntent(
                            action:
                            'android.settings.LOCATION_SOURCE_SETTINGS');
                        intent.launch();
                        Navigator.of(context, rootNavigator: true).pop();
                        // _gpsService();
                      })
                ],
              );
            });
      } else {
        print("gps is ok ...........");
      }
    }
  }


  setLocationPermission() async {
    // requestLocationPermission();
    _gpsService();

  }


  directURL() async {
    print("Direct to...");
    var res = await http.get("${Env.baseUrl}getSettings/1/c" as Uri,
        headers: {'Authorization': user.user['token']});
    print(res.statusCode);
    if (res.statusCode == 200) {
      print("if:block...");

      List<dynamic> list = json.decode(res.body);
      var catalogUrl = list[0]["catelogUrl"];
      print(catalogUrl);
      if (await canLaunch(catalogUrl)) {
        await launch(catalogUrl);
      }
    } else {
      print("else:block...");
      const url = 'http://qizo.in/';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }




  Future checkgps(int i) async {
    if (!(await Geolocator.isLocationServiceEnabled())) {
      _checkGps();
      print("Not ok checkGps");

      return null;
    } else {
      if (i == 0) {
        setLocationPermission();
      }
      if (i == 1) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) =>
                ExpenseSheetIndexPage("SalesMan")));
      }

      if (i == 2) {
//                              Product Catalog
        directURL();
      }

      if (i == 3) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DocumentMovementIndex()),
        );
      }

      if (i == 4) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AudioRecorde()), //AudioRecorde
        );
      }

      return true;
    }
  }

  // -------------------cngd----end-----------------


  Future _gpsServiceCheck() async {
    if (!(await Geolocator.isLocationServiceEnabled())) {
      _checkGps();
      print("Not ok ");

      return null;
    } else
      print("ok");

    _getLocation();
    return true;
  }


  void fun() {
    print("pressd");
  }


  _getLocation() async {
    prog = new ProgressDialog(
      context,
      type: ProgressDialogType.normal,
      isDismissible: false,
      // barrierDismissible: false,

      showLogs: true,
    );
    prog.style(
      message: "Loading ....", //
//      progress: 0.0,
//      maxProgress: 100.0,
    );
    // prog.show();

    GeolocationStatus geolocationStatus =
    await Geolocator().checkGeolocationPermissionStatus();
    print('858$geolocationStatus');

    Position position = await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high,);


    markAttendance(position.latitude, position.longitude);

    print("latitude :");
    print(position.latitude);
    longitude = position.longitude;
    latitude = position.latitude;

    print("user..................");
    print(user.branchId);
    //  print(user.branchName);
    // print("user..................");

    print("longitude:");
    // print(position.longitude);
    longitude = position.longitude;
    latitude = position.latitude;
  }


  internet_check() async {
    var i;
    var result = await (Connectivity().checkConnectivity());
    {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        // var i=true;
        return true;
      }
      else if (result == ConnectivityResult.none) {
        // print("Net not Connected");
        // i=false;
        showDialog(
          context: context,
          builder: (context) =>
          new AlertDialog(
            title: new Text('No Internet Connection'),
            content: new Text('Check Internet Connection'),
          ),
        );
        return false;
      }
    }
  }


  // ----------------------------Testing mark attentece without location-------------------------------------------------
  // ---------------------------------------------------------------------------------

  markAttendance(dynamic latitude, dynamic longitude) async {
    debugPrint("Function in  markAttendance");
//print("internet_check()=="+internet_check().toString());

    dynamic val = await internet_check();

    //  print("gjgh=="+gg.toString());
    if (val == false) {
      return;
    }


    //  print("Function $latitude");
    // print("Function $longitude");

    try {
      // print("----------------------on catch----------------------");
      List<Placemark> placeMark =
      await Geolocator().placemarkFromCoordinates(latitude, longitude);
      print("device id......");
      print(user.deviceId);


      var req = {
        "latitude": latitude.toString(),
        "longitude": longitude.toString(),
        "locationText": placeMark[0].locality.toString(),
      };

      var params = json.encode(req);
      //  print(params);

      print(user.user['token']);
      var response = await http.post("${Env.baseUrl}mobattendances" as Uri,
          headers: {
            'accept': 'application/json',
            'content-type': 'application/json',
            'Authorization': user.user['token'],
            'deviceId': user.deviceId
          },
          body: params);

      print(response.statusCode);
      print("response  :" + response.body);
      print("...");
      setState(() {});

      if (placeMark[0].locality == null || placeMark[0].locality == "") {
        print("area null");
        print(placeMark[0].locality);
        locality = placeMark[0].subAdministrativeArea;
      } else {
        print("area not null");
        print(placeMark[0].administrativeArea);
        locality = placeMark[0].locality;
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          String ms = "Attendance Marked";

          var c = json.decode(response.body);
          var msg = c['msg'].toString();
          print(msg);
          print("att:" + msg);
          if (json.decode(response.body).containsKey('msg')) {
            print("exist");
            ms = msg;
            showDialog(
                context: context,
                builder: (context) =>
                    AlertDialog(
                      title: Text(ms),
                    ));
          } else {
            ms = "Attendance Marked";
            showDialog(
                context: context,
                builder: (context) =>
                    AlertDialog(
                      title: Text(ms),
                      content: Text(locality.toString() +
                          " , " +
                          placeMark[0].administrativeArea +
                          "," +
                          "                         " +
                          placeMark[0].country +
                          " , " +
                          placeMark[0].thoroughfare

                      ),
                    ));

            print("not exist..");
            testfunction();
          }
        });
      }
    } catch (e) {
      print("----------------------on catch else----------------------");

      print("exception is : " + e.toString());

      locality = null;
      print("Marked");
      print("device id......");
      print(user.deviceId);

      var req = {
        "latitude": latitude.toString(),
        "longitude": longitude.toString(),
        "locationText": locality.toString(),
      };
      var params = json.encode(req);
      print(params);

      print(user.user['token']);
      var response = await http.post("${Env.baseUrl}mobattendances" as Uri,
          headers: {
            'accept': 'application/json',
            'content-type': 'application/json',
            'Authorization': user.user['token'],
            'deviceId': user.deviceId
          },
          body: params);

      print(response.statusCode);
      print("response  :" + response.toString());
      print("...");
      setState(() {});

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          String ms = "Attendance Marked";

          var c = json.decode(response.body);
          var msg = c['msg'].toString();
          print(msg);
          print("att:" + msg);
          if (json.decode(response.body).containsKey('msg')) {
            print("exist");
            testfunction();
            ms = msg;
            showDialog(
                context: context,
                builder: (context) =>
                    AlertDialog(
                      title: Text(ms),
                    ));
          } else {
            ms = "Attendance Marked";
            showDialog(
                context: context,
                builder: (context) =>
                    AlertDialog(
                      title: Text(ms),
                      content: Text(
                          " Location Not found "),
                    ));

            print("not exist..");
          }
        });
      }
      //  testfunction();
    }
    testfunction();
  }

// -----------------------------------------------------------------------------------
// --------------------------------------------------------------------------------------
  Container Appbarold(BuildContext context) {
    return Container(
      // height: 80,
      decoration: BoxDecoration(gradient: new LinearGradient(
          colors: [Color(0xFFE7E9EE), Color(0xFF328BF6)],
          begin: FractionalOffset.centerLeft,
          end: FractionalOffset.centerRight,
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp)),
      width: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.only(
          //  bottom: 1,
            right: 10,
            left: 10
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
//                    SizedBox(width: 10,),


              GestureDetector(
                  onTap: () {
                    print("hi");
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    // fit: StackFit.expand,
                    children: [
                      Center(
                        child: Container(

                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.0),
                              image: DecorationImage(
                                  image: AssetImage("assets/icon1.jpg"),
                                  fit: BoxFit.fill
                              )
                          ),
                          margin: new EdgeInsets.only(
                              left: 0.0, top: 5.0, right: 0.0, bottom: 0.0),
                          child: Align(alignment: Alignment.center,
                            child: Center(
                              child: Text(
                                "",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
              ),


              GestureDetector(
                onTap: () {
                  print("hi");
                },
                child: Container(
                    margin: EdgeInsets.only(
                        top: 10,
                        bottom: 7
                    ),
                    child: Column(

                      children: [
                        SizedBox(height: 8,),
                        Expanded(
                          child: Text(
                            "Qizo GT",
                            style: TextStyle(fontSize: 22, color: Colors.white),
                          ),
                        ),

                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              "${branchName.toString()}",
                              style: TextStyle(fontSize: 13,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )
                ),
              ),
              GestureDetector(
                onTap: () {
                  Widget noButton = TextButton(
                    child: Text("No"),
                    onPressed: () {
                      setState(() {
                        print("No...");
                        Navigator.pop(
                            context); // this is proper..it will only pop the dialog which is again a screen
                      });
                    },
                  );

                  Widget yesButton = TextButton(
                    child: Text("Yes"),
                    onPressed: () {
                      setState(() {
                        print("yes...");
                        pref.remove('userData');
                        Navigator.pop(context); //okk
//                              Navigator.pop(context);
                        Navigator.pushReplacementNamed(
                            context, "/logout");

//                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()),);
                      });
                    },
                  );
                  showDialog(
                      context: context,
                      builder: (c) =>
                          AlertDialog(
                              content: Text("Do you really want to logout?"),
                              actions: [yesButton, noButton]));
                },
                child: Container(
                  margin: new EdgeInsets.only(
                      left: 0.0, top: 25.0, right: 0.0, bottom: 0.0),
                  child: Text(
                    "${userName.toString()}",
                    style: TextStyle(fontSize: 13, color: Colors.white),
                  ),
                ),
              )
            ]),
      ),
    );
  }


  ///old list menu with attendace marking ,ExpeceSheet,ProductCatalod,Document
  ///
  SingleChildScrollView Old_List_Menue() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      child: SizedBox(
        // height:double.maxFinite
        //  height: MediaQuery.of(context).size.height,
        child: OrientationBuilder(
          builder: (context, orientation) {
            count = 2;
            if (orientation == Orientation.landscape) {
              count = 3;
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [


                  Visibility(visible: imageShow, child: SizedBox(height: 10,)),

                  Visibility(
                    visible: imageShow,
                    child: SizedBox(
                        child: Carousel(
                          dotSize: 3,
                          indicatorBgPadding: 3,
                          dotIncreasedColor: Colors.blue,
                          moveIndicatorFromBottom: 10,

                          //animationCurve = Curves.ease,
                          images: [
                            // Image.asset('assets/Home_image.jpg',fit:  BoxFit.fill,),
                            Image.network(
                              "https://www.impactbnd.com/hubfs/Marketing_Sales_integration-2.png",
                              fit: BoxFit.fill,),
                            Image.network(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRyZYS3saKEBgZsHBvmfoBQEAl2gR7bxZfkbQ&usqp=CAU',
                              fit: BoxFit.fill,),
                            Image.network(
                              'https://cdn.ymaws.com/www.export.org.uk/resource/resmgr/images/Resources_Images/Reaching_Customers/Fotolia_112338128_Subscripti.jpg',
                              fit: BoxFit.fill,),
                            // Image.asset('assets/Home_image.jpg',fit:  BoxFit.fill,),
                          ],),
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.3,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.4
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  // CarouselSlider(items: [
                  //   imageslide.map((e) => null)
                  // ],),
                  GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: options.length,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 6,
                    ),
                    itemBuilder: (c, i) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 175, 211, 246),
                          splashFactory: InkRipple.splashFactory,
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        ),
                        onPressed: () {
                          print("index: $i");
                          setState(() {
                            checkgps(i);
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(icon[i], size: 40, color: Colors.indigo),
                            SizedBox(width: 30),  // Add some space between icon and text
                            Text(
                              options[i],
                              style: TextStyle(fontSize: 20.0, color: Colors.black),
                            ),
                          ],
                        ),
                      );

                    },
                  ),

                  SizedBox(
                    width: 10,
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(1.0, 8.0, 1.0, 10.0),
                    child: SizedBox(
                      height:
                      (MediaQuery
                          .of(context)
                          .size
                          .width / 3) - 16.0,


                      child:ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: btnclr,
                          padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
                        ),
                        onPressed: () {
                          setState(() {
                            txtclr = Colors.red;
                            _gpsServiceCheck();
                          });
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/attndance.jpg'),
                              fit: BoxFit.fill,
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.4),
                                BlendMode.dstATop,
                              ),
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              textTitle,
                              style: TextStyle(fontSize: 25.0, color: txtclr),
                            ),
                          ),
                        ),
                      ),

                    ),
                  ),


                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  ///----------------------------------------------------------


  Widget NewHomePage(width, height) {
    var Mstr_Name_lst = ["Masters", "Transaction", "Reports", "Utility ",];

    return  Padding(
        padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
        child: GridView.builder(physics: ScrollPhysics(),
          itemCount: 4,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            childAspectRatio: width > 500 ? 3 : 1.5,
          ),
          itemBuilder: (c, i) {
            return Container(color: Colors.teal.shade900,
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal, // Background color
                  ),
                  onPressed: () {
                    print("index: $i");
                    setState(() {
                      SelectedPage(i);
                    });
                  },
                  child: Text(
                    Mstr_Name_lst[i],
                    style: TextStyle(fontSize: 25.0, color: Colors.white),
                  ),
                ),

              ),
            );
          },
        ));
  }




  SelectedPage(a){

    switch(a.toString()) {
      case "0": {
        PageNavigate(Masters_Home_Pgae());
      }
      break;

      case "1": {
        PageNavigate(CustomerVisited());
      }
      break;

      case "2": {
        PageNavigate(Report_Home_Pgae());
      }
      break;
      case "3": {
        PageNavigate(GeneralSettings());
      }
      break;
      default: {
        print("Not Selected");
      }
      break;
    }

  }



  void pageNavigate(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }






  Widget CircleButtonNavigate(){

    return Column(
      children: [




        Visibility(
          visible: widget.username.toString().toLowerCase()=="super admin"||widget.username.toString().toLowerCase()=="admin",
          child: Button_List(
            name: "Item Bill",
            mainIcon: Icons.apps,
            routAddPage: Rms_ItemBill(),
            routListPage: Rms_ItemBill_Index(),
          ),
        ),



        Visibility(
          visible:widget.username.toString().toLowerCase()=="super admin"||widget.username.toString().toLowerCase()=="admin",
          child: Button_List(
            name: "Make Order",
            mainIcon: Icons.apps,
            routAddPage: Rms_MakeOrder(),
            routListPage: Rms_MakeOrder(),
          ),
        ),





        Visibility(
          visible: widget.username.toString().toLowerCase()=="super admin"||widget.username.toString().toLowerCase()=="admin",
          child: Button_List(
            name: "Purchase",
            mainIcon: Icons.add_business,
            routAddPage:Purchase( passvalue: 0,passname: null.toString()),
            routListPage: Purchase_Index(),
          ),
        ),


        Visibility(
          visible: AppTyp=="GT",
          child: Button_List(
            name: "Sales",
            mainIcon: Icons.shopping_cart,
            routAddPage:Ofline_Sales2(
              passvalue: 0,
              passname: null.toString(),
            ),
            routListPage: salesindex(),
          ),
        ),




        Visibility(
          visible: widget.username.toString().toLowerCase()=="super admin"||widget.username.toString().toLowerCase()=="admin",
          child: Button_List(
            name: "Purchase Return",
            mainIcon: Icons.assignment_return_outlined,
            routAddPage:PurchaseReturn(
              passvalue: 0,
              passname: null.toString(),
            ),
            routListPage:Purchase_Rtn_Index(),
          ),
        ),



        Visibility(
          visible: AppTyp=="GT",
          child: Button_List(
            name: "Sales Return",
            mainIcon: Icons.remove_shopping_cart_rounded,
            routAddPage:SalesReturn2(
              passvalue: 0,
              passname: null.toString(),
            ),
            routListPage:Sales_Rtn_Index(),
          ),
        ),



        Visibility(
          visible: AppTyp=="GT",
          child: Button_List(
              name: "Receipt Collection",
              mainIcon: Icons.fact_check,
              routAddPage: ReceiptCollections_Direct2(
                passvalue: 0,
                passname: null.toString(),
              ) ,
              routListPage:ReceiptCollectionIndex_Direct(passvalue: null)),
        ),




        Visibility(
          visible: widget.username.toString().toLowerCase()=="super admin"||widget.username.toString().toLowerCase()=="admin",
          child: Button_List(
              name: "Payment Collection",
              mainIcon: Icons.description_outlined,
              routAddPage: Payment_Voucher_Direct(
                passvalue: 0,
                passname: null.toString(),
              ) ,
              routListPage:Payment_VoucherIndex_Direct(passvalue: null)),
        ),
        Visibility(
          visible: AppTyp=="GT",
          child: Button_List(
              name: "Set Location",
              mainIcon: Icons.location_on_outlined,
              routAddPage: Set_Cust_Location2(),
              routListPage:Set_Cust_Location2()),
        ),



//
//       IconButton(icon: Icon(Icons.home,size: 35,), onPressed: (){
//
//      test();
//
//         return;
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//         builder: (context) =>LocalDb_Test()
//
//             // Test4(Parm_Id: 29,Page_Type: "A4",)
//        // Dynamic_Pdf_Print(Parm_Id: 5,)
//           //  New_Model_PdfPrint(Parm_Id: 5,)
//        // Rms_Homes()
//      //  TestRec_Pay_Print(Parm_Id: 11,printType: "Recpt",)
//      // Testpage()
//
//     ),
//   );
// })







      ],);

  }





  Padding Button_List({
    required IconData mainIcon,
    required String name,
    routAddPage,
    routListPage
  }

      ) {
    return Padding(
      padding: const EdgeInsets.only(right: 8,left: 8,top: 8,bottom: 4),
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: 45,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.teal, width: 1),
              color: Colors.white,
              borderRadius: BorderRadius.circular(15)),
          child:Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Icon(
                mainIcon,
                color: Colors.teal,
                size: 30,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                name,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.teal,
                  fontSize: 23,
                ),
              ),
              Spacer(),
              IconButton(
                  icon: Icon(
                    Icons.list_alt,
                    color: Colors.teal,
                    size: 30,
                  ),
                  onPressed: (){

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>routListPage),
                    );

                  }),
              SizedBox(
                width: 10,
              ),

              // IconButton(
              //     icon: Icon(
              //       Icons.add_circle_outline_sharp,
              //       color: Colors.teal,
              //       size: 30,
              //     ),
              //     onPressed: (){
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) =>routAddPage
              //         ),
              //       );
              //     }),

              InkWell(

                onTap:(){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>routAddPage
                    ),
                  );
                },
                child:Icon(
                  Icons.add_circle_outline_sharp,
                  color: Colors.teal,
                  size: 30,
                ),
              ),
              SizedBox(
                width: 5,
              ),

            ],)),
    );
  }



}

test()async{

  // var res=await http.get("http://192.168.0.105/alnashath/api/Englishes/120610");
  var res=await http.get("http://alnashath.qizo.in/api/Englishes/120611" as Uri);
  print(res.body);
}
///-------------------------------------old button------------------------------

//   Widget CircleButtonNavigate(){
//
//     return Column(children: [
//       /// --------------------------------- Puchase -----------------------------
//       Padding(
//         padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
//         child:  GestureDetector(
//           onTap: () async {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => Purchase(
//                     passvalue: null,
//                     passname: null.toString(),
//                   )),
//             );
//           },
//           child: Container(
//             decoration: BoxDecoration(
//                 border: Border.all(color: Colors.teal, width: 0.7),
//                 color:Colors.white,
//                 borderRadius: BorderRadius.circular(15)),
//             child: Stack(children: [
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.add_business,
//                       color: Colors.teal,
//                       size: 30,
//                     ),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     Text(
//                       "Puchase",
//                       textAlign: TextAlign.left,
//                       style: TextStyle(
//                         color: Colors.teal,
//                         fontSize: 25,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 width: 103,
//               ),
//               GestureDetector(
//                 onTap: () async {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => Purchase(
//                           passvalue: null,
//                           passname: null.toString(),
//                         )),
//                   );
//                 },
//                 child: Align(
//                   alignment: Alignment.centerRight,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       border: Border(
//                         left: BorderSide(
//                           color: Colors.white,
//                           width: 0.7,
//                         ),
//                       ),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(5),
//                       child: new Icon(
//                         Icons.add,
//                         size: 30,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 40),
//                 child: Visibility(
//                   visible:false,// visiblestate == true,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Color.fromARGB(255, 255, 255, 255),
//                       borderRadius: BorderRadius.only(
//                           bottomRight: Radius.circular(14),
//                           bottomLeft: Radius.circular(14)),
//                       border: Border.all(width: 0.5),
//                     ),
//                     padding: const EdgeInsets.only(
//                         top: 10, left: 30, bottom: 2),
//                     alignment: Alignment(-1, 0.0),
//                     child: Text(
//                       "nill",
//                       style: TextStyle(
//                         fontWeight: FontWeight.normal,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//             ]),
//           ),
//         ),
//       ),
//       SizedBox(
//         height: 10,
//       ),
//
//
//       /// --------------------------------- Sales -----------------------------
//       Padding(
//         padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
//         child: GestureDetector(
//           onTap: () async {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => Newsalespage(
//                     passvalue: null,
//                     passname: null.toString(),
//                   )),
//             );
//           },
//           child: Container(
//             decoration: BoxDecoration(
//                 border: Border.all(color: Colors.teal, width: 0.7),
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(15)),
//             child: Stack(children: [
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.shopping_cart,
//                       color: Colors.teal,
//                       size: 30,
//                     ),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     Text(
//                       "Sales",
//                       textAlign: TextAlign.left,
//                       style: TextStyle(
//                         color: Colors.teal,
//                         fontSize: 25,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 width: 103,
//               ),
//               GestureDetector(
//                 onTap: () async {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => Newsalespage(
//                           passvalue: null,
//                           passname: null.toString(),
//                         )),
//                   );
//                 },
//                 child: Align(
//                   alignment: Alignment.centerRight,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       border: Border(
//                         left: BorderSide(
//                           color: Colors.white,
//                           width: 0.7,
//                         ),
//                       ),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(5),
//                       child: new Icon(
//                         Icons.add,
//                         size: 30,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 40),
//                 child: Visibility(
//                   visible:false,// visiblestate == true,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Color.fromARGB(255, 255, 255, 255),
//                       borderRadius: BorderRadius.only(
//                           bottomRight: Radius.circular(14),
//                           bottomLeft: Radius.circular(14)),
//                       border: Border.all(width: 0.5),
//                     ),
//                     padding: const EdgeInsets.only(
//                         top: 10, left: 30, bottom: 2),
//                     alignment: Alignment(-1, 0.0),
//                     child: Text(
//                       "nill",
//                       style: TextStyle(
//                         fontWeight: FontWeight.normal,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//             ]),
//           ),
//         ),
//       ),
//       SizedBox(
//         height: 10,
//       ),
//
//
//
//       /// --------------------------------- Puchase Return -----------------------------
//       Padding(
//         padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
//         child: GestureDetector(
//           onTap: () async {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => PurchaseReturn(
//                     passvalue: null,
//                     passname: null.toString(),
//                   )),
//             );
//           },
//           child: Container(
//             decoration: BoxDecoration(
//                 border: Border.all(color: Colors.teal, width: 0.7),
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(15)),
//             child: Stack(children: [
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.assignment_return_outlined,
//                       color: Colors.teal,
//                       size: 30,
//                     ),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     Text(
//                       "Purchase Return",
//                       textAlign: TextAlign.left,
//                       style: TextStyle(
//                         color: Colors.teal,
//                         fontSize: 25,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 width: 103,
//               ),
//               GestureDetector(
//                 onTap: () async {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => Purchase(
//                           passvalue: null,
//                           passname: null.toString(),
//                         )),
//                   );
//                 },
//                 child: Align(
//                   alignment: Alignment.centerRight,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       border: Border(
//                         left: BorderSide(
//                           color: Colors.white,
//                           width: 0.7,
//                         ),
//                       ),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(5),
//                       child: new Icon(
//                         Icons.add,
//                         size: 30,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 40),
//                 child: Visibility(
//                   visible:false,// visiblestate == true,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Color.fromARGB(255, 255, 255, 255),
//                       borderRadius: BorderRadius.only(
//                           bottomRight: Radius.circular(14),
//                           bottomLeft: Radius.circular(14)),
//                       border: Border.all(width: 0.5),
//                     ),
//                     padding: const EdgeInsets.only(
//                         top: 10, left: 30, bottom: 2),
//                     alignment: Alignment(-1, 0.0),
//                     child: Text(
//                       "nill",
//                       style: TextStyle(
//                         fontWeight: FontWeight.normal,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//             ]),
//           ),
//         ),
//       ),
//       SizedBox(
//         height: 10,
//       ),
//
//
//
//
//       ///---------------Total Sales Return----------------
//       Padding(
//         padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
//         child:    GestureDetector(
//           onTap: () async {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => SalesReturn(
//                     passvalue: null,
//                     passname: null.toString(),
//                   )),
//             );
//           },
//           child: Container(
//             decoration: BoxDecoration(
//                 border: Border.all(color: Colors.teal, width: 0.7),
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(15)),
//             child: Stack(children: [
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.remove_shopping_cart,
//                       color: Colors.teal,
//                       size: 30,
//                     ),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     Text(
//                       "Sales Return",
//                       textAlign: TextAlign.left,
//                       style: TextStyle(
//                         color: Colors.teal,
//                         fontSize: 25,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 width: 103,
//               ),
//               GestureDetector(
//                 onTap: (){
//                 },
//                 child: Align(
//                   alignment: Alignment.centerRight,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       border: Border(
//                         left: BorderSide(
//                           color: Colors.white,
//                           width: 0.7,
//                         ),
//                       ),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(5),
//                       child: new Icon(
//                         Icons.add,
//                         size: 30,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 40),
//                 child: Visibility(
//                   visible:false,// visiblestate == true,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Color.fromARGB(255, 255, 255, 255),
//                       borderRadius: BorderRadius.only(
//                           bottomRight: Radius.circular(14),
//                           bottomLeft: Radius.circular(14)),
//                       border: Border.all(width: 0.5),
//                     ),
//                     padding: const EdgeInsets.only(
//                         top: 10, left: 30, bottom: 2),
//                     alignment: Alignment(-1, 0.0),
//                     child: Text(
//                       "nill",
//                       style: TextStyle(
//                         fontWeight: FontWeight.normal,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//             ]),
//           ),
//         ),
//       ),
//       SizedBox(
//         height: 10,
//       ),
//       // Center(
//       //     child: Text(
//       //       "${Env.baseUrl}",
//       //       style: TextStyle(
//       //           fontSize: 10,
//       //           backgroundColor: Colors.white,
//       //           color: Colors.brown),
//       //     )),
// // IconButton(icon: Icon(Icons.store,size: 35,), onPressed: (){
// //   Navigator.push(
// //     context,
// //     MaterialPageRoute(
// //         builder: (context) =>
// //         //    Test4(Parm_Id: 214,)
// //         TestRec_Pay_Print(Parm_Id: 11,printType: "Recpt",)
// //
// //     ),
// //   );
// // })
//
//
//
//
//
//
//
//     Button_List(
//         name: "Purchase",
//         mainIcon: Icons.add_business,
//         routAddPage:Purchase( passvalue: null,passname: null.toString()),
//         routListPage: Purchase_Index(),
//     ),
//
//
//     Button_List(
//         name: "Sales",
//         mainIcon: Icons.shopping_cart,
//         routAddPage:Newsalespage(
//           passvalue: null,
//           passname: null.toString(),
//         ),
//         routListPage: salesindex(),
//     ),
//
//
//
//     Button_List(
//         name: "Purchase Return",
//         mainIcon: Icons.assignment_return_outlined,
//         routAddPage:PurchaseReturn(
//         passvalue: null,
//         passname: null.toString(),
//          ),
//         routListPage: PurchaseReturn(
//           passvalue: null,
//           passname: null.toString(),
//         ),
//     ),
//
//
//
//     Button_List(
//         name: "Sales Return",
//         mainIcon: Icons.assignment_return_outlined,
//         routAddPage:SalesReturn(
//     passvalue: null,
//     passname: null.toString(),
//     ),
//         routListPage: SalesReturn(
//           passvalue: null,
//           passname: null.toString(),
//         ),
//     ),
//
//
//
//
//     ],);
//
//
//   }