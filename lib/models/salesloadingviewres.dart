class SalesOrderLoadingViewRes {
  dynamic d;
  List<String> qr = [];
  dynamic sdItemId;
  dynamic sdQty;
  dynamic sdRate;
  dynamic sOHFromLedgerId;
  dynamic itemName;
  dynamic itmHSN;
  dynamic itmIsTaxAplicable;
  dynamic itmTaxInclusive;
  dynamic taxId;
  dynamic taxDescription;
  dynamic taxType;
  dynamic taxPercentage;
  dynamic taxAccHeadId;
  dynamic cgstPercentage;
  dynamic sgstPercentage;
  dynamic igstPercentage;
  dynamic igstTaxAccId;
  dynamic cgstTaxAccId;
  dynamic sgstTaxAccId;
  dynamic salesAccId;
  dynamic igstSalesAccId;
  dynamic sgstSalesAccId;
  dynamic cgstSalesAccId;
  dynamic additionalTaxDescription;
  dynamic additionalTaxPercentage;
  dynamic additionalTaxAplicableOn;

  SalesOrderLoadingViewRes(
      {this.d,
      this.sdItemId,
      this.sdQty,
      this.sdRate,
      this.sOHFromLedgerId,
      this.itemName,
      this.itmHSN,
      this.itmIsTaxAplicable,
      this.itmTaxInclusive,
      this.taxId,
      this.taxDescription,
      this.taxType,
      this.taxPercentage,
      this.taxAccHeadId,
      this.cgstPercentage,
      this.sgstPercentage,
      this.igstPercentage,
      this.igstTaxAccId,
      this.cgstTaxAccId,
      this.sgstTaxAccId,
      this.salesAccId,
      this.igstSalesAccId,
      this.sgstSalesAccId,
      this.cgstSalesAccId,
      this.additionalTaxDescription,
      this.additionalTaxPercentage,
      this.additionalTaxAplicableOn});

  factory SalesOrderLoadingViewRes.fromJson(Map<String, dynamic> parsedJson) {
    return SalesOrderLoadingViewRes(
      d: parsedJson["d"],
      sdItemId: parsedJson["sdItemId"],
      sdQty: parsedJson["sdQty"],
      sdRate: parsedJson["sdRate"],
      sOHFromLedgerId: parsedJson["sOHFromLedgerId"],
      itemName: parsedJson["itemName"],
      itmHSN: parsedJson["itmHSN"],
      itmIsTaxAplicable: parsedJson["itmIsTaxAplicable"],
      itmTaxInclusive: parsedJson["itmTaxInclusive"],
      taxId: parsedJson["igstTaxAccId"],
      taxDescription: parsedJson["taxDescription"],
      taxType: parsedJson["taxType"],
      taxPercentage: parsedJson["taxPercentage"],
      taxAccHeadId: parsedJson["taxAccHeadId"],
      cgstPercentage: parsedJson["cgstPercentage"],
      sgstPercentage: parsedJson["sgstPercentage"],
      igstPercentage: parsedJson["igstPercentage"],
      igstTaxAccId: parsedJson["igstTaxAccId"],
      cgstTaxAccId: parsedJson["cgstTaxAccId"],
      sgstTaxAccId: parsedJson["sgstTaxAccId"],
      salesAccId: parsedJson["salesAccId"],
      igstSalesAccId: parsedJson["igstSalesAccId"],
      sgstSalesAccId: parsedJson["sgstSalesAccId"],
      cgstSalesAccId: parsedJson["cgstSalesAccId"],
      additionalTaxDescription: parsedJson["additionalTaxDescription"],
      additionalTaxPercentage: parsedJson["additionalTaxPercentage"],
      additionalTaxAplicableOn: parsedJson["additionalTaxAplicableOn"],
    );
  }
}














































