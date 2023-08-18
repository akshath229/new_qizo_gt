import 'dart:async';
import 'dart:convert';

import 'dart:io'as io;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:dio/dio.dart';

import '../../urlEnvironment/urlEnvironment.dart';
import '../AppTheam.dart';
import 'cuWidgets.dart';


class Create_Brand extends StatefulWidget {
  double height;
  double width;
  dynamic token;
  dynamic device_id;
  dynamic TblShow;
  dynamic userId;
  dynamic branchId;

  Create_Brand({
    required this.height,
    required this.width,
    @required this.token,
    @required this.device_id,
    @required this.TblShow,
    @required this.userId,
    @required this.branchId,

  });

  @override
  _Create_BrandState createState() => _Create_BrandState();
}

class _Create_BrandState extends State<Create_Brand> {

  CUWidgets cw = CUWidgets();
  AppTheam theam =AppTheam();
  bool TableShow=true;
   var SaveButtonText="Save";
  var  BrandList=[];
  // File _image;

  dynamic _image;
 // io.File _image;

  ImagePicker picker = ImagePicker();

  TextEditingController Brand_Name_Controller = TextEditingController();
bool Brand_Name_validation=false;
dynamic EditId=0;


  void initState() {

  Timer(Duration(seconds: 1), (){
    setState(() {
    GetBrand();
  });

    setState(() {
      TableShow=widget.TblShow;
    });


  });
}



  getItemIndex(dynamic item) {
    var index = BrandList.indexOf(item);
    return index + 1;
  }




  //--------------Get Brand------------------

  GetBrand() async {
    print("error ");
    var jsonres = await cw.CUget_With_Parm(Token:widget.token, api: "MBrands", );

    if (jsonres != false) {
      var res = jsonDecode(jsonres);
  BrandList = res as List;
 // print(BrandList.toString());
return BrandList;
    }
    else{print("error "+jsonres.toString());}
  }


  //------ image select----------

  Future getImageFromGallery() async {
    print("on getImage");
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        //_image = File(pickedFile.path);
        _image =io.File(pickedFile.path);
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
        _image =io.File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }


ClereFunction(){
    setState(() {
       SaveButtonText="Save";
        BrandList=[];
        _image=null;
        EditId=0;
        Brand_Name_Controller.text="";
        Brand_Name_validation=false;

    });

}


  //----------------------------validation---------------------------------------

 Validation(){

if(Brand_Name_Controller.text==""){

  setState(() {
    Brand_Name_validation=true;

  });
}else{
  setState(() {
    Brand_Name_validation=false;
    if(SaveButtonText=="Save"){
      Savedata();
    }else{

      Edit();
    }

  });

}
 }

  //----------------------------Save---------------------------------------

