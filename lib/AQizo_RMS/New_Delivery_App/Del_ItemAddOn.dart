import 'dart:convert';
import 'dart:ui';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../GT_Masters/AppTheam.dart';
import '../../urlEnvironment/urlEnvironment.dart';
import 'Del_Model/Del_Model_AddonItms.dart';

class ItemAddon {
  static List<Del_AddonItems> _Del_Addons = new List<Del_AddonItems>();

  late Del_AddonItems Del_AddonDatas;
  AppTheam theam = AppTheam();

  TextEditingController ItemNotesController = new TextEditingController();

  var ItemNotes_Id = null;

// var   AddonData=[];

// [
//   {"name":"pepsi","Rate":"40"},
//   {"name":"FrechFries","Rate":"30"},
//   {"name":"meals","Rate":"50"},
//   ];

  bool ShowAddon = false;
  int Item_qty = 1;
  int Addon_qty = 1;
  bool ShowAddonSelcted = false;
  var selectedIndexes = [];
  bool AddToCart = false;
  var  Selected_AddonDatas = [];
  var SelectedUOM = null;
  var tappedIndex = null;
  bool _isDining = true;
  bool _IsImage = true;

  bool SelectNoteChkBx = false;
  var SelectedNoteIndex = [];
  var Selected_Notes_Data = [];

// var qtyarray=[{"qty":1},{"qty":1,},{"qty":1,}];

  initialFuntion(context, List<dynamic> UomData, itemname, itm_id, image, token,
      BillingNote, ImgOrTxt, currencyName, Map<String, bool> values, bool showAddonItems) async {
    _IsImage = ImgOrTxt;
    ShowAddon = false;
    Item_qty = 1;
    ShowAddonSelcted = false;
    AddToCart = false;
    selectedIndexes = [];
    Selected_AddonDatas = [];
    SelectedUOM = null;
    tappedIndex = null;
    _Del_Addons.clear();
    ItemNotesController.text = "";
    ItemNotes_Id = null;
    SelectedNoteIndex = [];
    Selected_Notes_Data = [];
    // qtyarray=[{"qty":1},{"qty":1,},{"qty":1,}];
    var s = await GetItemAddons(token, itm_id, showAddonItems);
    await AddItemPopup(context, UomData, itemname, image, BillingNote, currencyName, showAddonItems);
    print("s " + s.toString());
    if (AddToCart == true && SelectedUOM != null) {
      // print(json.encode(_Del_Addons));
      // Selected_AddonDatas.add(_Del_Addons.)
      var Slct_Notes = getSelected_Notes(BillingNote);
      _Del_Addons.forEach((element) {
        if (element.qty > 0) {
          Selected_AddonDatas.add(element);
        }
      });

      return [
        {
          "data": SelectedUOM,
          "Qty": Item_qty,
          "AddonData": Selected_AddonDatas,
          "Notes": Slct_Notes
          // "Cust_Ph":Ph_NumberController.text,"Address":Address_Controller.text
        }
      ];
    }
    return null;
  }

  getSelected_Notes(BillingNote) {
    if (SelectedNoteIndex.length > 0) {
      for (int i = 0; i < SelectedNoteIndex.length; i++) {
        Selected_Notes_Data.add(BillingNote[SelectedNoteIndex[i]]);
      }

      return Selected_Notes_Data;
    } else {
      return Selected_Notes_Data;
    }
  }

  GetItemAddons(token, id, bool showAddonItems) async {
    print(id.toString());
  //  final res = await http.get("${Env.baseUrl}RelitemAddons/$id/1", headers: {
 //   final res = await http.get("${Env.baseUrl}GtitemMasters/1/addon", headers: {
    final res = await http.get("${Env.baseUrl}GtitemMasters/$id/addonItem" as Uri, headers: {
      "Authorization": token,
    });

    print("res");
    print(res.body);
    print(res.statusCode);

    if (res.statusCode == 200) {
      var resAddon = json.decode(res.body);

      if (resAddon["relItemAddOn"].toString() == "[]") {
        print("No add on items");
      } else {
        print( "relItemAddOn " +resAddon["relItemAddOn"].toString());
        var s = [];
        s = resAddon["relItemAddOn"];
        print(s.length);

        for (int i = 0; i < s.length; i++) {
          print(s[i]["itemName"]);
          Del_AddonDatas = Del_AddonItems(
              id: s[i]["id"],
              itemName: s[i]["itemName"],
              mainItemId: s[i]["mainItemId"],
              addOnitemId: s[i]["addOnitemId"],
              addonItemName: s[i]["addonItemName"],
              isActive: s[i]["isActive"],
              addonRate: s[i]["addonRate"],
              qty: 0);

          print("addo on datas");
          _Del_Addons.add(Del_AddonDatas);
        }
        print(_Del_Addons);
      }
    }
  }

