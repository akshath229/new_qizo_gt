import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';

//import 'dart:io';
import 'dart:ui';
//import 'package:intl/intl.dart';

import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:new_qizo_gt/urlEnvironment/urlEnvironment.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

//import 'package:autocomplete_textfield/autocomplete_textfield.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'models/expenseCollection.dart';
import 'models/expenseSheet.dart';
import 'models/userdata.dart';
//import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';

//import 'package:http/http.dart' as http;

class ExpenseSheetSalesMan extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<ExpenseSheetSalesMan> {
  String url = "${Env.baseUrl}MobExpenseSheetheaders";

  late SharedPreferences pref;
  TextEditingController amountController = new TextEditingController();
  TextEditingController particularsController = new TextEditingController();
  TextEditingController expenseTotalController = new TextEditingController();
  dynamic user;
  dynamic branchName;
  dynamic userName;
  final picker = ImagePicker();
  static List<ExpenseAdd> expenseAd = [];
  late ExpenseAdd expense;
  String noImage = "-No Image-";

  static List<ExpenseCollect> expenseCollections = [];
  late ExpenseCollect expenseCollect;
  double expenseTotal = 0;
  late bool loadingResReceiptAdd;
  dynamic latitude;
  dynamic longitude;
  bool particularSelect = false;
  bool amountSelect = false;

  void initState() {
    expenseTotal = 0;
    print(url);
    SharedPreferences.getInstance().then((value) {
      pref = value;
      read();
      _getLocation();
    });
    // token get fun  this

//    getUsers();
    super.initState();
  }

  read() async {
    var v = pref.getString("userData");
    print("USER DATA: $v");
    var c = json.decode(v!);

    user = UserData.fromJson(c); // token gets this code user.user["token"]

    setState(() {
      print("user data................");
      print(user.user["token"]);
      pref.setString("customerToken", user.user["token"]);
      branchName = user.branchName;
      userName = user.user["userName"];
      print(".....");
      print(branchName);
      print(userName);
    });

//    getCustomer();
//    showDialog(
//        context: context,
//        builder: (context) => AlertDialog(
//              title: Text("data:   " + user.branchName),
//              content: Text("user data:   " + user.user["token"]),
//            ));
  }

//  get location longitute and latitude
  _getLocation() async {
    print("location");
    Geolocator geolocator = Geolocator();
    print(geolocator);

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    debugPrint('location: ${position.latitude}');
    print("latitude :");
    print(position.latitude);
    latitude = position.latitude;
    longitude = position.longitude;

    print("longitude:");
    print(position.longitude);

    // Your commented out code remains untouched...
  }


  validationRcvAmt() {
    if (amountController.text == "") {
      amountSelect = true;
      validationRemarks();
    } else {
      amountSelect = false;
      validationRemarks();
    }
  }

  validationRemarks() {
    if (particularsController.text == "") {
      particularSelect = true;
    } else {
      particularSelect = false;
    }
  }

  // Save Receipt Now
  receiptNow() {
    setState(() {
      correctValidateNow();
    });
  }

  getIndexRows(dynamic item) {
    int i = expenseAd.indexOf(item);
    return i + 1;
  }

