
 import 'dart:convert';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../GT_Masters/AppTheam.dart';
import '../../GT_Masters/Masters_UI/cuWidgets.dart';
import '../../GT_Masters/Printing/Dynamic_PDF_Print.dart';
import '../../appbarWidget.dart';
import '../../models/userdata.dart';
import '../../receiptcollection.dart';
import '../../sales.dart';
import '../../salesmanhome.dart';
import '../../salesorder.dart';
import '../../salesreturn.dart';
import '../../shopvisited.dart';
import '../../urlEnvironment/urlEnvironment.dart';

class  Stock_Aging_Report extends StatefulWidget {

   @override
   _Stock_Aging_Report createState() => _Stock_Aging_Report();
 }

 class _Stock_Aging_Report extends State< Stock_Aging_Report>
     with SingleTickerProviderStateMixin {
   late String branchName;
   late SharedPreferences pref;
   dynamic user;
   late String token;
   dynamic userName;
   dynamic dateFrom;
   dynamic dateTO = DateTime.now();
   late int salesLedgerId;
   dynamic custValue;
   bool deliveryDateSelect = false;
   dynamic serverDate;


   double TextBoxCurve=10;
   String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
   var StockData=[];


   TextEditingController DateFromController = new TextEditingController();
   TextEditingController Agingt_Controller = new TextEditingController();

   AppTheam theam = AppTheam();
   CUWidgets cw=CUWidgets();

   getItemIndex(dynamic item) {
     var index = StockData.indexOf(item);
     return index + 1;
   }

   //  get Token
   read() async {
     print("pass data");

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



   GetAgingRpt()async {
     String url = "${Env.baseUrl}GTStockAging/1";


     int Aginnum=int.parse(Agingt_Controller.text);
    var dd= DateTime.parse(DateFromController.text);
     var yy=dd.add(new Duration(days: -Aginnum));
     print(yy.toString());
     final dateFormatter = DateFormat('yyyy-MM-dd');
     final dateString = dateFormatter.format(yy);

     var parm = {
       "dateFrom": dateString,
     };

     //print(parm);
     var jsonParse = json.encode(parm);
     print(jsonParse);
     try {
       final res =
       await http.post(url as Uri,
           headers: {
             'accept': 'application/json',
             'content-type': 'application/json',
             'Authorization': token,
           },
           body: jsonParse);
       print(res.body);
       if (res.statusCode == 200) {
         setState(() {
           var parseJson = json.decode(res.body);
           StockData=parseJson["details"]["data"];
           print(StockData);
         });

       }else{
         setState(() {
           StockData.clear();
         });
       }
     } catch (e) {
       print("error on  unit= $e");
     }
   }




   Clear(){

     setState(() {
       StockData=[];
       DateFromController.text = date;
       Agingt_Controller.text = "0";
     });

   }


   void initState() {
     SharedPreferences.getInstance().then((value) {
       pref = value;
       read();
       DateFromController.text=date;
       Agingt_Controller.text="0";
     });
     super.initState();
   }

   Future<bool> _onBackPressed() {
     Navigator.pop(context);
     return Future.value(true);
   }







   // -------------------------All functions End------------------------------------------------------------------

   @override
   Widget build(BuildContext context) {
     return SafeArea(
       child: Scaffold(
         resizeToAvoidBottomInset: false,
//    key: scaffoldKey,
         appBar: PreferredSize(
             preferredSize: Size.fromHeight(190.0),
             child:  Appbarcustomwidget(uname: userName, branch: branchName, pref: pref, title:"Stock Aging Report")
         ),
         body: ListView(children: <Widget>[


           SizedBox(
             height: 10,
           ),

           Row(
             children: [
               SizedBox(width: 10),
               Expanded(
                 child: TextFormField(
                   style: TextStyle(fontSize: 15),
                   showCursor: true,
                   controller: DateFromController,
                   enabled: true,
                   validator: (v) {
                     if (v!.isEmpty) return "Required";
                     return null;
                   },
                   cursorColor: Colors.black,

                   scrollPadding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                   keyboardType: TextInputType.datetime,
                   readOnly: true,

                   onTap: () async {
                     final DateTime now = DateTime.now();
                     DateTime? date = await showDatePicker(
                         context: context,
                         initialDatePickerMode: DatePickerMode.day,
                         initialDate: now,
                         firstDate:DateTime(1900),// now.subtract(Duration(days: 1)),
                         lastDate: DateTime(2080),
                         builder: (BuildContext context, Widget? child) {
                           return Theme(
                             data: ThemeData.light(),
                             child: child!,
                           );
                         });

                     // if (date != null) {
                     //   print(date);
                     //   if (date.day < DateTime.now().day) {
                     //     print("invalid date select");
                     //
                     //     DateFromController.text = "";
                     //     return;
                     //   } else {
                     var d = DateFormat("yyyy-MM-d").format(date!);
                     DateFromController.text = d;
                     //   }
                     // }
                   },
                   decoration: InputDecoration(
                     errorStyle: TextStyle(color: Colors.red),
                     errorText: deliveryDateSelect ? "invalid date " : null,
                     suffixIcon: Icon(
                       Icons.calendar_today,
                       color: Colors.blue,
                       size: 24,
                     ),
                     isDense: true,
                     contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                     border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(TextBoxCurve)),
                     // curve brackets object
                     hintText: "From Date:dd/mm/yy",
                     hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                     labelText: "From Date",
                   ),
                 ),
               ),

               SizedBox(width: 10),
             ],
           ),


           SizedBox(height:8),
           Row(
             children: [
               SizedBox(width: 10),
               Expanded(
                 child: cw.CUTestbox(controllerName: Agingt_Controller,
                 label:"Aging LessThan" )
               ),

               SizedBox(width: 10),
             ],
           ),


           SizedBox(
             height: 10,
           ),

           Padding(
             padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
             child: Row(
               children: [
                 Expanded(
                   child: ElevatedButton(
                       style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green.shade700)),
                       onPressed: () {
                         GetAgingRpt();
                       },
                       child: Text("Show",
                         style: TextStyle(fontSize: 25),)),
                 ),
                 SizedBox(width: 5,),
                 Expanded(
                   child: ElevatedButton(
                       style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.indigo)),
                       onPressed: () {
                         Clear();
                       },
                       child: Text("Clear",
                         style: TextStyle(fontSize: 25),)),
                 ),


                 Visibility(
                     visible:StockData.length>0 ,
                     child:IconButton(icon: Icon(Icons.print), onPressed: (){
                       Navigator.push(
                           context,
                           MaterialPageRoute(
                               builder: (context) => Dynamic_Pdf_Print(
                                 Parm_Id: 29,
                                 Details_Data: StockData,
                                 title:"STOCK AGING REPORT" ,

                               )));
                     }))

               ],
             ),
           ),

// ----------------------table------------------

           Container(
             child: StockData.length > 0
                 ? Row(
//            verticalDirection: VerticalDirection.down,
//            crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 SizedBox(
                   width: 10,
                 ),
                 Expanded(
                     child: SingleChildScrollView(
                       scrollDirection: Axis.horizontal,
                       child: SingleChildScrollView(
                         scrollDirection: Axis.vertical,
                         child: DataTable(
                           columnSpacing: 17,
                           onSelectAll: (b) {},
                           sortAscending: true,
                           columns: <DataColumn>[
                             DataColumn(
                               label: Text('#'),
                             ),
                             DataColumn(
                               label: Text('Item Name'),
                             ),
                             DataColumn(
                               label: Text('Stock'),
                             ),

                           ],
                           rows: StockData
                               .map(
                                 (itemRow) => DataRow(
                               cells: [
                                 DataCell(
                                   Text(getItemIndex(itemRow)
                                       .toString()),
                                   showEditIcon: false,
                                   placeholder: false,
                                 ),
                                 DataCell(
                                   Text(
                                       itemRow['itm_Name'].toString()),
                                   showEditIcon: false,
                                   placeholder: false,
                                 ),
                                 DataCell(
                                   Text(itemRow['stock']
                                       .toStringAsFixed(3)),
                                   showEditIcon: false,
                                   placeholder: false,
                                 ),

                               ],
                             ),
                           )
                               .toList(),
                         ),
                       ),
                     )),
                 SizedBox(
                   width: 10,
                 )
               ],
             )
                 : Container(
               height: 400,
               child: Center(child: Text("No Data Found")),
             ),
           ),

           WillPopScope(
             onWillPop: _onBackPressed,
             child: Text(""),
           ),

