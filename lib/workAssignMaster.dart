import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:new_qizo_gt/urlEnvironment/urlEnvironment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/usersession.dart';
import 'models/userdata.dart';

class workAssignMaster extends StatefulWidget {
  @override
  _workAssignMasterState createState() => _workAssignMasterState();
}

class _workAssignMasterState extends State<workAssignMaster> {
  static List<EmpName> users = List<EmpName>.empty(growable: true);
  static List<project> prj = List<project>.empty(growable: true);
  static List<moduledata> module = List<moduledata>.empty(growable: true);



  late String branchName;
  dynamic userName;
  late UserSession usr;
  late SharedPreferences pref;
  dynamic user;
  late String token;

  bool employeeSelect = false;
  bool projectSelect = false;
  int employeeId = 0;
  String empname = "";
  int projectId = 0;
  String projname = "";
  bool moduleSelect = false;
  int moduleId = 0;
  String modulename = "";
  bool projMngSelect = false;
  int projMngId = 0;
  String projMngname = "";
  FocusNode assigndtFocusNode = FocusNode();
  FocusNode expdtFocusNode = FocusNode();
  FocusNode cmptdtFocusNode = FocusNode();
  dynamic assigndate;
  bool assigndateSelect = false;
  dynamic expectedDate;
  bool expectedDateSelect = false;
  dynamic cmpltDate;
  bool cmpltDateSelect = false;

  TextEditingController employeeController = new TextEditingController();
  TextEditingController projectController = new TextEditingController();
  TextEditingController moduleController = new TextEditingController();
  TextEditingController projMngController = new TextEditingController();
  TextEditingController remarkController = new TextEditingController();
  TextEditingController assigndateController = new TextEditingController();
  TextEditingController expecteddateController = new TextEditingController();
  TextEditingController cmpltdateController = new TextEditingController();

  void initState() {
    SharedPreferences.getInstance().then((value) {
      pref = value;
      read();
      GetEmp();
      Getproject();
      Getmodule();
      // super.initState();
    });
  }

  read() async {
    var v = pref.getString("userData");
    print("USER DATA: $v");
    var c = json.decode(v!);

    user = UserData.fromJson(c); // token gets this code user.user["token"]

    setState(() {
      print("user data................");
      // print(user.user["token"]);
      token = user.user["token"]; //  passes this user.user["token"]
      pref.setString("customerToken", user.user["token"]);
      branchName = user.branchName;
      userName = user.user["userName"];
      print(branchName);
      print(userName);
      print("....................");
    });
  }

//--------------------------------------Validation------------------------------------------
  validationemployee() {
    if (employeeController.text == "" || employeeId <= 0) {
      employeeSelect = true;

      validationproject();
    } else {
      employeeSelect = false;
      validationproject();
    }
  }

  validationproject() {
    if (projectController.text == "" || projectId <= 0) {
      projectSelect = true;
      validationmodule();
    } else {
      projectSelect = false;
      validationmodule();
    }
  }

  validationmodule() {
    if (moduleController.text == "" || moduleId <= 0) {
      moduleSelect = true;
      validationassigndate();
    } else {
      moduleSelect = false;
      validationassigndate();
    }
  }

  // validationprojMng() {
  //   if (projMngController.text == "") {
  //     projMngSelect = true;
  //     validationassigndate();
  //   } else {
  //     projMngSelect = false;
  //     validationassigndate();
  //   }
  // }

  validationassigndate() {
    if (assigndateController.text == "") {
      assigndateSelect = true;
      validationexpecteddate();
    } else {
      assigndateSelect = false;
      validationexpecteddate();
    }
  }

  validationexpecteddate() {
    if (expecteddateController.text == "") {
      expectedDateSelect = true;
    } else {
      expectedDateSelect = false;
    }
  }

//--------------------------------------Validation---End---------------------------------------

  Resetfunction() {
    employeeController.text = "";
    projectController.text = "";
    moduleController.text = "";
    projMngController.text = "";
    remarkController.text = "";
    assigndateController.text = "";
    expecteddateController.text = "";
    cmpltdateController.text = "";
    employeeId = 0;
    projectId = 0;
    moduleId = 0;
    employeeSelect = false;
    projectSelect = false;
    moduleSelect = false;
    projMngSelect = false;
    assigndateSelect = false;
    expectedDateSelect = false;
    cmpltDateSelect = false;

    FocusScope.of(context).unfocus();
    cmpltdateController.clear();
  }

