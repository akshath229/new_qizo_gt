import 'package:flutter/material.dart';

import 'login.dart';


class Appbarcustomwidget extends StatefulWidget {
  String uname;
  String branch;
  final pref;
  dynamic title;
  dynamic child;

  Appbarcustomwidget(
      {required this.uname,
      required this.branch,
      @required this.pref,
      @required this.title,
        this.child,
      });

  @override
  _AppbarcustomwidgetState createState() => _AppbarcustomwidgetState();
}

class _AppbarcustomwidgetState extends State<Appbarcustomwidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
          // gradient: new LinearGradient(
          //     colors: [Color(0xFFE7E9EE), Color(0xFF328BF6)],
          //     begin: FractionalOffset.centerLeft,
          //     end: FractionalOffset.centerRight,
          //     stops: [0.0, 1.0],
          //     tileMode: TileMode.clamp)
        color: Colors.teal
      ),
      width: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.only(
            //  bottom: 1,
            right: 10,
            left: 10),
        child:
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
// SizedBox(width: 10,),

          GestureDetector(
              onTap: () {
                print("hi");
                setState(() {
                  print("yes");
                  print("yes");

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
                        print("Logout...");
                      //  widget.pref.remove('loginUser');
                        widget.pref.remove('userData');
                        Navigator.pop(context); //okk
//                              Navigator.pop(context);
                      //  Navigator.pushReplacementNamed(context, "/logout");

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      });
                    },
                  );
                  showDialog(
                      context: context,
                      builder: (c) => AlertDialog(
                          content: Text("Do you really want to logout?"),
                          actions: [yesButton, noButton]));
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40.0),
                          image: DecorationImage(
                              image: AssetImage("assets/icon1.jpg"),
                              fit: BoxFit.fill)),
                      margin: new EdgeInsets.only(
                          left: 0.0, top: 5.0, right: 0.0, bottom: 0.0),
                      child: Align(
                        alignment: Alignment.center,
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
              )),

          Container(
              margin: EdgeInsets.only(top: 10, bottom: 15),
              child: Column(children: [
                SizedBox(
                  height: 7,
                ),
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: Text(
                      widget.branch.toString(),
                      style: TextStyle(fontSize: 13, color: Colors.white),
                    ),
                  ),
                ),
              ])),

               Container(
                margin: new EdgeInsets.only(
                    left: 0.0, top: 25.0, right: 0.0, bottom: 0.0),
                child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                  InkWell(child: Icon(Icons.logout,color: Colors.white,size: 20,),
                  onTap: (){
                    print("hi");
                    setState(() {
                      print("yes");
                      print("yes");

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
                            print("Logout...");
                            widget.pref.remove('userData');
                            Navigator.pop(context); //okk
//                              Navigator.pop(context);
                            Navigator.pushNamedAndRemoveUntil(context, "/logout",
                                    (route) => false);

                            //placementNamed(context, "/logout");

                            // Navigator.pushReplacement(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => Login()),
                            // );
                          });
                        },
                      );
                      showDialog(
                          context: context,
                          builder: (c) => AlertDialog(
                              content: Text("Do you really want to logout?"),
                              actions: [yesButton, noButton]));
                    });
                  },),

                    SizedBox(height: 2,),
                    Text(
                      "${widget.uname.toString()}",
                      style: TextStyle(fontSize: 13, color: Colors.white),
                    ),
                  ],
                ),
              ),


           //  widget.child==null?Visibility(child: Text(""),visible: false,):widget.child
        ]),
      ),

    );
  }
}
