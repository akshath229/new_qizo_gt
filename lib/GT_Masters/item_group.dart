import 'dart:convert';
import 'dart:ui';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

import '../appbarWidget.dart';
import '../models/userdata.dart';
import '../urlEnvironment/urlEnvironment.dart';
import 'AppTheam.dart';
import 'Masters_UI/cuWidgets.dart';

class Item_Group extends StatefulWidget {
  @override
  _Item_GroupState createState() => _Item_GroupState();
}

class _Item_GroupState extends State<Item_Group> {


  ImageProvider<Object> _resolveImage(Object imageSrc) {
    if (imageSrc is String) {
      return NetworkImage(imageSrc) as ImageProvider<Object>;
    } else if (imageSrc is File) {
      return FileImage(imageSrc) as ImageProvider<Object>;
    }
    throw ArgumentError('Unsupported image type');
  }


  CUWidgets cw = CUWidgets();
  AppTheam theam =AppTheam();
  //File _image;
  double TextBoxCurve=10.0;
   dynamic _image;
  ImagePicker picker = ImagePicker();

  SharedPreferences? pref;
  dynamic data;
  dynamic branch;
  var res;
  dynamic user;
  int? branchId;
  int? userId;
  UserData? userData;
  String branchName = "";
  dynamic userName;
  String? token;
  String? DeviceId;
  bool app_type=false;
  String ButtonName="Save";
int? Edit_Id=null;
// //----------------------------------
  TextEditingController DescriptionController = TextEditingController();
  TextEditingController Group_UnderController = TextEditingController();
  TextEditingController KOT_PrinterController = TextEditingController();
  TextEditingController Tab_Printer_IPController = TextEditingController();
  TextEditingController Display_OrderController = TextEditingController();
  TextEditingController TblSearchController =TextEditingController();

  bool Description_Select = false;
  bool Group_Under_Select = false;
  bool KOT_Printer_Select = false;
  bool Tab_Printer_IP_Selectr = false;
  bool Display_Order_Select = false;

var ItmGrp=[];
  String _searchResult = '';
  var usersFiltered=[];

  int GrpId=0;
  // static List<ItemGroup> ItmGrp = new List<ItemGroup>();
  static List<CustomerAdd> customerItemAdd = [];

  void initState() {
    setState(() {
      SharedPreferences.getInstance().then((value) {
        pref = value;
        read();
        GetItemGrp();
        customerItemAdd.clear();
        GeneralSettings();
      });
    });
  }





  GeneralSettings()async{

   var res=await cw.CUget_With_Parm(api:"generalSettings",Token: token);
   if(res!=false){

     print(res);
     var GenSettingsData=json.decode(res);
     print(GenSettingsData[0]["applicationType"]);
     setState(() {
       GenSettingsData[0]["applicationType"]=="GT"?app_type=false:app_type=true;
     });

   }

  }


  // //------------------for appbar------------
  read() async {
    var v = pref?.getString("userData");
    var c = json.decode(v!);
    user = UserData.fromJson(c); // token gets this code user.user["token"]
    setState(() {
      branchId = int.parse(c["BranchId"]);
      token = user.user["token"]; //  passes this user.user["token"]
      pref?.setString("customerToken", user.user["token"]);
      branchName = user.branchName;
      userName = user.user["userName"];
      userId = user.user["userId"];
      DeviceId = user.deviceId;
    });
  }

// //---------------end---for appbar------------
  getItemIndex(dynamic item) {
    var index = ItmGrp.indexOf(item);
    return index + 1;
  }