  AddItemPopup(context, List<dynamic> UomData, itemname, image, BillingNote,
      currencyTyp, activeAddonItems) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {

            ///.........................................................................
            return AlertDialog(
              title: Row(
                children: [
                  Text(itemname),
                  //Spacer(),
                  // Visibility(
                  //   visible:activeAddonItems == true,
                  //   // child: ElevatedButton(
                  //   //     child: Text(
                  //   //       "Add",
                  //   //       style: TextStyle(color: Colors.black, fontSize: 20),
                  //   //     ),
                  //   //     onPressed: () {
                  //   //       if (SelectedUOM == null) {
                  //   //         showDialog(
                  //   //             context: context,
                  //   //             builder: (context) {
                  //   //               return StatefulBuilder(
                  //   //                   builder: (context, setState) {
                  //   //                 return AlertDialog(actions: [
                  //   //                   Container(
                  //   //                     height: 30,
                  //   //                     width: 300,
                  //   //                     child: Center(
                  //   //                         child: Text(
                  //   //                       "UOM is Undefined..!" ,
                  //   //                       style: TextStyle(
                  //   //                           color: Colors.red, fontSize: 20),
                  //   //                     )),
                  //   //                   )
                  //   //                 ]);
                  //   //               });
                  //   //             });
                  //   //         return;
                  //   //       } else {
                  //   //         setState(() {
                  //   //           print(activeAddonItems);
                  //   //           AddToCart = true;
                  //   //           print("oipio");
                  //   //           Navigator.of(context).pop();
                  //   //         });
                  //   //       }
                  //   //     }),
                  // ),
                ],
              ),
              // backgroundColor: Colors.pink.shade100,
              actions: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(

                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: SizedBox(),
                            ),

                          ],
                        ),

