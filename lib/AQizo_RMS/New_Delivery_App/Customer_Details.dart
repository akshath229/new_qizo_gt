// import 'dart:convert';
// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_app/appbarWidget.dart';
// import 'package:flutter_app/models/userdata.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class Del_Customer_Details extends StatefulWidget {
//   @override
//   _Del_Customer_DetailsState createState() => _Del_Customer_DetailsState();
// }
//
// class _Del_Customer_DetailsState extends State<Del_Customer_Details> {
//
//
//   TextEditingController UserName_Controller= TextEditingController();
//   TextEditingController Ph_num_Controller= TextEditingController();
//   TextEditingController Add1_Controller= TextEditingController();
//   TextEditingController Add2_Controller= TextEditingController();
//   TextEditingController pin_Controller= TextEditingController();
//
//   double InputText_ContentPadding=10.0;
//
//
//
//   //------------------For App Bar------------------------
//   SharedPreferences pref;
//   dynamic branch;
//   var res;
//   dynamic user;
//   int branchId;
//   int userId;
//   UserData userData;
//   String branchName = "";
//   dynamic userName;
//   String token;
//
//   read() async {
//     var v = pref.getString("userData");
//     var c = json.decode(v);
//     user = UserData.fromJson(c); // token gets this code user.user["token"]
//     setState(() {
//       branchId = int.parse(c["BranchId"]);
//       token = user.user["token"]; //  passes this user.user["token"]
//       pref.setString("customerToken", user.user["token"]);
//       branchName = user.branchName;
//       userName = user.user["userName"];
//       userId = user.user["userId"];
//     });
//   }
//
//
// @override
//   void initState() {
//     // TODO: implement initState
//   setState(() {
//     SharedPreferences.getInstance().then((value) {
//       pref = value;
//       read();
//
//     });
//   });
//   }
//   ///-------------------------------------------------
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: SafeArea(
//         child: Scaffold(
//
//           appBar: PreferredSize(
//               preferredSize: Size.fromHeight(190.0),
//               child: Appbarcustomwidget(
//                 branch: branchName,
//                 pref: pref,
//                 title: "RMS Home",
//                 uname: userName,
//               )),
//
//
//
//           body: Padding(
//             padding: const EdgeInsets.only(left: 200,right: 200),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//
//
//                 Text("Customer Details",style: TextStyle(fontSize: 25),),
// SizedBox(height: 100,),
//
//               TextFormField(
//                   controller: Ph_num_Controller,
//                   decoration: InputDecoration(
//                       hintText: "PH:Number",
//                       contentPadding: EdgeInsets.only(left: InputText_ContentPadding,)
//                   )
//
//               ),
//
//
//                 SizedBox(height: 5,),
//
//               TextFormField(
//                   controller: UserName_Controller,
//                   decoration: InputDecoration(
//                       hintText: "Name",
//                       contentPadding: EdgeInsets.only(left: InputText_ContentPadding,)
//                   )
//
//               ),
//
//                 SizedBox(height: 5,),
//
//
//               TextFormField(
//                   controller: Add1_Controller,
//                   decoration: InputDecoration(
//                       hintText: "Address 1",
//                       contentPadding: EdgeInsets.only(left: InputText_ContentPadding,)
//                   )
//
//               ),
//
//
//                 SizedBox(height: 5,),
//
//
//               TextFormField(
//                   controller: Add2_Controller,
//                   decoration: InputDecoration(
//                       hintText: "Address 2",
//                       contentPadding: EdgeInsets.only(left: InputText_ContentPadding,)
//                   )
//
//               ),
//
//                 SizedBox(height: 5,),
//
//                 TextFormField(
//                   controller: pin_Controller,
//                   decoration: InputDecoration(
//                       hintText: "Pin",
//                       contentPadding: EdgeInsets.only(left: InputText_ContentPadding,)
//                   )
//
//               ),
//
//                 SizedBox(height: 20,),
//
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                   ElevatedButton(onPressed: (){},
//                       child: Text("   OK   ",style: TextStyle(fontSize: 20))),
//
//                   ElevatedButton(onPressed: (){
//                     Navigator.pop(context);
//                   }, child: Text(" BACK ",style: TextStyle(fontSize: 20)))
//                 ],)
//
//
//             ],),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
class Add_UserDetails{
  TextEditingController UserName_Controller= TextEditingController();
  TextEditingController Ph_num_Controller= TextEditingController();
  TextEditingController Add1_Controller= TextEditingController();
  TextEditingController Add2_Controller= TextEditingController();
  TextEditingController pin_Controller= TextEditingController();

  double InputText_ContentPadding=10;


  bool is_compete=false;
// bool _isDining=true;
  var OrderTyp="Delivery";
  bool Ph_num_Validation=false;

  initialFunction(context,setState,Ph_data)async{
    Ph_num_Validation=false;
    is_compete=false;
    UserName_Controller.text= "";
    Ph_num_Controller.text= "";
    Add1_Controller.text="";
    Add2_Controller.text="";
    pin_Controller.text= "";
    OrderTyp="Delivery";

    var s= await  CustomerDatas(context,setState,Ph_data);
    print("is_compete1");
    print(is_compete);
    if(is_compete==true){

      var customerdata=[{
        "Ph_num":Ph_num_Controller.text,
        "UserName":UserName_Controller.text,
        "Add1":Add1_Controller.text,
        "add2":Add2_Controller.text,
        "pin":pin_Controller.text,
        "OrderTyp":OrderTyp
      }];

      print("is_compete");
      print(is_compete);
      return customerdata;

    }
    return null;
  }

  CustomerDatas(context,setState,List Cust_Phone_numList){

    print("uioiuouiouioui");
    print(Cust_Phone_numList[0]["mobileNumber"]);
    return  showDialog(context: context,
        barrierDismissible: false,
        builder: (context)
        {
          return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                    content: Padding(
                      padding: const EdgeInsets.only(left: 0,right: 0),
                      child: SizedBox(
                        height: 500,
                        width: MediaQuery.of(context).size.width/2,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              Text("Customer Details",style: TextStyle(fontSize: 25),),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [


                                  Radio(
                                    activeColor: Colors.indigo,
                                    fillColor:MaterialStateProperty.all(Colors.red) ,
                                    value:"Delivery",
                                    groupValue: OrderTyp,
                                    onChanged: (value) {
                                      setState(() {
                                        setState((){
                                          OrderTyp=value!;
                                        });
                                      });
                                    },
                                  ),
                                  InkWell(
                                      onTap: (){
                                        setState((){
                                          OrderTyp="Delivery";
                                        });
                                      },
                                      child:
                                      Text("Delivery")),
                                  Spacer(),
                                  Radio(
                                    activeColor: Colors.indigo,
                                    fillColor:MaterialStateProperty.all(Colors.red) ,
                                    value:"Takeaway",
                                    groupValue:OrderTyp,
                                    onChanged: (value) {
                                      setState(() {
                                        OrderTyp=value!;
                                      });
                                    },
                                  ),
                                  InkWell(
                                      onTap: (){
                                        setState((){
                                          OrderTyp="Takeaway";
                                        });
                                      },
                                      child:
                                      Text("Takeaway")),
                                  Spacer(),
                                  Radio(
                                    activeColor: Colors.indigo,
                                    fillColor:MaterialStateProperty.all(Colors.red) ,
                                    value:"Dining",
                                    groupValue:OrderTyp,
                                    onChanged: (value) {
                                      setState(() {
                                        OrderTyp=value!;
                                      });
                                    },
                                  ),
                                  InkWell(
                                      onTap: (){
                                        setState((){
                                          OrderTyp="Dining";
                                        });
                                      },
                                      child: Text("Dining")),

                                ],
                              ),
                              ///...........................part for Delivery Start............................
                              Visibility(
                                visible: OrderTyp == "Delivery",
                                child: Column(
                                  children: [
                                    SizedBox(height: 20),
                                    TypeAheadField(
                                        hideOnEmpty: true,
                                        textFieldConfiguration: TextFieldConfiguration(
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(),
                                            controller: Ph_num_Controller,
                                            decoration: InputDecoration(
                                              errorStyle: TextStyle(color: Colors.red),
                                              errorText: Ph_num_Controller.text.length<0
                                                  ? "Please Select Customer ?"
                                                  : null,
//
                                              suffixIcon: IconButton(
                                                icon: Icon(Icons.remove_circle),
                                                color: Colors.blue,
                                                onPressed: () {
                                                  setState(() {
                                                    print("cleared");
                                                    Ph_num_Controller.text = "";
                                                  });
                                                },
                                              ),

                                              isDense: true,
                                              contentPadding: EdgeInsets.only(left: InputText_ContentPadding),
                                              // border: OutlineInputBorder(
                                              //     borderRadius: BorderRadius.circular(TextBoxCurve)),
                                              // i need very low size height
                                              labelText:
                                              'PH:Number', // i need to decrease height
                                            )),
                                        suggestionsBoxDecoration:
                                        SuggestionsBoxDecoration(elevation: 90.0),
                                        suggestionsCallback: (pattern) {
                                          return pattern==""? null:
                                          Cust_Phone_numList.where((s) =>
                                              s["mobileNumber"].toString().trim().toLowerCase().startsWith(pattern.toString().trim().toLowerCase()));
                                        },
                                        itemBuilder: (context, suggestion) {
                                          return Card(
                                            color: Colors.blue,
                                            child: ListTile(
                                              tileColor: Colors.teal,
                                              title: Text(
                                                suggestion["mobileNumber"],
                                                style: TextStyle(color: Colors.white
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        onSuggestionSelected: (suggestion) {
                                          print( "suggetion addresses" +suggestion["address2"]);

                                          Ph_num_Controller.text = suggestion["mobileNumber"]??"";
                                          UserName_Controller.text= suggestion["customerName"]??"";
                                          Add1_Controller.text=suggestion["address1"]??"";
                                           Add2_Controller.text=suggestion["address2"]??"";
                                          // pin_Controller.text= suggestion["pinNo"]??"";
                                          // print(suggestion["mobileNumber"]);
                                          // print(".......sales Ledger id");
                                          // print("...........");
                                        },
                                        errorBuilder: (BuildContext context, Object error) =>
                                            Text('$error',
                                                style: TextStyle(
                                                    color: Theme.of(context).errorColor)),
                                        transitionBuilder:
                                            (context, suggestionsBox, animationController) =>
                                            FadeTransition(
                                              child: suggestionsBox,
                                              opacity: CurvedAnimation(
                                                  parent: animationController,
                                                  curve: Curves.elasticIn),
                                            )
                                    ),

                                    SizedBox(height: 5,),

                                    TextFormField(
                                        controller: UserName_Controller,
                                        decoration: InputDecoration(
                                            hintText: "Name",
                                            contentPadding: EdgeInsets.only(left: InputText_ContentPadding,)
                                        )

                                    ),

                                    SizedBox(height: 5,),
                                    TextFormField(
                                        controller: Add1_Controller,
                                        decoration: InputDecoration(
                                            hintText: "House NO",
                                            contentPadding: EdgeInsets.only(left: InputText_ContentPadding,)
                                        )
                                    ),
                                    SizedBox(height: 5,),
                                    TextFormField(
                                        controller: Add2_Controller,
                                        decoration: InputDecoration(
                                            hintText: "Street NO",
                                            contentPadding: EdgeInsets.only(left: InputText_ContentPadding,)
                                        )
                                    ),
                                    SizedBox(height: 5,),
                                    TextFormField(
                                        controller: pin_Controller,
                                        decoration: InputDecoration(
                                            hintText: "Pin",
                                            contentPadding: EdgeInsets.only(left: InputText_ContentPadding,)
                                        )
                                    ),
                                    SizedBox(height: 20,),
                                    SizedBox(height: 20,),
                                  ],
                                ),
                              ),
                              ///...........................part for Delivery end............................

                              ///...........................part for Take Away Start............................
                              Visibility(
                                visible: OrderTyp == "Takeaway",
                                child: Column(
                                  children: [
                                    SizedBox(height: 50,),
                                    TypeAheadField(
                                        hideOnEmpty: true,
                                        textFieldConfiguration: TextFieldConfiguration(
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(),
                                            controller: Ph_num_Controller,
                                            decoration: InputDecoration(
                                              errorStyle: TextStyle(color: Colors.red),
                                              errorText: Ph_num_Controller.text.length<0
                                                  ? "Please Select Customer ?"
                                                  : null,
                                              suffixIcon: IconButton(
                                                icon: Icon(Icons.remove_circle),
                                                color: Colors.blue,
                                                onPressed: () {
                                                  setState(() {
                                                    print("cleared");
                                                    Ph_num_Controller.text = "";
                                                  });
                                                },
                                              ),

                                              isDense: true,
                                              contentPadding: EdgeInsets.only(left: InputText_ContentPadding,),
                                              // border: OutlineInputBorder(
                                              //     borderRadius: BorderRadius.circular(TextBoxCurve)),
                                              // i need very low size height
                                              labelText:
                                              'PH:Number', // i need to decrease height
                                            )),
                                        suggestionsBoxDecoration:
                                        SuggestionsBoxDecoration(elevation: 90.0),
                                        suggestionsCallback: (pattern) {
                                          return pattern==""? null:
                                          Cust_Phone_numList.where((s) =>
                                              s["mobileNumber"].toString().trim().toLowerCase().startsWith(pattern.toString().trim().toLowerCase()));
                                        },
                                        itemBuilder: (context, suggestion) {
                                          return Card(
                                            color: Colors.blue,
                                            child: ListTile(
                                              tileColor: Colors.teal,
                                              title: Text(
                                                suggestion["mobileNumber"],
                                                style: TextStyle(color: Colors.white
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        onSuggestionSelected: (suggestion) {
                                          Ph_num_Controller.text = suggestion["mobileNumber"];
                                          UserName_Controller.text= suggestion["customerName"];
                                          // print(suggestion["mobileNumber"]);
                                          // print(".......sales Ledger id");
                                          //
                                          // print("...........");
                                        },
                                        errorBuilder: (BuildContext context, Object error) =>
                                            Text('$error',
                                                style: TextStyle(
                                                    color: Theme.of(context).errorColor)),
                                        transitionBuilder:
                                            (context, suggestionsBox, animationController) =>
                                            FadeTransition(
                                              child: suggestionsBox,
                                              opacity: CurvedAnimation(
                                                  parent: animationController,
                                                  curve: Curves.elasticIn),
                                            )),

                                    SizedBox(height: 5,),

                                    TextFormField(
                                        controller: UserName_Controller,
                                        decoration: InputDecoration(
                                            hintText: "Name",
                                            contentPadding: EdgeInsets.only(left: InputText_ContentPadding,)
                                        )

                                    ),

                                    SizedBox(height: 170,),

                                  ],
                                ),
                              ),
                              ///...........................part for Take Away end............................

                              ///...........................part for Dining Start............................

                              Visibility(
                                visible: OrderTyp == "Dining",
                                child: Column(
                                  children: [
                                    SizedBox(height: 50,),


                                    TextFormField(
                                        controller: Add1_Controller,
                                        decoration: InputDecoration(
                                            hintText: "Table Details",
                                            contentPadding: EdgeInsets.only(left: InputText_ContentPadding,)
                                        )
                                    ),

                                    SizedBox(height: 10,),
                                    TextFormField(
                                        controller: Ph_num_Controller,
                                        decoration: InputDecoration(
                                            hintText: "Enter Ph:",
                                            contentPadding: EdgeInsets.only(left: InputText_ContentPadding,)
                                        )
                                    ),

                                    SizedBox(height: 10,),

                                    TextFormField(
                                        controller: UserName_Controller,
                                        decoration: InputDecoration(
                                            hintText: "Name",
                                            contentPadding: EdgeInsets.only(left: InputText_ContentPadding,)
                                        )

                                    ),
                                    SizedBox(height: 5,),



                                    SizedBox(height: 100),


                                  ],
                                ),
                              ),
                              ///...........................part for Dining end............................

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                      style:ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green.shade800)),
                                      onPressed: (){
                                        setState((){
                                          print("Delivery$OrderTyp");
                                          if(OrderTyp=="Dining") {
                                            Ph_num_Validation = true;
                                            is_compete = true;
                                            Navigator.pop(context);
                                            print("on poup");
                                            print(is_compete);
                                          }
                                          else{
                                            if (Ph_num_Controller.text == "") {
                                              // setState((){
                                              Ph_num_Validation = true;
                                              // });
                                            } else {
                                              Ph_num_Validation = true;
                                              is_compete = true;
                                              Navigator.pop(context);
                                              print("on poup");
                                              print(is_compete);
                                            }
                                          }
                                        });
                                      },
                                      child: Text("   Proceed   ",style: TextStyle(fontSize: 20))),

                                  ElevatedButton(
                                      style:ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red.shade400)),
                                      onPressed: (){
                                        Navigator.pop(context);
                                      }, child: Text(" BACK  ",style: TextStyle(fontSize: 20)))
                                ],),
                            ],),





                          ///..................old datas starts........................
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//
//                             Text("Customer Details",style: TextStyle(fontSize: 25),),
//                             SizedBox(height: 50,),
//
//
//                             TypeAheadField(
//                                 hideOnEmpty: true,
//                                 textFieldConfiguration: TextFieldConfiguration(
//                                     keyboardType: TextInputType.number,
//                                     style: TextStyle(),
//                                     controller: Ph_num_Controller,
//                                     decoration: InputDecoration(
//                                       errorStyle: TextStyle(color: Colors.red),
//                                       errorText: Ph_num_Controller.text.length<0
//                                           ? "Please Select Customer ?"
//                                           : null,
// //                            errorText: _validateName ? "please enter name" : null,
// //                            errorBorder:InputBorder.none ,
//                                       suffixIcon: IconButton(
//                                         icon: Icon(Icons.remove_circle),
//                                         color: Colors.blue,
//                                         onPressed: () {
//                                           setState(() {
//                                             print("cleared");
//                                             Ph_num_Controller.text = "";
//                                           });
//                                         },
//                                       ),
//
//                                       isDense: true,
//                                       contentPadding: EdgeInsets.only(left: InputText_ContentPadding),
//                                       // border: OutlineInputBorder(
//                                       //     borderRadius: BorderRadius.circular(TextBoxCurve)),
//                                       // i need very low size height
//                                       labelText:
//                                       'PH:Number', // i need to decrease height
//                                     )),
//                                 suggestionsBoxDecoration:
//                                 SuggestionsBoxDecoration(elevation: 90.0),
//                                 suggestionsCallback: (pattern) {
//                                  return pattern==""? null:
//                                    Cust_Phone_numList.where((s) =>
//                                       s["mobileNumber"].toString().trim().toLowerCase().startsWith(pattern.toString().trim().toLowerCase()));
//                                 },
//                                 itemBuilder: (context, suggestion) {
//                                   return Card(
//                                     color: Colors.blue,
//                                     child: ListTile(
//                                       tileColor: Colors.teal,
//                                       title: Text(
//                                         suggestion["mobileNumber"],
//                                         style: TextStyle(color: Colors.white
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 onSuggestionSelected: (suggestion) {
//                                   Ph_num_Controller.text = suggestion["mobileNumber"];
//                                   UserName_Controller.text= suggestion["customerName"];
//                                   Add1_Controller.text=suggestion["address1"]??"";
//                                   Add2_Controller.text=suggestion["address2"]??"";
//                                   pin_Controller.text= suggestion["pinNo"]??"";
//                                   // print(suggestion["mobileNumber"]);
//                                   // print(".......sales Ledger id");
//                                   // print("...........");
//                                 },
//                                 errorBuilder: (BuildContext context, Object error) =>
//                                     Text('$error',
//                                         style: TextStyle(
//                                             color: Theme.of(context).errorColor)),
//                                 transitionBuilder:
//                                     (context, suggestionsBox, animationController) =>
//                                     FadeTransition(
//                                       child: suggestionsBox,
//                                       opacity: CurvedAnimation(
//                                           parent: animationController,
//                                           curve: Curves.elasticIn),
//                                     )),
//
//
//                             // TextFormField(
//                             //     controller: Ph_num_Controller,
//                             //    keyboardType: TextInputType.number,
//                             //     decoration: InputDecoration(
//                             //       errorText: Ph_num_Validation?"Add Ph:num":null,
//                             //         hintText: "PH:Number",
//                             //         contentPadding: EdgeInsets.only(left: InputText_ContentPadding,)
//                             //     )
//                             //
//                             // ),
//
//
//                             SizedBox(height: 5,),
//
//                             TextFormField(
//                                 controller: UserName_Controller,
//                                 decoration: InputDecoration(
//                                     hintText: "Name",
//                                     contentPadding: EdgeInsets.only(left: InputText_ContentPadding,)
//                                 )
//
//                             ),
//
//                             SizedBox(height: 5,),
//
//
//                             TextFormField(
//                                 controller: Add1_Controller,
//                                 decoration: InputDecoration(
//                                     hintText: "Address 1",
//                                     contentPadding: EdgeInsets.only(left: InputText_ContentPadding,)
//                                 )
//
//                             ),
//
//
//                             SizedBox(height: 5,),
//
//
//                             TextFormField(
//                                 controller: Add2_Controller,
//                                 decoration: InputDecoration(
//                                     hintText: "Address 2",
//                                     contentPadding: EdgeInsets.only(left: InputText_ContentPadding,)
//                                 )
//
//                             ),
//
//                             SizedBox(height: 5,),
//
//                             TextFormField(
//                                 controller: pin_Controller,
//                                 decoration: InputDecoration(
//                                     hintText: "Pin",
//                                     contentPadding: EdgeInsets.only(left: InputText_ContentPadding,)
//                                 )
//
//                             ),
//
//                             SizedBox(height: 20,),
//
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//
//
//                                 Radio(
//                                   activeColor: Colors.indigo,
//                                   fillColor:MaterialStateProperty.all(Colors.red) ,
//                                   value:"Delivery",
//                                   groupValue: OrderTyp,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       setState((){
//                                         OrderTyp=value;
//                                       });
//                                     });
//                                   },
//                                 ),
//                                 InkWell(
//                                     onTap: (){
//                                       setState((){
//                                         OrderTyp="Delivery";
//                                       });
//                                     },
//                                     child:
//                                 Text("Delivery")),
//
//                                  Spacer(),
//
//
//
//                                 Radio(
//                                   activeColor: Colors.indigo,
//                                   fillColor:MaterialStateProperty.all(Colors.red) ,
//                                   value:"Takeaway",
//                                   groupValue:OrderTyp,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       OrderTyp=value;
//                                     });
//                                   },
//                                 ),
//
//                                 InkWell(
//                                     onTap: (){
//                                       setState((){
//                                         OrderTyp="Takeaway";
//                                       });
//                                     },
//                                     child:
//                                     Text("Takeaway")),
//
//
//                                 Spacer(),
//                                 Radio(
//                                   activeColor: Colors.indigo,
//                                   fillColor:MaterialStateProperty.all(Colors.red) ,
//                                   value:"Dining",
//                                   groupValue:OrderTyp,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       OrderTyp=value;
//                                     });
//                                   },
//                                 ),
//                                 InkWell(
//                                   onTap: (){
//                                     setState((){
//                                       OrderTyp="Dining";
//                                     });
//                                   },
//                                     child: Text("Dining")),
//
//                               ],
//                             ),
//
//
//                             SizedBox(height: 20,),
//
//
//
//
//
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 ElevatedButton(
//
//                           style:ButtonStyle(  backgroundColor: MaterialStateProperty.all(Colors.green.shade800)),
//                                     onPressed: (){
//                                      // qr_Barcode_Readfunction();
//                                   //   print( {Del_Qr_Rreader.Del_Qr_Rreader()});
//
//
//                                         setState((){
//                                            if(Ph_num_Controller.text==""){
//                                           setState((){
//                                              Ph_num_Validation=true;
//                                           });
//
//                                          }else{
//                                             Ph_num_Validation=true;
//                                             is_compete=true;
//                                             print("before pop context");
//                                             Navigator.pop(context);
//                                             print("on poup");
//                                             print(is_compete);
//
//                                      }
//
//                                   });
//
//                                 },
//                                     child: Text("   Proceed   ",style: TextStyle(fontSize: 20))),
//
//                                 ElevatedButton(
//                                     style:ButtonStyle(  backgroundColor: MaterialStateProperty.all(Colors.red.shade400)),
//                                     onPressed: (){
//                                   Navigator.pop(context);
//                                 }, child: Text(" BACK  ",style: TextStyle(fontSize: 20)))
//                               ],),
//                           ],),

                          ///....................old datas ends
                        ),
                      ),
                    )
                );
              });
        });
  }
}
