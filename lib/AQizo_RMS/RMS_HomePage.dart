import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';


import '../GT_Masters/Masters_HomePage.dart';
import '../PaymentVoucherIndex_Direct.dart';
import '../PaymentVoucher_Direct.dart';
import '../Purchase.dart';
import '../Purchase_Index.dart';
import '../Purchase_Return.dart';
import '../Purchase_Rtn_Index.dart';
import '../Reports/Report_Home.dart';
import '../appbarWidget.dart';
import '../indexpage.dart';
import '../itemBill.dart';
import '../itemBill_Index.dart';
import '../models/userdata.dart';
import '../receiptcollection_Direct.dart';
import '../receiptcollectionindex_Direct.dart';
import '../sales.dart';
import '../salesindex.dart';
import '../set_CustomerLocation.dart';
import 'New_Delivery_App/Del_ItemHome.dart';
import 'Rms_ItemBill_Index.dart';
import 'Rms_MakeOrder.dart';

class Rms_Homes extends StatefulWidget {
  @override
  _Rms_HomesState createState() => _Rms_HomesState();
}

class _Rms_HomesState extends State<Rms_Homes> {
  void initState() {
    setState(() {
      SharedPreferences.getInstance().then((value) {
        pref = value;
        read();
      });
    });
  }

//------------------For App Bar------------------------
  late SharedPreferences pref;
  dynamic branch;
  var res;
  dynamic user;
  late int branchId;
  late int userId;
  late UserData userData;
  String branchName = "";
  dynamic userName;
  late String token;

  read() async {
    var v = pref.getString("userData");
    var c = json.decode(v!);
    user = UserData.fromJson(c); // token gets this code user.user["token"]
    setState(() {
      branchId = int.parse(c["BranchId"]);
      token = user.user["token"]; //  passes this user.user["token"]
      pref.setString("customerToken", user.user["token"]);
      branchName = user.branchName;
      userName = user.user["userName"];
      userId = user.user["userId"];
    });
  }

//--------------END----For App Bar--end--------------------------------------

