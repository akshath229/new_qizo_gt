import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'models/userdata.dart';

class ReceiptView extends StatefulWidget {
  @override
  _ReceiptViewState createState() => _ReceiptViewState();
}

class _ReceiptViewState extends State<ReceiptView> {
  int _currentIndex = 0;
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );
  late SharedPreferences pref;
  dynamic user;
  dynamic token;
  late String branchName;
  dynamic userName;
  //get token
  read() async {
    var v = pref.getString("userData");
    print("USER DATA: $v");
    var c = json.decode(v!);
    //
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
    }); //  passes this user.user["token"]
    pref.setString("customerToken", user.user["token"]);
  }
  void pageChanged(int index) {
    setState(() {
      _currentIndex = index;
      // switch (_currentIndex) {
      //   case 0:
      //     return Home();
      //     break;
      //   case 1:
      //     return ViewOrder();
      //     break;
      //   default:
      //     return Home();
      // }
    });
  }

  void bottomTapped(int index) {
    setState(() {
      _currentIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  Widget callPage(int currentIndex) {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      // controller: pageController,
      // onPageChanged: (index) {
      //   switch (currentIndex) {
      //     case 0:
      //       return Home();
      //       break;
      //     case 1:
      //       return ViewOrder();
      //       break;
      //     default:
      //       return Home();
      //   }
      // },
      children: <Widget>[
        // _currentIndex == 0 ? Home() : ViewOrder()
      ],
    );


  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(190.0),
          child: Container(
            height: 60,
            color: Colors.blue,
            width: double.maxFinite,
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
                            style: TextStyle(fontSize: 13, color: Colors.white),
                          ),
                        )),
                    GestureDetector(
                      onTap: () {
                        print("hi");
                      },
                      child: Text(
                        "Receipt Collection",
                        style: TextStyle(fontSize: 22, color: Colors.white),
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
        body: callPage(_currentIndex),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (value) {
            setState(() {
              _currentIndex = value;
              print(_currentIndex.toString());
              print(value);
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",  // Use 'label' here
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.view_list),
              label: "View",  // Use 'label' here
            )
          ],
        ),

      ),
    );
  }
}
