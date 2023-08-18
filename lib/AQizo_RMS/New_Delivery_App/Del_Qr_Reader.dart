import 'dart:async';
import 'dart:convert';
import 'dart:ui';


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/userdata.dart';
import '../../urlEnvironment/urlEnvironment.dart';

class Del_Qr_Rreader extends StatefulWidget {

  var Del_Man_Id;
  Del_Qr_Rreader({this.Del_Man_Id});

  @override
  _Del_Qr_RreaderState createState() => _Del_Qr_RreaderState();
}

class _Del_Qr_RreaderState extends State<Del_Qr_Rreader> {


  late Timer _timer;
  late SharedPreferences pref;
  late int branchId;
  late int userId;
  late UserData userData;
  String branchName = "";
  dynamic userName;
  late String token;
  dynamic user;
  dynamic currencyName;
  var ScannedDatas=[];
  bool is_processes=false;
  var   EmpId;
  var Del_Man_Id;

  @override
  void initState() {
    // TODO: implement initState
    ScannedDatas=[];
    SharedPreferences.getInstance().then((value) {
      pref = value;
      read();
  });
        }
  read() async {
    var v = pref.getString("userData");
    var c = json.decode(v!);
    user = UserData.fromJson(c); // token gets this code user.user["token"]
    setState(() {
      branchId = int.parse(c["BranchId"]);
      token = user.user["token"]; //  passes this user.user["token"]
      print(user.user["token"]);
      pref.setString("customerToken", user.user["token"]);
      branchName = user.branchName;
      userName = user.user["userName"];
      userId = user.user["userId"];
      currencyName = user.user["currencyName"];
     //  EmpId=user.user["loginedEmployeeId"];
      EmpId=widget.Del_Man_Id;
      print("----EmpId----");
      print(EmpId.toString());
    });
  }

  void qr_Barcode_Readfunction() async {
    try {
      print("in qr_Barcode_Readfunction ");
      var result = await BarcodeScanner.scan();
      print("type");
      print(result.type);
      print("rawContent");
      print(result.rawContent);
      print("format");
      print(result.format);
      print("formatNote");
      print(result.formatNote);
      print(result.formatNote);
      final RegExp regexp = new RegExp(r'^0+(?=.)');
      print("${result.rawContent} => ${result.rawContent.replaceAll(regexp, '')}");
      var res=result.rawContent.replaceAll(regexp, '');

     Getdata(res);
    // Getdata(129);

    }
    catch(e) {  print("Error on qr_Barcode_Readfunction $e");}

  }


  Getdata(id)async{
    setState(() {
      is_processes=false;
    });

var result=await http.get("${Env.baseUrl}SalesHeaders/$id/VoucherNumber" as Uri,headers: {
"Authorization": token,
});


if(result.statusCode==200){



  var res=json.decode(result.body);
  print("salesHeader");
  print(res["salesHeader"]);
  if(res["salesHeader"].toString()=="[]"){

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (c) {
          return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1),
                    borderRadius: BorderRadius.circular(
                        20),
                  ),
                  title: Center(child: Text(
                    "Invalid...", style: TextStyle(color: Colors.red
                  ),)),
                );
              });
        });
    Timer(Duration(milliseconds: 1000), () {
      Navigator.pop(context);
      print("time 500");
    });

    return ;
  }

  print("salesDetails");
  print(res["salesDetails"]);

  print(res["salesHeader"][0]["voucherNo"].toString());

  for(int j=0;j<ScannedDatas.length;j++){

    if(res["salesHeader"][0]["id"]== ScannedDatas[j]["Sh_id"]){

setState(() {
  is_processes=true;
});

    }


  }

  if(res["salesHeader"][0]["cancelFlg"]==true||res["salesHeader"][0]["orderstatus"]=="delivered"|| is_processes==true){



    // showDialog(
    //     barrierDismissible: false,
    //     context: context,
    //     builder: (c) {
    //       return StatefulBuilder(
    //           builder: (context, setState) {
    //
    //             return AlertDialog(
    //               shape: RoundedRectangleBorder(
    //                 side: BorderSide(width: 1),
    //                 borderRadius: BorderRadius.circular(
    //                     20),
    //               ),
    //               title: Center(child: Text("Order Cancelled Or Already Processed",style: TextStyle(color: Colors.red
    //               ),)),
    //               actions: [TextButton(onPressed: (){Navigator.pop(context);}, child: Text("OK"))],
    //             );
    //           });
    //     });

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (c) {
          _timer = Timer(Duration(milliseconds: 400), () {
            Navigator.of(context).pop();
          });
          return AlertDialog(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
            title: Center(child: Text(
              "Order Cancelled Or Already Processed", style: TextStyle(color: Colors.red
            ),
            )),
          );
        }
    ).then((val){
      if (_timer.isActive) {
        _timer.cancel();
      }
    });

    return;

  }