  itemSave() {
    setState(() {
      validationemployee();
    });
    print("yyy $projectId");
    if (projectController.text == "" ||
        employeeController.text == "" ||
        moduleController.text == "" ||
        assigndateController.text == "" ||
        expecteddateController.text == "" ||
        employeeId <= 0 ||
        projectId <= 0 ||
        moduleId <= 0) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                title: Center(child: Text("check fields...")),
              ));
      return;
    }
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              title: Center(
                child: Text(
                  "Iteam Saved",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
//              content: Text("user data:   " + user.user["token"]),
            ));
    Resetfunction();
  }

  GetEmp() async {
    try {
      final res = await http.get("${Env.baseUrl}MemployeeMasters" as Uri, headers: {
        "Authorization": user.user["token"],
      });

      print(res.body);
      List<dynamic> tagsJson = json.decode(res.body)['employeeMaster'];

      List<EmpName> ut =
          tagsJson.map((tagsJson) => EmpName.fromJson(tagsJson)).toList();
      // print("uuuu : $ut");
      users = ut;
    } catch (e) {
      print("error on  employee= $e");
    }
  }

  Getproject() async {
    String url = "${Env.baseUrl}ProjectMasters";
    try {
      final res =
      await http.get(url as Uri, headers: {"Authorization": user.user["token"]});
      print("project");
      print(res.body);
      List<dynamic> tagsJson = json.decode(res.body)['list'];
      List<project> ut =
      tagsJson.map((tagsJson) => project.fromJson(tagsJson)).toList();
      print("uuuu : $ut");
      prj = ut;
    } catch (e) {
      print("error on  unit= $e");
    }
  }
  //------------------------------------test------------------------------------------------------------------------------------------------

  Getmodule() async {
    String url = "${Env.baseUrl}RelProjectModules";
    try {
      final res =
          await http.get(url as Uri, headers: {"Authorization": user.user["token"]});
      print("project");
      print(res.body);
      List<dynamic> tagsJson = json.decode(res.body);
      List<moduledata> ut =
          tagsJson.map((tagsJson) => moduledata.fromJson(tagsJson)).toList();
      print("uuuu : $ut");
      module = ut;
    } catch (e) {
      print("error on  unit= $e");
    }
  }

