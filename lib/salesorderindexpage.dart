import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_qizo_gt/printing.dart';
import 'package:new_qizo_gt/sales.dart';
import 'package:new_qizo_gt/salesorder.dart';
import 'package:new_qizo_gt/urlEnvironment/urlEnvironment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'GT_Masters/AppTheam.dart';
import 'appbarWidget.dart';
import 'models/userdata.dart';
import 'newtestpage.dart';

class SalesOrderIndexPageView extends StatefulWidget {

  dynamic passvalue;

  SalesOrderIndexPageView({this.passvalue});

  @override
  _SalesOrderIndexPageViewState createState() =>
      _SalesOrderIndexPageViewState();
}

class _SalesOrderIndexPageViewState extends State<SalesOrderIndexPageView> {
  dynamic branchName;
  dynamic userName;
  dynamic data;
  dynamic customerName;
  dynamic branch;
  dynamic user;
  dynamic nowTime;
  bool showProgress = true;
  List<dynamic> t = [];
  List<dynamic> pndSlsOrd = [];
  List<dynamic> cptSlsOrd = [];
 // var formatter = NumberFormat('#,##,000.00');
  var formatter = NumberFormat('#,##,##,##,##0.00');
  dynamic customer = "";
  dynamic datas;
  dynamic ShpName="";
  dynamic TtlAmd=0.00;
  dynamic cptTtlAmd=0.00;
  SharedPreferences? pref;
  dynamic prog;
  bool? visibilityTableRow;

  AppTheam theam = AppTheam();

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      SharedPreferences.getInstance().then((value) {

        pref = value;
        read();

        setState(() {

          // getIndexReceiptCollection();
          // getCustomer(72);

          var date = DateTime.now();
          // var formatter =
          // new DateFormat('MM-dd-yyyy'); // this dd-MM-yyyy format i want

          // String formattedDate = formatter
          //     .format(DateTime.parse(date.toString()));
          DateTime now = DateTime.now();
          // String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
          nowTime = DateFormat('kk:mm:ss').format(now);

          print(widget.passvalue.toString());
          print(nowTime);
       datas =widget.passvalue;
          print("eeeeee");
          print(datas.toString());
          print("eeeeee");
         // print("eeeeee"+datas['ledgerId'].toString());
          if(datas['ledgerId']==null || datas['ledgerId']==0)
          {
            // print("visibilityTableRowtrue"+datas['ledgerId'].toString());
            visibilityTableRow=true;
            Getdata(0);
          }
          else
          {
            print("visibilityTableRowfalse"+datas['ledgerId'].toString());
            Getdata(datas['ledgerId']);
            visibilityTableRow=false;
          }
        });
        // print("data is : "+widget.passvalue["dateFrom"].toString());
        // var c = json.decode(widget.passvalue);

      });
    });

    super.initState();

    // quantityController.addListener(qtyListener);
  }
  flutter_printer customPrintMange=flutter_printer();
  //get token
  read() async {
//    SharedPreferences pref = await SharedPreferences.getInstance();
    var v = pref?.getString("userData");
    print("USER DATA: $v");
    var c = json.decode(v!);
    user = UserData.fromJson(
        c); // token gets this code user.user["token"] okk??? user res

    setState(() {
      print("user data................");
      print(user.user["token"]);
      pref?.setString("customerToken", user.user["token"]);
      branchName = user.branchName;
      userName = user.user["userName"];
      print(".....");
      print(branchName);
      print(userName);
      // prog.hide();
    });
//    getCustomer();
//    showDialog(
//        context: context,
//        builder: (context) => AlertDialog(
//              title: Text("data:   " + user.branchName),
//              content: Text("user data:   " + user.user["token"]),
//            ));
  }

  removeListElement(int id) {
    // print(sl);
    t.removeWhere((element) => element['id'] == id);
    // customerItemAdd.removeWhere((element) => element.id == id);
    // grandTotal = grandTotal - amount;

    print("deleted");
//   customerItemAdd.indexOf(sl);

//    print('item:$name  rate: $price');
  }

  getItemIndex(dynamic item) {
    var index = t.indexOf(item);
    return index + 1;
  }

