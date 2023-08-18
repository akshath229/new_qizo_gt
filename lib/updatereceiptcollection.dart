import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_qizo_gt/urlEnvironment/urlEnvironment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'PaymentVoucher_Direct.dart';
import 'models/customersearch.dart';
import 'models/receiptAdditem.dart';
import 'models/userdata.dart';
import 'package:http/http.dart' as http;


class UpdateReceiptCollection extends StatefulWidget {
  dynamic data;

  UpdateReceiptCollection(this.data);

  @override
  _UpdateReceiptCollectionState createState() =>
      _UpdateReceiptCollectionState();
}

class _UpdateReceiptCollectionState extends State<UpdateReceiptCollection> {
  List<String> gender = ["Cash", "Bank"];

  String select = "Cash";
  late File _image;
  dynamic pickedFile;
  final picker = ImagePicker();
  late bool loadingResReceiptAdd;
  late int count;

  // images pick form gallery
  void getImageFromGallery() async {
    pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  // Capture Images From Camera
  void getImageFromCamera() async {
    pickedFile = await picker.pickImage(source: ImageSource.camera);
    print(".......................");
    print(pickedFile);
    setState(() {
      _image = File(pickedFile.path);
      print(_image);
    });
  }

  late UserData userData;
  late String branchName;
  dynamic userName;
  late String token;
  dynamic openingAmountBalance = 0.0;
  bool customerSelect = false;
  bool remarkSelect = false;
  bool receivedAmountSelect = false;
  double receiptTotal = 0.0;
  late String branchId;
  dynamic userArray;
  dynamic serverDate;
  int salesLedgerId = 0;

  late int customerSelectedId;
  late String customerSelectedEmail;
  late String customerSelectedName;
  String noImage = "-No Image-";
  TextEditingController controller = new TextEditingController();
  FocusNode field1FocusNode = FocusNode(); //Create first FocusNode

  late String customerName;
  late String selectedLetter;
  TextEditingController customerController = new TextEditingController();
  TextEditingController amountController = new TextEditingController();
  TextEditingController receiptController = new TextEditingController();
  TextEditingController remarksController = new TextEditingController();
  List<ReceiptAdd> customerReceipts = <ReceiptAdd>[];
  List<ReceiptAdd> finalCustomerReceipts = <ReceiptAdd>[];

  late double longitude;
  late double latitude;

  late ReceiptAdd customerReceipt;
  GlobalKey<AutoCompleteTextFieldState<Customer>> key =
  new GlobalKey(); //only one autocomplte
  String selectedPerson = "";
  List<ReceiptCollection> receiptCollection = <ReceiptCollection>[];
  late ReceiptCollection receipt;

  List<Customer> users = <Customer>[];
  bool loading = true;
  final letters = 'abcdefghijklmnopqrstuvwxyz'.split('');

  late SharedPreferences pref;

  void initState() {
    print("Data is ${this.widget.data}");
   // print("${widget.data['mobSmrctCollectionDetails']}");
   dynamic dts = [];
    dts =this.widget.data;
    //['mobSmrctCollectionDetails'];
    setState(() {
     // print("data...${dts}");
    });
    customerReceipts.clear();
    // dts.asMap().forEach((i, ele) {
    //   dynamic image = "";

      // if (ele['rdImgPath'] == "-" || ele['rdImgPath'] == "0") {
      //   image = null;
      // } else {
      //   image = ele['rdImgPath'] as String;
      // }
      // print("image is :${image}");

      // customerReceipt = ReceiptAdd(
      //     slNo: customerReceipts.length + 1,
      //     receivedAmount: ele['rdAmount'],
      //     remarks: ele['rdRemarks'],
      //     rdtransactionType: ele['rdtransactionType'],
      //     image: image);
      // print(customerReceipt.image);
      // print(customerReceipt.remarks);
      //
      // print(ele['rdtransactionType']);
      //
      // receiptTotal = receiptTotal + customerReceipt.receivedAmount;
      //
      // customerReceipts.add(customerReceipt);
    //});


    // print(p);
    // customerReceipts = p;

    // List<dynamic> t = json.decode(res.body);
    // List<ReceiptAdd> p = dts.map((dts) => ReceiptAdd.fromJson(dts)).toList();

    print('${Env.baseUrl}');
    customerController.text = "";
    remarksController.text = "";
    SharedPreferences.getInstance().then((value) {
      customerController.text = this.widget.data['Shop Name'].toString();
      salesLedgerId = this.widget.data['Id'].toInt();

      if(this.widget.data['Type'].toString()=="Cheque"){
        select ="Bank";
      }


      pref = value;
      read();
      receiptCollection.clear();
      _getLocation();
      getCustomer();
    });

    customerController.addListener(customerLedgerIdListener);

    super.initState();
  }

  validationRcvAmt() {
    if (amountController.text == "") {
      receivedAmountSelect = true;
      // validationRemarks();
    } else {
      receivedAmountSelect = false;
      // validationRemarks();
    }
  }

  // validationRemarks() {
  //   if (remarksController.text == "") {
  //     remarkSelect = true;
  //   } else {
  //     remarkSelect = false;
  //   }
  // }

  // Save Receipt Now
  receiptNow() {
    setState(() {
      if (salesLedgerId == 0) {
        customerSelect = true;
      } else {
        customerSelect = false;
        correctValidateNow();
      }
    });
  }

  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Theme.of(context).primaryColor,
          value: gender[btnValue],
          groupValue: select,
          onChanged: (value) {
            setState(() {
              print("Payment Type : ${value.toString()}");
              select = value!;
            });
          },
        ),
        Text(title)
      ],
    );
  }

  getIndexRows(dynamic item) {
    int i = customerReceipts.indexOf(item);
    return i + 1;
  }

  addCustomerReceipt() async {
    print("add...... ");
//     receiptCollection.clear();
//     customerReceipts.clear();
//     return;
    setState(() {
      if (salesLedgerId == 0 || customerController.text == "") {
        customerSelect = true;
        validationRcvAmt();
      } else {
        customerSelect = false;
        validationRcvAmt();
      }
    });

    if (amountController.text == "" || salesLedgerId <= 0) {
      print("check fields");
      print(salesLedgerId);
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("check fields"),
              ));
      return;
    }
    if (amountController.text == "" || salesLedgerId <= 0) {
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
  Future<void> picImageFromCamera() async {
    var amount = double.parse(amountController.text);
    print(amount);
    print(customerReceipts.length);
    print(amountController.text);
    print(remarksController.text);

    var pic = await picker.pickImage(source: ImageSource.camera, imageQuality: 30); // reduce it

    print("path  is....not null");

    print("Hello: " + pic!.path);
    setState(() {});
    int transtype;
    if (select == "Cash") {
      transtype = 0;
    } else {
      transtype = 1;
    }
    print("transaction type :${transtype.toString()}");

    customerReceipt = ReceiptAdd(
        slNo: customerReceipts.length + 1,
        receivedAmount: double.parse(amountController.text),
        remarks: remarksController.text,
        rdtransactionType: transtype,
        image: await pic.readAsBytes());
    receiptTotal = receiptTotal + customerReceipt.receivedAmount;
    setState(() {
      customerReceipts.add(customerReceipt);
    });
//
//    print("Hello: "+pics.toString());

    remarksController.text = "";
    amountController.text = "";
    print("2nd array length");
    print(receiptCollection.length);
    print("1st array length");
    print(customerReceipts.length);

    print(customerReceipts.length);
    print(salesLedgerId);
//
  }

// adding receipt with photo
  addingReceiptWithOutPhoto() {
    print("null....... path");

    var amount = double.parse(amountController.text);
    print(amount);
    print(customerReceipts.length);
    print(amountController.text);
    print(remarksController.text);
    setState(() {});
    int transtype;
    if (select == "Cash") {
      transtype = 0;
    } else {
      transtype = 1;
    }
    print("transaction type :${transtype.toString()}");

    customerReceipt = ReceiptAdd(
        slNo: customerReceipts.length + 1,
        receivedAmount: amount,
        remarks: remarksController.text,
        rdtransactionType: transtype,
        image: null);
    receiptTotal = receiptTotal + customerReceipt.receivedAmount;
    customerReceipts.add(customerReceipt);
//      print("Hello: "+pics.toString());

    remarksController.text = "";
    amountController.text = "";
    print("2nd array length");
    print(receiptCollection.length);
    print("1st array length");
    print(customerReceipts.length);

    print(customerReceipts.length);
    print(salesLedgerId);
  }

  // pic get from gallery
  Future<void> picImageFromGallery() async {
    var amount = double.parse(amountController.text);
    print(amount);
    print(customerReceipts.length);
    print(amountController.text);
    print(remarksController.text);

    var pic = await picker.pickImage(source: ImageSource.gallery, imageQuality: 30); // reduce it

    print("path  is....not null");

    print("Hello: ${pic?.path}");
    setState(() {});
    int transtype;
    if (select == "Cash") {
      transtype = 0;
    } else {
      transtype = 1;
    }

    print("transaction type :${transtype.toString()} ");
    customerReceipt = ReceiptAdd(
        slNo: customerReceipts.length + 1,
        receivedAmount: double.parse(amountController.text),
        remarks: remarksController.text,
        rdtransactionType: transtype,
        image: await pic?.readAsBytes());
    receiptTotal = receiptTotal + customerReceipt.receivedAmount;
    setState(() {
      customerReceipts.add(customerReceipt);
    });
//

    remarksController.text = "";
    amountController.text = "";
    print("2nd array length");
    print(receiptCollection.length);
    print("1st array length");
    print(customerReceipts.length);

    print(customerReceipts.length);
    print(salesLedgerId);
//
  }


  // remove customer items
  removeListElement(ReceiptAdd item) {
    setState(() {
//      int i = customerReceipts.indexOf(item);
      customerReceipts.remove(item);

      receiptTotal = receiptTotal - item.receivedAmount;
      print("st array length");
      print(customerReceipts.length);
      print("2nd array length");
      print(receiptCollection.length);

//      customerReceipts.removeWhere((element) => element.slNo == item.slNo);
//      receiptTotal = receiptTotal - item.receivedAmount;
//      receiptCollection.removeWhere((element) => element == item);
    });
  }

  //  passing api to files and index
  correctValidateNow() {
    receiptCollection.clear();
    print(salesLedgerId);
    setState(() {
      if (customerReceipts.length <= 0) {
        receiptCollection.clear();
//      validationRcvAmt();
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(
                    "Please Add Receipt",
                    style: TextStyle(color: Colors.red),
                  ),
//            content: Text("$customerName"),
                ));
        return;
      }
      print(receiptCollection);
      loadingResReceiptAdd = true;
    });

    if (customerReceipts.length <= 0) {
      return;
    }

    var params = new Map<String, dynamic>();

    customerReceipts.asMap().forEach((i, rece) {
      print("...");
      print(rece.image);
      print("...");

      if (rece.image != null) {
        receipt = ReceiptCollection(
            rdAmount: rece.receivedAmount,
            rdRemarks: rece.remarks,
            rdImgPath: i,
            rdtransactionType: rece.rdtransactionType);
        print("$i");
        params["$i.jpg"] = rece.image.runtimeType==String ? rece.image : MultipartFile.fromBytes(rece.image ?? [], filename: "$i.jpg"); //

        receiptCollection.add(receipt);
      } else {
        receipt = ReceiptCollection(
            rdAmount: rece.receivedAmount,
            rdRemarks: rece.remarks,
            rdImgPath: "-",
            rdtransactionType: rece.rdtransactionType);
        receiptCollection.add(receipt);
      }
    });

    print("length of last List");
    print(receiptCollection.length);

