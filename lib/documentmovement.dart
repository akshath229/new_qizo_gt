import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:new_qizo_gt/urlEnvironment/urlEnvironment.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import 'package:shared_preferences/shared_preferences.dart';
//import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';

import 'package:http/http.dart' as http;

import 'documentmovementindex.dart';
import 'models/userdata.dart';

class DocumentMoment extends StatefulWidget {
  @override
  _DocumentMomentState createState() => _DocumentMomentState();
}

class _DocumentMomentState extends State<DocumentMoment> {
  bool customerSelect = false;

  late String token;
  dynamic openingAmountBalance = 0.0;

  // final _focusNode = FocusNode();
  late String branchId;
  dynamic userArray;
  dynamic serverDate;

  String date = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  bool handOverToSelect = false;
  bool handOverFromSelect = false;
  dynamic pro;
  bool documentSelect = false;
  bool toEmployeeSelect = false;
  bool remarksSelect = false;
  dynamic user;
  dynamic salesLedgerId = 0;
  final picker = ImagePicker();
  dynamic voucherNo;
  late int customerSelectedId;
  late String customerSelectedEmail;
  late String customerSelectedName;

  TextEditingController controller = new TextEditingController();
  FocusNode field1FocusNode = FocusNode(); //Create first FocusNode
//  var _myKey = GlobalKey<FormState>();

  late String selectedLetter;
  TextEditingController customerController = new TextEditingController();
  TextEditingController documentNameController = new TextEditingController();
  TextEditingController toEmployeeController = new TextEditingController();
  TextEditingController handedOverToController = new TextEditingController();
  TextEditingController generalRemarksController = new TextEditingController();
  TextEditingController handedOverFromController = new TextEditingController();
  bool checkedValue = false;

  // GlobalKey<AutoCompleteTextFieldState<Customer>> key =
  //     new GlobalKey(); //only one autocomplte
  String selectedPerson = "";
  dynamic branchName;
  dynamic userName;
  String empCustLabel = "From Employee";
  PickedFile? pic;
  static List<dynamic> users = [];
  static List<dynamic> customers =[];
  bool loading = true;
  final letters = 'abcdefghijklmnopqrstuvwxyz'.split('');

  late SharedPreferences pref;

  void initState() {
    customerController.text = "";
//  goodsController.text = "";
    SharedPreferences.getInstance().then((value) {
      pref = value;
      read();
      // getEmployee();
      // getCustomer();
      getVoucherNumber();
      empCustLabel = "From Employee";
    });
    // token get fun  this

    // auto compelete fun
//    getUsers();
    super.initState();
    customerController.addListener(customerLedgerIdListener);
  }

  customerLedgerIdListener() {
    setState(() {
      salesLedgerId = 0;
      openingAmountBalance = 0.0;
      print(customerController.text);
      print("customer Id");
      // if (empCustLabel == "From Employee") {
      //   empCustLabel = "From Customer";
      // } else {
      //   empCustLabel = "From Employee";
      // }
      // print(_focusNode.hasFocus);
    });
  }

//get token
  read() async {
//    SharedPreferences pref = await SharedPreferences.getInstance();
    var v = pref.getString("userData");
    print("USER DATA: $v");
    var c = json.decode(v!);
    user = UserData.fromJson(
        c); // token gets this code user.user["token"] okk??? user res

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

  // get Voucher number
  getVoucherNumber() async {
    // http://erptestapi.qizo.in:811/api/getSettings/1/documentmanage
    var res = await http.get('${Env.baseUrl}getSettings/1/documentmanage' as Uri,
        headers: {'Authorization': user.user['token']});
    print(res.statusCode);
    print(res.body);
    var dt = json.decode(res.body);
    print(dt[0]['vocherNo']);
    voucherNo = dt[0]['vocherNo'];
  }

  // get Customer account
  getCustomer() async {
    try {
      // http://testcoreapi.qizo.in:809/api/
      final response =
      await http.get("${Env.baseUrl}MLedgerHeads/1/5" as Uri, headers: {
        "Authorization": user.user["token"],
      });
      print(response.statusCode);
      // print(response.body);

      if (response.statusCode == 200) {
        print('...................');
        Map<String, dynamic> data = json.decode(response.body);
        print("array is");
        // print(data["employeeMaster"]); //used  this to autocomplete
        print("........customer....");
        print(response.statusCode);
        print(data['lst']);
        // userArray = data["employeeMaster"];
        customers = (data["lst"] as List).toList();
//        users=loadUsers(s.toString());
        // s must be string or json  that will works it the loading will false okk??????  mustneed a function that will return to users okk??
//        users=loadUsers(s.toString());// s  to convert json ,now s is not in json okkk??
//        setState(() {
//          loading = false;
//        });
      } else {
        print("Error getting users");
      }
    } catch (e) {
      print("Error getting users");
    }
  }

// get Employee Mater account
  getEmployee() async {
    try {
      // http://testcoreapi.qizo.in:809/api/
      final response =
      await http.get("${Env.baseUrl}MemployeeMasters" as Uri, headers: {
        "Authorization": user.user["token"],
      });
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        print('...................');
        Map<String, dynamic> data = json.decode(response.body);
        print("array is");
        print(data["employeeMaster"]); //used  this to autocomplete
        print("........");
        print(response.statusCode);
        print(data["employeeMaster"]);
        userArray = data["employeeMaster"];
        users = (data["employeeMaster"] as List).toList();
//        users=loadUsers(s.toString());
        // s must be string or json  that will works it the loading will false okk??????  mustneed a function that will return to users okk??
//        users=loadUsers(s.toString());// s  to convert json ,now s is not in json okkk??
//        setState(() {
//          loading = false;
//        });
      } else {
        print("Error getting users");
      }
    } catch (e) {
      print("Error getting users");
    }
  }

