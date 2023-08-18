import 'dart:async';
import 'dart:convert';

/// for show both Unit master and popup of Item master unit texbox common page

import 'package:flutter/material.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../AppTheam.dart';
import '../Models/Unit_model.dart';
import 'cuWidgets.dart';



class Create_Unit extends StatefulWidget {
  dynamic UnitList;
  dynamic Height;
  dynamic Wedth;
  dynamic Token;
  bool visibility;
  dynamic deviceId;

  Create_Unit(
      {
        @required this.UnitList,
        @required this.Height,
        @required this.Wedth,
        @required this.Token,
        required this.visibility,
        @required this.deviceId,

      });

  @override
  _testState createState() => _testState();
}

class _testState extends State<Create_Unit> {

  // //---------------end---for appbar------------


  double TextBoxCurve=10.0;
  TextEditingController Unit_Name_Controller=TextEditingController();
  TextEditingController Description_Controller=TextEditingController();
  TextEditingController Type_Controller=TextEditingController();
  TextEditingController Unit_mstr_Controller=TextEditingController();
  TextEditingController Conversion_Controller=TextEditingController();

  bool  Unit_Name_Valid=false;
  bool  Type_Valid=false;
  bool  Unit_mstr_Select=false;
  bool  Conversion_Select=false;


  bool  CompountVisible=false;
  int UnimstrtId=0;

String SaveButtonText="Save";
  var Edit_Id=0;
  static List<Unit> unit =[];

  //----------------------for show and hide conversion part accordin to copount-------------------------------

  var type=[
    {"name":'Simple','id':1,},
    {"name":'Compound','id':2,},
  ];
  CUWidgets cw=CUWidgets();
  AppTheam theam =AppTheam();
  bool typeshow=false;
  bool TabelShow=false;
  int typeId=0;
  //-----------------------------------------------------


  var convText="";
  var Unitlist=[];



  initState() {

   setState(() {
     Unitlist= widget.UnitList as List;
     GetInitialData();
   });
  }
//-----------------change text while add conversion----------------
  GetInitialData() {

    Timer(Duration(seconds: 1), (){
      setState(() {
        GetUnit();
      });
    });

  }

ConversionText(){
setState(() {
  convText="1= ${Conversion_Controller.text} (${Unit_mstr_Controller.text})";
});

}


//-----------------------get unit foe refresh-----------------------
  GetUnit() async {
    print("GetUnit");
    var jsonres = await cw.CUget_With_Parm(api: "Gtunits", Token: widget.Token);

    if (jsonres != false) {
      var res = jsonDecode(jsonres);
      //  print("Unites = $res");

        List<dynamic> unitdetl = res["gtunit"];
        List<Unit> p =
        unitdetl.map((unitdetl) => Unit.fromJson(unitdetl)).toList();

        unit = p;
        TabelShow=widget.visibility;

    }
  }




  //-----------------validation----------------------

