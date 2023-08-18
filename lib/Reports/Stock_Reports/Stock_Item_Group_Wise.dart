 import 'dart:convert';
 import 'package:flutter/material.dart';

 import 'package:flutter_speed_dial/flutter_speed_dial.dart';
 import 'package:intl/intl.dart';
 import 'package:shared_preferences/shared_preferences.dart';
 import 'package:http/http.dart' as http;

 import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../GT_Masters/AppTheam.dart';
import '../../GT_Masters/Masters_UI/cuWidgets.dart';
import '../../appbarWidget.dart';
import '../../models/userdata.dart';
import '../../receiptcollection.dart';
import '../../sales.dart';
import '../../salesmanhome.dart';
import '../../salesorder.dart';
import '../../salesreturn.dart';
import '../../shopvisited.dart';
 // ledger balance page
 class StockItm_Grp_Wise extends StatefulWidget {

   @override
   _StockItm_Grp_Wise createState() => _StockItm_Grp_Wise();
 }

 class _StockItm_Grp_Wise extends State<StockItm_Grp_Wise>
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
   var GdwnId=null;
   var ItemId=null;
   var ItemTypId=2;


   var StockItm_Grp_Wise_Data=[];



   AppTheam theam = AppTheam();
   CUWidgets cw=CUWidgets();



   getItemIndex(dynamic item) {
     var index = StockItm_Grp_Wise_Data.indexOf(item);
     return index + 1;
   }

   void initState() {
     SharedPreferences.getInstance().then((value) {
       pref = value;
       read();
       getStock_itm_Grp_Wise();
     });
     super.initState();
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




   getStock_itm_Grp_Wise() async {
     print("uikuyo");

     try {

       var parsData={
         "itemGroupId": -1,
         "itemId": -1
       };
       var jsonParse=json.encode(parsData);
       var jsonres = await cw.post(api:"GTStockGroup/1", Token: token,body:jsonParse);

       if (jsonres != false) {
         var res = jsonDecode(jsonres);
         //  print("ItemList = $res");
         setState(() {
           StockItm_Grp_Wise_Data=res["details"]["data"];
           print(StockItm_Grp_Wise_Data);
           print(StockItm_Grp_Wise_Data.length.toString());
         });
// return usersFiltered;
       }
     } catch (e) {
       print("error" + e.toString());
     }

   }




   Future<bool> _onBackPressed() {
     Navigator.pop(context);
     return Future.value(true);
   }


   Clear(){

     setState(() {
       StockItm_Grp_Wise_Data.clear();
     });

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
             child:  Appbarcustomwidget(uname: userName, branch: branchName, pref: pref, title:"Stock Report")
         ),
         body: ListView(children: <Widget>[

           Container(
             child: StockItm_Grp_Wise_Data.length > 0
                 ? Row(
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
                               label: Text('Grou Name'),
                             ),
                             DataColumn(
                               label: Text('Qty'),
                             ),
                           ],
                           rows: StockItm_Grp_Wise_Data
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
                                       itemRow['GroupdName'].toString()),
                                   showEditIcon: false,
                                   placeholder: false,
                                 ),
                                 DataCell(
                                   Text(itemRow['Qty']
                                       .toStringAsFixed(2)),
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