//-------------------------------------------test-----------------------------------------------------------------------------------------
  //------------------------------------------------------------All Function End ---------------------------------

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(190.0),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
                gradient: new LinearGradient(
                    colors: [Color(0xFFE7E9EE), Color(0xFF328BF6)],
                    begin: FractionalOffset.centerLeft,
                    end: FractionalOffset.centerRight,
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp)),
            width: double.maxFinite,
            child: Padding(
              padding: const EdgeInsets.only(
                  //  bottom: 1,
                  right: 10,
                  left: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          print("hi");
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          // fit: StackFit.expand,
                          children: [
                            Center(
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40.0),
                                    image: DecorationImage(
                                        image: AssetImage("assets/icon1.jpg"),
                                        fit: BoxFit.fill)),
                                margin: new EdgeInsets.only(
                                    left: 0.0,
                                    top: 5.0,
                                    right: 0.0,
                                    bottom: 0.0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Center(
                                    child: Text(
                                      "",
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.red),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )),
                    GestureDetector(
                      onTap: () {
                        print("hi");
                      },
                      child: Container(
                          margin: EdgeInsets.only(top: 10, bottom: 15),
                          child: Column(children: [
                            SizedBox(
                              height: 7,
                            ),
                            Expanded(
                              child: Text(
                                "Work Assign Master",
                                style: TextStyle(
                                    fontSize: 22, color: Colors.white),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 7),
                                child: Text(
                                  "${branchName.toString()}",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.white),
                                ),
                              ),
                            ),
                          ])),
                    ),
                    GestureDetector(
                      onTap: () {
                        Widget noButton = TextButton(
                          child: Text("No"),
                          onPressed: () {
                            setState(() {
                              print("No...");
                              Navigator.pop(context);
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
          children: <Widget>[
            SizedBox(height: 10),

            Row(
              children: [
                SizedBox(width: 10),
                Expanded(
                    child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                            style: TextStyle(),
                            controller: employeeController,
                            decoration: InputDecoration(
                              errorStyle: TextStyle(color: Colors.red),
                              errorText: employeeSelect
                                  ? "Please Select Employee ?"
                                  : null,
                              suffixIcon: IconButton(
                                icon: Icon(Icons.remove_circle),
                                color: Colors.blue,
                                onPressed: () {
                                  setState(() {
                                    print("cleared");
                                    employeeController.text = "";
                                    employeeId = 0;
                                  });
                                },
                              ),
                              isDense: true,
                              contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14.0)),
                              labelText: 'Search Employee',
                            )),
                        suggestionsBoxDecoration:
                        SuggestionsBoxDecoration(elevation: 90.0),
                        suggestionsCallback: (pattern) {
                          return users.where((user) => user.emEmployeeName
                              .toUpperCase()
                              .contains(pattern.toUpperCase()));
                        },
                        itemBuilder: (context, suggestion) {
                          return Card(
                            color: Colors.blue,
                            child: ListTile(
                              title: Text(
                                suggestion.emEmployeeName,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          print(suggestion.emEmployeeName);
                          print("selected");

                          employeeController.text = suggestion.emEmployeeName;
                          print("close.... $employeeId");
                          empname = suggestion.emEmployeeName;
                          print(suggestion.id);
                          print(".......EmployeeName id");
                          employeeId = suggestion.id;
                          print("...........");
                        },
                        errorBuilder: (BuildContext context, Object? error) =>
                        error == null ? SizedBox() : Text(
                          '$error',
                          style: TextStyle(
                              color: Theme.of(context).errorColor
                          ),
                        ),
                        transitionBuilder:
                            (context, suggestionsBox, animationController) =>
                            FadeTransition(
                              child: suggestionsBox,
                              opacity: CurvedAnimation(
                                  parent: animationController?.view ?? const AlwaysStoppedAnimation(0.0),
                                  curve: Curves.elasticIn),
                            )
                    )
                ),
                SizedBox(
                  width: 10,
                )
              ],
            ),


            SizedBox(height: 10),

            Row(
              children: [
                SizedBox(width: 10),
                Expanded(
                    child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                          style: TextStyle(),
                          controller: projectController,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(color: Colors.red),
                            errorText: projectSelect ? "Please Select Project ?" : null,
                            suffixIcon: IconButton(
                              icon: Icon(Icons.remove_circle),
                              color: Colors.blue,
                              onPressed: () {
                                setState(() {
                                  print("cleared");
                                  projectController.text = "";
                                  projectId = 0;
                                });
                              },
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14.0)),
                            labelText: 'Search Project',
                          ),
                        ),
                        suggestionsBoxDecoration: SuggestionsBoxDecoration(elevation: 90.0),
                        suggestionsCallback: (pattern) {
                          return prj.where((prj) => prj.mpProjectName.toUpperCase().contains(pattern.toUpperCase()));
                        },
                        itemBuilder: (context, suggestion) {
                          return Card(
                            color: Colors.blue,
                            child: ListTile(
                              title: Text(
                                suggestion.mpProjectName,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          print(suggestion.mpProjectName);
                          print("selected");
                          projectController.text = suggestion.mpProjectName;
                          print("close.... $projectId");
                          projname = suggestion.mpProjectName;
                          print(suggestion.id);
                          print(".......project id");
                          projectId = suggestion.id;
                          print("...........");
                        },
                        errorBuilder: (BuildContext context, Object? error) =>
                        error == null ? SizedBox() : Text(
                          '$error',
                          style: TextStyle(
                              color: Theme.of(context).errorColor
                          ),
                        ),
                        transitionBuilder: (context, suggestionsBox, animationController) =>
                            FadeTransition(
                              child: suggestionsBox,
                              opacity: CurvedAnimation(
                                  parent:animationController?.view ?? const AlwaysStoppedAnimation(0.0),
                                  curve: Curves.elasticIn
                              ),
                            )
                    )
                ),
                SizedBox(
                  width: 10,
                )
              ],
            ),

            SizedBox(height: 10),

            Row(
              children: [
                SizedBox(width: 10),
                Expanded(
                    child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                          style: TextStyle(),
                          controller: moduleController,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(color: Colors.red),
                            errorText: moduleSelect ? "Please Select Module ?" : null,
                            suffixIcon: IconButton(
                              icon: Icon(Icons.remove_circle),
                              color: Colors.blue,
                              onPressed: () {
                                setState(() {
                                  print("cleared");
                                  moduleController.text = "";
                                  moduleId = 0;
                                });
                              },
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14.0)),
                            labelText: 'Search  Module',
                          ),
                        ),
                        suggestionsBoxDecoration: SuggestionsBoxDecoration(elevation: 90.0),
                        suggestionsCallback: (pattern) {
                          return module.where((module) => module.pmModuleName.toUpperCase().contains(pattern.toUpperCase()));
                        },
                        itemBuilder: (context, suggestion) {
                          return Card(
                            color: Colors.blue,
                            child: ListTile(
                              title: Text(
                                suggestion.pmModuleName,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          print(suggestion.pmModuleName);
                          print("selected");
                          moduleController.text = suggestion.pmModuleName;
                          print("close.... $moduleId");
                          modulename = suggestion.pmModuleName;
                          print(suggestion.id);
                          print(".......module id");
                          moduleId = suggestion.id;
                          print("...........");
                        },
                        errorBuilder: (BuildContext context, Object? error) =>
                        error == null ? SizedBox() : Text(
                          '$error',
                          style: TextStyle(
                              color: Theme.of(context).errorColor
                          ),
                        ),
                        transitionBuilder: (context, suggestionsBox, animationController) =>
                            FadeTransition(
                              child: suggestionsBox,
                              opacity: CurvedAnimation(
                                  parent: animationController?.view ?? const AlwaysStoppedAnimation(0.0),
                                  curve: Curves.elasticIn
                              ),
                            )
                    )
                ),
                SizedBox(
                  width: 10,
                )
              ],
            ),


            SizedBox(height: 10),
//--------------------------------------Date part-------------------------------------------
            Row(
              children: [
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    style: TextStyle(fontSize: 15),
                    showCursor: true,
                    controller: assigndateController,
                    enabled: true,
                    validator: (v) {
                      if (v!.isEmpty) return "Required";
                      return null;
                    },
//
                    // will disable paste operation
                    focusNode: assigndtFocusNode,
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
                firstDate: DateTime(2000),
                lastDate: DateTime(2080),
                builder: (BuildContext context, Widget? child) {
                return Theme(
                data: ThemeData.light(),
                child: child!,
                );
                });

                if (date != null) {
                print(date);
                assigndate = date;
                var d = DateFormat("yyyy-MM-d").format(date);
                d = DateFormat("d-MM-yyyy").format(date);
                assigndateController.text = d;
                }
                },

                  decoration: InputDecoration(
                      errorStyle: TextStyle(color: Colors.red),
                      errorText: assigndateSelect ? "invalid date " : null,
                      suffixIcon: Icon(
                        Icons.calendar_today,
                        color: Colors.blue,
                        size: 24,
                      ),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0)),
                      // curve brackets object
                      hintText: "dd/mm/yy",
                      hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                      labelText: "Assign Date",
                    ),
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),

            SizedBox(height: 10),

            Row(
              children: [
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    style: TextStyle(fontSize: 15),
                    showCursor: true,
                    controller: expecteddateController,
                    enabled: true,
                    validator: (v) {
                      if (v!.isEmpty) return "Required";
                      return null;
                    },
                    focusNode: expdtFocusNode,
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
                        firstDate: now.subtract(Duration(days: 1)),
                        lastDate: DateTime(2080),
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData.light(),
                            child: child!,
                          );
                        },
                      );

                      if (date != null) {
                        print(date);
                        print("assigndate : $assigndate");
                        var chkdate = assigndate;
                        if ((date.isBefore(chkdate == null ? chkdate = date : chkdate))) {
                          print("invalid ;  $chkdate");
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                "Expectede date not  before Assign date ",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          );
                          return;
                        } else {
                          print("invalid date select ; $chkdate");
                          expectedDate = DateFormat("d-MM-yyyy").format(date);
                          expecteddateController.text = expectedDate;
                        }
                      }
                    },
                    decoration: InputDecoration(
                      errorStyle: TextStyle(color: Colors.red),
                      errorText: expectedDateSelect ? "invalid date " : null,
                      suffixIcon: Icon(
                        Icons.calendar_today,
                        color: Colors.blue,
                        size: 24,
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0)
                      ),
                      hintText: "dd/mm/yy",
                      hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                      labelText: "Expected Date",
                    ),
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),


            SizedBox(height: 10),

            Row(
              children: [
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    style: TextStyle(fontSize: 15),
                    showCursor: true,
                    controller: cmpltdateController,
                    enabled: true,
                    validator: (v) {
                      if (v!.isEmpty) return "Required";
                      return null;
                    },
                    focusNode: cmptdtFocusNode,
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
                        firstDate: now.subtract(Duration(days: 1)),
                        lastDate: DateTime(2080),
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData.light(),
                            child: child!,
                          );
                        },
                      );

                      if (date != null) {
                        print(date);
                        if (date.day < DateTime.now().day) {
                          print("invalid date select");

                          cmpltdateController.text = "";
                          return;
                        } else {
                          cmpltDate = date;
                          var d = DateFormat("d-MM-yyyy").format(date);
                          cmpltdateController.text = d;
                        }
                      }
                    },
                    decoration: InputDecoration(
                      errorStyle: TextStyle(color: Colors.red),
                      errorText: cmpltDateSelect ? "invalid date " : null,
                      suffixIcon: Icon(
                        Icons.calendar_today,
                        color: Colors.blue,
                        size: 24,
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0)
                      ),
                      hintText: "dd/mm/yy",
                      hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                      labelText: "Completed Date",
                    ),
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),


            SizedBox(height: 10),

