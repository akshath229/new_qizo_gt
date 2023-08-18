import 'dart:convert';

import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:new_qizo_gt/urlEnvironment/urlEnvironment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'appbarWidget.dart';
import 'models/customersearch.dart';
import 'models/userdata.dart';
import 'models/usersession.dart';


class Set_Cust_Location extends StatefulWidget {
  @override
  _Set_Cust_LocationState createState() => _Set_Cust_LocationState();
}

class _Set_Cust_LocationState extends State<Set_Cust_Location> {


  static List<Customer> users = [];



  late String branchName;
  dynamic userName;
  dynamic user_ID;
  late UserSession usr;
  late SharedPreferences pref;
  dynamic user;
  late String token;
var customer_Id=null;
bool customerSelect=false;
  TextEditingController customerController= TextEditingController();


  void initState() {
    SharedPreferences.getInstance().then((value) {
      pref = value;
      read();
      getCustomer();
     // Get_LocationPermissionSatus();
    });
  }




  read() async {
    var v = pref.getString("userData");
    print("USER DATA: $v");
    var c = json.decode(v!);

    user = UserData.fromJson(c); // token gets this code user.user["token"]

    setState(() {
      print("user data................");
       print(user.user["userId"].toString());
       user_ID=user.user["userId"];
      token = user.user["token"]; //  passes this user.user["token"]
      pref.setString("customerToken", user.user["token"]);
      branchName = user.branchName;
      userName = user.user["userName"];
      print(branchName);
      print(userName);
      print("....................");
    });
  }




  getCustomer() async {
    try {
      final response =
      await http.get("${Env.baseUrl}${Env.CustomerURL}" as Uri, headers: {
        "Authorization": user.user["token"],
      });
      print(response.statusCode);

      if (response.statusCode == 200) {
        print('...................');
        Map<String, dynamic> data = json.decode(response.body);
        print("array is");
        print(data["lst"]); //used  this to autocomplete
        print("........");
        users = (data["lst"] as List)
            .map<Customer>((customer) =>
            Customer.fromJson(Map<String, dynamic>.from(customer)))
            .toList();
//        users=loadUsers(s.toString());
        return users;
      } else {
        print("Error getting users");
      }
    } catch (e) {
      print("Error getting users");
    }
  }


Rqst_LocationPerinsion(){
print("oooooooooooooooooooo");

showDialog(context: context, builder: (context) =>

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
          AndroidIntent intent = AndroidIntent(
            action: 'android.settings.LOCATION_SOURCE_SETTINGS',
          );
          intent.launch();
          Navigator.of(context, rootNavigator: true).pop();
          // _gpsService();
        },
      )

    ],
  ));

}



  Future<bool> getLocationPermissionStatus() async {
    LocationPermission permission = await Geolocator.checkPermission();
    print("permission status---");
    print(permission);

    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      await requestLocationPermission();
      return false;
    } else {
      return true;
    }
  }

  Future<void> requestLocationPermission() async {
    await Geolocator.requestPermission();
  }





  Set_Current_Location()async{

// var PermissionSts= await Get_LocationPermissionSatus();

 bool    PermissionSts=true;
if (PermissionSts==true){

var Location="";


    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

// print(position.latitude);
// print(position.longitude);



  List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
  print(placemarks.toString());
  placemarks.forEach((element) {
    Location = element.locality.toString();
  });



    PostCust_Location(position.latitude,position.longitude,Location);

}
else{

  //Get_LocationPermissionSatus();

}
  }





  PostCust_Location(lan,lon,location)async{


    var prms={

      "custId": customer_Id,
      "latitude": lan,
      "longitude": lon,
      "locationTxt":location,
      "userId": user_ID,


    };

    var params = json.encode(prms);
     print(params);


    var res = await http.post("${Env.baseUrl}customerlocations" as Uri,
        headers: {
          'accept': 'application/json',
          'content-type': 'application/json',
          'Authorization': user.user['token']
        },
        body: params);
    print(res.body);
    print(res.statusCode);
    if(res.statusCode==200||res.statusCode==201){
setState(() {
  customer_Id=null;
  customerController.text="";
});


      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "Success",
              style: TextStyle(color: Colors.indigo),
            ),
          ));
    }

  }




  GetLocation()async{

    final response =
        await http.get("${Env.baseUrl}customerlocations/$customer_Id/cust" as Uri, headers: {
      "Authorization": user.user["token"],
    });
if(response.statusCode==200){


  print(response.body);

  var res=json.decode(response.body);
  if(res["custlocation"].toString()=="[]"){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Can't Find Location..!",
            style: TextStyle(color: Colors.red),
          ),
        ));
    return;

  }



  print(res["custlocation"].length.toString());
  var i=res["custlocation"].length-1;
  print(res["custlocation"][i]["latitude"]);

  var lan=res["custlocation"][i]["latitude"];
  var lon=res["custlocation"][i]["longitude"];

