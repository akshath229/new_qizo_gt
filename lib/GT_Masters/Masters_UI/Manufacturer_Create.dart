import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import '../AppTheam.dart';
import 'cuWidgets.dart';



class Create_Manufacturer extends StatefulWidget {
  double height;
  double width;
  dynamic token;
  dynamic device_id;
  dynamic User_id;
  dynamic branch_Id;
   bool TblShow;
  Create_Manufacturer({
    required this.height,
    required this.width,
    @required this.token,
    @required this.device_id,
    @required this.branch_Id,
    @required this.User_id,
    required this.TblShow,


  });

  @override
  _Create_ManufacturerState createState() => _Create_ManufacturerState();
}

class _Create_ManufacturerState extends State<Create_Manufacturer> {

  CUWidgets cw = CUWidgets();
  AppTheam theam =AppTheam();
  var SaveButtonText="Save";
  var  ManufacturerList=[];

  TextEditingController Manufacturer_Name_Controller = TextEditingController();
  TextEditingController Address_Controller = TextEditingController();
  TextEditingController Contact_Controller = TextEditingController();
  TextEditingController Country_Controller = TextEditingController();
  bool Manufacturer_Name_validation=false;

var Back_Clear_Button="Back";
int Edit_Id=0;

  bool TableShow=true;



  void initState() {
if(widget.height==350.0){
  setState(() {
    Back_Clear_Button="Back";
  });
}
else{
setState(() {
  Back_Clear_Button="Clear";
});}


setState(() {
  TableShow=widget.TblShow;
});


    Timer(Duration(seconds: 1), (){
      setState(() {
        GetManufacturer();
      });

    });
  }



  getItemIndex(dynamic item) {
    var index = ManufacturerList.indexOf(item);
    return index + 1;
  }




  //--------------Get Manufacturer------------------

  GetManufacturer() async {

    var jsonres = await cw.CUget_With_Parm(Token:widget.token, api: "MManufacturers", );

    if (jsonres != false) {
      var res = jsonDecode(jsonres);
      ManufacturerList = res as List;
      // print(ManufacturerList.toString());
      return ManufacturerList;
    }
    else{print("error "+jsonres.toString());}

  }




  //----------------------------validation---------------------------------------

  Validation(){

    if(Manufacturer_Name_Controller.text==""){

      setState(() {
        Manufacturer_Name_validation=true;

      });
    }else{

      if(SaveButtonText=="Save"){

        setState(() {
          Manufacturer_Name_validation=false;
          Savedata();
        });

      }else
        {
          setState(() {
            Manufacturer_Name_validation=false;
            EditSave();
          });

      }


    }
  }

  //----------------------------Save---------------------------------------