// SingleChildScrollView(
// // scrollDirection: Axis.vertical,
// child: SizedBox(
// height: double.maxFinite,
// child: OrientationBuilder(
// builder: (context, orientation) {
// count = 2;
// if (orientation == Orientation.landscape) {
// count = 3;
// }
//
// return Padding(
// padding: const EdgeInsets.symmetric(horizontal: 8.0),
// child: Column(
// mainAxisSize: MainAxisSize.max,
// crossAxisAlignment: CrossAxisAlignment.stretch,
// children: [
// Padding(
// padding: const EdgeInsets.symmetric(vertical: 8.0),
// child: SizedBox(
// height: (MediaQuery.of(context).size.width / 3.5) -
// 16.0,
// child: RaisedButton(
// color: Colors.lightBlue,
// padding:
// const EdgeInsets.symmetric(horizontal: 20.0),
// onPressed: () {
// setState(() {
// _getLocation();
// });
// },
// // same size to all buttons with left and right and top and bottom same space
// child: Text("Mark Attendance",
// style: TextStyle(
// fontSize: 15.0, color: Colors.white)),
// ),
// ),
// ),
// // Padding(
// //   padding: const EdgeInsets.symmetric(vertical: 8.0),
// //   child: SizedBox(
// //     height:
// //     (MediaQuery.of(context).size.width / 3.5) - 16.0,
// //     child:Row(
// //       children: [
// //         Expanded(child:  RaisedButton(
// //           color: Colors.lightBlue,
// //           padding:
// //           const EdgeInsets.symmetric(horizontal: 20.0),
// //           onPressed: () {
// //             setState(() {
// //               _getLocation();
// //             });
// //           },
// //           // same size to all buttons with left and right and top and bottom same space
// //           child: Text("Ma",
// //               style: TextStyle(
// //                   fontSize: 15.0, color: Colors.white)),
// //         ),),
// //         Expanded(
// //           child: RaisedButton(
// //             color: Colors.lightBlue,
// //             padding:
// //             const EdgeInsets.symmetric(horizontal: 20.0),
// //             onPressed: () {
// //               setState(() {
// //                 _getLocation();
// //               });
// //             },
// //             // same size to all buttons with left and right and top and bottom same space
// //             child: Text("Attendance",
// //                 style: TextStyle(
// //                     fontSize: 15.0, color: Colors.white)),
// //           ),
// //         )
// //       ],
// //     ),
// //   ),
// // ),
// GridView.builder(
// itemCount: options.length,
// shrinkWrap: true,
// gridDelegate:
// SliverGridDelegateWithFixedCrossAxisCount(
// crossAxisCount: 2,
// crossAxisSpacing: 8.0,
// mainAxisSpacing: 8.0,
// childAspectRatio: 2,
// ),
// itemBuilder: (c, i) {
// return RaisedButton(
// color: Colors.lightBlue,
// padding: const EdgeInsets.symmetric(
// horizontal: 20.0),
// onPressed: () {
// print("index :  $i");
// setState(() {
// if (i == 4) {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) =>
// ExpenseSheetSalesMan()),
// );
// }
// if (i == 0) {
// //                              Product Catalog
// directURL();
// }
// if (i == 1) {
// //sales order
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => SalesOrder()),
// );
// }
// if (i == 2) {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) =>
// CustomerLedgerBalance()),
// );
// }
// if (i == 3) {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) =>
// ReceiptCollections()),
// );
// }
// if (i == 5) {
// //                                  Navigator.push(
// //                                    context,
// //                                    MaterialPageRoute(
// //                                        builder: (context) => SalesManMessages()),
// //                                  );
// }
// if (i == 5) {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) =>
// QrCodeReader()),
// );
// }
// if (i == 6) {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) =>
// SalesLoading()),
// );
// }
// if (i == 7) {
// setLocationPermission();
// }
// if (i == 8) {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => TestScreen()),
// );
// }
// });
// },
// child: Text(
// options[i],
// style: TextStyle(
// fontSize: 15.0, color: Colors.white),
// ),
// );
// },
// ),
// ],
// ),
// );
// },
// ),
// ),
// ),