  addCustomerReceipt() async {
    print("add...... ");
//     receiptCollection.clear();
//     customerReceipts.clear();
//     return;
    setState(() {
      // validationRcvAmt();
    });

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

  // add document

  addDocument() async {
    List<dynamic> data = [];
    data.clear();
    var params = new Map<String, dynamic>();
    if (pic != null)
      params["$voucherNo.jpg"] = MultipartFile.fromBytes(
          (await pic?.readAsBytes()) as List<int>,
          filename: "$voucherNo.jpg");
    dynamic dt = {
      "ddHandedOverFrom": handedOverFromController.text,
      "ddHandedOverTo": handedOverToController.text,
      // "ddDate": "2020-01-01T00:00:00",
      "ddRemarks": generalRemarksController.text,
      // "ddUserId": 1,
      // "ddBranchId": 1
    };

    data.add(dt);
    var req = {
      "dhVoucherNo": voucherNo,
      // "dhEntryDate": "2020-01-01T00:00:00",
      "dhDocumentName": documentNameController.text,
      "dhRemarks": generalRemarksController.text,
      "dhCollectedFrom": handedOverFromController.text,
      "dhCollectedFor": toEmployeeController.text,
      "dhClosedStatus": checkedValue,
      // "dhUsreId": 1,
      // "dhBranchId": 1,
      "tDocumentHandlingDetails": data.toList()
    };
    if (pic != null) req["dhImage"] = "$voucherNo.jpg";

    print(req);

    var map = json.encode(req);
    print(map);
    params["jsonString"] = map;
    print(params);
    FormData form = new FormData.fromMap(Map.from(params));
    print(form);
    addValidate(form);
  }

  // add validation
  addValidate(dynamic form) async {
    pro = new ProgressDialog(
      context,
      type: ProgressDialogType.normal,
      isDismissible: true,
      showLogs: true,
    );
    pro.style(
      message: "Adding Document", //
//      progress: 0.0,
//      maxProgress: 100.0,
    );
    if (pic == null || pic != null) pro.show();

    // else {

    print("...............else/.....");
    var dio = Dio();
    // print(url);
    var response = await dio.post(
      "${Env.baseUrl}TDocumentHandlingHeaders",
      data: form,
//      onSendProgress: (int sent, int total) {
//        print("$sent $total");
//      },
      options: Options(
        headers: {
          'content-type': 'multipart/form-data',
          'Authorization': user.user['token'],
          // 'deviceId':user.deviceId
        },
        followRedirects: false,
        validateStatus: (status) {
          return status! <= 500;
        },
      ),
    );
    // var response= await http.post(,
    // headers: {
    //   'Authorization': user.user['token']
    // });
    print(response.statusCode);
    if (pic == null || pic != null) pro.hide();

    if (pic == null) Navigator.pop(context);

    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text(
                "Document added success",
                style: TextStyle(color: Colors.black),
              ),
//              content: Text("$customerName"),
            ));