  addCustomerReceipt() async {
    print("add...... ");
//     receiptCollection.clear();
//     customerReceipts.clear();
//     return;
    setState(() {
      validationRcvAmt();
    });

    if (amountController.text == "" || particularsController.text == "") {
      print("check fields");
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("check fields"),
              ));
      return;
    }
    if (amountController.text == "" || particularsController.text == "") {
      return;
    }

    Widget cameraButton = FloatingActionButton(
      backgroundColor: Colors.lightBlueAccent,
      child: Icon(Icons.camera_alt),
      onPressed: () {
        setState(() {
          print("camera...");
          picImageFromCamera();
          Navigator.pop(context);
        });

//        alert.hide();
      },
    );
    Widget galleryButton = FloatingActionButton(
      backgroundColor: Colors.lightBlueAccent,
      child: Icon(
        Icons.camera,
      ),
      onPressed: () {
        setState(() {
          print("No image...");
          picImageFromGallery();
          Navigator.pop(context);
        });

//        alert.hide();
      },
    );

    Widget noImageButton = FloatingActionButton(
      backgroundColor: Colors.red,
      child: Icon(Icons.not_interested),
      onPressed: () {
        setState(() {
          print("No...");
          addingReceiptWithOutPhoto();
          Navigator.pop(context);
        });

//        alert.hide();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Center(child: Text("Select Option")),
//      content: Text("This is my message."),
      actions: [cameraButton, galleryButton, noImageButton],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    return;
  }

  // image pic from camera
  picImageFromCamera() async {
    var amount = double.parse(amountController.text);
    print(amount);
    print(expenseAd.length);
    print(amountController.text);
    print(particularsController.text);

    var pic = await picker.pickImage(
        source: ImageSource.camera, imageQuality: 30); // reduce it

    print("path  is....not null");

    print("Hello: " + (pic?.path as String));

    expense = ExpenseAdd(
        esdSlno: expenseAd.length,
        esAmount: double.parse(amountController.text),
        esImagePath: await pic?.readAsBytes(),
        esParticulars: particularsController.text);
    expenseTotal = expenseTotal + expense.esAmount;
    setState(() {
      expenseAd.add(expense);
    });
//    print("Hello: "+pic.toString());

    particularsController.text = "";
    amountController.text = "";
    print("2nd array length");
    print(expenseCollections.length);
    print("1st array length");
    print(expenseAd.length);
  }

  // pic get from gallery
  picImageFromGallery() async {
    var amount = double.parse(amountController.text);
    print(amount);
    print(expenseAd.length);
    print(amountController.text);
    print(particularsController.text);

    var pic = await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 30); // reduce it

    print("path  is....not null");

    print("Hello: " + pic.toString());

    expense = ExpenseAdd(
        esdSlno: expenseAd.length,
        esAmount: double.parse(amountController.text),
        esParticulars: particularsController.text,
        esImagePath: await pic?.readAsBytes());
    expenseTotal = expenseTotal + expense.esAmount;
    setState(() {
      expenseAd.add(expense);
    });
//

    print("Hello: " + pic.toString());

    particularsController.text = "";
    amountController.text = "";
    print("2nd array length");
    print(expenseCollections.length);
    print("1st array length");
    print(expenseAd.length);
  }

  addingReceiptWithOutPhoto() {
    print("null....... path");

    var amount = double.parse(amountController.text);
    print(amount);
    print(expenseAd.length);
    print(amountController.text);
    print(particularsController.text);

    expense = ExpenseAdd(
        esdSlno: expenseAd.length,
        esAmount: double.parse(amountController.text),
        esImagePath: null,
        esParticulars: particularsController.text);
    expenseTotal = expenseTotal + expense.esAmount;
    setState(() {
      expenseAd.add(expense);
    });
//

//    print("Hello: "+pics.toString());

    particularsController.text = "";
    amountController.text = "";
    print("2nd array length");
    print(expenseCollections.length);
    print("1st array length");
    print(expenseAd.length);
  }

  // remove customer items
  removeListElement(ExpenseAdd item) {
    setState(() {
//      int i = customerReceipts.indexOf(item);
      expenseAd.remove(item);

      expenseTotal = expenseTotal - item.esAmount;
      print("st array length");
      print(expenseAd.length);
      print("2nd array length");
      print(expenseCollections.length);

//      customerReceipts.removeWhere((element) => element.slNo == item.slNo);
//      receiptTotal = receiptTotal - item.receivedAmount;
//      receiptCollection.removeWhere((element) => element == item);
    });
  }

  //  passing api to files and index
  correctValidateNow() {
    expenseCollections.clear();
    setState(() {
      if (expenseAd.length <= 0) {
        expenseCollections.clear();
//      validationRcvAmt();
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(
                    "Please Add Expense",
                    style: TextStyle(color: Colors.red),
                  ),
//            content: Text("$customerName"),
                ));
        return;
      }
      print(expenseCollections);
      loadingResReceiptAdd = true;
    });

    if (expenseAd.length <= 0) {
      return;
    }

    var params = new Map<String, dynamic>();

    expenseAd.asMap().forEach((i, rece) {
      print(rece.esImagePath);
      if (rece.esImagePath != null) {
        expenseCollect = ExpenseCollect(
            esdSlno: i,
            esAmount: rece.esAmount,
            esImagePath: i,
            esParticulars: rece.esParticulars);
        print("$i");
        params["$i.jpg"] = MultipartFile.fromBytes(rece.esImagePath ?? [],
            filename: "$i.jpg"); //

        expenseCollections.add(expenseCollect);
      } else {
        expenseCollect = ExpenseCollect(
            esdSlno: i,
            esAmount: rece.esAmount,
            esImagePath: "-",
            esParticulars: rece.esParticulars);

        expenseCollections.add(expenseCollect);
      }
    });

    print("length of last List");
    print(expenseCollections.length);