                        ///---------------------------------------------------
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.5 - 60,
                          child: Column(
                            children: [
                              UomData.length == 0
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 10),
                                      child: Text(
                                        "UOM Not Found..!",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 20,
                                        ),
                                      ))
                                  : SizedBox(
                                      height: 250,
                                      width: 220,
                                child: Column(
                                  children: [
                                       ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: UomData.length,
                                        itemBuilder: (context, index) =>
                                            UomButtons(
                                                setState,
                                                index,
                                                UomData[index],
                                                UomData[index]["description"],
                                                UomData[index]["mrp"],
                                                currencyTyp),
                                      ),
                                  SizedBox(
                                      height: 15,
                                  ),
                                    Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(color: Colors.blueAccent),
                                            borderRadius: BorderRadius.circular(30)),
                                        height: 50,
                                        width: 160,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                                icon: Icon(Icons.remove, color: Colors.red, size: 40.0),
                                                onPressed: () {
                                                  setState(() {
                                                    --Item_qty;
                                                    if (Item_qty < 1) {
                                                      Item_qty = 1;
                                                    }
                                                  });
                                                }),
                                            Text("  " + Item_qty.toString() + " ", style: TextStyle(fontSize: 30.0),),
                                            IconButton(
                                                icon: Icon(Icons.add, color: Colors.green, size: 40.0),
                                                onPressed: () {
                                                  setState(() {
                                                    ++Item_qty;
                                                  });
                                                }),
                                          ],
                                        )
                                    )


                                ]
                                )

                                    ),
                            ],

                          ),
                        ),
                        Visibility(
                          visible: _Del_Addons.length > 0 && activeAddonItems == true,
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("  Add On +", style: TextStyle(fontSize: 20, color: Colors.green),),
                                         SizedBox(
                                            width: ShowAddon == true
                                                   ? MediaQuery.of(context).size.width / 2 : 350,
                                          height: 300,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: _Del_Addons.length,
                                            itemBuilder: (context, index) =>
                                                Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Checkbox(
                                                  value: selectedIndexes.contains(index),
                                                  onChanged: (_) {
                                                    setState(() {
                                                     // Selected_AddonDatas.clear();
                                                      if (selectedIndexes.contains(index))
                                                      {
                                                        print("unselect");
                                                        selectedIndexes.remove(index);// unselect
                                                        _Del_Addons[index].qty =  0;
                                                      } else {
                                                        selectedIndexes.add(index); // select
                                                       _Del_Addons[index].qty =  1;

                                                      }

                                                      // selectedIndexes.forEach((element) {
                                                      //
                                                      //  print(_Del_Addons[element].addonItemName) ;
                                                      //  Selected_AddonDatas.add(_Del_Addons[element]);
                                                      //  });
                                                    });
                                                    print(
                                                        "Selected_AddonDatas");
                                                    print(Selected_AddonDatas);
                                                  },
                                                ),
                                                Expanded(
                                                    child: Text(
                                                        _Del_Addons[index]
                                                            .addonItemName)),
                                                Expanded(
                                                    child: Text(
                                                        "$currencyTyp ${_Del_Addons[index].addonRate.toString() == null ? "xx" : _Del_Addons[index].addonRate.toString()}")),
                                                selectedIndexes.contains(index)
                                                    ? Add_Qty_Counter(
                                                        setState, index, 1)
                                                    : SizedBox(
                                                        height: 30,
                                                      ),
                                              ],
                                          //  ),
                                          ),
                                        )),
                               ]
                          )
                               //   ]
                        ),
                      ],
                    ),
                    ///------------------------------Notes--------------------------
                   Row(
                     children: [Text("  Notes", style: TextStyle(fontSize: 20, color: Colors.red),)],
                   ),
                    Container(

                      width: MediaQuery.of(context).size.width,
                      height: 260,
                      child:GridView.count(
                      // Create a grid with 2 columns. If you change the scrollDirection to
                      // horizontal, this produces 2 rows.
                      crossAxisCount: 4, childAspectRatio: 3,
                      // Generate 100 widgets that display their index in the List.
                      children: List.generate(BillingNote.length, (index) {
                        return Center(
                         child:
                             Row(
                             mainAxisAlignment: MainAxisAlignment.start,
                             children: [

                               Checkbox(
                                 value: SelectedNoteIndex.contains(index),
                                 onChanged: (_) {
                                   setState(() {

                                     if (SelectedNoteIndex.contains(index)) {
                                       SelectedNoteIndex.remove(index);
                                     } else {
                                       SelectedNoteIndex.add(index);
                                     }
                                   });
                                 },
                               ),
                               Text(
                                 BillingNote[index]["notes"].toString() + "   ",
                                 style: TextStyle(fontSize: 17, color: Colors.lightGreen[900]),
                               ),
                             ]));
                      }),
                    ),),

            //         Container(
            //           width: MediaQuery.of(context).size.width,
            //           height: 250,
            //           child:GridView.count(
            //             crossAxisCount: 2,
            //             children:[ ListView.builder(
            //             shrinkWrap: true,
            //             scrollDirection: Axis.horizontal,
            //             itemCount: BillingNote.length,
            //             itemBuilder: (context, index) =>
            //                 Row(
            //               mainAxisAlignment: MainAxisAlignment.start,
            //               children: [
            //
            //                 Checkbox(
            //                   value: SelectedNoteIndex.contains(index),
            //                   onChanged: (_) {
            //                     setState(() {
            //
            //                       if (SelectedNoteIndex.contains(index)) {
            //                         SelectedNoteIndex.remove(index);
            //                       } else {
            //                         SelectedNoteIndex.add(index);
            //                       }
            //                     });
            //                   },
            //                 ),
            //                 Text(
            //                   BillingNote[index]["notes"].toString() + "   ",
            //                   style: TextStyle(fontSize: 17, color: Colors.lightGreen[900]),
            //                 ),
            // ])
            //
            //           ),
            //           ])
            //
            //         ),

                    Center(
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                       children: [

                        // SizedBox(width: MediaQuery.of(context).size.width/2,
                        //   child: Row(
                        //     children: [
                        //       Expanded(
                        //         child: TypeAheadField(
                        //             suggestionsBoxVerticalOffset: 50,
                        //
                        //             direction:AxisDirection.up,
                        //             textFieldConfiguration: TextFieldConfiguration(
                        //                 style: TextStyle(),
                        //                 controller: ItemNotesController,
                        //                 decoration: InputDecoration(
                        //                   errorStyle: TextStyle(color: Colors.red),
                        //                   // errorText: itemSelect
                        //                   //     ? "Please Select product Item ?"
                        //                   //     : null,
                        //                   suffixIcon: IconButton(
                        //                     icon: Icon(Icons.remove_circle),
                        //                     color: Colors.blue,
                        //                     onPressed: () {
                        //                       setState(() {
                        //                         print("cleared");
                        //                         ItemNotesController.text = "";
                        //                         ItemNotes_Id = null;
                        //
                        //                       });
                        //                     },
                        //                   ),
                        //
                        //
                        //
                        //                   isDense: true,
                        //                   contentPadding:
                        //                   EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        //                   border: OutlineInputBorder(
                        //                       borderRadius: BorderRadius.circular(10)),
                        //                   // i need very low size height
                        //                   labelText:
                        //                   'Item Notes', // i need to decrease height
                        //                 )),
                        //             suggestionsBoxDecoration:
                        //             SuggestionsBoxDecoration(elevation: 90.0),
                        //             suggestionsCallback: (pattern) {
                        //               return BillingNote.where((user) =>
                        //                   user["notes"].toString().trim().toLowerCase().contains(pattern.trim().toLowerCase()));
                        //             },
                        //             itemBuilder: (context, suggestion) {
                        //               return Card(elevation: 0,
                        //                 color: Colors.blue,
                        //                 // shadowColor: Colors.blue,
                        //                 child: ListTile(
                        //                   tileColor: theam.DropDownClr,
                        //                   title: Text(
                        //                     suggestion["notes"],
                        //                     style: TextStyle(color: Colors.white),
                        //                   ),
                        //                 ),
                        //               );
                        //             },
                        //             onSuggestionSelected: (suggestion) {
                        //               print(suggestion["notes"]);
                        //               print("selected");
                        //               ItemNotesController.text=suggestion["notes"];
                        //               //  print(salesItemId);
                        //               print("...........");
                        //
                        //             },
                        //             errorBuilder: (BuildContext context, Object error) =>
                        //                 Text('$error',
                        //                     style: TextStyle(
                        //                         color: Theme.of(context).errorColor)),
                        //             transitionBuilder:
                        //                 (context, suggestionsBox, animationController) =>
                        //                 FadeTransition(
                        //                   child: suggestionsBox,
                        //                   opacity: CurvedAnimation(
                        //                       parent: animationController,
                        //                       curve: Curves.elasticIn),
                        //                 )),
                        //       ),
                        //
                        //
                        //
                        //     ],
                        //   ),
                        // ),

                        // SizedBox(
                        //   width: 10,
                        // ),

                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.green.shade800)),
                            child: Text(
                              "Add",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () {
                              print("Add pressed hyder");
                              if (SelectedUOM == null) {
                                print("selected UOM NULL hyder");
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(
                                          builder: (context, setState) {
                                        return AlertDialog(actions: [
                                          Container(
                                            height: 30,
                                            width: 300,
                                            child: Center(
                                                child: Text(
                                              "UOM is Undefined..!",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 20),
                                            )),
                                          )
                                        ]);
                                      });
                                    });
                                return;
                              } else {


                                print("have UOM hyder");
                                setState(() {
                                //  print(activeAddonItems.toString());
                                  AddToCart = true;
                                  print("oipio");
                                  Navigator.of(context).pop();
                                });
                              }
                            }),
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.red.shade400)),
                            child: Text(
                              "Cancel",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ))
                      ],
                    )
                    )
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Add_Qty_Counter(StateSetter setState, int index, qty) {
    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: Container(
          color: Colors.amber.shade600,
          // decoration: BoxDecoration(
          //     color: Colors.teal, borderRadius: BorderRadius.circular(30)),
          width: 100,
          height: 30,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                  onTap: () {
                    setState(() {
                      if (selectedIndexes.contains(index)) {
                        var s = _Del_Addons[index].qty;
                        _Del_Addons[index].qty = --s;
                        print("qty");
                        print(_Del_Addons[index].qty.toString());
                        --qty;
                        if (_Del_Addons[index].qty < 1) {
                          _Del_Addons[index].qty = 1;
                        } // unselect
                      }
                    });
                  },
                  child: Icon(
                    Icons.remove,
                    color: Colors.black,
                  )),
              Text(
                _Del_Addons[index].qty.toString(),
                style: TextStyle(color: Colors.black),
              ),
              InkWell(
                child: Icon(Icons.add, color: Colors.black),
                onTap: () {
                  if (selectedIndexes.contains(index)) {
                    setState(() {
                      var s = _Del_Addons[index].qty;

                      _Del_Addons[index].qty = s == null ? 0 : ++s;
                    });
                  }
                },
              ),
            ],
          )),
    );
  }

  Widget UomButtons(setState, index, Uom, UomName, rate, currencytyp) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () {
          print("Selected UOM");
          print(Uom);
          // var s= List<dynamic>.filled(1, Uom);
          SelectedUOM = Uom;
          print(SelectedUOM);
          print(SelectedUOM.runtimeType);
          setState(() {
            tappedIndex = index;
          });
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              color: tappedIndex == index ? Colors.green[100] : Colors.white,
              borderRadius: BorderRadius.circular(20)),
          width: 120,
          height: 50,
          child: Center(
              child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text: " " + UomName,
                    style: TextStyle(fontSize: 17, color: Colors.black)),
                TextSpan(text: "   $currencytyp",
                    style: TextStyle(color:Colors.black)),
                TextSpan(
                    text: '  ${rate.toString()}',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color:Colors.black)),
              ],
            ),
          )),
        ),
      ),
    );
  }
}