else{


  var qrdata= {
    "Sh_id":res["salesHeader"][0]["id"],
    "Billnum":res["salesHeader"][0]["voucherNo"],
    "Name":res["salesHeader"][0]["partyName"],
    "Phonenum":res["salesHeader"][0]["phone"],
    "Amount":res["salesHeader"][0]["amount"]
  };

  print("qrdata");
  print(qrdata);

  setState(() {
    ScannedDatas.add(qrdata);
    BillNumber_Controller.text="";
  });



  }


print(ScannedDatas);
}else{

  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (c) {
        return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1),
                  borderRadius: BorderRadius.circular(
                      20),
                ),
                title: Center(child: Text(
                  "Invalid", style: TextStyle(color: Colors.red
                ),)),
              );
            });
      });
  Timer(Duration(milliseconds: 1000), () {
    Navigator.pop(context);
    print("time 500");
  });

}


  }




  Proccess()async {
    var datatime = new DateFormat("yyyy-MM-dd").format(DateTime.now());

    print(datatime);
    print(ScannedDatas);

    if (ScannedDatas.length < 1) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (c) {
            return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(
                          20),
                    ),
                    title: Center(child: Text(
                      "Order not Selected", style: TextStyle(color: Colors.red
                    ),)),
                  );
                });
          });
      Timer(Duration(milliseconds: 1000), () {
        Navigator.pop(context);
        print("time 500");
      });
      print("Order not Selected");
    } else {

        var parm = {
          "voucherNo": 1,
          "delDate": datatime,
          "salesManId":EmpId, //widget.Del_Man_Id,
          "salesMan": null,
          "rmsDeliverDetails": [
            for(int i = 0; i < ScannedDatas.length; i++){

              "salesHeaderId": ScannedDatas[i]["Sh_id"]
            }
          ]
        };



        var finaldata = json.encode(parm);
        print("--finaldata--");
        print(finaldata);
        var result = await http.post("${Env.baseUrl}RmsDeliveryHeaders",
            headers: {
              'accept': 'application/json',
              'content-type': 'application/json',
              'Authorization': user.user["token"],
              'deviceId': user.deviceId
            },
            body: finaldata);

        print("-------parm------");
        print(result.body);
        print(result.statusCode);
        if(result.statusCode==200||result.statusCode==201){

          setState(() {
            ScannedDatas=[];
          });

          // showDialog(
          //     barrierDismissible: false,
          //     context: context,
          //     builder: (c) {
          //       // ignore: missing_return
          //       return StatefulBuilder(
          //           builder: (context, setState) {
          //
          //             return AlertDialog(
          //               shape: RoundedRectangleBorder(
          //                 side: BorderSide(width: 1),
          //                 borderRadius: BorderRadius.circular(
          //                     20),
          //               ),
          //               title: Center(child: Text(
          //                 "Success", style: TextStyle(color: Colors.green
          //               ),
          //               )),
          //             );
          //           });
          //       });




        }
      }

  }

  BackButtonFunction(){

    showDialog(
        context: context,
        builder: (c) => AlertDialog(
                content: Text("Do you really want to logout?"),
                actions: [
                  TextButton(
                    child: Text("Yes"),
                    onPressed: () {
                      setState(() {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Del_Login_DeliveyMan(pref: pref,Token: token,),));
                      });
                    },
                  ),
                  TextButton(
                    child: Text("No"),
                    onPressed: () {
                      setState(() {
                        print("No...");
                        Navigator.pop(context);
                      });
                    },
                  )
                ]));
  }


  TextEditingController BillNumber_Controller =TextEditingController();