//    return;
    var req = {
      "id": this.widget.data['id'],
      "rhCustId": salesLedgerId,
      "rhLatitude": latitude.toString(),
      "rhLongitude": longitude.toString(),
      "mobSmrctCollectionDetails":
          receiptCollection.map((receipt) => receipt.toJson()).toList()
    };

    var map = json.encode(req);
    print(map);
    params["jsonString"] = map;
    print(params);
    FormData form = new FormData.fromMap(Map.from(params));
    print(form);
    view(form);
  }

  void view(dynamic form) async {
    EasyLoading.show(status: 'Adding Receipt');
    var dio = Dio();

    var res = await dio.put(
      "${Env.baseUrl}MobSmrctCollectionHeaders/${this.widget.data['id']}",
      data: form,
      options: Options(
        headers: {
          'content-type': 'multipart/form-data',
          'Authorization': user.user['token'],
          'deviceId': user.deviceId
        },
        followRedirects: false,
        validateStatus: (status) {
          return status! <= 500;
        },
      ),
    );

    print(res.statusCode);
    if (res.statusCode == 200 || res.statusCode == 201 && receiptCollection.length > 0) {
      print(res.data);
      loadingResReceiptAdd = false;
      setState(() {
        EasyLoading.dismiss();
        receiptCollection.clear();
        customerReceipts.clear();
        remarksController.text = "";
        amountController.text = "";
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Receipt Updated Success"),
              content: Text("$customerName"),
            ));
        Timer(Duration(seconds: 2), () {
          print("Yeah, this line is printed after 2 seconds");

          Navigator.pop(context);
        });
        customerController.text = "";
        salesLedgerId = 0;

        receiptTotal = 0;
      });
    }
  }


  // listener for customer select
  customerLedgerIdListener() {
    setState(() {
      salesLedgerId = 0;

      openingAmountBalance = 0;
      print(customerController.text);
      print("item");
    });
  }