  Savedata()async{
print("on save");
var finaldata={
   "brndId":0,
  // "brndImage":"",//_image.toString(),
  "brndDescription":Brand_Name_Controller.text,
  "brndUserId":widget.userId,
  "brndBranchId": widget.branchId,
};



var parm=jsonEncode(finaldata);
print(parm);
var dio = Dio();


// var sss= await MultipartFile.fromFile(_image?.path,
//     filename: _image.path.split('/').last ?? 'image.jpeg');
//
//
// print(sss.filename);


//_image != null ? _image.path.split('/').last ?? 'image.jpeg':"";

    String filePath = _image==null?"":_image.path;
    String fileName = 'Mob_Image.jpeg';


    var formData = FormData.fromMap({
      'jsonString':parm,
      'image':_image==null?"": await MultipartFile.fromFile(filePath, filename:fileName),
     // 'image':_image != null ?json.encode(base64Encode(_image.readAsBytesSync()))  : '',
    });
print(formData.toString());

print(formData.fields);


var res = await dio.post("${Env.baseUrl}MBrands",
  data: formData,
  options: Options(
    headers: {
      'content-type': 'multipart/form-data',
      'Authorization':widget.token,
      'deviceId':widget.device_id,
    },
    followRedirects: false,

  ),
);
print(res.statusCode);

// if(res!=false && res.toString().contains("msg")) {
//   // print("contains(msg)");
//   var resmsg=jsonDecode(res);
//   // print(resmsg.toString());
//   // print(resmsg["msg"].toString());
//
//   cw.MessagePopup(context,resmsg["msg"]);
//   return;
//
// }
 if(res.statusCode == 200 || res.statusCode == 201 ){
  print(res.toString());
  print("success");
  cw.SavePopup(context);
  ClereFunction();
}else{
  print(res.toString());
  print("error");
  cw.FailePopup(context);

}


  }




//-------------------------------Edit------------------------------------------
  Edit()async{

    var dio = Dio();
    var formData=FormData();
print("Edit");
var finaldata={
  "brndId":EditId,
  // "brndImage":"",//_image.toString(),
  "brndDescription":Brand_Name_Controller.text,
  "brndUserId":widget.userId,
  "brndBranchId": widget.branchId,
};

    var parm = jsonEncode(finaldata);
    print(parm);
    print(_image.toString());





if(_image.runtimeType.toString()=="String"){
  print("image on String form");
  // var Edited_image=await io.File(_image);

  // String filePath = _image == null ? "" : Edited_image.path;
  // String fileName = 'Mob_Image';
  formData = FormData.fromMap({
    'jsonString': parm,
    'image': _image == null ? "" : _image,
    // 'image': _image == null ? "" : await MultipartFile.fromFile(
    //         filePath, filename: fileName),
  });




}else {
  print("Edit New image Selected");
  String filePath = _image == null ? "" : _image.path;
  String fileName = 'Mob_Image.jpeg';
  print(filePath.toLowerCase());
   formData = FormData.fromMap({
    'jsonString': parm,
    'image': _image == null ? "" : await MultipartFile.fromFile(
        filePath, filename: fileName),
    // 'image':_image != null ?json.encode(base64Encode(_image.readAsBytesSync()))  : '',
  });
}
print("Edit final");
    print(formData.fields);
// return;
var res = await dio.put("${Env.baseUrl}MBrands/$EditId",
  data: formData,
  options: Options(
    headers: {
      'content-type': 'multipart/form-data',
      'Authorization':widget.token,
      'deviceId':widget.device_id,
    },
    followRedirects: false,

  ),
);
print(res.statusCode);

// if(res!=false && res.toString().contains("msg")) {
//   // print("contains(msg)");
//   var resmsg=jsonDecode(res);
//   // print(resmsg.toString());
//   // print(resmsg["msg"].toString());
//
//   cw.MessagePopup(context,resmsg["msg"]);
//   return;
//
// }
    if(res.statusCode! >= 200 && res.statusCode! <=205 ){
      print(res.toString());
      print("updated");
      cw.UpdatePopup(context);
      ClereFunction();
    }else{
      print(res.toString());
      print("error");
      cw.FailePopup(context);

    }


  }



//----------------------------------Edit data Binding--------------------------------------

EditBinding(data){
print("yityuituy");
print(data.toString());

setState(() {
  print(data['brndDescription']);
  Brand_Name_Controller.text=data['brndDescription'];
  EditId=data['brndId'];
  SaveButtonText="Update";
  _image=data['brndImage'];
});

}





//--------------------------Delete------------------------------------

  Delete(id)async{
print(id.toString());
   var res=await cw.delete(api:"MBrands/$id",Token: widget.token,deviceId:widget.device_id);
   if(res!=false) {
  print("Deletd");
   print(res.toString());
  ClereFunction();
  cw.DeletePopup(context);
  return;

}else{
     print("Deletd Faile");
     cw.FailePopup(context);
   }


  }


//----------------------------------------------------------
test()async{


var l=io.File(_image);
print(l.toString());
print(l.path.toString());
var  ss=l.length();
print(ss.toString());
}