///---------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
appBar:PreferredSize(child: Appbarcustomwidget(uname: userName, branch: branchName, pref: pref, title: "Orders"), preferredSize: Size.fromHeight(80)) ,


        floatingActionButton:Align(
         alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: FloatingActionButton(

                child:Icon(Icons.qr_code,
            color: Colors.teal,
            size: 40,),
              backgroundColor: Colors.white,
                elevation: 0,
                onPressed: (){qr_Barcode_Readfunction();
                }),
          ),
        ),

        body:WillPopScope(
          onWillPop: (){
         return  BackButtonFunction();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [



                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(children: [

                      Expanded(
                        child: TextFormField(
                          controller: BillNumber_Controller,
                          enabled: true,
                          validator: (v) {
                            if (v.isEmpty) return "Required";
                            return null;
                          },
//
//                  focusNode: field1FocusNode,
                          cursorColor: Colors.black,
                          scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                          keyboardType: TextInputType.number,

                          decoration: InputDecoration(
//                    suffixIcon: Icon(
//                      Icons.calendar_today,
//                      color: Colors.blue,
//                      size: 24,
//                    ),
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 16.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            // curve brackets object
//                    hintText: "Quantity",
                            hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                            hintText: "Enter",
                          ),
                        ),
                      ),

                      SizedBox(width: 10,),

                      InkWell(

                        onTap: (){

                          if(BillNumber_Controller.text!=""){
                            Getdata(BillNumber_Controller.text);

                          }

                        },
                        child: Container(height: 40,
                        width: 100,
                        child: Center(child: Text("OK",style: TextStyle(color: Colors.white,fontSize: 25),)),
                        color: Colors.green,),
                      )

                      // Getdata(id)

                    ],),
                  ),



                  ListView.builder(
                    itemCount: ScannedDatas.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) =>
                    Dismissible(

                      background:Container(
                        child: Align(alignment: Alignment.centerRight,child:Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Icon(Icons.delete_outline,size: 30,),
                        ),),
                        color: Colors.red,),
                      key:Key(ScannedDatas[index].toString()),
                      onDismissed: (a){
                        ScannedDatas.removeAt(index);
                        print("aaaaaaaaaaa");
                        print(a);
                        print(ScannedDatas);


                      },
                      direction: DismissDirection.endToStart,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Container(
                           decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                          child: ListTile(
                            onLongPress: (){
                              showDialog(
                                  context: context,
                                  builder: (c) => AlertDialog(
                                      content: Text("Remove Order?"),
                                      actions: [
                                        TextButton(
                                          child: Text("Yes"),
                                          onPressed: () {
                                            setState(() {
                                              ScannedDatas.removeAt(index);
                                              Navigator.pop(context);
                                            });
                                          },
                                        ),
                                        TextButton(
                                          child: Text("No"),
                                          onPressed: () {
                                            setState(() {
                                              print("No...");
                                              Navigator.pop(context);
                                            });
                                          },
                                        )
                                      ]));

                            },
                           // onTap: (){
                           //   print(ScannedDatas[index]);
                           // },

                            title: Text(ScannedDatas[index]["Name"]??"".toString(),style: TextStyle(color: Colors.black,fontSize: 20 ),),
                           leading:  Text("Bill No."+ScannedDatas[index]["Billnum"].toString(),style: TextStyle(color: Colors.black,fontSize: 20 ),),
                           trailing: Text(currencyName +" "+ScannedDatas[index]["Amount"].toString(),style: TextStyle(color: Colors.black,fontSize: 20 ),),
                          subtitle: Text(ScannedDatas[index]["Phonenum"]??"".toString(),style: TextStyle(color: Colors.black,fontSize: 15 ),),
                          ),
                        ),
                      ),
                    ),),
                ],
              ),
            ),
          ),
        ),



        bottomNavigationBar:Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: (){
                    setState(() {

                      showDialog(
                          context: context,
                          builder: (context) {
                            Future.delayed(Duration(milliseconds: 500), () {
                              Navigator.of(context).pop(true);
                            });
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1),
                                borderRadius: BorderRadius.circular(
                                    20),
                              ),
                              title: Center(child: Text(
                                "Success", style: TextStyle(color: Colors.green
                              ),
                              )),
                            );
                          });
                      Future.delayed(Duration(milliseconds: 800), () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Del_Login_DeliveyMan(pref: pref,Token: token,),));
                      });

                    });
                   Proccess();
                  },
                  child: Container(
                    color: Colors.indigo,
                    height: 50,
                    child: Center(child: Text("Process",style:TextStyle(fontSize: 25,color: Colors.white),))),
                ),
              ),

              SizedBox(width: 5,),

              Expanded(
                child: InkWell(
                  onTap: (){
                  setState(() {
                    ScannedDatas=[];
                    BillNumber_Controller.clear();

                  });
                  },
                  child: Container(
                    color: Colors.teal,
                    height: 50,
                    child:Center(child: Text("Reset",style:TextStyle(fontSize: 25,color: Colors.white),))),
                ),
              ),
            ],
          ),
        ) ,
      ),
    );
  }
}
