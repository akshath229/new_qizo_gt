// import 'package:device_info/device_info.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_app/urlEnvironment/urlEnvironment.dart';
//
// void main() => runApp(const MaterialApp(home: MyApp()));
//
// class MyApp extends StatefulWidget {
//   const MyApp({Key key}) : super(key: key);
//   @override
//   _MyAppState createState() => _MyAppState();
// }
// class _MyAppState extends State<MyApp> {
//   TextEditingController DeviceIdController = TextEditingController();
//   String deviceId;
//
//   @override
//   void initState() {
//     print("in");
//     _getId();
//     print(Env.baseUrl);
//     super.initState();
//   }
//   _getId() async {
//     deviceId = await deviceInfo();
//     // deviceId = await DeviceId.getID;
//     deviceId= deviceId.substring(5, 11);
//     print("Device Id : " + deviceId);
//   }
//   deviceInfo() async {
//     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//     print(androidInfo.version.codename);
//     print(androidInfo.type);
//     print(androidInfo.androidId);
//     print(androidInfo.device);
//     print(androidInfo.manufacturer);
//     print(androidInfo.host);
//     print(androidInfo.brand);
//     print(androidInfo.model);
//     print(androidInfo.version.release);
//     return androidInfo.id;
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.teal,
//           centerTitle: true,
//           automaticallyImplyLeading: false,
//           title: Text(
//             'Qizo GT',
//           ),
//         ),
//      body:Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//
//             const  Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//               child: Text("Device id is :"),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//               child: Text("$deviceId"),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//               child: TextField(
//                 controller: DeviceIdController,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: 'Enter a search term',
//                 ),
//               ),
//             ),
//
//             ElevatedButton(
//               child: Text('Save'),
//               style: ElevatedButton.styleFrom(
//                 primary: Colors.teal,
//                 textStyle: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontStyle: FontStyle.normal),
//               ),
//               onPressed: () {
//                 save();
//               },
//             ),
//           ],
//         )
//     )
//     );
//   }
//   save(){
//     print(DeviceIdController.text + ((int.parse(deviceId) * 16) * 17).toString());
//     if(DeviceIdController.text == ((int.parse(deviceId)* 16)* 17).toString())
//       {
//         print("nothing");
//       }
//     else{
//       print("nononothing");
//     }
//   }
// }


///...............................................................................................
///................................curently working...................................................
///
///
///
///
// import 'dart:convert';
//
// import 'package:device_info/device_info.dart';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:new_qizo_gt/technicianhome.dart';
// import 'package:new_qizo_gt/urlEnvironment/urlEnvironment.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'AQizo_RMS/New_Delivery_App/Del_DeliveryMan_Login.dart';
// import 'AQizo_RMS/New_Delivery_App/Del_ItemHome.dart';
// import 'AQizo_RMS/New_Delivery_App/Del_Model/New_DeliveryPage.dart';
// import 'AQizo_RMS/RMS_Home2.dart';
// import 'frontPage.dart';
// import 'godownuserhome.dart';
// import 'login.dart';
// import 'models/userdata.dart';
//
// String deviceId = '';
//
// int RegKey = 1;
// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//     statusBarColor: Colors.teal,
//   ));
//   WidgetsFlutterBinding.ensureInitialized();
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   print(deviceId);
//   RegKey = prefs.getInt('Regkey')!;
//   print( "RegKey"  +  RegKey.toString());
//   runApp(MyApp());
// }
//
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//   dynamic user;
//
//   @override
//   void initState() {
//
//     setState(() {
//       print("..........");
//       print("${Env.baseUrl}");
//       print("..........");
//       config();
//     });
//
//     super.initState();
//   }
//
//
//   Future selectNotification(String? payload) async {
//     if (payload != null) {
//       debugPrint('notification payload: ' + payload);
//       print("message read Success");
//     } else {
//       print("not read msg");
//     }
//   }
//
//   config() async {
//     var initializationSettingsAndroid =
//     AndroidInitializationSettings('@mipmap/launcher_icon');
//     var initializationSettingsIOS = IOSInitializationSettings();
//     var initializationSettings = InitializationSettings(
//         android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: selectNotification);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       routes: {
//
//         "/logout": (_) => new Login(),
//         "Home": (_) => new Rms_Homes2(username: user.user['userType'].toString()),
//       },
//       home: RegKey != 0 ? onBoard() : FutureBuilder<SharedPreferences>(
//           future: SharedPreferences.getInstance(),
//           builder: (c,s){
//             if(!s.hasData) return Center(child: CircularProgressIndicator());
//             print(s.data?.containsKey("userData"));
//
//             //------------------Changed adt and others-----------------------------------
//             //-------------------------------------------------------------------------------
//             if(s.data!.containsKey("userData")){
//               try {
//
//                 user =
//                     UserData.fromJson(json.decode(s.data!.getString('userData')));
//                 print("json.encode(user)");
//                 print(json.encode(user));
//                 var aptyp=user.appType;
//                 print("---------$aptyp------");
//                 print("---------${user.user['userType']}------");
//                 print(aptyp.runtimeType);
//                 if (Env.baseUrl == "http://erptestapi.qizo.in:811/api/") {
//                   print("api direct to adt home");
//                   return Login();
//                 }
//                 if (user.user['userType'] == 'Technician') return TechnicianHome();
//
//                 ///.....................only for delivery man login .........................................
//                 if (aptyp == 'RMSDelivery' && user.user['userType'].toString().toLowerCase()=="delivery" ) return Del_Login_DeliveyMan();
//                 if (aptyp == 'RMSDelivery' && user.user['userType'].toString().toLowerCase()=="counter" )
//                   return  Del_Qr_Rreader2(Del_Man_Id: user.user["loginedEmployeeId"]);
//                 ///.....................only for delivery man login .........................................
//                 if (aptyp == 'RMSDelivery' && user.user['userType'].toString().toLowerCase()=="sales" ) return Del_ItemHome();
//                 if (aptyp == 'GT') return Rms_Homes2(username: user.user['userType'].toString());
//                 if (user.user['userType'] == 'Godown') return GoDownUserHome();
//               }catch(e){
//                 print("error on auto login $e");
//                 return Login();
//               }
//             }
//             return Login();
//           }
//       ),
//       debugShowCheckedModeBanner: false,
//       title: 'Qizo GT',
//       theme:ThemeData.light(),
//     );
//
//   }
// }


///.............................................................................................................
// import 'package:flutter/material.dart';
// import 'package:flutter_app/home.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Thermal Printer',
//       home: Home(),
//     );
//   }
// }


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

String deviceId = '';

int RegKey = 1;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.teal, // status bar color
  ));
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print(deviceId);
  RegKey = prefs.getInt('Regkey')!;
  print( "RegKey"  +  RegKey.toString());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  dynamic user;

  @override
  void initState() {
    setState(() {
      print("..........");
      config();
    });
    super.initState();
  }

  Future selectNotification(String? payload) async {
    debugPrint('notification payload: ' + (payload ?? ''));
    if (payload != null) {
      print("message read Success");
    } else {
      print("not read msg");
    }
  }

  config() async {
    var initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/launcher_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(), // Added this to resolve a minor issue in the provided code. Please replace with your actual Widget.
      debugShowCheckedModeBanner: false,
      title: 'Qizo GT',
      theme: ThemeData.light(),
    );
  }
}