  Savedata()async{
    print("on save");

    var finaldata={
      "mfrId":0,
      "mfrAddress": Address_Controller.text,
      "mfrBranchId": widget.branch_Id,
      "mfrContactNo": Contact_Controller.text,
      "mfrContry": Country_Controller.text,
      "mfrDescription": Manufacturer_Name_Controller.text,
      "mfrUserId": widget.User_id,

    };
    var parm=jsonEncode(finaldata);
    print(parm);

    var res= await cw.post(api:"MManufacturers",body:parm,Token:widget.token,deviceId: widget.device_id,);
    if(res!=false && res.toString().contains("msg")) {
      // print("contains(msg)");
       var resmsg=jsonDecode(res);
      // print(resmsg.toString());
      // print(resmsg["msg"].toString());

       cw.MessagePopup(context,resmsg["msg"],Colors.red);
       return;

    }
    else if(res!=false){
      print(res.toString());
      print("success");
      cw.SavePopup(context);
      Clear();
    }else{
      print(res.toString());
      print("error");
      cw.FailePopup(context);

    }

  }

//-----------------------------------

Clear(){
    setState(() {
      Manufacturer_Name_Controller.text = "";
      Address_Controller.text = "";
      Contact_Controller.text = "";
      Country_Controller.text = "";
      Manufacturer_Name_validation=false;
      SaveButtonText="Save";
    });

}


//--------------------Edit----binding---------------------
  Edit(data){

    setState(() {
      SaveButtonText="Udate";
      Manufacturer_Name_Controller.text =data["mfrDescription"];
      Address_Controller.text =data["mfrAddress"];
      Contact_Controller.text =data["mfrContactNo"];
      Country_Controller.text =data["mfrContry"];
    });

  }




EditSave()async{

    print("on edit");
    print(Edit_Id.toString());
    var finaldata={
      "mfrId":Edit_Id,
      "mfrAddress":Address_Controller.text,
      "mfrBranchId": widget.branch_Id,
      "mfrContactNo":Contact_Controller.text,
      "mfrContry":Country_Controller.text,
      "mfrDescription":Manufacturer_Name_Controller.text,
      "mfrUserId": widget.User_id,

    };
    var parm=jsonEncode(finaldata);
    print(parm);


    var res=await cw.put(api:"MManufacturers/$Edit_Id",body:parm,Token:widget.token,deviceId: widget.device_id,);
    if(res!=false && res.toString().contains("msg")) {
      // print("contains(msg)");
      var resmsg=jsonDecode(res);
      // print(resmsg.toString());
      // print(resmsg["msg"].toString());

      cw.MessagePopup(context,resmsg["msg"],Colors.red);
      return;

    }
    else if(res!=false){
      print(res.toString());
      print("Updated");
      cw.UpdatePopup(context);
      Clear();
    }else{
      print(res.toString());
      print("error");
      cw.FailePopup(context);

    }
}




//--------------------Dalete-------------------------
  Delete(id) async{
    print(id.toString());
    print("on dalete");

    var res =await cw.delete(api: "MManufacturers/$id",
        deviceId: widget.device_id,
        Token: widget.token);

    if (res != false) {
      print(res.toString());
      print("daleted");
      cw.DeletePopup(context);
      Clear();
    } else {
      print(res.toString());
      print("error");
      cw.FailePopup(context);
    }
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
                          controllerName: Manufacturer_Name_Controller,
                          label: "Manufacturer Name",
                          errorcontroller:Manufacturer_Name_validation,
                        ),
                      ),
                    ),

                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: cw.CUTestbox(
                    controllerName: Address_Controller,
                    label: "Address",
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: cw.CUTestbox(
                    controllerName: Contact_Controller,
                    label: "Contact No",

                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: cw.CUTestbox(
                    controllerName: Country_Controller,
                    label: "Country",
                  ),
                ),


                Visibility(visible: TableShow,
                  child: FutureBuilder(
                    future: GetManufacturer(),
                    builder: (context, snapshot) {
                       // print("iuyi");
                       // print(snapshot.data.toString());
                       // print(snapshot.connectionState.toString());

                       if(snapshot.data.toString()=="null"||snapshot.data==[]) {
                         return Center(child: Text("No Data!"));
                       }
                       else if(snapshot.connectionState.toString()=="ConnectionState.waiting") {
                         return Center(child: Text("Loading...."));
                       }
                       return
                       SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 20,
                          headingRowColor: theam.TableHeadRowClr,
                          onSelectAll: (b) {},
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
                            //   label: Text('Address'),
                            // ),
                            DataColumn(
                              label: Text('Contact No ',style: theam.TableFont,),
                            ),
                            // DataColumn(
                            //   label: Text('Country '),
                            // ),
                            DataColumn(
                              label: Text(''),
                            ),

                          ],
                          rows: ManufacturerList
                              .map(
                                (itemRow) => DataRow(
                              cells: [
                                DataCell(
                                  Text(getItemIndex(itemRow).toString()),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(itemRow["mfrDescription"].toString()=="null"?"--":itemRow["mfrDescription"]),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),


                                // DataCell(
                                //   Text(itemRow["mfrAddress"].toString()=="null"?"--":itemRow["mfrAddress"]),
                                //   showEditIcon: false,
                                //   placeholder: false,
                                // ),
                                DataCell(
                                  Text(itemRow["mfrContactNo"].toString()=="null"?"--":itemRow["mfrContactNo"]),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                // DataCell(
                                //   Text(itemRow["mfrContry"].toString()=="null"?"--":itemRow["mfrContry"]),
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
                                                setState(() {
                                                  Edit_Id=itemRow["mfrId"];
                                                });
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
                                                Delete(itemRow["mfrId"]);

                                              },


                                            )
                                          ],),
                                        ),)
                                    ],
                                    icon: Icon(Icons.more_horiz),
                                    //offset: Offset()
                                  ), showEditIcon: false,
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
                    padding: const EdgeInsets.fromLTRB(8, 8, 4, 1),
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
                    padding: const EdgeInsets.fromLTRB(4, 8, 8, 1),
                    child: cw.CUButton(color: Colors.indigo,H: 50,name: Back_Clear_Button,W: 60,
                        Labelstyl: TextStyle(
                          fontSize: 30,
                          color: Colors.white
                        ),
                        function: (){

                          if(widget.height==350.0){
                            Navigator.pop(context);
                          }
                          else{
                            Clear();
                          }

                        }),
                  ),
                ),


              ],),
          ),

        ));
  }
}