//----------------------------------------End--Date part-----------------------------------------------------------------

            Row(
              children: [
                SizedBox(width: 10),
                Expanded(
                    child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                          style: TextStyle(),
                          controller: projMngController,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(color: Colors.red),
                            errorText: projMngSelect ? "Please Select proj Mng?" : null,
                            suffixIcon: IconButton(
                              icon: Icon(Icons.remove_circle),
                              color: Colors.blue,
                              onPressed: () {
                                setState(() {
                                  print("cleared");
                                  projMngController.text = "";
                                  projMngId = 0;
                                });
                              },
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14.0)),
                            labelText: 'Search Project Managed By',
                          ),
                        ),
                        suggestionsBoxDecoration: SuggestionsBoxDecoration(elevation: 90.0),
                        suggestionsCallback: (pattern) {
                          return users.where((user) => user.emEmployeeName.toUpperCase().contains(pattern.toUpperCase()));
                        },
                        itemBuilder: (context, suggestion) {
                          return Card(
                            color: Colors.blue,
                            child: ListTile(
                              title: Text(
                                suggestion.emEmployeeName,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          print(suggestion.emEmployeeName);
                          print("selected");
                          projMngController.text = suggestion.emEmployeeName;
                          print("close.... " + suggestion.emEmployeeName);
                          empname = suggestion.emEmployeeName;
                          print(suggestion.id);
                          print(".......ProjectManaged id");
                          employeeId = suggestion.id;
                          print("...........");
                        },
                        errorBuilder: (BuildContext context, Object? error) => // Change this line
                        error != null
                            ? Text('$error',
                            style: TextStyle(
                                color: Theme.of(context).errorColor))
                            : SizedBox.shrink(),  // This is an empty widget that does not render anything
                        transitionBuilder: (context, suggestionsBox, animationController) =>
                            FadeTransition(
                              child: suggestionsBox,
                              opacity: CurvedAnimation(
                                  parent: animationController?.view ?? const AlwaysStoppedAnimation(0.0),
                                  curve: Curves.elasticIn
                              ),
                            )
                    )
                ),
                SizedBox(
                  width: 10,
                )
              ],
            ),


            SizedBox(
              height: 10,
            ),

            Row(children: [
              SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: remarkController,
                  enabled: true,
                  validator: (v) {
                    if (v!.isEmpty) return "Required";
                    return null;
                  },
//
                  cursorColor: Colors.black,

                  scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
//                    suffixIcon: Icon(
//                      Icons.calendar_today,
//                      color: Colors.blue,
//                      size: 24,
//                    ),
//                       errorStyle: TextStyle(color: Colors.red),
//                       errorText: remarkSelect ? "Invalid Remark" : null,
//                       isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 18.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0)),
                    // curve brackets object
//                    hintText: "Quantity",
                    hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                    labelText: "Remark",
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              )
            ]),

            SizedBox(height: 10),

            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                    onTap: () {
                      print("Save");
                      itemSave();
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
                SizedBox(width: 172),
                GestureDetector(
                    onTap: () {
                      print("Reset");
                      setState(() {
                        Resetfunction();
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EmpName {
  int id;
  String emEmployeeName;

  EmpName({required this.id, required this.emEmployeeName});

  factory EmpName.fromJson(Map<String, dynamic> parsedJson) {
    return EmpName(
      id: parsedJson["id"].toInt(),
      emEmployeeName: parsedJson["emEmployeeName"].toString(),
    );
  }
}

class project {
  int id;
  String mpProjectName;

  project({required this.id, required this.mpProjectName});

  factory project.fromJson(Map<String, dynamic> parsedJson) {
    return project(
      id: parsedJson["id"].toInt(),
      mpProjectName: parsedJson["mpProjectName"].toString(),
    );
  }
}


class moduledata {
  int id;
  String pmModuleName;

  moduledata({required this.id, required this.pmModuleName});

  factory moduledata.fromJson(Map<String, dynamic> parsedJson) {
    return moduledata(
      id: parsedJson["id"].toInt(),
      pmModuleName: parsedJson["pmModuleName"].toString(),
    );
  }
}