//    return;
    var req = {
      "eshLatitude": latitude.toString(),
      "eshLongitude": longitude.toString(),
      "mobExpenseSheetDetails":
          expenseCollections.map((exp) => exp.toJson()).toList()
    };
//    var req = {
//      "rhCustId": salesLedgerId,
//      "rhLatitude": latitude.toString(),
//      "rhLongitude": longitude.toString(),
//      "mobSmrctCollectionDetails":
//      receiptCollection.map((receipt) => receipt.toJson()).toList()
//    };

    var map = json.encode(req);
    print(map);
    params["jsonString"] = map;
    print(params);
    FormData form = new FormData.fromMap(Map.from(params));
    print(form);
    view(form);
  }

  view(dynamic form) async {
    var prs = new ProgressDialog(
      context,
      type: ProgressDialogType.normal,
      isDismissible: true,
      showLogs: true,
    );
    prs.style(
      message: "Adding Expense", //
//      progress: 0.0,
//      maxProgress: 100.0,
    );

    prs.show();
    var dio = Dio();
   print(url);
       var res = await dio.post(
      url,
      data: form,
//      onSendProgress: (int sent, int total) {
//        print("$sent $total");
//      },
      options: Options(
        headers: {
          'content-type': 'multipart/form-data',
          'Authorization': user.user['token'],
          'deviceId':user.deviceId
        },
        followRedirects: false,
        validateStatus: (status) {
          return status! <= 500;
        },
      ),
    );
    print(res.statusCode);
    if (res.statusCode == 200 ||
        res.statusCode == 201 && expenseCollections.length > 0) {
      print(res.data);
      prs.hide();

      loadingResReceiptAdd = false;
      setState(() {
        expenseCollections.clear();
        expenseAd.clear();
        expenseTotal = 0;

        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Expense Added Success"),
//              content: Text("$customerName"),
                ));
        Timer(Duration(seconds: 2), () {
          print("Yeah, this line is printed after 2 seconds");

          Navigator.pop(context);






        });
      });
    }
  }