  Validation(){

    if(Unit_Name_Controller.text=="") {
      setState(() {
        Unit_Name_Valid = true;
      });
    }
      else if(
    Type_Controller.text==""||typeId==0)
      {
        setState(() {
          Unit_Name_Valid = false;
          Type_Valid=true;
        });
    }





      else if(Type_Controller.text=="Compound"){
      print(UnimstrtId.toString());
        if(Unit_mstr_Controller.text=="" ||  UnimstrtId==0) {
          setState(() {
            Unit_mstr_Select = true;
            Unit_Name_Valid = false;
            Type_Valid = false;
          });
        } else if( Conversion_Controller.text=="")
        {
          setState(() {
            Conversion_Select=true;
            Unit_mstr_Select=false;
            Unit_Name_Valid = false;
            Type_Valid=false;
          });

        }

        else
        {

          setState(() {
            Conversion_Select=false;
            Unit_mstr_Select=false;
            Unit_Name_Valid = false;
            Type_Valid=false;
            Save("from Compunt");
          });
        }

    }

      else
        {

        setState(() {
          Conversion_Select=false;
          Unit_mstr_Select=false;
          Unit_Name_Valid = false;
          Type_Valid=false;
          Save("from simple");
        });
    }



  }




//----------------------------save---------------------
Save(a)async{
  print(a.toString());
    print("on save");

   var  finaldata;

    if(Type_Controller.text=="Simple"){
      finaldata = {
        "id": SaveButtonText=="Save"?0:Edit_Id,//id,
        "formalName": Unit_Name_Controller.text,
        "description": Description_Controller.text,
        "isSimple": false,
         "nos": 1,
        // "unitUnder":UnimstrtId,
      };
    }

else
  {
    finaldata = {
      "id": SaveButtonText=="Save"?0:Edit_Id,//id,
      "formalName": Unit_Name_Controller.text,
      "description": Description_Controller.text,
      "isSimple": true,
      "nos": Conversion_Controller.text,
      "unitUnder":UnimstrtId,
    };
  }




//print(finaldata.toString());
 var  parm = json.encode(finaldata);
   print(parm.toString());

if(SaveButtonText=="Save"&&Edit_Id==0) {
  print("Save");
  var res = await cw.post(api: "Gtunits",
      body: parm,
      Token: widget.Token,
      deviceId: widget.deviceId);
  if(res!=false && res.toString().contains("msg")) {
    // print("contains(msg)");
    var resmsg=jsonDecode(res);
    // print(resmsg.toString());
    // print(resmsg["msg"].toString());

    cw.MessagePopup(context,resmsg["msg"],Colors.red);
    return;

  }
  else
  if (res != false) {
    print(res.toString());
    Clear();
    GetUnit();
    print(res.toString());
    cw.SavePopup(context);
  } else {
    cw.FailePopup(context);
  }
}
//------------edit part---------------
else

  {
    print("edit part");
    print(Edit_Id.toString());
var res= await cw.put(api: "Gtunits/$Edit_Id",body: parm, Token: widget.Token, deviceId: widget.deviceId);
    if(res!=false && res.toString().contains("msg")) {
      // print("contains(msg)");
      var resmsg=jsonDecode(res);
      // print(resmsg.toString());
      // print(resmsg["msg"].toString());
      cw.MessagePopup(context,resmsg["msg"],Colors.red);
      return;
    }
    else if (res != false) {
      Clear();
     // print(res.toString());
     // GetUnit();
      print(res.toString());
      cw.UpdatePopup(context);
    } else {
      cw.FailePopup(context);
    }

  }





}


//-------------------clear------------------------
  Clear(){
setState(() {
    Unit_Name_Controller.text="";
    Description_Controller.text="";
    Type_Controller.text="";
    Unit_mstr_Controller.text="";
    Conversion_Controller.text="";
    convText="";
    typeshow=false;
    UnimstrtId=0;
    SaveButtonText="Save";
    Edit_Id=0;
    Unit_Name_Valid=false;
    Type_Valid=false;
    Unit_mstr_Select=false;
    GetUnit();
  });
  }




//------------------------Edit--------------------------------

Edit(Data)  {
print("on edit");
setState(() {
  SaveButtonText="Update";
  Edit_Id=Data.id;
});


// print(Data.unitUnder.runtimeType);
var underUnit="";
var underId=Data.unitUnder.toString()=="null"?"0":Data.unitUnder.toString();
unit.forEach((f) {
  if (f.id.toString() == underId) {
  // print(f.formalName);
   underUnit=f.formalName;
  }
  return;
});
if(Data.isSimple.toString()=="true"){//  Comount typ
  setState(() {
    Unit_Name_Controller.text=Data.formalName.toString();
    Description_Controller.text=Data.description.toString();
    Type_Controller.text="Compound";
    typeId=2;
    Conversion_Controller.text=Data.nos.toString();
    UnimstrtId=int.parse(underId);
    typeshow=true;
    Unit_mstr_Controller.text=underUnit;
  });

}

else{

  setState(() {
    Unit_Name_Controller.text=Data.formalName;
    Description_Controller.text=Data.description;
    Type_Controller.text="Simple";
    typeId=1;
    typeshow=false;
  });



}
}



Delete(Un_id)async{


    var res= await cw.delete(api: "Gtunits/$Un_id", Token: widget.Token, deviceId: widget.deviceId,);
  if(res!=false && res.toString().contains("msg")) {
      print("contains(msg)");
      var resmsg=jsonDecode(res);
      // print(resmsg.toString());
      // print(resmsg["msg"].toString());
      cw.MessagePopup(context,resmsg["msg"],Colors.indigo.shade200);
      return;
    }
    else
  if(res!=false){
    cw.DeletePopup(context);
    setState(() {
      // GetUnit();
    });



  }else
      {
        cw.FailePopup(context);
      }

}




