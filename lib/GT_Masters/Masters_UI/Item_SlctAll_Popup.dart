import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import '../../models/finishedgoods.dart';
import '../AppTheam.dart';


class Itm_Slct_All_Popup extends StatefulWidget {
  List<dynamic> data;

  Itm_Slct_All_Popup({required this.data});
  @override
  _Itm_Slct_All_PopupState createState() => _Itm_Slct_All_PopupState();
}
class _Itm_Slct_All_PopupState extends State<Itm_Slct_All_Popup> {

  AppTheam theam =AppTheam();

  initState() {
    SelectedRowData = [];
    goods = widget.data;
  }



  bool tblSlctd=true;
  late List <FinishedGoods> goods;
 var SelectedRowData;

  var slnum=0;
  TextEditingController QtyController = new TextEditingController();



  SelectedRows(bool stsus,FinishedGoods data)async{

      if (stsus) {

        showDialog(
            context: context,
            builder: (context) =>   AlertDialog(
              shape:RoundedRectangleBorder(
                side: BorderSide(color:  Colors.blueAccent, width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
              title: Center(child: Text(data.itmName)),
              content:   Container(
                width: 100,
                height: 30,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        autofocus: true,
                        controller:QtyController,
                        onFieldSubmitted: (val)  {
                          print('onSubmited $val');
                        },
                        // focusNode: generalFocus,
                        enabled: true,
                        validator: (v) {
                          if (v!.isEmpty) return "Required";
                          return null;
                        },
//
//                  focusNode: field1FocusNode,
                        cursorColor: Colors.black,

                        scrollPadding:
                        EdgeInsets.fromLTRB(0, 20, 20, 0),
                        keyboardType: TextInputType.text,

                        decoration: InputDecoration(
//                    suffixIcon: Icon(
//                      Icons.calendar_today,
//                      color: Colors.blue,
//                      size: 24,
//                    ),
                          isDense: true,
                          contentPadding: EdgeInsets.all(8),
                          // border: OutlineInputBorder(
                          //     borderRadius: BorderRadius.circular(10)),
                          // curve brackets object
                          hintText: "Quantity",
                          hintStyle: TextStyle(
                              color: Colors.black, fontSize: 15),
                        ),
                      ),
                    ),
                    SizedBox(width: 5,),
                    ElevatedButton(onPressed: (){
                      setState(() {
                        SelectedRowData.add(data);
                       // ItemPushToArray(data,QtyController.text);
                        Navigator.of(context, rootNavigator: true).pop();
                        QtyController.text="";

                      });
                    }, child: Text("OK"))
                  ],
                ),
              ),


            ));




      }

      else {

        setState(() {
          SelectedRowData.remove(data);
        });

      }











  }


  ItemPushToArray(FinishedGoods data,qty){

    var json={
           "id" :data.id,
          "itmName" :data.itmName,
           "qty":qty,
          "itmImage" :data.itmImage,
          "itmUserId" :data.itmUserId,
          "itmBranchId":data.itmBranchId,
          "txPercentage" :data.txPercentage,
          "atPercentage" :data.atPercentage,
          "description" :data.description,
          "itmHsn" :data.itmHsn,
          "unitId":data.unitId,
          "itmUnitId":data.itmUnitId,
          "txCgstPercentage":data.txCgstPercentage,
          "txSgstPercentage":data.txSgstPercentage,
          "txIgstpercentage" :data.txIgstpercentage,
          "itmTaxId" :data.itmTaxId,
          "itmSalesRate" :data.itmSalesRate
    };


    SelectedRowData.add(json);

  }


var Selectedrow=[];

  ///------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(color: Colors.white,
                  height: MediaQuery.of(context).size.width/1.2,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columnSpacing: 14,
                        onSelectAll: (b) { },
                        sortAscending: true,
                        columns: <DataColumn>[
                          DataColumn(
                            label: Text('Name'),
                          ),
                          // DataColumn(
                          //   label: Text('Qty'),
                          // ),
                          DataColumn(
                            label: Text('Rate'),
                          ),
                        ],
                        rows: widget.data
                            .map(
                              (itemRow)=>

                                  DataRow(
                          selected:SelectedRowData.contains(itemRow),
                          color:MaterialStateColor.resolveWith(
                                (states) {

                                  if (SelectedRowData.contains(itemRow)) {
                                return Colors.teal;
                              } else {
                                return Colors.white;
                              }
                                  setState(() {  });
                            },

                          ),

                          onSelectChanged: (bool? selected) {
                           // print(itemRow.index);
                           SelectedRows(selected!, itemRow);
                          },

                          cells: [
                            DataCell(
                              Container(
                                width: 150,
                                child: Text('${itemRow.itmName.toString()}'),
                              ),
                              showEditIcon: false,
                              placeholder: false,
                            ),
//                         DataCell(
//                           Container(
//                             width: 70,
//                             height: 50,
//                             child: Padding(
//                               padding: const EdgeInsets.all(2),
//                               child: TextFormField(
//                                 controller:TextEditingController(),
//                                 onFieldSubmitted: (val)  {
//                                   print('onSubmited $val');
//                                 },
//                                 // focusNode: generalFocus,
//                                 enabled: true,
//                                 validator: (v) {
//                                   if (v.isEmpty) return "Required";
//                                   return null;
//                                 },
// //
// //                  focusNode: field1FocusNode,
//                                 cursorColor: Colors.black,
//
//                                 scrollPadding:
//                                     EdgeInsets.fromLTRB(0, 20, 20, 0),
//                                 keyboardType: TextInputType.text,
//
//                                 decoration: InputDecoration(
// //                    suffixIcon: Icon(
// //                      Icons.calendar_today,
// //                      color: Colors.blue,
// //                      size: 24,
// //                    ),
//                                   isDense: true,
//                                   contentPadding: EdgeInsets.all(8),
//                                   // border: OutlineInputBorder(
//                                   //     borderRadius: BorderRadius.circular(10)),
//                                   // curve brackets object
//                                   hintText: "Qty",
//                                   hintStyle: TextStyle(
//                                       color: Colors.black, fontSize: 15),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           showEditIcon: false,
//                           placeholder: false,
//                         ),
                            DataCell(
                              Text('${itemRow.itmSalesRate.toString()}'),
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
            ),
        Container(height: 50,width: MediaQuery.of(context).size.width,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left:2,right: 2),
                child: ElevatedButton(
                  style:ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.green.shade700), ) ,
                    onPressed: (){
                    if(SelectedRowData.length<1){

                      showDialog(
                        barrierDismissible: false,
                          context: context,
                          builder: (context) =>   AlertDialog(
                          shape:RoundedRectangleBorder(
                          side: BorderSide(color:  Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(20),
                      ),
                      title: Center(child: Text("Add Item...!")),));


                    Timer(Duration(milliseconds:1200),() {
                      Navigator.of(context, rootNavigator: true).pop();
                    });
                    return;
                    }else{
                      Navigator.pop(context, SelectedRowData) ;
                      return SelectedRowData;
                    }
                    },

                    child: Text("Add to Cart")),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left:2,right: 2),
                child: ElevatedButton(
                    style:ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo), ) ,
                    onPressed: (){
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: Text("Cancel")),
              ),
            ),

            Container(height: 30,width: 30,
                decoration: BoxDecoration(color: Colors.teal,
                    borderRadius: BorderRadius.circular(20)),
                child:Center(child: Text(SelectedRowData.length.toString())))
          ],
        ),)
      ],
    );


  }
}
