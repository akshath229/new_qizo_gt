import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:android_intent/android_intent.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:new_qizo_gt/salesloading.dart';
import 'package:new_qizo_gt/urlEnvironment/urlEnvironment.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'documentmovementindex.dart';
import 'models/userdata.dart';

class GoDownUserHome extends StatefulWidget {
  @override
  _GoDownUserHomeState createState() => _GoDownUserHomeState();
}

class _GoDownUserHomeState extends State<GoDownUserHome> {
  dynamic user;
  late SharedPreferences pref;
  dynamic token;
  dynamic longitude;
  dynamic latitude;
  dynamic branchName;
  dynamic userName;
  dynamic locality;
  dynamic prog;

  @override
  void initState() {
    setState(() {
      print("Godown User Home...............");
      SharedPreferences.getInstance().then((value) {
        pref = value;
        read();
      });

      super.initState();
    });
  }

  @override
  void dispose() {
    // TODO: Add code here
    super.dispose();
  }

  late int count;
  List<String> options = [
    'Sales Loading ',
    'Document',
    'Messages',
    // 'Pending Job'
  ];

  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => false,
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(190.0),
            child: Container(
              height: 60,
              color: Colors.blue,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
//                    SizedBox(width: 10,),

                      GestureDetector(
                          onTap: () {
                            print("hi");
                          },
                          child: Container(
                            margin: new EdgeInsets.only(
                                left: 0.0, top: 25.0, right: 0.0, bottom: 0.0),
                            child: Text(
                              "${branchName.toString()}",
                              style:
                                  TextStyle(fontSize: 13, color: Colors.white),
                            ),
                          )),
                      GestureDetector(
                        onTap: () {
                          print("hi");
                        },
                        child: Text(
                          "Godown  Home",
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            Widget noButton = TextButton(
                              child: Text("No"),
                              onPressed: () {
                                setState(() {
                                  print("No...");
                                  Navigator.pop(context);
                                  // this is proper..it will only pop the dialog which is again a screen
                                });
                              },
                            );
                            Widget yesButton = TextButton(
                              child: Text("Yes"),
                              onPressed: () {
                                setState(() {
                                  print("yes...");
                                  pref.remove('userData');
                                  Navigator.pop(context);
                                  Navigator.pushReplacementNamed(
                                      context, "/logout");
                                });
                              },
                            );
                            showDialog(
                                context: context,
                                builder: (c) => AlertDialog(
                                    content:
                                        Text("Do you really want to logout?"),
                                    actions: [yesButton, noButton]));
                          });
                        },
                        child: Container(
                          margin: new EdgeInsets.only(
                              left: 0.0, top: 25.0, right: 0.0, bottom: 0.0),
                          child: Text(
                            "${userName.toString()}",
                            style: TextStyle(fontSize: 13, color: Colors.white),
                          ),
                        ),
//
                      )
                    ]),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: SizedBox(
              // height: double.maxFinite,
              height: 800,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: SizedBox(
                            height: (MediaQuery.of(context).size.width / 3.5) -
                                16.0,
                            child:ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.lightBlue,  // Button's background color
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),  // Button's padding
                                onPrimary: Colors.white,  // Color for text and icons
                              ),
                              onPressed: () {
                                setState(() {
                                  _gpsServiceCheck();
                                });
                              },
                              child: Text(
                                "Mark Attendance",
                                style: TextStyle(fontSize: 15.0),
                              ),
                            )

                          ),
                        ),
                        GridView.builder(
                          itemCount: options.length,
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 2,
                          ),
                          itemBuilder: (c, i) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.lightBlue,  // The background color of the button
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),  // Padding for the button
                                onPrimary: Colors.white,  // The color for text or icons
                              ),
                              onPressed: () {
                                print("index :  $i");
                                setState(() {
                                  checkgps(i);
                                });
                              },
                              child: Text(
                                options[i],
                                style: TextStyle(fontSize: 15.0),
                              ),
                            );

                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        )));
  }

  read() async {
    var v = pref.getString("userData");
    print("USER DATA: $v");
    var c = json.decode(v!);
    user = UserData.fromJson(c); // token gets this code user.user["token"]

    setState(() {
      print("user data................");
      print(user.user["token"]);
      token = user.user["token"]; //  passes this user.user["token"]
      pref.setString("customerToken", user.user["token"]);
      branchName = user.branchName;
      userName = user.user["userName"];
      print(".....");
      print(branchName);
      print(userName);
    });
    pref.setString("customerToken", user.user["token"]);
//    getCustomer();
//    showDialog(
//        context: context,
//        builder: (context) => AlertDialog(
//              title: Text("data:   " + user.branchName),
//              content: Text("user data:   " + user.user["token"]),
//            ));
  }

  /*Show dialog if GPS not enabled and open settings location*/
  Future _checkGps() async {
    if (!(await Geolocator().isLocationServiceEnabled())) {
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

  Future _gpsServiceCheck() async {
    if (!(await Geolocator.isLocationServiceEnabled())) {
      _checkGps();
      print("Not ok");

      return null;
    } else
      print("ok");
    _getLocation();
    return true;
  }

  Future checkgps(int i) async {
    if (!(await Geolocator.isLocationServiceEnabled())) {
      _checkGps();
      print("Not ok");

      return null;
    } else {
      if (i == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SalesLoading()),
        );
      }
      if (i == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DocumentMovementIndex()),
        );
      }
      if (i == 2) {
//                                Navigator.push(
//                                  context,
//                                  MaterialPageRoute(
//                                      builder: (context) => JobSheet()),
//                                );
      }
      if (i == 3) {
//                                Navigator.push(
//                                  context,
//                                  MaterialPageRoute(
//                                      builder: (context) => JobPending()),
//                                );

        // Navigator.push(
        //     context, MaterialPageRoute(builder:
        //     (context) => DocumentMovementIndex()));
      }
      return true;
    }
  }

  _getLocation() async {
    prog = new ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: true,
      showLogs: true,
    );
    prog.style(
      message: "Loading ....", //
//      progress: 0.0,
//      maxProgress: 100.0,
    );
    prog.show();
    GeolocationStatus geolocationStatus =
        await Geolocator().checkGeolocationPermissionStatus();
    print(geolocationStatus);

    Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
    print(geolocator);
    Position position = await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//    debugPrint('${position}');
    debugPrint('location: ${position.latitude}');
    print("latitude :");
    print(position.latitude);
    longitude = position.longitude;
    latitude = position.latitude;