    print(response.data);
    if (response.statusCode == 201 ||
        response.statusCode == 204 ||
        response.statusCode == 200) {
      handedOverFromController.text = "";
      handedOverToController.text = "";
      generalRemarksController.text = "";
      documentNameController.text = "";
      toEmployeeController.text = "";
      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => DocumentMovementIndex()));
    }
    // }
  }

  // image pic from camera
  picImageFromCamera() async {
    // var amount = double.parse(amountController.text);
    // print(amount);
    // print(expenseAd.length);
    // print(amountController.text);
    // print(particularsController.text);
    // pic = "";
    setState(() {});

    if (documentNameController.text == "") {
      documentSelect = true;
    } else {
      documentSelect = false;
    }

    if (toEmployeeController.text == "") {
      toEmployeeSelect = true;
    } else {
      toEmployeeSelect = false;
    }
    // if (generalRemarksController.text == "") {
    //   remarksSelect = true;
    // } else {
    //   remarksSelect = false;
    // }

    if (handedOverFromController.text == "") {
      handOverFromSelect = true;
    } else {
      handOverFromSelect = false;
    }
    if (handedOverToController.text == "") {
      handOverToSelect = true;
    } else {
      handOverToSelect = false;
    }
    if (documentSelect ||
        toEmployeeSelect ||
        remarksSelect ||
        handOverToSelect ||
        handOverFromSelect) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text(
                  "Check Fields....",
                  style: TextStyle(color: Colors.red),
                ),
//              content: Text("$customerName"),
              ));
      return;
    } else {
      pic = (await picker.pickImage(
          source: ImageSource.camera, imageQuality: 30)) as PickedFile; // reduce it

      print("path  is....not null");

      print("Hello: " + pic!.path);

      addDocument();
    }

    // expense = ExpenseAdd(
    //     esdSlno: expenseAd.length,
    //     esAmount: double.parse(amountController.text),
    //     esImagePath: await pic.readAsBytes(),
    //     esParticulars: particularsController.text);
    // expenseTotal = expenseTotal + expense.esAmount;
    // setState(() {
    //   expenseAd.add(expense);
    // });
//    print("Hello: "+pic.toString());

    // particularsController.text = "";
    // amountController.text = "";
    // print("2nd array length");
    // print(expenseCollections.length);
    // print("1st array length");
    // print(expenseAd.length);
  }

  // pic get from gallery
  picImageFromGallery() async {
    // var amount = double.parse(amountController.text);
    // print(amount);
    // print(expenseAd.length);
    // print(amountController.text);
    // print(particularsController.text);
    // pic = "";
    setState(() {});

    if (documentNameController.text == "") {
      documentSelect = true;
    } else {
      documentSelect = false;
    }

    if (toEmployeeController.text == "") {
      toEmployeeSelect = true;
    } else {
      toEmployeeSelect = false;
    }
    // if (generalRemarksController.text == "") {
    //   remarksSelect = true;
    // } else {
    //   remarksSelect = false;
    // }

    if (handedOverFromController.text == "") {
      handOverFromSelect = true;
    } else {
      handOverFromSelect = false;
    }
    if (handedOverToController.text == "") {
      handOverToSelect = true;
    } else {
      handOverToSelect = false;
    }

    if (documentSelect ||
        toEmployeeSelect ||
        remarksSelect ||
        handOverToSelect ||
        handOverFromSelect) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text(
                  "Check Fields....",
                  style: TextStyle(color: Colors.red),
                ),
//              content: Text("$customerName"),
              ));
      return;
    } else {
      pic = (await picker.pickImage(
          source: ImageSource.gallery, imageQuality: 30)) as PickedFile; // reduce it

      print("path  is....not null");

      print("Hello: " + pic!.path.toString());
      addDocument();
    }