//  get location longitute and latitude
  _getLocation() async {
    print("location");
    Geolocator geolocator = Geolocator();
    print(geolocator);
    Position position = await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    debugPrint('location: ${position.latitude}');
    print("latitude :");
    print(position.latitude);
//    showDialog(
//        context: context,
//        builder: (context) => AlertDialog(
//              title: Text("longitude:   " + position.longitude.toString()),
//              content: Text("latitude:   " + position.latitude.toString()),
//            ));

    print("longitude:");
    print(position.longitude);
    longitude = position.longitude;
    latitude = position.latitude;
//    showAboutDialog();

//    final coordinates = new Coordinates(position.latitude, position.longitude);
//    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
//    var first = addresses.first;
//    print(first);
//    print("${first.featureName} : ${first.addressLine}");
  }

//get token
  read() async {
    var v = pref.getString("userData");
    print("USER DATA: $v");
    var c = json.decode(v!);
    //
    users = UserData.fromJson(c) as List<Customer>; // token gets this code user.user["token"]

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

// get customer account
  getCustomer() async {
    try {
      final response =
          await http.get("${Env.baseUrl}MLedgerHeads/1/5" as Uri, headers: {
        "Authorization": user.user["token"],
      });
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        print('...................');
        Map<String, dynamic> data = json.decode(response.body);
        print("array is");
        print(data["list"]); //used  this to autocomplete
        print("........");
        print(response.statusCode);
        print(data["lst"]);
        userArray = data["lst"];
        users = (data["lst"] as List)
            .map<Customer>((customer) =>
                Customer.fromJson(Map<String, dynamic>.from(customer)))
            .toList();
//        users=loadUsers(s.toString());

      } else {
        print("Error getting users");
      }
    } catch (e) {
      print("Error getting users");
    }
  }

