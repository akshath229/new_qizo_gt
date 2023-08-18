import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:new_qizo_gt/urlEnvironment/urlEnvironment.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';

import 'package:http/http.dart' as http;

import 'models/customersearch.dart';
import 'models/userdata.dart';

//import 'dart:convert';
class CustomerLedgerBalance extends StatefulWidget {
  @override
  _CustomerLedgerBalanceState createState() => _CustomerLedgerBalanceState();
}

@override
@override
class _CustomerLedgerBalanceState extends State<CustomerLedgerBalance> {
  bool customerSelect = false;
   int amount=0;

  late String token;
  dynamic openingAmountBalance = 0.0;

  late String branchId;
  dynamic userArray;
  dynamic serverDate;

  String date = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  bool autovalidate = false;

  dynamic user;
  int salesLedgerId = 0;

  late int customerSelectedId;
  late String customerSelectedEmail;
  late String customerSelectedName;

  TextEditingController controller = new TextEditingController();
  FocusNode field1FocusNode = FocusNode(); //Create first FocusNode
//  var _myKey = GlobalKey<FormState>();

  late String selectedLetter;
  TextEditingController customerController = new TextEditingController();
  TextEditingController goodsController = new TextEditingController();
  TextEditingController quantityController = new TextEditingController();
  TextEditingController rateController = new TextEditingController();
  TextEditingController generalRemarksController = new TextEditingController();
  TextEditingController paymentController = new TextEditingController();
  GlobalKey<AutoCompleteTextFieldState<Customer>> key =
      new GlobalKey(); //only one autocomplte
  String selectedPerson = "";
  dynamic branchName;
  dynamic userName;
  static List<Customer> users = [];
  bool loading = true;
  final letters = 'abcdefghijklmnopqrstuvwxyz'.split('');

  late SharedPreferences pref;



  // ----------test function---------
  void increment(){
    setState(() {
      amount=amount+1;
      print("in");
    });


  }

  // ----------test function---------




  void initState() {
    customerController.text = "";
//  goodsController.text = "";
    SharedPreferences.getInstance().then((value) {
      pref = value;
      read();
      getCustomer();
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

// get customer account
  getCustomer() async {
    try {
      // http://testcoreapi.qizo.in:809/api/
      final response = await http
          .get("${Env.baseUrl}MLedgerHeads/1/5" as Uri, headers: {
        "Authorization": user.user["token"],
      });
      print(response.statusCode);

      if (response.statusCode == 200) {
        print('...................');
        Map<String, dynamic> data = json.decode(response.body);
        print("array is");
        print(data["lst"]); //used  this to autocomplete
        print("........");
        print(response.statusCode);
        print(data["lst"]);
        userArray = data["lst"];
        users = (data["lst"] as List)
            .map<Customer>((customer) =>
                Customer.fromJson(Map<String, dynamic>.from(customer)))
            .toList();
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

//get customer ledger balance
  getCustomerLedgerBalance(int accountId) async {
//    String Url = "http://testcoreapi.qizo.in:809/api/getsettings";
    try {
      final response = await http.get(
          "${Env.baseUrl}getsettings" as Uri,
          headers: {"accept": "application/json"});
      print(response.statusCode);

      if (response.statusCode == 200) {
        print('...................');

        print(response.body);

        List<dynamic> list = json.decode(response.body);
        print(list[0]["workingDate"] +
            "....................." +
            list[0]["workingTime"]);
        var formatter =
            new DateFormat('MM-dd-yyyy'); // this dd-MM-yyyy format i want
//        DateTime dateTime = formatter.parse(list[0]["workingDate"].substring(0,10));
//        print(dateTime);
        String formattedDate = formatter
            .format(DateTime.parse(list[0]["workingDate"].substring(0, 10)));
        print(formattedDate);

        getLedger(accountId, formattedDate);
      } else {
        print("Error getting users");
      }
    } catch (e) {
      print("Error getting users" + e.toString());
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
    setState(() {

    });
    try {
      var response = await http.get(url as Uri, headers: {
        "Authorization": user.user["token"],
      });
      print(response.body);

     print(response.statusCode);
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
                      "Customer Balance",
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
//                            errorText: _validateName ? "please enter name" : null,
//                            errorBorder:InputBorder.none ,
                          suffixIcon: IconButton(
                            icon: Icon(Icons.remove_circle),
                            color: Colors.blue,
                            onPressed: () {
                              print("cleared");
                              customerController.text = "";
                              salesLedgerId = 0;
                            },
                          ),

                          isDense: true,
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.0)),
                          // i need very low size height
                          labelText:
                              'customer search', // i need to decrease height
                        )),
                    suggestionsBoxDecoration:
                        SuggestionsBoxDecoration(elevation: 90.0),
                    suggestionsCallback: (pattern) {
                      return users.where((user) =>
                          user.lhName.toUpperCase().contains(pattern.toUpperCase()));
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
                    errorBuilder: (BuildContext context, Object? error) => Text(
                        '$error',
                        style: TextStyle(color: Theme.of(context).errorColor)),
                    transitionBuilder:
                        (context, suggestionsBox, animationController) =>
                            FadeTransition(
                              child: suggestionsBox,
                              opacity: CurvedAnimation(
                                  parent: animationController!,
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
            visible: openingAmountBalance > 0.0,
            child: SizedBox(
              height: 9,
            ),
          ),



// -------------testig-------------
Container(
  color: Colors.red,
  width: 10.0,
  height: 40.0,
  child:TextButton( style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Colors.green),
  ),


    onPressed: increment,
    child: Text("Click"),
  )
),


  Center(
    child: Text(
      '$amount'
    ),
  )

// -------------testing end---------------




//          Row(
//            children: [
//              SizedBox(width: 10,),
//            Expanded(
//
//              child:RaisedButton(
//                textColor: Colors.white,
//                color: Colors.lightBlueAccent,
//                child: Text("Save"),
//                onPressed: (){},
//                shape: new RoundedRectangleBorder(
//                  borderRadius: new BorderRadius.circular(14.0),
//                ),
//              ),
//
//            ),
//
//              SizedBox(width: 10,),
//
//            ],
//          )
        ],
      ),
    ));
  }
}