  ///-----------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: [

          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: cw.CUTestbox(
                    controllerName: Brand_Name_Controller,
                    label: "Brand Name",
                    errorcontroller:Brand_Name_validation,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  child: _image == null
                      ? Text("")
                      : Container(
                    height: widget.height==350?50:80,
                    width:  widget.height==350?50:80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.height == 350 ? 30 : 0,),
                      image: DecorationImage(
                          image: _image is String
                              ? NetworkImage(_image as String)
                              : _image is io.File
                              ? FileImage(_image as io.File)
                              : AssetImage("assets/default_image.jpg"), // or some other default asset image
                          fit: BoxFit.fill
                      ),
                    ),

                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10, bottom: 15),
                child: IconButton(
                    icon: Icon(
                      Icons.add_a_photo,
                      color: Colors.blue,
                      size: 40,
                    ),
                    onPressed: () {
                      showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (c) => AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(
                                    Radius.circular(50.0))),
                            insetPadding: EdgeInsets.symmetric(
                              horizontal: 100,
                            ),
                            content: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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

                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      }),
                                  Spacer(),
                                  IconButton(
                                      icon: Icon(
                                        Icons.camera_alt,
                                        color: Colors.lightBlue,
                                        size: 35,
                                      ),
                                      onPressed: () {
                                        // Navigator.of(context,rootNavigator: true).pop();

                                        getImageFromCamera();
                                      }),
                                  Spacer(),
                                  IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.lightBlue,
                                        size: 35,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();

                                        setState(() {
                                          _image = null;
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




        Visibility(visible: TableShow,
          child: FutureBuilder(
            future: GetBrand(),
           builder: (context, snapshot) {
              // print("iuyi");
            //  print(snapshot.data.toString());
             return snapshot.data.toString()=="null"?Text("No Data "):  SingleChildScrollView(
               scrollDirection: Axis.horizontal,
               child: DataTable(
                 columnSpacing: 15,
                 onSelectAll: (b) {},
                 headingRowColor: theam.TableHeadRowClr,
                 sortAscending: true,
                 showCheckboxColumn: false,
                 columns: <DataColumn>[
                   DataColumn(
                     label: Text(
                       'No',style: theam.TableFont,
                       textAlign: TextAlign.left,
                     ),
                   ),
                   DataColumn(
                     label: Text('Item Type',style: theam.TableFont,),
                   ),
                   // DataColumn(
                   //   label: Text(''),
                   // ),
                   DataColumn(
                     label: Text(''),
                   ),

                 ],
                 rows: BrandList
                     .map(
                       (itemRow) => DataRow(
                     cells: [
                       DataCell(
                         Text(getItemIndex(itemRow).toString()),
                         showEditIcon: false,
                         placeholder: false,
                       ),
                       DataCell(
                         Text(itemRow["brndDescription"]),
                         showEditIcon: false,
                         placeholder: false,
                       ),
                       // DataCell(
                       //   itemRow["brndImage"].toString()=="null"?Text(""):
                       //   Padding(
                       //     padding: const EdgeInsets.only(top: 5),
                       //     child: Container(
                       //       height:50,
                       //       width: 50,
                       //       decoration: BoxDecoration(
                       //           borderRadius: BorderRadius.circular(30),
                       //           image: DecorationImage(
                       //               image: NetworkImage(itemRow["brndImage"]),
                       //
                       //               //AssetImage("assets/icon1.jpg"),
                       //
                       //               fit: BoxFit.fill))),
                       //   ),
                       //   // SizedBox(child: Image.network(itemRow["brndImage"])),
                       //   showEditIcon: false,
                       //   placeholder: false,
                       // ),

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
                                       print("edit $itemRow");
                                       print(itemRow['brndDescription']);
                                       EditBinding(itemRow);
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
                                       Delete(itemRow['brndId']);

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
             );

           },
          ),
        )
      ]),


          bottomNavigationBar:    Container(width: widget.width,height: 80,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: cw.CUButton(H: 50,name: SaveButtonText,W: 60,
                        function: (){Validation();},
                        Labelstyl: TextStyle(
                          fontSize: 30,
                          color: Colors.white
                        ),
                        color:theam.saveBtn_Clr),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: cw.CUButton(color: Colors.indigo,H: 50,name: "Clear",W: 60,
                        Labelstyl: TextStyle(
                          fontSize: 30,
                          color: Colors.white
                        ),
                        function: (){
                          //  Navigator.pop(context);
// ClereFunction();
                          test();
                        }),
                  ),
                ),


              ],),
          ),

    ));
  }
}