// import 'dart:convert';
// import 'dart:ui';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_app/AQizo_RMS/New_Delivery_App/Del_Model/Del_Model_AddonItms.dart';
// import 'package:flutter_app/GT_Masters/AppTheam.dart';
// import 'package:flutter_app/urlEnvironment/urlEnvironment.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
//
// class ItemAddon {
//   static List<Del_AddonItems> _Del_Addons = new List<Del_AddonItems>();
//   Del_AddonItems Del_AddonDatas;
//   AppTheam theam = AppTheam();
//
//   TextEditingController ItemNotesController = new TextEditingController();
//
//   var ItemNotes_Id = null;
//   bool ShowAddon = false;
//   int Item_qty = 1;
//   int Addon_qty = 1;
//   bool ShowAddonSelcted = false;
//   var selectedIndexes = [];
//   bool AddToCart = false;
//   var Selected_AddonDatas = [];
//   var SelectedUOM = null;
//   var tappedIndex = null;
//   bool _isDining = true;
//   bool _IsImage = true;
//
//   bool SelectNoteChkBx = false;
//   var SelectedNoteIndex = [];
//   var Selected_Notes_Data = [];
//
//
// // var qtyarray=[{"qty":1},{"qty":1,},{"qty":1,}];
//
//   initialFuntion(context, List<dynamic> UomData, itemname, itm_id, image, token,
//       BillingNote, ImgOrTxt, currency, Map<String, bool> values, activeAddonItems) async {
//     _IsImage = ImgOrTxt;
//     ShowAddon = false;
//     Item_qty = 1;
//     ShowAddonSelcted = false;
//     AddToCart = false;
//     selectedIndexes = [];
//     Selected_AddonDatas = [];
//     SelectedUOM = null;
//     tappedIndex = null;
//     _Del_Addons.clear();
//     ItemNotesController.text = "";
//     ItemNotes_Id = null;
//     SelectedNoteIndex = [];
//     Selected_Notes_Data = [];
//     // qtyarray=[{"qty":1},{"qty":1,},{"qty":1,}];
//     var s = await GetItemAddons(token, itm_id,activeAddonItems);
//     await AddItemPopup(
//         context, UomData, itemname, image, BillingNote, currency, activeAddonItems);
//     if (AddToCart == true && SelectedUOM != null) {
//      //  print(json.encode(_Del_Addons));
//       //Selected_AddonDatas.add(_Del_Addons.toList());
//       print("billong notes new");
//       print(BillingNote);
//       print(Selected_AddonDatas);
//       var Slct_Notes = getSelected_Notes(BillingNote);
//
//       _Del_Addons.forEach((element) {
//         if (element.qty < 0) {
//           Selected_AddonDatas.add(element);
//         }
//       });
//
//       return [
//         {
//           "data": SelectedUOM,
//           "Qty": Item_qty,
//           "AddonData": Selected_AddonDatas,
//           "Notes": Slct_Notes
//           // "Cust_Ph":Ph_NumberController.text,"Address":Address_Controller.text
//         }
//       ];
//     }
//     return null;
//   }
//
//   getSelected_Notes(BillingNote) {
//     if (SelectedNoteIndex.length > 0) {
//       for (int i = 0; i < SelectedNoteIndex.length; i++) {
//         Selected_Notes_Data.add(BillingNote[SelectedNoteIndex[i]]);
//       }
//
//       return Selected_Notes_Data;
//     } else {
//       return Selected_Notes_Data;
//     }
//   }
//
//   GetItemAddons(token, id,showAddonItemsList) async {
//
//     // final res = await http.get("${Env.baseUrl}RelitemAddons/$id/1", headers: {
//     final res = await http.get("${Env.baseUrl}GtitemMasters/1/addon", headers: {
//       "Authorization": token,
//     });
//     print ("addon item list" + showAddonItemsList.toString());
//     print("res");
//     print(res.body);
//     print(res.statusCode);
//
//     if (res.statusCode == 200) {
//       var resAddon = json.decode(res.body);
//
//       if (resAddon["relItemAddOn"].toString() == "[]") {
//         print("No add on items");
//       } else {
//         print("rel itemaddon");
//         print(resAddon["relItemAddOn"]);
//         var s = [];
//         s = resAddon["relItemAddOn"];
//         print(s.length);
//
//         for (int i = 0; i < s.length; i++) {
//           print(s[i]["itemName"]);
//           print(s[i]["mainItemId"]);
//           print(s[i]["maintItemUomId"]);
//           print(s[i]["addonItemName"]);
//           print(s[i]["addonRate"]);
//           print(s[i]["qty"]);
//
//           Del_AddonDatas =Del_AddonItems(
//               id: s[i]["id"],
//               itemName: s[i]["itemName"],
//               mainItemId: s[i]["maintItemUomId"],
//               addOnitemId: s[i]["addOnitemId"],
//               addonItemName: s[i]["addonItemName"],
//               isActive: s[i]["isActive"],
//               addonRate: s[i]["addonRate"],
//                qty: 0
//               );
//           print(Del_AddonItems(id: s[1]["id"],
//             itemName: s[1]["itemName"],
//             mainItemId: s[1]["maintItemUomId"],
//             addOnitemId: s[1]["addOnitemId"],
//             addonItemName: s[1]["addonItemName"],
//             isActive: s[1]["isActive"],
//             addonRate: s[1]["addonRate"],
//               qty: 1
//           ));
//           print("addo on datas");
//           _Del_Addons.add(Del_AddonDatas);
//           print(_Del_Addons);
//         }
//         print(_Del_Addons);
//       }
//     }
//   }
//
//
//   AddItemPopup(context, List<dynamic> UomData, itemname, image, BillingNote,
//       currencyTyp, activeAddonItems) {
//     return showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//
//             ///.........................................................................
//             return AlertDialog(
//               title: Row(
//                 children: [
//                   Text(itemname),
//                   Spacer(),
//                   Visibility(
//                     visible:activeAddonItems == true,
//                     child: ElevatedButton(
//                         child: Text(
//                           "Add",
//                           style: TextStyle(color: Colors.black, fontSize: 20),
//                         ),
//                         onPressed: () {
//                           if (SelectedUOM == null) {
//                             showDialog(
//                                 context: context,
//                                 builder: (context) {
//                                   return StatefulBuilder(
//                                       builder: (context, setState) {
//                                     return AlertDialog(actions: [
//                                       Container(
//                                         height: 30,
//                                         width: 300,
//                                         child: Center(
//                                             child: Text(
//                                           "UOM is Undefined..!" ,
//                                           style: TextStyle(
//                                               color: Colors.red, fontSize: 20),
//                                         )),
//                                       )
//                                     ]);
//                                   });
//                                 });
//                             return;
//                           } else {
//                             setState(() {
//                               print(activeAddonItems);
//                               AddToCart = true;
//                               print("oipio");
//                               Navigator.of(context).pop();
//                             });
//                           }
//                         }),
//                   ),
//                 ],
//               ),
//               // backgroundColor: Colors.pink.shade100,
//               actions: [
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   // mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Row(
//
//                       crossAxisAlignment: CrossAxisAlignment.start,
//
//                       children: [
//                         Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(2.0),
//                               child: SizedBox(),
//                             ),
//
//                           ],
//                         ),
//
//                         ///---------------------------------------------------
//                         SizedBox(
//                           width: MediaQuery.of(context).size.width / 2.5 - 100,
//                           child: Column(
//                             children: [
//                               UomData.length == 0
//                                   ? Padding(
//                                       padding: const EdgeInsets.only(
//                                           top: 10, bottom: 10),
//                                       child: Text(
//                                         "UOM Not Found..!",
//                                         style: TextStyle(
//                                           color: Colors.red,
//                                           fontSize: 20,
//                                         ),
//                                       ))
//                                   : SizedBox(
//                                       height: 250,
//                                       width: 200,
//                                 child: Column(
//                                   children: [
//                                        ListView.builder(
//                                         shrinkWrap: true,
//                                         itemCount: UomData.length,
//                                         itemBuilder: (context, index) =>
//                                             UomButtons(
//                                                 setState,
//                                                 index,
//                                                 UomData[index],
//                                                 UomData[index]["description"],
//                                                 UomData[index]["mrp"],
//                                                 currencyTyp),
//                                       ),
//                                   SizedBox(
//                                       height: 15,
//                                   ),
//                                     Container(
//                                         decoration: BoxDecoration(
//                                             border: Border.all(color: Colors.blueAccent),
//                                             borderRadius: BorderRadius.circular(30)),
//                                         height: 50,
//                                         width: 160,
//                                         child: Row(
//                                           crossAxisAlignment: CrossAxisAlignment.center,
//                                           mainAxisAlignment: MainAxisAlignment.center,
//                                           children: [
//                                             IconButton(
//                                                 icon: Icon(Icons.remove, color: Colors.red, size: 40.0),
//                                                 onPressed: () {
//                                                   setState(() {
//                                                     --Item_qty;
//                                                     if (Item_qty < 1) {
//                                                       Item_qty = 1;
//                                                     }
//                                                   });
//                                                 }),
//                                             Text("  " + Item_qty.toString() + " ", style: TextStyle(fontSize: 30.0),),
//                                             IconButton(
//                                                 icon: Icon(Icons.add, color: Colors.green, size: 40.0),
//                                                 onPressed: () {
//                                                   setState(() {
//                                                     ++Item_qty;
//                                                   });
//                                                 }),
//                                           ],
//                                         )
//                                     )
//
//
//                                 ]
//                                 )
//
//                                     ),
//                             ],
//
//                           ),
//                         ),
//
//
//
//                         Visibility(
//                           visible: _Del_Addons.length > 0 && activeAddonItems == true,
//                           child:Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text("  Add On", style: TextStyle(fontSize: 20),),
//                                          SizedBox(
//                                             width: ShowAddon == true
//                                                    ? MediaQuery.of(context).size.width / 2.5 : 450,
//                                           //height: 200,
//                                           height: 300,
//                                           child: ListView.builder(
//                                             shrinkWrap: true,
//                                             itemCount: _Del_Addons.length,
//                                             itemBuilder: (context, index) =>
//                                                 Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 Checkbox(
//                                                   value: selectedIndexes
//                                                       .contains(index),
//                                                   onChanged: (_) {
//                                                     setState(() {
//                                                       Selected_AddonDatas
//                                                           .clear();
//
//                                                       if (selectedIndexes
//                                                           .contains(index)) {
//                                                         selectedIndexes.remove(
//                                                             index); // unselect
//                                                       } else {
//                                                         selectedIndexes.add(
//                                                             index); // select
//                                                         _Del_Addons[index].qty =
//                                                             1;
//                                                       }
//
//                                                       // selectedIndexes.forEach((element) {
//                                                       //
//                                                       //  print(_Del_Addons[element].addonItemName) ;
//                                                       //  Selected_AddonDatas.add(_Del_Addons[element]);
//                                                       // });
//                                                     });
//                                                     print(
//                                                         "Selected_AddonDatas");
//                                                     print(Selected_AddonDatas);
//                                                   },
//                                                 ),
//                                                 Expanded(
//                                                     child: Text(
//                                                         _Del_Addons[index]
//                                                             .addonItemName)),
//                                                 Expanded(
//                                                     child: Text(
//                                                         "$currencyTyp ${_Del_Addons[index].addonRate.toString() == null ? "xx" : _Del_Addons[index].addonRate.toString()}")),
//
//                                                 selectedIndexes.contains(index)
//                                                     ? Add_Qty_Counter(
//                                                         setState, index, 1)
//                                                     : SizedBox(
//                                                         height: 30,
//
//
//                                                       ),
//                                               ],
//                                           //  ),
//                                           ),
//                                         )),
//                                ]
//                           )
//                                //   ]
//                         ),
//                       ],
//                     ),
//
//
//
//                     ///------------------------------Notes--------------------------
//
//                     Container(
//                       width: MediaQuery.of(context).size.width,
//                       height: 240,
//                       child: ListView.builder(
//                         shrinkWrap: true,
//                         //scrollDirection: Axis.horizontal,
//                         scrollDirection: Axis.vertical,
//                         itemCount: BillingNote.length,
//                         itemBuilder: (context, index) => Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Checkbox(
//                               value: SelectedNoteIndex.contains(index),
//                               onChanged: (_) {
//                                 print("BillingNote");
//                                 print(BillingNote);
//                                 print(BillingNote.runtimeType);
//                                 setState(() {
//                                   // Selected_Notes_Data.clear();
//
//                                   if (SelectedNoteIndex.contains(index)) {
//                                     SelectedNoteIndex.remove(index);
//                                   } else {
//                                     SelectedNoteIndex.add(index);
//                                    // Selected_Notes_Data.add(BillingNote[index]);// select
//                                     //  Selected_Notes_Data.add(BillingNote[SelectedNoteIndex]);
//                                   }
//                                 });
//
//                                 print("jjjjjjjjjjjjjjjjjjjjj");
//                                 // print(Selected_Notes_Data);
//                                 // print(Selected_Notes_Data.runtimeType);
//                                 print(SelectedNoteIndex);
//                               },
//                             ),
//                             Text(
//                               BillingNote[index]["notes"].toString() + "   ",
//                               style: TextStyle(fontSize: 17, color: Colors.lightGreen[900]),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//
//
//                     Row(
//                       children: [
//                         // SizedBox(width: MediaQuery.of(context).size.width/2,
//                         //   child: Row(
//                         //     children: [
//                         //       Expanded(
//                         //         child: TypeAheadField(
//                         //             suggestionsBoxVerticalOffset: 50,
//                         //
//                         //             direction:AxisDirection.up,
//                         //             textFieldConfiguration: TextFieldConfiguration(
//                         //                 style: TextStyle(),
//                         //                 controller: ItemNotesController,
//                         //                 decoration: InputDecoration(
//                         //                   errorStyle: TextStyle(color: Colors.red),
//                         //                   // errorText: itemSelect
//                         //                   //     ? "Please Select product Item ?"
//                         //                   //     : null,
//                         //                   suffixIcon: IconButton(
//                         //                     icon: Icon(Icons.remove_circle),
//                         //                     color: Colors.blue,
//                         //                     onPressed: () {
//                         //                       setState(() {
//                         //                         print("cleared");
//                         //                         ItemNotesController.text = "";
//                         //                         ItemNotes_Id = null;
//                         //
//                         //                       });
//                         //                     },
//                         //                   ),
//                         //
//                         //
//                         //
//                         //                   isDense: true,
//                         //                   contentPadding:
//                         //                   EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//                         //                   border: OutlineInputBorder(
//                         //                       borderRadius: BorderRadius.circular(10)),
//                         //                   // i need very low size height
//                         //                   labelText:
//                         //                   'Item Notes', // i need to decrease height
//                         //                 )),
//                         //             suggestionsBoxDecoration:
//                         //             SuggestionsBoxDecoration(elevation: 90.0),
//                         //             suggestionsCallback: (pattern) {
//                         //               return BillingNote.where((user) =>
//                         //                   user["notes"].toString().trim().toLowerCase().contains(pattern.trim().toLowerCase()));
//                         //             },
//                         //             itemBuilder: (context, suggestion) {
//                         //               return Card(elevation: 0,
//                         //                 color: Colors.blue,
//                         //                 // shadowColor: Colors.blue,
//                         //                 child: ListTile(
//                         //                   tileColor: theam.DropDownClr,
//                         //                   title: Text(
//                         //                     suggestion["notes"],
//                         //                     style: TextStyle(color: Colors.white),
//                         //                   ),
//                         //                 ),
//                         //               );
//                         //             },
//                         //             onSuggestionSelected: (suggestion) {
//                         //               print(suggestion["notes"]);
//                         //               print("selected");
//                         //               ItemNotesController.text=suggestion["notes"];
//                         //               //  print(salesItemId);
//                         //               print("...........");
//                         //
//                         //             },
//                         //             errorBuilder: (BuildContext context, Object error) =>
//                         //                 Text('$error',
//                         //                     style: TextStyle(
//                         //                         color: Theme.of(context).errorColor)),
//                         //             transitionBuilder:
//                         //                 (context, suggestionsBox, animationController) =>
//                         //                 FadeTransition(
//                         //                   child: suggestionsBox,
//                         //                   opacity: CurvedAnimation(
//                         //                       parent: animationController,
//                         //                       curve: Curves.elasticIn),
//                         //                 )),
//                         //       ),
//                         //
//                         //
//                         //
//                         //     ],
//                         //   ),
//                         // ),
//
//                         // SizedBox(
//                         //   width: 10,
//                         // ),
//
//                         ElevatedButton(
//                             style: ButtonStyle(
//                                 backgroundColor: MaterialStateProperty.all(
//                                     Colors.green.shade800)),
//                             child: Text(
//                               "Add",
//                               style:
//                                   TextStyle(color: Colors.white, fontSize: 20),
//                             ),
//                             onPressed: () {
//                               if (SelectedUOM == null) {
//                                 showDialog(
//                                     context: context,
//                                     builder: (context) {
//                                       return StatefulBuilder(
//                                           builder: (context, setState) {
//                                         return AlertDialog(actions: [
//                                           Container(
//                                             height: 30,
//                                             width: 300,
//                                             child: Center(
//                                                 child: Text(
//                                               "UOM is Undefined..!",
//                                               style: TextStyle(
//                                                   color: Colors.red,
//                                                   fontSize: 20),
//                                             )),
//                                           )
//                                         ]);
//                                       });
//                                     });
//                                 return;
//                               } else {
//                                 setState(() {
//                                   print(activeAddonItems.toString());
//                                   AddToCart = true;
//                                   print("oipio");
//                                   Navigator.of(context).pop();
//                                 });
//                               }
//                             }),
//                         SizedBox(
//                           width: 10,
//                         ),
//                         ElevatedButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             style: ButtonStyle(
//                                 backgroundColor: MaterialStateProperty.all(
//                                     Colors.red.shade400)),
//                             child: Text(
//                               "Cancel",
//                               style:
//                                   TextStyle(color: Colors.white, fontSize: 20),
//                             ))
//                       ],
//                     )
//                   ],
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Add_Qty_Counter(StateSetter setState, int index, qty) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 30),
//       child: Container(
//           color: Colors.amber.shade600,
//           // decoration: BoxDecoration(
//           //     color: Colors.teal, borderRadius: BorderRadius.circular(30)),
//           width: 100,
//           height: 30,
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               InkWell(
//                   onTap: () {
//                     setState(() {
//                       if (selectedIndexes.contains(index)) {
//                         var s = _Del_Addons[index].qty;
//
//                         _Del_Addons[index].qty = --s;
//
//                         print("qty");
//                         print(_Del_Addons[index].qty.toString());
//                         --qty;
//                         if (_Del_Addons[index].qty < 1) {
//                           _Del_Addons[index].qty = 1;
//                         } // unselect
//                       }
//                     });
//                   },
//                   child: Icon(
//                     Icons.remove,
//                     color: Colors.black,
//                   )),
//               Text(
//                 _Del_Addons[index].qty.toString(),
//                 style: TextStyle(color: Colors.black),
//               ),
//               InkWell(
//                 child: Icon(Icons.add, color: Colors.black),
//                 onTap: () {
//                   if (selectedIndexes.contains(index)) {
//                     setState(() {
//                       var s = _Del_Addons[index].qty;
//
//                       _Del_Addons[index].qty = s == null ? 0 : ++s;
//                     });
//                   }
//                 },
//               ),
//             ],
//           )),
//     );
//   }
//
//   Widget UomButtons(setState, index, Uom, UomName, rate, currencytyp) {
//     return Padding(
//       padding: const EdgeInsets.all(5.0),
//       child: InkWell(
//         onTap: () {
//           print("Selected UOM");
//           print(Uom);
//           // var s= List<dynamic>.filled(1, Uom);
//           SelectedUOM = Uom;
//           print(SelectedUOM);
//           print(SelectedUOM.runtimeType);
//           setState(() {
//             tappedIndex = index;
//           });
//         },
//         child: Container(
//           decoration: BoxDecoration(
//               border: Border.all(color: Colors.green),
//               color: tappedIndex == index ? Colors.green[100] : Colors.white,
//               borderRadius: BorderRadius.circular(20)),
//           width: 120,
//           height: 50,
//           child: Center(
//               child: RichText(
//             text: TextSpan(
//               children: <TextSpan>[
//                 TextSpan(
//                     text: " " + UomName,
//                     style: TextStyle(fontSize: 17, color: Colors.black)),
//                 TextSpan(text: "   $currencytyp",
//                     style: TextStyle(color:Colors.black)),
//                 TextSpan(
//                     text: '  ${rate.toString()}',
//                     style:
//                         TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color:Colors.black)),
//               ],
//             ),
//           )),
//         ),
//       ),
//     );
//   }
// }
