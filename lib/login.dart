import 'dart:ui';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:new_qizo_gt/urlEnvironment/DynamicUrl.dart';
import 'package:new_qizo_gt/urlEnvironment/urlEnvironment.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'AQizo_RMS/New_Delivery_App/Del_DeliveryMan_Login.dart';
import 'AQizo_RMS/New_Delivery_App/Del_ItemHome.dart';
import 'AQizo_RMS/New_Delivery_App/Del_Model/New_DeliveryPage.dart';
import 'AQizo_RMS/RMS_Home2.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
//  var _formKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController inputController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController CmpnyNameController = TextEditingController();
  TextEditingController UserIdController = TextEditingController();

  int branchId = 0;
  late String branchName;
  late Map _mySelection;
  String loginType = "";
  bool _validate = true;
  bool CompanyIdvalidate = true;
  bool branchSelect = false;
  late String deviceId;
  bool showProgress = true;
  dynamic Companyid=0;
  dynamic CompanyName="";
  static SharedPreferences? pref;
  dynamic prs;
  Color PrPasswordbutton = Colors.white;
  Color PrUNamebutton = Colors.white;

// bool  IsDriver=false;// for delivery app
//  final String loginApi = "http://testcoreapi.qizo.in:811/api/Login";
//  final String url = "http://testcoreapi.qizo.in:811/api/MCompanyProfiles/";

  List data = []; //edited line

  Future<String> getSWData() async {
    try {

      var res = await http
          .get(Uri.encodeFull("${Env.baseUrl}MCompanyProfiles") as Uri, headers: {
        "Accept": "application/json",
      });
      print(("${Env.baseUrl}MCompanyProfiles"));
      print("res.body");
      print(res.body.toString());
      print(res.statusCode);
      var resBody = json.decode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        // prs.hide();
     //   if (!mounted) return null;
        if (this.mounted) {
        setState(() {
          data = resBody;
          print("data : $data");
        });}
        //print(resBody);
        print("success");
        showProgress = false;
        return "Sucess";
      }


    }catch(e){
      print("error on getSWData : $e");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.black,
            width: 250,
            behavior: SnackBarBehavior.floating,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            duration: Duration(seconds:3),
            content: Text("Server Error Please Try Again Later...",
              style: TextStyle(color: Colors.white, fontSize: 13,),
              textAlign: TextAlign.center,),
          ));
      if (this.mounted) {
        setState(() {
          showProgress = false;
        });
      }

    }
  }

  @override
  void initState() {
    print("in");
    _getId();
    print(Env.baseUrl);
    // prs.show();
    getSWData();

    super.initState();
  }

  _getId() async {
    deviceId = await deviceInfo();

    // deviceId = await DeviceId.getID;
    // deviceId= deviceId.substring(5, 11);
    deviceId=  deviceId.replaceAll(new RegExp(r'[^0-9]'),'');
    print("Device Id : " + deviceId);
  }

  deviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print(androidInfo.version.codename);
    print(androidInfo.type);
    print(androidInfo.androidId);
    print(androidInfo.device);
    print(androidInfo.manufacturer);
    print(androidInfo.host);
    print(androidInfo.brand);
    print(androidInfo.model);
    print(androidInfo.version.release);

    print("the device info is " + androidInfo.id.toString());

    return androidInfo.id;
  }


  //--------getcompany details with email or ph num---------
  getcompany(id)async{
    print(Env.baseUrl.toString());
    if(id ==""){
       id="nill";
    }
    print(id);


      try {
        final res = await http.get("${Env.baseUrl}MCompanyProfiles/1/1/$id" as Uri, headers: {
               "Accept": "application/json",
        });
        var tagsJson = json.decode(res.body);

        var compnydata=tagsJson["mCompanyProfile"];
        print(compnydata);



        if(compnydata.isEmpty) {
          setState(() {
            print("in");
            CompanyIdvalidate=false;
            CmpnyNameController.text="";
          });

          return;
        }
        else{ print("out");
        setState(() {
          print("getcompany name :");
           CompanyName = compnydata[0]["companyProfileName"];
           Companyid = compnydata[0]["companyProfileId"];
          print("CompanyName :" + CompanyName);
          CmpnyNameController.text=CompanyName.toString();
          CompanyIdvalidate=true;

        });


        }



      } catch (e) {
        print("error on getcompany : $e");
      }
    }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          exit(0);
        });

        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Text(
              'Qizo GT',
            ),
          ),
          body: Container(
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: showProgress
                          ? Container(
                        height: 500,
                        child: Center(child: CircularProgressIndicator(
                        )),
                      )
                          : ListView(
                        children: <Widget>[
                          Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10),
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => DynamicUrlEdit()),
                                  );
                                },
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 30),
                                ),
                              )),

  //------------------------------------strt-------------------------------------------------------


                          Container(
                            padding: EdgeInsets.all(10),
                            child: TextField(
                              controller: UserIdController,

                    onTap: (){
                                setState(() {
                                  PrPasswordbutton = passwordController.text=="" ? Colors.white : Colors.black26;
                                  PrUNamebutton    = userNameController.text=="" ? Colors.white : Colors.black26;
                                });
                                },


                    onSubmitted: (a){
                      getcompany(a.toString());
                    },
                              decoration: InputDecoration(
                                suffixIcon:IconButton(
                                  onPressed: (){
                                    CmpnyNameController.text="";
                                    getcompany(UserIdController.text);

                                  },
                                  icon: Icon(Icons.search_rounded),
                                ),
                                errorStyle: TextStyle(
                                  color: Colors.red,
                                  fontSize: 15.0,
                                ),
                                border: OutlineInputBorder(),
                                isDense: true,
                                labelText: 'Company ID',
                                errorText:CompanyIdvalidate ==false ? "Invalid 'Email/Mobile No" : null,

                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: TextField(enabled: false,
                              controller: CmpnyNameController,
                              decoration: InputDecoration(
                                errorStyle: TextStyle(
                                  color: Colors.brown,
                                  fontSize: 15.0,
                                ),
                                border: OutlineInputBorder(),
                                labelText: 'Company',
                                errorText:
                                !_validate ? 'Invalid Company!' : null,
                              ),
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.all(10),
                            child: TextField(
                              onTap: (){
                                setState(() {
                                  PrPasswordbutton = passwordController.text=="" ?
                                  Colors.white : Colors.black26;
                                  PrUNamebutton=Colors.blue;


                                  if(UserIdController.text != ""){
                                      getcompany(UserIdController.text);
                                    }
                                });

                              },
                              controller: userNameController,
                              decoration: InputDecoration(
                                suffixIcon:IconButton(
                                  onPressed: (){
                                    userNameController.text="";
                                  },
                                  icon: Icon(Icons.clear,color: PrUNamebutton,),
                                ),
                                errorStyle: TextStyle(
                                  color: Colors.brown,
                                  fontSize: 15.0,
                                ),
                                border: OutlineInputBorder(),
                                labelText: 'User Name',
                                errorText:
                                    !_validate ? 'Invalid Username!' : null,
                              ),
                            ),
                          ),




                          Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: TextField(
                              onTap: (){
                                setState(() {
                                  PrPasswordbutton=Colors.blue;
                                  PrUNamebutton = userNameController.text=="" ?
                                  Colors.white : Colors.black26;
                                  if(UserIdController.text != ""){
                                    getcompany(UserIdController.text);
                                  }
                                });

                              },
                              obscureText: true,
                              controller: passwordController,
                              decoration: InputDecoration(
                                suffixIcon:IconButton(
                                  onPressed: (){
                                    passwordController.text="";
                                  },
                                  icon: Icon(Icons.clear,color:PrPasswordbutton,),
                                ),
                                border: OutlineInputBorder(),
                                labelText: 'Password',
                                errorStyle: TextStyle(
                                  color: Colors.brown,
                                  fontSize: 15.0,
                                ),
                                errorText:
                                    !_validate ? 'Invalid Password!' : null,
                              ),
                            ),
                          ),



                          SizedBox(height: 10,),
                          Container(
                            height: 50,
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Builder(
                              builder: (c) {
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.teal, // background color
                                    onPrimary: Colors.white, // text color
                                  ),
                                  child: Text('Login'),
                                  onPressed: () {
                                    print(Env.baseUrl);
                                    if (CmpnyNameController.text == "") {
                                      ScaffoldMessenger.of(c).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Please choose a branch.",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      );
                                    }

                                    if (userNameController.text == '') {
                                      ScaffoldMessenger.of(c).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "invalid Username is Empty",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      );
                                    }
                                    if (passwordController.text == '') {
                                      ScaffoldMessenger.of(c).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "invalid Password is Empty",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      );
                                    } else {
                                      loginRequest();
                                    }
                                  },
                                );

                              },
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                        ],
                      )))),
    );
  }



  Future loginRequest() async {
    EasyLoading.show(status: 'Loading Data...');

    print("Starting request");
    var username = userNameController.text.toString().trim();
    var password = passwordController.text.toString().trim();

    print("username: $username");
    print("password: $password");

    branchName = CompanyName.toString();

    print("branch name: $branchName");

    var map = {
      "userUserName": username,
      "userPassword": password,
      "userBranchId": Companyid.toString()
    };

    var params = json.encode(map);
    print("Login params: $params");
    print(Env.baseUrl);

    var response = await http.post("${Env.baseUrl}login" as Uri,
        headers: {
          'accept': 'application/json',
          'content-type': 'application/json'
        },
        body: params);

    var userData = {
      "deviceId": deviceId,
      "BranchName": branchName,
      "BranchId": Companyid.toString(),
      "user": json.decode(response.body),
      "password": password,
    };

    setState(() {
      branchId = int.parse(userData["BranchId"]);
      print("branchId: $branchId");

      loginType = "technician";

      if (response.statusCode == 200) {
        _validate = true;
        print("login response: ${userData['user']['userType']}");
        print("Validation: $_validate");

        GetProjType(
          token: userData['user']['token'],
          BranchId: Companyid.toString(),
          BranchName: branchName,
          deviceId: deviceId,
          user: json.decode(response.body),
          password: password,
          usertyp: userData['user']['userType'],
        );

        /// Other processing...

        EasyLoading.dismiss();
      } else {
        _validate = false;
        print("Error in login: $_validate");
        EasyLoading.showError('Error in login');
      }
    });
  }

  GetProjType({
    token,
  deviceId,
  BranchName,
  BranchId,
  user,
  password,
    usertyp
})async{
    print("GetProjType");
    var res = await http.get("${Env.baseUrl}generalSettings" as Uri,
        headers: {'Authorization':token});
    print(res.statusCode);
    if (res.statusCode < 210) {
      print("GetProjType sucess");
      print(res.body);
      var result =[];
      result= json.decode(res.body);
      print(result[0]["applicationType"]);
      if(result[0]["applicationType"]=="RMS"||
          result[0]["applicationType"].toString().toLowerCase().contains("rms"))
      {
        var userData = {
          "deviceId": deviceId,
          "BranchName": BranchName,
          "BranchId": BranchId,
          "user": user,
          "password":password,
          "appType":result[0]["applicationType"],
          "user_typ":usertyp
        };
        print("userData");
        print(userData);
        print("password");
        print(user["userId"].toString());
        pref = await SharedPreferences.getInstance();
        pref?.setString("userData", json.encode(userData));
      if(result[0]["applicationType"].toString().toLowerCase()=="rmsdelivery") {
        print("sdfsf " + usertyp.toString().toLowerCase());
        if (usertyp.toString().toLowerCase() == "delivery") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>
                Del_Login_DeliveyMan(Token: token, pref: pref,)
            ),
          );
        }
        else if (usertyp.toString().toLowerCase() == "counter") {

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                Del_Qr_Rreader2(Del_Man_Id: user["loginedEmployeeId"])),
          );

        }
        else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>
            // Rms_Homes()
            Del_ItemHome()
            ),
          );
        }
      }else{
        Navigator.push(
          context,
           MaterialPageRoute(builder: (context) => Rms_Homes2(username: usertyp.toString())),
          // MaterialPageRoute(builder: (context) => LocalDb_Test()),
        );
      }
      }
      else
{
  var userData = {
    "deviceId": deviceId,
    "BranchName": BranchName,
    "BranchId": BranchId,
    "user": user,
    "password":password,
    "appType":result[0]["applicationType"],
    "user_typ":usertyp
  };
  print("userData");
  print(userData);
  print("passwsddsord");
  print(password);
  pref = await SharedPreferences.getInstance();
  pref?.setString("userData", json.encode(userData));
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Rms_Homes2(username: usertyp.toString())),
     // MaterialPageRoute(builder: (context) => LocalDb_Test()),
    );
}
    }

  }
}