// get customer account

  Future<String> getCustomer(dynamic id) async {
    try {
      final response = await http
          .get(Uri.parse("${Env.baseUrl}MLedgerHeads/${id.toString()}"), headers: {
        "Authorization": user.user["token"],
      });

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        var v = json.decode(response.body);
        customerName = "";
        customerName = v['ledgerHeads'][0]['lhName'];
        print("......");
        print(v['ledgerHeads'][0]['lhName']);
        return customerName;
      } else {
        print("Error getting users");
        return "Error getting users";
      }
    } catch (e) {
      print("Exception: $e");
      return "Error occurred";
    }
  }



  getTime(dynamic date) {
    // var formatter =
    // new DateFormat('HH:mm');
    var dateFormate = DateFormat("dd-MM-yyyy").format(DateTime.parse(date));

    // String formattedDates = formatter
    //     .format(DateTime.parse(date));
    var formattedTime = DateFormat.jm().format(DateTime.parse(date));
    //
    // print(formattedTime);
    var formattedDates = DateFormat('MMM dd , yyyy').format(
        DateTime.parse(date));
    // print(formattedDate);
    return "${formattedDates.toString()}" + " - " + formattedTime;
  }

  // get indexDocument
  getIndexReceiptCollection() async {
    // TDocumentHandlingdetails/1/1
    var res = await http.get("${Env.baseUrl}TsalesOrderHeaders" as Uri,
        headers: {'Authorization': user.user['token']});
    print(".....api data..w....");
    print(res.body);
    setState(() {
      var dt = json.decode(res.body);
      print(".....api data..1....");
      print(dt);
      t = dt['soHeader'] as List;
      t.forEach(print);
      print(t);
      print(res.statusCode);
      showProgress= true;
    });
  }

  // move to element list
  moveListElement(int id) {
    print(id);
  }


  Getdata(dynamic id ) async{

    print("GetdataWithid");
    String valiurl;
    print("GetdataWithid : $id");
    if(id==0){
      valiurl= "Soheader";
    }else{
      valiurl = "Soheader/$id/1";
    }

    String url = "${Env.baseUrl}$valiurl";
    try {
      final res =
      await http.get(url as Uri, headers: {"Authorization": user.user["token"]});

      print("Sales order Data");
       print(url.toString());

      print("json decoded");
      var tagsJson = json.decode(res.body);
      print(tagsJson);

      setState(() {

        t = tagsJson["list"] as List;
        t.forEach(print);
        print("tt= $t");
        //print(Getdatas["ledgerName"]);
        showProgress= false;
        // SlsOrder = Getdatas;

        if(id== 0||id==null)
        {ShpName=""; }
        else
        {
          ShpName = t[0]['ledgerName'].toString();
        }

      });



      // for(int i=0;i<t.length;i++){
      //           pndSlsOrd = t.where((i) => i["SalesHid"]==0).toList();
      //           // print("tttt$pndSlsOrd".toString());
      //           // print(res.statusCode);
      //           showProgress= false;
      //           // for(int j=0;j<pndSlsOrd.length;i++){
      //           //   TtlAmd=TtlAmd +pndSlsOrd[j]['Order Value'];
      //           // }




      // List<dynamic> t = json.decode(res.body);
      // List<PaymentCondition> p =
      // t.map((t) => PaymentCondition.fromJson(t)).toList();
    } catch (e) {print("error $e");}


  }




  // Getdata(dynamic id ) async{
  //
  //
  //   dynamic dtfrm=datas['dtFrom'].toString();
  //   dynamic dtto=datas['dtTo'].toString();
  //
  //   var req = {
  //     "dateFrom": dtfrm,
  //     "dateTo": dtto,
  //     "ledgerId":id
  //   };
  //   var params = json.encode(req);
  //   print(params);
  //   print("${Env.baseUrl}RptSalesOrder/1");
  //   var res = await http.post("${Env.baseUrl}RptSalesOrder/1",
  //       headers: {
  //         'accept': 'application/json',
  //         'content-type': 'application/json',
  //         'Authorization': user.user['token'],
  //         'deviceId': user.deviceId
  //       },
  //       body: params);
  //   print(res.statusCode);
  //   print(res.body);
  //   var jsndt = json.decode(res.body);
  //   print("ddd$jsndt");
  //   setState(() {
  //     if (res.statusCode == 200 || res.statusCode == 201) {
  //       print("true$jsndt");
  //
  //
  //
  //       setState(() {
  //         // var jsndt = json.decode(res.body);
  //         print(".....api data......");
  //         //  print(jsndt);
  //         t = jsndt['details']['data'] as List;
  //         //
  //         //
  //         //
  //         for(int i=0;i<t.length;i++){
  //           pndSlsOrd = t.where((i) => i["SalesHid"]==0).toList();
  //           // print("tttt$pndSlsOrd".toString());
  //           // print(res.statusCode);
  //           showProgress= false;
  //           // for(int j=0;j<pndSlsOrd.length;i++){
  //           //   TtlAmd=TtlAmd +pndSlsOrd[j]['Order Value'];
  //           // }
  //
  //
  //
  //           cptSlsOrd = t.where((i) => i["SalesHid"]>0).toList();
  //           // print("tttt$cptSlsOrd".toString());
  //           //  print(res.statusCode);
  //           showProgress= false;
  //           // for(int k=0;k<cptSlsOrd.length;i++) {
  //           //   cptTtlAmd = cptTtlAmd + cptSlsOrd[k]['Order Value'];
  //           //  }
  //
  //         }
  //
  //
  //
  //         // t.forEach(print);
  //         // print("tttt$t");
  //         // print(res.statusCode);
  //         // showProgress= false;
  //
  //
  //
  //         if(id== 0||id==null)
  //         {ShpName=""; }
  //         else
  //         {
  //           ShpName = t[0]['Shop Name'].toString();
  //         }
  //
  //
  //         for(int k=0;k<cptSlsOrd.length;k++) {
  //           cptTtlAmd = cptTtlAmd + cptSlsOrd[k]['Order Value'];
  //         }
  //
  //         for(int j=0;j<pndSlsOrd.length;j++){
  //           TtlAmd=TtlAmd +pndSlsOrd[j]['Order Value'];
  //         }
  //
  //
  //
  //       });
  //
  //
  //
  //     }
  //   });
  //
  // }