//     expense = ExpenseAdd(
//         esdSlno: expenseAd.length,
//         esAmount: double.parse(amountController.text),
//         esParticulars: particularsController.text,
//         esImagePath: await pic.readAsBytes());
//     expenseTotal = expenseTotal + expense.esAmount;
//     setState(() {
//       expenseAd.add(expense);
//     });
// //
//
//     print("Hello: " + pic.toString());
//
//     particularsController.text = "";
//     amountController.text = "";
//     print("2nd array length");
//     print(expenseCollections.length);
//     print("1st array length");
//     print(expenseAd.length);
  }

  addingReceiptWithOutPhoto() {
    print("null....... path");
    setState(() {
      if (documentNameController.text == "") {
        documentSelect = true;
      } else {
        documentSelect = false;
      }

      if (toEmployeeController.text == "") {
        toEmployeeSelect = true;
      } else {
        toEmployeeSelect = false;
      }
      // if (generalRemarksController.text == "") {
      //   remarksSelect = true;
      // } else {
      //   remarksSelect = false;
      // }

      if (handedOverFromController.text == "") {
        handOverFromSelect = true;
      } else {
        handOverFromSelect = false;
      }
      if (handedOverToController.text == "") {
        handOverToSelect = true;
      } else {
        handOverToSelect = false;
      }
      if (documentSelect ||
          toEmployeeSelect ||
          remarksSelect ||
          handOverToSelect ||
          handOverFromSelect) {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(
                  title: Text(
                    "Check Fields....",
                    style: TextStyle(color: Colors.red),
                  ),
//              content: Text("$customerName"),
                ));
        return;
      }
      else {
        pic = null;

        addDocument();
      }
    });

    // var amount = double.parse(amountController.text);
    // print(amount);
    // print(expenseAd.length);
    // print(amountController.text);
    // print(particularsController.text);
    //
    // expense = ExpenseAdd(
    //     esdSlno: expenseAd.length,
    //     esAmount: double.parse(amountController.text),
    //     esImagePath: null,
    //     esParticulars: particularsController.text);
    // expenseTotal = expenseTotal + expense.esAmount;
    // setState(() {
    //   expenseAd.add(expense);
    // });
//

//    print("Hello: "+pics.toString());

    // particularsController.text = "";
    // amountController.text = "";
    // print("2nd array length");
    // print(expenseCollections.length);
    // print("1st array length");
    // print(expenseAd.length);
  }

//get customer ledger balance
//   getCustomerLedgerBalance(int accountId) async {
// //    String Url = "http://testcoreapi.qizo.in:809/api/getsettings";
//     try {
//       final response = await http.get(
//           "${Env.baseUrl}getsettings",
//           headers: {"accept": "application/json"});
//       print(response.statusCode);
//
//       if (response.statusCode == 200) {
//         print('...................');
//
//         print(response.body);
//
//         List<dynamic> list = json.decode(response.body);
//         print(list[0]["workingDate"] +
//             "....................." +
//             list[0]["workingTime"]);
//         var formatter =
//         new DateFormat('MM-dd-yyyy'); // this dd-MM-yyyy format i want
// //        DateTime dateTime = formatter.parse(list[0]["workingDate"].substring(0,10));
// //        print(dateTime);
//         String formattedDate = formatter
//             .format(DateTime.parse(list[0]["workingDate"].substring(0, 10)));
//         print(formattedDate);
//
//         getLedger(accountId, formattedDate);
//       } else {
//         print("Error getting users");
//       }
//     } catch (e) {
//       print("Error getting users" + e);
//     }
//     print("customer Id is");
//     print(accountId);
//   }

