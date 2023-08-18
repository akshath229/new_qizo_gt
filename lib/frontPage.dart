import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:new_qizo_gt/urlEnvironment/urlEnvironment.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import 'main.dart';
class onBoard extends StatefulWidget {
  const onBoard({required Key key}) : super(key: key);
  @override
  _OnBoardState createState() => _OnBoardState();
}
class _OnBoardState extends State<onBoard> {
  TextEditingController DeviceIdController = TextEditingController();
  TextEditingController DataController = TextEditingController();
  @override

  void initState() {
    print("in");
      _getId();
    print(Env.baseUrl);
    super.initState();
  }

  _getId() async {


    deviceId = await deviceInfo();
    // deviceId = await DeviceId.getID;
    print("the length of teh device is " + deviceId.length.toString());
    if(deviceId.length<11){

      deviceId= deviceId.replaceAll(new RegExp(r'[^0-9]'),'');
      DataController.text=deviceId;
      print("Device Id : " + deviceId);
    }
    else{
      deviceId= deviceId.substring(5, 11);
      DataController.text=deviceId;
      print("Devggice Id : " + deviceId);
    }

  }

  deviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print(androidInfo.version.codename);
    print(androidInfo.type);
    print("the android id is " + androidInfo.androidId);
    print(androidInfo.device);
    print(androidInfo.manufacturer);
    print(androidInfo.host);
    print(androidInfo.brand);
    print(androidInfo.model);
    print(androidInfo.version.release);
    print("theee adsadf " + androidInfo.id.toString());

    return androidInfo.id;
  }
  @override
  Widget build(BuildContext context) {
    print("the device id is" + deviceId.toString());
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            'Qizo GT',
          ),
        ),
        body:Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
              Row( mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:[
                Text("PIN", style: TextStyle(fontSize:30, decoration: TextDecoration.underline,)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: SizedBox(
                    width: 150.0,
                    height: 80.0,
                    child: TextField(
                    readOnly: true,
                    controller: DataController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                        style: TextStyle(fontSize: 30)
                  ),
                  ),
                ),
                ]),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextField(

                    controller: DeviceIdController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Serial Key',
                    ),
                      style: TextStyle(fontSize: 25)
                  ),
                ),
        SizedBox(
          width: 180, // <-- Your width
          height: 75,
               child: ElevatedButton(
                  child: Text('Register'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal,
                    textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontStyle: FontStyle.normal),
                  ),
                  onPressed: () {
                    save();
                  },
                ),
        )
              ],
            )
        )
    );
  }
  save(){
    print(DeviceIdController.text + ((int.parse(deviceId) * 16) * 17).toString());
    if(DeviceIdController.text == ((int.parse(deviceId)* 16)* 17).toString())
    {
      CheckRegistration();
    }
    else{
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Center(
                child: Text(
                  "Invalid Key",
                  style: TextStyle(color: Colors.red),
                )),
          ));
    }
  }
  CheckRegistration() async {
    print("Shared pref called");
    int RegKey=0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('Regkey', RegKey);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }
}