  ///-------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return
     Scaffold(body:
     ListView( shrinkWrap: true,
          children: [
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: cw.CUTestbox(controllerName: Unit_Name_Controller,
                 label: "Name", errorcontroller: Unit_Name_Valid),
           ),
           Padding(
             padding: const EdgeInsets.only(left: 8, right: 8,bottom: 4),
             child: cw.CUTestbox(controllerName: Description_Controller,
               label: "Description",
             ),
           ),
           Padding(
             padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
             child: TypeAheadField(
                 textFieldConfiguration: TextFieldConfiguration(
                   controller: Type_Controller,
                   style: TextStyle(),
                   decoration: InputDecoration(
                     errorStyle: TextStyle(color: Colors.red),
                     errorText: Type_Valid ? "Invalid Type Selected" : null,
                     suffixIcon: IconButton(
                       icon: Icon(Icons.remove_circle),
                       color: Colors.blue,
                       onPressed: () {
                         print("cleared");
                         Type_Controller.text = "";
                         typeshow=false;
                         //  salesPaymentId = 0;
                       },
                     ),

                     isDense: true,
                     contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 16.0),
                     border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(TextBoxCurve)),
                     hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                     labelText: "Type",
                   ),
                 ),
                 suggestionsBoxDecoration:
                 SuggestionsBoxDecoration(elevation: 90.0),
                 suggestionsCallback: (pattern) {
//                        print(payment);
                   return type.where((typ) => typ["name"].toString().trim().contains(pattern));
                 },
                 itemBuilder: (context, suggestion) {
                   return Card(
                     margin: EdgeInsets.all(2),
                     color: Colors.white,
                     child: ListTile(
                       tileColor:theam.DropDownClr,
                       title: Column(
                         children: [
                           Text(
                             suggestion["name"].toString(),
                             style: TextStyle(color: Colors.white),
                           ),
                         ],
                       ),
                     ),
                   );
                 },
                 onSuggestionSelected: (suggestion) {
                   print( suggestion["name"]);
                   print("Typ selected");

                   Type_Controller.text = suggestion["name"].toString();
                   typeId = int.tryParse(suggestion["id"].toString()) ?? 0;
                   print("...........");
                   if (Type_Controller.text == "Compound") {
                     setState(() {
                       typeshow = true;
                     });
                   } else {
                     setState(() {
                       typeshow = false;
                     });
                   }
                 },
                 errorBuilder: (BuildContext context, Object? error) =>
                     Text(
                         '$error',
                         style: TextStyle(color: Theme
                             .of(context)
                             .errorColor)),
                 transitionBuilder:
                     (context, suggestionsBox, animationController) =>
                     FadeTransition(
                       child: suggestionsBox,
                       opacity: CurvedAnimation(
                           parent: animationController!,
                           curve: Curves.elasticIn),
                     )),
           ),


           Visibility(visible:typeshow,

             child:   Column(children: [



               Padding(

                 padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),

                 child: TypeAheadField(

                     textFieldConfiguration: TextFieldConfiguration(

                       controller: Unit_mstr_Controller,

                       style: TextStyle(),

                       decoration: InputDecoration(

                         errorStyle: TextStyle(color: Colors.red),

                         errorText: Unit_mstr_Select ? "Invalid Unit Selected" : null,

                         suffixIcon: IconButton(

                           icon: Icon(Icons.remove_circle),

                           color: Colors.blue,

                           onPressed: () {



                             print("cleared");

                             Unit_mstr_Controller.text = "";

                             //  salesPaymentId = 0;



                           },

                         ),

                         isDense: true,

                         contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 16.0),

                         border: OutlineInputBorder(

                             borderRadius: BorderRadius.circular(10.0)),

                         hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                         labelText: "Unit",

                       ),

                     ),

                     suggestionsBoxDecoration:

                     SuggestionsBoxDecoration(elevation: 90.0),

                     suggestionsCallback: (pattern) {

                       //                        print(payment);

                       return Unitlist.where((unt) => unt.toString().contains(pattern));

                     },

                     itemBuilder: (context, suggestion) {

                       return Card(

                         margin: EdgeInsets.all(2),

                         color: Colors.white,

                         child: ListTile(

                           tileColor: theam.DropDownClr,

                           title: Column(

                             children: [

                               Text(

                                 suggestion.description,

                                 style: TextStyle(color: Colors.white),

                               ),

                             ],

                           ),

                         ),

                       );

                     },

                     onSuggestionSelected: (suggestion) {

                       print(suggestion.description);

                       print("unit selected");



                       Unit_mstr_Controller.text = suggestion.description;

                       print("close.... $UnimstrtId");

                       UnimstrtId = 0;



                       print(suggestion.id);

                       print(".......GrpId id");

                       UnimstrtId = suggestion.id;

                       print(UnimstrtId);

                       print("...........");
                       ConversionText();
                     },

                     errorBuilder: (BuildContext context, Object? error) =>

                         Text(

                             '$error',

                             style: TextStyle(color: Theme

                                 .of(context)

                                 .errorColor)),

                     transitionBuilder:

                         (context, suggestionsBox, animationController) =>

                         FadeTransition(

                           child: suggestionsBox,

                           opacity: CurvedAnimation(

                               parent: animationController!,

                               curve: Curves.elasticIn),

                         )),

               ),



               Row(
                 children: [
                   Expanded(
                     child: Padding(
                       padding: const EdgeInsets.fromLTRB(8, 4, 8, 2),
                       child: TextFormField(
                         onChanged: (a) {

                           ConversionText();
                         },

                         style: TextStyle(fontSize: 15),

                         //showCursor: true,

                         controller: Conversion_Controller,
                         maxLength: 15,
                         cursorColor: Colors.black,

                         scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),

                         keyboardType: TextInputType.text,

                         decoration: InputDecoration( counterText: "",
                           errorStyle: TextStyle(color: Colors.red),
                           errorText: Conversion_Select == true ? "invalid " : null,
                           isDense: true,
                           contentPadding:
                           EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                           border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10.0)),
                           hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                           labelText: "Conversion",
                         ),
                       ),
                     ),
                   ),