//   getLedger(dynamic acId, dynamic date) async {
//     print(acId);
//     print("the given date is");
//     print(date);
//     var url = "${Env.baseUrl}TaccLedgers/$acId/$date";
//     print("url:" + url);
//     try {
//       final response = await http.get(url, headers: {
//         "Authorization": user.user["token"],
//       });
// //      print(response.statusCode);
//       if (response.statusCode == 200) {
//         print(response.body);
//         var e = json.decode(response.body);
//         print(e["openingAmount"]);
//         setState(() {
//           if (e["openingAmount"] > 0.0) {
//             openingAmountBalance = e["openingAmount"];
//           } else {
//             print("opening amount is zero");
//           }
//         });
//       }
//     } catch (e) {
//       print("error" + e);
//     }
//   }

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
                      ),
                    ],
                ),
              ),


                  GestureDetector(
                     onTap: () {
                      print("hi");
                    },
                           child:
                           Container(
                             margin: EdgeInsets.only(
                                 top: 10,
                                 bottom: 15
                             ),
                             child: Column(children:[
                               SizedBox(height: 7,),
                             Expanded(
                               child:Text(
                       "Document Create",
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
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: documentNameController,
                      enabled: true,
                      validator: (v) {
                        if (v!.isEmpty) return "Required";
                        return null;
                      },
//
//                  focusNode: field1FocusNode,
                      cursorColor: Colors.black,

                      scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                      keyboardType: TextInputType.text,

                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.red),
                        errorText: documentSelect
                            ? "Please add Document ?"
                            : null,
//                    suffixIcon: Icon(
//                      Icons.calendar_today,
//                      color: Colors.blue,
//                      size: 24,
//                    ),
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(
                            20.0, 10.0, 20.0, 16.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0)),
                        // curve brackets object
//                    hintText: "Quantity",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                        labelText: "Document Name",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              // SizedBox(
              //   height: 4,
              // ),
//           Row(children: [
//             SizedBox(width: 10),
//             Expanded(
//                 child: TypeAheadField(
//                     textFieldConfiguration: TextFieldConfiguration(
//                         style: TextStyle(),
//                         focusNode: _focusNode,
//                         onTap: () {
//                           print("focus");
//                           setState(() {
//                             if (empCustLabel == "From Employee") {
//
//                               customerController.text = "";
//
//                               empCustLabel = "From Customer";
//                               print(empCustLabel);
//                             } else {
//                               customerController.text = "";
//
//                               empCustLabel = "From Employee";
//
//                               print(empCustLabel);
//
//                             }
//                           });
//                         },
//                         controller: customerController,
//                         decoration: InputDecoration(
//                           errorStyle: TextStyle(color: Colors.red),
//                           errorText:
//                               customerSelect ? "Please Select user ?" : null,
// //                            errorText: _validateName ? "please enter name" : null,
// //                            errorBorder:InputBorder.none ,
//                           suffixIcon: IconButton(
//                             icon: Icon(Icons.remove_circle),
//                             color: Colors.blue,
//                             onPressed: () {
//                               print("cleared");
//                               customerController.text = "";
//                               salesLedgerId = 0;
//                             },
//                           ),
//
//                           isDense: true,
//                           contentPadding:
//                               EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(14.0)),
//                           // i need very low size height
//                           labelText:
//                               '${empCustLabel.toString()}', // i need to decrease height
//                         )),
//                     suggestionsBoxDecoration:
//                         SuggestionsBoxDecoration(elevation: 90.0),
//
//                     suggestionsCallback: (pattern) {
//                       // print("start with upper case");
//                       // if(pattern.toUpperCase() ==  pattern){
//                       //   print("capital 1st");
//
//                       if (empCustLabel == "From Employee") {
//                         return users.where(
//                             (user) => user['emEmployeeName'].contains(pattern));
//                       } else {
//                         return customers
//                             .where((usr) => usr['lhName'].contains(pattern.toUpperCase()));
//                       }
//
//                       // }
//                       // else{
//                       //   print("small first");
//                       //   return users.where((user) =>
//                       //       user['emEmployeeName'].contains(pattern.toUpperCase()));
//                       // }
//                     },
//                     itemBuilder: (context, suggestion) {
//                       return Card(
//                         color: Colors.white,
//                         shadowColor: Colors.blue,
//                         child: ListTile(
//                           focusColor: Colors.blue,
//                           hoverColor: Colors.red,
//                           title:Container(
//                             child:  empCustLabel == "From Employee"
//                                 ? Text(
//                               suggestion['emEmployeeName'] ?? "",
//                               style: TextStyle(color: Colors.black),
//                             )
//                                 : Text(
//                               suggestion['lhName'] ?? "",
//                               style: TextStyle(color: Colors.black),
//                             ),
//                           )
//                         ),
//                       );
//                     },
//                     onSuggestionSelected: (suggestion) {
//                       setState(() {
//                         if (empCustLabel == "From Employee") {
//                           print("selected Employee");
//
//                           print(suggestion['emEmployeeName']);
//                           print("selected Employee");
//
//                           customerController.text =
//                               suggestion['emEmployeeName'];
//                         } else {
//                           print("selected Customer");
//
//                           print(suggestion['lhName']);
//                           print("selected Customer");
//
//                           customerController.text = suggestion['lhName'];
//                         }
//                         print("close.... $salesLedgerId");
//                         salesLedgerId = 0;
//
//                         print(suggestion['id']);
//                         print(".......sales Ledger id");
//                         salesLedgerId = suggestion['id'];
//                         if (suggestion['id'] != null) {
//                           // getCustomerLedgerBalance(suggestion.id);
//                         }
//                         print(salesLedgerId);
//                         print("...........");
//                       });
//                     },
//                     errorBuilder: (BuildContext context, Object error) => Text(
//                         '$error',
//                         style: TextStyle(color: Theme.of(context).errorColor)),
//                     transitionBuilder:
//                         (context, suggestionsBox, animationController) =>
//                             FadeTransition(
//                               child: suggestionsBox,
//                               opacity: CurvedAnimation(
//                                   parent: animationController,
//                                   curve: Curves.elasticIn),
//                             ))),
//             SizedBox(
//               width: 10,
//             ),
//           ]),
              Visibility(
                visible: openingAmountBalance > 0,
                child: SizedBox(
                  height: 15,
                ),
              ),
              Visibility(
                visible: openingAmountBalance > 0,
                child: Row(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(width: 30),
                    Expanded(
                      child: Text(
                        "Current Balance:  " + openingAmountBalance.toString(),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Visibility(
                visible: openingAmountBalance > 0.0,
                child: SizedBox(
                  height: 9,
                ),
              ),
              Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: handedOverFromController,
                      enabled: true,
                      validator: (v) {
                        if (v!.isEmpty) return "Required";
                        return null;
                      },
//
//                  focusNode: field1FocusNode,
                      cursorColor: Colors.black,

                      scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                      keyboardType: TextInputType.text,

                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.red),
                        errorText: handOverFromSelect
                            ? "Invalid Handed Over From ?"
                            : null,
//                    suffixIcon: Icon(
//                      Icons.calendar_today,
//                      color: Colors.blue,
//                      size: 24,
//                    ),
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(
                            20.0, 10.0, 20.0, 16.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0)),
                        // curve brackets object
//                    hintText: "Quantity",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                        labelText: "Document From",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),

              SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: toEmployeeController,
                      enabled: true,
                      validator: (v) {
                        if (v!.isEmpty) return "Required";
                        return null;
                      },
//
//                  focusNode: field1FocusNode,
                      cursorColor: Colors.black,

                      scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                      keyboardType: TextInputType.text,

                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.red),
                        errorText:
                        toEmployeeSelect ? "Invalid To Employee ?" : null,
//                            errorText: _validateName ? "please enter name" : null,
//                            errorBorder:InputBorder.none ,
//                    suffixIcon: Icon(
//                      Icons.calendar_today,
//                      color: Colors.blue,
//                      size: 24,
//                    ),
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(
                            20.0, 10.0, 20.0, 16.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0)),
                        // curve brackets object
//                    hintText: "Quantity",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                        labelText: "Document To",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),

              SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: handedOverToController,
                      enabled: true,
                      validator: (v) {
                        if (v!.isEmpty) return "Required";
                        return null;
                      },
//
//                  focusNode: field1FocusNode,
                      cursorColor: Colors.black,

                      scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                      keyboardType: TextInputType.text,

                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.red),
                        errorText:
                        handOverToSelect ? "Invalid Handed Over To ?" : null,
//                    suffixIcon: Icon(
//                      Icons.calendar_today,
//                      color: Colors.blue,
//                      size: 24,
//                    ),
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(
                            20.0, 10.0, 20.0, 16.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0)),
                        // curve brackets object
//                    hintText: "Quantity",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                        labelText: "Handed Over To",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),

              SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: generalRemarksController,
                      enabled: true,
                      validator: (v) {
                        if (v!.isEmpty) return "Required";
                        return null;
                      },
//
//                  focusNode: field1FocusNode,
                      cursorColor: Colors.black,

                      scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                      keyboardType: TextInputType.text,

                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.red),
                        errorText: remarksSelect ? "Invalid Remarks ?" : null,
//                    suffixIcon: Icon(
//                      Icons.calendar_today,
//                      color: Colors.blue,
//                      size: 24,
//                    ),
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(
                            20.0, 10.0, 20.0, 16.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0)),
                        // curve brackets object
//                    hintText: "Quantity",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                        labelText: "Remarks",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),

              SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Expanded(
                      child: CheckboxListTile(
                        title: Center(child: Text("Closed")),

                        value: checkedValue,
                        onChanged: (newValue) {
                          setState(() {
                            checkedValue = newValue!;
                            print(checkedValue);
                          });
                        },

                        // controlAffinity:
                        // ListTileControlAffinity
                        //     .leading, //  <-- leading Checkbox
                      ),

                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        addCustomerReceipt();
                      },
                      child: Text("Save"),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.lightBlueAccent),foregroundColor:MaterialStateProperty.all(Colors.white) ,

                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    )

                  ),
                  SizedBox(width: 10,),
                ],
              ),
            ],
          ),
        ));
  }
}
