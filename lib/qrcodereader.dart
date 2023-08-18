import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QrCodeReader extends StatefulWidget {
  @override
  _QrCodeReaderState createState() => _QrCodeReaderState();
}

class _QrCodeReaderState extends State<QrCodeReader> {
  dynamic results = "Not Yet Selected Scan!";
  ScanResult scanResult;
  dynamic codeFormat = "";

  Future _scanQR() async {
    results = "Not Yet Selected Scan!";
    try {
      dynamic qrResult = await BarcodeScanner.scan();
      setState(() {
        scanResult = qrResult;
      });
      var result = await BarcodeScanner.scan();
      setState(() {
        scanResult = result;
        print("..Scanned..");
        if (scanResult.rawContent != "") {
          print(scanResult.rawContent);
          print(
              scanResult.type); // The result type (barcode, cancelled, failed)
          print(scanResult.format); // The barcode format (as enum)
          print(scanResult.formatNote);
          setState(() {
            if (scanResult.format.toString() == "qr") {
              print("qr code");
              codeFormat = "QR Code";
            } else {
              print("Barcode");
              codeFormat = "BarCode";
            }
          });

          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("${codeFormat.toString()} Selected"),
                    content: Text("Code : ${scanResult.rawContent}"),
                  ));
          results = "Content : " +
              scanResult.rawContent +
              " , Format : ${scanResult.format}";
//              + " , Type : ${scanResult.type}";
        } else {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("Code Selection Cancelled"),
                  ));
          results = "Code Selection Cancelled";
        }
      });
    } on PlatformException catch (e) {
      var result = ScanResult(
        type: ResultType.Error,
        format: BarcodeFormat.unknown,
      );

      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          result.rawContent = 'The user did not grant the camera permission!';
        });
      } else {
        result.rawContent = 'Unknown error: $e';
      }
      setState(() {
        scanResult = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text("QR / BarCode Scanner"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(results),
            SizedBox(
              height: 30,
            ),
            FloatingActionButton.extended(
              backgroundColor: Colors.lightBlue,
              icon: Icon(Icons.camera_alt),
              label: Text(
                "QR / Barcode Scanner",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: _scanQR,
            ),
          ],
        ),
      ),
    );
  }
}