//    {this.name,
//    this.isoCountryCode,
//    this.country,
//    this.postalCode,
//    this.administrativeArea,
//    this.subAdministrativeArea,
//    this.locality,
//    this.subLocality,
//    this.thoroughfare,
//    this.subThoroughfare,
//    this.position});

    print("user..................");
    print(user.branchId);
    print(user.branchName);
    print("user..................");

    print("longitude:");
    print(position.longitude);
//    var id= json.encode(user["BranchId"]);
//    var c = user['BranchId'];

    markAttendance();
//    showAboutDialog();

//    final coordinates = new Coordinates(position.latitude, position.longitude);
//    var addresses = await geolocator.local.findAddressesFromCoordinates(coordinates);
//    var first = addresses.first;
//    print(first);
//    print("${first.featureName} : ${first.addressLine}");
  }

  markAttendance() async {
    List<Placemark> placeMark =
        await Geolocator().placemarkFromCoordinates(latitude, longitude);
    print(placeMark[0].locality);
    print(placeMark[0].country);
    print(placeMark[0].administrativeArea);
    print(placeMark[0].subLocality);
    print(placeMark[0].subAdministrativeArea);
    print(placeMark[0].position);
    print(placeMark[0].thoroughfare);
    print("maked");
    var req = {
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "locationText": placeMark[0].locality.toString(),
//      "userId": user.user['userId'],
//      "branchId": int.parse(user.branchId)
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
//    print(response.body);
    print(response.statusCode);
    print(response.body);
    setState(() {
      prog.hide();
    });
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
              builder: (context) => AlertDialog(
                    title: Text(ms),
//                 content: Text(locality.toString() +
//                     " , " +
//                     placeMark[0].administrativeArea +
//                     "," +
//                     "                         " +
//                     placeMark[0].country
// //                    ",Pin :" +
// //                    placeMark[0].postalCode +
// //                     " , " +
// //                     placeMark[0].thoroughfare
// //                    +
// //                    " , " +
// //                    placeMark[0].isoCountryCode
//                 ),
                  ));
        } else {
          ms = "Attendance Marked";

          print("not exist..");
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text(ms),
                    content: Text(locality.toString() +
                            " , " +
                            placeMark[0].administrativeArea +
                            "," +
                            "                         " +
                            placeMark[0].country +
//                    ",Pin :" +
//                    placeMark[0].postalCode +
                            " , " +
                            placeMark[0].thoroughfare
//                    +
//                    " , " +
//                    placeMark[0].isoCountryCode
                        ),
                  ));
        }

        // dynamic id = c['id'];
        // if (id > 0) {
        //   print("if.....");
        // } else {
        //   print("else");
        // }
      });
    }
  }
}
