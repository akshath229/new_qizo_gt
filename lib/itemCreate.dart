import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'models/usersession.dart';
import 'models/userdata.dart';



class itemCreate extends StatefulWidget {
  @override
  _itemCreateState createState() => _itemCreateState();
}

class _itemCreateState extends State<itemCreate> {

  late String branchName;
  dynamic userName;
  late UserSession usr;
  late SharedPreferences pref;
  dynamic user;
  late String token;
  bool itemSelect = false;
  bool rateSelect = false;

  TextEditingController itemController = new TextEditingController();
  TextEditingController rateController = new TextEditingController();


  void initState() {
    SharedPreferences.getInstance().then((value) {
      pref = value;
      read();
     // super.initState();
    });
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
  }


  validationRate() {
    if (itemController.text == "") {
      itemSelect = true;
      validationrate();
    } else {
      itemSelect = false;
      validationrate();
    }
  }


  validationrate(){
    if (rateController.text == "") {
      rateSelect = true;
      // validationrate();
    } else {
      rateSelect = false;
      // validationrate();
    }
  }



  itemSave(){
    setState(() {
      validationRate();
    });
if(rateController.text == "" || itemController.text == ""){
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("check fields"),
//              content: Text("user data:   " + user.user["token"]),
      ));
  return;

}
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Iteam Saved",
            style: TextStyle(color: Colors.blue),
          ),
//              content: Text("user data:   " + user.user["token"]),
        ));
    Resetfunction();
  }

  Resetfunction(){
    itemController.text="";
    rateController.text="";
    itemSelect = false;
    rateSelect = false;
    FocusScope.of(context).unfocus();
    rateController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(190.0),
        child: Container(
          height: 80,
          decoration: BoxDecoration(  gradient: new LinearGradient(
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
                                    style: TextStyle(fontSize: 10, color: Colors.red),
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
                            bottom: 15
                        ),
                        child: Column(children:[
                          SizedBox(height: 7,),
                          Expanded(
                            child: Text(
                              "Item Create",
                              style: TextStyle(fontSize: 22, color: Colors.white),
                            ),
                          ),


                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 7),
                              child: Text(
                                "${branchName.toString()}",
                                style: TextStyle(fontSize: 13, color: Colors.white),
                              ),
                            ),
                          ),
                        ])
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
                            print("yes...");pref.remove('userData');
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
                          builder: (c) => AlertDialog(
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
        ),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 10),

          Row(
            children: [
              SizedBox(width: 10),

              Expanded(
                  child: TextFormField(
                    controller: itemController,
                    enabled: true,
                    validator: (v) {
                      if (v!.isEmpty) return "Required";
                      return null;
                    },
//
                    cursorColor: Colors.black,

                    scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(

//                    suffixIcon: Icon(
//                      Icons.calendar_today,
//                      color: Colors.blue,
//                      size: 24,
//                    ),
                      errorStyle: TextStyle(color: Colors.red),
                      errorText: itemSelect ? "Invalid Item" : null,
                      isDense: true,
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 18.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0)),
                      // curve brackets object
//                    hintText: "Quantity",
                      hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                      labelText: "Item Name",
                    ),
                  ),
                ),
              SizedBox(
                width: 10,
              )
            ]),

          SizedBox(height: 10),

          Row(
              children: [
                SizedBox(width: 10),

                Expanded(
                  child: TextFormField(
                    controller: rateController,
                    enabled: true,
                    validator: (v) {
                      if (v!.isEmpty) return "Required";
                      return null;
                    },
//
                    cursorColor: Colors.black,

                    scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                    keyboardType: TextInputType.number,

                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}")),
                    ],
                    decoration: InputDecoration(

//                    suffixIcon: Icon(
//                      Icons.calendar_today,
//                      color: Colors.blue,
//                      size: 24,
//                    ),
                      errorStyle: TextStyle(color: Colors.red),
                      errorText: rateSelect ? "Invalid Rate" : null,
                      isDense: true,
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 18.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0)),
                      // curve brackets object
//                    hintText: "Quantity",
                      hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                      labelText: "Rate",
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                )
              ]),

          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                  onTap: () {
                    print("Save");
                    itemSave();
                  },
                  child:Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.lightBlueAccent,
                    ),
                    width: 100,
                    height: 40,
                    child: Center(
                      child: Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )

              ),

              SizedBox(width: 172),
              GestureDetector(
                  onTap: () {
                    print("Reset");
                    setState(() {
                      Resetfunction();
                    });
                  },
                  child:Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.lightBlueAccent,
                    ),
                    width: 100,
                    height: 40,
                    child: Center(
                      child: Text(
                        "Reset",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
              ),
            ],
          ),

        ],
      ),
    ),
    );
  }
}