  @override
  Widget build(BuildContext context) {
    var ScreenSize = MediaQuery
        .of(context)
        .size;
    return SafeArea(
        child: Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(190.0),
                child: Appbarcustomwidget(
                  branch: branchName,
                  pref: pref,
                  title: "RMS Home",
                  uname: userName,
                )),


            body: ListView(children: <Widget>[





              NewHomePage(ScreenSize.width, ScreenSize.height),


              CircleButtonNavigate(context),


            ])));
  }


  Widget NewHomePage(width, height) {
    var Mstr_Name_lst = ["Masters", "Transaction", "Reports", "Utility ",];

    return Padding(
        padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
        child: GridView.builder(physics: ScrollPhysics(),
          itemCount: 4,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            childAspectRatio: width > 500 ? 3 : 1.5,
          ),
          itemBuilder: (c, i) {
            return Container(color: Colors.teal.shade900,
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal, // sets the background color
                    onPrimary: Colors.white, // sets the color of the text and icons
                    textStyle: TextStyle(
                      fontSize: 25.0,
                    ),
                  ),
                  onPressed: () {
                    print("index :  $i");
                    setState(() {
                      SelectedPage(i);
                    });
                  },
                  child: Text(Mstr_Name_lst[i]),
                ),

              ),
            );
          },
        ));
  }


  ///----------------------------------------------------------


  SelectedPage(a) {
    switch (a.toString()) {
      case "0":
        {
          pageNavigate(Masters_Home_Pgae());
        }
        break;

      case "1":
        {
          pageNavigate(CustomerVisited());
        }
        break;

      case "2":
        {
          pageNavigate(Report_Home_Pgae());
        }
        break;
      case "3":
        {
          // PageNavigate(CustomerVisited());
        }
        break;

    // break;
    // case "6": {
    //   PageNavigate(Test());
    // }
      default:
        {
          print("Not Selected");
        }
        break;
    }
  }


  Widget pageNavigate(Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Icon(Icons.navigate_next),  // or any other visual widget
    );
  }



  Widget CircleButtonNavigate(context) {
    return Column(
      children: [


        Button_List(
          context: context,
          name: "Item Bill",
          mainIcon: Icons.apps,
          // routAddPage: Rms_ItemBill(),
          routAddPage: Del_ItemHome(),
          routListPage: Rms_ItemBill_Index(),
        ),



        Button_List(
          context: context,
          name: "Make Order",
          mainIcon: Icons.apps,
          routAddPage: Rms_MakeOrder(),
          routListPage: Rms_MakeOrder(),
        ),





        Button_List(
          context: context,
          name: "Purchase",
          mainIcon: Icons.add_business,
          routAddPage: Purchase(passvalue: 0, passname: null.toString()),
          routListPage: Purchase_Index(),
        ),


        Button_List(
        context: context,
          name: "Sales",
          mainIcon: Icons.shopping_cart,
          routAddPage:Newsalespage(
            passvalue: 0,
            passname: null.toString(),
          ),
          routListPage: salesindex(),
        ),


        Button_List(
          context: context,
          name: "Purchase Return",
          mainIcon: Icons.assignment_return_outlined,
          routAddPage: PurchaseReturn(
            passvalue: 0,
            passname: null.toString(),
          ),
          routListPage: Purchase_Rtn_Index(),
        ),


        //
        // Button_List(
        //   name: "Sales Return",
        //   mainIcon: Icons.remove_shopping_cart_rounded,
        //   routAddPage:SalesReturn(
        //     passvalue: null,
        //     passname: null.toString(),
        //   ),
        //   routListPage:Sales_Rtn_Index(),
        // ),


        Button_List(
            context: context,
            name: "Receipt Collection",
            mainIcon: Icons.fact_check,
            routAddPage: ReceiptCollections_Direct(
              passvalue: 0,
              passname: null.toString(),
            ),
            routListPage: ReceiptCollectionIndex_Direct(passvalue: null)),


        Button_List(
            context: context,
            name: "Payment Collection",
            mainIcon: Icons.description_outlined,
            routAddPage: Payment_Voucher_Direct(
              passvalue: 0,
              passname: null.toString(),
            ),
            routListPage: Payment_VoucherIndex_Direct(passvalue: null)),



        Button_List(
            context: context,
            name: "Set Location",
            mainIcon: Icons.location_on_outlined,
            routAddPage:Set_Cust_Location(),
            routListPage:Set_Cust_Location()
        ),

        // IconButton(icon: Icon(Icons.qr_code, size: 35,), onPressed: () {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) =>
        //          // Del_Qr_Rreader()
        //       Del_Login_DeliveyMan()
        //            // RMS_SimPrint(Page_Type:false,Parm_Id: 51,)
        //        // TestArabicTermalPrint()
        //      // Rms_TestSimpPrint(Parm_Id: 51,)
        //          // Dynamic_Pdf_Print(Parm_Id: 5,)
        //         //  New_Model_PdfPrint(Parm_Id: 5,)
        //        //  Rms_Homes()
        //       //  TestRec_Pay_Print(Parm_Id: 11,printType: "Recpt",)
        //              //Testpage()
        //      ),
        //   );
        // })


      ],);
  }


  Padding Button_List({
    context,
    required IconData mainIcon,
    required String name,
    routAddPage,
    routListPage

  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 4),
      child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: 45,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.teal, width: 1),
              color: Colors.white,
              borderRadius: BorderRadius.circular(15)),
          child: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Icon(
                mainIcon,
                color: Colors.teal,
                size: 30,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                name,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.teal,
                  fontSize: 23,
                ),
              ),
              Spacer(),
              IconButton(
                  icon: Icon(
                    Icons.list_alt,
                    color: Colors.teal,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => routListPage),
                    );
                  }),
              SizedBox(
                width: 10,
              ),

              // IconButton(
              //     icon: Icon(
              //       Icons.add_circle_outline_sharp,
              //       color: Colors.teal,
              //       size: 30,
              //     ),
              //     onPressed: (){
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) =>routAddPage
              //         ),
              //       );
              //     }),

              InkWell(

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => routAddPage
                    ),
                  );
                },
                child: Icon(
                  Icons.add_circle_outline_sharp,
                  color: Colors.teal,
                  size: 30,
                ),
              ),
              SizedBox(
                width: 5,
              ),

            ],)),
    );
  }
}