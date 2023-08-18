import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'package:http/http.dart' as http;

import '../../urlEnvironment/urlEnvironment.dart';



class CUWidgets {
  /// testfun is for only testing
  testfun(dynamic da) {
    print(da.toString());
  }

  /// basic Textform feids..................
  Widget CUTestbox({
    required TextEditingController controllerName,
    required bool errorcontroller,
    dynamic label = "",
    dynamic hintText = "",
    TextInputType=TextInputType.text,
    TextInputFormatter
  }) {
    return
      TextFormField(
        style: TextStyle(fontSize: 15),
        //showCursor: true,
        controller: controllerName,
        cursorColor: Colors.black,
        textInputAction:TextInputAction.next,
        scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
        keyboardType: TextInputType,
        inputFormatters: TextInputFormatter,

        onTap: () async {

        },
        decoration: InputDecoration(
          errorStyle: TextStyle(color: Colors.red),
          errorText: errorcontroller == true ? "Invalid  $label" : null,

          isDense: true,
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0)),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black, fontSize: 15),
          labelText: label,
        ),
      );
  }


  /// basic of button created with InkWell........................
  Widget CUButton({
    String name = "button",
    Color color = Colors.blueGrey,
    double H = 10,
    double W = 10,
    required Function function,
    required TextStyle Labelstyl
  }) {
    try {
      return InkWell(
        onTap: () {
          function();
        },
        child: Container(
          color: color,
          height: H,
          width: W,
          child: Center(child: Text(name, style: Labelstyl)),
        ),
      );
    } catch (e) {
      print("Error on Button $e");
      return Container(child: Text('Error'));  // Return a default widget in case of an exception.
    }
  }

  /// basic Api caliing........................

  CUget({required String api}) async {
    try {
      var result = await http.get('${Env.baseUrl}$api' as Uri,
          headers: {"accept": "application/json"});
      print(result.body);
      if (result.statusCode == 200 || result.statusCode == 201) {
        return result.body;
      }
      else {
        print("Error on Fetch Data statusCode= ${result.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error on Fetch Data $e");
      return false;
    }
  }


  /// Tosters service.....bottom popup...................

  //  CUpopup(String msg, txtcolor, context, {duration = 0, gravity = 0}) {
  //   Toast.show(
  //       msg,
  //       context,
  //       duration: duration != 0 ? duration : Toast.LENGTH_SHORT,
  //       gravity: gravity != 0 ? gravity : Toast.BOTTOM,
  //       backgroundColor:
  //       Color.fromRGBO(8, 44, 243, 1.0),
  //       textColor: txtcolor,
  //       border: Border(
  //           top: BorderSide(
  //             color: Color.fromRGBO(203, 209, 209, 1),
  //           ), bottom: BorderSide(
  //         color: Color.fromRGBO(203, 209, 209, 1),
  //       ), right: BorderSide(
  //         color: Color.fromRGBO(203, 209, 209, 1),
  //       ), left: BorderSide(
  //         color: Color.fromRGBO(203, 209, 209, 1),
  //       )),
  //       backgroundRadius: 30
  //   );
  // }






  /// Conidtional popup service....Normal.................

  CUshowDialog(context,{String label="",labelcolor=Colors.black,required VoidCallback clickFunction }) {
        showDialog(barrierDismissible: false,
            context: context,
            builder: (c) => AlertDialog(
                content: Text(label.toString(),textAlign: TextAlign.center,
                style: TextStyle(color: labelcolor),),
                actions: [
                  TextButton(onPressed: (){
                    ///clickFunction;
                    Navigator.of(context,rootNavigator: true).pop();
                  }, child: Text("Yes")),

                  TextButton(onPressed: (){
                    Navigator.of(context,rootNavigator: true).pop();
                  }, child: Text("No")), ]));
  }

  /// basic Api with body prameter  caliing........................

  CUget_With_Parm({required String api,Token}) async {
    try {
      print("token" +Token);
      var result = await http.get('${Env.baseUrl}$api' as Uri,
          headers:{"accept": "application/json",
        "Authorization":Token});
      print("api" + "$api");
      print(result.body);
      print(result.statusCode);
      if (result.statusCode == 200 || result.statusCode == 201) {
        return result.body;
      }
      else {
        print("Error on Fetch Data statusCode= ${result.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error on Fetch Data $e");
      return false;
    }
  }





  ///----post methode-------------

  post({required String api, Token,  body, deviceId}) async {
    try {
      var result = await http.post('${Env.baseUrl}$api' as Uri,
          headers: {
            'accept': 'application/json',
            'content-type': 'application/json',
            'Authorization':Token,
            'deviceId':deviceId
          },
          body: body);
       print(result.body);
       print(result.statusCode);
      if (result.statusCode == 200 || result.statusCode == 201) {
        return result.body;
      } else if(result.statusCode == 409){
        return result.body;
      }

      else
      {
        print("Error on post Data statusCode= ${result.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error While posting Data $e");
      return false;
    }
  }



  ///-----put edit methode

  put({required String api, Token,  body, deviceId}) async {
    try {
      var result = await http.put('${Env.baseUrl}$api' as Uri,
          headers: {
            'accept': 'application/json',
            'content-type': 'application/json',
            'Authorization':Token,
            'deviceId':deviceId
          },
          body: body);
        print(result.body);
        print(result.statusCode);
      if (result.statusCode <= 210 && result.statusCode >=200) {
        return result.body;

      }

      else if(result.statusCode == 409){
        return result.body;
      }


      else {
        print("Error on post Data statusCode= ${result.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error While posting Data $e");
      return false;
    }
  }




  ///---------------------delete ------------------------------

  delete({required String api, Token, deviceId}) async {
    try {
      var result = await http.delete('${Env.baseUrl}$api' as Uri,
          headers: {
            'accept': 'application/json',
            'content-type': 'application/json',
            'Authorization':Token,
            'deviceId':deviceId
          });
      print(result.body);
       print(result.statusCode);
      if (result.statusCode <= 210 && result.statusCode >=200) {
        return result.body;
      }
      else if(result.statusCode == 409){
        return result.body;
      }


      else {
        print("Error on Delete Data statusCode= ${result.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error While Delete Data $e");
      return false;
    }
  }

  ///-----save , failed ,delete and update popup------

SavePopup(context){

  showDialog(barrierDismissible: false,
      context: context,
      builder: (c) => AlertDialog(backgroundColor: Colors.lightBlue,

          shape:RoundedRectangleBorder(
            side: BorderSide(color:  Colors.blueAccent, width: 1),
            borderRadius: BorderRadius.circular(20),
          ),
          content: Text("Saved",textAlign: TextAlign.center,style: TextStyle(fontSize: 25),
          )));
  Timer(Duration(seconds: 1), (){
    Navigator.of(context,rootNavigator: true).pop();
  });

}



  FailePopup(context) {
    showDialog(barrierDismissible: false,
        context: context,
        builder: (c) =>
            AlertDialog(backgroundColor: Colors.red.shade300,

                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.red.shade900, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                content: Text("Failed...", textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25),
                )));
    Timer(Duration(seconds: 1), () {
      Navigator.of(context, rootNavigator: true).pop();
    });
  }



  UpdatePopup(context){

    showDialog(barrierDismissible: false,
        context: context,
        builder: (c) => AlertDialog(backgroundColor: Colors.lightBlue,

            shape:RoundedRectangleBorder(
              side: BorderSide(color:  Colors.blueAccent, width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
            content: Text("Updated",textAlign: TextAlign.center,style: TextStyle(fontSize: 25),
            )));
    Timer(Duration(seconds: 1), (){
      Navigator.of(context,rootNavigator: true).pop();
    });

  }

  DeletePopup(context){

    showDialog(barrierDismissible: false,
        context: context,
        builder: (c) => AlertDialog(backgroundColor: Colors.lightBlue,

            shape:RoundedRectangleBorder(
              side: BorderSide(color:  Colors.blueAccent, width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
            content: Text("Deleted",textAlign: TextAlign.center,style: TextStyle(fontSize: 25),
            )));
    Timer(Duration(seconds: 1), (){
      Navigator.of(context,rootNavigator: true).pop();
    });

  }




  MessagePopup(context,String msg,Color color){

    showDialog(barrierDismissible: false,
        context: context,
        builder: (c) => AlertDialog(backgroundColor: color,

            shape:RoundedRectangleBorder(
              side: BorderSide(color:  Colors.black87, width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
            content: Text(msg??"",textAlign: TextAlign.center,style: TextStyle(fontSize: 25),
            )));
        // Vibration.vibrate(duration: 200);
    Timer(Duration(milliseconds:1400,), (){
      Navigator.of(context,rootNavigator: true).pop();
    });

  }

}