  //------ image select----------
  Future getImageFromGallery() async {
    print("on getImage");
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print("image selected $_image");
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageFromCamera() async {
    print("on getImage");
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

 //-----------------get item grp--------------------

  GetItemGrp() async {
    var jsonres = await cw.CUget_With_Parm(api: "Gtitemgroups", Token: token);

    if(jsonres != false) {
      setState(() {
        var result = jsonDecode(jsonres)["gtItemGroup"];
        ItmGrp = result as List;
        usersFiltered = result;
      });
      // The rest of your code remains unchanged...
    } else {
      print("Error on GetItemGrp");
    }
  }




  //----------------------save or add---------------------------
  SaveItem()async {


    if(ButtonName=="Save") {
      print("in SaveItem");
      var k = {
        "igDescription": DescriptionController.text,
        "igUnderGroupId": GrpId,
        "igKotPrinter": KOT_PrinterController.text,
        "igTabPrinter": Tab_Printer_IPController.text,
        "igDisplayOrder": Display_OrderController.text,
        //"igDiplayImagepath": _image,
        "igBranchId": branchId,
        "igUserId": userId,
        // "groupUnder":{
        // "igUnderGroupId": DescriptionController.text,
        // "igDescription": Group_UnderController.text,
        // }
      };

      var parm = jsonEncode(k);
      print(parm);
      var dio = Dio();

      String filePath = _image == null ? "" : _image.path;
      String fileName = 'Mob_Image';

      var formData = FormData.fromMap({
        'jsonString': parm,
        'image': null
        // _image== null ? "" : await MultipartFile.fromFile(
        // filePath, filename: fileName),

      });
      print(formData.toString());

      print(formData.fields);

      var res = await dio.post("${Env.baseUrl}Gtitemgroups",
        data: formData,
        options: Options(
          headers: {
            'content-type': 'multipart/form-data',
            'Authorization': token,
            'deviceId': DeviceId,
          },
          followRedirects: false,

        ),
      );
      print(res.statusCode);


      if (res.statusCode == 200 || res.statusCode == 201) {
        print(res.toString());
        print("success");
        cw.SavePopup(context);
        ClearFunction();
      } else {
        print(res.toString());
        print("error");
        cw.FailePopup(context);


        setState(() {
          // customerItemAdd.add(k);
          ClearFunction();
        });
      }
    }
    else//----Edit part-------------------------------------------
     {
      var k = {
        "id":Edit_Id,
        "igDescription": DescriptionController.text,
        "igUnderGroupId": GrpId,
        "igKotPrinter": KOT_PrinterController.text,
        "igTabPrinter": Tab_Printer_IPController.text,
        "igDisplayOrder": Display_OrderController.text,
        //"igDiplayImagepath": _image,
        "igBranchId": branchId,
        "igUserId": userId,
        // "groupUnder":{
        // "igUnderGroupId": DescriptionController.text,
        // "igDescription": Group_UnderController.text,
        // }
      };
      var parm = jsonEncode(k);
      print(parm);
      var dio = Dio();

      var formData = FormData.fromMap({
        'jsonString': parm,
        'image': null
        // _image== null ? "" : await MultipartFile.fromFile(
        // filePath, filename: fileName),

      });
      print(formData.toString());

      print(formData.fields);

      var res = await dio.put("${Env.baseUrl}Gtitemgroups/$Edit_Id",
        data: formData,
        options: Options(
          headers: {
            'content-type': 'multipart/form-data',
            'Authorization': token,
            'deviceId': DeviceId,
          },
          followRedirects: false,

        ),
      );
      print(res.statusCode);


      if (res.statusCode! >= 200 && res.statusCode! <=205) {
        print(res.toString());
        print("success");
        cw.UpdatePopup(context);
        ClearFunction();
      } else {
        print(res.toString());
        print("error");
        cw.FailePopup(context);


        setState(() {
          // customerItemAdd.add(k);
          ClearFunction();
        });
      }



    }
  }
  //----------------------------------------


  //-------------clear fun---------------------
  ClearFunction(){
    setState(() {
      TableReset();
 Edit_Id=null;
    ButtonName="Save";
   DescriptionController.text="";
   Group_UnderController.text="";
    GrpId=0;
       KOT_PrinterController.text="";
    Tab_Printer_IPController.text="";
   Display_OrderController.text="";
    _image=null;
      GetItemGrp();
    });
  }




 Validation(){

if(DescriptionController.text==""){
setState(() {
  Description_Select=true;
});
}else if(Group_UnderController.text=="" && GrpId==0){
  setState(() {
    Description_Select=false;
    Group_Under_Select=true;
  });
}
else{


  setState(() {
    SaveItem();
    Description_Select=false;
    Group_Under_Select=false;
  });

}



 }






//--------------------------Delete------------------------------------

  Delete(id)async{
    TableReset();
    print(id.toString());
    var res=await cw.delete(api:"Gtitemgroups/$id",Token:token,deviceId:DeviceId);
    if(res!=false) {
      print("Deletd");
      print(res.toString());
      ClearFunction();
      cw.DeletePopup(context);
      return;

    }else{
      print("Deletd Faile");
      cw.FailePopup(context);
    }


  }




//------------------------------------Edit binding-------------------------------
EditBind(data){
    print(data['id']);


    setState(() {
      TableReset();
      Edit_Id=data['id'];
      ButtonName="Update";
    DescriptionController.text=data['igDescription'];
    Group_UnderController.text=data['groupUnder'];
    GrpId=data['igUnderGroupId'];
    KOT_PrinterController.text=data['igKotPrinter'];
    Tab_Printer_IPController.text=data['igTabPrinter'];
    Display_OrderController.text=data['igDisplayOrder'].toString()=="null"?"":data['igDisplayOrder'].toString();
    _image=data['igDiplayImagepath'];

    });

}


TableReset(){

  TblSearchController.text="";
  _searchResult = "";
  usersFiltered = ItmGrp.where((user) => user['igDescription'].toLowerCase().contains(_searchResult) || user['igDescription'].toLowerCase().contains(_searchResult)).toList();
}

  ///-------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: PreferredSize(
          child: Appbarcustomwidget(
              uname: userName,
              branch: branchName,
              pref: pref,
              title: "Item Group"),
          preferredSize: Size.fromHeight(80)),
      body: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
            child: cw.CUTestbox(
                hintText: "",
                label: "Description",
                controllerName: DescriptionController,
            errorcontroller:Description_Select),
          ),
          //----------------Group_Under-------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
            child: TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller:Group_UnderController ,
                  style: TextStyle(),
                  decoration: InputDecoration(
                    errorStyle: TextStyle(color: Colors.red),
                    errorText: Group_Under_Select
                        ? "Invalid Group Selected"
                        : null,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.remove_circle),
                      color: Colors.blue,
                      onPressed: () {
                        setState(() {
                          print("cleared");
                          Group_UnderController.text = "";
                          //  salesPaymentId = 0;
                        });
                      },
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 16.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(TextBoxCurve)),

                    hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                    labelText: "Group Under",
                  ),
                ),

                suggestionsBoxDecoration:
                SuggestionsBoxDecoration(elevation: 90.0),
                suggestionsCallback: (pattern) {
//                        print(payment);
                  return ItmGrp.where((unt) => unt['igDescription'].trim().toLowerCase().contains(pattern.trim().toLowerCase()));
                },
                itemBuilder: (context, suggestion) {
                  return Card(
                    margin: EdgeInsets.all(2),
                    color: Colors.white,
                    child: ListTile(tileColor:theam.DropDownClr,
                      title: Text(
                        suggestion['igDescription'],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  print(suggestion['igDescription']);
                  print("Grp selected");

                  Group_UnderController.text = suggestion['igDescription'];
                  print("close.... $GrpId");
                  GrpId = 0;

                  print(suggestion['id']);
                  print(".......GrpId id");
                  GrpId = suggestion['id'];
                  print(GrpId);
                  print("...........");
                },
                errorBuilder: (BuildContext context, Object? error) =>
                    Text('$error',
                        style: TextStyle(
                            color: Theme.of(context).errorColor)),
                transitionBuilder:
                    (context, suggestionsBox, animationController) =>
                    FadeTransition(
                      child: suggestionsBox,
                      opacity: CurvedAnimation(
                          parent: animationController!,
                          curve: Curves.elasticIn),
                    )),
          ),
          //----------------unit-------------------


          Visibility(visible:app_type,
            child: Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                  child: Container(
                      child: cw.CUTestbox(
                          label: "KOT Printer",
                          controllerName: KOT_PrinterController)),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                  child: Container(
                      child: cw.CUTestbox(
                          label: "Tab Printer IP",
                          controllerName: Tab_Printer_IPController)),
                )),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: Container(
                    child: cw.CUTestbox(
                        label: "Display Order",
                        controllerName: Display_OrderController,TextInputFormatter: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}")
                      )],TextInputType:TextInputType.number )),
              )),

              Container(
                child: _image == null
                    ? Text("")
                    : Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    image: DecorationImage(
                      image: _resolveImage(_image),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),



              Padding(
                padding: const EdgeInsets.only(right: 10, bottom: 15),
                child: IconButton(
                    icon: Icon(
                      Icons.image,
                      size: 50,
                    ),
                    onPressed: () {
                      showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (c) => AlertDialog(
                            // shape: RoundedRectangleBorder(
                            //     borderRadius:
                            //     BorderRadius.all(
                            //         Radius.circular(50.0))),
                            insetPadding: EdgeInsets.symmetric(horizontal: 100, ),
                            content: Container(

                              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                               crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                      icon: Icon(
                                        Icons.filter,
                                        color: Colors.lightBlue,
                                        size: 35,
                                      ),
                                      onPressed: () {

                                        getImageFromGallery();
                                        Navigator.of(context,rootNavigator: true).pop();
                                      }),
                                     Spacer(),

                                  IconButton(
                                      icon: Icon(
                                        Icons.camera_alt,color: Colors.lightBlue,
                                        size: 35,
                                      ),
                                      onPressed: () {
                                        // Navigator.of(context,rootNavigator: true).pop();
                                        getImageFromCamera();
                                      }),

                                  Spacer(),

                                  IconButton(
                                      icon: Icon(
                                        Icons.delete,color: Colors.lightBlue,
                                        size: 35,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context,rootNavigator: true).pop();
                                       setState(() {
                                         _image=null;
                                       });
                                      }),
                                ],
                              ),
                            )),
                      );
                    }),
              ),
            ],
          ),


          Visibility(
            visible: ItmGrp.length > 0,
            child: Container(height: MediaQuery.of(context).size.height/2.1,
              child: SingleChildScrollView(scrollDirection: Axis.vertical,
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
                          columnSpacing: 20,
                          // columnSpacing: 20,
                          onSelectAll: (b) {},
                          sortAscending: true,
                          headingRowColor:theam.TableHeadRowClr,

                          columns: <DataColumn>[
                            DataColumn(
                              label: Text('No',style:theam.TableFont),
                            ),
                            DataColumn(
                              label: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [

                                  Text('Desc',style:theam.TableFont,),

                                  Container(height: 25,width: 55,
                                    child: TextField(style: TextStyle(color: Colors.white,),
                                        controller: TblSearchController,
                                        decoration: new InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding:
                                            EdgeInsets.only(bottom: 10, left: 0.5, right:0.5),
                                            hintText: 'Search',
                                            hintStyle: TextStyle(color: Colors.black)
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            _searchResult = value;
                                            usersFiltered = ItmGrp.where((user) => user['igDescription'].toLowerCase().contains(_searchResult) || user['igDescription'].toLowerCase().contains(_searchResult)).toList();
                                          });
                                        }),
                                  ),
                                ],
                              ),
                            ),
                            DataColumn(
                              label: Text('Grp Under',style:theam.TableFont),
                            ),
                            // DataColumn(
                            //   label: Text('Image'),
                            // ),
                            DataColumn(
                              label: Text(''),// label: Text('Cess %'),
                            ),
                          ],
                          rows:List.generate(usersFiltered.length, (index) =>
                              DataRow(
                                cells: [
                                  DataCell(
                                    Text(getItemIndex(usersFiltered[index]).toString()),
                                    showEditIcon: false,
                                    placeholder: false,
                                  ),
                                  DataCell(
                                    Text(usersFiltered[index]['igDescription'].toString()),
                                    showEditIcon: false,
                                    placeholder: false,
                                  ),
                                  DataCell(
                                    Text(usersFiltered[index]['groupUnder'].toString()),
                                    showEditIcon: false,
                                    placeholder: false,
                                  ),
                                  //                               DataCell(
                                  //                                 Container(
                                  //                                   child:itemRow['igDiplayImagepath']==null? Icon(Icons.broken_image_outlined):
                                  //                                   Container(
                                  //                                     height: 40,
                                  //                                     width: 40,
                                  //                                     decoration: BoxDecoration(
                                  //                                         borderRadius: BorderRadius.circular(40.0),
                                  //                                         image: DecorationImage(
                                  //                                             image: NetworkImage(itemRow['igDiplayImagepath']),
                                  //                                             onError:(a,d){
                                  //                                              // print("Error on image");
                                  //                                              },
                                  //                                             //AssetImage("assets/icon1.jpg"),
                                  //                                             fit: BoxFit.fill),
                                  //
                                  //
                                  //
                                  // ),
                                  //                                   ),
                                  //                                 ),
                                  //                                 showEditIcon: false,
                                  //                                 placeholder: false,
                                  //                               ),
                                  DataCell(
                                    PopupMenuButton<int>(
                                      onSelected:(a){
                                        print("saf $a");
                                      } ,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30.0),

                                      ),
                                      color:theam.EditpopupClr,
                                      itemBuilder: (context) => [
                                        PopupMenuItem(height: 30,
                                          child:
                                          Container(
                                            child: Row(children: [
                                              GestureDetector(child: Padding(
                                                padding: const EdgeInsets.only(left: 5),
                                                child: Icon(Icons.edit,color: Colors.white,),
                                              ),
                                                onTap: (){
                                                  Navigator.pop(context);
                                                  print("edit $usersFiltered[index]");
                                                  // print(itemRow['brndDescription']);
                                                  EditBind(usersFiltered[index]);
                                                },

                                              ),
                                              Spacer(),
                                              GestureDetector(child: Padding(
                                                padding: const EdgeInsets.only(left: 5,right: 5),
                                                child: Icon(Icons.delete,color: Colors.white,),
                                              ),
                                                onTap: (){
                                                  Navigator.pop(context);
                                                  print("delete");
                                                  Delete(usersFiltered[index]['id']);

                                                },


                                              )
                                            ],),
                                          ),)
                                      ],
                                      icon: Icon(Icons.more_horiz),
                                      //offset: Offset()
                                    ),
                                    showEditIcon: false,
                                    placeholder: false,
                                  ),
                                ],
                              ),
                          )
                              .toList(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 4, 8),
              child: cw.CUButton(
                  H: 50,
                  color:theam.saveBtn_Clr,
                  name: ButtonName,
                  Labelstyl:
                      TextStyle(fontSize: 26,color: Colors.white),
              function:() {
                  Validation();
              }
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
              child: cw.CUButton(
                  H: 50,
                  function: (){ClearFunction();},
                  name: "Clear",
                  color: Colors.indigo,
                  Labelstyl:
                      TextStyle(fontSize: 26,color: Colors.white)),
            ),
          )
        ],
      ),
    ));
  }
}




class CustomerAdd {
  late String Description;
  late String Group_Under;
  late int Group_Under_id;
  late String Kot_Printer;
  late String Printer_ip;
  late String Dis_Order;
  late File img_path;

  CustomerAdd({
    required this.Description,
    required this.Group_Under,
    required this.Group_Under_id,
    required this.Kot_Printer,
    required this.Printer_ip,
    required this.Dis_Order,
    required this.img_path,
    required int id,
  }
      ) ;
  CustomerAdd.formJson(Map<String,dynamic>json){
    Description=json["Description"];
    Group_Under=json["Group_Under"];
    Group_Under_id=json["Group_Under_id"];
    Kot_Printer=json["Kot_Printer"];
    Printer_ip=json["Printer_ip"];
    Dis_Order=json["Dis_Order"];
    img_path=json["img_path"];


  }
}