//  view(dynamic form) async {
//    var prs = new ProgressDialog(
//      context,
//      type: ProgressDialogType.Normal,
//      isDismissible: true,
//      showLogs: true,
//    );
//    prs.style(
//      message: "Adding Receipt", //
////      progress: 0.0,
////      maxProgress: 100.0,
//    );
//
//    prs.show();
//    var dio = Dio();
//
//    var res = await dio.post(
//      "${Env.baseUrl}MobExpenseSheetheaders",
//      data: form,
////      onSendProgress: (int sent, int total) {
////        print("$sent $total");
////      },
//      options: Options(
//        headers: {
//          'content-type': 'multipart/form-data',
//          'Authorization': user.user['token']
//        },
//        followRedirects: false,
//        validateStatus: (status) {
//          return status <= 500;
//        },
//      ),
//    );
//    print(res.statusCode);
//    if (res.statusCode == 200 ||
//        res.statusCode == 201 ) {
//      print(res.data);
//      loadingResReceiptAdd = false;
//      setState(() {
//        prs.hide();
//        expenseCollections.clear();
//        expenseAd.clear();
//        particularsController.text = "";
//        amountController.text = "";
//        showDialog(
//            context: context,
//            builder: (context) => AlertDialog(
//              title: Text("Expense Added Success"),
//            ));
//
//        expenseTotal = 0;
//      });
//    }
//  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(190.0),
        child: Container(
          height: 80,
          color: Colors.blue,
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
//                    SizedBox(width: 10,),

                  GestureDetector(
                      onTap: () {
                        print("hi");
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
                                image: AssetImage("assets/Home_image.jpg"),
                                fit: BoxFit.fill
                            )
                        ),
                          margin: new EdgeInsets.only(
                                left: 0.0, top: 5.0, right: 0.0, bottom: 0.0),
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
                        "Expense Sheet",
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
      body: ListView(
        children: [
          SizedBox(
            height: 6,
          ),
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextFormField(
                  controller: particularsController,
                  enabled: true,
                  validator: (v) {
                    if (v!.isEmpty) return "Required";
                    return null;
                  },
//
                  // will disable paste operation
//                  focusNode: field1FocusNode,
                  cursorColor: Colors.black,

                  scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                  keyboardType: TextInputType.text,

                  decoration: InputDecoration(
                    errorStyle: TextStyle(color: Colors.red),
                    errorText:
                        particularSelect ? "Please Type Particulars" : null,
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 16.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0)),
                    hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                    labelText: "Particulars",
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          SizedBox(
            height: 6,
          ),
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextFormField(
                  controller: amountController,

                  enabled: true,
                  validator: (v) {
                    var t = v.runtimeType;
                    if (v!.isEmpty || t == double || t == int) return "Required";
                    return null;
                  },
//
                  // will disable paste operation
//                  focusNode: field1FocusNode,
                  cursorColor: Colors.black,

                  scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                  keyboardType: TextInputType.number,

                  decoration: InputDecoration(
                    errorStyle: TextStyle(color: Colors.red),
                    errorText: amountSelect ? "Invalid amount" : null,
//                    suffixIcon: Icon(
//                      Icons.calendar_today,
//                      color: Colors.blue,
//                      size: 24,
//                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 16.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0)),

                    // curve brackets object
//                    hintText: "Quantity",
                    hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                    labelText: "Amount",
                  ),
                ),
              ),
              SizedBox(
                width: 4,
              ),
              SizedBox(width: 4),
              SizedBox.fromSize(
                size: Size(45, 45), // button width and height
                child: ClipOval(
                  child: Material(
                    color: Colors.lightBlueAccent, // button color
                    child: InkWell(
                      splashColor: Colors.green, // splash color
                      onTap: addCustomerReceipt,
//                      onPressed: ,
                      // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ), // icon
//                          Text("Call"), // text
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
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
                    receiptNow();
                  },
                  child: Container(
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
                  )),

              SizedBox(
                width: 140,
              ),
              GestureDetector(
                  onTap: () {
                    print("Reset");
                    setState(() {
                      particularsController.text = "";
                      amountController.text = "";
                      amountSelect = false;
                      particularSelect = false;
                      expenseAd.clear();
                      expenseTotal = 0;
                    });
                  },
                  child: Container(
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
                  )),
              // Padding(
              //   padding: EdgeInsets.only(left: 164.0, right: 0.0),
              //   child: RaisedButton(
              //     textColor: Colors.white,
              //     color: Colors.lightBlueAccent,
              //     child: Text("Reset"),
              //     onPressed: () {
              //       setState(() {
              //         customerSelect = false;
              //         deliveryDateSelect = false;
              //         rateSelect = false;
              //         quantitySelect = false;
              //         itemSelect = false;
              //         paymentSelect = false;
              //         customerItemAdd.clear();
              //         sales.clear();
              //         customerController.text = "";
              //         salesdeliveryController.text = "";
              //         generalRemarksController.text = "";
              //         paymentController.text = "";
              //         grandTotal = 0;
              //         salesPaymentId = 0;
              //         salesItemId = 0;
              //         salesLedgerId = 0;
              //       });
              //     },
              //     shape: new RoundedRectangleBorder(
              //       borderRadius: new BorderRadius.circular(14.0),
              //     ),
              //   ),
              // ),
            ],
          ),
          // Row(
          //   children: [
          //     SizedBox(
          //       width: 10,
          //     ),
          //     Padding(
          //       padding: EdgeInsets.only(left: 0.0, right: 0.0),
          //       child: RaisedButton(
          //         textColor: Colors.white,
          //         color: Colors.lightBlueAccent,
          //         child: Text("Save"),
          //         onPressed: receiptNow,
          //         shape: new RoundedRectangleBorder(
          //           borderRadius: new BorderRadius.circular(14.0),
          //         ),
          //       ),
          //     ),
          //     Padding(
          //       padding: EdgeInsets.only(left: 163.0, right: 0.0),
          //       child: RaisedButton(
          //         textColor: Colors.white,
          //         color: Colors.lightBlueAccent,
          //         child: Text("Reset"),
          //         onPressed: () {
          //           setState(() {
          //             particularsController.text = "";
          //             amountController.text = "";
          //             amountSelect = false;
          //             particularSelect = false;
          //             expenseAd.clear();
          //             expenseTotal = 0;
          //           });
          //         },
          //         shape: new RoundedRectangleBorder(
          //           borderRadius: new BorderRadius.circular(14.0),
          //         ),
          //       ),
          //     ),
          //     SizedBox(
          //       width: 10,
          //     ),
          //   ],
          // ),
          SizedBox(
            height: 6,
          ),
          Visibility(
            visible: expenseAd.length > 0,
            child: Row(
//            verticalDirection: VerticalDirection.down,
//            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
//                      columnSpacing: 17,
                      onSelectAll: (b) {},
                      sortAscending: true,
                      columns: <DataColumn>[
                        DataColumn(
                          label: Text('#'),
                        ),
                        DataColumn(
                          label: Text('Particulars'),
                        ),
                        DataColumn(
                          label: Text('Amount'),
                        ),
                        DataColumn(
                          label: Text('images'),
                        ),
                        DataColumn(
                          label: Text(' '),
                        ),
                      ],
                      rows: expenseAd
                          .map(
                            (itemRow) => DataRow(
                              cells: [
                                DataCell(
                                  Text(getIndexRows(itemRow).toString()),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(itemRow.esParticulars),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(itemRow.esAmount.toString()),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 50,
                                    height: 150,
                                    child: itemRow.esImagePath != null
                                        ? Image.memory(itemRow.esImagePath,
                                            fit: BoxFit.cover)
                                        : Text(
                                            noImage.toString(),
                                            style: TextStyle(height: 10),
                                          ),
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  TextButton(

                                    child: Icon(Icons.delete),
                                    onPressed: () {
                                      setState(() {
                                        removeListElement(itemRow);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                )
              ],
            ),
          ),
          Visibility(
            visible: expenseTotal > 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 90,
                ),
                Expanded(
                  child: TextField(
                    readOnly: true,
                    controller: expenseTotalController,
                    style: TextStyle(
                        color: Colors.lightBlue,
//                      fontFamily: Font.AvenirLTProMedium.value,
                        fontSize: 17),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Total Amount : $expenseTotal',
                      hintStyle: TextStyle(
                        fontSize: 17,
                        color: Colors.red,
                        backgroundColor: Colors.white10,
//                          fontFamily: Font.AvenirLTProBook.value)
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