                   Text("$convText       "),

                 ],
               ),
             ],),

           ),

        SizedBox(height: 10,),


//---tets---------
         FutureBuilder(
           initialData:GetUnit(),
           future: GetUnit(),
           builder: (context, snapshot) {
           return  Visibility(
               visible:TabelShow,
               child: SizedBox(height:Type_Controller.text=="Compound"?widget.Height/2.5:widget.Height/2,
                 child: SingleChildScrollView(
                   scrollDirection: Axis.horizontal,
                   child: SingleChildScrollView(
                     scrollDirection: Axis.vertical,
                     child: DataTable(
                       showCheckboxColumn: false,
                       columnSpacing: 18,
                       headingRowColor: theam.TableHeadRowClr,
                       onSelectAll: (b) {},
                       sortAscending: true,
                       columns: <DataColumn>[
                         DataColumn(
                           label: Text('Name',style: theam.TableFont,),
                         ),
                         DataColumn(
                           label: Text('Description',style: theam.TableFont,),
                         ),
                         DataColumn(
                           label: Text('Type',style: theam.TableFont,),
                         ),
                         DataColumn(
                           label: Text('Conversion',style: theam.TableFont,),
                         ),
                         DataColumn(
                           label: Text(''),
                         ),
                       ],
                       rows: unit.map((itemRow) =>DataRow(

                         onSelectChanged: (a){
                           print("itemRow.toString()");
                         },


                         cells: [
                           DataCell(
                             Text(itemRow.formalName=="null"?"---":itemRow.formalName),
                             showEditIcon: false,
                             placeholder: false,
                           ),
                           DataCell(
                             Text(itemRow.description??"---"),
                             showEditIcon: false,
                             placeholder: false,
                           ),
                           DataCell(
                             Text(itemRow.isSimple =="false"?"Simple":"Compound"),
                             showEditIcon: false,
                             placeholder: false,
                           ),
                           DataCell(
                             Text(itemRow.nos=="null"?"":itemRow.nos),
                             showEditIcon: false,
                             placeholder: false,
                           ),
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
                                           print(itemRow.formalName);
                                           Edit(itemRow);
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
                                           Delete(itemRow.id);

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
                       ).toList(),
                     ),
                   ),
                 ),
               ));
         },)



      ]),

       bottomNavigationBar:    Container(width: widget.Wedth,height: 80,
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
                 child: cw.CUButton(color: Colors.indigo,H: 50,name: "Cancel",W: 60,
                     Labelstyl: TextStyle(
                       fontSize: 30,
                       color: Colors.white
                     ),
                 function: (){

                   if(widget.Height==350.0){
                     Navigator.pop(context);
                   }
                   else{
                     Clear();
                   }

                 }),
               ),
             ),


           ],),
       )
       ,
       

     );
  }
}