//get customer ledger balance
  getCustomerLedgerBalance(int accountId) async {
    try {
      final response = await http.get("${Env.baseUrl}getsettings" as Uri,
          headers: {"accept": "application/json"});
      print(response.statusCode);

      if (response.statusCode == 200) {
        print('...................');

        print(response.body);

        List<dynamic> list = json.decode(response.body);
        print(list[0]["workingDate"] +
            "....................." +
            list[0]["workingTime"]);
        var formatter = new DateFormat('MM-dd-yyyy'); // this dd-MM-yyyy format
        String formattedDate = formatter
            .format(DateTime.parse(list[0]["workingDate"].substring(0, 10)));
        print(formattedDate);

        getLedger(accountId, formattedDate);
      } else {
        print("Error getting users");
      }
    } catch (e) {
      print("Error getting users$e");
    }
    print("customer Id is");
    print(accountId);
  }

  getLedger(dynamic acId, dynamic date) async {
    print(acId);
    print("the given date is");
    print(date);
    var url = "${Env.baseUrl}TaccLedgers/$acId/$date";
    print("url:" + url);
    try {
      final response = await http.get(url as Uri, headers: {
        "Authorization": user.user["token"],
      });

      if (response.statusCode == 200) {
        print(response.body);
        var e = json.decode(response.body);
        print(e["openingAmount"]);
        setState(() {
          if (e["openingAmount"] > 0.0) {
            openingAmountBalance = e["openingAmount"];
          } else {
            print("opening amount is zero");
          }
        });
      }
    } catch (e) {
      print("error" + e.toString());
    }
  }

  Widget build(BuildContext context) {

    print(customerReceipts.length);

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
                      "Update Receipt",
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
                            Navigator.pop(context); // this is proper..it will only pop the dialog which is again a screen
                          });
                        },
                      );


                      Widget yesButton = TextButton(
                        child: Text("Yes"),
                        onPressed: () {
                          setState(() {
                            print("yes...");
                            pref.remove('userData');
                            Navigator.pop(context);
                            Navigator.pushReplacementNamed(context, "/logout");
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

          Row(children: [
            SizedBox(width: 10),
            Expanded(
                child: TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                        style: TextStyle(),
                        controller: customerController,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(color: Colors.red),
                          errorText: customerSelect
                              ? "Please Select Customer ?"
                              : null,
                          suffixIcon: IconButton(
                            icon: Icon(Icons.remove_circle),
                            color: Colors.blue,
                            onPressed: () {
                              setState(() {
                                print("cleared");
                                customerController.text = "";
                                salesLedgerId = 0;
                                openingAmountBalance = 0;
                              });
                            },
                          ),

                          isDense: true,
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.0)),
                          labelText:
                              'customer search', // i need to decrease height
                        )),
                    suggestionsBoxDecoration:
                        SuggestionsBoxDecoration(elevation: 90.0),
                    suggestionsCallback: (pattern) {
                      return users.where((user) =>
                          user.lhName.contains(pattern.toUpperCase()));
                    },
                    itemBuilder: (context, suggestion) {
                      return Card(
                        color: Colors.white,
                        // shadowColor: Colors.blue,
                        child: ListTile(
                          // focusColor: Colors.blue,
                          // hoverColor: Colors.red,
                          title: Text(
                            suggestion.lhName,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      print(suggestion.lhName);
                      print("selected");

                      customerController.text = suggestion.lhName;
                      customerName = suggestion.lhName;
                      print("close.... $salesLedgerId");
                      salesLedgerId = 0;

                      print(suggestion.id);
                      print(".......sales Ledger id");
                      salesLedgerId = suggestion.id;
                      if (suggestion.id != null) {
                        getCustomerLedgerBalance(suggestion.id);
                      }
                      print(salesLedgerId);
                      print("...........");
                    },
                    errorBuilder: (BuildContext context, Object? error) {
                      if (error != null) {
                        return Text(
                          '$error',
                          style: TextStyle(color: Theme.of(context).errorColor),
                        );
                      } else {
                        return Container();  // Return an empty Container when error is null.
                      }
                    },

                    transitionBuilder:
                        (context, suggestionsBox, animationController) =>
                            FadeTransition(
                              child: suggestionsBox,
                              opacity: CurvedAnimation(
                                  parent: animationController?.view ?? const AlwaysStoppedAnimation(0.0),
                                  curve: Curves.elasticIn),
                            ))),
            SizedBox(
              width: 10,
            ),
          ]),
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
            height: 6,
          ),
          Visibility(
            visible: openingAmountBalance > 0,
            child: SizedBox(
              height: 9,
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextFormField(
                  controller: remarksController,
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
                    // errorStyle: TextStyle(color: Colors.red),
                    // errorText: remarkSelect ? "Please Enter Remarks" : null,
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 16.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0)),
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
          // SizedBox(
          //   height: 6,
          // ),
          // Row(
          //   children: [
          //     Text("Payment Type")
          //   ],
          // ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 12,
              ),
              Text(
                "Payment Type",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                width: 15,
              ),
              addRadioButton(0, 'Cash'),
              SizedBox(
                width: 10,
              ),
              addRadioButton(1, 'Bank'),
              // addRadioButton(2, 'Others'),
            ],
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
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.digitsOnly,
                  //   FilteringTextInputFormatter.allow(RegExp("/./")).
                  // ],
                  // i need page laod to view datatable
                  decoration: InputDecoration(
                    errorStyle: TextStyle(color: Colors.red),
                    errorText: receivedAmountSelect ? "Invalid amount" : null,
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

                    labelText: "Received Amount",
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
            height: 6,
          ),
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 0.0, right: 0.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.lightBlueAccent),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                    ),
                  ),
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: receiptNow, // Make sure receiptNow function is defined in your code
                )
                ,
              ),
              Padding(
                padding: EdgeInsets.only(left: 163.0, right: 0.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.lightBlueAccent),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                    ),
                  ),
                  child: Text(
                    "Reset",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    setState(() {
                      customerController.text = "";
                      remarksController.text = "";
                      amountController.text = "";
                      customerSelect = false;
                      receivedAmountSelect = false;
                      remarkSelect = false;
                      salesLedgerId = 0;
                      customerReceipts.clear();
                      receiptTotal = 0;
                    });
                  },
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
          Visibility(
            visible: customerReceipts.length > 0,
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
                          label: Text('Remarks'),
                        ),
                        DataColumn(
                          label: Text('Transaction Type'),
                        ),
                        DataColumn(
                          label: Text('Received Amount'),
                        ),
                        DataColumn(
                          label: Text('images'),
                        ),
                        DataColumn(
                          label: Text(' '),
                        ),
                      ],
                      rows: customerReceipts
                          .map(
                            (itemRow) => DataRow(
                              cells: [
                                DataCell(
                                  Text(getIndexRows(itemRow).toString()),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(itemRow.remarks),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 50,
                                    // height: 150,
                                    child: itemRow.rdtransactionType == 0
                                        ? Text("Cash")
                                        : Text("Bank"),
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(itemRow.receivedAmount.toString()),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 50,
                                    height: 150,

                                      child: itemRow.image != null
                                           ? itemRow.image.runtimeType==String?
                                      Image.network(itemRow.image, fit: BoxFit.cover)
                                          :
                                      Image.memory(itemRow.image, fit: BoxFit.cover)
                                        : Text( // where is this?
                                            "noImage".toString(),
                                            style: TextStyle(height: 10),
                                          ),
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                    TextButton(
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(0, 0, 0, 0)),
                                      ),
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
            visible: receiptTotal > 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 90,
                ),
                Expanded(
                  child: TextField(
                    readOnly: true,
                    controller: receiptController,
                    style: TextStyle(
                        color: Colors.lightBlue,
//                      fontFamily: Font.AvenirLTProMedium.value,
                        fontSize: 17),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Total Amount : $receiptTotal',
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