//---------------------------------All function End-------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(190.0),
              child:  Appbarcustomwidget(uname: userName, branch: branchName, pref: pref, title: "Sales Order Index")
            ),
            body: ListView(
              children: [
                SizedBox(
                  height: 5,
                ),

                Stack(
                    children:[
                      Visibility(visible:  t.length > 0 ,
                        child: Container(child: Padding(
                            padding: const EdgeInsets.only(left:35,top: 10),
                            child: Text(ShpName,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.indigo,fontSize: 17,),) ),)),


                      // Container(
                      //   child: Align(
                      //     alignment:Alignment.centerRight,
                      //     child: GestureDetector(
                      //       onTap: () {
                      //         // Navigator.pop(context);
                      //         Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //
                      //                 builder: (context) => SalesOrder(passvalue:datas['ledgerId'],passname: datas['ledgerId']==null ? "" : t[0]["ledgerName"])));
                      //       },
                      //       child: Padding(
                      //         padding: const EdgeInsets.only(right: 10),
                      //         child: Container(
                      //             decoration: BoxDecoration(
                      //               borderRadius: BorderRadius.circular(60),
                      //               color: Colors.blueAccent,
                      //             ),
                      //             width: 35,
                      //             height: 35,
                      //             child: Center(
                      //                 child: Icon(
                      //                   Icons.add,
                      //                   color: Colors.white,
                      //                 ))),
                      //       ),
                      //     ),
                      //   ),
                      // ),




                      Visibility(
                        visible:  pndSlsOrd.length > 0 ,
                        child: Align(alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10,right: 15),
                              child: Text("Rs. "+formatter.format(TtlAmd).toString(),),
                            )),
                      ),
                    ]
                ),
                showProgress ?
                Container(
                  height: 500,
                  width: 350,
                  child: Center(
                      child:Text("No Sales Orders")
                    //   CircularProgressIndicator(),
                  ),
                ):Container(
                  child: t.length > 0 ?
                  Row(
//            verticalDirection: VerticalDirection.down,
//            crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DataTable(
                                columnSpacing: 17,
                                onSelectAll: (b) {},
                                headingRowColor: theam.TableHeadRowClr,
                                sortAscending: true,
                                  columns: <DataColumn>[
                                    DataColumn(
                                      label: Text('V.No',style: theam.TableFont),
                                    ),
                                    (visibilityTableRow ?? false) ?
                                    DataColumn(
                                      label: Text('Shop Name',style: theam.TableFont,),
                                    ) :
                                    DataColumn(
                                      label: Text(''),
                                    ),
                                    DataColumn(
                                      label: Text('Date',style: theam.TableFont),
                                    ),
                                    DataColumn(
                                      label: Text(' '),
                                    ),
                                  ],

                                  rows: t
                                    .map(
                                      (itemRow) => DataRow(
                                    cells: [
                                      DataCell(
                                        Text(
                                          //  getItemIndex(itemRow).toString()),
                                            '${itemRow['voucherNo'].toString()}'),
                                        showEditIcon: false,
                                        placeholder: false,
                                      ),
                                      visibilityTableRow == true
                                          ? DataCell(
                                        GestureDetector(
                                          onTap: () {},
                                          child: Text('${itemRow['ledgerName'] ?? "---"}'),
                                        ),
                                        showEditIcon: false,
                                        placeholder: false,
                                      )
                                          :DataCell(
                                        GestureDetector(
                                          onTap: () {},
                                          child: Text(
                                              ""),
                                        ),
                                        showEditIcon: false,
                                        placeholder: false,
                                      ),
                                      // :
                                      //  DataCell(
                                      //    GestureDetector(
                                      //      onTap: () {},
                                      //      child: Text('Shop Name'),
                                      //    ),
                                      //    showEditIcon: false,
                                      //    placeholder: false,
                                      //  ),
                                      DataCell(
                                        GestureDetector(
                                          onTap: () {},
                                          child: Text(
                                              '${ DateFormat("dd-MM-yyyy").format(DateTime.parse(itemRow['voucherDate']))}'),
                                        ),
                                        showEditIcon: false,
                                        placeholder: false,
                                      ),




                                      DataCell(
                                        TextButton(

                                          child: Icon(Icons.menu),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (_) => AlertDialog(
                                                content: Container(
                                                  child: Row(
                                                    children: [

                                                  IconButton(icon:Icon(Icons.repeat,color: Colors.black,),
                                                  onPressed: () {
                                                    setState(() {
                                                      Navigator.of(context,rootNavigator: true).pop();
                                                    });
                                                    //print(itemRow.toString());
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Newsalespage(
                                                                  passvalue:itemRow['ledgerId']==null?null:itemRow['ledgerId'].toInt(),
                                                                  passname: itemRow['ledgerName'].toString()
                                                                  ,itemrowdata:itemRow)),);

                                                                }),

                                                     Spacer(),

                                                      IconButton(icon:Icon(Icons.print,color: Colors.black,),
                                                        onPressed: (){
                                                          setState(() {
                                                            Navigator.of(context,rootNavigator: true).pop();
                                                          });
                                                      //  print(itemRow.toString());
                                                       customPrintMange.initialFunction(itemRow['id'].toInt());
                                                        },),

                                                      Spacer(),

                                                      IconButton(icon:Icon(Icons.edit,color: Colors.black,),
                                                        onPressed: (){
                                                          setState(() {
                                                            Navigator.of(context,rootNavigator: true).pop();
                                                          });
                                                        //print(itemRow.toString());
                                                          Navigator.push(context,
                                                              MaterialPageRoute(builder: (context)=>
                                                              SalesOrder(passvalue:itemRow['ledgerId']==null?null:itemRow['ledgerId'].toInt(),
                                                                passname:itemRow['ledgerName'].toString(),
                                                                EditData:itemRow,)
                                                          ));



                                                        },),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                    .toList(),
                              ),
                            ),
                          )),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ): Container(
                    height: 400,
                    child: Center(
                        child: Text("No Order Found")),
                  ),
                ),

                SizedBox(height: 30),
//----------------------For Completed Sales order---------------------------------------------------------------------------------

//--------------------------------End--------------------------------------------------------------------
              ],
            )));
  }
}