//---------------------------------------------------------
//-------------------------table ead------------------
         ]),







         bottomSheet: Padding(
           padding: const EdgeInsets.only(left: 15,bottom: 15),
           child: FloatingActionButton(

               backgroundColor: Colors.blue,
               hoverColor: Colors.red,  elevation: 5,

               child: Icon(Icons.home_filled),


               onPressed: (){
                 Navigator.pushAndRemoveUntil(context,
                     MaterialPageRoute(builder:(context) =>
                         SalesManHome()), (route) => false);
               }),

         ),

         floatingActionButton:SpeedDial(
           animatedIcon:AnimatedIcons.menu_arrow,overlayColor: Colors.blue,
           children: [

             SpeedDialChild(
                 child: Icon(Icons.add_shopping_cart_sharp),
                 backgroundColor: Colors.blue,
                 label: "Sales",
                 onTap:(){
                   Navigator.push(
                       context,
                       MaterialPageRoute(
                           builder: (context) =>Newsalespage(passvalue:salesLedgerId,passname:custValue.toString(),)));
                 } ),

             SpeedDialChild(
                 child: Icon(Icons.remove_shopping_cart_rounded),
                 backgroundColor: Colors.blue,
                 label: "Sales Return",
                 onTap:(){
                   Navigator.push(
                       context,
                       MaterialPageRoute(
                           builder: (context) => SalesReturn(passvalue:salesLedgerId,passname:custValue.toString(),)));
                 } ),



             SpeedDialChild(
                 child: Icon(Icons.description_outlined),
                 backgroundColor: Colors.blue,
                 label: "Receipt Collection",
                 onTap:(){
                   Navigator.push(
                       context,
                       MaterialPageRoute(
                           builder: (context) =>ReceiptCollections(passvalue:salesLedgerId.hashCode,passname:custValue.toString(),)));
                 } ),

             SpeedDialChild(
                 child: Icon(Icons.shopping_cart),
                 backgroundColor: Colors.blue,
                 label: "Sales Order",
                 onTap:(){
                   Navigator.push(
                       context,
                       MaterialPageRoute(
                           builder: (context) =>SalesOrder(passvalue:salesLedgerId,passname: custValue.toString(),)));
                 } ),

             SpeedDialChild(
                 child: Icon(Icons.remove_red_eye_outlined),
                 backgroundColor: Colors.blue,
                 label: "Shop Visited",
                 onTap:(){
                   Navigator.push(
                       context,
                       MaterialPageRoute(
                           builder: (context) => shopvisited(passvalue:salesLedgerId,passname:custValue.toString(),)));
                 } ),

           ],
         ),
       ),


     );
   }
 }





 class Payment_Type {
   Payment_Type({
     required this.id,
     required this.paymentType,
     required this.isActive,

   });

   int id;
   String paymentType;
   bool isActive;


   factory Payment_Type.fromJson(Map<String, dynamic> json) => Payment_Type(
     id: json["id"],
     paymentType: json["paymentType"],
     isActive: json["isActive"],

   );

   Map<String, dynamic> toJson() => {
     "id": id,
     "paymentType": paymentType,
     "isActive": isActive,
   };
 }