//ShowLocation(lan:lan,lon:lon);

}

  }
  ShowLocation({lan,lon})async{


      var uri = Uri.parse("google.navigation:q=$lan,$lon");
      if (await canLaunch(uri.toString())) {
        await launch(uri.toString());
      } else {
        throw 'Could not launch ${uri.toString()}';
      }

  }





  ///--------------------------------
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        appBar: PreferredSize(
            preferredSize: Size.fromHeight(190.0),
            child:Appbarcustomwidget(uname: userName, branch: branchName, pref: pref, title: "INDEX")
        ),


        body: Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(height:50,
                  width: 500,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 8, 0),
                    child: TypeAheadField(
                        hideOnEmpty: true,
                        textFieldConfiguration: TextFieldConfiguration(
                            style: TextStyle(),
                            controller: customerController,
                            decoration: InputDecoration(
                              errorStyle: TextStyle(color: Colors.red),
                              errorText: customerSelect
                                  ? "Please Select Customer ?"
                                  : null,
//                            errorText: _validateName ? "please enter name" : null,
//                            errorBorder:InputBorder.none ,
                              suffixIcon: IconButton(
                                icon: Icon(Icons.remove_circle),
                                color: Colors.blue,
                                onPressed: () {
                                  setState(() {
                                    print("cleared");
                                    customerController.text = "";
                                    customer_Id = null;

                                  });
                                },
                              ),

                              isDense: true,
                              contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              // i need very low size height
                              labelText:
                              'customer search', // i need to decrease height
                            )),
                        suggestionsBoxDecoration:
                        SuggestionsBoxDecoration(elevation: 90.0),
                        suggestionsCallback: (pattern) {
                          return users.where((user) =>
                              user.lhName.toUpperCase().contains(pattern.toUpperCase()));
                        },
                        itemBuilder: (context, suggestion) {
                          return Card(
                            color: Colors.blue,
                            child: ListTile(
                              tileColor: Colors.teal,
                              title: Text(
                                suggestion.lhName,
                                style: TextStyle(color: Colors.white
                                ),
                              ),
                            ),
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          print(suggestion.lhName);
                          print("selected");

                          customerController.text = suggestion.lhName;
                          print("close.... $customer_Id");

                          print(suggestion.id);
                          print(".......sales Ledger id");
                          setState(() {
                            customer_Id = suggestion.id;
                          });

                          print(customer_Id);
                          print("...........");
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
                                  parent: animationController!,
                                  curve: Curves.elasticIn),
                            )),
                  ),
                ),


                Row(
                  children: [
                    SizedBox(width: 20,),
                    Visibility(
                      visible: customer_Id!=null,
                      child: ElevatedButton(onPressed: (){

                        Set_Current_Location();
                      }, child: Text("Set Location")),
                    ),

                    SizedBox(width: 20,),

                    Visibility(
                      visible: customer_Id!=null,
                      child: ElevatedButton(onPressed: (){

                        GetLocation();
                      }, child: Text("Show Location")),
                    ),
                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}






